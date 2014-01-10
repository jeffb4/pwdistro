#!/bin/sh

DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$_")")" && pwd -P )

KEYRING="./pwdistro.pub"
PWID=$(uuidgen)

echo -n "Site: "; read SITE
echo -n "Username: "; read USERNAME
echo -n "Password: "; read PASSWORD
echo -n "Comment: "; read COMMENT

for k in $DIR/pubkeys/*; do
# add public key to public keyring
  gpg --armor --import --keyring $KEYRING --no-default-keyring $k
# create a destination directory for that user's copy of the password
  mkdir -p $DIR/passwords/$(basename $k)
# generate a copy of the password data for the user encrypted with their
# public key
  gpg --armor -r $(basename $k) --encrypt > $DIR/passwords/$(basename $k)/$PWID <<EOF
$PWID
$SITE
$USERNAME
$PASSWORD
$COMMENT
EOF
done


