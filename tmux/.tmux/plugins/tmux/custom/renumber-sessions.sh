#!/usr/bin/env bash
sessions=$(tmux list-sessions -F '#S' | grep '^[0-9]\+$' | sort -n)

new=2 # Since we start indexing from 1
for old in $sessions
do
  tmux rename-session -t $old $new
  ((new++))
done
