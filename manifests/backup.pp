# @summary Configure GitLab backups
#
# @param paths
#   List of paths (locations to files or directories) to be backed up.
#
# @param posthook_commands
#   List of commands to run after the paths are backed up.
#
# @param prehook_commands
#   List of commands to run before the paths are backed up.
#
# @example
#   include profile_pgbackrest::backup
class profile_pgbackrest::backup (
  Array[String] $paths,
  Array[String] $posthook_commands,
  Array[String] $prehook_commands,
) {
  if ( lookup('profile_backup::client::enabled') ) {
    include profile_backup::client

    profile_backup::client::add_job { 'profile_pgbackrest':
      paths             => $paths,
      posthook_commands => $posthook_commands,
      prehook_commands  => $prehook_commands,
    }
  }
}
