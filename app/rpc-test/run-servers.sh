#!/bin/bash
source $(dirname $0)/../../util/helpers.sh

export HRD_REGISTRY_IP="192.168.40.171"
export MLX5_SHUT_UP_BF=0
export MLX5_SINGLE_THREADED=1
export MLX4_SINGLE_THREADED=1
export MLX_QP_ALLOC_TYPE="HUGE"
export MLX_CQ_ALLOC_TYPE="HUGE"

if [ "$#" -ne 1 ]; then
    blue "Illegal number of parameters"
	blue "Usage: ./run-servers.sh <machine_number>"
	exit
fi

# With link-time optimization, main exe does not get correct permissions
chmod +x main
drop_shm

# The 0th server hosts the QP registry
if [ "$1" -eq 0 ]; then
	blue "Resetting QP registry"
	sudo killall memcached
	memcached -l 192.168.40.171 1>/home/qijing/tmp.txt 2>/home/qijing/error.txt &
	sleep 1
fi

sudo LD_LIBRARY_PATH=/usr/local/lib/ -E \
	numactl --membind=1 --cpunodebind=1 taskset -c 8,9,10,11,12,13,14,15 ./main --machine-id $1 &

# Debug: run --num-threads 1 --num-coro 2 --base-port-index 0 --num-ports 2 --num-qps 2 --machine-id 0 --postlist 16 --numa-node 0 --size-req 48 --size-resp 8
