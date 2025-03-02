#lang pollen

root {
}

/* Centering the page */
body {
  margin: 3rem auto;
  padding: 0;
  max-width: 750px; 
  font-size: 1.05em;
  font-family: 'Literata', serif;
}

.container {
  min-height: 100%;
}

.template-content {
  width: 100%;
  /*
  overflow-y: auto;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE and Edge */
  */
}

.footer {
  text-align: center;
  margin-top: auto;
}


/*
.content::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Opera */
}
*/

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

.nav-item.active {
  text-decoration: underline;
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

  .blog-post-left {
    flex-direction: column !important; 
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

.experience-block {
}

.experience-head {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.experience-title-name {
  display: flex;
  flex-direction: column;
  row-gap: 0em;
}

.experience-name {
  font: inherit;
  font-size: 1.1em;
  font-weight: 600;
  font-style: normal;
  margin-bottom: 0px;
  margin-top: 0px;
}


.experience-title {
  font: inherit;
  font-size: 1.1em;
  font-weight: 200;
  font-style: italic;
  margin-bottom: 0px;
  margin-top: 0px;
}


.experience-date-range {
  font: inherit;
  font-size: 1em;
  font-weight: 100;
  font-style: italic;
  margin-bottom: 0px;
  margin-top: 0px;
  text-align: right;
  white-space: nowrap;
}

.experience-langs {
  display: flex;
  flex-direction: row;
  column-gap: 1em;
  align-items: center;
}

.lang {
  display: flex;
  flex-direction: row;
  column-gap: 0.25em;
  align-items: center;
  margin-top: 0.4em;
}

.lang-name {
  margin: 0;
  display: inline;
}

.lang-dot {
    display: inline-block;
    width: 0.625rem;
    height: 0.625rem;
    border-radius: 50%;
    margin-top: 0.2em;
}

.blog-post-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-self: stretch;
}

.blog-post-left {
  display: flex;
  max-width: 80%;
  flex-wrap: wrap;
}


.blog-post-title {
  text-decoration: underline; 
  text-decoration-color: grey;
  margin-top: auto;
  margin-bottom: auto;
}

.blog-post-title:before {
  display: inline-block;
  content: ":: ";
  white-space: pre;
  font-weight: 400;
}

.blog-post-date {
  font-style: italic;
  font-weight: 100;
  margin-top: auto;
  margin-bottom: auto;
}

.blog-post-languages {
  display: flex;
  flex-direction: row;
  align-items: center;
  column-gap: 1em;
}

.blog-post-languages > * {
  margin: auto;
}

.blog-post-lang-wrapper {
  display: inline-flex;
  margin-left: 0.85em;
  align-items: center;
}

.blog-post-lang-wrapper:before {
  content: "[ ";
  display: inline-block;
  white-space: pre;
  margin: 0;
}

.blog-post-lang-wrapper:after {
  content: " ]";
  display: inline-block;
  white-space: pre;
}

.experience-bullets {
  padding-top: 0.5em;
}

.bullet-text {
  font-weight: 300;
}
