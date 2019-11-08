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
class sysadmin_tools {

Package { ensure => 'installed' }

$packages = [ 'sysstat', 'lsof', 'mcelog', 'rasdaemon', 'strace', 'ltrace', 'valgrind', 'setools-console', 'setroubleshoot-server', 'iotop', 'procps-ng', 'acpid', 'blktrace', 'dstat', 'curl', 'wget', 'iperf', 'mtr', 'iputils', 'ethtool', 'traceroute', 'iptraf-ng', 'nmap-ncat' ]

package { $packages: }

}
