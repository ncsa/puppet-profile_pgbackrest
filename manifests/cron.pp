# @summary Configure backup cronjobs
#
# @param backup_type
#   Specifies the type of backup to be performed (full, diff, incr)
#
# @param cron_ensure
#   Determines whether the cron job should be configured ('present') or removed ('absent').
#
# @param cron_hour
#   The hour (1-12) at which the backup should run. If left undef, the system's default scheduling behavior applies.
#
# @param cron_minute
#   The minute (1-59) at which the backup should start. If left undef, the system's default scheduling behavior applies.
#
# @param cron_month
#   Specifies the month (1-12) or a string-based cron expression (e.g., "*") to control execution. If left undef, the job runs every month.
#
# @param cron_monthday
#   Specifies the day of the month (1-31) when the backup should run. If left undef, the backup runs based on other cron settings.
#
# @param stanza_name
#   The name of the pgBackRest stanza to be configured.
#
# @param user
#   The system user under which the backup cron job runs. Defaults to root.
#
# @example
#   include profile_pgbackrest::cron
define profile_pgbackrest::cron (
  Enum['full','diff','incr']                 $backup_type   = 'incr',
  Enum['present','absent']                   $cron_ensure = 'present',
  Optional[Integer[1,12]]                    $cron_hour     = undef,
  Optional[Integer[1,59]]                    $cron_minute   = undef,
  Optional[Variant[Integer[1,12],String[1]]] $cron_month    = undef,
  Optional[Integer[1,31]]                    $cron_monthday = undef,
  String[1]                                  $stanza_name   = 'demo',
  String                                     $user          = 'root',
) {
  cron { "pgbackrest backup cron - ${backup_type}":
    ensure   => $cron_ensure,
    command  => "sudo -u postgres pgbackrest --type=${backup_type} --stanza=${stanza_name} --log-level-console=info backup",
    user     => $user,
    hour     => $cron_hour,
    minute   => $cron_minute,
    month    => $cron_month,
    monthday => $cron_monthday,
  }
}
