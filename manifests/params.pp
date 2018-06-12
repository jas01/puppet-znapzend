# -*- coding: utf-8 -*-
# == Class:  znapzend::params
#
# Cette class
#
# @param
#
# @example
#
# @author <jas01>
#
# === Copyright
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
#Everyone is permitted to copy and distribute verbatim or modified
#copies of this license document, and changing it is allowed as long
#as the name is changed.
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#
#
class znapzend::params {

  case $::osfamily {
    'FreeBSD': {
    $service = 'znapzend'
    $mbuffer_path = '/usr/local/bin/mbuffer'
    }
    'Solaris': {
      $service = 'svc:/pkgsrc/znapzend:default'
      $mbuffer_path = '/opt/tool/bin/mbuffer'
    }
    default: {
      fail("Your ${::osfamily} is not yet supported by this module")
    }
  }
}
