ARG CUDA_VERSION=11.8.0
ARG IMAGE_DISTRO=ubi8
ARG COMPUTE_COMPATIBILITY=5.0

FROM nvidia/cuda:${CUDA_VERSION}-devel-${IMAGE_DISTRO} AS builder

WORKDIR /build

COPY . /build/

RUN COMPUTE=${COMPUTE_COMPATIBILITY} make

FROM nvidia/cuda:${CUDA_VERSION}-runtime-${IMAGE_DISTRO}

COPY --from=builder /build/gpu_burn /app/
COPY --from=builder /build/compare.ptx /app/

WORKDIR /app

ENTRYPOINT ["./gpu_burn"]
