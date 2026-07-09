#!/bin/bash

# Exit immediately if a command exits with a non-zero status code
set -e

# ==============================================================================
# 1. DIRECTORY & PATH CONFIGURATION (Verify these match your local paths)
# ==============================================================================
REPO_DIR="$HOME/Downloads/VINS-Fusion-ROS2"
DATA_BASE_DIR="$HOME/Downloads/data_odometry_gray/dataset/sequences"
POSE_BASE_DIR="$HOME/Downloads/data_odometry_poses/dataset/poses"
VINS_OUTPUT_DIR="/home/qin/vins_output"
EVO_ENV_ACTIVATE="$HOME/Downloads/VINS-Fusion-ROS2/evo_env/bin/activate"

echo "===================================================================="
echo " Starting Batch Processing for KITTI Sequences 00 to 10"
echo "===================================================================="
cd "$REPO_DIR"

# Optional: Source your ROS 2 overlay workspace setup if needed
# source /opt/ros/foxy/setup.bash
# source ./install/setup.bash

# ==============================================================================
# 2. RUN VINS-FUSION ESTIMATOR LOOP
# ==============================================================================
for i in {0..10}; do
    # Format number to 2 digits (00, 01, 02 ... 10)
    SEQ=$(printf "%02d" $i)
    
    echo ""
    echo "####################################################################"
    echo " EXECUTING SEQUENCE: $SEQ"
    echo "####################################################################"

    # Dynamically select the correct tracking config assignment file
    if [ $i -le 2 ]; then
        CONFIG="./config/kitti_odom/kitti_config00-02.yaml"
    elif [ $i -eq 3 ]; then
        CONFIG="./config/kitti_odom/kitti_config03.yaml"
    else
        CONFIG="./config/kitti_odom/kitti_config04-12.yaml"
    fi

    # Run the specific sequence tracking node
    ros2 run vins kitti_odom_test "$CONFIG" "${DATA_BASE_DIR}/${SEQ}/"

    # Protect result file from overwriting by renaming it specifically to the sequence
    if [ -f "${VINS_OUTPUT_DIR}/vio.txt" ]; then
        TARGET_FILE="${VINS_OUTPUT_DIR}/vio_${SEQ}.txt"
        mv "${VINS_OUTPUT_DIR}/vio.txt" "$TARGET_FILE"
        echo "--> Saved trajectory trace output to: $TARGET_FILE"
        
        # Strip out potential hidden trailing spaces to block downstream evo parsing errors
        sed -i 's/[[:space:]]*$//; /^$/d' "$TARGET_FILE"
    else
        echo "[ERROR] Expected file missing at ${VINS_OUTPUT_DIR}/vio.txt. Node may have failed."
        exit 1
    fi
done

# ==============================================================================
# 3. AUTOMATED EVO METRIC EVALUATION LOOP
# ==============================================================================
echo ""
echo "===================================================================="
echo " Activating evo_env sandbox to run metric evaluations..."
echo "===================================================================="
source "$EVO_ENV_ACTIVATE"

cd "$VINS_OUTPUT_DIR"

for i in {0..10}; do
    SEQ=$(printf "%02d" $i)
    GT_POSE="${POSE_BASE_DIR}/${SEQ}.txt"
    EST_POSE="./vio_${SEQ}.txt"

    echo ""
    echo "--------------------------------------------------------------------"
    echo " METRIC ACCURACY REPORT FOR SEQUENCE: $SEQ"
    echo "--------------------------------------------------------------------"

    if [ -f "$GT_POSE" ] && [ -f "$EST_POSE" ]; then
        # Run absolute pose error evaluation with alignment parameter flags
        # Logs metrics to terminal window and writes down a local backup file archive
        evo_ape kitti "$GT_POSE" "$EST_POSE" -va --save_results "ate_metric_seq_${SEQ}.zip"
    else
        echo "[WARN] Skipping sequence $SEQ. Ground truth matrix or output trace file not found."
    fi
done

echo ""
echo "===================================================================="
echo " All tasks finalized! All individual sequence logs are saved."
echo "===================================================================="