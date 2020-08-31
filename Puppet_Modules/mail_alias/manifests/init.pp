# Class: mail_alias
# ===========================
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2020 Your name here, unless otherwise noted.
#
class mail_alias (
    $enable_mail_alias  = false,
	$alias_file         = '/etc/aliases',
	$alias_owner        = 'root',
	$alias_group        = 'root',
	$alias_mode         = '0644',
	$roots_alias        = undef,

) {
  
  if $::osfamily != 'RedHat' {
    fail("mail_alias supports osfamilies RedHat only. Detected OS Family is <$::osfamily>.")
  }
	
  #Validate type and fail if not string or array
  if !is_string($roots_alias) and !is_array($roots_alias) {
    fail('<$roots_alias> must be a string or an array.')
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_mail_alias) {
    $real_enable_mail_alias = str2bool($enable_mail_alias)
  } else {
    $real_enable_mail_alias = $enable_mail_alias
  }

#Only do if this module is enabled  
 if $real_enable_mail_alias == true {

  if $alias_file == undef {
    fail ("alias_file has to be defined. Currently set to <$alias_file>.")
  }
  
  if $roots_alias == undef {
    $alias_ensure = 'absent'
	} else {
    $alias_ensure = 'present'
	}

  #Make sure file is right
  file { $alias_file:
	ensure  => 'present',
	owner   => $alias_owner,
    group   => $alias_group,
    mode    => $alias_mode,
  }

  #Check root alias and set if required
  if $::root_mail_alias != $roots_alias {
	
	ini_setting { 'root_setting':
	  ensure            => $alias_ensure,
	  path              => $alias_file,
	  section           => '',
	  key_val_separator => ':',
	  setting           => 'root',
	  value             => $roots_alias,
	}
  
    exec { 'execute_newaliases':
       command => "/usr/bin/newaliases"
    }
  }

 }
}
