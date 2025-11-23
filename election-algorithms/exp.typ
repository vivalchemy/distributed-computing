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




#rubric(4, "Implement the Election Algorithms", dateOfPerformance: datetime(day: 14, month: 11, year: 2025))

#text(size: 14pt, weight: "bold")[
  Aim: To Implement the Election Algorithms
]

#line(length: 100%)

== #underline("Code:")

#v(1em)

*FileSystem:*

```sh
.
├── Bully.java
├── ElectionAlgorithm.java
├── Main.java
├── Makefile
├── Process.java
└── Ring.java
```

#code("./Makefile", "Makefile", desc: "Builds and runs the Java programs")
#code("./ElectionAlgorithm.java", "java", desc: "Common interface for election algorithms")
#code("./Process.java", "java", desc: "Represents a process in the system")
#code("./Bully.java", "java")
#code("./Ring.java", "java")
#code("./Main.java", "java", desc: "Simulates both election algorithms")


== Running the code
To run the code, you need to have `Java` and `make(optional)` installed. Then, run the following commands:

```sh
make run
```

If make is not installed, you can run the following commands:

```sh
javac *.java
java Main
```

#pagebreak()
== #underline("Output:")

#image("./assets/SS_2025-11-23 12-42-41.png")
#image("./assets/SS_2025-11-23 12-42-51.png")
#image("./assets/SS_2025-11-23 12-43-14.png")
#image("./assets/SS_2025-11-23 12-43-21.png")

#pagebreak()
== #underline("Postlab:")

+ *What is the role of coordination in the distributed system?*

  #sym.arrow.double In a distributed system, coordination acts as the orchestrator that synchronizes independent nodes so they act as a single, coherent entity. Its primary role is to manage inter-process interactions by establishing the order of events, ensuring consensus on data states, and controlling access to shared resources to prevent conflicts. Without effective coordination, the system would suffer from data inconsistency, race conditions, and an inability to recover reliably from partial failures.

+ *Compare bully and ring algorithms*

#set table(
  fill: (x, y) =>
  if y == 0 {
  gray.lighten(40%)
},
  align: (x, y) =>
  if y == 0 {
  center
} else {
  auto 
},
)

#block(width: 80%)[
  #table(
    columns: (1fr, 1fr),
    table.header([Bully Algorithm], [Ring Algorithm]),

    [The active node with the highest ID forces itself as the leader.],
    [An election message circles the ring; the highest ID found after a full lap wins.],

    [ Requires a fully connected network; every node must know every other node's address. ],
    [Uses a logical ring. Nodes only need to know their immediate neighbor.],

    [ Heavy traffic. In the worst case, it generates O(n2) messages. ],
    [It typically generates fewer messages (average O(nlogn)).],

    [ Messages are sent in parallel, resulting in low latency. ],
    [The message must process sequentially through every node.],

    [If the highest-ID node is unstable, it causes frequent, wasted re-elections.],
    [If one node crashes, the ring breaks and must be repaired before electing a leader.]
  )
]
