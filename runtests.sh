#!/bin/bash

for x in `ls tests | grep -v "\.c"`; do
    echo "$x:"
    ./tests/$x
    echo
done
