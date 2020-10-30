FROM lambci/lambda:provided
FROM lambci/lambda:build-python3.6

ARG TMP_DIR=/tmp
ARG GSF_VERSION=1.14
ARG WV_VERSION=1.2.8
ARG PIXBUF_VERSION=2.22
ARG SVG_VERSION=2.26
ARG ATK_VERSION=2.2
ARG GTK_VERSION=2.24
ARG FRIBIDI_VERSION=0.10.4
ARG ABIWORD_VERSION=3.0.4

ARG GSFPREFIX=/opt
ARG WVPREFIX=/opt
ARG ABIPREFIX=/opt

RUN yum groupinstall -y "Development Tools"

RUN yum install -y \
    boost-devel \
    cairo-devel \
    pango-devel \
    pango \
    rust \
    rust-std-static \
    cargo \
    cairo*

#### Gsf
WORKDIR ${TMP_DIR}/gsf
RUN curl -L ftp://ftp.gnome.org/pub/GNOME/sources/libgsf/${GSF_VERSION}/libgsf-${GSF_VERSION}.46.tar.xz | tar -xJ
RUN cd libgsf-${GSF_VERSION}.46  && ./configure --prefix=${GSFPREFIX} --disable-static --disable-gtk-doc-html \
 && make && make install
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${GSFPREFIX}/lib/pkgconfig

#### Wv
WORKDIR ${TMP_DIR}/wv
RUN curl -L  https://www.abisource.com/downloads/wv/${WV_VERSION}/wv-${WV_VERSION}.tar.gz  | tar -xz
RUN cd wv-${WV_VERSION} && ./configure --prefix=${WVPREFIX} && make && make install
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${WVPREFIX}/lib/pkgconfig

#### FriBidi
ARG FRIBIDIPREFIX=/opt
WORKDIR ${TMP_DIR}/fribidi
RUN curl -L https://sourceforge.net/projects/fribidi/files/FriBidi/${FRIBIDI_VERSION}/fribidi-${FRIBIDI_VERSION}.tar.gz | tar -xz
RUN cd fribidi-${FRIBIDI_VERSION} && ./configure --prefix=${FRIBIDIPREFIX} && make && make install
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIBIDIPREFIX}/lib/pkgconfig

#### Pixbuf
ARG PIXBUFPREFIX=/opt
WORKDIR ${TMP_DIR}/pixbuf
RUN curl -L http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${PIXBUF_VERSION}/gdk-pixbuf-${PIXBUF_VERSION}.0.tar.gz | tar -xz
RUN cd gdk-pixbuf-${PIXBUF_VERSION}.0 && ./configure --prefix=${PIXBUFPREFIX} && make && make install && ldconfig
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${PIXBUFPREFIX}/lib/pkgconfig:${PIXBUFPREFIX}/bin/gdk-pixbuf-csource

### Svg
ARG SVGPREFIX=/opt
WORKDIR ${TMP_DIR}/svg
RUN curl -L http://ftp.acc.umu.se/pub/gnome/sources/librsvg/${SVG_VERSION}/librsvg-${SVG_VERSION}.1.tar.gz | tar -xz
RUN cd librsvg-${SVG_VERSION}.1 && ./configure --prefix=${SVGPREFIX} && make && make install
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${SVGPREFIX}/lib/pkgconfig

#### Atk
ARG ATKPREFIX=/opt
WORKDIR ${TMP_DIR}/atk
RUN curl -L http://ftp.gnome.org/pub/gnome/sources/atk/${ATK_VERSION}/atk-${ATK_VERSION}.0.tar.xz | tar -xJ
RUN cd atk-${ATK_VERSION}.0 && ./configure --prefix=${ATKPREFIX} && make && make install
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${ATKPREFIX}/lib/pkgconfig

### Gtk2
ARG GTKPREFIX=/opt
WORKDIR ${TMP_DIR}/gtk
ENV PATH=$PATH:${PIXBUFPREFIX}/bin/gdk-pixbuf-csource
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${GTKPREFIX}/lib/pkgconfig
ENV GDK_PIXBUF_CSOURCE=${PIXBUFPREFIX}/bin/gdk-pixbuf-csource
RUN curl -L https://download.gnome.org/sources/gtk+/${GTK_VERSION}/gtk+-${GTK_VERSION}.10.tar.xz | tar -xJ
RUN cd gtk+-${GTK_VERSION}.10 && ./configure --prefix=${GTKPREFIX}  && make && make install

### Abiword
WORKDIR ${TMP_DIR}/abiword
ENV PATH=$PATH:/opt/bin/gtk-update-icon-cache
RUN curl -L https://www.abisource.com/downloads/abiword/${ABIWORD_VERSION}/source/abiword-${ABIWORD_VERSION}.tar.gz | tar -xz
RUN cd abiword-${ABIWORD_VERSION} && ./configure --prefix=${ABIPREFIX} --disable-default-plugins --disable-print --disable-spell --with-gtk2 && \
    make && make install

RUN cp /usr/lib64/libpango* /opt/lib/

RUN /opt/bin/abiword --help
