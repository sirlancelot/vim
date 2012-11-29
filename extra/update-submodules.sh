#!/bin/sh

git submodule foreach "git checkout -q master && git pull --ff-only"
