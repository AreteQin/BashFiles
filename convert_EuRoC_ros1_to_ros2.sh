#!/bin/bash

# Base directory containing the machine_hall datasets
BASE_DIR="$HOME/Downloads/machine_hall"

# Output mode
OUTPUT_IN_PLACE=true

# Check if ROS 2 Humble is installed/sourced
IS_HUMBLE=false
if [ -d "/opt/ros/humble" ] || [ "$ROS_DISTRO" = "humble" ]; then
    IS_HUMBLE=true
    echo "Detected ROS 2 Humble. Will apply metadata.yaml fix."
    echo ""
else
    echo "ROS 2 Humble not detected. Skipping metadata.yaml fixes."
    echo ""
fi

# Function to fix metadata.yaml files in a directory
fix_metadata() {
    local search_dir="$1"
    find "$search_dir" -type f -name "metadata.yaml" -print0 2>/dev/null | while IFS= read -r -d '' metafile; do
        if grep -q 'offered_qos_profiles: \[\]' "$metafile" 2>/dev/null; then
            echo "  → Fixing metadata.yaml: $metafile"
            sed -i 's/offered_qos_profiles: \[\]/offered_qos_profiles: ""/g' "$metafile"
        fi
    done
}

echo "========================================"
echo "Step 1: Fixing existing ROS2 bag files"
echo "========================================"

if [ "$IS_HUMBLE" = true ]; then
    # Fix metadata.yaml in any existing ROS2 bag directories under BASE_DIR
    fix_metadata "$BASE_DIR"
fi

echo ""
echo "========================================"
echo "Step 2: Converting ROS1 bag files"
echo "========================================"
echo ""

# Find all .bag files and process them
find "$BASE_DIR" -type f -name "*.bag" | while read -r bagfile; do
    bagdir=$(dirname "$bagfile")
    basename_no_ext=$(basename "$bagfile" .bag)
    
    # Determine output path
    if [ "$OUTPUT_IN_PLACE" = true ]; then
        output_file="$bagdir/${basename_no_ext}.mcap"
    else
        rel_path="${bagdir#$BASE_DIR/}"
        out_dir="$OUTPUT_DIR/$rel_path"
        mkdir -p "$out_dir"
        output_file="$out_dir/${basename_no_ext}.mcap"
    fi
    
    echo "----------------------------------------"
    echo "Converting: $bagfile"
    echo "Output:     $output_file"
    echo ""
    
    # Run the conversion
    rosbags-convert --src "$bagfile" --dst "$output_file"
    convert_status=$?
    
    if [ $convert_status -eq 0 ]; then
        echo "✓ Conversion success: $basename_no_ext"
        
        # If Humble is detected, fix metadata.yaml files in output location
        if [ "$IS_HUMBLE" = true ]; then
            if [ "$OUTPUT_IN_PLACE" = true ]; then
                fix_metadata "$bagdir"
            else
                fix_metadata "$out_dir"
            fi
        fi
    else
        echo "✗ Conversion failed: $basename_no_ext"
    fi
    echo ""
done

echo "========================================"
echo "All done!"
echo "========================================"