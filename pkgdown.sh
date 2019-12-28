#!/bin/bash


# create container
    # docker rm -f travis
docker run -dt --name travis -w /root dongzhuoer/ci:base 2> /dev/null
docker exec travis rm .bashrc .profile
docker exec travis bash -c 'echo -e "[user]\n\tname = Zhuoer Dong\n\temail = dongzhuoer@mail.nankai.edu.cn\n" > .gitconfig'

# fetch gitbook
docker exec travis mkdir {dongzhuoer,tidyverse,r-lib}
docker exec travis git clone --depth 1 -b dongzhuoer/pgmcs      https://gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git dongzhuoer/pgmcs
docker exec travis bash -c "rm -rf */*/.git"

# auxiliary files
docker exec travis wget -O readme.md https://raw.githubusercontent.com/dongzhuoer/gist/master/cc-license.md

# push to gh-pages
docker exec travis git clone --depth 1 -b public https://gitlab-ci-token:$GITLAB_TOKEN@gitlab.com/dongzhuoer/pkgdown.dongzhuoer.com.git git 
docker exec travis mv git/.git .
docker exec travis rm -rf git
docker exec travis git add --all
docker exec travis git commit -m "Travis build at `date '+%Y-%m-%d %H:%M:%S'`" --allow-empty 
docker exec travis git push
