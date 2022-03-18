# Latest Python for Debian GNU/Linux

# Howto

Install docker and make. Then run

```
make
```

To issue build for a particular version

```
make python3.10-bullseye
make python3.10-buster
make python3.10-stretch
```

Look at the `build/` directory

# Internals

The build process runs inside docker, *without* using cache. It was tested on Linux and macOS. The source code for building packages will be downloaded from the [deadsnakes](https://github.com/deadsnakes) project. After the build, the simple smoke test takes place, installing all packages and running Python script. 

# FAQ

### Which versions of Debian are supported?

All currently maintaied versions: 9 (stretch), 10 (buster), 11 (bullseye)

### Which versions of Python are supported?

Only latest version – Python 3.10

### Why do not build all supported Python?

There is not much sense in that. If you need all Python versions for development, look at the [pyenv](https://github.com/pyenv/pyenv) project or [docker images](https://hub.docker.com/_/python). In other cases, you can safely run old python code in the newest interpreter.

### How long does the full build process take?

Making the fastest build isn't a goal of this project.

  **MacBook Pro 2019, Core i7 (Docker 6 CPU, 8 GB):**  
  
  Debian 11 (bullseye): *43m29s*</br>
  Debian 10 (buster): *40m58s*</br>
  Debian 9 (stretch): *49m36s*</br>

  **AMD Ryzen 5 3600 6-Core / 64G:**
  
  Debian 11 (bullseye): *32m48s*</br>
  Debian 10 (buster): *31m11s*</br>
  Debian 9 (stretch): *25m23s*</br>

