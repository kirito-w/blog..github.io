- https://blog.csdn.net/hanpca/article/details/136819938

```
DESCRIPTION = "yr-bus demo"
SECTION = "bin"
LICENSE = "CLOSED"

PV = "0.1+git${SRCPV}"
SRC_URI = "git://172.17.10.103:9090/cbb/yr-bus.git;protocol=http;branch=master"
SRCREV = "124ad1dd18bd515ed560b43d99542362fdc21f7e"

S = "${WORKDIR}/git"

DEPENDS = "mosquitto cjson libyrcommon-api"
RDEPENDS_${PN} = "mosquitto cjson libyrcommon-api"

do_compile (){
    make clean
    make WORKDIR=${WORKDIR}
}

do_install () {
    #install yr-bus binary
    install -d ${D}${bindir}/
    install -m 0755 ${S}/yr-bus ${D}${bindir}/


    #install config files,can be omitted   DATA_DIR
    #install -d ${D}${base_prefix}/mnt/yr_config_file/
    #install -m 0755 ${THISDIR}/yr-mqtt_config.ini ${D}${base_prefix}/mnt/yr_config_file/yr-mqtt_config.ini

    #install start scripts,can be omitted
   # install -d ${D}${sysconfdir}/init.d/
   # install -m 0755 ${THISDIR}/start_yr-bus ${D}${sysconfdir}/init.d/start_yr-bus
}

TARGET_CC_ARCH += "${LDFLAGS}"
```