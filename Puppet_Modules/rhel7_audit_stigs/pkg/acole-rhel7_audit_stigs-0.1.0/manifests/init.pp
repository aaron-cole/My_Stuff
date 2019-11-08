# Class: RHEL7_audit_stigs
# ===========================
#
# Full description of class rhel7_audit_stigs here.
#
#
# Authors
# -------
#
# Author Name <author@domain.com>
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
  }

  file { "/etc/audit/auditd.conf":
    notify => Service["auditd"],
    ensure => file,
    mode => '0640',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/auditd.conf',
  }

  file { "/etc/audit/rules.d/access.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/access.rules',
  }

  file { "/etc/audit/rules.d/account_mod.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/account_mod.rules',
  }
  file { "/etc/audit/rules.d/audit.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/audit.rules',
  }

  file { "/etc/audit/rules.d/audit_rules_networkconfig_modification.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/audit_rules_networkconfig_modification.rules',
  }

  file { "/etc/audit/rules.d/audit_time_rules.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/audit_time_rules.rules',
  }

  file { "/etc/audit/rules.d/delete.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/delete.rules',
  }

  file { "/etc/audit/rules.d/export.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/export.rules',
  }

  file { "/etc/audit/rules.d/logins.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/logins.rules',
  }

  file { "/etc/audit/rules.d/MAC-policy.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/MAC-policy.rules',
  }

  file { "/etc/audit/rules.d/perm_mod.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/perm_mod.rules',
  }

  file { "/etc/audit/rules.d/privileged_command.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/privileged_command.rules',
  }

  file { "/etc/audit/rules.d/setuid.rules":
    notify => Service["auditd"],
    ensure => file,
    mode => '0600',
    owner => 'root',
    group => 'root',
    seltype => "auditd_etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/setuid.rules',
  }

  file { "/etc/audisp/audispd.conf":
    notify => Service["auditd"],
    ensure => file,
    mode => '0640',
    owner => 'root',
    group => 'root',
    seltype => "etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/audispd.conf',
  }

  file { "/etc/audisp/audisp-remote.conf":
    notify => Service["auditd"],
    ensure => file,
    mode => '0640',
    owner => 'root',
    group => 'root',
    seltype => "etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/audisp-remote.conf',
  }

  file { "/etc/audisp/plugins.d/au-remote.conf":
    notify => Service["auditd"],
    ensure => file,
    mode => '0640',
    owner => 'root',
    group => 'root',
    seltype => "etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/au-remote.conf',
  }

  file { "/etc/audisp/plugins.d/syslog.conf":
    notify => Service["auditd"],
    ensure => file,
    mode => '0640',
    owner => 'root',
    group => 'root',
    seltype => "etc_t",
    source => 'puppet:///modules/RHEL7_audit_stigs/syslog.conf',
  }

#exec { 'restorecon':
#    command => "restorecon -RF /etc/audit/",
#    path => "/usr/sbin",
#    require => Package['policycoreutils'],
#    before => Service['audit'],
#    subscribe => Package['httpd'],
#    refreshonly => true,
#  }
#  package { 'policycoreutils-python':
#    ensure => installed,
#  }
}
