.PHONY: all build pack clean python3.10-bullseye python3.10-buster python3.10-stretch clean-python3.10-bullseye clean-python3.10-buster clean-python3.10-stretch

all: pack

pack: build
	@find build/ -maxdepth 1 -mindepth 1 ! -path . -type d -exec sh -c 'tar -cvjSf "$(basename {}).tar.bz2" "$(basename {})"' \;

build: python3.10-bullseye python3.10-buster python3.10-stretch

python3.10-bullseye: clean-python3.10-bullseye
	@echo "Build Python 3.10 for Debian 11 (bullseye)"
	@mkdir -p build/bullseye/python3.10
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg DEBIAN_RELEASE=bullseye \
		--build-arg UBUNTU_RELEASE=focal \
		--build-arg PYTHON_VERSION=3.10 \
		--build-arg REPO_TAG=debian/3.10.5-1+focal1 \
		--output build/bullseye/python3.10 \
		--force-rm \
		--no-cache \
		.
	@rm build/bullseye/python3.10/hack

python3.10-buster: clean-python3.10-buster
	@echo "Build Python 3.10 for Debian 10 (buster)"
	@mkdir -p build/buster/python3.10
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg DEBIAN_RELEASE=buster \
		--build-arg UBUNTU_RELEASE=focal \
		--build-arg PYTHON_VERSION=3.10 \
		--build-arg REPO_TAG=debian/3.10.5-1+focal1 \
		--output build/buster/python3.10 \
		--force-rm \
		--no-cache \
		.
	@rm build/buster/python3.10/hack

python3.10-stretch: clean-python3.10-stretch
	@echo "Build Python 3.10 for Debian 9 (stretch)"
	@mkdir -p build/stretch/python3.10
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg DEBIAN_RELEASE=stretch \
		--build-arg UBUNTU_RELEASE=bionic \
		--build-arg PYTHON_VERSION=3.10 \
		--build-arg REPO_TAG=debian/3.10.5-1+bionic1 \
		--output build/stretch/python3.10 \
		--force-rm \
		--no-cache \
		.
	@rm build/stretch/python3.10/hack

clean: clean-python3.10-bullseye clean-python3.10-buster clean-python3.10-stretch

clean-python3.10-bullseye:
	@echo "Clean artifacts of build of Python 3.10 for Debian 11 (bullseye)"
	@rm -rf build/bullseye/python3.10/*

clean-python3.10-buster:
	@echo "Clean artifacts of build of Python 3.10 for Debian 10 (buster)"
	@rm -rf build/buster/python3.10/*

clean-python3.10-stretch:
	@echo "Clean artifacts of build of Python 3.10 for Debian 9 (stretch)"
	@rm -rf build/stretch/python3.10/*
