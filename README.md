# SHiVAi runtime Docker image

[![GitHub release](https://img.shields.io/github/v/release/jhuguetn/shivai-runtime?logo=github)](https://github.com/jhuguetn/shivai-runtime/releases)
[![DockerHub pulls](https://img.shields.io/docker/pulls/jhuguetn/shivai-runtime?logo=docker)](https://hub.docker.com/r/jhuguetn/shivai-runtime/tags)

Portable CPU-only Docker runtime for reproducible **SHiVAi** execution.

- SHiVAi project: https://github.com/pboutinaud/SHiVAi

Find the image in Docker Hub [here](https://hub.docker.com/r/jhuguetn/shivai-runtime).

## Components

* Debian 11 Bullseye
* Python 3.11.13
* ANTs 2.4.3
* niimath
* dcm2niix
* TensorFlow 2.17.0
* Keras 3.6.0
* SHiVAi pinned commit/version: `b57c49175861b9a434e6b8bc3b0491faf4a0aac9`

## Usage

The container entrypoint is `shiva`.

Show help:

```bash
docker run --rm -it jhuguetn/shivai-runtime:latest --help
```

Example PVS run:

```bash
mkdir -p ./data/out

docker run --rm -it \
  -v $(pwd)/config.yml:/config.yml:ro \
  -v $(pwd)/models:/models:ro \
  -v $(pwd)/data:/data \
  jhuguetn/shivai-runtime:latest \
  --in /data/in \
  --out /data/out \
  --input_type standard \
  --prediction PVS \
  --brain_seg fs_precomp \
  --use_cpu \
  --config /config.yml
```

## License

This repository contains Docker build infrastructure for SHiVAi runtime execution.

The distributed image installs SHiVAi, which remains governed by its upstream license:

- SHiVAi pipeline and repository content: GNU Affero General Public License v3.0 or later (AGPLv3+)
- SHiVAi trained model weights: CC BY-NC-SA 4.0

This image does not include model weights. Models and configuration files must be mounted at runtime.

## Notes

* CPU-only image
* Generic SHiVAi runtime
* Models and configuration files should be mounted at runtime
* Intended for reproducible research workflows as a parent image for future workflow-specific images

## Credits

Jordi Huguet ([BarcelonaBeta Brain Research Center](http://barcelonabeta.org))
