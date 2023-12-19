#lang pollen

◊(define (link url text)
  ◊a[#:href url #:target "_blank"]{◊text})

◊cols[#:gap 5]{
    ◊rows[#:gap 1]{
        ◊headline{Andrey Piterkin}
        ◊cols[#:gap 1]{
            ◊(link "/files/AndreyPiterkin2025.pdf" "cv")
            ◊(link "https://www.linkedin.com/in/andreypiterkin" "linkedin")
            ◊(link "https://www.github.com/AndreyPiterkin" "github")
        }
    }

    ◊rows[#:gap 0]{
      ◊p{I am Andrey, and I am a Junior studying Computer Science at Northeastern University. I am passionate about ◊em{systems programming}, ◊em{systematic design}, and ◊em{performant simulation}.}
      ◊empty-vspace[#:size 2]

      ◊h3{Right now, I am}
      ◊items{
          ◊item{Systematically designing a toy OS in ◊lang{Rust}}
          ◊item{Creating an ECS-based planet simulator in ◊lang{C++}}
          ◊item{Experimenting with ◊lang{Clojure}}
      }
      
      ◊empty-vspace[#:size 2]
      ◊h3{Soon, I will be}
      ◊items{
          ◊item{Working at ◊(link "https://www.mathworks.com" "MathWorks") in ◊em{Control Design Automation} for Spring 2024}
          ◊item{Taking Compiler Design (CS 4410)}
          ◊item{Working at ◊(link "https://www.databricks.com" "Databricks") for Summer 2024}
          ◊item{Working at ◊(link "https://www.datadog.com" "Datadog") for Fall 2024}
      }
    }
}
