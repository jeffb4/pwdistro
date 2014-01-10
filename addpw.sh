#!/bin/sh

KEYRING="./pwdistro.pub"
PWID=$(uuidgen)

echo -n "Site: "; read SITE
echo -n "Username: "; read USERNAME
echo -n "Password: "; read PASSWORD
echo -n "Comment: "; read COMMENT

for k in pubkeys/*; do
# add public key to public keyring
  gpg --armor --import --keyring $KEYRING --no-default-keyring $k
# create a destination directory for that user's copy of the password
  mkdir -p passwords/$(basename $k)
# generate a copy of the password data for the user encrypted with their
# public key
  gpg --armor -r $(basename $k) --encrypt > passwords/$(basename $k)/$PWID <<EOF
$PWID
$SITE
$USERNAME
$PASSWORD
$COMMENT
EOF
done


