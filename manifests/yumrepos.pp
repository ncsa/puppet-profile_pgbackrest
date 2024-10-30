# @summary Configure  the pgbackrest yumrepos
#
# @example
#   include profile_pgbackrest::yumrepos
class profile_pgbackrest::yumrepos () {
  case $::facts['os']['family'] {
    'RedHat': {
      yumrepo { 'yum_common_redhat':
        descr         => 'yum_common_redhat',
        baseurl       => lookup('profile_pgbackrest::yumrepos::repo_baseurl'),
        gpgcheck      => true,
        gpgkey        => lookup('profile_pgbackrest::yumrepos::repo_gpgkey'),
        repo_gpgcheck => true,
      }
    }
    default: {
      fail("Unsupported OS family: ${::facts['os']['family']}. This module only supports RedHat.")
    }
  }
}
