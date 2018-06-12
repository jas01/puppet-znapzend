# @private Manages znapzend service
class znapzend::service {

  service { $::znapzend::service :
    ensure => 'running',
    enable => true,
  }

}
