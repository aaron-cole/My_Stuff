# Class: yum
# ===========================
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
class yum (
    $enable_class              = false,
    $enable_gpg_check          = false,
	$enable_local_pkg_check    = false,
	$enable_clean_requirements = false,
	$target_file               = '/etc/yum.conf',
) {
  # validate type and convert string to boolean if necessary
  if is_string($enable_class) {
    $real_enable_class = str2bool($enable_class)
  } else {
    $real_enable_class = $enable_class
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_gpg_check) {
    $real_enable_gpg_check = str2bool($enable_gpg_check)
  } else {
    $real_enable_gpg_check = $enable_gpg_check
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_local_pkg_check) {
    $real_enable_local_pkg_check = str2bool($enable_local_pkg_check)
  } else {
    $real_enable_local_pkg_check = $enable_local_pkg_check
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_clean_requirements) {
    $real_enable_clean_requirements = str2bool($enable_clean_requirements)
  } else {
    $real_enable_clean_requirements = $enable_clean_requirements
  }

  if $enable_class == true {
   case $::operatingsystem {
    'RedHat','CentOS': {
        if $real_enable_gpg_check == true { 
           ini_setting { 'gpg check':
	         ensure            => present,
		     path              => $target_file,
		     section           => 'main',
		     setting           => 'gpgcheck',
		     value             => '1',
		     key_val_separator => '='
	       }
        } else {
	       ini_setting { 'gpg check':
		     ensure            => present,
		     path              => $target_file,
		     section           => 'main',
		     setting           => 'gpgcheck',
		     value             => '0',
		     key_val_separator => '='
	       }
        }
	  
	    if $real_enable_local_pkg_check == true { 
           ini_setting { 'local pkg check':
	         ensure            => present,
	         path              => $target_file,
	         section           => 'main',
	         setting           => 'localpkg_gpgcheck',
	         value             => '1',
	         key_val_separator => '='
	       }
	    } else {
	       ini_setting { 'local pkg check':
		     ensure            => present,
		     path              => $target_file,
	         section           => 'main',
	         setting           => 'localpkg_gpgcheck',
	         value             => '0',
	         key_val_separator => '='
	       }
	    }
	  
	    if $real_enable_clean_requirements == true { 
           ini_setting { 'clean requirements':
		     ensure            => present,
		     path              => $target_file,
		     section           => 'main',
		     setting           => 'clean_requirements_on_remove',
		     value             => '1',
		     key_val_separator => '='
		   }
	    } else {
	       ini_setting { 'clean requirements':
		     ensure            => present,
		     path              => $target_file,
		     section           => 'main',
		     setting           => 'clean_requirements_on_remove',
		     value             => '0',
		     key_val_separator => '='
		   }
	    }
	  
    }
    default: {
          fail("only supports RedHat/CentOS like systems")
        }
   }
  } else {
    notice('Class disabled.')
    }
}
