#!/bin/bash
# Run ORB-SLAM3 stereo-inertial on all EuRoC Machine Hall sequences.
# Each run gets a unique output name, so results are never overwritten.
# ORB-SLAM3 saves: f_<output_name>.txt (full trajectory) and
#                  kf_<output_name>.txt (keyframes) in the ORB_SLAM3_DIR.

ORB_SLAM3_DIR=~/ORB_SLAM3_OpenCV4
DATASET_DIR=~/Downloads/machine_hall

VOCABULARY="$ORB_SLAM3_DIR/Vocabulary/ORBvoc.txt"
SETTINGS="$ORB_SLAM3_DIR/Examples/Stereo-Inertial/EuRoC.yaml"
TIMESTAMPS_DIR="$ORB_SLAM3_DIR/Examples/Stereo-Inertial/EuRoC_TimeStamps"

# sequence folder name -> timestamp file prefix
SEQUENCES=(
  "MH_01_easy MH01"
  "MH_02_easy MH02"
  "MH_03_medium MH03"
  "MH_04_difficult MH04"
  "MH_05_difficult MH05"
)

cd "$ORB_SLAM3_DIR" || { echo "Cannot cd into $ORB_SLAM3_DIR"; exit 1; }

for entry in "${SEQUENCES[@]}"; do
  seq=${entry%% *}        # e.g. MH_01_easy
  short=${entry##* }      # e.g. MH01

  # Handle nested (seq/seq) or flat (seq) dataset layouts
  if [ -d "$DATASET_DIR/$seq/$seq/mav0" ]; then
    seq_path="$DATASET_DIR/$seq/$seq"
  elif [ -d "$DATASET_DIR/$seq/mav0" ]; then
    seq_path="$DATASET_DIR/$seq"
  else
    echo "!! Sequence folder not found for $seq, skipping."
    continue
  fi

  output_name="dataset-${short}_stereoi"

  echo "=============================================="
  echo " Running: $seq"
  echo " Path:    $seq_path"
  echo " Output:  f_${output_name}.txt / kf_${output_name}.txt"
  echo "=============================================="

  ./Examples/Stereo-Inertial/stereo_inertial_euroc \
    "$VOCABULARY" \
    "$SETTINGS" \
    "$seq_path" \
    "$TIMESTAMPS_DIR/${short}.txt" \
    "$output_name"

  echo " Finished $seq"
  echo
done

echo "All sequences done. Trajectory files:"
ls -1 f_dataset-*_stereoi.txt kf_dataset-*_stereoi.txt 2>/dev/null
