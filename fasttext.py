import multiprocessing
from time import time

from gensim.models import FastText

cores = multiprocessing.cpu_count() # Count the number of cores in a computer


with open('data/wikipedia.pt.nilc') as f:
    sentences = f.readlines()

sentences = [sent.split() for sent in sentences]


ft_model = FastText(min_count=20,
                     window=2,
                     vector_size=300,
                     sample=6e-5, 
                     alpha=0.03, 
                     min_alpha=0.0007, 
                     negative=20,
                     workers=cores-1)

t = time()

ft_model.build_vocab(sentences, progress_per=10000)

print('Time to build vocab: {} mins'.format(round((time() - t) / 60, 2)))

t = time()

ft_model.train(sentences, total_examples=ft_model.corpus_count, epochs=30, report_delay=1)

print('Time to train the model: {} mins'.format(round((time() - t) / 60, 2)))


ft_model.save("models/fast_text.model")
