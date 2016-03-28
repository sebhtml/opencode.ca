#!/bin/bash

emacs --script demo.el &> log.txt

less -S log.txt

