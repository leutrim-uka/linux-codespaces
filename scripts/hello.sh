#!/usr/bin/env bash

mimic() {
    echo "First parameter: $1"
    echo "Second parameter: $2"
    echo "Third parameter: $3"
}

add() {
    num1=$1
    num2=$2
    result=$((num1 + num2))
    echo $result
}

# Will not echo the result, because it is captured into a variable
output=$(add 4 5)

add $output 4