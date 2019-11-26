# Class: root_user
# ===========================
# This module will allow you to configure the root user's password
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
class root_user (
  $class_enabled = false,
  $password      = undef,
  $enc_type      = 'SHA-512',
  $enc_salt      = 'Saltines',
) {

  # validate type and convert string to boolean if necessary
  if is_string($class_enabled) {
    $class_enabled_real = str2bool($class_enabled)
  } else {
    $class_enabled_real = $class_enabled
  }
  
  if !is_string($password){
    fail('Password must be a string.')
  }
  
  # Get the octet of the IP
  $octsarray = split($::ipaddress, '[.]')
  $lastoct = $octsarray[3]

  # Zeros to add if not 3 digits
  $real_zero = "0"
  $real_two_zero = "00"

  # Add Zeros if not 3 digits
  case $lastoct.length {
    1: { $real_lastoct = "${real_two_zero}${lastoct}" }
    2: { $real_lastoct = "${real_zero}${lastoct}" }
    default: { $real_lastoct = $lastoct }
  }

  # Our real password we will use
  $real_password = "${password}${real_lastoct}"
 
  # Check if Class is disabled or password is unset
    if $class_enabled_real == true and $password != undef {
      user { 'root':
        ensure => present,
        password => pw_hash($real_password, $enc_type, $enc_salt),
      }
    } else {
      notice('Class disabled.')
    }
  
}
