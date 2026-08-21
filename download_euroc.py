#!/usr/bin/env python3
"""
Download EuRoC MAV dataset sequences with resume support.
Uses wget via subprocess for robust resume capability.
"""
import os
import sys
import subprocess
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed

# Base URL pattern
BASE_URL = "http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset"

# Define sequences: (folder_name, relative_path)
SEQUENCES = {
    # Machine Hall
    "MH_01_easy":      "machine_hall/MH_01_easy/MH_01_easy.zip",
    "MH_02_easy":      "machine_hall/MH_02_easy/MH_02_easy.zip",
    "MH_03_medium":    "machine_hall/MH_03_medium/MH_03_medium.zip",
    "MH_04_difficult": "machine_hall/MH_04_difficult/MH_04_difficult.zip",
    "MH_05_difficult": "machine_hall/MH_05_difficult/MH_05_difficult.zip",
    # Vicon Room 1
    "V1_01_easy":      "vicon_room1/V1_01_easy/V1_01_easy.zip",
    "V1_02_medium":    "vicon_room1/V1_02_medium/V1_02_medium.zip",
    "V1_03_difficult": "vicon_room1/V1_03_difficult/V1_03_difficult.zip",
    # Vicon Room 2
    "V2_01_easy":      "vicon_room2/V2_01_easy/V2_01_easy.zip",
    "V2_02_medium":    "vicon_room2/V2_02_medium/V2_02_medium.zip",
    "V2_03_difficult": "vicon_room2/V2_03_difficult/V2_03_difficult.zip",
}

def download_sequence(name, rel_path, output_dir, max_retries=3):
    """Download a single sequence with wget resume support."""
    url = f"{BASE_URL}/{rel_path}"
    output_path = Path(output_dir) / f"{name}.zip"
    
    # Skip if already fully downloaded (check file size > 100MB)
    if output_path.exists() and output_path.stat().st_size > 100_000_000:
        print(f"[SKIP] {name}: already downloaded ({output_path.stat().st_size / 1e9:.2f} GB)")
        return True
    
    print(f"[DOWNLOAD] {name} from {url}")
    
    for attempt in range(max_retries):
        try:
            # wget -c: resume, --progress=bar:force: show progress
            cmd = [
                "wget", "-c", "--progress=bar:force",
                "-O", str(output_path),
                url
            ]
            result = subprocess.run(cmd, check=True, capture_output=True, text=True)
            print(f"[DONE] {name}")
            return True
            
        except subprocess.CalledProcessError as e:
            print(f"[RETRY {attempt+1}/{max_retries}] {name} failed: {e}")
            if attempt == max_retries - 1:
                print(f"[FAIL] {name}")
                return False
    
    return False

def main():
    # Default output directory
    output_dir = sys.argv[1] if len(sys.argv) > 1 else "./EuRoC"
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    
    # Select sequences to download
    # Usage: python download_euroc.py ./EuRoC MH_01_easy V1_01_easy
    if len(sys.argv) > 2:
        to_download = {k: v for k, v in SEQUENCES.items() if k in sys.argv[2:]}
    else:
        # Default: download recommended subset for ORB-SLAM3 vs VINS comparison
        to_download = {
            "MH_01_easy": SEQUENCES["MH_01_easy"],
            "MH_02_easy": SEQUENCES["MH_02_easy"],
            "MH_04_difficult": SEQUENCES["MH_04_difficult"],
            "V1_01_easy": SEQUENCES["V1_01_easy"],
            "V1_02_medium": SEQUENCES["V1_02_medium"],
            "V1_03_difficult": SEQUENCES["V1_03_difficult"],
        }
    
    print(f"Downloading {len(to_download)} sequences to: {output_dir}")
    print("-" * 50)
    
    # Download with 2 parallel workers (adjust based on your bandwidth)
    success = []
    failed = []
    
    with ThreadPoolExecutor(max_workers=2) as executor:
        futures = {
            executor.submit(download_sequence, name, path, output_dir): name 
            for name, path in to_download.items()
        }
        
        for future in as_completed(futures):
            name = futures[future]
            if future.result():
                success.append(name)
            else:
                failed.append(name)
    
    print("-" * 50)
    print(f"Success: {len(success)}/{len(to_download)}")
    if failed:
        print(f"Failed: {failed}")
    
    # Auto-unzip option
    print("\nUnzipping downloaded files...")
    for name in success:
        zip_path = Path(output_dir) / f"{name}.zip"
        extract_dir = Path(output_dir) / name
        if not extract_dir.exists():
            print(f"Unzipping {name}...")
            subprocess.run(["unzip", "-q", str(zip_path), "-d", str(extract_dir)], check=False)
    
    print("Done!")

if __name__ == "__main__":
    main()