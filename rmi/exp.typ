#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm) )

#import "../utils.typ" : rubric

#let code(filename, lang) = {
  block(stroke: 1pt + gray, inset: 10pt, radius: 10pt)[
    === #filename
    #line(length: 100%, stroke: 1pt + gray)

    #raw(read(filename), lang: lang)
  ]
}


#rubric(3, "Implement a remote calcultor using Java RMI")

#pagebreak()

#text(size: 13pt)[*Aim: Implement an RMI client and server*]

== Code

#code("CalcInterface.java", "java")
#code("CalcServer.java", "java")
#code("CalcClient.java", "java")

#pagebreak()

== Output

#image("assets/SS_2025-11-13 22-34-51.png")
#image("assets/SS_2025-11-13 22-34-57.png")

#pagebreak()
== Postlab

+ *What are the different times at which a client can be bound to a server?*\
  #sym.arrow.r.double A client can be bound to a server at three different times:
  - Compile-time binding:\
    The server location is known and fixed when the client is compiled. This is rare in distributed systems because it reduces flexibility.
  - Load-time binding:\
    The binding happens when the client program is loaded into memory. The server address might be specified in a configuration file or as a parameter.
  - Run-time (or dynamic) binding:\
    The most common approach — the client locates and connects to the server while running, using a name service, registry, or directory lookup. This allows servers to move or scale without changing the client code.

+ *How does a binding process locate a server?*\
  #sym.arrow.r.double The binding process locates a server using a name or directory service. Typically, the server registers its address and service details with a registry (like RMI Registry or a naming server).\
  When a client wants to connect, it queries this registry using a logical name, and the registry returns the server’s network address or stub. This way, clients don’t need to know the physical location of the server in advance.

+ *Name some optimization methods adopted for better performance of distributed
applications using RPC and RMI.*\
  #sym.arrow.r.double Some common optimization methods include:
  - Caching and replication: Frequently used data or objects are cached locally to reduce remote calls.
  - Batching requests: Multiple small requests are combined into a single call to reduce network overhead.
  - Asynchronous communication: Allows a client to continue working without waiting for a remote response.
  - Stub optimization: Using lightweight stubs or optimized marshalling/unmarshalling to reduce serialization cost.
  - Connection pooling: Reusing existing connections instead of opening a new one for each request.
  - Load balancing: Distributing client requests across multiple servers to prevent bottlenecks.
