# @private Manages znapzend service
class znapzend::service {

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
