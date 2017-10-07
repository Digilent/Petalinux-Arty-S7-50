




YAML_BSP_CONFIG[FLASH_MEMORY] = "set,axi_quad_spi_0"
YAML_BSP_CONFIG[STDIN] = "set,axi_uartlite_0"
XSCTH_WS = "${TOPDIR}/../components/plnx_workspace"
EXTERNALXSCTSRC = "${PETALINUX}/tools/hsm/data/embeddedsw"
FILESEXTRAPATHS_prepend := "${sysconf}:"
sysconf = "${TOPDIR}/../project-spec/configs"
EXTRA_OEMAKE_APP_append_microblaze = "CFLAGS=-O3\ -DCONFIG_FS_BOOT_OFFSET=${boot_offset}"
XSCTH_PROC_microblaze = "microblaze_0"
YAML_BSP_CONFIG[MAIN_MEMORY] = "set,mig_7series_0"
EXTERNALXSCTSRC_BUILD = "${TOPDIR}/../components/plnx_workspace"
inherit xsctyaml externalxsctsrc
YAML_BSP_CONFIG[STDOUT] = "set,axi_uartlite_0"
SRC_URI_append ="\
    file://config\
"
COMPILE_TRIGGER_FILES = "  ${XSCTH_WS}/${XSCTH_PROJ} "
export PETALINUX
SYSCONFIG = "${WORKDIR}/config"
hsmoutf = "${WORKDIR}/offsets"
YAML_FILE_PATH = "${WORKDIR}/fsboot.yaml"
XSCTH_MISC = "-yamlconf ${YAML_FILE_PATH}"
YAML_BSP_CONFIG = " STDIN STDOUT MAIN_MEMORY FLASH_MEMORY"

do_configure_append () {
	hsmoutf="${WORKDIR}/offsets"
	touch ${hsmoutf}
	ipinfof="${TOPDIR}/misc/config/data/ipinfo.yaml"
	xsct "${PETALINUX}/etc/hsm/scripts/petalinux_hsm.tcl"\
	"get_flash_width_parts" "${SYSCONFIG}" "${ipinfof}"\
	"${XSCTH_HDF}" "${hsmoutf}"
}

do_compile_prepend () {
	boot_offset=$(egrep -e "^boot=" "${hsmoutf}" | cut -d "=" -f 2 | cut -d " " -f 1)
}
