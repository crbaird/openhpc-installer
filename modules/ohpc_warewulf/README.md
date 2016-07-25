# OpenHPC ohpc_warewulf Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with base](#setup)
3. [Parameters](#parameters)

## Overview

The module configures OpenHPC Warewulf and enables all required services.

## Setup

### Beginning with base

```
class { 'ohpc_warewulf':
  sms_eth_internal => $sms_eth_internal,
  sms_ip           => $sms_ip,
  internal_netmask => $internal_netmask,
  manage_firewall  => $manage_firewall,
}
```

## Parameters

### `sms_eth_internal`

Internal Ethernet interface on SMS

### `sms_ip`

Internal IP address on SMS server

### `internal_netmask`

Subnet netmask for internal network

### `manage_firewall`

`true`/`false` - tells the module whether to manage firewall settings or not
