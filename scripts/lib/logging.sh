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

function a2t::log::info() {
    printf '\e[0;30;46mINFO[%04d]\e[0m %s\n' "${SECONDS}" "${1-}" >&2
    shift || true
    local message
    for message; do
        printf '           %s\n' "${message}" >&2
    done
}

function a2t::log::warn() {
    printf '\e[0;30;43mWARN[%04d]\e[0m %s\n' "${SECONDS}" "${1-}" >&2
    shift || true
    local message
    for message; do
        printf '           %s\n' "${message}" >&2
    done
}

function a2t::log::error() {
    printf '\e[0;97;41mERRO[%04d]\e[0m %s\n' "${SECONDS}" "${1-}" >&2
    shift || true
    local message
    for message; do
        printf '           %s\n' "${message}" >&2
    done
}

function a2t::log::fatal() {
    printf '\e[0;97;41mFATA[%04d]\e[0m %s\n' "${SECONDS}" "${1-}" >&2
    shift || true
    local message
    for message; do
        printf '           %s\n' "${message}" >&2
    done
    exit 1
}
