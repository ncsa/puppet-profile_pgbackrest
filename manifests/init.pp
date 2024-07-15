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
}
