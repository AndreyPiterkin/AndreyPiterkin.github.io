#lang pollen

:root {
}

/* Centering the page */
body {
  margin: 3rem auto;
  max-width: 750px; 
  font-size: 1.05em;
  font-family: 'Literata', serif;
}

@media screen and (min-width: 1301px) {
  body {
    max-width: 50%;
  }

  .headline {
    white-space: nowrap;
  }
}

@media screen and (max-width: 1300px) {
  body {
    max-width: 60%;
  }

  .headline {
    white-space: nowrap;
  }
}

@media screen and (max-width: 1299px) {
  .headline {
    white-space: normal;
  }

  .headline-box {
    margin: 1em;
  }

}

@media screen and (max-width: 900px) {
  body {
    max-width: 80%;
  }

  .headline-box {
    flex-direction: column !important;
    margin: 2em;
  }


  .headline {
    white-space: nowrap;
  }

}


h2 {
  font: inherit;
  font-size: 2em;
  font-weight: 700;
  font-style: normal;
  margin-bottom: 0px;
}

h3 {
  font: inherit;
  font-size: 1em;
  font-weight: 600;
  font-style: normal;
  margin-bottom: 0px;
  margin-top: 0px;
}

p {
  font: inherit;
  font-weight: 300;
  font-style: normal;
  margin-bottom: 0px;
}

em {
  font: inherit;
  font-weight: 300;
  font-style: italic;
}

a {
  font: inherit;
  color: black;
  font-weight: 400;
  font-style: normal;
}

a:hover {
  color: grey;
}

li {
  font: inherit;
  font-weight: 300;
  display: table-row;
  margin-bottom: 0.5em;
}

ul.dash {
    font: inherit;
    list-style: none;
    margin-left: 0;
    margin-top: 0.5em;
    padding-left: 0em;
    margin-bottom: 0;
}

ul.dash > li:before {
    font: inherit;
    display: inline-block;
    content: "\2014";
    width: 1.5em;
    margin-left: -3em;
    display: table-cell;
}

