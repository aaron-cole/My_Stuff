# Class: azure_agent
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
class azure_agent (

    $role_stateconsumer                     = 'None',
    $role_configurationconsumer             = 'None',
    $role_topologyconsumer                  = 'None',
    $provisioning_enabled                   = 'n',
    $provisioning_deleterootpassword        = 'n',
    $provisioning_regeneratesshhostkeypair  = 'n',
    $provisioning_sshhostkeypairtype        = 'rsa',
    $provisioning_monitorhostname           = 'y',
    $provisioning_decodecustomdata          = 'n',
    $provisioning_executecustomdata         = 'n',
    $provisioning_passwordcryptid           = undef,
    $provisioning_passwordcryptsaltlength   = undef,
    $resourcedisk_format                    = 'n',
    $resourcedisk_filesystem                = 'ext4',
    $resourcedisk_mountpoint                = '/mnt/resource',
    $resourcedisk_enableswap                = 'n',
    $resourcedisk_swapsizemb                = '0',
    $lbproberesponder                       = 'y',
    $logs_file                              = '/var/log/waagent.log',
    $logs_console                           = 'y',
    $logs_verbose                           = 'n',
    $network_interface                      = undef,
    $os_rootdevicescsitimeout               = '300',
    $os_opensslpath                         = 'None',
    $httpproxy_host                         = undef,
    $httpproxy_port                         = undef,
    $extensions_enabled                     = 'y',
    $package_ensure                         = 'absent',
    $service_ensure                         = 'stopped',
    $service_enable                         = 'false',

) {

  # Validation
  if is_string($package_ensure) {
    validate_re($package_ensure, '^(absent|present|latest|purge|installed)$', "azure_agent::package_ensure may be either 'absent|present|latest|purge|installed' and is set to <${package_ensure}>.")
  } else {
    fail('azure_agent::package_ensure must be a string. ')
  }
  
  if is_string($service_ensure) {
    validate_re($service_ensure, '^(stopped|running)$', "azure_agent::service_ensure may be either 'stopped' or 'running' and is set to <${service_ensure}>.")
  } else {
    fail('azure_agent::service_ensure must be a string. ')
  }

  if is_string($service_enable) {
    validate_re($service_enable, '^(false|true)$', "azure_agent::service_enable may be either 'false' or 'true' and is set to <${service_enable}>.")
  } else {
    fail('azure_agent::service_enable must be a string. ')
  }
  
  if is_string($extensions_enabled) {
    validate_re($extensions_enabled, '^(y|n)$', "azure_agent::extensions_enabled may be either 'y' or 'n' and is set to <${extensions_enabled}>.")
  } else {
    fail('azure_agent::extensions_enabled must be a string. ')
  }

  if is_string($provisioning_enabled) {
    validate_re($provisioning_enabled, '^(y|n)$', "azure_agent::provisioning_enabled may be either 'y' or 'n' and is set to <${provisioning_enabled}>.")
  } else {
    fail('azure_agent::provisioning_enabled must be a string. ')
  }  
  
  if is_string($provisioning_monitorhostname) {
    validate_re($provisioning_monitorhostname, '^(y|n)$', "azure_agent::provisioning_monitorhostname may be either 'y' or 'n' and is set to <${provisioning_monitorhostname}>.")
  } else {
    fail('azure_agent::provisioning_monitorhostname must be a string. ')
  }   
  
  if is_string($provisioning_deleterootpassword) {
    validate_re($provisioning_deleterootpassword, '^(y|n)$', "azure_agent::provisioning_deleterootpassword may be either 'y' or 'n' and is set to <${provisioning_deleterootpassword}>.")
  } else {
    fail('azure_agent::provisioning_deleterootpassword must be a string. ')
  }   

  if is_string($provisioning_regeneratesshhostkeypair) {
    validate_re($provisioning_regeneratesshhostkeypair, '^(y|n)$', "azure_agent::provisioning_regeneratesshhostkeypair may be either 'y' or 'n' and is set to <${provisioning_regeneratesshhostkeypair}>.")
  } else {
    fail('azure_agent::provisioning_regeneratesshhostkeypair must be a string. ')
  }

  if is_string($provisioning_sshhostkeypairtype) {
    validate_re($provisioning_sshhostkeypairtype, '^(rsa|dsa|ecdsa)$', "azure_agent::provisioning_sshhostkeypairtype may be either 'rsa' or 'dsa' or 'ecdsa' and is set to <${provisioning_sshhostkeypairtype}>.")
  } else {
    fail('azure_agent::provisioning_sshhostkeypairtype must be a string. ')
  }
  
  if is_string($provisioning_decodecustomdata) {
    validate_re($provisioning_decodecustomdata, '^(y|n)$', "azure_agent::provisioning_decodecustomdata may be either 'y' or 'n' and is set to <${provisioning_decodecustomdata}>.")
  } else {
    fail('azure_agent::provisioning_decodecustomdata must be a string. ')
  }  
  
  if is_string($provisioning_decodecustomdata) {
    validate_re($provisioning_decodecustomdata, '^(y|n)$', "azure_agent::provisioning_decodecustomdata may be either 'y' or 'n' and is set to <${provisioning_decodecustomdata}>.")
  } else {
    fail('azure_agent::provisioning_decodecustomdata must be a string. ')
  }    
  
  if is_string($resourcedisk_format) {
    validate_re($resourcedisk_format, '^(y|n)$', "azure_agent::resourcedisk_format may be either 'y' or 'n' and is set to <${resourcedisk_format}>.")
  } else {
    fail('azure_agent::resourcedisk_format must be a string. ')
  }     
  
  if is_string($resourcedisk_enableswap) {
    validate_re($resourcedisk_enableswap, '^(y|n)$', "azure_agent::resourcedisk_enableswap may be either 'y' or 'n' and is set to <${resourcedisk_enableswap}>.")
  } else {
    fail('azure_agent::resourcedisk_enableswap must be a string. ')
  }   
  
  if is_string($logs_verbose) {
    validate_re($logs_verbose, '^(y|n)$', "azure_agent::logs_verbose may be either 'y' or 'n' and is set to <${logs_verbose}>.")
  } else {
    fail('azure_agent::logs_verbose must be a string. ')
  }   
  
  if is_string($lbproberesponder) {
    validate_re($lbproberesponder, '^(y|n)$', "azure_agent::lbproberesponder may be either 'y' or 'n' and is set to <${lbproberesponder}>.")
  } else {
    fail('azure_agent::lbproberesponder must be a string. ')
  } 

  if is_string($logs_console) {
    validate_re($logs_console, '^(y|n)$', "azure_agent::logs_console may be either 'y' or 'n' and is set to <${logs_console}>.")
  } else {
    fail('azure_agent::logs_console must be a string. ')
  } 

  if $provisioning_passwordcryptid != undef {
    if is_string($provisioning_passwordcryptid) {
      validate_re($provisioning_passwordcryptid, '^(1|2a|5|6)$', "azure_agent::provisioning_passwordcryptid may be either '1' or '2a' or '5' or '6' and is set to <${provisioning_passwordcryptid}>.")
    } else {
      fail('azure_agent::provisioning_passwordcryptid must be a string. ')
    } 
  }

  if $provisioning_passwordcryptsaltlength != undef {
    if is_string($provisioning_passwordcryptsaltlength) {
      validate_re($provisioning_passwordcryptsaltlength, '^\d+$', "azure_agent::provisioning_passwordcryptsaltlength must be a valid number and is set to <${provisioning_passwordcryptsaltlength}>.")
    } else {
      fail('azure_agent::provisioning_passwordcryptsaltlength must be a string. ')
    } 
  }
  
  if $httpproxy_port != undef {
    if is_string($httpproxy_port) {
      validate_re($httpproxy_port, '^\d+$', "azure_agent::httpproxy_port must be a valid number and is set to <${httpproxy_port}>.")
    } else {
      fail('azure_agent::httpproxy_port must be a string. ')
    } 
  }

    validate_re($resourcedisk_swapsizemb, '^\d+$', "azure_agent::resourcedisk_swapsizemb must be a valid number and is set to <${resourcedisk_swapsizemb}>.")

    validate_re($os_rootdevicescsitimeout, '^\d+$', "azure_agent::os_rootdevicescsitimeout must be a valid number and is set to <${os_rootdevicescsitimeout}>.")

  if is_string($role_stateconsumer) {
    validate_re($role_stateconsumer, '^(None)$', "azure_agent::role_stateconsumer must be 'None' and is set to <${role_stateconsumer}>.")
  } else {
    fail('azure_agent::role_stateconsumer must be a string. ')
  } 

  if is_string($role_configurationconsumer) {
    validate_re($role_configurationconsumer, '^(None)$', "azure_agent::role_configurationconsumer must be 'None' and is set to <${role_configurationconsumer}>.")
  } else {
    fail('azure_agent::role_configurationconsumer must be a string. ')
  } 

  if is_string($role_topologyconsumer) {
    validate_re($role_topologyconsumer, '^(None)$', "azure_agent::role_topologyconsumer must be 'None' and is set to <${role_topologyconsumer}>.")
  } else {
    fail('azure_agent::role_topologyconsumer must be a string. ')
  } 

  if is_string($resourcedisk_filesystem) {
    validate_re($resourcedisk_filesystem, '^(ext3|ext4|xfs|btrfs)$', "azure_agent::resourcedisk_filesystem may be either 'ext3' 'ext4' 'xfs' 'btrfs' and is set to <${resourcedisk_filesystem}>.")
  } else {
    fail('azure_agent::resourcedisk_filesystem must be a string. ')
  }

  if $os_opensslpath != 'None' {
    if is_string($os_opensslpath) {
      validate_absolute_path($os_opensslpath)
    } else {
      fail('azure_agent::os_opensslpath must be a string. ')
    } 
  }

  if $httpproxy_host != undef {
    if is_string($httpproxy_host) {
      if is_domain_name($httpproxy_host) {
	    $httpproxy_host_real = $httpproxy_host
	  } elsif is_ip_address($httpproxy_host) {
	    $httpproxy_host_real = $httpproxy_host
	  } else {
        fail('azure_agent::httpproxy_host must be a valid hostname or IP and is set to <${httpproxy_host_real}>.')	  
	  }
    } else {
      fail('azure_agent::httpproxy_host must be a string. ')
    } 
  }

  if $network_interface != undef {
    if is_string($network_interface) {
      validate_absolute_path("/etc/sysconfig/network-scripts/ifcfg-$network_interface")
    } else {
      fail('azure_agent::network_interface must be a string. ')
    } 
  }  

 #Install  
 package { 'WALinuxAgent':
    ensure   => $package_ensure,
	before   => Service['waagent'],
  }
  
 #Service
 service { 'waagent':
    ensure     => $service_ensure,
    enable     => $service_enable,
    require    => Package['WALinuxAgent'],
  }

 case $package_ensure {
    'absent','purge': {
	    $file_ensure = $package_ensure
	}
	default: {
	    $file_ensure = 'file'
	}
 }
 
 #Deploy Config file
 file { '/etc/waagent.conf':
    notify  => Service['waagent'],
	ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
	mode    => '0644',
    content => template('azure_agent/waagent_conf.erb'),
  } 

}
