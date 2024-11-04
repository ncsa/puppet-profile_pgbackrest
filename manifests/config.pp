class profile_pgbackrest::config (
  String                        $config_filepath   = '/etc/pgbackrest/pgbackrest.conf',
  Boolean                       $manage_cron       = false,
  Enum['present','absent']      $pgbackrest_ensure = 'present',
  Optional[Hash]                $stanza            = undef,
  String[1]                     $stanza_name       = '',
  Array[String[1]]              $repositories      = ['/var/lib/pgbackrest'],
  Enum['postgres','pgbackrest'] $repository_owner  = 'postgres',
) {

  package { 'pgbackrest': 
    ensure => $pgbackrest_ensure, 
  }
 
  file { '/var/log/pgbackrest'
    ensure  => 'directory',
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0770',
    #require => File['/etc/pgbackrest']
  }

  file { '/etc/pgbackrest'
    ensure  => directory,
  }

  file { '/etc/pgbackrest/conf.d'
    ensure  => directory,
    require => File['/etc/pgbackrest'],
  }

  file { '/etc/pgbackrest/conf.d'
    ensure  => directory,
    require => File['/etc/pgbackrest'],
  }

  file { $config_filepath:
    ensure  => file,
    content => epp('profile_pgbackrest/pgbackrest_config.epp', {'configs' => $stanza}),
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0640',
    require => File['/etc/pgbackrest'],
  }

  $repositories.each |$repository| {
    file { $repository:
      ensure => directory,
      owner  => $repository_owner,
      group  => $repository_owner,
      mode   => '0750',
    }
  }
#  exec { "pgbackrest create stanza" 
#    command => "pgbackrest --stanza=${stanza_name} --log-level-console=info stanza-create", 
#    user    => postgres,
#    onlyif  => ["[ -s ${confi_filepath} ]"],
#  } 

#  $cron_jobs.each |$type, $properties| {
#    profile_pgbackrest::cron { $type: * => $properties }
#  }
}
