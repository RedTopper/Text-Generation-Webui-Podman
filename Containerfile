FROM nvidia/cuda:11.7.0-devel-ubuntu22.04 as builder

COPY --from=continuumio/miniconda3 /opt/conda /opt/conda

ENV PIP_ROOT_USER_ACTION=ignore
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV PATH=/opt/conda/bin:$PATH

RUN apt-get update && apt-get install -y git ninja-build build-essential python3 pip
RUN git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa /build

WORKDIR /build

RUN --mount=type=cache,target=/opt/conda/pkgs,Z conda install pytorch pytorch-cuda=11.7 -c pytorch -c nvidia
RUN --mount=type=cache,target=/root/.cache/pip,Z pip3 install -r requirements.txt
RUN python3 setup_cuda.py bdist_wheel -d .

FROM ubuntu:22.04

COPY --from=continuumio/miniconda3 /opt/conda /opt/conda

ENV CLI_ARGS=""
ENV PIP_ROOT_USER_ACTION=ignore
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV PATH=/opt/conda/bin:$PATH

VOLUME /data

RUN apt-get update && apt-get install -y git

RUN --mount=type=cache,target=/opt/conda/pkgs,Z conda install torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia

RUN git clone https://github.com/oobabooga/text-generation-webui /app

WORKDIR /app

COPY --from=builder /build /app/repositories/GPTQ-for-LLaMa

RUN pip install /app/repositories/GPTQ-for-LLaMa/quant_cuda-0.0.0-cp310-cp310-linux_x86_64.whl
RUN --mount=type=cache,target=/root/.cache/pip,Z pip install -r /app/requirements.txt

RUN rm -rf /app/models
RUN ln -s /data /app/models

CMD python3 server.py ${CLI_ARGS}
