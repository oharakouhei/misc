#!/bin/bash

#
# あるディレクトリ内に散らかったファイルを小さいディレクトリに分割するスクリプト
# fooディレクトリ内に
# bar_0001hogehoge.huga
# のようにファイルが大量にある場合
# foo/0001/bar_0001hogehoge.huga
# に移動させる
#
max=168
i=1
str_source_dir="foo"
str_file_prefix="bar_"
until [[ i -eq max ]]; do
    # echo $i
    if [[ i -lt 10 ]]; then
        str_file_dir_num="000$i"
    elif [[ i -ge 10 && i -lt 100 ]]; then
        str_file_dir_num="00$i"
    else
        str_file_dir_num="0$i"
    fi
    mkdir "${str_source_dir}/${str_file_dir_num}"
    str_file_names="${str_file_prefix}${str_file_dir_num}*"
    source="${str_source_dir}/${str_file_names}"
    target="${str_source_dir}/${str_file_dir_num}"
    mv $source $target
    i=$(( i+1 ))
done