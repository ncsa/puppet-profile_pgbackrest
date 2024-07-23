class profile_pgbackrest::yumrepos () {
  case $::facts['os']['family'] {
    'RedHat': {
      # ensure_resource('yumrepo', ['pgdg-redhat-repo'], { baseurl => $yum_repo })
      yumrepo { 'yum_common_redhat':
        descr         => 'yum_common_redhat',
        baseurl       => lookup('profile_pgbackrest::yum_common_redhat_url'),
        gpgcheck      => true,
        gpgkey        => lookup('profile_pgbackrest::yumrepo_gpgkey'),
        repo_gpgcheck => true,
      }
    }
  }
}
