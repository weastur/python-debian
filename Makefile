.PHONY: all build pack clean python3.12-bookworm python3.12-bullseye python3.12-buster clean-python3.12-bullseye clean-python3.12-buster clean-python3.12-bookworm

all: pack

pack: build
	@find build/ -maxdepth 1 -mindepth 1 ! -path . -type d -exec sh -c 'tar -cvjSf "$(basename {}).tar.bz2" "$(basename {})"' \;

build: python3.12-bookworm python3.12-bullseye python3.12-buster

python3.12-bookworm: clean-python3.12-bookworm
	@echo "Build Python 3.12 for Debian 12 (bookworm)"
	@mkdir -p build/bookworm/python3.12
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg DEBIAN_RELEASE=bookworm \
		--build-arg UBUNTU_RELEASE=jammy \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg REPO_TAG=debian/3.12.0-1+jammy1 \
		--output build/bookworm/python3.12 \
		--force-rm \
		--no-cache \
		.
	@rm build/bookworm/python3.12/hack

python3.12-bullseye: clean-python3.12-bullseye
	@echo "Build Python 3.12 for Debian 11 (bullseye)"
	@mkdir -p build/bullseye/python3.12
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg DEBIAN_RELEASE=bullseye \
		--build-arg UBUNTU_RELEASE=focal \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg REPO_TAG=debian/3.12.0-1+focal1 \
		--output build/bullseye/python3.12 \
		--force-rm \
		--no-cache \
		.
	@rm build/bullseye/python3.12/hack

python3.12-buster: clean-python3.12-buster
	@echo "Build Python 3.12 for Debian 10 (buster)"
	@mkdir -p build/buster/python3.12
	@docker buildx build --platform linux/amd64 \
		--build-arg DEBIAN_RELEASE=buster \
		--build-arg UBUNTU_RELEASE=focal \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg REPO_TAG=debian/3.12.0-1+focal1 \
		--output build/buster/python3.12 \
		--force-rm \
		--no-cache \
		.
	@rm build/buster/python3.12/hack

clean: clean-python3.12-bookworm clean-python3.12-bullseye clean-python3.12-buster

clean-python3.12-bookworm:
	@echo "Clean artifacts of build of Python 3.12 for Debian 12 (bookworm)"
	@rm -rf build/bookworm/python3.12/*

clean-python3.12-bullseye:
	@echo "Clean artifacts of build of Python 3.12 for Debian 11 (bullseye)"
	@rm -rf build/bullseye/python3.12/*

clean-python3.12-buster:
	@echo "Clean artifacts of build of Python 3.12 for Debian 10 (buster)"
	@rm -rf build/buster/python3.12/*
