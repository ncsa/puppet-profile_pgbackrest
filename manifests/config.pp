class profile_pgbackrest::config (
  String $config_file_path = '/etc/pgbackrest/pgbackrest.conf',
  Hash $config = {}
) {
  file { $config_file_path:
    ensure  => file,
    content => epp('pgbackrest/pgbackrest.conf.erb', $config),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
  }
}
