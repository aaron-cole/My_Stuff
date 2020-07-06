# Class: journald_conf
# ===========================
#
# Authors
# -------
#
# Author Name <aaron-cole@outlook.com>
#
# Copyright
# ---------
#
# Copyright 2019 Aaron Cole, unless otherwise noted.
#
class journald_conf (

    $storage             = undef,
    $compress            = undef,
    $seal                = undef,
    $splitmode           = undef,
    $syncintervalsec     = undef,
    $ratelimitinterval   = undef,
    $ratelimitburst      = undef,
    $systemmaxuse        = undef,
    $systemkeepfree      = undef,
    $systemmaxfilesize   = undef,
    $runtimemaxuse       = undef,
    $runtimekeepfree     = undef,
    $runtimemaxfilesize  = undef,
    $maxretentionsec     = undef,
    $maxfilesec          = undef,
    $forwardtosyslog     = undef,
    $forwardtokmsg       = undef,
    $forwardtoconsole    = undef,
    $forwardtowall       = undef,
    $ttypath             = undef,
    $maxlevelstore       = undef,
    $maxlevelsyslog      = undef,
    $maxlevelkmsg        = undef,
    $maxlevelconsole     = undef,
    $maxlevelwall        = undef,
    $linemax             = undef,
	
) {

  $os_name_maj = "${::operatingsystem}-${::operatingsystemmajrelease}"

  case $os_name_maj {
	'RedHat-7','CentOS-7': {
      $service_name_real = 'taniumclient'
    }
	'RedHat-8','CentOS-8': {
      $service_name_real = 'taniumclient'
    }
	default: {
      fail("journald_conf supports osfamilies RedHat7 and RedHat8. Detected OS is <$os_name_maj>.")
    }
  }

 #Deploy Config file
 file { '/etc/systemd/journald.conf':
    notify  => Service['systemd-journald'],
	ensure  => 'file',
    owner   => 'root',
    group   => 'root',
	mode    => '0644',
    content => template('journald_conf/journald.conf.erb'),
  } 

 #Service
 service { 'systemd-journald':
    ensure     => running,
    enable     => true,
  }

}
