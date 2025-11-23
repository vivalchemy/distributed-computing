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




#rubric(4, "Implement the Clock Syncronization Algorithms", dateOfPerformance: datetime(day: 14, month: 11, year: 2025))

#text(size: 14pt, weight: "bold")[
  Aim: To Implement the Clock Synchronization Algorithms
]

#line(length: 100%)

== #underline("Code:")

#v(1em)

*Filesystem:*

```sh
.
├── ClockSyncAlgorithm.java
├── LamportClock.java
├── Main.java
├── Makefile
└── SuzukiKasami.java
```

#code("./Makefile", "Makefile", desc: "Builds and runs the java code")
#code("./ClockSyncAlgorithm.java", "java", desc: "Interface for the clock synchronization algorithms")
#code("./LamportClock.java", "java")
#code("./SuzukiKasami.java", "java")
#code("./Main.java", "java")


#v(2em)
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
#image("./assets/SS_2025-11-23 15-23-21.png")


#pagebreak()
== #underline("Postlab:")

+ *Distinguish between physical and logical clocks*

  #block(width: 80%)[
    #table(
      columns: (1fr, 1fr),
      inset: 7pt,
      align: (x, y) => if y == 0 { center } else { auto },
      fill: (x, y) => if y == 0 { gray.lighten(40%) },
      [ *Physical Clocks* ],
      [ *Logical Clocks* ],

      [ Represent actual time based on hardware timers ],
      [ Represent event ordering, not real time ],

      [ Can drift due to hardware imperfections ],
      [ Do not drift since values are software-maintained ],

      [ Require synchronization protocols (NTP, Cristian’s) ],
      [ Require message-based updating rules (Lamport, Vector) ],

      [ Used when real timestamps matter ],
      [ Used when causal ordering matters ],

      [ Affected by network delays and clock skew ],
      [ Not affected by hardware or drift, only logic rules ],
    )
  ]

+ *Calculation of time interval between physical clock synchronization*

  #sym.arrow.double The time interval between two physical clocks synchronization is given by:\
  $ρ$: max clock drift rate \ 
  $δ$: max allowed clock difference  \
  $T$: sync interval  \

  $T = δ / (2ρ)$

  For e.g.
  If $ρ = 10^(-5)$ and $δ = 0.1$ then\
  $T = 0.1 / (2 × 10^(-5)) = 5000$ seconds

+ *Implement the logical clock using counter*

  #sym.arrow.double The logical clock using a counter and be implemented as follows;
  - Each process maintains a counter $L C = 0$.
  - Each event increments the counter by $L C = L C + 1$
  - When sending a message we include the $L C$ in the message.
  - When receiving a message with timestamp $T$ we update the $L C$ using $L C = max(L C, T) + 1$

+ *Example of partial ordering and total ordering events*

  #sym.arrow.double Following are the examples of partial and total ordering events:
  - Partial ordering  Some events have a causal relationship, but not all pairs are comparable.\
    For e.g.\
    e1 → e2\
    e1 → e3\
    e2 and e3 are not related (no ordering between them)\

  - Total ordering  Every pair of events is comparable and placed in a single global order.\
  For e.g. e1 < e2 < e3 < e4\

#pagebreak()
5. *Compare token based and non token based clocks*
  
  #block(width: 80%)[
  #table(
    columns: (1fr, 1fr),
    inset: 7pt,
    align: (x, y) => if y == 0 { center } else { auto },
    fill: (x, y) => if y == 0 { gray.lighten(40%) },
    [ *Token–Based Clocks* ],[ *Non–Token–Based Clocks* ],

    [ Require a special token to coordinate access or ordering. ],
    [ No token is used; ordering is computed using timestamps. ],

    [ Communication overhead is low (messages only when token moves). ],
    [ Communication overhead is higher (timestamps sent with every event/message). ],

    [ No need for global ordering computation — token ensures order. ],
    [ Ordering must be computed using clock rules (Lamport, vector clocks). ],

    [ Token loss or duplication is a serious fault. ],
    [ No single point of failure; purely logical. ],

    [ Example: Suzuki–Kasami, Raymond’s tree-based algorithm. ],
    [ Example: Lamport clocks, vector clocks. ]
  )
]
