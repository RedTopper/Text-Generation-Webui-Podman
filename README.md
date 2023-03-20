# Text Generation Webui (Podman)

This repository puts [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui ) into a podman container. For full usage information, see the README.md in that repository [and the wiki](https://github.com/oobabooga/text-generation-webui/wiki).

This docker file automatically builds GPTQ-for-LLaMa so you can use 4bit LLaMa models.

## Usage

`./build.sh` to pull the latest commit and build (script provides access to access GPU when building .whl for 4bit)

`podman-compose up` to run the container, by default on port 7861.

## Data

`./data` and `./output` will automatically be populated with files and directories from text-generation-webui. Files are set to copy once, then never copy again if they exist. If your models are on a different drive altogether, you can still add additional mount-points, like so:

```yaml
volumes:
  - ./data:/data:z
  - ./output:/output:z
  - /media/some-drive/LLaMA-HFv2:/data/models:z
```

## Notes

The command line arguments can be changed by modifying `CLI_ARGS` in the podman-compose.yaml file

## License

The license in this repository only applies to the files here, not the original work at [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui). With that said:

```
    Copyright © 2023 AJ Walter <git@awalter.net>
    This work is free. You can redistribute it and/or modify it under the
    terms of the Do What The Fuck You Want To Public License, Version 2,
    as published by Sam Hocevar. See the LICENSE file for more details.
```
