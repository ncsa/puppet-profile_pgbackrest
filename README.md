# profile_pgbackrest

This profile installs and configures pgbackrest for RHEL machine only.

For pgBackrest User Guide, see: https://pgbackrest.org/user-guide-rhel.html

## Dependencies
- [puppet/epel]()
- [puppetlabs/stdlib](https://forge.puppet.com/modules/puppetlabs/stdlib/readme)

## Usage

In a role.pp or profile.pp file:
```
include ::profile_pgbackrest
```

Hiera Data:
```
---
profile_pgbackrest::config::stanza_name: 'demo'
profile_pgbackrest::config::stanza:
  demo:
    pg1-path: "/var/lib/pgsql/data"
  global:
    repo1-path: "/backups/pgbackrest"
    repo1-retention-full: 2 
    repo1-bundle: y
    start-fast: y
    compress-type: zst

profile_pgbackrest::config::repositories:
  - "/backups/pgbackrest"

profile_pgbackrest::config::cron_jobs:
  'full':
    backup_type: 'full'
    cron_hour: 5
    cron_minute: 30
```

## Notes
- This profile limits to creating 1 stanza.
