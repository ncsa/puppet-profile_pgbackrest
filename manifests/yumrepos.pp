class profile_pgbackrest::yumrepos () {
  $yum_repo = 'https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.8-x86_64/'

  case $::facts['os']['family'] {
    'RedHat': {
      # ensure_resource('yumrepo', ['pgdg-redhat-repo'], { baseurl => $yum_repo })
      yumrepo { 'postgres':
        descr         => 'postgres',
        baseurl       => $yum_repo,
        gpgcheck      => false,
        gpgkey        => 'https://download.postgresql.org/pub/repos/yum/keys/RPM-GPG-KEY-PGDG-AARCH64-RHEL8',
        repo_gpgcheck => false,
      }
    }
  }
}
