# Text Generation Webui (Podman+Docker)

This repository puts [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui ) into a container. For full usage information, see the README.md in that repository [and the wiki](https://github.com/oobabooga/text-generation-webui/wiki).

This Containerfile automatically builds GPTQ-for-LLaMa so you can use 4bit LLaMa models.

## Prerequisites

A working install of `nvidia-container-runtime` 

For Fedora, see: [How to enable NVIDIA GPUs in containers on bare metal in RHEL 8](https://www.redhat.com/en/blog/how-use-gpus-containers-bare-metal-rhel-8)

A working install of `podman` or `docker`

A working install of `podman-compose` or `docker-compose-plugin`

## Podman Usage

`podman-compose build` to pull the latest commit and build.

`podman-compose up` to run the container, by default on port 7861.

## Docker Usage

`./docker.sh` will convert the Containerfile into a valid Dockerfile by removing some selinux labels (see that file for more details)

`docker compose -f podman-compose.yaml build` will pull the latest commit and build using the new modified Dockerfile from the last step.

`docker compose -f podman-compose.yaml up` will run the container.

**Gotchas:**

You will also likely need to set the default runtime. Create the following file:

`cat /etc/docker/daemon.json`

```json
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime": "nvidia"
}
```

Additionally, If your machine is using `selinux`, you may need to run in privileged by setting `privileged: true` in the `podman-compose.yaml` file. This may have security ramifications beyond the scope of this setup. If you use selinux, I highly suggest running rootless with podman instead.

## Data

`./data` and `./output` will automatically be populated with files and directories from text-generation-webui. Files are set to copy once, then never copy again if they exist. If your models are on a different drive altogether, you can still add additional mount-points, like so:

```yaml
volumes:
  - ./data:/data:z
  - ./output:/output:z
  - /media/some-drive/LLaMA-HFv2:/data/models:z
```

## Notes

The command line arguments can be changed by modifying `CLI_ARGS` in the `podman-compose.yaml` file

## License

The license in this repository only applies to the files here, not the original work at [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui). With that said:
