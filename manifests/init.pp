# @summary Configures pgbackrest for a Redhat system
class profile_pgbackrest (
  # PARAMETERS
) {
  # SUB-MODULES TO INCLUDE 
  include epel
  include stdlib
  include profile_pgbackrest::yumrepos
  include profile_pgbackrest::config
  include profile_pgbackrest::backup
}
