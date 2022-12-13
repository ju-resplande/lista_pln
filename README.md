# Lista nlp

## Install requirements

``` bash
    pip install wikiextractor gensim
    pip install -r portuguese_word_embeddings/requirements.txt
```

## Steps

### 1. Download data

``` bash
mkdir data
wget https://dumps.wikimedia.org/ptwiki/latest/ptwiki-latest-pages-articles.xml.bz2 --directory-prefix ./data
```

### 2. Preprocess data

``` bash
cd data
wikiextractor https://dumps.wikimedia.org/ptwiki/latest/ptwiki-latest-pages-articles.xml.bz2 

cd ../1-billion-word-language-modeling-benchmark
bash scripts/get_data.sh # modified script

cd ../portuguese_word_embeddings
python preprocessing.py ../data/text.tokenized/wikipedia.pt.shuffled.sorted.tokenized ../data/wikipedia.pt.nilc
```

## 3.Training

``` bash
bash glove.sh
bash wang2vec.sh
python fasttext.py
python word2vec.py
```


## 4. Evaluation
``` bash
bash evaluate.sh glove
bash evaluate.sh wang2vec
bash evaluate.sh fasttext
bash evaluate.sh word2vec
```