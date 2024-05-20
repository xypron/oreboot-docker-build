
all:
	make base
	sudo docker buildx build -t oreboot -f Dockerfile .

noble-base-riscv64.tar.gz:
	wget https://cdimage.ubuntu.com/ubuntu-base/noble/daily/current/noble-base-riscv64.tar.gz

base: noble-base-riscv64.tar.gz
	sudo docker buildx build -t noble/riscv64:latest -f Dockerfile.base .
