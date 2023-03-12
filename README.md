# Text Generation Webui (Podman)

This repository puts [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui ) into a podman container. For full usage information, see the README.md in that repository [and the wiki](https://github.com/oobabooga/text-generation-webui/wiki).

This docker file automatically builds GPTQ-for-LLaMa so you can use 4bit LLaMa models.

## Usage

Edit the path `/path/to/models` in the podman-compose.yaml file.

`podman-compose build` to pull the latest commit and build.

`podman-compose up` to run the container, by default on port 7861.

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
