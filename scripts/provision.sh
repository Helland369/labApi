#!/usr/bin/env bash
set -euo pipefail

RUNTIME="${CONTAINER_RUNTIME:-docker}"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release git

install_docker() {
  install -m 0755 -d /etc/apt/keyrings
  if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
  fi

  CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
  ARCH="$(dpkg --print-architecture)"

  echo \
    "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list

  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  usermod -aG docker vagrant || true
  systemctl enable --now docker

  # docker compose convenience shim
  if ! command -v docker-compose >/dev/null 2>&1; then
    cat >/usr/local/bin/docker-compose <<'EOF'
#!/usr/bin/env bash
exec docker compose "$@"
EOF
    chmod +x /usr/local/bin/docker-compose
  fi
}

install_podman() {
  apt-get install -y podman podman-compose buildah skopeo uidmap slirp4netns fuse-overlayfs
}

case "$RUNTIME" in
  docker)
    install_docker
    ;;
  podman)
    install_podman
    ;;
  both)
    install_docker
    install_podman
    ;;
  *)
    echo "Unknown CONTAINER_RUNTIME: $RUNTIME (supported: docker, podman, both)" >&2
    exit 1
    ;;
esac

apt-get install -y jq unzip

cat >/etc/motd <<'EOF'
Lab cattle VM is ready.
- Repo sync path: /vagrant
- Container runtime: set by CONTAINER_RUNTIME in Vagrantfile/env
- Recreate VM anytime: vagrant destroy -f && vagrant up
EOF
