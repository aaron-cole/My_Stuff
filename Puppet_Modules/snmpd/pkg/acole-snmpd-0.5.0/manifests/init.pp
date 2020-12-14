# Class: snmpd
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
# Copyright 2020 Aaron Cole, unless otherwise noted.
#
class snmpd (
    
    $enable_snmpd                        = false,
    $package_manage                      = true,
    $package_ensure                      = 'installed',
    $package_name                        = ['net-snmp','net-snmp-utils','net-snmp-devel'],
    $service_manage                      = true,
    $service_ensure                      = running,
    $service_enable                      = true,
	$service_name                        = 'snmpd',
    $config_file_name                    = '/etc/snmp/snmpd.conf',
    $config_file_owner                   = 'root',
    $config_file_group                   = 'root',
    $config_file_mode                    = '0600',
    $config_file_environment             = undef,
	$config_file_location                = undef,
	$config_file_contact                 = undef,
	$config_file_sysservices             = '76',
	$config_file_load                    = '10 12 15',
    $config_file_pass                    = '.1.3.6.1.4.1.4413.4.1 /usr/bin/ucd5820stat',
	$snmpv3_user                         = undef,
	$snmpv3_perms                        = 'ro',
	$snmpv3_auth_type                    = 'SHA',
	$snmpv3_priv_type                    = 'AES',
	$snmpv3_auth_pass                    = 'undef',
	$snmpv3_priv_pass                    = 'undef',
	$snmpv3_cmd                          = '/usr/bin/net-snmp-config',
    $var_net_snmp                        = '/var/lib/net-snmp',
    $varnetsnmp_owner                    = 'root',
    $varnetsnmp_group                    = 'root',

){

 #We only support RHEL 7/8
  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^7\.*/: {
         $os_release = $::operatingsystemrelease
        }
		/^8\.*/: {
         $os_release = $::operatingsystemrelease
        }
        default: {
          fail("snmpd supports RedHat like systems with major release of 7 and 8 and you have ${::operatingsystemrelease}")
        }
	  }
    }
  } 
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_snmpd) {
    $real_enable_snmpd = str2bool($enable_snmpd)
  } else {
    $real_enable_snmpd = $enable_snmpd
  } 

 if $real_enable_snmpd == true {


  # validate type and convert string to boolean if necessary
  if is_string($package_manage) == true {
    $my_package_manage = str2bool($package_manage)
  } else {
    $my_package_manage = $package_manage
  }

  # validate type and convert string to boolean if necessary
  if is_string($service_manage) == true {
    $my_service_manage = str2bool($service_manage)
  } else {
    $my_service_manage = $service_manage
  }

  # validate type and convert string to boolean if necessary
  if is_string($service_enable) == true {
    $my_service_enable = str2bool($service_enable)
  } else {
    $my_service_enable = $service_enable
  } 
  
   #Install Package
  if $my_package_manage {
    package { $package_name:
      ensure   => $package_ensure,
	  before   => File['snmpd_conf'],
    }
  }

  file { 'snmpd_conf':
    ensure  => file,
    path    => $config_file_name,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
  }
  
  if $config_file_contact != undef {
   ini_setting { 'sys contact':
	  ensure            => present,
	  path              => $config_file_name,
	  section           => '',
	  key_val_separator => '  ',
	  setting           => 'syscontact',
	  value             => $config_file_contact,
    }  
   }

  if ($config_file_location != undef) and ($config_file_environment != undef) {
   $real_location = "${config_file_location} ${config_file_environment}"
   ini_setting { 'sys location':
	  ensure            => present,
	  path              => $config_file_name,
	  section           => '',
	  key_val_separator => '  ',
	  setting           => 'syslocation',
	  value             => $real_location,
    }  
   }

  if $config_file_sysservices != undef {
   ini_setting { 'sysservices':
	  ensure            => present,
	  path              => $config_file_name,
	  section           => '',
	  key_val_separator => ' ',
	  setting           => 'sysservices',
	  value             => $config_file_sysservices,
    }  
   }

  if $config_file_load != undef {
   ini_setting { 'load':
	  ensure            => present,
	  path              => $config_file_name,
	  section           => '',
	  key_val_separator => ' ',
	  setting           => 'load',
	  value             => $config_file_load,
    }  
   }

  if $config_file_pass != undef {
   ini_setting { 'pass':
	  ensure            => present,
	  path              => $config_file_name,
	  section           => '',
	  key_val_separator => '  ',
	  setting           => 'pass',
	  value             => $config_file_pass,
    }  
   }   
  
  if $service_manage {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
  
  if $snmpv3_user != undef {
    
	$cmd = $snmpv3_priv_pass ? {
    undef   => "createUser ${snmpv3_user} ${snmpv3_auth_type} \"${snmpv3_auth_pass}\"",
    default => "createUser ${snmpv3_user} ${snmpv3_auth_type} \"${snmpv3_auth_pass}\" ${snmpv3_priv_type} \"${snmpv3_priv_pass}\""
    }

    if ($snmpv3_user in $facts['snmpv3_user']) {
      # user details from config are available as fact
      $usm_user = $facts['snmpv3_user'][$snmpv3_user]

      $authhash = snmpd::snmpv3_usm_hash($snmpv3_auth_type, $usm_user['engine'], $snmpv3_auth_pass)

      # privacy protocol key may be empty; truncate to 128 bits if used
      $privhash = empty($snmpv3_priv_pass) ? {
        true    => '',
        default => snmpd::snmpv3_usm_hash($snmpv3_auth_type, $usm_user['engine'], $snmpv3_priv_pass, 128)
      }
      # (re)create the user if at least one of the hashes is different
      $create = ($authhash != $usm_user['authhash']) or ($privhash != $usm_user['privhash'])
    } else {
    # user is unknown
    $create = true
    }
	
	if $create {
      unless defined(Exec["stop-${service_name}"]) {
      $command = $facts['service_provider'] ? {
        'systemd' => "systemctl stop ${service_name}; sleep 5",
        default   => "service ${service_name} stop ; sleep 5",
      }

      exec { "stop-${service_name}":
        command => $command,
        user    => 'root',
        cwd     => '/',
        path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      }
    }

    unless defined(File["${snmpd::var_net_snmp}/${service_name}.conf"]) {
      #
      # For this file there is no content defined since the SNMP daemon
      # rewrites the content on exit. But the file needs to exist or the
      # following file_line resource will fail.
      #
      file { "${snmpd::var_net_snmp}/${service_name}.conf":
        ensure => file,
        mode   => '0600',
        owner  => $snmpd::varnetsnmp_owner,
        group  => $snmpd::varnetsnmp_group,
      }
    }

    file_line { "create-snmpv3-user-${snmpv3_user}":
      path      => "${snmpd::var_net_snmp}/${service_name}.conf",
      line      => $cmd,
      match     => "^createUser ${snmpv3_user} ",
      subscribe => Exec["stop-${service_name}"],
      before    => Service[$service_name],
    }
   }
	file_line { "rouser ${snmpv3_user}":
	  path      => "$config_file_name",
      line      => "rouser ${snmpv3_user}",
      match     => "^rouser ${snmpv3_user}",
      notify    => Service[$service_name],
    }
  }
 } #If enabled
}#Class
