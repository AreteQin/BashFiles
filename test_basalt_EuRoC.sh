#!/usr/bin/env bash
# Run Basalt VIO on all EuRoC Machine Hall sequences.
# Each sequence gets its own output folder; all files carry the sequence name.
#
# Dataset layout expected (matches yours):
#   $DATASET_ROOT/MH_01_easy/MH_01_easy/mav0/...   <- inner folder = dataset path
#   $DATASET_ROOT/MH_01_easy/MH_01_easy.mcap       <- ignored (not a directory)

set -u  # treat unset variables as errors

# ---------- adjust these paths ----------
# Binary release (installed via scripts/install.sh):
#   binaries -> ~/.local/bin, libs -> ~/.local/lib, data -> ~/.local/etc/basalt
DATASET_ROOT="$HOME/Downloads/machine_hall"
BASALT_VIO="$HOME/.local/bin/basalt_vio"               # path to basalt_vio binary
CAM_CALIB="$HOME/.local/etc/basalt/euroc_ds_calib.json"  # EuRoC double-sphere calibration
CONFIG="$HOME/.local/etc/basalt/euroc_config.json"       # Basalt EuRoC config (vio_use_imu: true)
OUT_ROOT="$HOME/Downloads/machine_hall_basalt_results"
SHOW_GUI=0
# -----------------------------------------

# The binary release needs its bundled libs on LD_LIBRARY_PATH
# (normally done by sourcing ~/.basalt/env; we set it here so the
# script works even from a fresh/non-interactive shell)
export LD_LIBRARY_PATH="$HOME/.local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

if [[ ! -x "$BASALT_VIO" ]]; then
    echo "ERROR: basalt_vio not found or not executable: $BASALT_VIO" >&2
    exit 1
fi

mkdir -p "$OUT_ROOT"

for outer in "$DATASET_ROOT"/*/; do
    seq="$(basename "$outer")"

    # inner folder holding mav0/
    inner="$outer$seq"

    if [[ ! -d "$inner/mav0" ]]; then
        echo "SKIP $seq: no $inner/mav0 (not a EuRoC sequence folder?)"
        continue
    fi

    outdir="$OUT_ROOT/$seq"
    mkdir -p "$outdir"

    echo "===== Running $seq ====="
    # NOTE: this Basalt release writes stats_*.ubjson and trajectory.txt to the
    # CURRENT WORKING DIRECTORY (ignoring --result-path), so we cd into the
    # sequence's output folder before running.
    (
        cd "$outdir" || exit 1
        "$BASALT_VIO" \
            --dataset-path "$inner" \
            --dataset-type euroc \
            --cam-calib "$CAM_CALIB" \
            --config-path "$CONFIG" \
            --show-gui "$SHOW_GUI" \
            --save-trajectory tum \
            --marg-data "$outdir/marg_$seq" \
            --result-path "$outdir" \
            > "$outdir/${seq}_log.txt" 2>&1
    )

    status=$?
    if [[ $status -ne 0 ]]; then
        echo "FAILED $seq (exit $status) — see $outdir/${seq}_log.txt"
        continue
    fi

    # Rename generic outputs to include the sequence name
    for f in stats_vio stats_all stats_sums; do
        [[ -f "$outdir/$f.ubjson" ]] && \
            mv "$outdir/$f.ubjson" "$outdir/${f}_${seq}.ubjson"
    done
    [[ -f "$outdir/trajectory.txt" ]] && \
        mv "$outdir/trajectory.txt" "$outdir/trajectory_${seq}.txt"

    echo "DONE $seq -> $outdir"
done

echo "All sequences finished. Results in: $OUT_ROOT"