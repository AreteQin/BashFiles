#! /bin/bash

echo "============================================="
echo "Where are you located?"
echo "(1) China"
echo "(2) Canada"
read location

## for Python source
case ${location} in
"1")
    echo "1!"
    ;;
"2")
    echo "2!"
    ;;
esac
