#!/bin/bash
fswatch -0 -o src | xargs -0 -n 1 bash -c 'scons platform=osx'