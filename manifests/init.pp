# Class: apache
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class apache {
  if !defined(Class['Apache::Params']) {
      include apache::params
  }
  package { 'httpd':
    name   => $apache::params::apache_name,
    ensure => installed,
  }
  
  service { 'httpd':
    name        => $apache::params::apache_name,
    ensure      => running,
    enable      => true,
    subscribe   => Package['httpd'],
    hasrestart  => true,
    hasstatus   => true,
    restart     => "/usr/sbin/apache2ctl configtest && /usr/sbin/apache2ctl -k graceful",
  }

  file { "httpd_vdir":
    name => $apache::params::vdir,
    ensure  => directory,
    recurse => true,
    purge   => true,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }
}
