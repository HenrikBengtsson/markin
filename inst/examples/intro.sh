#! /usr/bin/env bash

MDI_USER=alice
MDI_HOSTNAME=dev2
MDI_PWD='~'

mdi_code_block <<...EOF...
msg="Hello world!"
date --rfc-3339=seconds
...EOF...


mdi_code_block <<...EOF...
msg="Hello world!"
...EOF...


mdi_code_block <<...EOF...
echo "\$msg"
...EOF...
