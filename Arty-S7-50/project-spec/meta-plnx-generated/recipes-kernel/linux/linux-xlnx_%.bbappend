


# returns all the elements from the src uri that are .cfg files
def find_cfgs(d):
    sources=src_patches(d, True)
    sources_list=[]
    for s in sources:
        if s.endswith('.cfg'):
            sources_list.append(s)

    return sources_list


do_compile[depends] = "virtual/dtb:do_deploy"
FILESEXTRAPATHS_prepend := "${THISDIR}/configs:"
do_configure[depends] += "kern-tools-native:do_populate_sysroot"
KERNEL_IMAGETYPE = "simpleImage.mb"
SRC_URI += "file://plnx_kernel.cfg"
KERNEL_IMAGETYPE_zynq ?= "zImage"
RDEPENDS_kernel-base = ""

do_compile_prepend () {
	install -d ${B}/arch/microblaze/boot/dts
	cp ${DEPLOY_DIR_IMAGE}/${MACHINE}-system.dts ${B}/arch/microblaze/boot/dts/mb.dts
}

do_deploy_append () {
	install -m 0644 ${D}/boot/System.map-${KERNEL_VERSION} ${DEPLOYDIR}/System.map.linux
	install -m 0644 ${D}/boot/vmlinux-${KERNEL_VERSION} ${DEPLOYDIR}/vmlinux
}
