url_buildroot_download = https://buildroot.org/downloads
lts_release = 2025.02
ifeq ($(lts_release),)
	url_buildroot = $(url_buildroot_download)/buildroot-2023.05.tar.gz
else
	url_buildroot = $(url_buildroot_download)/buildroot-$(lts_release).tar.gz
endif

archive_buildroot = buildroot.tar.gz
board_defconfig = stm32f429_disco_xip_defconfig
dir_download = downloads
dir_configs = configs
dir_output = output
dir_buildroot = buildroot

bootstrap:
	mkdir -p $(dir_download)
	mkdir -p $(dir_buildroot)
	wget -O $(dir_download)/$(archive_buildroot) $(url_buildroot)
	tar zxvf $(dir_download)/$(archive_buildroot) -C $(dir_buildroot) --strip-components=1

defconfig:
	make -C $(dir_buildroot) $(board_defconfig)

build:
	make -j$(shell grep -c '^processor' /proc/cpuinfo) -C $(dir_buildroot)

flash:
	cd $(dir_buildroot) && board/stmicroelectronics/stm32f429-disco/flash.sh $(dir_output) stm32f429discovery

clean:
	rm -rf $(dir_buildroot) $(dir_download)
