#!/usr/bin/env bash

T=`date +%m%d%H%M`

# -------------------------------------------------- #
# Usually you only need to customize these variables #
CFG=$1                                               #
GPUS=$2                                              #
# -------------------------------------------------- #
GPUS_PER_NODE=$(($GPUS<8?$GPUS:8))
NNODES=`expr $GPUS / $GPUS_PER_NODE`

MASTER_PORT=${MASTER_PORT:-28596}
MASTER_ADDR=${MASTER_ADDR:-"127.0.0.1"}  
RANK=${RANK:-0}
# MASTER_ADDR=${MASTER_ADDR}  # 由集群自动分配   # 多节点 16卡 --- 集群自己分配通信，30h ---> 15h，效率没有翻倍，可能是没设置好
# RANK=${RANK}                # 由集群自动分配（主节点为0，其他节点递增）

WORK_DIR=$(echo ${CFG%.*} | sed -e "s/configs/work_dirs/g")/
# Intermediate files and logs will be saved to UniAD/projects/work_dirs/

# export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
if [ ! -d ${WORK_DIR}logs ]; then
    mkdir -p ${WORK_DIR}logs
fi

PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
python -m torch.distributed.run \
    --nproc_per_node=${GPUS_PER_NODE} \
    --master_addr=${MASTER_ADDR} \
    --master_port=${MASTER_PORT} \
    --nnodes=${NNODES} \
    --node_rank=${RANK} \
    $(dirname "$0")/train.py \
    $CFG \
    --launcher pytorch \
    ${@:3} \
    --deterministic \
    --work-dir ${WORK_DIR} \
    2>&1 | tee ${WORK_DIR}logs/train.$T