#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm) )

#import "../utils.typ" : rubric

#let code(filename, lang) = {
  block(stroke: 1pt + gray, inset: 10pt, radius: 10pt)[
    === #filename
    #line(length: 100%, stroke: 1pt + gray)

    #raw(read(filename), lang: lang)
  ]
}


#rubric(2, "Implement a RPC client and server")

#pagebreak()

#text(size: 13pt)[*Aim: Implement a RPC client and server*]

== Code

#code("calc.x", "c")
#code("calc_server.c", "c")
#code("calc_client.c", "c")

#pagebreak()

== Output

#image("assets/SS_2025-11-13 23-44-55.png")
#image("assets/SS_2025-11-13 23-45-43.png")
#image("assets/SS_2025-11-13 23-46-07.png")
#image("assets/SS_2025-11-13 23-46-22.png")


#pagebreak()
== Postlab

+ *In which category of communication can RPC be included?*\
  #sym.arrow.r.double Remote Procedure Call (RPC) falls under the category of synchronous communication.  
  In this type, the client sends a request to the server and waits until the server responds before continuing execution.  
  It gives the illusion that a remote call behaves just like a local function call.

+ *What are stubs? What are the different ways of stub generation?*\
  #sym.arrow.r.double A stub is a small piece of code that acts as a gateway between the client and the remote server.  
  - On the client side, the stub represents the remote procedure and handles the communication details like marshalling and sending requests.  
  - On the server side, the stub receives the request, unpacks the parameters, and invokes the actual method.

  There are two main ways to generate stubs:
  - Static stub generation: The stubs are generated at compile time using an interface definition (for example, using `rmic` in Java RMI).
  - Dynamic stub generation: The stubs are created at runtime using reflection or dynamic proxies, removing the need for pre-generated stub files.

+ *What is binding?*\
  #sym.arrow.r.double Binding refers to the process of connecting or linking a client to the server that provides a specific service.  
  It can occur at three different times:
  - Compile-time binding – fixed during compilation.  
  - Load-time binding – done when the program is loaded.  
  - Run-time (dynamic) binding – established while the program is running, usually through a name or directory service.

+ *Name the transparencies achieved through stubs.*\
  #sym.arrow.r.double Stubs help achieve several important transparencies in distributed systems:
  - Access transparency: The client and server communicate as if they were on the same machine.  
  - Location transparency: The client doesn’t need to know where the server physically resides.  
  - Communication transparency: The details of message passing, marshalling, and transport are hidden from the programmer.
