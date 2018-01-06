# Configures znapzend to snapshot a ZFS dataset
#
# Configuration is stored as zfs properties on datasets.
#
# @param plan [String] Plan for snapshots to be taken/stored.
#   See Znapzend documentation for valid values.
#
# @example Snapshotting a dataset every 5 minutes for an hour
#
#   znapzend::dataset_config { 'tank/storage':
#     plan => '1hours=>5minutes',
#   }
#
define znapzend::dataset_config(
  $plan,
) {

  $dataset = $title

  zfs_property {
    default:
      dataset => $dataset,
      notify  => Class['znapzend::service'];

    "${dataset}-org.znapzend:pre_znap_cmd":
      property => 'org.znapzend:pre_znap_cmd',
      value    => 'off';

    "${dataset}-org.znapzend:src_plan":
      property => 'org.znapzend:src_plan',
      value    => $plan;

    "${dataset}-org.znapzend:post_znap_cmd":
      property => 'org.znapzend:post_znap_cmd',
      value    => 'off';

    "${dataset}-org.znapzend:zend_delay":
      property => 'org.znapzend:zend_delay',
      value    => '0';

    "${dataset}-org.znapzend:mbuffer":
      property => 'org.znapzend:mbuffer',
      value    => '/opt/tool/bin/mbuffer';

    "${dataset}-org.znapzend:recursive":
      property => 'org.znapzend:recursive',
      value    => 'off';

    "${dataset}-org.znapzend:mbuffer_size":
      property => 'org.znapzend:mbuffer_size',
      value    => '1G';

    "${dataset}-org.znapzend:tsformat":
      property => 'org.znapzend:tsformat',
      value    => '%Y-%m-%dT%H:%M:%SZ';

    "${dataset}-org.znapzend:enabled":
      property => 'org.znapzend:enabled',
      value    => 'on';
  }

}
