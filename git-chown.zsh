#!/bin/zsh

export OLD_EMAIL="$1"

if [ -z "$OLD_EMAIL" ]; then
  echo "Usage: $0 <commiter email>"
  echo "Example: $0 development@rooland.cz"
  exit 1
fi

if [ "$OLD_EMAIL" = "$(git config user.email)" ]; then
  echo "Old email and new one are same, soooo..... I would change nothing :/"
  echo "First please setup new git author ( https://help.github.com/articles/setting-your-username-in-git/ )"
  exit 1
fi

echo "E-mail which needs to be rewritten: $OLD_EMAIL"

git filter-branch --env-filter '

CORRECT_NAME="$(git config user.name)"
CORRECT_EMAIL="$(git config user.email)"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

echo 'Do you want to remove backup? -- The "duplicit" commits (y/N)'
read REMOVE_BACKUP

if [ "$REMOVE_BACKUP" = 'y' ]; then
  git update-ref -d refs/original/refs/heads/master
else
  echo 'You can do it later by this: git update-ref -d refs/original/refs/heads/master'
fi
