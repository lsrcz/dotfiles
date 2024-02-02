{ stack, writeShellScriptBin }:
writeShellScriptBin "stack-upload" ''
  #! /usr/bin/env bash

  stack upload --candidate $1
''
