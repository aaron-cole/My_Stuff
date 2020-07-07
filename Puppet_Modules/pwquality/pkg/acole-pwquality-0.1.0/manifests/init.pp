# Class: pwquality
# This module will allow you to configure the root user's password
#
# Authors
# -------
#
# Author Name <aaron-cole@outlook.com>
#
# Copyright
# ---------
#
# Copyright 2020 Aaron Cole, unless otherwise noted.
#
class pwquality (

    $package_manage         = true,
    $package_ensure         = 'installed',
    $package_name           = 'libpwquality',
    $config_file_name       = '/etc/security/pwquality.conf',
    $config_file_owner      = 'root',
    $config_file_group      = 'root',
    $config_file_mode       = '0644',
    $difok                  = '8',
    $minlen                 = '16',
    $dcredit                = '-2',
    $ucredit                = '-2',
    $lcredit                = '-2',
    $ocredit                = '-2',
    $minclass               = '4',
    $maxrepeat              = '3',
    $maxclassrepeat         = '4', 
    $gecoscheck             = undef,
    $dictcheck              = '1',
    $usercheck              = '1',
    $enforcing              = undef,
    $dictpath               = undef,

) {

  $os_name_maj = "${::operatingsystem}-${::operatingsystemmajrelease}"
  
 case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        '7': {
          $template_file = 'pwquality_el7.erb'
        }
        '8': {
          $template_file = 'pwquality_el8.erb'  
        }
        default: {
          fail("pwquality supports RedHat7 and RedHat8. Detected OS is <$os_name_maj>.")
 	    }
      }
	}
    default: {
      fail("pwquality supports osfamilies RedHat7 and RedHat8. Detected OS is <$os_name_maj>.")
    }
  }

 #Install Package
 if $my_package_manage {
    package { $package_name:
      ensure   => $package_ensure,
      name     => $package_name,
	  before   => File['pwquality_conf'],
    }
  }

  file { 'pwquality_conf':
    ensure  => file,
    path    => $config_file_name,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    content => template("${module_name}/${template_file}"),
  }

}
