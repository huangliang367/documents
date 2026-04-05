# Kernel整体架构理解

先建立整体结构。

Linux Kernel主要模块：
```text
Linux Kernel
├── Process Management
├── Memory Management
├── Virtual File System
├── Device Drivers
├── Networking
├── Architecture Layer
└── Security
```
源码目录：
```text
linux
├── arch/
├── block/
├── drivers/
├── fs/
├── include/
├── init/
├── kernel/
├── mm/
├── net/
└── tools/
```
关键目录：
```text
目录 作用
arch CPU架构代码
drivers 设备驱动
fs 文件系统
kernel 进程调度
mm 内存管理
net 网络协议栈
```
## Kernel启动流程

启动流程（ARM64）：
```text
BootROM
 ↓
ATF
 ↓
U-Boot
 ↓
Kernel
 ↓
init
```
Kernel入口：
```text
arch/arm64/kernel/head.S
```
启动流程：
```text
head.S
 ↓
start_kernel()
 ↓
setup_arch()
 ↓
mm_init()
 ↓
sched_init()
 ↓
initcalls
 ↓
init进程
```

核心入口函数：
```c
init/main.c
```
最重要函数：
```c
start_kernel()
```
## Kernel配置与编译

配置系统：

Kconfig

配置：
```text
make menuconfig
```
编译：
```text
make -j$(nproc)
```
ARM64编译：
```text
make ARCH=arm64 defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
```
生成：
```text
arch/arm64/boot/Image
```
## Kernel启动实验（推荐）

使用 QEMU virt 启动Kernel。

启动：
```text
qemu-system-aarch64 \
-machine virt \
-cpu cortex-a72 \
-m 1024 \
-nographic \
-kernel Image \
-append "console=ttyAMA0"
```
如果使用 U-Boot：
```text
booti kernel_addr - fdt_addr
```
## Kernel源码阅读顺序

推荐顺序非常重要。

第一阶段（入口）

阅读：
```text
init/main.c
```
理解：
```c
start_kernel()
```
第二阶段（进程）

目录：
```text
kernel/
```
核心文件：
```text
kernel/sched/
```
理解：

调度器
```text
task_struct
```
第三阶段（内存）

目录：

mm/

重点：

页表
伙伴系统
slab
vm_area_struct

第四阶段（中断）

目录：

kernel/irq/

ARM64：
```text
arch/arm64/kernel/irq.c
```
第五阶段（设备驱动）

目录：

drivers/

重点：
```text
platform driver
device tree
driver model
```
## Kernel最重要的数据结构
```text
task_struct
```
进程描述符：
```text
include/linux/sched.h
mm_struct
```
进程地址空间：
```text
include/linux/mm_types.h
file
```
文件对象：
```text
include/linux/fs.h
device
```
设备模型：
```text
struct device
```
## Kernel最重要机制

必须理解的核心机制：

1 进程调度
CFS scheduler

源码：
```text
kernel/sched/fair.c
```
2 内存管理

核心：
```text
页表
虚拟内存
伙伴系统
slab
```
目录：

mm/

3 中断系统

流程：
```text
硬件中断
 ↓
irq handler
 ↓
softirq
 ↓
tasklet
```
4 驱动模型

Linux设备模型：
```text
bus
device
driver
```
结构：
```text
struct device
struct driver
struct bus_type
```
5 VFS

虚拟文件系统：
```text
VFS
 ↓
ext4
 ↓
block layer
```
目录：
```text
fs/
```
## 驱动开发路线

建议顺序：

1 字符设备

实现：
```text
open
read
write
ioctl
```
2 platform driver

结合：

device tree

示例：
```text
drivers/char/
```
3 中断驱动

函数：
```text
request_irq()
```
4 DMA

用于：

高速设备

## Kernel调试方法

常见调试手段：
```text
printk
printk()
```
日志：
```text
dmesg
ftrace
```
内核函数追踪：
```text
/sys/kernel/debug/tracing
```
gdb调试

结合：
```text
qemu -s -S
```
调试：
```text
gdb vmlinux
crash
```
内核崩溃分析：
```text
vmcore
```
## Kernel学习阶段路线

推荐四阶段。

第一阶段（基础）

目标：
```text
理解Kernel结构
会编译Kernel
会启动Kernel
```
实践：
```text
QEMU + Kernel
```
第二阶段（核心机制）

重点：
```text
进程调度
内存管理
中断
VFS
```
第三阶段（驱动开发）

学习：
```text
字符设备
platform driver
设备树
DMA
```
第四阶段（高级）

深入：
```text
NUMA
RCU
Lock
网络协议栈
性能优化
```
十一、强烈推荐的学习方式

最有效路线：
```text
QEMU
 ↓
ATF
 ↓
U-Boot
 ↓
Linux Kernel
```
然后调试：
```text
GDB
ftrace
printk
```

