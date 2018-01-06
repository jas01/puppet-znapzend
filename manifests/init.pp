# Installs & manages znapzend for zfs snapshots
#
# http://www.znapzend.org
#
class znapzend {

  include znapzend::install, znapzend::config, znapzend::service

  Class['znapzend::install'] -> Class['znapzend::config'] ~> Class['znapzend::service']

}
