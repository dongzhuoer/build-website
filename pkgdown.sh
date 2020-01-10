#!/bin/bash


# create container
    # docker rm -f rlang0
docker run -dt --name rlang0 -w /root dongzhuoer/rlang:rmarkdown 2> /dev/null
docker exec rlang0 rm .bashrc .profile
docker exec rlang0 bash -c 'echo -e "[user]\n\tname = Zhuoer Dong\n\temail = dongzhuoer@mail.nankai.edu.cn\n" > .gitconfig'
docker exec rlang0 Rscript -e "install.packages('prettydoc')"

# fetch gitbook
docker exec rlang0 mkdir {dongzhuoer,tidyverse,r-lib}
docker exec rlang0 git clone --depth 1 -b dongzhuoer/pgmcs      https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/pgmcs
docker exec rlang0 git clone --depth 1 -b dongzhuoer/paristools       https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/paristools
docker exec rlang0 git clone --depth 1 -b dongzhuoer/mcapomorphy       https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/mcapomorphy
docker exec rlang0 git clone --depth 1 -b dongzhuoer/bisecpp       https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/bisecpp
docker exec rlang0 git clone --depth 1 -b dongzhuoer/biozhuoer       https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/biozhuoer
docker exec rlang0 git clone --depth 1 -b dongzhuoer/minir       https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/minir
docker exec rlang0 git clone --depth 1 -b dongzhuoer/rget        https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/rget
docker exec rlang0 git clone --depth 1 -b dongzhuoer/rGEO.data         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/rGEO.data
docker exec rlang0 git clone --depth 1 -b dongzhuoer/rGEO         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/rGEO
docker exec rlang0 git clone --depth 1 -b dongzhuoer/Rcppzhuoer         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/Rcppzhuoer
docker exec rlang0 git clone --depth 1 -b dongzhuoer/qGSEA        https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/qGSEA
docker exec rlang0 git clone --depth 1 -b dongzhuoer/libzhuoer         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/libzhuoer
docker exec rlang0 git clone --depth 1 -b dongzhuoer/hgnc         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/hgnc
docker exec rlang0 git clone --depth 1 -b dongzhuoer/minir         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/minir
docker exec rlang0 git clone --depth 1 -b dongzhuoer/zhuoerdown         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/zhuoerdown
docker exec rlang0 git clone --depth 1 -b dongzhuoer/ggcsgb         https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/ggcsgb
docker exec rlang0 git clone --depth 1 -b dongzhuoer/shapebase          https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/shapebase
docker exec rlang0 bash -c "rm -rf */*/.git"

# auxiliary files
docker cp pkgdown.Rmd rlang0:/root/index.Rmd
docker exec rlang0 Rscript -e "rmarkdown::render('index.Rmd')"
docker exec rlang0 rm index.Rmd
docker exec rlang0 Rscript -e "download.file('https://raw.githubusercontent.com/dongzhuoer/gist/master/cc-license.md', 'readme.md')"
docker exec rlang0 bash -c 'echo -e ".gitconfig\n" > .gitignore'

# push to gh-pages
docker exec rlang0 git clone --depth 1 -b public https://gitlab-ci-token:$GITLAB_TOKEN@gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git git 
docker exec rlang0 mv git/.git .
docker exec rlang0 rm -rf git
docker exec rlang0 git rm -r --cached .
docker exec rlang0 git add --all
docker exec rlang0 git commit -m "Travis build at `date '+%Y-%m-%d %H:%M:%S'`" --allow-empty 
docker exec rlang0 git push
