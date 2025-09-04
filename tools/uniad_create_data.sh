
PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
python tools/create_data.py nuscenes --root-path ./data/nuscenes \
       --out-dir ./data/infos \
       --extra-tag nuscenes \
       --version v1.0 \
       --canbus ./data/nuscenes \

# change the coordinate to mmdet3d v1.0
python tools/data_converter/update_coord.py nuscenes \
       --root-dir ./data/infos \
       --out-dir ./data/infos \
       --version v1.0