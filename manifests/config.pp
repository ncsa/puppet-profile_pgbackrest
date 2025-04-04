# @summary Configure pgbackrest
#
# @param config_filepath
#   The absolute path to the pgBackRest configuration file.
#
# @param cron_jobs
#   A hash defining scheduled backup jobs for pgBackRest, typically used to automate backups via cron.
#
# @param pgbackrest_ensure
#   Determines whether pgBackRest should be installed and configured ('present') or removed ('absent').
#
# @param stanza
#   A hash containing stanza configuration, which defines backup settings for a PostgreSQL instance.
#
# @param stanza_name
#   The name of the pgBackRest stanza to be configured.
#
# @param repositories
#   An array of paths to pgBackRest repository locations where backups will be stored.
#
# @param user
#   The system user that owns and runs pgBackRest.
#
# @param group
#   The system group associated with pgBackRest.
#
# @param conf_mode
#   The file permission mode for the pgBackRest configuration file.
#
# @param repo_mode
#   The file permission mode for the pgBackRest log directory.
#
# @example
#   include profile_pgbackrest::config
class profile_pgbackrest::config (
  String                        $config_filepath   = '/etc/pgbackrest.conf',
  Optional[Hash]                $cron_jobs         = undef,
  Enum['present','absent']      $pgbackrest_ensure = 'present',
  Optional[Hash]                $stanza            = undef,
  String[1]                     $stanza_name       = 'demo',
  Array[String[1]]              $repositories      = [],
  String                        $user              = 'postgres',
  String                        $group             = 'postgres',
  String                        $conf_mode         = '0644',
  String                        $repo_mode         = '0700',
) {
  package { 'pgbackrest':
    ensure => $pgbackrest_ensure,
  }

  # Dynamically configures pgbackrest.conf
  file { $config_filepath:
    ensure  => file,
    content => epp('profile_pgbackrest/pgbackrest_config.epp', { 'configs' => $stanza }),
    owner   => $user,
    group   => $group,
    mode    => $conf_mode,
  }

  # Creates custom repositories
  # if none is given, the default is /var/lib/pgbackrest
  $repositories.each |$repository| {
    file { $repository:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => $repo_mode,
    }
  }

  if $repositories.empty {
    $check_path = "/var/lib/pgbackrest/backup/${stanza_name}/backup.info"
  } else {
    $check_path = "${repositories[0]}/backup/${stanza_name}/backup.info"
  }

  exec { "create stanza ${stanza_name}":
    command => "/bin/pgbackrest --stanza=${stanza_name} --log-level-console=info stanza-create",
    user    => $user,
    creates => $check_path,
  }

  # Configures cron jobs
  $cron_jobs.each |$type, $properties| {
    profile_pgbackrest::cron { $type: * => $properties }
  }
}
