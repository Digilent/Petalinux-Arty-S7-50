
OUTFILE_NAME = "u-boot-s"
do_compile[depends] = "virtual/bootloader:do_deploy"
ELF_INFILE = "${DEPLOY_DIR_IMAGE}/u-boot.elf"
