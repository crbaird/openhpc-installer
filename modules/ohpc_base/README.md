# ohpc_base

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with base](#setup)
3. [Usage - Configuration options and additional functionality](#usage)

## Overview

The module provides base configuration for all OpenHPC modules:
 * Enables OpenHPC yum/zypper repositories
 * Configures NTP
 * Defines `yumgroup` resource to install OpenHPC package groups

## Setup

### Beginning with base

The module enables EPEL and OpenHPC repositories. It also installs `ohpc-base` package group.

```puppet
include '::ohpc_base'
```

## Usage

### I want the recommended configuration

The recommended way is to let the module configure NTP daemon for you.
You will have to specify your NTP servers.

```puppet
class { 'ohpc_base':
  manage_epel => true,
  manage_ntp  => true,
  ntp_servers => [ 'ntp-host1', 'ntp-host2' ]
}
```

### Installing groups of packages

OpenHPC packages are distributed in `yum groups`.
To make puppet run `yum groupinstall ohpc-base`, specify:
```puppet
ohpc_base::yumgroup { 'ohpc-base':
}
```
Puppet will run the `yum groupinstall ohpc-base` only if this group is not installed yet.
