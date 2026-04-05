# U-Boot 学习指南

## U-Boot简介

U-Boot（Universal Boot Loader）是嵌入式系统中最常见的 Bootloader，主要负责：

初始化硬件
加载操作系统
提供调试命令行
管理环境变量
支持网络、存储设备

典型应用平台：

ARM / ARM64
RISC-V
PowerPC
x86

## Boot 启动流程

嵌入式系统的典型启动流程：

ROM Code
   ↓
SPL / TPL
   ↓
U-Boot
   ↓
Linux Kernel
   ↓
Root FileSystem

ARM64 常见流程：

BL1 (ATF)
 ↓
BL2
 ↓
BL31
 ↓
U-Boot
 ↓
Linux

## U-Boot源码结构

源码仓库：

```html
https://source.denx.de/u-boot/u-boot
```

目录结构：

```text
u-boot
├── arch/          CPU架构代码
├── board/         板级支持代码
├── cmd/           U-Boot命令
├── common/        公共代码
├── configs/       默认配置
├── drivers/       驱动
├── dts/           设备树
├── env/           环境变量
├── fs/            文件系统
├── include/       头文件
├── lib/           工具库
├── net/           网络协议
```

重要目录：

```text
目录 作用
arch CPU架构初始化
board 板级初始化
cmd 命令实现
drivers 设备驱动
dts 设备树
```

## U-Boot启动流程

入口文件：

arch/arm/lib/crt0.S

启动流程：

CPU reset
   ↓
start.S
   ↓
lowlevel_init
   ↓
board_init_f()
   ↓
DDR初始化
   ↓
relocate_code()
   ↓
board_init_r()
   ↓
驱动初始化
   ↓
main_loop()

流程图：

Reset
 ↓
CPU初始化
 ↓
board_init_f
 ↓
DDR初始化
 ↓
代码重定位
 ↓
board_init_r
 ↓
设备初始化
 ↓
U-Boot命令行

## U-Boot命令系统

常用命令：

```text
help
version
bdinfo
printenv
setenv
saveenv
```

内存操作：

md 0x40000000
mw 0x40000000 0x12345678
cmp
cp

Linux启动命令：

```text
booti
bootz
bootm
```

## U-Boot环境变量

查看环境变量：

```text
printenv
```

设置：

```text
setenv bootargs console=ttyAMA0
```

保存：

```text
saveenv
```

环境变量通常存储在：

SPI Flash
eMMC
NAND Flash

相关源码：

env/

## U-Boot设备驱动模型

U-Boot采用 Driver Model（类似 Linux）：

Driver
  ↓
Device
  ↓
Uclass

关键结构：

struct driver
struct udevice
struct uclass

驱动匹配：

compatible = "vendor,device"

设备树提供硬件信息。

1. 设备树 Device Tree

设备树目录：

arch/arm/dts/

示例：

qemu-arm64.dts

编译：

dtc

U-Boot查看设备树：

fdt addr 0x40400000
fdt print

## U-Boot配置系统

U-Boot使用 Kconfig：

make qemu_arm64_defconfig
make menuconfig
make

生成配置：

.config
include/generated/autoconf.h

defconfig位置：

configs/*.defconfig

## Linux启动方式

三种启动方式：

架构 命令

```text
ARM64 booti
ARM32 bootz
legacy bootm
```

示例：

```text
booti 0x40200000 - 0x40400000
```

含义：

```text
booti <kernel> <initrd> <fdt>
```

示例：

kernel = 0x40200000
initrd = none
dtb = 0x40400000

## QEMU实验

编译：

```text
make qemu_arm64_defconfig
make -j$(nproc)
```

启动：

```text
qemu-system-aarch64 \
-machine virt \
-cpu cortex-a57 \
-nographic \
-bios u-boot.bin
```

成功后：

U-Boot>

## 通过TFTP加载Linux

启动QEMU网络：

```text
-netdev user,id=net0,tftp=./
-device virtio-net-device,netdev=net0
```

U-Boot加载：

```text
tftpboot 0x40200000 Image
tftpboot 0x40400000 virt.dtb
booti 0x40200000 - 0x40400000
```

## 添加U-Boot命令示例

创建：

cmd/hello.c

代码：

```c
# include <common.h>

# include <command.h>

static int do_hello(cmd_tbl_t *cmdtp, int flag,
                    int argc, char* const argv[])
{
    printf("hello world\n");
    return 0;
}

U_BOOT_CMD(
    hello, 1, 1, do_hello,
    "hello command",
    ""
);
```

编译：

```text
make
```

运行：

```text
hello
```

输出：

```text
hello world
```

## U-Boot源码阅读顺序

推荐顺序：

第一阶段
cmd/
common/main.c

理解命令系统。

第二阶段
arch/arm/lib/crt0.S
common/board_f.c
common/board_r.c

理解启动流程。

第三阶段
drivers/

理解驱动模型。

第四阶段
env/

理解环境变量。

## Bootloader工程师核心能力

需要掌握：

Boot流程
ROM
ATF
U-Boot
Kernel
内存布局
kernel addr
fdt addr
initrd addr
设备树
dts
dtb
fdt
调试能力
串口调试
GDB调试
内存dump
日志分析

## 推荐实践项目

项目1：

QEMU virt
 ↓
ATF
 ↓
U-Boot
 ↓
Linux

项目2：

U-Boot加载rootfs

项目3：

实现自定义U-Boot命令

项目4：

添加驱动

## 推荐学习资源

官方文档：

<https://docs.u-boot.org>

源码：

<https://source.denx.de/u-boot/u-boot>

推荐资料：

Bootlin U-Boot Training
Embedded Linux Primer
