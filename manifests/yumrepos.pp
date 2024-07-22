class profile_pgbackrest::yumrepos () {
  case $::facts['os']['family'] {
    'RedHat': {
      # ensure_resource('yumrepo', ['pgdg-redhat-repo'], { baseurl => $yum_repo })
      yumrepo { 'postgres':
        descr         => 'postgres',
        baseurl       => lookup('profile_pgbackrest::yumrepo_url'),
        gpgcheck      => true,
        gpgkey        => lookup('profile_pgbackrest::yumrepo_gpgkey'),
        repo_gpgcheck => true,
      }
    }
  }
}
