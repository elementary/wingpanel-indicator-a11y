# Wingpanel Universal Access Indicator

## Building and Installation

You'll need the following dependencies:

* cmake
* libgranite-dev
* libwingpanel-2.0-dev
* valac

It's recommended to create a clean build environment

    mkdir build
    cd build/
    
Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make
    
To install, use `make install`

    sudo make install
