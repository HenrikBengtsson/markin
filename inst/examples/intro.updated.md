# The Markdown Injector (MDI) - An Introduction

The following code block illustrates how to use `date` in the shell and what it's output is.

<!-- code-block #1 -->
```sh
{alice@dev2 ~}$ date --rfc-3339=seconds
2020-09-01 10:28:24-07:00
```

What is special about the above code block, is that its content can be updated by running the **mdi** tool, as in:

```sh
$ mdi inject intro.md
```

Here is another two code blocks:

<!-- code-block #2 -->
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

