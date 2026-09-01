# bash/snippets

![License: MIT](https://img.shields.io/badge/License-MIT-green.svg) ![ShellCheck: clean](https://img.shields.io/badge/ShellCheck-clean-brightgreen.svg) ![Explained at bashsnippets.xyz](https://img.shields.io/badge/explained%20at-bashsnippets.xyz-blue)

I got tired of digging the same scripts out of my own notes every time a disk filled up, a service died, or a cron job overlapped itself into an outage. This repo is those scripts: tested, copy-paste bash for real Linux boxes and cron jobs, each one explained line-by-line at [bashsnippets.xyz](https://bashsnippets.xyz). No login, no paywall, no newsletter wall — clone it, read it, run it.

**Every script in this repo:**

- runs `set -euo pipefail` — stops on the first error instead of marching past it
- uses named variables for thresholds and paths — no magic numbers to guess at
- comments explain *why* a line exists, not *what* it does
- is **ShellCheck-clean** (`shellcheck -S style`, zero findings) and mirrors the tested version explained line-by-line on the site

## Scripts

| Script | What breaks without it | Explained |
|--------|------------------------|-----------|
| [`automated-file-backup.sh`](scripts/automated-file-backup.sh) | Deleted or disk-failed data is gone with no undo. | [Read](https://bashsnippets.xyz/snippets/automated-file-backup) |
| [`bash-argument-parsing.sh`](scripts/bash-argument-parsing.sh) | A flag read as a value deploys to nowhere, silently. | [Read](https://bashsnippets.xyz/snippets/bash-argument-parsing) |
| [`bash-arrays.sh`](scripts/bash-arrays.sh) | One space in a list item silently splits it in two. | [Read](https://bashsnippets.xyz/snippets/bash-arrays) |
| [`bash-curl-api-requests.sh`](scripts/bash-curl-api-requests.sh) | curl exits 0 on HTTP 500, so a failed call poisons everything downstream. | [Read](https://bashsnippets.xyz/snippets/bash-curl-api-requests) |
| [`bash-flock-single-instance.sh`](scripts/bash-flock-single-instance.sh) | Overlapping cron runs stack copies until the box falls over. | [Read](https://bashsnippets.xyz/snippets/bash-flock-single-instance) |
| [`bash-for-loop-examples.sh`](scripts/bash-for-loop-examples.sh) | Looping over `ls` silently skips filenames with spaces. | [Read](https://bashsnippets.xyz/snippets/bash-for-loop-examples) |
| [`bash-functions.sh`](scripts/bash-functions.sh) | `return` sets an exit code, not a string — data lost. | [Read](https://bashsnippets.xyz/snippets/bash-functions) |
| [`bash-functions-arguments.sh`](scripts/bash-functions-arguments.sh) | A reused variable clobbers the caller and deletes the wrong dir. | [Read](https://bashsnippets.xyz/snippets/bash-functions-arguments) |
| [`bash-if-else-examples.sh`](scripts/bash-if-else-examples.sh) | The wrong test operator fails logic silently on odd input. | [Read](https://bashsnippets.xyz/snippets/bash-if-else-examples) |
| [`bash-parse-json-jq.sh`](scripts/bash-parse-json-jq.sh) | grep on JSON breaks the moment the API reformats — and fails silently. | [Read](https://bashsnippets.xyz/snippets/bash-parse-json-jq) |
| [`bash-read-file-line-by-line.sh`](scripts/bash-read-file-line-by-line.sh) | A missing final newline silently drops the last line. | [Read](https://bashsnippets.xyz/snippets/bash-read-file-line-by-line) |
| [`bash-retry-with-backoff.sh`](scripts/bash-retry-with-backoff.sh) | One transient error kills a deploy you then re-run by hand. | [Read](https://bashsnippets.xyz/snippets/bash-retry-with-backoff) |
| [`bash-sed-find-replace.sh`](scripts/bash-sed-find-replace.sh) | An unanchored `sed -i` across a tree rewrites substrings you never looked at. | [Read](https://bashsnippets.xyz/snippets/bash-sed-find-replace) |
| [`bash-send-email-alert.sh`](scripts/bash-send-email-alert.sh) | Failures go unnoticed until users report them. | [Read](https://bashsnippets.xyz/snippets/bash-send-email-alert) |
| [`bash-slack-webhook-alerts.sh`](scripts/bash-slack-webhook-alerts.sh) | A broken cron job fails silently for a week before anyone notices. | [Read](https://bashsnippets.xyz/snippets/bash-slack-webhook-alerts) |
| [`bash-string-manipulation.sh`](scripts/bash-string-manipulation.sh) | `cut` returns the wrong field the moment the format shifts. | [Read](https://bashsnippets.xyz/snippets/bash-string-manipulation) |
| [`bash-timeout-command.sh`](scripts/bash-timeout-command.sh) | A hung job never exits and never frees its lock. | [Read](https://bashsnippets.xyz/snippets/bash-timeout-command) |
| [`bash-trap-cleanup.sh`](scripts/bash-trap-cleanup.sh) | A crash leaves temp files behind and publishes a half-written file. | [Read](https://bashsnippets.xyz/snippets/bash-trap-cleanup) |
| [`check-if-website-is-up.sh`](scripts/check-if-website-is-up.sh) | You learn the site is down from angry users. | [Read](https://bashsnippets.xyz/snippets/check-if-website-is-up) |
| [`check-ssl-certificate-expiry.sh`](scripts/check-ssl-certificate-expiry.sh) | An expired certificate takes the site dark without warning. | [Read](https://bashsnippets.xyz/snippets/check-ssl-certificate-expiry) |
| [`create-dated-folder.sh`](scripts/create-dated-folder.sh) | Untimestamped backup folders overwrite the previous run. | [Read](https://bashsnippets.xyz/snippets/create-dated-folder) |
| [`delete-old-log-files.sh`](scripts/delete-old-log-files.sh) | Unmanaged logs fill `/var/log` until writes fail and services crash. | [Read](https://bashsnippets.xyz/snippets/delete-old-log-files) |
| [`disk-space-warning.sh`](scripts/disk-space-warning.sh) | A silently full disk crashes writes with no heads-up. | [Read](https://bashsnippets.xyz/snippets/disk-space-warning) |
| [`docker-prune-cleanup.sh`](scripts/docker-prune-cleanup.sh) | Dead containers, images, and volumes eat disk unnoticed. | [Read](https://bashsnippets.xyz/snippets/docker-prune-cleanup) |
| [`file-permissions-security.sh`](scripts/file-permissions-security.sh) | World-writable files let a compromised script overwrite your app. | [Read](https://bashsnippets.xyz/snippets/file-permissions-security) |
| [`find-duplicate-files.sh`](scripts/find-duplicate-files.sh) | Duplicate copies waste gigabytes silently across archives. | [Read](https://bashsnippets.xyz/snippets/find-duplicate-files) |
| [`find-large-files-linux.sh`](scripts/find-large-files-linux.sh) | Disk hits 100% and you can't find the culprit fast. | [Read](https://bashsnippets.xyz/snippets/find-large-files-linux) |
| [`kill-process-on-port.sh`](scripts/kill-process-on-port.sh) | `EADDRINUSE` — something squats your port and blocks startup. | [Read](https://bashsnippets.xyz/snippets/kill-process-on-port) |
| [`list-open-ports-linux.sh`](scripts/list-open-ports-linux.sh) | Unknown listening ports are the blind spot in a security audit. | [Read](https://bashsnippets.xyz/snippets/list-open-ports-linux) |
| [`monitor-cpu-ram-usage.sh`](scripts/monitor-cpu-ram-usage.sh) | A runaway process pins CPU until the server stops responding. | [Read](https://bashsnippets.xyz/snippets/monitor-cpu-ram-usage) |
| [`mysql-database-backup.sh`](scripts/mysql-database-backup.sh) | A mistaken `DROP TABLE` destroys data with no undo. | [Read](https://bashsnippets.xyz/snippets/mysql-database-backup) |
| [`quick-system-info-report.sh`](scripts/quick-system-info-report.sh) | Guessing server state during an outage costs response time. | [Read](https://bashsnippets.xyz/snippets/quick-system-info-report) |
| [`restart-service-if-stopped.sh`](scripts/restart-service-if-stopped.sh) | A crashed service stays down for hours without a watchdog. | [Read](https://bashsnippets.xyz/snippets/restart-service-if-stopped) |
| [`rsync-remote-backup.sh`](scripts/rsync-remote-backup.sh) | A local-only backup dies with the machine. | [Read](https://bashsnippets.xyz/snippets/rsync-remote-backup) |
| [`search-files-for-text-grep.sh`](scripts/search-files-for-text-grep.sh) | Hunting a pattern by opening files by hand wastes time. | [Read](https://bashsnippets.xyz/snippets/search-files-for-text-grep) |
| [`ssh-key-setup-script.sh`](scripts/ssh-key-setup-script.sh) | Password SSH invites brute-force attacks on any exposed server. | [Read](https://bashsnippets.xyz/snippets/ssh-key-setup-script) |

## Explained on the site

Two pages earn their place as full explainers rather than a single copy-paste script — a strict-mode pattern you add to *every* script, and a command reference you run interactively. They live on the site, not in `scripts/`:

- [Bash error handling with `set -euo pipefail`](https://bashsnippets.xyz/snippets/bash-error-handling)
- [Kill a process by name with `pgrep` / `pkill`](https://bashsnippets.xyz/snippets/kill-a-process)

## Browser tools

Some of these jobs are faster to build in a form than to hand-write — a cron schedule, a hardened wrapper, a chmod calculator. The interactive versions live at [bashsnippets.xyz/tools](https://bashsnippets.xyz/tools).

---

The production layer these scripts don't cover — logging, locking, alerting wired together — is the [Production Bash Toolkit](https://bashsnippets.xyz/starter-kit).

Licensed under the [MIT License](LICENSE).
