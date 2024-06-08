# This is a script that installs all the required packages to compile this book.
# Add the packages needed to build your content in this list (also in the
# DESCRIPTION file).

install.packages(c('bookdown', 'learnitdown', 'sessioninfo'),
  repos = c('https://learnitr.r-universe.dev', 'https://cloud.r-project.org'))
