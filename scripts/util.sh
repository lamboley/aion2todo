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

# Download a remote installation script and pipe it into a shell.
#
# Output is captured and only surfaced when the installation fails, so a
# successful run stays quiet. `pipefail` — set by lib/init.sh — is what makes
# a curl failure propagate rather than being masked by the interpreter's
# exit status.
#
# Usage:
#   a2t::util::run_curl_install <url> [interpreter [args...]]
#
# Examples:
#   a2t::util::run_curl_install "https://astral.sh/uv/install.sh" sh
#   a2t::util::run_curl_install "https://get.k3s.io" sh -s -
function a2t::util::run_curl_install() {
    local url="${1:?an url is required}"
    shift

    # Default to `sh` when no interpreter is given, otherwise the pipeline
    # below would end on a dangling `|`.
    if [[ "$#" -eq 0 ]]; then
        set -- sh
    fi

    # `--fail` matters more than it looks: without it curl hands the body of an
    # HTTP error page to the interpreter, which then happily executes it.
    local output
    local ret=0
    output="$(curl --fail --silent --show-error --location "${url}" | "$@" 2>&1)" || ret=$?

    if [[ "${ret}" -ne 0 ]]; then
        a2t::log::error "${url} failed (exit ${ret})" "${output}"
        return "${ret}"
    fi

    a2t::log::info "${url} successfully executed."
}
