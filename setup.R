# Learnitdown configuration and functions
learnitdown <- list(
  baseurl = "https://learnitr.github.io/bookdown", # The base URL for the site
  imgbaseurl =
    "https://learnitr.github.io/bookdown/images", # The base URL for external (big) images (or a subdir of baseurl if not used)
  shiny_imgdir = "images/shinyapps",   # The Shiny image directory (screenshots)
  package = "mycoursepkg",             # Associated package for the exercises
  institutions = c(                    # Known institutions
    "MySchool1",
    "MySchool2"
  ),
  courses = c(                        # Identifiers for your courses
    "IntroStat",
    "RProg"
  ),
  courses_names = c(
    "Introductory Statistics",
    "R Programming"
  ),
  acad_year = "2023-2024",               # The academic (university) year
  YY = 23,                               # The academic year short id
  W = as.Date("2023-09-10") + (0:37)*7,  # Sundays before each academic week
  Q1 = as.Date("2023-09-10") + (0:14)*7, # There are 15 weeks at Q1
  Q2 = as.Date("2024-02-04") + c(0:8, 11:15)*7, # Q2 starts 04/02 w22 but w30-31 are holidays
  # Add any constant that you would like to use in the book, example:
  teacher = "John Doe"                   # In the book: `r !"The teacher is {teacher}"`
)

# We use glue() often for variables replacement from learnitdown, so, we
# define the `!` operator for character objects to glue the string
# Cons: it slightly slows down the usual `!` operator (10x slower)
`!` <- function(x) {
  if (is.character(x)) {
    as.character(glue::glue_data(learnitdown, x))
  } else {# Usual ! operator
    .Primitive('!')(x)
  }
}

# Examples:
#!"The course {course[1]} for academic year {acad_year}"
#  -> The course IntroStat for academic year 2023-2024

## Big images (animated gifs, ...) are stored externally, refer them this way:
#
# `r img("sub_dir", "image_name.gif")`
# or to add a caption (use ''' instead of ` if you need it in your caption):
# # `r img("sub_dir", "image_name.gif", caption = "A nice picture.")`

## h5p(), launch_shiny(), learnr() & assignation() for exercises blocks, use:
#
# `r h5p(x, toc = "Short description")`
#
# `r launch_shiny(url, toc = "Short description")`
#
# `r learnr(id, title = "...", toc = "Short description")`
#
#```{r assign_A01Ia_markdown, echo=FALSE, results='asis'}
#if (exists("assignment"))
#  assignment("A01Ia_markdown", part = NULL,
#    url = "https://github.com/ORG/A01Ia_markdown",
#    course.ids = c(
#      'IntroStat'          = !"A01Ia_{YY}A_markdown", # Site or session A
#      'RProg'              = !"A01Ia_{YY}B_markdown", # Site or session B
#      'late_a'             = !"A01Ia_{YY}A_markdown"), # Late users for site A
#    course.urls = c(
#      'IntroStat'         = "https://classroom.github.com/a/...",
#      'RProg'             = "https://classroom.github.com/a/...",
#      'late_a'            = "https://classroom.github.com/a/..."),
#    course.starts = c(
#      'IntroStat'         = !"{W[1]+1} 08:00:00",
#      'Rprog'             = NA, # Nondefined date, or just ignore it
#      'late_a'            = !"{W[1]+1} 08:00:00"),
#    course.ends = c(
#      'IntroStat'         = !"{W[3]+5} 23:59:59",
#      'RProg'             = !"{W[5]+5} 23:59:59"),
#    term = "Q1", level = 3,
#    toc = "First use of Markdown")
#```
# Use assignment2() for group assignment, and challenge() or challenge2()
# for assignments that are linked to challenges
#
# Then, at the end of the module, create the exercises toc with:
#
# `r show_ex_toc()`
#
# Use `r learnitdown::clean_ex_toc()` at the beginning of index.Rmd to
# make sure the ex dir is clean when the book compiles

