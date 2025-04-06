#!/bin/bash

if [[ "${#}" -le 1 ]]; then
    echo "Insufficient amount of parameters - command required!" 1>&2
    exit 2
fi

if echo "${1}" | grep -qvE '^[1-9][0-9]*$'; then
    echo "${1} must be a positive integer!" 1>&2
    exit 1
fi


timestamp="${1}"

shift

elapsed=0
counter=0

while [[ $(echo "${elapsed} ${timestamp}" | awk '{print ($1 < $2)}') == '1' ]]; do
    
    before=$(date +%s.%N )
 
    ("${@}" &> /dev/null)

    after=$(date +%s.%N)

    duration=$(echo "${after} - ${before}" | bc)

    counter=$(( "${counter}" + 1 ))
 
    elapsed=$(echo "${elapsed} + ${duration}" | bc)

done

echo "Ran the command ${@} ${counter} times for $(echo 'scale=2; ${elapsed}' | bc) seconds"
echo "Average duration -" $(echo "scale=2; ${elapsed} / ${counter}" | bc)
