#!/bin/bash

#[ -n "$DEBUG" ] && set -x
set -x


: ${KEY?'missing github private key do deploy docker run -e KEY=XXXX'}

:${COMMIT_NAME:=octopress}
:${COMMIT_EMAIL:=cat@octopress.org}

# private github key comes from env variable KEY
# docker run -e KEY=XXXX
mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo $KEY|base64 -d> /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

# saves githubs host to known_hosts
ssh -T -o StrictHostKeyChecking=no  git@github.com

git config --global user.name "$COMMIT_NAME"
git config --global user.email "$COMMIT_EMAIL"

cd /tmp/blog
git fetch
git reset --hard origin/master
eval "$(rbenv init -)"
rake generate

rake deploy
