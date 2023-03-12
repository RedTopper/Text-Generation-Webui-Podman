FROM continuumio/miniconda3

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git ninja-build build-essential

RUN --mount=type=cache,target=/opt/conda/pkgs,Z conda install torchvision torchaudio pytorch-cuda=11.7 git -c pytorch -c nvidia

VOLUME /data

RUN git clone https://github.com/oobabooga/text-generation-webui /app
WORKDIR /app

RUN mkdir repositories && cd repositories && \
    git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa

RUN --mount=type=cache,target=/root/.cache/pip,Z pip install -r /app/requirements.txt

RUN rm -rf /app/models
RUN ln -s /data /app/models

ENV CLI_ARGS=""
EXPOSE 7860
CMD cd /app/repositories/GPTQ-for-LLaMa && \
    python3 setup_cuda.py install && \
    cd /app && \
    python3 server.py ${CLI_ARGS}
