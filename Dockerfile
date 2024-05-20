FROM noble/riscv64:latest
MAINTAINER Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
LABEL Description="Build oreboot for RISC-V"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
	gcc \
	git \
	libssl-dev \
	pkg-config \
	rustup \
	make \
	sudo \
	vim

RUN echo user ALL=NOPASSWD: ALL > /etc/sudoers.d/uboot
RUN useradd -m -U user
USER user:user
WORKDIR /home/user

RUN git clone https://github.com/oreboot/oreboot.git
WORKDIR /home/user/oreboot
ENV RUST_BACKTRACE=1
