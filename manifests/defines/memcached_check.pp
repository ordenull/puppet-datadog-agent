# Class: datadog::check::memcached
#
# This define contains a datadog memcached health check
#
# Parameters
#   hostname
#       Memcached server hostname
#
#   port
#       Memcached server port
#
#   tags
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# datadog::check::memcached { 'default': }
#
# datadog::check::memcached { 'Status Check': 
#   hostname => 'localhost',
#   port     => '11211',
#   tags     => ['sessions'],
# }
#
define datadog::check::memcached (
  $hostname  = 'localhost',
  $port      = 11211,
  $tags      = [],
) {

  $memcached_check_yaml_file = '/etc/dd-agent/conf.d/mcache.yaml'

  if ( !defined( Concat[$memcached_check_yaml_file] ) ) {
    concat { $memcached_check_yaml_file:
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      notify => Service['datadog-agent'],
    }
  }

  if ( !defined( Concat::Fragment["datadog_memcached_check_header"] ) ) {
    concat::fragment { "datadog_memcached_check_header":
      target  => $memcached_check_yaml_file,
      content => "init_config:\n\ninstances:\n",
      order   => 10,
    }
  }

  concat::fragment { "datadog_memcached_check_fragment_$title":
    target  => $memcached_check_yaml_file,
    content => template('datadog/memcached_check.yaml.erb'),
    order   => 20,
  }

}
