# Class: multiplexor
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
class multiplexor (
    
	$enable_rhel6_screen  = true,
	$enable_rhel7_screen  = true,
	$enable_rhel7_tmux    = false,
	$enable_rhel8_tmux    = true,

){

  # validate type and convert string to boolean if necessary
  if is_string($enable_rhel6_screen) {
    $real_enable_rhel6_screen = str2bool($enable_rhel6_screen)
  } else {
    $real_enable_rhel6_screen = $enable_rhel6_screen
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_rhel7_screen) {
    $real_enable_rhel7_screen = str2bool($enable_rhel7_screen)
  } else {
    $real_enable_rhel7_screen = $enable_rhel7_screen
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_rhel7_tmux) {
    $real_enable_rhel7_tmux = str2bool($enable_rhel7_tmux)
  } else {
    $real_enable_rhel7_tmux = $enable_rhel7_tmux
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_rhel8_tmux) {
    $real_enable_rhel8_tmux = str2bool($enable_rhel8_tmux)
  } else {
    $real_enable_rhel8_tmux = $enable_rhel8_tmux
  }
  
  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^6\.*/: {
		    if $real_enable_rhel6_screen == true {
              package { 'screen':
              ensure => 'installed',
			  }
          }
        }
        /^7\.*/: {
            if $real_enable_rhel7_screen == true {
			  package { 'screen':
              ensure => 'installed',
              }
			}
			
			if $real_enable_rhel7_tmux == true {
			  package { 'tmux':
              ensure => 'installed',
              }
			}
        }
		/^8\.*/: {
		    if $real_enable_rhel8_tmux == true {
              package { 'tmux':
              ensure => 'installed',
			  }
          }
        }
        default: {
          fail("only supports RedHat like systems with major release of 6, 7, 8 and you have ${::operatingsystemrelease}")
        }
      }
    }
  }	
}
