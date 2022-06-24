FROM nvidia/cuda:11.1.1-devel AS builder

WORKDIR /build

COPY . /build/

RUN COMPUTE=3.7 make  # Max usable version for the k80

FROM nvidia/cuda:11.1.1-runtime

COPY --from=builder /build/gpu_burn /app/
COPY --from=builder /build/compare.ptx /app/

WORKDIR /app

ENTRYPOINT ["./gpu_burn"]
