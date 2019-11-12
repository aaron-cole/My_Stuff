# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $collect_all           = false,
  $enable_ipv4_localhost = true,
  $enable_ipv6_localhost = true,
  $enable_fqdn_entry     = true,
  $use_fqdn              = true,
  $fqdn_host_aliases     = $::hostname,
  $localhost_aliases     = ['localhost',
                            'localhost4',
                            'localhost4.localdomain4'],
  $localhost6_aliases    = ['localhost6'],
  $purge_hosts           = false,
  $target                = '/etc/hosts',
  $host_entries          = undef,
  $enable_extra_entry_1  = false,
  $extra_entry_1_ip      = '0.0.0.0',
  $extra_entry_1_fqdn    = 'somehost1.somewhere',
  $extra_entry_1_aliases = 'somehost1',
  $enable_extra_entry_2  = false,
  $extra_entry_2_ip      = '0.0.0.0',
  $extra_entry_2_fqdn    = 'somehost2.somewhere',
  $extra_entry_2_aliases = 'somehost2',
  $enable_extra_entry_3  = false,
  $extra_entry_3_ip      = '0.0.0.0',
  $extra_entry_3_fqdn    = 'somehost3.somewhere',
  $extra_entry_3_aliases = 'somehost3',
  $enable_extra_entry_4  = false,
  $extra_entry_4_ip      = '0.0.0.0',
  $extra_entry_4_fqdn    = 'somehost4.somewhere',
  $extra_entry_4_aliases = 'somehost4',
  $enable_extra_entry_5  = false,
  $extra_entry_5_ip      = '0.0.0.0',
  $extra_entry_5_fqdn    = 'somehost5.somewhere',
  $extra_entry_5_aliases = 'somehost5',
) {


  # validate type and convert string to boolean if necessary
  if is_string($collect_all) {
    $collect_all_real = str2bool($collect_all)
  } else {
    $collect_all_real = $collect_all
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_ipv4_localhost) {
    $ipv4_localhost_enabled = str2bool($enable_ipv4_localhost)
  } else {
    $ipv4_localhost_enabled = $enable_ipv4_localhost
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_ipv6_localhost) {
    $ipv6_localhost_enabled = str2bool($enable_ipv6_localhost)
  } else {
    $ipv6_localhost_enabled = $enable_ipv6_localhost
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_fqdn_entry) {
    $fqdn_entry_enabled = str2bool($enable_fqdn_entry)
  } else {
    $fqdn_entry_enabled = $enable_fqdn_entry
  }

  # validate type and convert string to boolean if necessary
  if is_string($use_fqdn) {
    $use_fqdn_real = str2bool($use_fqdn)
  } else {
    $use_fqdn_real = $use_fqdn
  }

  # validate type and convert string to boolean if necessary
  if is_string($purge_hosts) {
    $purge_hosts_enabled = str2bool($purge_hosts)
  } else {
    $purge_hosts_enabled = $purge_hosts
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_extra_entry_1) {
    $extra_entry_1_enable = str2bool($enable_extra_entry_1)
  } else {
    $extra_entry_1_enable = $enable_extra_entry_1
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_extra_entry_2) {
    $extra_entry_2_enable = str2bool($enable_extra_entry_2)
  } else {
    $extra_entry_2_enable = $enable_extra_entry_2
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_extra_entry_3) {
    $extra_entry_3_enable = str2bool($enable_extra_entry_3)
  } else {
    $extra_entry_3_enable = $enable_extra_entry_3
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_extra_entry_4) {
    $extra_entry_4_enable = str2bool($enable_extra_entry_4)
  } else {
    $extra_entry_4_enable = $enable_extra_entry_4
  }
  
  # validate type and convert string to boolean if necessary
  if is_string($enable_extra_entry_5) {
    $extra_entry_5_enable = str2bool($enable_extra_entry_5)
  } else {
    $extra_entry_5_enable = $enable_extra_entry_5
  }

  if $ipv4_localhost_enabled == true {
    $localhost_ensure     = 'present'
    $localhost_ip         = '127.0.0.1'
    $my_localhost_aliases = $localhost_aliases
  } else {
    $localhost_ensure     = 'absent'
    $localhost_ip         = '127.0.0.1'
    $my_localhost_aliases = undef
  }

  if $ipv6_localhost_enabled == true {
    $localhost6_ensure     = 'present'
    $localhost6_ip         = '::1'
    $my_localhost6_aliases = $localhost6_aliases
  } else {
    $localhost6_ensure     = 'absent'
    $localhost6_ip         = '::1'
    $my_localhost6_aliases = undef
  }

  if !is_string($my_localhost_aliases) and !is_array($my_localhost_aliases) {
    fail('hosts::localhost_aliases must be a string or an array.')
  }

  if !is_string($my_localhost6_aliases) and !is_array($my_localhost6_aliases) {
    fail('hosts::localhost6_aliases must be a string or an array.')
  }
  
  if !is_string($extra_entry_1_ip) and !is_array($extra_entry_1_ip) {
    fail('hosts::extra_entry_1_ip must be a string or an array.')
  }
 
  if !is_string($extra_entry_1_fqdn) and !is_array($extra_entry_1_fqdn) {
    fail('hosts::extra_entry_1_fqdn must be a string or an array.')
  }
  
  if !is_string($extra_entry_1_aliases) and !is_array($extra_entry_1_aliases) {
    fail('hosts::extra_entry_1_aliases must be a string or an array.')
  }

  if !is_string($extra_entry_2_ip) and !is_array($extra_entry_2_ip) {
    fail('hosts::extra_entry_2_ip must be a string or an array.')
  }
 
  if !is_string($extra_entry_2_fqdn) and !is_array($extra_entry_2_fqdn) {
    fail('hosts::extra_entry_2_fqdn must be a string or an array.')
  }
  
  if !is_string($extra_entry_2_aliases) and !is_array($extra_entry_2_aliases) {
    fail('hosts::extra_entry_2_aliases must be a string or an array.')
  }
  
  if !is_string($extra_entry_3_ip) and !is_array($extra_entry_3_ip) {
    fail('hosts::extra_entry_3_ip must be a string or an array.')
  }
 
  if !is_string($extra_entry_3_fqdn) and !is_array($extra_entry_3_fqdn) {
    fail('hosts::extra_entry_3_fqdn must be a string or an array.')
  }
  
  if !is_string($extra_entry_3_aliases) and !is_array($extra_entry_3_aliases) {
    fail('hosts::extra_entry_3_aliases must be a string or an array.')
  }
  
  if !is_string($extra_entry_4_ip) and !is_array($extra_entry_4_ip) {
    fail('hosts::extra_entry_4_ip must be a string or an array.')
  }
 
  if !is_string($extra_entry_4_fqdn) and !is_array($extra_entry_4_fqdn) {
    fail('hosts::extra_entry_4_fqdn must be a string or an array.')
  }
  
  if !is_string($extra_entry_4_aliases) and !is_array($extra_entry_4_aliases) {
    fail('hosts::extra_entry_4_aliases must be a string or an array.')
  }
  
  if !is_string($extra_entry_5_ip) and !is_array($extra_entry_5_ip) {
    fail('hosts::extra_entry_5_ip must be a string or an array.')
  }
 
  if !is_string($extra_entry_5_fqdn) and !is_array($extra_entry_5_fqdn) {
    fail('hosts::extra_entry_5_fqdn must be a string or an array.')
  }
  
  if !is_string($extra_entry_5_aliases) and !is_array($extra_entry_5_aliases) {
    fail('hosts::extra_entry_5_aliases must be a string or an array.')
  }
  
  if $fqdn_entry_enabled == true {
    $fqdn_ensure          = 'present'
    $my_fqdn_host_aliases = $fqdn_host_aliases
    $fqdn_ip              = $::ipaddress
  } else {
    $fqdn_ensure          = 'absent'
    $my_fqdn_host_aliases = []
    $fqdn_ip              = $::ipaddress
  }

  if $extra_entry_1_enable == true {
    $extra_1_ensure          = 'present'
    $my_extra_1_host_aliases = $extra_entry_1_aliases
    $extra_1_ip              = $extra_entry_1_ip
  } else {
    $extra_1_ensure          = 'absent'
    $my_extra_1_host_aliases = []
    $extra_1_ip              = $extra_entry_1_ip
  }
  
  if $extra_entry_2_enable == true {
    $extra_2_ensure          = 'present'
    $my_extra_2_host_aliases = $extra_entry_2_aliases
    $extra_2_ip              = $extra_entry_2_ip
  } else {
    $extra_2_ensure          = 'absent'
    $my_extra_2_host_aliases = []
    $extra_2_ip              = $extra_entry_2_ip
  }

  if $extra_entry_3_enable == true {
    $extra_3_ensure          = 'present'
    $my_extra_3_host_aliases = $extra_entry_3_aliases
    $extra_3_ip              = $extra_entry_3_ip
  } else {
    $extra_3_ensure          = 'absent'
    $my_extra_3_host_aliases = []
    $extra_3_ip              = $extra_entry_3_ip
  }
  
  if $extra_entry_4_enable == true {
    $extra_4_ensure          = 'present'
    $my_extra_4_host_aliases = $extra_entry_4_aliases
    $extra_4_ip              = $extra_entry_4_ip
  } else {
    $extra_4_ensure          = 'absent'
    $my_extra_4_host_aliases = []
    $extra_4_ip              = $extra_entry_4_ip
  }
  
  if $extra_entry_5_enable == true {
    $extra_5_ensure          = 'present'
    $my_extra_5_host_aliases = $extra_entry_5_aliases
    $extra_5_ip              = $extra_entry_5_ip
  } else {
    $extra_5_ensure          = 'absent'
    $my_extra_5_host_aliases = []
    $extra_5_ip              = $extra_entry_5_ip
  }
  
  Host {
    target => $target,
  }

  $local_aliases = $localhost_aliases + $localhost6_aliases + $fqdn_host_aliases
  
  host { unique($local_aliases):
    ensure => 'absent',
  }
  
  $extra_aliases = $extra_entry_1_aliases + $extra_entry_2_aliases + $extra_entry_3_aliases + $extra_entry_4_aliases + $extra_entry_5_aliases

  host {  unique($extra_aliases):
    ensure => 'absent',
  }

  host { 'localhost.localdomain':
    ensure       => $localhost_ensure,
    host_aliases => $my_localhost_aliases,
    ip           => $localhost_ip,
  }

  host { 'localhost6.localdomain6':
    ensure       => $localhost6_ensure,
    host_aliases => $my_localhost6_aliases,
    ip           => $localhost6_ip,
  }
  
  if $use_fqdn_real == true {
    host { $::fqdn:
      ensure       => $fqdn_ensure,
      host_aliases => $my_fqdn_host_aliases,
      ip           => $fqdn_ip,
    }

    case $collect_all_real {
      # collect all the exported Host resources
      true:  {
        Host <<| |>>
      }
      # only collect the exported entry above
      default: {
        Host <<| title == $::fqdn |>>
      }
    }
  }
  
  host { $extra_entry_1_fqdn:
    ensure       => $extra_1_ensure,
    host_aliases => $my_extra_1_host_aliases,
    ip           => $extra_1_ip,
  }

  host { $extra_entry_2_fqdn:
    ensure       => $extra_2_ensure,
    host_aliases => $my_extra_2_host_aliases,
    ip           => $extra_2_ip,
  }
  
  host { $extra_entry_3_fqdn:
    ensure       => $extra_3_ensure,
    host_aliases => $my_extra_3_host_aliases,
    ip           => $extra_3_ip,
  }
  
  host { $extra_entry_4_fqdn:
    ensure       => $extra_4_ensure,
    host_aliases => $my_extra_4_host_aliases,
    ip           => $extra_4_ip,
  }
  
  host { $extra_entry_5_fqdn:
    ensure       => $extra_5_ensure,
    host_aliases => $my_extra_5_host_aliases,
    ip           => $extra_5_ip,
  }
  
  resources { 'host':
    purge => $purge_hosts,
  }

  if $host_entries != undef {
    $host_entries_real = delete($host_entries,$::fqdn)
    validate_hash($host_entries_real)
    create_resources(host,$host_entries_real)
  }
}
