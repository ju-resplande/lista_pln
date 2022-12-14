DATA_DIR='../../data/wikipedia.pt.nilc'

cd src/wang2vec
make
./word2vec -train ${DATA_DIR} -output ../../models/wang2vec.kv \
 -type 0 -size 50 -window 5 -negative 10 -nce 0 -hs 0 -sample 1e-4 -threads 1 -binary 0 -iter 5 -cap 0
