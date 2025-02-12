# @summary This defined type manages pgBackRest cron jobs.
#
# @note This defined type schedules PostgreSQL backups at a specified time.
#
# @param cron_ensure Set the cron job to present or absent
#
# @param stanza The name of the stanza to be backed up
#
# @param backup_type The type of backup to perform (e.g., "full", "incremental").
#
# @param cron_hour The hour at which the cron job runs (1-12). If `undef`, the default schedule applies.
#
# @param cron_minute The minute at which the cron job runs (1-59). If `undef`, the default schedule applies.
#
# @param cron_month The month in which the cron job runs. Can be an integer (1-12) or a string. If `undef`, the job runs every month.
#
# @param cron_monthday The day of the month on which the cron job runs (1-31). If `undef`, the job runs daily.
#
# @param user The user running the cron commands
#
# @example
#   include profile_pgbackrest::cron
define profile_pgbackrest::cron (
  Enum['present','absent']                   $cron_ensure   = 'present',
  String                                     $stanza        = 'demo',
  Enum['full','diff','incr']                 $backup_type   = 'full',
  Optional[Integer[1,12]]                    $cron_hour     = undef,
  Optional[Integer[1,59]]                    $cron_minute   = undef,
  Optional[Variant[Integer[1,12],String[1]]] $cron_month    = undef,
  Optional[Integer[1,31]]                    $cron_monthday = undef,
  String                                     $user          = 'postgres',
) {
  cron { "pgbackrest backup cron - ${backup_type}":
    ensure   => $cron_ensure,
    command  => "pgbackrest --type=${backup_type} --stanza=${stanza} --log-level-console=info backup",
    user     => $user,
    hour     => $cron_hour,
    minute   => $cron_minute,
    month    => $cron_month,
    monthday => $cron_monthday,
  }
}
