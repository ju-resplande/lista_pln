#!/bin/bash -e

# Copyright 2013 Google Inc. All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Does all the corpus preparation work.
#
# Assumes you have already untarred ${DATA_DIR}/text.tgz:
# tar --extract -v \
# --file ../statmt.org/tar_archives/${DATA_DIR}/text.tgz \
# --wildcards ${DATA_DIR}/text/news.20??.en.shuffled
#
# Takes the data in:
# ./${DATA_DIR}/text/news.20??.en.shuffled, removes duplication with sort -u
# and runs punctuation normalization and tokenization, producing the data in:
# ./${DATA_DIR}/text.tokenized/wikipedia.pt.shuffled.tokenized
#
# It then splits the data in 100 shards, randomly shuffled, sets aside
# held-out data, and splits it into 50 test partitions.

# Punctuation normalization and tokenization.

DATA_DIR=../data

if [ -d ${DATA_DIR}/text.tokenized ]
then
  rm -rf ${DATA_DIR}/text.tokenized/*
else
  mkdir ${DATA_DIR}/text.tokenized
fi

# Set environemnt vars LANG and LANGUAGE to make sure all users have the same
# locale settings.
export LANG=pt
export LANGUAGE=pt_BR
export LC_ALL=pt_BR.utf8

for dir in $(ls ${DATA_DIR}/text); do

  dir_path=${DATA_DIR}/text/${dir}
  for file in $(ls ${dir_path}); do
    file_path=${dir_path}/${file}
    cat ${file_path}
  done
done | sort -u --output=${DATA_DIR}/text.tokenized/wikipedia.pt.shuffled.sorted
echo "Done sorting corpus."


echo "Working on ${DATA_DIR}/text/wikipedia.pt.shuffled.sorted"
time cat ${DATA_DIR}/text.tokenized/wikipedia.pt.shuffled.sorted | \
  ./scripts/normalize-punctuation.perl -l ${LANG} | \
  ./scripts/tokenizer.perl -l ${LANG} > \
  ${DATA_DIR}/text.tokenized/wikipedia.pt.shuffled.sorted.tokenized
echo "Done working on ${DATA_DIR}/text/wikipedia.pt.shuffled."

# Split the data in 100 shards
if [ -d ${DATA_DIR}/text.tokenized.shuffled ]
then
  rm -rf ${DATA_DIR}/text.tokenized.shuffled/*
else
  mkdir ${DATA_DIR}/text.tokenized.shuffled
fi
./scripts/split-input-data.perl \
  --output_file_base="${DATA_DIR}/text.tokenized.shuffled/wikipedia.pt" \
  --num_shards=100 \
  --input_file=${DATA_DIR}/text.tokenized/wikipedia.pt.shuffled.sorted.tokenized
echo "Done splitting/shuffling corpus into 100 shards wikipedia.pt-000??-of-00100."

# Hold 00000 shard out, and split it 50 way.
if [ -d ${DATA_DIR}/heldout.tokenized.shuffled ]
then
  rm -rf ${DATA_DIR}/heldout.tokenized.shuffled/*
else
  mkdir ${DATA_DIR}/heldout.tokenized.shuffled
fi

mv ${DATA_DIR}/text.tokenized.shuffled/wikipedia.pt-00000-of-00100 \
  ${DATA_DIR}/heldout.tokenized.shuffled/
echo "Set aside shard 00000 of wikipedia.pt-000??-of-00100 as held-out data."

./scripts/split-input-data.perl \
  --output_file_base="$PWD/${DATA_DIR}/heldout.tokenized.shuffled/wikipedia.pt.heldout" \
  --num_shards=50 \
  --input_file=${DATA_DIR}/heldout.tokenized.shuffled/wikipedia.pt-00000-of-00100
echo "Done splitting/shuffling held-out data into 50 shards."