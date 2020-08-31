# Class: axon_agent
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
class axon_agent (

    $enable_axon_agent         = false,
    $package_manage            = true,
    $package_ensure            = 'installed',
    $package_name              = 'axon-agent',
    $service_manage            = true,
    $service_ensure            = running,
    $service_enable            = true,
    $registration_key          = undef,
    $registration_filename     = 'registration_pre_shared_key.txt',
    $config_path               = '/etc/tripwire',
	$dns_service_name          = undef,
	$dns_service_domain        = undef,
	$bridge_host               = undef,
	$bridge_port               = undef,
	$bridge_auth_mode          = undef,
	$socks5_host               = undef,
	$socks5_port               = undef,
	$socks5_user_name          = undef,
	$socks5_user_password      = undef,
	$tls_version               = undef,
	$tls_cipher_suites         = undef,
	$spool_size_max            = undef,
	$log4cplus_logger_twagent  = undef,

) {

  # validate type and convert string to boolean if necessary
  if is_string($enable_axon_agent) {
    $real_enable_axon_agent = str2bool($enable_axon_agent)
  } else {
    $real_enable_axon_agent = $enable_axon_agent
  } 

 if $real_enable_axon_agent == true {
 
 #Install Package
 if $package_manage {
    package { 'Axon Agent':
      ensure   => $package_ensure,
      name     => $package_name,
	  before   => Service['tripwire-axon-agent'],
    }
  }

 #Manage Service
 if $service_manage {
    service { 'tripwire-axon-agent':
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
 }

 #Files
 if $registration_key {
   # The agent will delete the registration key on startup, and we don't want
   # puppet re-creating it every time. There isn't a way to conditionally
   # create a file, so we have to use an exec command with a condition.
   $cmd = $facts['kernel'] ? {
      default => "/bin/echo \"${registration_key}\" > ${config_path}/${registration_filename}",
    }
    exec { 'echo_key':
      command => $cmd,
      # not exactly...
      creates => "${config_path}/${registration_filename}.done",
    }
    file { 'key.done':
      ensure => file,
      path   => "${config_path}/${registration_filename}.done",
    }
    Exec['echo_key'] -> File['key.done']
  }

  file { 'twagent.conf':
    ensure  => file,
    notify  => Service['tripwire-axon-agent'],
	owner   => 'root',
    group   => 'root',
	mode    => '0600',
	path    => "${config_path}/twagent.conf",
    content => template('axon_agent/twagent_conf.erb'),
  }

 } 
}
