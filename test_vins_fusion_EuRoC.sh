#!/bin/bash
# batch_run_vins.sh — run VINS-Fusion (stereo+IMU) on every .mcap under $BASE_DIR

# ==================== Configuration ====================
VINS_WS="$HOME/Downloads/VINS-Fusion-ROS2"
CONFIG_DIR="$VINS_WS/config/euroc"            # temp configs MUST live here!
ORIG_CONFIG="$CONFIG_DIR/euroc_stereo_imu_config.yaml"
BASE_DIR="$HOME/Downloads/machine_hall"
OUTPUT_BASE="$HOME/output"

TOPICS=(/cam0/image_raw /cam1/image_raw /imu0)
READY_TIMEOUT=30    # max seconds to wait for node subscriptions
DRAIN_TIME=15       # seconds to let the estimator finish its queue after bag ends

source /opt/ros/humble/setup.bash
source "$VINS_WS/install/setup.bash"

mkdir -p "$OUTPUT_BASE"
set +m
set +e

# ==================== Helpers ====================
kill_ros2_node() {
    local name=$1 pid=$2
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        kill -INT "$pid" 2>/dev/null; sleep 3
    fi
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        kill -TERM "$pid" 2>/dev/null; sleep 2
    fi
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        kill -9 "$pid" 2>/dev/null; sleep 1
    fi
    pkill -INT -f "$name" 2>/dev/null; sleep 2
    pkill -9  -f "$name" 2>/dev/null
    wait "$pid" 2>/dev/null
    echo "  $name stopped."
}

# Wait until a topic has at least N subscribers (nodes truly ready)
wait_for_subscribers() {
    local topic=$1 min=$2 timeout=$3 t=0 n
    while (( t < timeout )); do
        n=$(ros2 topic info "$topic" 2>/dev/null | awk -F': *' '/Subscription count/{print $2}')
        if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= min )); then
            return 0
        fi
        sleep 1; ((t++))
    done
    return 1
}

cleanup() {
    echo ""
    echo "Interrupted! Cleaning up..."
    kill_ros2_node "vins_node" "$vins_pid"
    kill_ros2_node "loop_fusion_node" "$loop_pid"
    [ -n "$temp_config" ] && rm -f "$temp_config"
    exit 1
}
trap cleanup INT TERM

# ==================== Pre-flight checks ====================
echo "Pre-flight checks..."
for f in $(grep -oP '^(cam0_calib|cam1_calib):\s*"?\K[^"\s]+' "$ORIG_CONFIG"); do
    if [ -f "$CONFIG_DIR/$f" ]; then
        echo "  OK: $CONFIG_DIR/$f"
    else
        echo "  WARNING: calibration file $CONFIG_DIR/$f NOT FOUND"
    fi
done
echo ""

# ==================== Main loop ====================
mapfile -t bags < <(find "$BASE_DIR" -name "*.mcap" | sort)
total=${#bags[@]}
if [ "$total" -eq 0 ]; then
    echo "No .mcap files found in $BASE_DIR"; exit 1
fi
echo "Found $total bag files to process"
echo ""

for i in "${!bags[@]}"; do
    bag="${bags[$i]}"
    bag_name=$(basename "$bag" .mcap)

    echo "========================================"
    echo "[$((i+1))/$total] Processing: $bag_name"
    echo "========================================"

    output_dir="$OUTPUT_BASE/$bag_name"
    mkdir -p "$output_dir"

    # --- KEY FIX: temp config in the SAME directory as the original ---
    temp_config="$CONFIG_DIR/.tmp_config_${bag_name}.yaml"
    sed -E "s|^[[:space:]]*output_path:.*|output_path: \"$output_dir/\"|" \
        "$ORIG_CONFIG" > "$temp_config"

    # Verify the rewrite actually happened
    if ! grep -qF "output_path: \"$output_dir/\"" "$temp_config"; then
        echo "  ERROR: failed to rewrite output_path — skipping"
        rm -f "$temp_config"
        continue
    fi
    echo "  Temp config: $temp_config"
    echo "  Output dir:  $output_dir"

    cd "$CONFIG_DIR"   # covers ports that resolve relative paths against CWD
    vins_pid=""; loop_pid=""

    ros2 run vins vins_node "$temp_config" > "$output_dir/vins_log.txt" 2>&1 &
    vins_pid=$!
    ros2 run loop_fusion loop_fusion_node "$temp_config" > "$output_dir/loop_fusion_log.txt" 2>&1 &
    loop_pid=$!

    # --- Wait for real readiness, not a fixed sleep ---
    echo "  Waiting for nodes to subscribe..."
    for topic in "${TOPICS[@]}"; do
        if wait_for_subscribers "$topic" 1 "$READY_TIMEOUT"; then
            echo "    $topic: subscribed"
        else
            echo "    WARNING: no subscriber on $topic after ${READY_TIMEOUT}s"
        fi
    done

    # --- Crash check before wasting a bag playback ---
    if grep -qiE "unable to open|wrong path|segmentation" "$output_dir/vins_log.txt"; then
        echo "  ERROR: vins_node reports a problem — see $output_dir/vins_log.txt"
        kill_ros2_node "vins_node" "$vins_pid"
        kill_ros2_node "loop_fusion_node" "$loop_pid"
        rm -f "$temp_config"
        continue
    fi

    echo "  Playing bag: $bag_name"
    ros2 bag play "$bag"

    echo "  Bag finished. Draining estimator for ${DRAIN_TIME}s..."
    sleep "$DRAIN_TIME"

    kill_ros2_node "vins_node" "$vins_pid"
    kill_ros2_node "loop_fusion_node" "$loop_pid"
    rm -f "$temp_config"

    # --- Validate result ---
    vio_csv="$output_dir/vio.csv"
    if [ -s "$vio_csv" ]; then
        echo "  ✓ $bag_name done — vio.csv has $(wc -l < "$vio_csv") lines"
    else
        echo "  ✗ $bag_name FAILED — vio.csv empty/missing. Check:"
        echo "      $output_dir/vins_log.txt"
    fi
    echo ""
    sleep 5
done

echo "========================================"
echo "All $total bags processed! Results: $OUTPUT_BASE"
echo "========================================"