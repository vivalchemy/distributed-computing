#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm))

#let _rubricHeader() = {
  set text(size: 13pt)

  align(center)[
    #text(size: 14pt, weight: "bold")[
      FR. CONCEICAO RODRIGUES COLLEGE OF ENGINEERING

      Department of Computer Engineering
    ]

    #text(size: 14pt, weight: "bold")[
      Academic Year 2025-2026
    ]

    #text(fill: rgb("#ff0000"))[
      == #underline[Rubrics for Lab Experiments]
    ]
  ]

}

#let _rubricSubjectDetails(subjectName, subjectCode) = {
box(width: 80%)[
  #text(weight: "bold")[
    #table(
      columns:(auto, auto, 1fr, auto),
      stroke: none,
    )[
        // here
      Class:][B.E. Computer\ Engineering][#align(right)[Subject Name:]][#subjectName][
      Semster:][VIII][#align(right)[Subject Code:]][#subjectCode]
  ]
]
}


#let _rubricPracticalDetails(practicalNo, title, dateOfPerformance, rollNo, studentName) = {
  set text(size: 13pt)
  table(
    columns: (auto, 1fr),
    inset: 14pt,
    [* Practical No.*],[#practicalNo],
    [* Title:*],[#title],
    [* Date of Performance:*],[#dateOfPerformance.display("[day]-[month]-[year]")],
    [* Roll No.*],[#rollNo],
    [* Student*],[#studentName]
  )
}

#let _rubricEvaluation() = {
  set text(size: 13pt)
  [=== Evaluation]
  set text(size: 12pt)

  set table(
    fill: (x, y) =>
    if x == 0 or y == 0 { rgb("#cccccc") },
  )


table(
  columns: (17%, 15%, 15%, 20%, 20%, 13%),
  align: horizon,
[*Performance Indicator*],[*Below Average*],[*Average*],[*Good*],[*Excellent*],[*Marks*],
  [*On Time Submission (2)*],[Not submitted(0)],[Submitted after deadline (1)],[Early or on time submission (2)],[---],[],
  [* Test cases and output (4)*],[Incorrect output (1)],[The expected output is verified only a for few test cases (2)],[The expected output is Verified for all test cases but is not presentable (3)],[Expected output is obtained for all test cases. Presentable and easy to follow (4)],[],
  [* Coding efficiency (2) *],[The code is not structured at all (0)],[The code is structured but not efficient (1)],[The code is Structured and efficient. (2)],[-],[],
  [*Knowledge(2)*],[Basic concepts not clear (0)],[Understood the basic concepts (1)],[Could explain the concept with suitable example (1.5)],[Could relate the theory with real world
application(2)],[],
  table.cell(inset: 14pt)[*Total*],table.cell(colspan:5)[]
)

}

#let _rubricTeacherSignature() = {
  text(size: 13pt, weight: "bold")[Signature of the Teacher:]
}


#let rubric(practicalNo, title, dateOfPerformance: datetime.today(), rollNo : 9914, studentName : "Vivian Ludrick")= {
  _rubricHeader()
  _rubricSubjectDetails("DC Lab1", "CSL801")
  _rubricPracticalDetails(practicalNo, title, dateOfPerformance, rollNo, studentName)
  _rubricEvaluation()
  _rubricTeacherSignature()
}

// #rubric(1, "Introduction to Distributed Computing")
