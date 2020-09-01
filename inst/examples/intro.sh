#! /usr/bin/env bash
#' @usage: mdi build intro.sh

# shellcheck disable=SC2034
MDI_USER=alice
MDI_HOSTNAME=dev2
MDI_PS1="{\u@\h \w}\$ "

mdi_code_block <<EOF
date --rfc-3339=seconds
EOF


mdi_code_block --label=set-msg <<EOF
pwd
mkdir -p testing   ## '-p': no error if already exists
cd testing
pwd
msg="Hello world!"
EOF


mdi_code_block <<EOF
echo "Message: '\$msg'"
EOF
