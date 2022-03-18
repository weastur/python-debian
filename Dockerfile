ARG DEBIAN_RELEASE

FROM debian:${DEBIAN_RELEASE} as build

ARG DEBIAN_RELEASE
ARG UBUNTU_RELEASE
ARG PYTHON_VERSION
ARG REPO_TAG
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes

WORKDIR /root
RUN apt-get update -qq \
	&& apt-get install -qq -y --no-install-recommends > /dev/null \
	libmpdec-dev \
	libncursesw5-dev \
        blt-dev \
        build-essential \
        debhelper \
        libbluetooth-dev \
        libbz2-dev \
        libdb-dev \
        libexpat1-dev \
        libffi-dev \
        libgdbm-dev \
        libgpm2 \
        liblzma-dev \
        libncurses-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        locales \
        lsb-release \
        mime-support \
        net-tools \
        netbase \
        python3-sphinx \
        quilt \
        sharutils \
        texinfo \
        time \
        tk-dev \
        unzip \
        xauth \
        xvfb \
        zlib1g-dev \
    && apt-get -qq clean \
    && rm -rf "/var/lib/apt/lists"/*

ADD https://github.com/deadsnakes/python${PYTHON_VERSION}/archive/refs/tags/${REPO_TAG}.zip python.zip
RUN unzip -q python.zip \
	&& cd python*-debian* \
	&& sed -ie "s/${UBUNTU_RELEASE}/${DEBIAN_RELEASE}/g" debian/changelog \
	&& sed -ie 's/^Maintainer:/Uploaders: Pavel Sapezhka <me@weastur.com>\nMaintainer:/' debian/control \
	&& dpkg-buildpackage -uc -us -b

FROM debian:${DEBIAN_RELEASE} AS test
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes
COPY --from=build /root/*.deb /root/
RUN apt-get update -qq \
	&& apt-get install -qq -y --no-install-recommends ./root/*.deb > /dev/null \
        && python${PYTHON_VERSION} -c 'print("OK")' \
	&& touch /root/hack

FROM scratch AS export
COPY --from=build /root/*.deb /
# BuildKit ignores stages treated as unneeded for the result
# So we create an artificial need of the test stage by copying file from.
COPY --from=test /root/hack /
