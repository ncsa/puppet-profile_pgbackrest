#   include profile_pgbackrest
class profile_pgbackrest (
  # PARAMETERS
  String $postgresql_data,
  String $backup_path,
) {
# SUB-MODULES TO INCLUDE 
  include epel
  include stdlib
  include profile_pgbackrest::yumrepos
  include profile_pgbackrest::config

  # Configuration parameters for the PostgreSQL server
  class { 'postgresql::server':
    version           => '14',               # Specify the version of PostgreSQL
    listen_addresses  => '*',                # Listen on all available IP addresses
    port              => 5432,               # Default PostgreSQL port
  }
}
