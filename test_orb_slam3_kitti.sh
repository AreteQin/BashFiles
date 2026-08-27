#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Force bash to find the local 'evo' binaries if installed via pip --user
export PATH="$HOME/.local/bin:$PATH"

# ==============================================================================
# 1. USER CONFIGURATION
# ==============================================================================
ORB_SLAM3_DIR="/home/qin/ORB_SLAM3_OpenCV4"          # Path to compiled ORB-SLAM3 root
KITTI_DIR="/home/qin/Downloads/data_odometry_gray/dataset"        # Directory containing "sequences/"
POSES_DIR="/home/qin/Downloads/data_odometry_poses/dataset/poses"  # Directory containing ground truth 00.txt to 10.txt
OUTPUT_DIR="/home/qin/orb_slam3_evaluation"  # Destination for trajectories and plots
EVO_ENV_ACTIVATE="$HOME/Downloads/VINS-Fusion-ROS2/.venv/bin/activate"

# Run mode choice: Set to "mono" or "stereo"
MODE="stereo"

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
source "$EVO_ENV_ACTIVATE"
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
    $EXEC Vocabulary/ORBvoc.txt "$YAML_PATH" "$KITTI_DIR/sequences/${i}"

    # ==============================================================================
    # 4. TRACK AND ISOLATE TRAJECTORY FILES BY ACTIVE MODE
    # ==============================================================================
    if [ "$MODE" = "stereo" ]; then
        TRAJ_FILE="CameraTrajectory.txt" 
        if [ ! -f "$TRAJ_FILE" ]; then
            echo "Error: Expected KITTI stereo matrix $TRAJ_FILE not found."
            continue
        fi
        ESTIMATED_TRAJ="$OUTPUT_DIR/seq_${i}_estimated.txt"
        mv "$TRAJ_FILE" "$ESTIMATED_TRAJ"
        
        GT_POSE="$POSES_DIR/${i}.txt"
        if [ -f "$GT_POSE" ]; then
            echo "Evaluating Stereo trajectory using native KITTI alignment..."
            
            # FIXED: Removed plotting parameters to bypass the matplotlib crash
            evo_ape kitti "$GT_POSE" "$ESTIMATED_TRAJ" \
                -r trans_part \
                -va \
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
            echo "Converting KITTI Ground Truth matrices to timestamped TUM trajectories..."
            GT_TUM="${OUTPUT_DIR}/seq_${i}_gt_tum.txt"
            
            # Inline Python utility to cleanly map the 12-column pose to an 8-column TUM format using Scipy
            python3 -c "
import sys, numpy as np
from scipy.spatial.transform import Rotation as R
with open('$GT_POSE', 'r') as f: p_lines = f.readlines()
with open('$TIMES_FILE', 'r') as f: t_lines = f.readlines()
out = []
for idx in range(min(len(p_lines), len(t_lines))):
    toks = list(map(float, p_lines[idx].strip().split()))
    if len(toks) != 12: continue
    mat = np.array(toks).reshape(3, 4)
    q = R.from_matrix(mat[:, :3]).as_quat() # Output format: [x, y, z, w]
    out.append(f'{t_lines[idx].strip()} {mat[0,3]} {mat[1,3]} {mat[2,3]} {q[0]} {q[1]} {q[2]} {q[3]}\n')
with open('$GT_TUM', 'w') as f: f.writelines(out)
"
            echo "Evaluating Monocular trajectory (Resolving scale factor using Sim3 alignment)..."
            evo_ape tum "$GT_TUM" "$ESTIMATED_TRAJ" \
                -r trans_part \
                -va \
                -s \
                --save_results "$OUTPUT_DIR/seq_${i}_results.zip"
                
            # Clean up the generated temporary ground truth file
            rm -f "$GT_TUM"
        else
            echo "Missing ground truth ($GT_POSE) or times.txt ($TIMES_FILE). Skipping evaluation."
        fi
    fi
    
    # Clean up residual artifacts from this iteration loop
    rm -f CameraTrajectory.txt KeyFrameTrajectory.txt f_mono_kitti.txt f_stereo_kitti.txt
    
    echo "Sequence ${i} complete!"
    echo "------------------------------------------------------------------"
    sleep 2
done

echo "=================================================================="
echo "All sequences executed! Results compiled in: $OUTPUT_DIR"
echo "=================================================================="