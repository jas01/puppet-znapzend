# @private Manages znapzend service
class znapzend::service (
  Boolean $enabled = $::znapzend::service_enable,
)
{

  if $enabled {
    if $::osfamily == 'FreeBSD' {
      service { $::znapzend::service :
        hasrestart => false,
        enable     => true,
      }
    }
    else {
      service { $::znapzend::service :
        ensure => 'running',
        enable => true,
      }
    }
  }
}
