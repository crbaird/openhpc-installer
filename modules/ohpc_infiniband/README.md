# OpenHPC ohpc_infiniband Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with base](#setup)
3. [Parameters](#parameters)

## Overview

The module adds OpenHPC OFED and PSM support

## Setup

### Beginning with base
To install OFED and PSM OpenHPC packages and enable `rdma` service, specify:
```puppet
include ::ohpc_infiniband
```

### Enabling IPoIB

To enable IP over InfiniBand, specify `sms_ipoib` and `ipoib_netmask` parameters:

```puppet
class { 'ohpc_infiniband':
  sms_ipoib     => $sms_ipoib,
  ipoib_netmask => $ipoib_netmask,
}
```

## Parameters

### `sms_ipoip`

IPoIB IP address

### `ipoib_netmask`

IPoIB IP network mask
