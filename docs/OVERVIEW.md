```yaml
Overview:
  description: Docker container escape lab for security research
  subsystems:
    vulnerable_containers: Five containers with deliberate misconfigurations
    hardened_container: One container with all known hardening applied
    escape_scripts: Proof-of-concept escape scripts for each vulnerable scenario
  data_flow: Host -> docker-compose -> containers -> escape attempts -> host verification

Features Index:
  privileged_escape:
    description: Escape from --privileged container via device mount
    entry_points: [containers/vulnerable/Dockerfile, docker-compose.yml]
    doc: docs/OVERVIEW.md
  docker_socket_escape:
    description: Escape via exposed Docker socket
    entry_points: [containers/vulnerable/Dockerfile, docker-compose.yml]
    doc: docs/OVERVIEW.md
  capabilities_escape:
    description: Escape via SYS_ADMIN/SYS_PTRACE capabilities
    entry_points: [containers/vulnerable/Dockerfile, docker-compose.yml]
    doc: docs/OVERVIEW.md
  host_mount_escape:
    description: Escape via mounted host root filesystem
    entry_points: [containers/vulnerable/Dockerfile, docker-compose.yml]
    doc: docs/OVERVIEW.md
  pid_namespace_escape:
    description: Escape via shared PID namespace
    entry_points: [containers/vulnerable/Dockerfile, docker-compose.yml]
    doc: docs/OVERVIEW.md
  hardened_probing:
    description: Zero-day probing against hardened container
    entry_points: [containers/hardened/Dockerfile, docker-compose.yml]
    doc: docs/OVERVIEW.md
```

## Scenarios

| # | Container | Vulnerability | Escape Vector |
|---|-----------|--------------|---------------|
| 1 | `escape-privileged` | `--privileged` | Mount host block device |
| 2 | `escape-docker-socket` | Docker socket mounted | Spawn privileged container via API |
| 3 | `escape-capabilities` | `CAP_SYS_ADMIN` + `CAP_SYS_PTRACE` | cgroup release_agent or overlay mount |
| 4 | `escape-host-mount` | Host `/` mounted at `/host` | Direct filesystem access, cron/ssh injection |
| 5 | `escape-pid-namespace` | `--pid=host` + `CAP_SYS_PTRACE` | nsenter into host PID 1 or ptrace host processes |
| 6 | `escape-hardened` | None (hardened) | Zero-day research target |

## Hardened Container Defenses

- Alpine minimal base image
- Non-root user (`prisoner`)
- All capabilities dropped (`cap_drop: ALL`)
- Read-only root filesystem
- `no-new-privileges` security option
- Noexec tmpfs for `/tmp`
- Default seccomp profile active
- Default AppArmor profile active
- No host mounts, no shared namespaces
