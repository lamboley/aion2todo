#!/usr/bin/env bash

# Copyright (c) 2026 Lucas Lamboley.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script installs k3d from its GitHub release.
#
# Usage:
#   ENV_VAR=... scripts/install-k3d.sh
#
# Example:
#   Installing a specific version:
#     INSTALL_K3D_VERSION=v5.9.0 scripts/install-k3d.sh
#   Installing in a specific directory:
#     INSTALL_K3D_BIN_DIR=/opt/bin scripts/install-k3d.sh
#
# Environment variables:
#   - INSTALL_K3D_VERSION
#     Version of k3d to download. Use v5.9.0 as the default.
#
#   - INSTALL_K3D_BIN_DIR
#     Directory to install k3d binary. Use ${HOME}/.local/bin as the default.

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

function setup_env() {
  INSTALL_K3D_VERSION="${INSTALL_K3D_VERSION:-v5.9.0}"
  INSTALL_K3D_BIN_DIR="${INSTALL_K3D_BIN_DIR:-${HOME}/.local/bin}"
}

function download_binary() {
  local filename="k3d-linux-amd64"
  local base_url="https://github.com/k3d-io/k3d/releases/download/${INSTALL_K3D_VERSION}"

  a2t::util::ensure-temp-dir

  a2t::log::info "Downloading ${base_url}/${filename}"
  a2t::util::download_from_github \
    "${A2T_TEMP}/${filename}" "${base_url}/${filename}"
}

function setup_binary() {
  a2t::log::info "Installing k3d to ${INSTALL_K3D_BIN_DIR}/k3d"
  mkdir -p "${INSTALL_K3D_BIN_DIR}"
  install -m 0755 "${A2T_TEMP}/k3d-linux-amd64" "${INSTALL_K3D_BIN_DIR}/k3d"
}

setup_env
download_binary
setup_binary
