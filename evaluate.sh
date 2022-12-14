VECTOR_FILE=$1

cd src/portuguese_word_embeddings

echo Evaluating ${VECTOR_FILE}

for lang in br pt; do
    echo ${lang}
    python evaluate.py ../../models/${VECTOR_FILE}.kv ${lang}
done

ANALOGY_PATH=analogies/testset
for eval_file in $(ls ${ANALOGY_PATH}); do
    echo ${eval_file}
    python analogies.py -m ../../models/${VECTOR_FILE}.kv -t ${ANALOGY_PATH}/${eval_file}
done