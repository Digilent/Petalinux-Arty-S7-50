# 1 "/home/digilent/work/git/Petalinux-Arty-S7-50/Arty-S7-50/build/../components/plnx_workspace/device-tree-generation/system-top.dts"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/home/digilent/work/git/Petalinux-Arty-S7-50/Arty-S7-50/build/../components/plnx_workspace/device-tree-generation/system-top.dts"







/dts-v1/;
/include/ "pl.dtsi"
/ {
 chosen {
  bootargs = "earlycon";
  stdout-path = "serial0:115200n8";
 };
 aliases {
  serial0 = &axi_uartlite_0;
  spi0 = &axi_quad_spi_0;
 };
 memory {
  device_type = "memory";
  reg = <0x80000000 0x10000000>;
 };
};
# 1 "/home/digilent/work/git/Petalinux-Arty-S7-50/Arty-S7-50/build/tmp/work/plnx_microblaze-xilinx-linux/device-tree-generation/xilinx+gitAUTOINC+43551819a1-r0/system-user.dtsi" 1
/include/ "system-conf.dtsi"
/ {
};

&flash0 {
 compatible = "s25fl128s";
};
# 24 "/home/digilent/work/git/Petalinux-Arty-S7-50/Arty-S7-50/build/../components/plnx_workspace/device-tree-generation/system-top.dts" 2
