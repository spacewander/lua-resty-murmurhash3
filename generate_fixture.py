import random
import sys
from string import ascii_letters, digits, punctuation

import mmh3


visible = ascii_letters + digits + punctuation + " \t"

def get_random_word():
    return ''.join(random.choice(visible) for i in range(random.randint(1, 20))).rstrip()

with open(sys.argv[1], "w") as f:
    py_32bit_out = open("python_32.out", "w")
    py_128bit_out = open("python_128.out", "w")
    for i in range(1000):
        word = get_random_word()
        f.write(word + "\n")
        py_32bit_out.write(str(mmh3.hash(word, i) & 0xffffffff) + "\n")
        py_128bit_out.write(mmh3.hash_bytes(word, i) + "\n")
