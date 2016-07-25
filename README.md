OpenHPC Installer
=================

Installer for OpenHPC Cluster recipes.
It relies on openhpc-* modules. They are not included in this repository.

1. Install this repository
```
cd /var/tmp
curl -L -s https://github.intel.com/jdlugole/openhpc-installer/archive/master.tar.gz | tar -zx
cd openhpc-installer-master
```

# 2. Install Puppet Agent and all required modules
```
cd /var/tmp/openhpc-installer-master
install.sh
```

# 3. Run Puppet to configure your server

Modify `hieradata/default.yaml` configuration file, and run script:
```
run-puppet.sh
```
