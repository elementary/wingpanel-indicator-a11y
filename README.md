# Wingpanel Universal Access Indicator

## Building and Installation

You'll need the following dependencies:

* meson
* libgranite-dev
* libwingpanel-2.0-dev
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    sudo ninja install
