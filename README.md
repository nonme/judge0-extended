# judge0-extended

Fork of [judge0/judge0](https://github.com/judge0/judge0) CE v1.13.1 with additional Go versions. Current release: **v1.13.1-extended.1**. Language IDs are compatible with [ce.judge0.com](https://ce.judge0.com).

## Added languages

| ID | Language | Notes |
|----|----------|-------|
| 60 | Go (1.13.5) | Upstream, retained for backwards compatibility |
| 95 | Go (1.18.5) | First release with generics |
| 106 | Go (1.22.10) | Compatible with ce.judge0.com id 106 |
| 107 | Go (1.23.5) | Compatible with ce.judge0.com id 107 |

All other languages are identical to upstream judge0 CE v1.13.1.

## Deploy on a fresh server

### Prerequisites

Ubuntu 22.04, Docker, Docker Compose.

cgroup v1 is required. Add `systemd.unified_cgroup_hierarchy=0` to `GRUB_CMDLINE_LINUX` in `/etc/default/grub`, then run `sudo update-grub && sudo reboot`.

### Steps

```bash
git clone https://github.com/nonme/judge0-extended.git
cd judge0-extended
```

Set passwords in `judge0.conf`:
- `REDIS_PASSWORD` — generate a random password
- `POSTGRES_PASSWORD` — generate another random password

Go 1.18+ requires higher limits for compilation. Set in `judge0.conf`:
```
MAX_FILE_SIZE=10240
MAX_MAX_FILE_SIZE=102400
CPU_TIME_LIMIT=15
MAX_CPU_TIME_LIMIT=15
WALL_TIME_LIMIT=20
MAX_WALL_TIME_LIMIT=20
```

Start everything (first run builds the Docker image, takes a few minutes):

```bash
docker compose up -d db redis
sleep 10s
docker compose up -d
sleep 5s
```

API is available at `http://<SERVER_IP>:2358`. Docs at `http://<SERVER_IP>:2358/docs`.

## Update from upstream

```bash
git fetch upstream
git merge upstream/master
# resolve conflicts if any, then rebuild
docker compose build
docker compose up -d
```

## License

Same as upstream — [LICENSE](LICENSE).
