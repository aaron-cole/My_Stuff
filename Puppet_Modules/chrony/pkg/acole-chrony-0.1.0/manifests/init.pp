# Class: chrony
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
class chrony (

    $package_manage         = true,
    $package_ensure         = 'installed',
    $package_name           = 'chrony',
    $service_manage         = true,
    $service_ensure         = running,
    $service_enable         = true,
	$service_name           = 'chronyd',
    $config_file_name       = '/etc/chrony.conf',
    $config_file_owner      = 'root',
    $config_file_group      = 'root',
    $config_file_mode       = '0644',
    $servers                = ['0.us.pool.ntp.org',
                               '1.us.pool.ntp.org',
                               '2.us.pool.ntp.org'],
    $server_options         = undef,
    $drift_file             = '/var/lib/chrony/drift',
    $makestep               = '1.0 3',
    $leapsectz              = 'right/UTC',
    $kernel_synchronization = true, 
    $minimum_sources        = undef,
    $keyfile                = '/etc/chrony.keys',
    $log_directory          = '/var/log/chrony',
    $chrony_server_port     = undef,
    $chrony_mgmt_port       = undef,

) {

  # validate type as array or fail
  validate_array($servers)
  
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

  # validate type and convert string to boolean if necessary
  if is_string($kernel_synchronization) == true {
    $my_kernel_synchronization = str2bool($kernel_synchronization)
  } else {
    $my_kernel_synchronization = $kernel_synchronization
  }
  
  if ($drift_file != '') and ($drift_file != undef) {
    validate_absolute_path($drift_file)
  }
  
  if ($keyfile != '') and ($keyfile != undef) {
    validate_absolute_path($keyfile)
  }

  if ($log_directory != '') and ($log_directory != undef) {
    validate_absolute_path($log_directory)
  }

 #Install Package
 if $my_package_manage {
    package { $package_name:
      ensure   => $package_ensure,
      name     => $package_name,
	  before   => File['chrony_conf'],
    }
  }

  file { 'chrony_conf':
    ensure  => file,
    path    => $config_file_name,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    content => template('chrony/chrony_conf.erb'),
  }
  
 if $my_service_manage {  
    service { 'chrony_service':
      ensure     => $service_ensure,
      name       => $service_name_real,
      enable     => $service_enable,
      hasstatus  => $my_service_hasstatus,
      hasrestart => $my_service_hasrestart,
      subscribe  => [ Package[$package_name],
                    File['chrony_conf'],
                  ],
    }
  }

}
