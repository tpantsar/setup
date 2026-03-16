#!/bin/bash
# Automatically generate an SSH key (if missing) and add it to GitHub via Github CLI.
# Ensure GitHub SSH auth works; if not, upload an SSH key via GitHub CLI.

# Optional override:
# SSH_KEY=~/.ssh/id_ed25519
SSH_KEY="${SSH_KEY:-}"

# Skip when gh isn't installed yet to avoid aborting the full installer.
if ! command -v gh >/dev/null 2>&1; then
  echo "gh not found; skipping GitHub SSH key setup."
  exit 0
fi

# Prefer modern key, but also consider RSA
DEFAULT_KEYS=(
  "${HOME}/.ssh/id_ed25519"
  "${HOME}/.ssh/id_rsa"
)

HOST="github.com"
SSH_USER="git"

PRIVATE_KEY="${SSH_KEY:-${HOME}/.ssh/id_ed25519}"
PUB_KEY="${PRIVATE_KEY}.pub"
EMAIL="${EMAIL:-$(git config --get user.email 2>/dev/null || true)}"
EMAIL="${EMAIL:-tomi.pantsar@gmail.com}"
TITLE="${TITLE:-$(hostname)-$(date +%Y%m%d-%H%M%S)}"

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 1
  }
}

# Detect GitHub's "success" banner (exit code is often 1 even on success)
ssh_auth_works_with_key() {
  local key="$1"
  [[ -f "$key" ]] || exit 1

  local extra_opts=()
  # If supported, avoid interactive host key prompt on first connect
  if ssh -o StrictHostKeyChecking=accept-new -G "$HOST" >/dev/null 2>&1; then
    extra_opts+=(-o StrictHostKeyChecking=accept-new)
  fi

  local out
  out="$(
    ssh \
      "${extra_opts[@]}" \
      -o BatchMode=yes \
      -o IdentitiesOnly=yes \
      -i "$key" \
      -T "${SSH_USER}@${HOST}" 2>&1 || true
  )"

  grep -qiE "successfully authenticated|^Hi [^!]+!" <<<"$out"
}

ensure_gh_auth_with_public_key_scope() {
  # Are we logged in?
  if ! gh auth status -h "$HOST" >/dev/null 2>&1; then
    echo "Not logged into GitHub via gh. Starting login..."
    # Request the needed scope up-front.
    gh auth login -h "$HOST" --git-protocol ssh --scopes admin:public_key
  fi

  # Do we have the required scope?
  local scopes_line scopes
  scopes_line="$(gh auth status -h "$HOST" 2>/dev/null | sed -n 's/.*Token scopes: //p' || true)"
  scopes="$(tr -d "'" <<<"$scopes_line" | tr ',' ' ')" # normalize

  if ! grep -qw "admin:public_key" <<<"$scopes"; then
    echo "gh token is missing scope admin:public_key; refreshing authorization..."
    gh auth refresh -h "$HOST" --scopes admin:public_key
  fi
}

need_cmd ssh
need_cmd gh
need_cmd awk
need_cmd grep
need_cmd sed
need_cmd tr

# Generate SSH key if missing
if [[ ! -f "${PRIVATE_KEY}" ]]; then
  echo "Generating a new SSH key at ${PRIVATE_KEY}..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$PRIVATE_KEY" -N ""
else
  echo "SSH key already exists at ${PRIVATE_KEY}"
fi

# Ensure public key exists (some setups have private key but missing .pub)
if [[ ! -f "$PUB_KEY" ]]; then
  echo "Public key missing; regenerating ${PUB_KEY} from private key..."
  ssh-keygen -y -f "$PRIVATE_KEY" >"$PUB_KEY"
  chmod 644 "$PUB_KEY"
fi

# If SSH already works with any existing key, stop.
echo "Checking existing SSH authentication to GitHub..."
if [[ -n "$SSH_KEY" ]]; then
  if ssh_auth_works_with_key "$SSH_KEY"; then
    echo "Already authenticated to GitHub over SSH using: $SSH_KEY"
    exit 0
  fi
else
  for k in "${DEFAULT_KEYS[@]}"; do
    if ssh_auth_works_with_key "$k"; then
      echo "Already authenticated to GitHub over SSH using: $k"
      exit 0
    fi
  done
fi

# Ensure gh auth + scopes only when we actually need to upload a key.
echo "Ensuring GitHub CLI auth (and required scopes) for SSH key management..."
ensure_gh_auth_with_public_key_scope

echo "Checking if this SSH key is already added to GitHub..."
LOCAL_KEY_TWOFIELDS=$(awk '{print $1" "$2}' "$PUB_KEY")

# Pull all keys for the authenticated user via REST API
# /user/keys returns JSON with "key": "ssh-ed25519 AAAAB3...".
REMOTE_KEYS="$(gh api /user/keys --paginate --jq '.[].key' 2>/dev/null || true)"

# Normalize remote keys the same way and check for exact match
if awk '{print $1" "$2}' <<<"$REMOTE_KEYS" | grep -qxF "$LOCAL_KEY_TWOFIELDS"; then
  echo "This SSH key is already uploaded to GitHub. Skipping add."
else
  echo "Uploading SSH key to GitHub..."
  gh ssh-key add "$PUB_KEY" -t "$TITLE"
  echo "SSH key successfully added."
fi

# Test GitHub SSH access
echo "Testing GitHub SSH connection with ${PRIVATE_KEY}..."
if ssh_auth_works_with_key "$PRIVATE_KEY"; then
  echo "GitHub SSH authentication is working with ${PRIVATE_KEY}"
else
  echo "SSH still isn't authenticating with ${PRIVATE_KEY}."
  echo "Tip: ensure the key is loaded (ssh-agent) and that Git is using SSH:"
  echo "  ssh -i \"$PRIVATE_KEY\" -o IdentitiesOnly=yes -T git@github.com"
fi
