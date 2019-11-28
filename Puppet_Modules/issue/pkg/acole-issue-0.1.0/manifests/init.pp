# Class: issue
# ===========================
#
# Full description of class issue here.
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
class issue (
   $content     = undef,
   $enabled     = false,
   $owner       = 'root',
   $group       = 'root',
   $mode        = '0644',
   $target_file = '/etc/issue',
) {

  # validate type and convert string to boolean if necessary
  if is_string($enabled) {
    $real_enabled = str2bool($enabled)
  } else {
    $real_enabled = $enabled
  }

  if !is_string($content) and !is_array($content) {
    fail('content must be a string or an array.')
  }
  
  if !is_string($target_file) and !is_array($target_file) {
    fail('target_file must be a string or an array.')
  }

  # Check if Class is disabled or content is unset
    if $real_enabled == true and $content != undef {
      file { $target_file:
        ensure  => 'file',
	    owner   => $owner,
        group   => $group,
        mode    => $mode,
        content => $content,
  }	
    } else {
      notice('Class disabled.')
    }

}
