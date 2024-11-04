define profile_pgbackrest::cron (
  Enum['full','diff','incr']        $backup_type   = 'incr', 
  Optional[Integer[1,12]]           $cron_hour     = undef,
  Optional[Integer[1,59]]           $cron_minute   = undef,
  Optional[Integer[1,12],String[1]] $cron_month    = undef,
  Optional[Integer[1,31]]           $cron_monthday = undef,
) {
  cron { "pgbackrest backup cron":
    ensure    => $cron_ensure,
    command   => "pgbackrest --stanza=${backup_type} --log-level-console=info backup",
    user      => postgres, 
    hour      => $cron_hour,
    minute    => $cron_minute,
    month     => $cron_month,
    monthday  => $cron_monthday,
  }
}
