#! /usr/bin/env bash
#' @usage: mdi build intro.sh

# shellcheck disable=SC2016,SC2034
MDI_USER=alice
MDI_HOSTNAME=dev2
PS1="{\u@\h \w}\$ "

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


ans=42
mdi_code_block --label=fake-input <<EOF
read -r -p "Enter a number: " ans 
echo "Answer: $ans"
#cat > tmp.txt # mdi-hide <<< "42"; echo "42"
#cat tmp.txt
EOF


mdi_code_block --label=stdin <<EOF
cat > tmp.txt # mdi-hide <<< "42"; echo "42"
cat tmp.txt
EOF

mdi_code_block --label=stdin-multiline <<EOF
cat > tmp.txt # mdi-hide <<< "$(printf '1+2${ENTER}3+4')"; printf "1+2\n3+4\n"
cat tmp.txt
EOF
