# README

## Blank skeleton description

+ DESCRIPTION / NAMESPACE: standard R Package Files

+ R/npm_install.R: the function your users will have to load once to install the node modules

+ R/run.R: the function to launch the Node script located at inst/cordes/app.js

+ inst/cordes/app.js: the script containing the code launched via the run `R/run.R` function.

+ inst/cordes/package.json: the NodeJS package definition file.

## Helper functions from {cordes}

+ `cordes::install_module("module")` installs an npm module in the node folder (i.e. it calls `npm install` inside the node folder)

