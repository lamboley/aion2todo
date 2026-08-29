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

# This script installs uv from its GitHub release.
#
# Usage:
#   ENV_VAR=... scripts/install-uv.sh
#
# Example:
#   Installing a specific version:
#     INSTALL_UV_VERSION=0.12.7 scripts/install-uv.sh
#   Installing in a specific directory:
#     INSTALL_UV_BIN_DIR=/opt/bin scripts/install-uv.sh
#
# Environment variables:
#   - INSTALL_UV_VERSION
#     Version of uv to download. Use 0.12.7 as the default.
#
#   - INSTALL_UV_BIN_DIR
#     Directory to install uv binary. Use ${HOME}/.local/bin as the default

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

function setup_env() {
    INSTALL_UV_VERSION=${INSTALL_UV_VERSION:-0.12.7}
    INSTALL_UV_BIN_DIR="${INSTALL_UV_BIN_DIR:-${HOME}/.local/bin}"
}

function download_binary() {
    local filename="uv-x86_64-unknown-linux-gnu.tar.gz"
    local url="https://releases.astral.sh/github/uv/releases/download/${INSTALL_UV_VERSION}/${filename}"

    a2t::util::ensure-temp-dir

    a2t::log::info "Downloading ${url}"
    a2t::util::download_from_github "${A2T_TEMP}/${filename}" "${url}"

    tar --extract --gzip --no-same-owner --strip-components 1 \
        --file "${A2T_TEMP}/${filename}" --directory "${A2T_TEMP}"
}

function setup_binary() {
    a2t::log::info "Installing uv to ${INSTALL_UV_BIN_DIR}/uv"
    a2t::log::info "Installing uvx to ${INSTALL_UV_BIN_DIR}/uvx"
    mkdir -p "${INSTALL_UV_BIN_DIR}"
    install -m 0755 "${A2T_TEMP}/uv" "${A2T_TEMP}/uvx" "${INSTALL_UV_BIN_DIR}"
}

setup_env
download_binary
setup_binary
