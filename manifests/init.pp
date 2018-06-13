# Installs & manages znapzend for zfs snapshots
#
# http://www.znapzend.org
#
class znapzend (
  String $service                    = $::znapzend::params::service,
  Stdlib::Absolutepath $mbuffer_path = $::znapzend::params::mbuffer_path,
  Optional[Boolean] $use_mbuffer     = true,
  Optional[String] $tsformat         = '%Y-%m-%dT%H:%M:%SZ',
) inherits znapzend::params
{

  include znapzend::install, znapzend::config, znapzend::service

  Class['znapzend::install'] -> Class['znapzend::config'] ~> Class['znapzend::service']

}
