import multiprocessing
from time import time
import os

from gensim.models import Word2Vec
from gensim.test.utils import datapath

cores = multiprocessing.cpu_count() # Count the number of cores in a computer

path = os.path.join(os.path.abspath('.'), 'data/wikipedia.pt.nilc')
corpus_file = datapath(path)

w2v_model = Word2Vec(min_count=20,
                     window=2,
                     vector_size=300,
                     sample=6e-5, 
                     alpha=0.03, 
                     min_alpha=0.0007, 
                     negative=20,
                     workers=cores-1)

t = time()

w2v_model.build_vocab(corpus_file=corpus_file, progress_per=10000)

print('Time to build vocab: {} mins'.format(round((time() - t) / 60, 2)))

t = time()

w2v_model.train(sentences, total_examples=w2v_model.corpus_count, epochs=30, report_delay=1)

print('Time to train the model: {} mins'.format(round((time() - t) / 60, 2)))


w2v_model.save("models/word2vec.model")
