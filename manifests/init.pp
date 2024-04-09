# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile_pgbackrest
class profile_pgbackrest {
  $param = {
    'stanza_name' => lookup('pgbackrest::stanza_name'),
    'postgresql_data' => lookup('pgbackrest::postgresql_data'),
    'backup_path'  => lookup('pgbackrest::backup_path')
  }

  # @TODO: instead of using case statement, let the hiera lookup do it 
  # There is a yum resource instead of package 
  case $::facts['os']['family'] {
    "RedHat": {
  
      package { 'pgdg-redhat-repo':
        source => "https://download.postgresql.org/pub/repos/yum/reporpms/EL-${::facts['operatingsystemmajrelease']}-${::facts['architecture']}/pgdg-redhat-repo-latest.noarch.rpm"
      }

      package { 'libzstd':
        source   => lookup('pgbackrest::epel_libzstd')
      }
    }
  }

  # default for ensure is installed
  package { 'pgbackrest':}

  # Adds the stanza to pgbackrest_config.epp
  file { '/etc/pgbackrest.conf':
    ensure  => file,
    content => epp('pgbackrest/pgbackrest_config.epp', $param),
  }

  # configs according to pgbackrest documentation
  # this is where backups will be saved
  file { '/var/lib/pgbackrest':
    ensure => directory,
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0750',
  }
}
