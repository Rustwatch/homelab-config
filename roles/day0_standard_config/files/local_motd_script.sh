#!/bin/bash
set -u

output_dir=/run/custom
output_file="${output_dir}/motd.dynamic"
tmp_file=$(mktemp "${output_file}.XXXXXX") || exit 1

trap 'rm -f "$tmp_file"' EXIT
umask 022

for script in /etc/update-motd.d/motd_*.sh; do
    [[ -f "$script" && -x "$script" ]] || continue
    "$script" >> "$tmp_file" 2>/dev/null || true
done

chmod 0644 "$tmp_file"
mv -f "$tmp_file" "$output_file"
trap - EXIT
