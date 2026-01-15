#!/bin/bash

# Build curl from release tarball
# https://curl.se/docs/install.html
# https://github.com/curl/curl/releases

if command -v /usr/local/bin/curl &>/dev/null; then
  echo "curl is already installed in /usr/local/bin/curl"
  /usr/local/bin/curl --version
  exit 0
fi

CURL_INFO_URL="https://curl.se/info"
CURL_URL="$(curl -fsSL "${CURL_INFO_URL}" | awk -F': ' '$1=="Download"{print $2}')"
if [[ -z "${CURL_URL}" ]]; then
  echo "Failed to determine curl download URL from ${CURL_INFO_URL}" >&2
  exit 1
fi
CURL_TARBALL="$(basename "${CURL_URL}")"
CURL_VERSION="${CURL_TARBALL#curl-}"
CURL_VERSION="${CURL_VERSION%.tar.gz}"
echo "Determined curl version: ${CURL_VERSION}"

echo "Installing build dependencies and a bootstrap curl..."
sudo apt update
sudo apt install -y curl build-essential pkg-config libssl-dev zlib1g-dev libpsl-dev

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

curl -Lo "${TMPDIR}/${CURL_TARBALL}" "${CURL_URL}"
tar -C "${TMPDIR}" -xf "${TMPDIR}/${CURL_TARBALL}"

echo "Building version ${CURL_VERSION} from release tarball ${TMPDIR}/${CURL_TARBALL} ..."
cd "${TMPDIR}/curl-${CURL_VERSION}"
./configure --prefix=/usr/local --with-openssl
make -j"$(nproc)"
sudo make install
sudo ldconfig

# Test curl executable
which curl
whereis curl

curl --version
/usr/local/bin/curl --version

echo "curl version ${CURL_VERSION} installed successfully."
echo "To use the newly installed curl, ensure /usr/local/bin is in your PATH before /usr/bin."
