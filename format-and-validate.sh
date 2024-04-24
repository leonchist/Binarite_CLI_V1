#! /bin/bash

all_tf_directories=$(find . -name '*.tf' -not -path '*.terraform*' -printf '%h\n' | sort -u)

root_dir=$(pwd)

for dir in $all_tf_directories; do
    cd "$root_dir/$dir"
    terraform fmt
    terraform init -backend=false
    terraform validate
done