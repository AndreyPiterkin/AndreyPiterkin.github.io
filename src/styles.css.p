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

.statics {
  margin-left: auto;
  margin-right: 0;
  margin-top: -1em;
}

.nav-item {
  font-size: 1.3em;
  font-weight: 590;
  text-decoration: none;
  transition: color 0.1s ease-in-out, transform 0.2s ease-in-out, text-decoration 0.1s ease-in-out;
  display: inline-block; 
}

.nav-item:hover {
  color: rgb(48,48,48);
  transform: translateX(-2px);
  text-decoration: underline;
}

.nav-item:hover:after {
  content: " <";
  text-decoration: none;
  display: inline-block;
  white-space: pre;
}


.nav-item:after {
  content: " |";
}

.nav-item.active:after {
  content: " <";
  text-decoration: none;
  display: inline-block;
  white-space: pre;
}


.nav-bar > .nav-item {
  text-align: right;
}

.headline.active {}

.main {
  margin-top: 1em;
}

@media screen and (min-width: 1300px) {
  body {
    max-width: 60%;
  }

  .headline {
    white-space: nowrap;
    float: right;
    text-align: right;
  }
  
}

@media screen and (max-width: 1299px) {
  .headline.* {
    white-space: normal;
    text-align: right;
  }
}

@media screen and (max-width: 900px) {
  body {
    max-width: 80%;
  }

  .headline-box {
    flex-direction: column !important;
  }


  .headline {
    white-space: nowrap;
    text-align: center;
  }

  .statics {
    margin: auto;
  }

  .main {
    margin-top: 0em;
  }

  .nav-bar-flex {
    flex-direction: row !important; 
    column-gap: 1em !important;
    margin: auto !important;
    flex-wrap: wrap !important;
    justify-content: center !important;
  }

  .nav-item {
    font-size: 1.3em;
    font-weight: 590;
    text-decoration: none;
    transition: text-decoration 0.1s ease-in-out !important;
    display: block !important; 
  }

  .nav-item:hover {
    color: rgb(48,48,48);
    text-decoration: underline;
    transform: translate(0px) !important;
  }

  .nav-item:hover:after {
    content: "" !important; 
    text-decoration: none !important;
    display: block !important
    white-space: pre !important;
  }

  .nav-item:after {
    content: "" !important;
  }

  .nav-item.active:after {
    content: "" !important;
    text-decoration: none !important;
    display: !important block;
    white-space: !important pre;
  }

  .nav-item.active {
    text-decoration: underline !important;
  }

  .nav-bar > .nav-item {
    text-align: center !important;
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

