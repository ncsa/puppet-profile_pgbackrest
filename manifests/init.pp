# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile_pgbackrest
class profile_pgbackrest (
  # PARAMETERS
  String $stanza_name,
  String $postgresql_data,
  String $backup_path,
  # Maybe include like a list that user can use to customize their stanza
) {
# SUB-MODULES TO INCLUDE 
  include epel

  file { '/hello.txt':
    ensure  => 'file',
    content => "Welcome to my server!\n",
  }

#  case $::facts['os']['family'] {
#    'RedHat': {
#      ensure_resource('yumrepo', ['pgdg-redhat-repo'], { baseurl => lookup('postgresql_yum_repo') })
#    }
#  }

  # default for ensure is installed
#  package { 'pgbackrest': }

  # Adds the stanza to pgbackrest_config.epp
#  file { '/etc/pgbackrest.conf':
#    ensure  => file,
#    content => epp('pgbackrest/pgbackrest_config.epp', $param),
#  }

  # configs according to pgbackrest documentation
  # this is where backups will be saved
#  file { '/var/lib/pgbackrest':
#    ensure => directory,
#    owner  => 'postgres',
#    group  => 'postgres',
#    mode   => '0750',
#  }
}
