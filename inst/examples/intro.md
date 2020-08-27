# The Markdown Injector (MDI) - An Introduction

The following code block illustrates how to use `date` in the shell and what it's output is.

<!-- code-block #1 -->
```sh
$ date --rfc-3339=seconds
2020-08-27 14:46:11-07:00
```

What is special about the above code block, is that its content can be updated by running the **mdi** tool, as in:

```sh
$ mdi intro.md
```
