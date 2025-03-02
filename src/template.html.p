~(define name "Andrey Piterkin")

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:ital,opsz,wght@0,7..72,200;0,7..72,300;0,7..72,400;0,7..72,500;0,7..72,600;0,7..72,700;0,7..72,800;0,7..72,900;1,7..72,200;1,7..72,300;1,7..72,400;1,7..72,500;1,7..72,600;1,7..72,700;1,7..72,800;1,7..72,900&display=swap" rel="stylesheet">
        <title>~|name|</title>
        <link rel="stylesheet" type="text/css" href="/styles.css" />
    </head>
    <body>
    ~(->html
        ~flex[rows (gap 2) (class "container")]{
            ~flex[cols (gap 5) (class "headline-box")]{
                ~flex[rows (gap 1) (class "menu")]{
                    ~headline{Andrey Piterkin}
                    ~flex[(? "nav-bar-flex") (gap 0.5) (class "nav-bar")]{
                        ~nav[(url "/experience.html") (target "")]{experience}
                        ~nav[(url "/blog.html") (target "")]{blog}
                        ~nav[(url "https://www.linkedin.com/in/andreypiterkin")]{linkedin}
                        ~nav[(url "https://www.github.com/AndreyPiterkin")]{github}
                        ~nav[(url "/files/AndreyPiterkin2025.pdf")]{cv}
                    }
                }
                ~div[#:class "template-content"]{
                    ~|doc|
                }
            }
            ~div[#:class "footer"]{
                ~p{© 2025 Andrey Piterkin}
            }
        }
    )
    </body>
    </html>
