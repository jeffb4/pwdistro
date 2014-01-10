#!/bin/sh

# XXX get passphrase. Easier than passing fd0 prompt to gpg
echo "Generating a new private/public key pair"
echo -n "Passphrase: "
read -s PASSPHRASE
echo

# Generate new private/public keypaid, and store ID in KEY variable
KEY=$( gpg --gen-key --batch <<EOF 2>&1 | grep "marked as ultimately trusted" | awk '{ print $3 }'
%echo Generating a new key for $USER with $PASSPHRASE
%echo %dry-run
Key-Type: 1
Name-Comment: $USER pwdistro
Subkey-Type: 1
Expire-Date: 0
Passphrase: $PASSPHRASE
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF
)

mkdir -p pubkeys; chmod 700 pubkeys

gpg --armor --export $KEY > pubkeys/$USER

echo "Completed, Key $KEY exported to pubkeys/$USER"

# egrep "gpg: key \S+ marked as ultimately trusted" <<EOF
