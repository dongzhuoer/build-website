#!/bin/bash


# create container
    # docker rm -f travis
docker run -dt --name travis -w /root dongzhuoer/ci:base 2> /dev/null
docker exec travis rm .bashrc .profile
docker exec travis bash -c 'echo -e "[user]\n\tname = Zhuoer Dong\n\temail = dongzhuoer@mail.nankai.edu.cn\n" > .gitconfig'

# fetch gitbook
docker exec travis mkdir {hadley,tidyverse,yihui,dongzhuoer}
docker exec travis git clone --depth 1 -b rstudio/bookdown-demo  https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/bookdown-demo
docker exec travis git clone --depth 1 -b hadley/r4ds            https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/r4ds
docker exec travis git clone --depth 1 -b hadley/adv-r           https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/adv-r
docker exec travis git clone --depth 1 -b hadley/r-pkgs          https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git hadley/r-pkgs
docker exec travis git clone --depth 1 -b rstudio/rmarkdown-book https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/rmarkdown-book
docker exec travis git clone --depth 1 -b rstudio/bookdown       https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/bookdown  
docker exec travis git clone --depth 1 -b rstudio/blogdown       https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git rstudio/blogdown
docker exec travis git clone --depth 1 -b tidyverse/style        https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git tidyverse/style
docker exec travis git clone --depth 1 -b tidyverse/tidyeval     https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git tidyverse/tidyeval
docker exec travis git clone --depth 1 -b dongzhuoer/nutshell    https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git dongzhuoer/nutshell
docker exec travis git clone --depth 1 -b dongzhuoer/thesis      https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git dongzhuoer/thesis
docker exec travis git clone --depth 1 -b yihui/r-ninja          https://gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git yihui/r-ninja
docker exec travis bash -c "rm -rf */*/.git"

# auxiliary files
docker cp bookdown.md travis:/root/index.md && docker exec travis pandoc index.md -s -o index.html
docker exec travis wget -O readme.md https://raw.githubusercontent.com/dongzhuoer/gist/master/cc-license.md

# push to gh-pages
docker exec travis git clone --depth 1 -b public https://gitlab-ci-token:$GITLAB_TOKEN@gitlab.com/dongzhuoer/bookdown.dongzhuoer.com.git git 
docker exec travis mv git/.git .
docker exec travis rm -rf git
docker exec travis git add --all
docker exec travis git commit -m "Travis build at `date '+%Y-%m-%d %H:%M:%S'`" --allow-empty 
docker exec travis git push
