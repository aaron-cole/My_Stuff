# Class: sysadmin_tools
# ===========================
#
# Install basic SysAdmin tools for diagnosising server and application
# issues.
#
# 
#
# Authors
# -------
#
# Author Name <aaron.cole06@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2019 Aaron Cole, unless otherwise noted.
#
class sysadmin_tools (

  $enable_sysadmin_tools = 'false',

)
{

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^6\.*/: {
          $packages = [ 'sysstat', 'lsof', 'mcelog', 'strace', 'ltrace', 'valgrind', 'setools-console', 'setroubleshoot-server', 'iotop', 'acpid', 'blktrace', 'dstat', 'curl', 'wget', 'mtr', 'iputils', 'ethtool', 'traceroute' ]
        }
        /^7\.*/: {
          $packages = [ 'sysstat', 'lsof', 'mcelog', 'rasdaemon', 'strace', 'ltrace', 'valgrind', 'setools-console', 'setroubleshoot-server', 'iotop', 'procps-ng', 'acpid', 'blktrace', 'dstat', 'curl', 'wget', 'mtr', 'iputils', 'ethtool', 'traceroute', 'iptraf-ng', 'nmap-ncat' ]
        }
		/^8\.*/: {
          $packages = [ 'sysstat', 'lsof', 'mcelog', 'rasdaemon', 'strace', 'ltrace', 'valgrind', 'setools-console', 'setroubleshoot-server', 'iotop', 'procps-ng', 'acpid', 'blktrace', 'dstat', 'curl', 'wget', 'mtr', 'iputils', 'ethtool', 'traceroute', 'iptraf-ng', 'nmap-ncat' ]
        }
        default: {
          fail("only supports RedHat like systems with major release of 6, 7, 8 and you have ${::operatingsystemrelease}")
        }
      }
    }
  }
  
  if $enable_sysadmin_tools == true {
     Package { ensure => 'installed' }
	 package { $packages: }
  }
}
