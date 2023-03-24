FROM nvidia/cuda:11.7.0-devel-ubuntu22.04 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y git ninja-build build-essential python3-dev python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip,Z pip3 install torch
RUN git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa /build

WORKDIR /build

ARG GPTQ_SHA=HEAD
RUN git reset --hard ${GPTQ_SHA}

RUN --mount=type=cache,target=/root/.cache/pip,Z pip3 install -r requirements.txt

ARG TORCH_CUDA_ARCH_LIST="8.6+PTX"
RUN python3 setup_cuda.py bdist_wheel -d .

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y git python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip,Z pip install torch torchvision torchaudio

RUN git clone https://github.com/oobabooga/text-generation-webui /app

WORKDIR /app

ARG WEBUI_SHA=HEAD
RUN git reset --hard ${WEBUI_SHA}

RUN --mount=type=cache,target=/root/.cache/pip,Z pip install -r requirements.txt

COPY --from=builder /build /app/repositories/GPTQ-for-LLaMa
RUN --mount=type=cache,target=/root/.cache/pip,Z pip install /app/repositories/GPTQ-for-LLaMa/*.whl

COPY entrypoint.sh .

VOLUME /data
VOLUME /output

ENV CLI_ARGS=""
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENTRYPOINT ["/app/entrypoint.sh"]
CMD python3 server.py ${CLI_ARGS}
