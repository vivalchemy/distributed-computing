#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm) )

#import "../utils.typ" : rubric

#let code(filename, lang, desc: none) = {
  let desc = if desc != none {
    text(size: 10pt, weight: "bold", fill: rgb("666"))[\: #desc]
  } else { none }

  block(stroke: 1pt + gray, inset: 10pt, radius: 10pt)[
    === #filename #desc
    #line(length: 100%, stroke: 1pt + gray)

    #raw(read(filename), lang: lang)
  ]
}

#rubric(8, "Implement Map Reduce", dateOfPerformance: datetime(year:2025, month: 11, day:20))

#pagebreak()


== Aim

Implement a Map reduce algorithm

== Code

#code("map_reduce.py", "python")

== Output

#image("./assets/SS_2025-11-30 00-46-00.png")
#pagebreak()

== Postlab

+ *Role of Mapper and Reducer in the Experiment*

#sym.arrow.double The Mapper processes each input document and produces intermediate key-value pairs.  
  In this word count experiment, the mapper takes each paragraph (document) and outputs `(word, 1)` for every word it encounters.

  The Reducer takes the grouped intermediate key-value pairs produced by the mapper and aggregates them.  
  In this case, it sums all the counts for each word to produce the final word frequency.

+ How Hadoop Shuffles and Sorts Intermediate Key-Value Pairs

#sym.arrow.double After the mapper produces intermediate key-value pairs, Hadoop performs the shuffle and sort phase:

  1. Shuffle: All values corresponding to the same key are transferred to the same reducer.
  2. Sort: The keys are sorted so that the reducer processes them in a consistent order.

  This ensures that each reducer receives all values for a particular key and can aggregate them correctly.
