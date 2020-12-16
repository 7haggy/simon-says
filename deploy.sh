# abort on errors
set -e

# build
yarn run build

# navigate into the build output directory
cd dist

git init
git add -A
git commit -m 'deploy'

git push -f https://github.com/7haggy/simon-says.git master:gh-pages

cd -