from collections import defaultdict
from itertools import chain
import re

documents = [
    """
    When you arise in the morning, think of what a precious privilege it is to be alive — to breathe, to think, to enjoy, to love.
    """,
    """
    Do not act as if you were going to live ten thousand years. Death hangs over you. While you live, while it is in your power, be good.
    """,
    """
    The happiness of your life depends upon the quality of your thoughts; therefore, guard accordingly, and take care that you entertain no notions unsuitable to virtue and reasonable nature.
    """,
    """
    If you are distressed by anything external, the pain is not due to the thing itself, but to your estimate of it; and this you have the power to revoke at any moment.
    """,
    """
    Everything we hear is an opinion, not a fact. Everything we see is a perspective, not the truth.
    """,
]

def map_function(document):
    """Splits a document into words and returns (word, 1) pairs"""
    for word in re.findall(r"\b\w+\b", document.lower()):
        yield (word, 1)

def shuffle(mapped_data):
    grouped_data = defaultdict(list)
    for key, value in mapped_data:
        grouped_data[key].append(value)
    return grouped_data

def reduce_function(key, values):
    return (key, sum(values))

def map_reduce(documents):
    mapped = list(chain.from_iterable(map(map_function, documents)))
    grouped = shuffle(mapped)
    reduced = [reduce_function(key, vals) for key, vals in grouped.items()]
    return reduced

if __name__ == "__main__":
    result = map_reduce(documents)
    # sort by count descending
    result.sort(key=lambda kv: kv[1], reverse=True)
    # print top 20 most frequent words
    for word, count in result[:20]:
        print(word, count)

