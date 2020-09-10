# Class: modprobe
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
# Copyright 2020 Your name here, unless otherwise noted.
#
class modprobe (

    $enable_modprobe	= false,
	$blacklist_rhel6    = ['usb-storage',
						   'dccp',
						   'sctp',
						   'rds',
						   'tipc',
                           'net-pf-31',
                           'bluetooth'],
	$blacklist_rhel7	= ['usb-storage',
                           'dccp'],
	$blacklist_rhel8    = ['uvcvideo',
                           'usb-storage'],
	$file_name			= '/etc/modprobe.d/blacklist.conf',
	$file_owner			= 'root',
	$file_group			= 'root',
	$file_mode			= '644',
	
) {
  # validate type and convert string to boolean if necessary
  if is_string($enable_modprobe) {
    $real_enable_modprobe = str2bool($enable_modprobe)
  } else {
    $real_enable_modprobe = $enable_modprobe
  } 

 if $real_enable_modprobe == true {  
 
  case $::osfamily {
    'RedHat': {
	  case $::operatingsystemrelease {
	    /^6\.*/: {
		  validate_array($blacklist_rhel6)
          $real_blacklist = $blacklist_rhel6
        }
        /^7\.*/: {
          validate_array($blacklist_rhel7)
          $real_blacklist = $blacklist_rhel7
        }
		/^8\.*/: {
          validate_array($blacklist_rhel8)
          $real_blacklist = $blacklist_rhel8		  
        }
		default: {
          fail("modprobe supports RedHat like systems with major release of 5, 6, 7 and 8 and you have ${::operatingsystemrelease}")
		}
	  }
	}
	default: {
      fail("modprobe supports osfamilies RedHat. Detected osfamily is ${::osfamily}")
    }
  }
  
  validate_array($real_blacklist)
  
  file { 'blacklist.conf':
    ensure  => file,
    path    => $file_name,
    owner   => $file_owner,
    group   => $file_group,
    mode    => $file_mode,
    content => template('modprobe/blacklist.erb'),
  }
  
 } 
}
