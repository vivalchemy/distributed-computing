#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm) )

#import "../rubrics.typ" : rubric

#rubric(1, "Multithreaded Client Server")

#pagebreak()


#let code(filename, lang) = {
  block(stroke: 1pt + gray, inset: 10pt, radius: 10pt)[
    === #filename
    #line(length: 100%, stroke: 1pt + gray)

    #raw(read(filename), lang: lang)
  ]
}

== Aim

Create a Client Server architecuture using socket programming in java where the server needs to be multithreaded

== Code

#code("ChatServer.java", "java")
#code("ChatClient.java", "java")

#pagebreak()

== Output
#image("assets/10Nov25_22h31m38s.png")
#image("assets/10Nov25_22h32m10s.png")
#image("assets/10Nov25_22h32m34s.png")
#image("assets/10Nov25_22h33m30s.png")

#pagebreak()

== Postlab

#image("assets/postlab1.png", width: 95%)
#image("assets/postlab2.png")

