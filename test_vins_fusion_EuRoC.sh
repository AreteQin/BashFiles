#!/bin/bash

set -e

# ==================== Configuration ====================
VINS_WS="$HOME/Downloads/VINS-Fusion-ROS2"
ORIG_CONFIG="$VINS_WS/config/euroc/euroc_stereo_imu_config.yaml"
BASE_DIR="$HOME/Downloads/machine_hall"
OUTPUT_BASE="$HOME/output"

# Source ROS2 and VINS workspace
source /opt/ros/humble/setup.bash
source "$VINS_WS/install/setup.bash"

# Create base output directory
mkdir -p "$OUTPUT_BASE"

# ==================== Helper Functions ====================
cleanup_processes() {
    if [ -n "$vins_pid" ] && kill -0 $vins_pid 2>/dev/null; then
        echo "  Stopping vins_node (PID: $vins_pid)..."
        kill -INT $vins_pid 2>/dev/null || true
        wait $vins_pid 2>/dev/null || true
    fi
    if [ -n "$loop_pid" ] && kill -0 $loop_pid 2>/dev/null; then
        echo "  Stopping loop_fusion_node (PID: $loop_pid)..."
        kill -INT $loop_pid 2>/dev/null || true
        wait $loop_pid 2>/dev/null || true
    fi
}

cleanup_files() {
    [ -f "$temp_config" ] && rm -f "$temp_config"
}

trap 'echo ""; echo "Interrupted! Cleaning up..."; cleanup_processes; cleanup_files; exit 1' INT TERM

# ==================== Main Loop ====================
mapfile -t bags < <(find "$BASE_DIR" -name "*.mcap" | sort)

total=${#bags[@]}
if [ "$total" -eq 0 ]; then
    echo "No .mcap files found in $BASE_DIR"
    exit 1
fi

echo "Found $total bag files to process"
echo ""

for i in "${!bags[@]}"; do
    bag="${bags[$i]}"
    bag_name=$(basename "$bag" .mcap)
    
    echo "========================================"
    echo "[$((i+1))/$total] Processing: $bag_name"
    echo "========================================"
    
    # 1. Create bag-specific output directory
    output_dir="$OUTPUT_BASE/$bag_name"
    mkdir -p "$output_dir"
    echo "  Output dir: $output_dir"
    
    # 2. Create temporary config with unique output path
    temp_config="/tmp/vins_config_${bag_name}.yaml"
    sed "s|output_path: *\".*\"|output_path: \"$output_dir/\"|" "$ORIG_CONFIG" > "$temp_config"
    echo "  Temp config: $temp_config"
    
    # Change to VINS workspace (some nodes expect this)
    cd "$VINS_WS"
    
    # 3. Start VINS node
    echo "  Starting vins_node..."
    ros2 run vins vins_node "$temp_config" > "$output_dir/vins_log.txt" 2>&1 &
    vins_pid=$!
    
    # 4. Start Loop Fusion node
    echo "  Starting loop_fusion_node..."
    ros2 run loop_fusion loop_fusion_node "$temp_config" > "$output_dir/loop_fusion_log.txt" 2>&1 &
    loop_pid=$!
    
    # 5. Wait for initialization
    echo "  Waiting 10s for nodes to initialize..."
    sleep 10
    
    # 6. Play bag
    echo "  Playing bag: $bag_name"
    ros2 bag play "$bag"
    
    # 7. Bag finished — graceful shutdown
    echo "  Bag finished. Shutting down nodes..."
    cleanup_processes
    
    # 8. Clean up temp config
    cleanup_files
    
    echo "  ✓ Finished: $bag_name"
    echo "  Results: $output_dir"
    echo ""
    
    # Brief pause between runs to ensure ROS2 topics clear
    sleep 3
done

echo "========================================"
echo "All $total bags processed!"
echo "Results saved in: $OUTPUT_BASE"
echo "========================================"