# AList

This host uses a user-level AList install instead of the official systemd
installer.

## Paths

- Binary: `~/.local/bin/alist`
- Data directory: `~/.local/share/alist`
- Config: `~/.local/share/alist/config.json`
- Web port: `60154`

The official install script defaults to `/opt/alist` and its install/update
commands require root because it writes a systemd service. Avoid that flow on
this host unless a system-level install is explicitly desired.

## Start

Run AList in a dedicated tmux session:

```bash
tmux new-session -d -s alist '/data3/yky/.local/bin/alist server --data /data3/yky/.local/share/alist --log-std'
```

Then open:

```text
http://127.0.0.1:60154
```

## Stop

```bash
tmux kill-session -t alist
```

## Check Status

```bash
tmux ls
pgrep -af '/data3/yky/.local/bin/alist server --data /data3/yky/.local/share/alist'
ss -ltnp 'sport = :60154'
curl http://127.0.0.1:60154
```

## Password

The admin username is:

```text
admin
```

Set a new password with:

```bash
/data3/yky/.local/bin/alist admin set '<new-password>' --data /data3/yky/.local/share/alist
```

## Notes

Do not rely on `alist start --data ~/.local/share/alist` here. It can leave a
stale daemon pid under `~/.local/bin/daemon/pid`, causing later starts to report
`alist already started` even though nothing is listening on port `60154`.

If that happens, remove the stale daemon pid and start with tmux:

```bash
rm -f ~/.local/bin/daemon/pid
tmux new-session -d -s alist '/data3/yky/.local/bin/alist server --data /data3/yky/.local/share/alist --log-std'
```