img <- function(..., caption = "") {
  path <- paste(learnitdown$imgbaseurl, ..., sep = "/")
  # Cannot use ` inside R code => use ''' instead
  caption <- gsub("'''", "`", caption)
  paste0("![", caption, "](", path, ")")
}

h5p <- function(id, toc = "", ...)
  learnitdown::h5p(id, toc = toc, baseurl = learnitdown$baseurl,
    toc.def = "H5P exercise {id}",
    h5p.img = "images/list-h5p.png",
    h5p.link = paste(learnitdown$baseurl, "h5p", sep = "/"), ...)

launch_shiny <- function(url, toc = "", fun = paste(learnitdown$package, "run_app", sep = "::"),
  alt1 = "*Click to start the Shiny application*",
  #alt1 = "*Cliquez pour lancer l'application Shiny.*",
  alt2 = "*Click to start or [run `{run.cmd}`]({run.url}{run.arg}) in RStudio.*", ...) #,
  #alt2 = "*Cliquez pour lancer ou [exécutez dans RStudio]({run.url}{run.arg}){{target=\"_blank\"}} `{run.cmd}`.*", ...)
  learnitdown::launch_shiny(url = url, toc = toc, imgdir = learnitdown$shiny_imgdir,
    fun = fun, alt1 = alt1, alt2 = alt2, toc.def = "Shiny application {app}",
    run.url = paste(learnitdown$baseurl, "/", learnitdown$rstudio,  "?runrcode=", sep = ""),
    app.img = "images/list-app.png",
    app.link = paste(learnitdown$baseurl, "shiny_app", sep = "/"), ...)

launch_report <- function(module, course = "IntroStat", toc = NULL, fun = NULL,
  alt1 = "*Click to see the progress report.*",
  #alt1 = "*Cliquez pour visualiser le rapport de progression.*",
  alt2 = "*Click to calculate your progress report for this module.*",
  #alt2 = "*Cliquez pour calculer votre rapport de progression pour ce module.*",
  height = 800, ...)
  learnitdown::launch_shiny(url =
      paste0("https://SERVER/sdd-progress-report?course=", course,
        "&module=", module),
    toc = toc, imgdir = learnitdown$shiny_imgdir,
    fun = fun, alt1 = alt1, alt2 = alt2, toc.def = "Progress report {app}",
    run.url = paste(learnitdown$baseurl, "/", learnitdown$rstudio,  "?runrcode=", sep = ""),
    app.img = "images/list-app.png",
    app.link = paste(learnitdown$baseurl, "shiny_app", sep = "/"), height = height, ...)

# Note: not used yet!
launch_learnr <- function(url, toc = "", fun = paste(learnitdown$package, "run", sep = "::"), ...)
  launch_shiny(url = url, toc = toc, fun = fun, ...)

learnr <- function(id, title = NULL, toc = "", package = learnitdown$package,
  text = "Work now on the tutarial exercises")
  #text = "Effectuez maintenant les exercices du tutoriel")
  learnitdown::learnr(id = id, title = title, package = package, toc = toc,
    text = text, toc.def = "Tutorial {id}", #toc.def = "Tutoriel {id}",
    rstudio.url = paste(learnitdown$baseurl, learnitdown$rstudio, sep = "/"),
    tuto.img = "images/list-tuto.png",
    tuto.link = paste(learnitdown$baseurl, "tutorial", sep = "/"))

# Note: use course.urls = c(`IntroStat` = "classroom url1", `RProg` = "classroom url2"), and url = link to Github template repository for the assignment
assignment <- function(name, url, course.ids = NULL, course.urls = NULL,
  course.starts = NULL, course.ends = NULL, part = NULL, toc = "", clone = TRUE,
  level = 3, n = 1, type = "ind. github", acad_year = !"{acad_year}",
  term = "Q1", texts = learnitdown::assignment_fr())
  learnitdown::assignment(name = name, url = url, course.ids = course.ids,
    course.urls = course.urls, course.starts = course.starts,
    course.ends = course.ends, part = part,
    course.names = stats::setNames(learnitdown$courses_names,
      learnitdown$courses), toc = toc, clone = clone, level = level, n = n,
    type = type, acad_year = acad_year, term = term, texts = texts,
    assign.img = "images/list-assign.png",
    assign.link = paste(learnitdown$baseurl, "github_assignment", sep = "/"),
    template = "assignment_fr.html", baseurl = learnitdown$baseurl)

