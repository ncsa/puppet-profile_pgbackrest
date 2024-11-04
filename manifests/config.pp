class profile_pgbackrest::config (
  String                        $config_filepath   = '/etc/pgbackrest.conf',
  Optional[Hash]                $cron_jobs         = undef,
  Enum['present','absent']      $pgbackrest_ensure = 'present',
  Optional[Hash]                $stanza            = undef,
  String[1]                     $stanza_name       = '',
  Array[String[1]]              $repositories      = ['/var/lib/pgbackrest'],
  String                        $user              = 'postgres',
  String                        $group             = 'postgres',
  String                        $conf_mode         = '0644',
  String                        $var_lib_mode      = '0700',
  String                        $var_log_mode      = '0700',
) {

  package { 'pgbackrest': 
    ensure => $pgbackrest_ensure, 
  }
 
  file { '/var/log/pgbackrest':
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => $var_log_mode,
  }

#  file { '/etc/pgbackrest':
#    ensure  => directory,
#  }

#  File { '/etc/pgbackrest/conf.d':
#    ensure  => directory,
#    require => File['/etc/pgbackrest'],
#  } 

  file { $config_filepath:
    ensure  => file,
    content => epp('profile_pgbackrest/pgbackrest_config.epp', {'configs' => $stanza}),
    owner   => $user,
    group   => $group,
    mode    => $conf_mode,
  }

  $repositories.each |$repository| {
    file { $repository:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => $var_log_mode,
    }
  }

  exec { "pgbackrest create stanza":
    command => "/bin/pgbackrest --stanza=${stanza_name} --log-level-console=info stanza-create", 
    user    => postgres,
  } 

  $cron_jobs.each |$type, $properties| {
    profile_pgbackrest::cron { $type: * => $properties }
  }
}
