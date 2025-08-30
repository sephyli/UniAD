#!/bin/bash
export PYTHONPATH="${PYTHONPATH}: {$pwd}"

# python ./tools/analysis_tools/visualize/run.py \
#     --predroot PATH_TO_YOUR_PREDISION_RESULT_PKL \
#     --out_folder PATH_TO_YOUR_OUTPUT_FOLDER \
#     --demo_video FILENAME_OF_OUTPUT_VIDEO \
#     --project_to_cam True

python ./tools/analysis_tools/visualize/run.py \
    --predroot /data1/zzh/UniAD-2.0/output/results.pkl \
    --out_folder /data1/zzh/UniAD-2.0/output/ \
    --demo_video test_demo.avi \
    --project_to_cam True