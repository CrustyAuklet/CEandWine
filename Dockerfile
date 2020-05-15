FROM ubuntu:latest
LABEL maintainer="Ethan Slattery <CrustyAuklet@gmail.com>"
EXPOSE 10240

# this image expects two things to be mounted:
# mount condif files to /compiler-explorer/etc/config most likely a c++.local.properties
# mount a folder containing all the compilers and libraries described in the config at the
# appropriate location, ex: /opt/compiler_explorer

# update and install wine and wine32, create a wine directory
RUN echo "*** Installing WINE and basic tools ***" \
    && apt-get update \
    && dpkg --add-architecture i386 \
    && apt-get -y update \
    && apt-get install -y curl wget apt-transport-https apt-utils software-properties-common \
    && apt-get install -y bzip2 libc6-dev-i386 make git binutils-multiarch \
    && apt-get install -y --install-recommends wine-stable wine32 \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -s /usr/include/asm-generic /usr/include/asm \
    && WINEARCH=win32 winecfg

RUN echo "*** Installing Compiler Explorer ***" \
    && apt-get -y update \
    && apt-get install -y curl dirmngr apt-transport-https lsb-release ca-certificates \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/* \
    && git clone --depth 1 --branch EWAVR https://github.com/CrustyAuklet/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Add missing dependencies for Compiler Explorer" \
    && npm i @sentry/node \
    && make webpack

WORKDIR /compiler-explorer

CMD [ "make" ]
