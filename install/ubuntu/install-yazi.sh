#!/usr/bin/env bash
set -euo pipefail

# https://github.com/sxyazi/yazi
# https://yazi-rs.github.io/docs/installation#source

REPO_URL="https://github.com/sxyazi/yazi.git"
SRC_DIR="${HOME}/yazi"
INSTALL_DIR="/usr/local/bin"
BINARIES=(yazi ya)

log() { printf '%s\n' "$*"; }

ensure_rust() {
  # Make cargo/rustup available in this non-interactive shell
  export PATH="${HOME}/.cargo/bin:${PATH}"

  if ! command -v cargo >/dev/null 2>&1 || ! command -v rustup >/dev/null 2>&1; then
    log "Installing Rust toolchain (rustup) ..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # shellcheck disable=SC1090
    [[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
    export PATH="${HOME}/.cargo/bin:${PATH}"
  fi

  rustup update >/dev/null
}

default_branch() {
  local b
  b="$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')"
  if [[ -z "${b:-}" ]]; then
    # fallback guesses
    if git show-ref --verify --quiet refs/remotes/origin/main; then
      b="main"
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
      b="master"
    else
      b="main"
    fi
  fi
  printf '%s' "$b"
}

installed_version() {
  if command -v yazi >/dev/null 2>&1; then
    # Typical output: "yazi 0.x.y" (strip possible leading 'v')
    yazi -V 2>/dev/null | awk '{print $2}' | sed 's/^v//' || true
  else
    printf ''
  fi
}

latest_tag_version() {
  # Prefer semver tags like v0.2.5 (strip leading v)
  local t
  t="$(git tag --list 'v*' --sort=-v:refname | head -n1 || true)"
  printf '%s' "${t#v}"
}

ver_gt() {
  # returns 0 if $1 > $2 (semver-ish), else 1
  [[ -z "${1:-}" || -z "${2:-}" ]] && return 1
  [[ "$1" == "$2" ]] && return 1
  [[ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -n1)" == "$1" ]]
}

clone_or_update_repo() {
  if [[ ! -d "${SRC_DIR}/.git" ]]; then
    log "Cloning yazi repo into ${SRC_DIR} ..."
    git clone --depth=1 "${REPO_URL}" "${SRC_DIR}"
  fi

  cd "${SRC_DIR}"

  # Refuse to auto-update if user has local modifications
  if ! git diff --quiet || ! git diff --cached --quiet; then
    log "Local changes detected in ${SRC_DIR}. Refusing to update automatically."
    log "Commit/stash your changes and re-run."
    exit 1
  fi

  git fetch --prune origin
  git fetch --tags --prune origin || true

  local branch upstream local_rev remote_rev
  branch="$(default_branch)"
  upstream="origin/${branch}"

  # If the upstream ref doesn't exist yet (rare), fetch it explicitly
  if ! git show-ref --verify --quiet "refs/remotes/${upstream}"; then
    git fetch --depth=1 origin "${branch}:${branch}" || true
    git fetch --depth=1 origin "${branch}" || true
  fi

  local_rev="$(git rev-parse HEAD)"
  remote_rev="$(git rev-parse "${upstream}" 2>/dev/null || true)"

  # Repo-updated flag exported via echo
  if [[ -n "${remote_rev:-}" && "${local_rev}" != "${remote_rev}" ]]; then
    log "Repo has updates (${local_rev:0:8} -> ${remote_rev:0:8}). Updating checkout ..."
    # Keep it shallow and deterministic
    git reset --hard "${upstream}"
    echo "1"
  else
    echo "0"
  fi
}

build_and_install() {
  cd "${SRC_DIR}"
  ensure_rust

  log "Building yazi (release, locked) ..."
  cargo build --release --locked

  log "Installing binaries to ${INSTALL_DIR} (sudo) ..."
  for b in "${BINARIES[@]}"; do
    sudo install -m 0755 "target/release/${b}" "${INSTALL_DIR}/${b}"
  done

  log "Installed version:"
  yazi -V
}

main() {
  local need_build=0 repo_updated=0

  repo_updated="$(clone_or_update_repo)"

  local inst_ver latest_ver
  inst_ver="$(installed_version)"
  latest_ver="$(latest_tag_version)"

  if ! command -v yazi >/dev/null 2>&1; then
    log "yazi is not installed. Will build & install."
    need_build=1
  fi

  if [[ "${repo_updated}" == "1" ]]; then
    log "Upstream repo changed. Will rebuild & install."
    need_build=1
  fi

  if [[ -n "${latest_ver:-}" && -n "${inst_ver:-}" ]] && ver_gt "${latest_ver}" "${inst_ver}"; then
    log "Newer version available (installed: ${inst_ver}, latest tag: ${latest_ver}). Will rebuild & install."
    need_build=1
  fi

  if [[ "${need_build}" == "1" ]]; then
    build_and_install
  else
    log "yazi is up to date (installed: ${inst_ver:-unknown}; repo HEAD unchanged; latest tag: ${latest_ver:-none})."
    yazi -V || true
  fi
}

main "$@"
