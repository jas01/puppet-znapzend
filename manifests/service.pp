# @private Manages znapzend service
class znapzend::service {

  service { 'svc:/pkgsrc/znapzend:default':
    ensure => 'running',
  }

}
