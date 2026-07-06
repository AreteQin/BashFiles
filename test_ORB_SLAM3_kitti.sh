#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
# Exit on any unexpected errors
set -e

# ==============================================================================
# 1. USER CONFIGURATION
# ==============================================================================
ORB_SLAM3_DIR="/home/qin/ORB_SLAM3_OpenCV4"          # Path to compiled ORB-SLAM3 root
KITTI_DIR="/home/qin//Downloads/data_odometry_gray/dataset"        # Directory containing "sequences/"
POSES_DIR="/home/qin/Downloads/data_odometry_poses/dataset/poses"  # Directory containing ground truth 00.txt to 10.txt
OUTPUT_DIR="/home/qin/orb_slam3_evaluation"       # Destination for trajectories and plots

# Run mode choice: "mono" or "stereo"
MODE="mono"

# ==============================================================================
# 2. SANITY CHECKS
# ==============================================================================
mkdir -p "$OUTPUT_DIR"

if [ ! -d "$ORB_SLAM3_DIR" ] || [ ! -d "$KITTI_DIR" ] || [ ! -d "$POSES_DIR" ]; then
    echo "Error: One or more configuration paths do not exist. Please check your script paths."
    exit 1
fi

# Ensure vocabulary is unpacked
if [ ! -f "$ORB_SLAM3_DIR/Vocabulary/ORBvoc.txt" ]; then
    echo "Unpacking vocabulary..."
    cd "$ORB_SLAM3_DIR/Vocabulary" && tar -xf ORBvoc.txt.tar.gz
fi

# ==============================================================================
# 3. BENCHMARK LOOP (00 to 10)
# ==============================================================================
cd "$ORB_SLAM3_DIR"

for i in {00..10}; do
    echo "=================================================================="
    echo " Processing KITTI Sequence: ${i} | Mode: ${MODE}"
    echo "=================================================================="
    
    # Dynamically select the correct calibration file
    if [ "$i" = "00" ] || [ "$i" = "01" ] || [ "$i" = "02" ]; then
        YAML_FILE="KITTI00-02.yaml"
    elif [ "$i" = "03" ]; then
        YAML_FILE="KITTI03.yaml"
    else
        YAML_FILE="KITTI04-12.yaml"
    fi

    # Set up executable target parameters
    if [ "$MODE" = "stereo" ]; then
        EXEC="./Examples/Stereo/stereo_kitti"
        YAML_PATH="Examples/Stereo/${YAML_FILE}"
    else
        EXEC="./Examples/Monocular/mono_kitti"
        YAML_PATH="Examples/Monocular/${YAML_FILE}"
    fi

    # Run the SLAM system
    # Note: adding a timeout or running normally. 
    $EXEC Vocabulary/ORBvoc.txt "$YAML_PATH" "$KITTI_DIR/sequences/${i}"

    #    ==============================================================================
    # 4. TARGET THE CORRECT NATIVE KITTI ODOMETRY FORMAT
    # ==============================================================================
    if [ "$MODE" = "stereo" ]; then
        TRAJ_FILE="f_stereo_kitti.txt"
    else
        TRAJ_FILE="f_mono_kitti.txt"
    fi

    if [ ! -f "$TRAJ_FILE" ]; then
        echo "Error: Expected KITTI output matrix $TRAJ_FILE not found."
        echo "Tracking may have failed completely or aborted early."
        continue
    fi

    # Move and systematically isolate the tracking results
    ESTIMATED_TRAJ="$OUTPUT_DIR/seq_${i}_estimated.txt"
    mv "$TRAJ_FILE" "$ESTIMATED_TRAJ"
    
    # Clean up residual TUM files so they don't clutter the directory next iteration
    rm -f CameraTrajectory.txt KeyFrameTrajectory.txt
    
    echo "Trajectory saved to: $ESTIMATED_TRAJ"

    if [ -z "$TRAJ_FILE" ]; then
        echo "Warning: No trajectory output discovered for sequence ${i}. Tracking may have failed."
        continue
    fi

    # Move and systematically isolate the tracking results
    ESTIMATED_TRAJ="$OUTPUT_DIR/seq_${i}_estimated.txt"
    mv "$TRAJ_FILE" "$ESTIMATED_TRAJ"
    echo "Trajectory saved to: $ESTIMATED_TRAJ"

    # ==============================================================================
    # 4. TRACK AND ISOLATE TRAJECTORY FILES BY ACTIVE MODE
    # ==============================================================================
    if [ "$MODE" = "stereo" ]; then
        TRAJ_FILE="f_stereo_kitti.txt"
        if [ ! -f "$TRAJ_FILE" ]; then
            echo "Error: Expected KITTI stereo matrix $TRAJ_FILE not found."
            continue
        fi
        ESTIMATED_TRAJ="$OUTPUT_DIR/seq_${i}_estimated.txt"
        mv "$TRAJ_FILE" "$ESTIMATED_TRAJ"
        
        GT_POSE="$POSES_DIR/${i}.txt"
        if [ -f "$GT_POSE" ]; then
            echo "Evaluating Stereo trajectory using native KITTI alignment..."
            evo_ape kitti "$GT_POSE" "$ESTIMATED_TRAJ" \
                -r full \
                -va \
                --plot_mode xy \
                --save_plot "$OUTPUT_DIR/seq_${i}_error_plot.png" \
                --save_results "$OUTPUT_DIR/seq_${i}_results.zip"
        fi
        
    else
        # Monocular mode outputs KeyFrameTrajectory.txt (TUM format)
        TRAJ_FILE="KeyFrameTrajectory.txt"
        if [ ! -f "$TRAJ_FILE" ]; then
            echo "Error: Expected TUM format trajectory $TRAJ_FILE not found."
            continue
        fi
        ESTIMATED_TRAJ="$OUTPUT_DIR/seq_${i}_estimated.txt"
        mv "$TRAJ_FILE" "$ESTIMATED_TRAJ"
        
        GT_POSE="$POSES_DIR/${i}.txt"
        TIMES_FILE="$KITTI_DIR/sequences/${i}/times.txt"
        
        if [ -f "$GT_POSE" ] && [ -f "$TIMES_FILE" ]; then
            echo "Evaluating Monocular trajectory (Aligning timestamps & resolving scale)..."
            
            # 1. Temporarily map the KITTI ground truth to TUM format using sequence timestamps
            evo_traj kitti "$GT_POSE" --timestamps_file "$TIMES_FILE" --save_as_tum
            
            # evo outputs the converted file to the current directory using the base name (e.g., 00.tum)
            GT_TUM="${i}.tum"
            
            # 2. Run APE using TUM matching rules
            # Note: '-s' is CRITICAL here; it enables Sim(3) alignment to resolve scale factors
            evo_ape tum "$GT_TUM" "$ESTIMATED_TRAJ" \
                -r full \
                -va \
                -s \
                --plot_mode xy \
                --save_plot "$OUTPUT_DIR/seq_${i}_error_plot.png" \
                --save_results "$OUTPUT_DIR/seq_${i}_results.zip"
                
            # Clean up the temporary TUM ground truth file from the working directory
            rm -f "$GT_TUM"
        else
            echo "Missing ground truth ($GT_POSE) or times.txt ($TIMES_FILE). Skipping evaluation."
        fi
    fi
    
    # Clean up residual artifacts from this iteration loop
    rm -f CameraTrajectory.txt KeyFrameTrajectory.txt f_mono_kitti.txt f_stereo_kitti.txt
    
    echo "Sequence ${i} complete!"
    sleep 2
done

echo "=================================================================="
echo "All sequences executed! Results compiled in: $OUTPUT_DIR"
echo "=================================================================="