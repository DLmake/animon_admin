# Production features - checklist

Assignment: *"Add authentication/authorization, monitoring/logging and other features,
needed in production environments."*

Everything is an Ansible role in `roles/`, so it works the same with **Vagrant** (`vagrant up`)
and **Multipass** (`./up.sh`). Unfinished parts are placeholder tasks named `TODO ...` -
they run without changing anything, so the playbook keeps working while you fill them in.

Re-apply after changes: `vagrant provision` (Vagrant) or `./up.sh` (Multipass).

## Already in place

| Feature | Where |
|---|---|
| User login / registration, protected pages (`middleware('auth')`) | animon app (Laravel Breeze) |
| Health check URL `/up` | animon app (`bootstrap/app.php`) |
| `APP_DEBUG=false`, production env | `roles/app/templates/env.j2` |
| Separate DB user with rights only to its own database | `roles/app/tasks/main.yml` |

## To do

| Area | Feature | File | Done |
|---|---|---|---|
| **Auth / security** | Secrets in ansible-vault, Redis password | `roles/security/tasks/secrets.yml`, `group_vars/all.yml` | [ ] |
| | Firewall (ufw): only 22, 80, 443 open | `roles/security/tasks/firewall.yml` | [ ] |
| | SSH: keys only, no root login | `roles/security/tasks/ssh.yml` | [ ] |
| | fail2ban against brute-force logins | `roles/security/tasks/fail2ban.yml` | [ ] |
| | HTTPS (self-signed locally) + security headers | `roles/security/tasks/https.yml`, `roles/app/templates/nginx.conf.j2` | [ ] |
| | Automatic security updates | `roles/security/tasks/updates.yml` | [ ] |
| | *(optional)* admin role in the app (`is_admin` + Gates) | animon app repo | [ ] |
| **Monitoring** | node_exporter (server metrics) | `roles/monitoring/tasks/node_exporter.yml` | [ ] |
| | Prometheus | `roles/monitoring/tasks/prometheus.yml` | [ ] |
| | Grafana dashboards (with login) | `roles/monitoring/tasks/grafana.yml` | [ ] |
| | Uptime check of `/up` | `roles/monitoring/tasks/uptime.yml` | [ ] |
| **Logging** | Laravel daily logs, level warning | `roles/logging/tasks/laravel_logs.yml`, `env.j2` | [ ] |
| | Log rotation | `roles/logging/tasks/logrotate.yml` | [ ] |
| | *(optional)* Loki + Promtail central logs | `roles/logging/tasks/central_logs.yml` | [ ] |
| **Other** | Queue worker as a systemd service | `roles/workers/tasks/queue_worker.yml` | [ ] |
| | Scheduler (cron `schedule:run`) | `roles/workers/tasks/scheduler.yml` | [ ] |
| | `php artisan optimize` | `roles/app/tasks/main.yml` (TODO near the end) | [ ] |
| | Nightly MySQL backups | `roles/backups/tasks/mysql_backup.yml` | [ ] |

Before adding monitoring, raise the VM memory to 3-4 GB
(`vb.memory` in `vagrantfile`, `--memory` in `scripts/common.sh`).

## Layout

```
playbook.yml            runs the roles in order
group_vars/all.yml      shared variables (paths, DB, PHP version)
roles/
  app/                  the working app setup (was playbook.yml)
  workers/              queue worker + scheduler
  security/             firewall, SSH, fail2ban, HTTPS, secrets, updates
  logging/              Laravel logs, logrotate, central logs
  monitoring/           node_exporter, Prometheus, Grafana, uptime
  backups/              nightly MySQL dumps
    tasks/main.yml      list of parts in this role
    tasks/<part>.yml    one part each - replace the TODO task with real tasks
    defaults/main.yml   settings for the role (ports, retention, ...)
    templates/          config files the role writes (stubs to fill in)
    handlers/main.yml   service restarts
```
