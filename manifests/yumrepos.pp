# @summary Configures the yum repo for pgbackrest. Only supporting RedHat
#
# @param repo_baseurl The url of the Postgresql Yum Repository
#
# @param repo_gpgkey The url to the gpgkey of the Postgresql Yum Repository for RHEL
class profile_pgbackrest::yumrepos (
  String $repo_baseurl,
  String $repo_gpgkey,
) {
  case $::facts['os']['family'] {
    'RedHat': {
      # ensure_resource('yumrepo', ['pgdg-redhat-repo'], { baseurl => $yum_repo })
      yumrepo { 'postgresql_yum_repo':
        descr         => 'yum_common_redhat',
        baseurl       => $repo_baseurl,
        gpgcheck      => true,
        gpgkey        => $repo_gpgkey,
        repo_gpgcheck => true,
      }
    }
    default: {
      fail("Unsupported OS family: ${facts['os']['family']}. Skipping yum repository configuration.")
    }
  }
}
