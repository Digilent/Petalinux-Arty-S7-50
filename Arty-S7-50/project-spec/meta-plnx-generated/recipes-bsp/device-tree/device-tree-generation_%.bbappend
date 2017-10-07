


DT_PADDING_SIZE = "0x1000"
XSCTH_WS = "${TOPDIR}/../components/plnx_workspace"
KERNEL_DTS_INCLUDE = "${STAGING_KERNEL_DIR}/include"
sysconf = "${TOPDIR}/../project-spec/configs"
XSCTH_PROC_microblaze = "microblaze_0"
SRC_URI_append ="\
    file://config\
"
export PETALINUX
YAML_DT_BOARD_FLAGS = "{BOARD template }"
YAML_CONSOLE_DEVICE_CONFIG = "axi_uartlite_0"
FILESEXTRAPATHS_append := ":${sysconf}"
YAML_MAIN_MEMORY_CONFIG = "mig_7series_0"

do_configure_append () {
	script="${PETALINUX}/etc/hsm/scripts/petalinux_hsm_bridge.tcl"
	data=${PETALINUX}/etc/hsm/data/
	eval xsct ${script} -c ${WORKDIR}/config \
	-hdf ${DEVICETREE_WORKDIR}/hardware_description.hdf -repo ${S}\
	-data ${data} -sw ${DEVICETREE_WORKDIR} -o ${DEVICETREE_WORKDIR} -a "soc_mapping"
}
