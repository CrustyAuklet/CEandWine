# CEandWine
Docker container for running Compiler Explorer, with Wine installed for running EWAVR

## Instructions for running with EWAVR

This image runs a local instance of compiler explorer.

To get the most use out of this image you should mount two volumes:

    A directory containing all the compilers and libraries you want to use
    a config file(s) to /compiler_explorer/etc/config/<name_of_config_file>

currently I am using the command

docker run --restart=always -d --name compiler_explorer \
-v /opt/compiler_explorer:/opt/compiler_explorer \
-v /opt/compiler_explorer/c++.local.properties:/compiler-explorer/etc/config/c++.local.properties \
-p 80:10240 crustyauklet/compiler_explorer \
/bin/bash -c "/opt/compiler_explorer/compilers/ewavr_7108/common/bin/LightLicenseManager setup -s ${IAR_SERVER} && make"

this mounts the c++ local config file, all my compilers and libraries to the expected location from that config file (/opt/compiler_explorer). It also runs a command to register the IAR compilers on the new image BEFORE running make to start the instance.