assignment2 <- function(name, url, course.ids = NULL, course.urls = NULL,
  course.starts = NULL, course.ends = NULL, part = NULL, toc = "", clone = TRUE,
  level = 4, n = 2, type = "group github", acad_year = !"{acad_year}",
  term = "Q1", texts = learnitdown::assignment2_fr())
  learnitdown::assignment2(name = name, url = url, course.ids = course.ids,
    course.urls = course.urls, course.starts = course.starts,
    course.ends = course.ends, part = part,
    course.names = stats::setNames(learnitdown$courses_names,
      learnitdown$courses), toc = toc, clone = clone, level = level, n = n,
    type = type, acad_year = acad_year, term = term, texts = texts,
    assign.img = "images/list-assign2.png",
    assign.link = paste(learnitdown$baseurl, "github_assignment", sep = "/"),
    template = "assignment_fr.html", baseurl = learnitdown$baseurl)

challenge <- function(name, url, course.ids = NULL, course.urls = NULL,
  course.starts = NULL, course.ends = NULL, part = NULL, toc = "", clone = TRUE,
  level = 3, n = 1, type = "ind. challenge", acad_year = !"{acad_year}",
  term = "Q1", texts = learnitdown::challenge_fr())
  learnitdown::challenge(name = name, url = url, course.ids = course.ids,
    course.urls = course.urls, course.starts = course.starts,
    course.ends = course.ends, part = part,
    course.names = stats::setNames(learnitdown$courses_names,
      learnitdown$courses), toc = toc, clone = clone, level = level, n = n,
    type = type, acad_year = acad_year, term = term, texts = texts,
    assign.img = "images/list-challenge.png",
    assign.link = paste(learnitdown$baseurl, "github_challenge", sep = "/"),
    template = "assignment_fr.html", baseurl = learnitdown$baseurl)

challenge2 <- function(name, url, course.ids = NULL, course.urls = NULL,
  course.starts = NULL, course.ends = NULL, part = NULL, toc = "", clone = TRUE,
  level = 4, n = 2, type = "group challenge", acad_year = !"{acad_year}",
  term = "Q1", texts = learnitdown::challenge2_fr())
  learnitdown::challenge2(name = name, url = url, course.ids = course.ids,
    course.urls = course.urls, course.starts = course.starts,
    course.ends = course.ends, part = part,
    course.names = stats::setNames(learnitdown$courses_names,
      learnitdown$courses), toc = toc, clone = clone, level = level, n = n,
    type = type, acad_year = acad_year, term = term, texts = texts,
    assign.img = "images/list-challenge2.png",
    assign.link = paste(learnitdown$baseurl, "github_challenge", sep = "/"),
    template = "assignment_fr.html", baseurl = learnitdown$baseurl)

# Note: use `r learnitdown::clean_ex_toc()` at the beginning of index.Rmd to
# make sure the ex dir is clean when the book compiles.
show_ex_toc <- function(header = "", clear.it = TRUE)
  learnitdown::show_ex_toc(header = header, clear.it = clear.it)

# Include javascript and css code for {learnitdown} additional features
# in style.css and header.html, respectively
learnitdown::learnitdown_init(
  baseurl = learnitdown$baseurl,
  hide.code.msg = "See the code",
  #hide.code.msg = "Voir le code",
  institutions = learnitdown$institutions,
  courses = learnitdown$courses)

# Knitr default options
knitr::opts_chunk$set(comment = "#", fig.align = "center")
