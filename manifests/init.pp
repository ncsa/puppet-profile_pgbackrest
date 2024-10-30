# @summary Configure profile_pgbackrest
#
# @example
#   include profile_pgbackrest
class profile_pgbackrest (
  # PARAMETERS
) {
  # SUB-MODULES TO INCLUDE 
  include epel
  include stdlib
  include profile_pgbackrest::yumrepos
  include profile_pgbackrest::config
}
