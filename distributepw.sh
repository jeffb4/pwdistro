#!/bin/sh

DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$_")")" && pwd -P )

KEYRING="./pwdistro.pub"

if [[ "$1" = "-dist" ]]; then
# distribute the password from stdin to $2
  read PWID
  read SITE
  read USERNAME
  read PASSWORD
  read COMMENT
  for k in $DIR/pubkeys/*; do
# add public key to public keyring
    gpg --trust-model always --armor --import --keyring $KEYRING --no-default-keyring $k
# create a destination directory for that user's copy of the password
    mkdir -p $DIR/passwords/$(basename $k)
# generate a copy of the password data for the user encrypted with their
# public key
    gpg --trust-model always --armor --keyring $KEYRING --no-default-keyring -r $(basename $k) --encrypt > $DIR/passwords/$(basename $k)/$PWID <<EOF
$PWID
$SITE
$USERNAME
$PASSWORD
$COMMENT
EOF
  done
else

  PWID=$1

  if [ "$PWID" = "-a" ]; then
    PWID=$( ls -1 $DIR/passwords/$USER)
  fi

  for k in $PWID; do
    gpg --use-agent --batch -q --decrypt $p | $0 -dist
  done

fi
