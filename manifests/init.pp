#   include profile_pgbackrest
class profile_pgbackrest (
  # PARAMETERS
  String $postgresql_data,
  String $backup_path,
) {
# SUB-MODULES TO INCLUDE 
  include epel
  include profile_pgbackrest::pgbackrest_config
  include profile_pgbackrest::yumrepos

  # default for ensure is installed
  package { 'pgbackrest': }

  # configs according to pgbackrest documentation
  # this is where backups will be saved
  file { '/var/lib/pgbackrest':
    ensure => directory,
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0750',
  }
}
