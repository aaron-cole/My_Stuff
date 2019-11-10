# Class: rhel7_audit_stigs
# ===========================
#
# Full description of class rhel7_audit_stigs here.
#
#
# Authors
# -------
#
# Copyright
# ---------
#
# Copyright 2019 Aaron Cole, unless otherwise noted.
#
class rhel7_audit_stigs {

  package { 'audit':
    ensure => installed,
  }

  package { 'audispd-plugins':
    ensure => installed,
  }

  service { 'auditd':
    ensure => running,
    enable => true,
    require => Package["audit"],
	start   => '/usr/sbin/service auditd start',
	stop   => '/usr/sbin/service auditd stop',
	restart   => '/usr/sbin/service auditd restart',
	status   => '/usr/sbin/service auditd status',
  }

  File {
    notify  => Service["auditd"],
	ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '600,
    seltype => "auditd_etc_t",
  }
  
  file { "/etc/audit/auditd.conf":
    mode    => '0640',
    source  => 'puppet:///modules/rhel7_audit_stigs/auditd.conf',
  }

  file { "/etc/audit/rules.d/access.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/access.rules',
  }

  file { "/etc/audit/rules.d/account_mod.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/account_mod.rules',
  }

  file { "/etc/audit/rules.d/audit.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/audit.rules',
  }

  file { "/etc/audit/rules.d/audit_rules_networkconfig_modification.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/audit_rules_networkconfig_modification.rules',
  }

  file { "/etc/audit/rules.d/audit_time_rules.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/audit_time_rules.rules',
  }

  file { "/etc/audit/rules.d/delete.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/delete.rules',
  }

  file { "/etc/audit/rules.d/export.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/export.rules',
  }

  file { "/etc/audit/rules.d/logins.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/logins.rules',
  }

  file { "/etc/audit/rules.d/MAC-policy.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/MAC-policy.rules',
  }

  file { "/etc/audit/rules.d/modules.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/modules.rules',
  }

  file { "/etc/audit/rules.d/perm_mod.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/perm_mod.rules',
  }

  file { "/etc/audit/rules.d/privileged_command.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/privileged_command.rules',
  }

  file { "/etc/audit/rules.d/setuid.rules":
    source  => 'puppet:///modules/rhel7_audit_stigs/setuid.rules',
  }

  file { "/etc/audisp/audispd.conf":
    mode    => '0640',
    seltype => "etc_t",
    source  => 'puppet:///modules/rhel7_audit_stigs/audispd.conf',
  }

  file { "/etc/audisp/audisp-remote.conf":
    mode    => '0640',
    seltype => "etc_t",
    source  => 'puppet:///modules/rhel7_audit_stigs/audisp-remote.conf',
  }

  file { "/etc/audisp/plugins.d/au-remote.conf":
    mode    => '0640',
    seltype => "etc_t",
    source  => 'puppet:///modules/rhel7_audit_stigs/au-remote.conf',
  }

  file { "/etc/audisp/plugins.d/syslog.conf":
    mode    => '0640',
    seltype => "etc_t",
    source  => 'puppet:///modules/rhel7_audit_stigs/syslog.conf',
  }

  exec { 'restorecon':
    command => "restorecon -RF /etc/audit/",
    path => "/usr/sbin",
    require => Package['policycoreutils'],
    before => Service['auditd'],
    subscribe => Package['audit'],
    refreshonly => true,
  }
  
  package { 'policycoreutils':
    ensure => installed,
  }
  
  package { 'policycoreutils-python':
    ensure => installed,
  }
}
