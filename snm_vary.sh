#!/usr/bin/env bash
set -euo pipefail                # good hygiene

# --------- user-editable paths ---------------------------------------------
in_dir="./sram_vary_temp"    # folder that holds all the .sp netlists
out_dir="$in_dir/SNM_hold_results"     # where HSPICE should drop its output
wave_stage="$in_dir/sw0_waveform_files"   # final stash for *.sw0 files
# ---------------------------------------------------------------------------
mkdir -p "$out_dir" "$wave_stage"

# Launch one HSPICE run in the background per temperature
for netlist in "$in_dir"/*.sp; do
    [ -e "$netlist" ] || { echo "No *.sp files in $in_dir"; exit 1; }

    base="$(basename "${netlist%.*}")"     # strip directory & .sp extension
    echo "Running HSPICE on $netlist  →  $out_dir/${base}.*"

    # -i  : input netlist
    # -o  : prefix for every output file HSPICE writes
    # -hpp: (your original flag) keeps HSPICE progress printed to the screen
    hspice -i "$netlist" -o "$out_dir/$base" &
done


wait    # block until every background HSPICE run finishes
echo "All simulations finished."

# copy (or use 'mv' if you’d rather move)
cp "$out_dir"/*.sw0  "$wave_stage"/

echo "Waveforms copied to: $wave_stage"
