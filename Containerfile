FROM nvidia/cuda:11.7.0-devel-ubuntu22.04 as builder

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

RUN apt-get update \
    && apt-get install --no-install-recommends -y git ninja-build build-essential python3-dev python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa /build

WORKDIR /build

# Fix until new parameter "groupsize" is figured out
RUN git reset --hard 468c47c01b4fe370616747b6d69a2d3f48bab5e4

RUN --mount=type=cache,target=/root/.cache/pip,Z pip3 install torch
RUN --mount=type=cache,target=/root/.cache/pip,Z pip3 install -r requirements.txt
RUN python3 setup_cuda.py bdist_wheel -d .

FROM ubuntu:22.04

ENV CLI_ARGS=""
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

VOLUME /data

RUN apt-get update \
    && apt-get install --no-install-recommends -y git python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/oobabooga/text-generation-webui /app

WORKDIR /app

COPY --from=builder /build /app/repositories/GPTQ-for-LLaMa

RUN --mount=type=cache,target=/root/.cache/pip,Z pip install torch torchvision torchaudio
RUN --mount=type=cache,target=/root/.cache/pip,Z pip install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip,Z pip install /app/repositories/GPTQ-for-LLaMa/*.whl

RUN rm -rf /app/models
RUN ln -s /data /app/models

CMD python3 server.py ${CLI_ARGS}
