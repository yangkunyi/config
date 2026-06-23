# WebDAV

This host serves `/data3/yky` with `dufs` for browser access and WebDAV.

## Service

- Binary: `~/.local/bin/dufs`
- Root: `/data3/yky`
- Bind: `127.0.0.1`
- Port: `60154`
- Permission: `--allow-all`
- Runtime: tmux session `dufs`

The service intentionally binds to `127.0.0.1` because access should go through
SSH port forwarding. Do not bind it to `0.0.0.0` while `--allow-all` is enabled
unless external write access is explicitly intended.

## Start

```bash
tmux new-session -d -s dufs '/data3/yky/.local/bin/dufs /data3/yky --bind 127.0.0.1 --port 60154 --allow-all'
```

## Stop

```bash
tmux kill-session -t dufs
```

## Status

```bash
tmux ls
pgrep -af '/data3/yky/.local/bin/dufs /data3/yky'
ss -ltnp 'sport = :60154'
curl http://127.0.0.1:60154
```

## SSH Forwarding

From a local machine:

```bash
ssh -N -L 60154:127.0.0.1:60154 a100_login
```

Then open:

```text
http://127.0.0.1:60154
```

## Rclone

Create a WebDAV remote:

```bash
rclone config
```

Use these values:

```text
name: a100_dufs
type: webdav
url: http://127.0.0.1:60154
vendor: other
user: <empty>
pass: <empty>
```

Examples:

```bash
rclone lsd a100_dufs:
rclone ls a100_dufs:
rclone copy ./file.txt a100_dufs:tmp/
rclone copy a100_dufs:surg_agent ./surg_agent
```
