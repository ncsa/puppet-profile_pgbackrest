# @summary Manages the configuration of pgBackRest, a backup solution for PostgreSQL.
#
# @param config_filepath The file path where the pgBackRest configuration is stored.
#   Defaults to `/etc/pgbackrest.conf`.
#
# @param cron_jobs A hash defining scheduled cron jobs for running pgBackRest backups.
#   Defaults to `undef`, meaning no cron jobs are set.
#
# @param pgbackrest_ensure Determines whether pgBackRest should be present or absent.
#   Accepts `'present'` or `'absent'`. Defaults to `'present'`.
#
# @param stanza A hash defining stanza configurations for pgBackRest.
#   Defaults to `undef`, meaning no stanza is configured.
#
# @param stanza_name The name of the pgBackRest stanza to be configured.
#   Must be a non-empty string. Defaults to `''` (empty string).
#
# @param repositories An array of repository paths where backups will be stored.
#   Defaults to `undef`, meaning no stanza is configured.
#
# @param user The system user that owns the pgBackRest configuration and backup files.
#   Defaults to `'postgres'`.
#
# @param group The system group that owns the pgBackRest configuration and backup files.
#   Defaults to `'postgres'`.
#
# @param conf_mode The file mode (permissions) for the pgBackRest configuration file.
#   Defaults to `'0644'`.
#
# @param var_lib_mode The file mode (permissions) for the backup storage directory.
#   Defaults to `'0700'`.
#
# @param var_log_mode The file mode (permissions) for the log directory.
#   Defaults to `'0700'`.
class profile_pgbackrest::config (
  String                        $config_filepath   = '/etc/pgbackrest.conf',
  Hash                          $cron_jobs         = {},
  Enum['present','absent']      $pgbackrest_ensure = 'present',
  Hash                          $stanza            = {},
  String[1]                     $stanza_name       = 'demo',
  Array[String[1]]              $repositories      = [],
  String                        $user              = 'postgres',
  String                        $group             = 'postgres',
  String                        $conf_mode         = '0644',
  String                        $var_lib_mode      = '0700',
  String                        $var_log_mode      = '0700',
) {
  package { 'pgbackrest':
    ensure => $pgbackrest_ensure,
  }

  # Configure the /etc/pgbackrest.conf file
  file { $config_filepath:
    ensure  => file,
    content => epp('profile_pgbackrest/pgbackrest_config.epp', { 'configs' => $stanza }),
    owner   => $user,
    group   => $group,
    mode    => $conf_mode,
  }

  # If the user wants a repository that's not /var/lib/pgbackrest
  $repositories.each |$repository| {
    file { $repository:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => $var_log_mode,
    }
  }

  # Creates the stanza. Only supports one stanza
  exec { 'create stanza':
    command => "/bin/pgbackrest --stanza=${stanza_name} --log-level-console=info stanza-create",
    user    => $user,
  }

  # Sets up backup cron jobs
  $cron_jobs.each |$type, $properties| {
    profile_pgbackrest::cron { $type: * => $properties }
  }
}
