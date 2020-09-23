#!/bin/bash


# create container
    # docker rm -f rlang0
docker run -dt --name rlang0 -w /root dongzhuoer/rlang:rmarkdown 2> /dev/null
docker exec rlang0 rm .bashrc .profile
docker exec rlang0 bash -c 'echo -e "[user]\n\tname = Zhuoer Dong\n\temail = dongzhuoer@mail.nankai.edu.cn\n" > .gitconfig'
docker exec rlang0 Rscript -e "install.packages('prettydoc')"

# fetch gitbook
docker exec rlang0 mkdir {hadley,tidyverse,yihui,dongzhuoer}
docker exec rlang0 git clone --depth 1 -b rstudio/bookdown-demo  https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/bookdown-demo
docker exec rlang0 git clone --depth 1 -b hadley/r4ds            https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/r4ds
docker exec rlang0 git clone --depth 1 -b hadley/adv-r           https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/adv-r
docker exec rlang0 git clone --depth 1 -b hadley/ggplot2-book    https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/ggplot2-book
docker exec rlang0 git clone --depth 1 -b hadley/r-pkgs          https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/r-pkgs
docker exec rlang0 git clone --depth 1 -b rstudio/rmarkdown-book https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/rmarkdown-book
docker exec rlang0 git clone --depth 1 -b rstudio/bookdown       https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/bookdown  
docker exec rlang0 git clone --depth 1 -b rstudio/blogdown       https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/blogdown
docker exec rlang0 git clone --depth 1 -b tidyverse/design       https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git tidyverse/design
docker exec rlang0 git clone --depth 1 -b tidyverse/style        https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git tidyverse/style
docker exec rlang0 git clone --depth 1 -b tidyverse/tidyeval     https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git tidyverse/tidyeval
docker exec rlang0 git clone --depth 1 -b dongzhuoer/nutshell    https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git dongzhuoer/nutshell
docker exec rlang0 git clone --depth 1 -b dongzhuoer/thesis      https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git dongzhuoer/thesis
docker exec rlang0 git clone --depth 1 -b yihui/r-ninja          https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git yihui/r-ninja
docker exec rlang0 bash -c "rm -rf */*/.git"

# auxiliary files
docker cp bookdown.Rmd rlang0:/root/index.Rmd
docker exec rlang0 Rscript -e "rmarkdown::render('index.Rmd')"
docker exec rlang0 rm index.Rmd bookdown.png
docker exec rlang0 Rscript -e "download.file('https://raw.githubusercontent.com/dongzhuoer/gist/master/cc-license.md', 'readme.md')"
docker exec rlang0 bash -c 'echo -e ".gitconfig\n" > .gitignore'

# push to gh-pages
docker exec rlang0 git clone --depth 1 -b public https://gitlab-ci-token:$GITLAB_TOKEN@gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git git 
docker exec rlang0 mv git/.git .
docker exec rlang0 rm -rf git
docker exec rlang0 git rm -r --cached .
docker exec rlang0 git add --all
docker exec rlang0 git commit -m "Travis build at `date '+%Y-%m-%d %H:%M:%S'`" --allow-empty 
docker exec rlang0 git push
