hexo generate -d
cp -R public/* .deploy/jiji262.github.io
cd .deploy/jiji262.githucd ../b.io
git add .
git commit -m “update”
git push origin master
