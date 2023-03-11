# Text Generation Webui (Podman)

This repo puts [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui ) into a podman container. For full usage information, see the README.md in that repository [and the wiki](https://github.com/oobabooga/text-generation-webui/wiki).

This docker file automatically builds GPTQ-for-LLaMa so you can use 4bit LLaMa models.

## Usage

Edit the path `/path/to/models` in the podman-compose.yaml file.

`podman-compose build` to pull the latest commit and build.

`podman-compose up` to run the container, by default on port 7861.

## Notes

The command line arguments can be changed by modifying CLI_ARGS in the podman-compose.yaml file

The base image is genuinely massive. It might be better to change it to something else, but hey it works.
