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

# This script installs the k3s binary from its GitHub release.
#
# Usage:
#   ENV_VAR=... scripts/install-k3s.sh
#
# Example:
#   Installing a specific version:
#     INSTALL_K3S_VERSION=v1.36.4+k3s1 scripts/install-k3s.sh
#   Installing in a specific directory:
#     INSTALL_K3S_BIN_DIR=/opt/bin scripts/install-k3s.sh
#
# Environment variables:
#   - INSTALL_K3S_VERSION
#     Version of k3s to download. Use v1.36.4+k3s1 as the default.
#
#   - INSTALL_K3S_BIN_DIR
#     Directory to install k3s binary. Use /usr/local/bin as the default.

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

function setup_env() {
    INSTALL_K3S_VERSION="${INSTALL_K3S_VERSION:-v1.36.4+k3s1}"
    INSTALL_K3S_BIN_DIR="${INSTALL_K3S_BIN_DIR:-/usr/local/bin}"

    # Skip sudo when already root.
    SUDO="sudo"
    if [[ "$(id -u)" -eq 0 ]]; then
        SUDO=""
    fi

    # https://docs.k3s.io/installation/requirements?os=rhel#rhel-10
    a2t::log::info "Installing kernel-modules-extra"
    ${SUDO} dnf install -y kernel-modules-extra


    # https://docs.k3s.io/installation/requirements?os=rhel#inbound-rules-for-k3s-nodes
    if systemctl is-active --quiet firewalld; then
        a2t::log::info "Adding firewalld rules for k3s"
        ${SUDO} firewall-cmd --permanent --add-port=6443/tcp                      # apiserver
        ${SUDO} firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 # pods
        ${SUDO} firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 # services
        ${SUDO} firewall-cmd --reload
    fi
}

function download_binary() {
    local base_url="https://github.com/k3s-io/k3s/releases/download/${INSTALL_K3S_VERSION}"

    a2t::util::ensure-temp-dir

    a2t::log::info "Downloading ${base_url}/k3s"
    a2t::util::download_from_github "${A2T_TEMP}/k3s" "${base_url}/k3s"
}

function setup_binary() {
    a2t::log::info "Installing k3s to ${INSTALL_K3S_BIN_DIR}/k3s"
    ${SUDO} mkdir -p "${INSTALL_K3S_BIN_DIR}"
    ${SUDO} install -m 0755 "${A2T_TEMP}/k3s" "${INSTALL_K3S_BIN_DIR}/k3s"

    local command
    for command in kubectl crictl ctr; do
        a2t::log::info "Linking ${INSTALL_K3S_BIN_DIR}/${command} to k3s"
        ${SUDO} ln -sf k3s "${INSTALL_K3S_BIN_DIR}/${command}"
    done
}

setup_env
download_binary
setup_binary
