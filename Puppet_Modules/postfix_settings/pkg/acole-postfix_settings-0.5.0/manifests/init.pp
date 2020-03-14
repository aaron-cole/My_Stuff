# Class: postfix_settings
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
class postfix_settings (

  $target_file               = '/etc/postfix/main.cf',
  $myhostname                = undef,
  $mydomain                  = $::domain,
  $relay_host                = undef,
  $smtpd_client_restrictions = 'permit_mynetworks,reject',

)  {
  package { 'postfix':
    ensure => installed,
    before => Service['postfix'],
  }

  service { 'postfix':
    ensure     => running,
    enable     => true,
    require    => Package["postfix"],
	hasstatus  => true,
	hasrestart => true,
	subscribe  => File[$target_file],
  }

  if $myhostname {
	ini_setting { 'postfix myhostname':
	  ensure            => present,
	  path              => $target_file,
	  section           => '',
	  key_val_separator => ' = ',
	  setting           => 'myhostname',
	  value             => $myhostname,
	  notify            => Service['postfix'],
    }
   }

  if $mydomain {
	ini_setting { 'postfix mydomain':
	  ensure            => present,
	  path              => $target_file,
	  section           => '',
	  key_val_separator => ' = ',
	  setting           => 'mydomain',
	  value             => $mydomain,
	  notify            => Service['postfix'],
    }
   }

  if $relay_host {
	ini_setting { 'postfix relay_host':
	  ensure            => present,
	  path              => $target_file,
	  section           => '',
	  key_val_separator => ' = ',
	  setting           => 'relayhost',
	  value             => $relay_host,
	  notify            => Service['postfix'],
    }
   }

  if $smtpd_client_restrictions {
	ini_setting { 'postfix smtpd_client_restrictions':
	  ensure            => present,
	  path              => $target_file,
	  section           => '',
	  key_val_separator => ' = ',
	  setting           => 'smtpd_client_restrictions',
	  value             => $smtpd_client_restrictions,
	  notify            => Service['postfix'],
    }
   }
  
  file { $target_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['postfix'],
  }
}