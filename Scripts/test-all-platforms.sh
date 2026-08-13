#!/usr/bin/env bash
#
#  test-all-platforms.sh
#  SwiftExtras
#
#  Created by Wesley de Groot on 2026-08-06.
#  https://wesleydegroot.nl
#
#  https://github.com/0xWDG/SwiftExtras
#  MIT License
#

set -u
set -o pipefail

SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIRECTORY="$(cd "${SCRIPT_DIRECTORY}/.." && pwd)"
BUILD_DIRECTORY="${PROJECT_DIRECTORY}/.build/platform-tests"
SWIFT_CONTAINER_IMAGE="${SWIFT_CONTAINER_IMAGE:-swift:6.0}"
FAILURES=()

run_check() {
    local name="$1"
    shift

    printf '\n==> %s\n' "${name}"
    if "$@"; then
        printf 'PASS: %s\n' "${name}"
    else
        printf 'FAIL: %s\n' "${name}" >&2
        FAILURES+=("${name}")
    fi
}

build_for_apple_platform() {
    local name="$1"
    local destination="$2"
    local sdk="$3"
    local derived_data_path="${BUILD_DIRECTORY}/${name}"

    if ! xcrun --sdk "${sdk}" --show-sdk-path >/dev/null 2>&1; then
        printf '\nSKIP: %s build (%s SDK is not installed)\n' "${name}" "${sdk}"
        return
    fi

    run_check \
        "${name} build" \
        xcodebuild \
            -scheme SwiftExtras \
            -destination "${destination}" \
            -derivedDataPath "${derived_data_path}" \
            -skipPackagePluginValidation \
            -quiet \
            build
}

test_linux() {
    if [[ "$(uname -s)" == "Linux" ]]; then
        run_check "Linux tests" swift test
        return
    fi

    if [[ "${SKIP_LINUX:-0}" == "1" ]]; then
        printf '\nSKIP: Linux tests (SKIP_LINUX=1)\n'
        return
    fi

    if ! command -v container >/dev/null 2>&1; then
        printf '\nFAIL: Linux tests require Apple container on non-Linux hosts.\n' >&2
        FAILURES+=("Linux tests")
        return
    fi

    if ! container system status >/dev/null 2>&1; then
        printf '\nFAIL: Apple container is not running. Run: container system start\n' >&2
        FAILURES+=("Linux tests")
        return
    fi

    run_check \
        "Linux tests (${SWIFT_CONTAINER_IMAGE})" \
        container run --rm \
            --mount "type=bind,source=${PROJECT_DIRECTORY},target=/workspace,readonly" \
            --workdir /workspace \
            "${SWIFT_CONTAINER_IMAGE}" \
            swift test --scratch-path /tmp/swift-extras-build
}

cd "${PROJECT_DIRECTORY}" || exit 1
mkdir -p "${BUILD_DIRECTORY}"

if [[ "$(uname -s)" == "Darwin" ]]; then
    run_check "macOS tests" swift test
    build_for_apple_platform "ios" "generic/platform=iOS Simulator" "iphonesimulator"
    build_for_apple_platform "tvos" "generic/platform=tvOS Simulator" "appletvsimulator"
    build_for_apple_platform "watchos" "generic/platform=watchOS Simulator" "watchsimulator"
    build_for_apple_platform "catalyst" "generic/platform=macOS,variant=Mac Catalyst" "macosx"
else
    printf '\nSKIP: Apple platform builds require macOS with Xcode.\n'
fi

test_linux

if (( ${#FAILURES[@]} > 0 )); then
    printf '\nFailed checks:\n' >&2
    printf '  - %s\n' "${FAILURES[@]}" >&2
    exit 1
fi

printf '\nAll available platform checks passed.\n'