## 推荐书籍

经典资料：

1

Linux Kernel Development
Robert Love

2

Understanding the Linux Kernel

3

Linux Device Drivers

4

Professional Linux Kernel Architecture

## Kernel工程师核心能力

必须掌握：
```text
Kernel启动流程
进程调度
内存管理
驱动模型
设备树
调试
```

## Linux Kernel 8周源码阅读路线

第1周：Kernel整体结构 + 编译启动

目标：

能编译Kernel
能在QEMU启动
理解Kernel目录结构

源码目录重点：
```text
linux
├── arch/
├── kernel/
├── mm/
├── fs/
├── drivers/
├── net/
└── init/
```
重点阅读文件：

init/main.c

最重要函数：

start_kernel()

启动流程：
```text
head.S
 ↓
start_kernel()
 ↓
setup_arch()
 ↓
mm_init()
 ↓
sched_init()
 ↓
rest_init()
```
实践：

启动Kernel：
```text
qemu-system-aarch64 \
-machine virt \
-cpu cortex-a72 \
-m 1024 \
-nographic \
-kernel Image \
-append "console=ttyAMA0"
```
第2周：ARM64启动流程

重点理解 CPU reset → Kernel。

阅读：
```text
arch/arm64/kernel/head.S
arch/arm64/kernel/setup.c
```
关键函数：
```text
primary_entry
start_kernel
setup_arch
```
重点理解：
```text
页表初始化
MMU开启
CPU初始化
```
ARM64启动流程：
```text
EL3
 ↓
EL2
 ↓
EL1
 ↓
Kernel
```
第3周：进程管理

阅读目录：
```text
kernel/
kernel/sched/
```
重点文件：
```text
kernel/fork.c
kernel/sched/core.c
kernel/sched/fair.c
```
重点数据结构：
```text
struct task_struct
```
核心函数：
```text
schedule()
context_switch()
```
理解：
```text
进程创建
进程切换
调度器
```
第4周：内存管理

阅读目录：

mm/

重点文件：
```text
mm/page_alloc.c
mm/mmap.c
mm/slab.c
mm/slub.c
```
重点结构：
```text
struct page
struct mm_struct
struct vm_area_struct
```
理解：
```text
伙伴系统
虚拟内存
页表
slab分配器
```
第5周：中断系统

阅读：
```text
kernel/irq/
```
ARM64相关：
```text
arch/arm64/kernel/irq.c
arch/arm64/kernel/entry.S
```
流程：
```text
硬件中断
 ↓
irq handler
 ↓
softirq
 ↓
tasklet
```
核心函数：
```text
request_irq()
```
第6周：设备模型

Linux设备模型：
```text
Bus
 ↓
Device
 ↓
Driver
```
阅读：

drivers/base/

重点文件：
```text
drivers/base/device.c
drivers/base/bus.c
drivers/base/driver.c
```
核心结构：
```text
struct device
struct device_driver
struct bus_type
```
第7周：字符设备驱动

阅读：
```text
drivers/char/
```
重点函数：
```text
register_chrdev
file_operations
```
结构：
```text
struct file_operations
```
核心函数：
```text
open
read
write
ioctl
```
实践：

写一个驱动：

/dev/hello

第8周：设备树 + Platform Driver

阅读：

drivers/of/

重点函数：
```text
of_match_device()

platform driver：

platform_driver_register()
```
结构：

struct platform_driver

典型驱动流程：
```text
设备树
 ↓
platform_device
 ↓
platform_driver
 ↓
probe()
```
推荐源码阅读顺序（非常关键）

最佳顺序：
```text
init/main.c
 ↓
arch/arm64/kernel/head.S
 ↓
kernel/sched/
 ↓
mm/
 ↓
kernel/irq/
 ↓
drivers/base/
 ↓
drivers/
```
避免一开始就读：

drivers/gpu
net/

代码太复杂。

Kernel源码阅读技巧
1 从函数入口读

例如：

start_kernel()

逐步跟：
```text
setup_arch()
mm_init()
sched_init()
```
2 用代码索引工具

推荐：
```text
cscope
ctags
```
生成索引：
```text
make tags
```
3 VSCode跳转

快捷键：
```text
F12
Ctrl+Click
```
4 打印日志

调试：
```text
printk()
```
查看：
```text
dmesg
```
Kernel工程师必会调试

常用工具：
```text
gdb
ftrace
perf
crash
```
QEMU调试：
```text
qemu -s -S
```
GDB连接：
```text
target remote :1234
```
最佳实践环境

推荐环境：
```text
QEMU
 ↓
ATF
 ↓
U-Boot
 ↓
Linux Kernel
```

还需要深入：
```text
RCU
Lock
NUMA
cgroup
network stack
```