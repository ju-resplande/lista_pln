VECTOR_FILE=$1

cd src/portuguese_word_embeddings

echo Evaluating ${VECTOR_FILE}

for lang in (pt eu); do
    echo ${lang}
    python evaluate.py ../../${VECTOR_FILE} pt
done

ANALOGY_PATH=analogies/testset
for eval_file in $(ls ${ANALOGY_PATH}); do
    echo ${eval_file}
    python analogies.py -m ../../${VECTOR_FILE} -t ${ANALOGY_PATH}/${eval_path}
done