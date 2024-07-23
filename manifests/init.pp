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
  include postgresql::server

  # Configuration parameters for the PostgreSQL server
  class { 'postgresql::server':
    version           => '14',               # Specify the version of PostgreSQL
    listen_addresses  => '*',                # Listen on all available IP addresses
    port              => 5432,               # Default PostgreSQL port
    manage_firewall   => true,               # Manage firewall rules to allow traffic on PostgreSQL port
    postgres_password => lookup('postgresql::server::dbpassword'),   # Password for the PostgreSQL superuser
  }

  # Create a new PostgreSQL database owned by the default 'postgres' user
  postgresql::server::db { 'test_database':
    user     => 'postgres',        # Default PostgreSQL superuser
    password => postgresql_password('postgres', lookup('postgresql::server::dbpassword')), # Encrypted password for the user
  }
}
