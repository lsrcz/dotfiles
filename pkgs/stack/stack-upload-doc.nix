{ stack, writeShellScriptBin }:
writeShellScriptBin "stack-upload-doc" ''
  #! /usr/bin/env bash

  cd $1

  dist=`stack path --dist-dir 2>/dev/null`

  echo -e "\033[1;36mGenerating documentation...\033[0m"
  stack haddock

  if [ "$?" -eq "0" ]; then
    docdir=$dist/doc/html
    cd $docdir
    doc=$1-$2-docs
    echo -e "Compressing documentation from \033[1;34m$docdir\033[0m for \033[1;35m$1\033[0m-\033[1;33m$2\033[1;30m"
    cp -r $1 $doc
    tar -c -v -z --format=ustar -f $doc.tar.gz $doc
    echo -e "\033[1;32mUploading to Hackage...\033[0m"
    cabal upload -d $doc.tar.gz
    exitcode=$?
    rm -rf $doc
    rm $doc.tar.gz
    exit $exitcode
  else
    echo -e "\033[1;31mNot in a stack-powered project\033[0m"
  fi
''

