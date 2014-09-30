include $(PQ_FACTORY)/factory.mk

$(call show_vars,pq-gmp-dir,pq-mpfr-dir,pq-mpc-dir)
$(call show_vars,LD_LIBRARY_PATH)

pq_part_name := gcc-4.9.1
pq_part_file := $(pq_part_name).tar.bz2

pq_gcc_configuration_flags+= --prefix=$(part_dir)
pq_gcc_configuration_flags+= --with-mpc=$(pq-mpc-dir)
pq_gcc_configuration_flags+= --with-gmp=$(pq-gmp-dir)
pq_gcc_configuration_flags+= --with-mpfr=$(pq-mpfr-dir)
pq_gcc_configuration_flags+= --enable-threads=posix
pq_gcc_configuration_flags+= --enable-shared
pq_gcc_configuration_flags+= --enable-languages=c,c++
pq_gcc_configuration_flags+= --disable-bootstrap

build-stamp: stage-stamp
	$(MAKE) -C gcc-build mkinstalldirs=$(part_dir) && \
	$(MAKE) -C gcc-build mkinstalldirs=$(part_dir) DESTDIR=$(stage_dir) install && \
	touch $@

stage-stamp: configure-stamp

configure-stamp: patch-stamp
	( \
		mkdir -p gcc-build && \
		cd gcc-build && \
		../$(pq_part_name)/configure $(pq_gcc_configuration_flags) \
	) && touch $@

patch-stamp: unpack-stamp
	touch $@

unpack-stamp: $(pq_part_file)
	tar xf $(source_dir)/$(pq_part_file) && touch $@

LIBRARY_PATH       :=/usr/lib/x86_64-linux-gnu
C_INCLUDE_PATH     :=/usr/include/x86_64-linux-gnu
CPLUS_INCLUDE_PATH :=/usr/include/x86_64-linux-gnu
export LIBRARY_PATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH

