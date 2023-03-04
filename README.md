# gpu-burn-tesla-k80

A fork of [gpu-burn](https://github.com/wilicc/gpu-burn) with the Dockerfile modified to work with
the [NVIDIA Tesla K80](https://www.nvidia.com/en-gb/data-center/tesla-k80/).

Read the original blog post: http://wili.cc/blog/gpu-burn.html


## Running with Docker

Clone the repo, build the image, and start the program:

```
git clone https://github.com/esologic/gpu-burn-tesla-k80
cd gpu-burn-tesla-k80
docker build -t gpu_burn .
docker run --rm --gpus all gpu_burn
```

Should only require that an NVIDIA driver is installed on the host, as the dependencies are managed
inside the container.

If you want to only use one GPU on the k80, use the following:

```
docker run --rm --gpus '"device=0"' gpu_burn
```

You can also pass in the test duration or other args to script inside docker container like this:

```
devon@gance-live:~/Documents/gpu-burn-tesla-k80$ docker run --rm --gpus '"device=0,1"' gpu_burn 10
GPU 0: Tesla K80 (UUID: GPU-9a6afb5a-ad6f-9073-e99b-7cfd77ef7198)
GPU 1: Tesla K80 (UUID: GPU-5dfb0b0a-0681-4960-f905-4dd4cdd8f111)
Burning for 10 seconds.
...
```

Another example, using doubles:

```
devon@gance-live:~/Documents/gpu-burn-tesla-k80$ docker run --rm --gpus '"device=0,1"' gpu_burn -d 10
GPU 0: Tesla K80 (UUID: GPU-9a6afb5a-ad6f-9073-e99b-7cfd77ef7198)
GPU 1: Tesla K80 (UUID: GPU-5dfb0b0a-0681-4960-f905-4dd4cdd8f111)
Burning for 10 seconds.
70.0%  proc'd: 316 (735 Gflop/s) - 0 (0 Gflop/s)   errors: 0 - 0   temps: 72 C - 51 C 
	Summary at:   Thu Jun 23 15:27:23 UTC 2022

100.0%  proc'd: 316 (735 Gflop/s) - 316 (735 Gflop/s)   errors: 0 - 0   temps: 72 C - 51 C 
	Summary at:   Thu Jun 23 15:27:26 UTC 2022

100.0%  proc'd: 316 (735 Gflop/s) - 632 (786 Gflop/s)   errors: 0 - 0   temps: 74 C - 53 C 
Killing processes.. Burning for 10 seconds.
Initialized device 0 with 11441 MB of memory (11323 MB available, using 10191 MB of it), using DOUBLES
Results are 33554432 bytes each, thus performing 316 iterations
Freed memory for dev 0
Uninitted cublas
Burning for 10 seconds.
Initialized device 1 with 11441 MB of memory (11323 MB available, using 10191 MB of it), using DOUBLES
Results are 33554432 bytes each, thus performing 316 iterations
Freed memory for dev 1
Uninitted cublas
done

Tested 2 GPUs:
	GPU 0: OK
	GPU 1: OK
```


## Building

To build GPU Burn:

`make`

To remove artifacts built by GPU Burn:

`make clean`

GPU Burn builds with a default Compute Capability of 5.0.
To override this with a different value:

`make COMPUTE=<compute capability value>`

CFLAGS can be added when invoking make to add to the default
list of compiler flags:

`make CFLAGS=-Wall`

LDFLAGS can be added when invoking make to add to the default
list of linker flags:

`make LDFLAGS=-lmylib`

NVCCFLAGS can be added when invoking make to add to the default
list of nvcc flags:

`make NVCCFLAGS=-ccbin <path to host compiler>`

CUDAPATH can be added to point to a non standard install or
specific version of the cuda toolkit (default is 
/usr/local/cuda):

`make CUDAPATH=/usr/local/cuda-<version>`

CCPATH can be specified to point to a specific gcc (default is
/usr/bin):

`make CCPATH=/usr/local/bin`

CUDA_VERSION and IMAGE_DISTRO can be used to override the base
images used when building the Docker `image` target, while IMAGE_NAME
can be set to change the resulting image tag:

`make IMAGE_NAME=myregistry.private.com/gpu-burn CUDA_VERSION=12.0.1 IMAGE_DISTRO=ubuntu22.04 image`

# Usage

    GPU Burn
    Usage: gpu_burn [OPTIONS] [TIME]
    
    -m X   Use X MB of memory
    -m N%  Use N% of the available GPU memory
    -d     Use doubles
    -tc    Try to use Tensor cores (if available)
    -l     List all GPUs in the system
    -i N   Execute only on GPU N
    -h     Show this help message
    
    Example:
    gpu_burn -d 3600
