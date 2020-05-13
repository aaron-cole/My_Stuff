# Class: shadow
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
class shadow (
    $enable_libuser_crypt_style  = true,
	$libuser_crypt_style_setting = 'sha512',
	$enable_useradd_settings     = true,
	$useradd_group               = '100',
	$useradd_home                = '/home',
	$useradd_inactive            = '0',
	$useradd_expire              = '-1',
	$useradd_shell               = '/bin/bash',
	$useradd_skel                = '/etc/skel',
	$useradd_create_mail_spool   = 'yes',
	$enable_login_defs_settings  = true,
	$login_defs_mail_dir         = '/var/spool/mail',
	$login_defs_pass_max_days    = '60',
	$login_defs_pass_min_days    = '1',
	$login_defs_pass_min_length  = '15',
	$login_defs_pass_warn_age    = '7',
	$login_defs_create_home      = 'yes',
	$login_defs_umask            = '077',
	$login_defs_usergroups_enab  = 'yes',
	$logins_defs_encrypt_method  = 'SHA512',
	$logins_defs_fail_delay      = '4',
	$set_shadow_perms            = true,
	$set_passwd_perms            = true,
	$set_group_perms             = true,
	$set_gshadow_perms           = true,
) {

  # validate type and convert string to boolean if necessary
  if is_string($enable_login_defs_settings) {
    $real_enable_login_defs_settings = str2bool($enable_login_defs_settings)
  } else {
    $real_enable_login_defs_settings = $enable_login_defs_settings
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_useradd_settings) {
    $real_enable_useradd_settings = str2bool($enable_useradd_settings)
  } else {
    $real_enable_useradd_settings = $enable_useradd_settings
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($set_shadow_perms) {
    $real_set_shadow_perms = str2bool($set_shadow_perms)
  } else {
    $real_set_shadow_perms = $set_shadow_perms
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($set_passwd_perms) {
    $real_set_passwd_perms = str2bool($set_passwd_perms)
  } else {
    $real_set_passwd_perms = $set_passwd_perms
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_libuser_crypt_style) {
    $real_enable_libuser_crypt_style = str2bool($enable_libuser_crypt_style)
  } else {
    $real_enable_libuser_crypt_style = $enable_libuser_crypt_style
  }

  # validate type and convert string to boolean if necessary
  if is_string($set_group_perms) {
    $real_set_group_perms = str2bool($set_group_perms)
  } else {
    $real_set_group_perms = $set_group_perms
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($set_gshadow_perms) {
    $real_set_gshadow_perms = str2bool($set_gshadow_perms)
  } else {
    $real_set_gshadow_perms = $set_gshadow_perms
  }
  
  if $real_enable_libuser_crypt_style == true { 
    file { '/etc/libuser.conf':
	  ensure  => 'present',
	  owner   => 'root',
      group   => 'root',
      mode    => '0644',
	} 
	
	ini_setting { 'libuser crypt style':
	  ensure            => present,
	  path              => '/etc/libuser.conf',
	  section           => 'defaults',
	  setting           => 'crypt_style',
	  value             => $libuser_crypt_style_setting,
	}
  }

  if $real_enable_useradd_settings == true { 
    file { '/etc/default/useradd':
	  ensure  => 'present',
	  owner   => 'root',
      group   => 'root',
      mode    => '0600',
	} 
	
	ini_setting { 'useradd group':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'GROUP',
	  value             => $useradd_group,
	}

	ini_setting { 'useradd home':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'HOME',
	  value             => $useradd_home,
	}
	
	ini_setting { 'useradd inactive':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'INACTIVE',
	  value             => $useradd_inactive,
	}
	
	ini_setting { 'useradd expire':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'EXPIRE',
	  value             => $useradd_expire,
	}

	ini_setting { 'useradd shell':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'SHELL',
	  value             => $useradd_shell,
	}

	ini_setting { 'useradd skel':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'SKEL',
	  value             => $useradd_skel,
	}

	ini_setting { 'useradd create mail spool':
	  ensure            => present,
	  path              => '/etc/default/useradd',
	  section           => '',
	  key_val_separator => '=',
	  setting           => 'CREATE_MAIL_SPOOL',
	  value             => $useradd_create_mail_spool,
	}	
  }

  if $real_enable_login_defs_settings == true {
	file { '/etc/login.defs':
	  ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
	  content => template("${module_name}/${template_dir}/login.defs.erb"),
	}
  }
  
  if $real_set_shadow_perms == true {
	file { '/etc/shadow':
	  ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0000',
	}
  }

  if $real_set_passwd_perms == true {
	file { '/etc/passwd':
      ensure  => 'present',
	  owner   => 'root',
      group   => 'root',
      mode    => '0644',
	}
  }  

  if $real_set_group_perms == true {
	file { '/etc/group':
      ensure  => 'present',
	  owner   => 'root',
      group   => 'root',
      mode    => '0644',
	}
  }
  
  if $real_set_gshadow_perms == true {
	file { '/etc/gshadow':
      ensure  => 'present',
	  owner   => 'root',
      group   => 'root',
      mode    => '0000',
	}
  }  
}
