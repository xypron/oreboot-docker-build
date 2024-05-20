FROM noble/riscv64:latest
MAINTAINER Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
LABEL Description="Build oreboot for RISC-V"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
	device-tree-compiler \
	gcc \
	git \
	libssl-dev \
	lld \
	make \
	pkg-config \
	rustup \
	sudo \
	vim

RUN echo user ALL=NOPASSWD: ALL > /etc/sudoers.d/uboot
RUN useradd -m -U user
USER user:user
WORKDIR /home/user

RUN git clone https://github.com/oreboot/oreboot.git
WORKDIR /home/user/oreboot
ENV RUST_BACKTRACE=1
RUN make firsttime

RUN git remote add orangecms https://github.com/orangecms/oreboot.git
RUN git fetch orangecms

RUN rustup toolchain install nightly-2024-01-10-riscv64gc-unknown-linux-gnu
RUN rustup toolchain install nightly-2024-01-10-riscv64gc-unknown-linux-gnu \
	--component llvm-tools
RUN ln -s /usr/lib/llvm-18/bin/lld \
	/home/user/.rustup/toolchains/nightly-2024-01-10-riscv64gc-unknown-linux-gnu/lib/rustlib/riscv64gc-unknown-linux-gnu/bin/rust-lld

RUN git checkout orangecms/all-the-things-wip -b all-the-things-wip
WORKDIR /home/user/oreboot/src/mainboard/starfive/visionfive2
COPY vf2.dtb vf2.dtb
RUN make DTB=vf2.dtb
