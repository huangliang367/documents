# RK3588 PCIe

## EP

### Kernel driver

#### dts

```dts
&pcie3x4 {
 compatible = "rockchip,rk3588-pcie-std-ep";
 reset-gpios = <&gpio4 RK_PB6 GPIO_ACTIVE_HIGH>;
    memory-region = <&bar0_region>, <&bar2_region>;
    memory-region-names = "bar0", "bar2";
 vpcie3v3-supply = <&vcc3v3_pcie30>;
 status = "okay";

 pcie@fe150000 {
  compatible = "rockchip,rk3588-pcie-std-ep";
  #address-cells = <0x03>;
  #size-cells = <0x02>;
  bus-range = <0x00 0x0f>;
  clocks = <0x02 0x14e 0x02 0x153 0x02 0x149 0x02 0x158 0x02 0x15e 0x02 0x183>;
  clock-names = "aclk_mst\0aclk_slv\0aclk_dbi\0pclk\0aux\0pipe";
  device_type = "pci";
  interrupts = <0x00 0x107 0x04 0x00 0x106 0x04 0x00 0x105 0x04 0x00 0x104 0x04 0x00 0x103 0x04>;
  interrupt-names = "sys\0pmc\0msg\0legacy\0err";
  #interrupt-cells = <0x01>;
  interrupt-map-mask = <0x00 0x00 0x00 0x07>;
  interrupt-map = <0x00 0x00 0x00 0x01 0x1d6 0x00 0x00 0x00 0x00 0x02 0x1d6 0x01 0x00 0x00 0x00 0x03 0x1d6 0x02 0x00 0x00 0x00 0x04 0x1d6 0x03>;
  linux,pci-domain = <0x00>;
  num-ib-windows = <0x10>;
  num-ob-windows = <0x10>;
  num-viewport = <0x08>;
  max-link-speed = <0x03>;
  msi-map = <0x00 0x1d7 0x00 0x1000>;
  num-lanes = <0x04>;
  phys = <0x1d8>;
  phy-names = "pcie-phy";
  power-domains = <0x5c 0x22>;
  ranges = <0x800 0x00 0xf0000000 0x00 0xf0000000 0x00 0x100000 0x81000000 0x00 0xf0100000 0x00 0xf0100000 0x00 0x100000 0x82000000 0x00 0xf0200000 0x00 0xf0200000 0x00 0xe00000 0xc3000000 0x09 0x00 0x09 0x00 0x00 0x40000000>;
  reg = <0x00 0xfe150000 0x00 0x10000 0x0a 0x40000000 0x00 0x400000>;
  reg-names = "pcie-apb\0pcie-dbi";
  resets = <0x02 0x20d 0x02 0x21c>;
  reset-names = "pcie\0periph";
  rockchip,pipe-grf = <0x6e>;
  status = "okay";
  reset-gpios = <0xff 0x0e 0x00>;
  memory-region = <0x1d9 0x1da>;
  memory-region-names = "bar0\0bar2";
  vpcie3v3-supply = <0x1db>;

  legacy-interrupt-controller {
   interrupt-controller;
   #address-cells = <0x00>;
   #interrupt-cells = <0x01>;
   interrupt-parent = <0x01>;
   interrupts = <0x00 0x104 0x01>;
   phandle = <0x1d6>;
  };
 };

   bar0-region@3c000000 {
   reg = <0x00 0x3c000000 0x00 0x400000>;
   phandle = <0x1d9>;
  };

  bar2-region@40000000 {
   reg = <0x00 0x40000000 0x00 0x4000000>;
   phandle = <0x1da>;
  };
};
```

ddr map:

| start        | size       |
| ------------ | ---------- |
| 0x00200000   | 0x08200000 |
| 0x09400000   | 0xe6c00000 |
| 0x01f0000000 | 0x10000000 |

#### structs

```c
struct rockchip_pcie {
 struct dw_pcie   pci;
 void __iomem   *apb_base;
 struct phy   *phy;
 struct clk_bulk_data  *clks;
 unsigned int   clk_cnt;
 struct reset_control  *rst;
 struct gpio_desc  *rst_gpio;
 unsigned long   *ib_window_map;
 unsigned long   *ob_window_map;
 u32    num_ib_windows;
 u32    num_ob_windows;
 phys_addr_t   *outbound_addr;
 u8    bar_to_atu[PCIE_BAR_MAX_NUM];
 dma_addr_t   ib_target_address[PCIE_BAR_MAX_NUM];
 u32    ib_target_size[PCIE_BAR_MAX_NUM];
 void    *ib_target_base[PCIE_BAR_MAX_NUM];
 struct dma_trx_obj  *dma_obj;
 phys_addr_t   dbi_base_physical;
 struct pcie_ep_obj_info  *obj_info;
 enum pcie_ep_mmap_resource cur_mmap_res;
 int    irq;
 struct workqueue_struct  *hot_rst_wq;
 struct work_struct  hot_rst_work;
 struct mutex   file_mutex;
 DECLARE_BITMAP(virtual_id_irq_bitmap, RKEP_EP_VIRTUAL_ID_MAX);
 wait_queue_head_t wq_head;
};

static const struct dw_pcie_ops dw_pcie_ops = {
 .link_up = rockchip_pcie_link_up,
};
```

#### drivers

## RC

## RK3588 PCIe测试

EP执行命令：

```shell
./pcie_speed_test_ep
Usage: ./pcie_speed_test_ep <mem_type>(1 hugepage, 2 rkdrm)
```

RC执行命令：

```shell
./pcie_speed_test_rc
Usage: ./pcie_speed_test_rc <rw: r/0 w/1 rw/2> <buff size> task_num <mem_type 1:hugepage 2:drm 3:rkep>
```
