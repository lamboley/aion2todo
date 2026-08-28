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

# This script install tools and softwares mandatory to develop the application.
#
# Usage:
#   scripts/install.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

# uv is an extremely fast Python package and project manager.
#
# [1] https://docs.astral.sh/uv/getting-started/installation/
a2t::util::run_curl_install "https://astral.sh/uv/install.sh" sh

# pre-commit is a framework for managing and maintaining multi-language pre-commit hooks.
#
# [1] https://pre-commit.com/index.html
uv tool install pre-commit
pre-commit install
pre-commit run
a2t::log::info "pre-commit installed."

# k3d is a lightweight wrapper to run k3s in docker.
#
# [1] https://k3d.io/stable/#releases
a2t::util::run_curl_install "https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh" bash

# On RHEL, the docs say this is required.
#
# [1] https://docs.k3s.io/installation/requirements?os=rhel#rhel-10
sudo dnf install -y kernel-modules-extra

# For firewalld, the following rules a required.
#
# [1] https://docs.k3s.io/installation/requirements?os=rhel#inbound-rules-for-k3s-nodes
if systemctl is-active --quiet firewalld; then
    sudo firewall-cmd --permanent --add-port=6443/tcp #apiserver
    sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 #pods
    sudo firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 #services
    sudo firewall-cmd --reload
fi

# k3s installs itself as a systemd service.
#
# [1] https://docs.k3s.io/installation/configuration
a2t::util::run_curl_install "https://get.k3s.io" sh -s -
