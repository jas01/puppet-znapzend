# Configures znapzend to snapshot a ZFS dataset
#
# Configuration is stored as zfs properties on datasets.
#
# @param plan [String] Plan for snapshots to be taken/stored.
#   See Znapzend documentation for valid values.
#
# @param src_plan [String] Same as plan.
#
# @param enable [Boolean] default true, define if znapzend should take this dataset
# enable for znapzend or not
#
# @param resursive [on/off] define if the znapzend should take recursive snapshot/send, default: off
#
# @param mbuffer_size [String] The size of mbuffer, default: 1G
#
# @param dst_plan [Hash] A hash who define the dst_plan
#
# @example Snapshotting a dataset every 5 minutes for an hour
#
#   znapzend::dataset_config { 'tank/storage':
#     plan => '1hours=>5minutes',
#   }
#
# @example DST : For something like the example inside znapzend
#    znapzendzetup create --recursive --mbuffer=/opt/omni/bin/mbuffer \
#       --mbuffersize=1G --tsformat='%Y-%m-%d-%H%M%S' \
#       --pre-snap-command="/bin/sh /usr/local/bin/lock_flush_db.sh" \
#       --post-snap-command="/bin/sh /usr/local/bin/unlock_db.sh" \
#       SRC '7d=>1h,30d=>4h,90d=>1d' tank/home \
#       DST:a '7d=>1h,30d=>4h,90d=>1d,1y=>1w,10y=>1month' backup/home \
#       DST:b '7d=>1h,30d=>4h,90d=>1d,1y=>1w,10y=>1month' root@bserv:backup/home
#
# you should
#
#  znapzend::dataset_config ( 'tank/storage':
#    src_plan          => '7d=>1h,30d=>4h,90d=>1d',
#    recursive         => 'on'
#    mbuffer_path      => '/opt/omni/bin/mbuffer',
#    mbuffer_size      => '1G',
#    tsformat          => '%Y-%m-%d-%H%M%S',
#    pre-snap-command  => '/bin/sh /usr/local/bin/lock_flush_db.sh',
#    post-snap-command => '/bin/sh /usr/local/bin/unlock_db.sh',
#    dst_plan          => { 'a' => { plan => '7d=>1h,30d=>4h,90d=>1d,1y=>1w,10y=>1month', target => 'backup/home' },
#                           'b' => { plan => '7d=>1h,30d=>4h,90d=>1d,1y=>1w,10y=>1month', target => 'root@bserv:backup/home' }
#                          }
#  }
#
define znapzend::dataset_config(
  Boolean $enable = true,
  Enum['On','Off','on','off'] $recursive = 'off',
  String $mbuffer_size = '1G',
  String $mbuffer_path = $::znapzend::mbuffer_path,
  Optional[String] $pre_snap_command = 'off',
  Optional[String] $post_snap_command = 'off',
  Optional[String] $tsformat = $::znapzend::tsformat,
  Optional[Hash] $dst_plan = undef,
  Optional[String] $src_plan = undef,
  Optional[String] $plan = undef,

) {

  $dataset = $title

  # To keep the compatibility with old variable plan

  if $plan == undef and $src_plan == undef {
    fail('plan and src_plan cannot by both undef')
  }


  if $src_plan != undef {
    $_src_plan = $src_plan
  }
  else {
    $_src_plan = $plan
  }

  if $enable {
    $enabled = 'on'
  }
  else
  {
    $enabled = 'off'
  }

  $_recursive = downcase($recursive)

  # Main properties

  zfs_property {
    default:
      dataset => $dataset,
      notify  => Class['znapzend::service'];

    "${dataset}-org.znapzend:pre_znap_cmd":
      property => 'org.znapzend:pre_znap_cmd',
      value    => $pre_snap_command;

    "${dataset}-org.znapzend:src_plan":
      property => 'org.znapzend:src_plan',
      value    => $_src_plan;

    "${dataset}-org.znapzend:post_znap_cmd":
      property => 'org.znapzend:post_znap_cmd',
      value    => $post_snap_command;

    "${dataset}-org.znapzend:zend_delay":
      property => 'org.znapzend:zend_delay',
      value    => '0';

    "${dataset}-org.znapzend:mbuffer":
      property => 'org.znapzend:mbuffer',
      value    => $::znapzend::mbuffer_path;

    "${dataset}-org.znapzend:recursive":
      property => 'org.znapzend:recursive',
      value    => $_recursive;

    "${dataset}-org.znapzend:mbuffer_size":
      property => 'org.znapzend:mbuffer_size',
      value    => $mbuffer_size;

    "${dataset}-org.znapzend:tsformat":
      property => 'org.znapzend:tsformat',
      value    => $tsformat;

    "${dataset}-org.znapzend:enabled":
      property => 'org.znapzend:enabled',
      value    => $enabled;
  }

  # Properties for each dst

  $dst_plan.each | String $key, Hash $config | {
    zfs_property {
      default:
        dataset => $dataset,
        notify  => Class['znapzend::service'];

      "${dataset}-org.znapzend:dst_${key}":
        property => "org.znapzend:dst_${key}",
        value    => $config['target'];

      "${dataset}-org.znapzend:dst_${key}_plan":
        property => "org.znapzend:dst_${key}_plan",
        value    => $config['plan'];
    }
  }
}
