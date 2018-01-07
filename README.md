# caius/puppet-znapzend

This module configures [znapzend][] on your node to manage snapshotting zfs datasets.

Include the module to install/setup the service, then lean on `znapzend::dataset_config` to configure the frequency of snapshots for a dataset.

Example:

```puppet
include znapzend

# Take snapshots every 5 minutes for the past hour,
# and store hourly snapshots for the past week
znapzend::dataset_config { 'tank/storage':
  plan => '1hours=>5minutes,1weeks=>1hours',
}
```

[znapzend]: http://www.znapzend.org
