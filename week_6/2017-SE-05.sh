#!/bin/bash

if [[ "${#}" -ne 2 ]]; then
    echo "Invalid amoubt of args" 1>&2
    exit 1
fi

if [[ ! -d "${1}" ]]; then
    echo "${1} is not a dir!" 1>&2
    exit 2
fi

# тук има корекция със използването на sort. На упражненията споменах че тук лексикографското сортиране би проработило, тъй като сравнението на версиите върви по числата отляво надясно
# това е грешно, тъй като самите числа все пак трябва да бъдат сравнявани почислово, тоест трябва да се сортира по колоните, разделени с точки
# сортирането може да се извърши по много начини, един от тях е да използваме awk, за да принтираме колони, съдържащи версията на файла, както и цялото му име. Версията на файла ще използваме
# като ключ, по който да извършим сортировката, след което ще го изрежем от изходните данни

find "${1}" -type f | grep -E "vmlinuz-[0-9]+(\.[0-9]+){2}-${2}\$" | xargs -I{} basename {} | awk -F '-' '{print $2,$0}' | sort -nrk 1,1 -nrk 2,2 -nrk 3,3 -t '.' | cut -d ' ' -f 2- | head -n 1
