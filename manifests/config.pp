class profile_pgbackrest::config (
  String $config_file_path = '/etc/pgbackrest.conf',
  Hash $configs = {},
) {
  package { 'pgbackrest': }
  
  file { $config_file_path:
    ensure  => file,
    content => epp('profile_pgbackrest/pgbackrest_config.epp', {'configs' => $configs}),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
  }

  # configs according to pgbackrest documentation
  # this is where backups will be saved
  file { '/var/lib/pgbackrest':
    ensure => directory,
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0750',
  }
}
