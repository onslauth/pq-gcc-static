include $(PQ_FACTORY)/factory.mk

pq_part_name := gcc-4.9.1
pq_part_file := $(pq_part_name).tar.bz2

pq_gcc_configuration_flags += --prefix=$(part_dir)
pq_gcc_configuration_flags += --with-mpc=$(pq-mpc-dir)
pq_gcc_configuration_flags += --with-gmp=$(pq-gmp-dir)
pq_gcc_configuration_flags += --with-mpfr=$(pq-mpfr-dir)
pq_gcc_configuration_flags += --enable-languages=c,c++
pq_gcc_configuration_flags += --disable-bootstrap
pq_gcc_configuration_flags += --disable-multilib
pq_gcc_configuration_flags += --enable-shared
pq_gcc_configuration_flags += --enable-threads=posix
pq_gcc_configuration_flags += --with-tune=generic
pq_gcc_configuration_flags += --disable-libstdcxx

build-stamp: stage-stamp
	$(MAKE) -C gcc-build mkinstalldirs=$(part_dir)
	$(MAKE) -C gcc-build mkinstalldirs=$(part_dir) DESTDIR=$(stage_dir) install
	cp $(source_dir)/dir $(stage_dir)/$(part_dir)/share/info/dir
	touch $@

stage-stamp: configure-stamp

configure-stamp: patch-stamp
	mkdir -p gcc-build
	cd gcc-build &&	../$(pq_part_name)/configure $(pq_gcc_configuration_flags)
	touch $@

patch-stamp: unpack-stamp
	cd $(pq_part_name) && patch -p0 < $(source_dir)/fix-lib-dir-i386.patch
	cd $(pq_part_name) && patch -p0 < $(source_dir)/ar-ranlib-changes.patch
	cd $(pq_part_name) && patch -p0 < $(source_dir)/disable-libcilkrts.patch
	touch $@

unpack-stamp: $(pq_part_file)
	tar xf $(source_dir)/$(pq_part_file)
	touch $@
