# The Markdown Injector - An Introduction

The following code block illustrates how to use `date` in the shell and what it's output is.

<!-- code-block #1 -->
```sh
{alice@dev2 ~}$ date --rfc-3339=seconds
2020-09-01 17:49:06-07:00
```

What is special about the above code block, is that its content can be updated by running the **markin** tool, as in:

```sh
$ markin inject intro.md
```

Here is another two code blocks:

<!-- code-block label="set-msg" -->
```sh
{alice@dev2 ~}$ pwd
~
{alice@dev2 ~}$ mkdir -p testing   ## '-p': no error if already exists
{alice@dev2 ~}$ cd testing
{alice@dev2 ~/testing}$ pwd
~/testing
{alice@dev2 ~/testing}$ msg="Hello world!"
```

<!-- code-block #3 -->
```sh
{alice@dev2 ~}$ echo "Message: '$msg'"
Message: 'Hello world!'
```

<!-- code-block label="stdin" -->
```sh
{alice@dev2 ~}$ cat > tmp.txt 
42
{alice@dev2 ~}$ cat tmp.txt
42
```

<!-- code-block label="stdin-multiline" -->
```sh
{alice@dev2 ~}$ cat > tmp.txt 
1+2
3+4
{alice@dev2 ~}$ cat tmp.txt
1+2
3+4
```
