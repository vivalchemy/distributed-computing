#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm) )

#import "../utils.typ" : rubric

#let code(filename, lang) = {
  block(stroke: 1pt + gray, inset: 10pt, radius: 10pt)[
    === #filename
    #line(length: 100%, stroke: 1pt + gray)

    #raw(read(filename), lang: lang)
  ]
}




#rubric(4, "Message Queueing with RabbitMQ/Kafka/Custom Implementation", dateOfPerformance: datetime(day: 14, month: 11, year: 2025))

#text(size: 14pt, weight: "bold")[
  Aim:\
  Implement and explore flexibility of Persistent communication using Message Queuing system.\
  OR\
  Implement a message-passing system using a middleware framework (e.g., Apache Kafka or RabbitMQ)
]

#line(length: 100%)

== #underline("Code:")

#v(1em)

#text(weight: "bold")[
  File Structure:
]

```sh
.
├── bun.lock
├── compose.yaml # docker compose for the rabbit mq
├── package.json # amqp library to interact with rabbit mq
├── publisher.js # publisher code
├── subscriber.js # subscriber code
└── utils.js # shared connection code
```

#code("./package.json", "json")
#code("./compose.yaml", "yaml")
#code("./utils.js", "js")
#code("./publisher.js", "js")
#code("./subscriber.js", "js")

#pagebreak()
== #underline("Screenshots:")

#image("./assets/SS_2025-11-23 11-24-51.png")
#image("./assets/SS_2025-11-23 11-25-09.png")
#image("./assets/SS_2025-11-23 11-25-16.png")
#image("./assets/SS_2025-11-23 11-25-22.png")
#image("./assets/SS_2025-11-23 11-27-01.png")

#pagebreak()
== #underline("Postlab:")

#v(2em)

+ *What is message queueing?*

  #sym.arrow.double Message queueing is a communication method where data is sent as discrete messages between processes or systems through a queue. Instead of communicating directly, a sender places messages into the queue, and a receiver processes them later—allowing both to work independently and at different speeds. This makes applications more reliable, scalable, and fault-tolerant, since the queue ensures messages aren’t lost even if a service is slow or temporarily unavailable.

+ *What are the benefits of message queueing?*

  #sym.arrow.double The benefits of message queueing are: 
  - Asynchronous processing: Long or slow tasks can run in the background without blocking user-facing services.
  - Decoupling: Producers and consumers work independently without needing to run at the same time.
  - Scalability: Consumers can be scaled horizontally to process messages faster when load increases.
  - Reliability: Messages are stored safely in the queue, preventing data loss if a service crashes.
  - Smoothing out the load: Queues absorb spikes in workload so systems are not overwhelmed.
