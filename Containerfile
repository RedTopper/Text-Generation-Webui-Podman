FROM huggingface/transformers-pytorch-gpu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git software-properties-common gnupg ninja-build

VOLUME /data

RUN git clone https://github.com/oobabooga/text-generation-webui /app
WORKDIR /app

RUN mkdir repositories && cd repositories && \
    git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa

RUN --mount=type=cache,target=/root/.cache/pip:z pip install -r /app/requirements.txt

RUN rm -rf /app/models
RUN ln -s /data /app/models

ENV CLI_ARGS=""
EXPOSE 7860
CMD cd /app/repositories/GPTQ-for-LLaMa && \
    python3 setup_cuda.py install && \
    cd /app && \
    python3 server.py ${CLI_ARGS}
