# Recipes derived from Nix Reference Manual > Development > Building Nix

set shell := ["bash", "-c"]

devenvrc := "source <(nix print-dev-env .#native-ccacheStdenv)"

buildDir := "build"

# list recipes
[private]
@default:
    just --list --unsorted --list-submodules

# build nix source
build:
    #! /usr/bin/env bash
    {{devenvrc}}

    mesonConfigurePhase && ninjaBuildPhase

# check the build
check:
    #! /usr/bin/env bash
    {{devenvrc}}

    cd {{buildDir}} && mesonCheckPhase

# install to ./outputs
install:
    #! /usr/bin/env bash
    {{devenvrc}}

    cd {{buildDir}} && ninjaInstallPhase

# run all phases
run:
    #! /usr/bin/env bash
    {{devenvrc}}

    set -e

    echo '{{YELLOW}}Buidling...{{NORMAL}}'
    just build

    echo '{{YELLOW}}Checking...{{NORMAL}}'
    just check

    echo '{{YELLOW}}Installing...{{NORMAL}}'
    just install

# build release version of nix for your platform
release:
    #! /usr/bin/env bash
    {{devenvrc}}

    nix build
