class profile_pgbackrest::postgresql_conf (
  String $config_file_path = '/var/lib/pgsql/12/data/postgresql.conf',
  Hash $configs = {},
) {
  configs.each | $key, $value | {
    first_line { '${key}_first_line':
      path => $config_file_path,
      line => '${key} = ${value}', 
      match => '^${key} = '
    }
  }
}
