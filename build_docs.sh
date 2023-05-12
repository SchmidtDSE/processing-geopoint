mkdir -p public
yes | sudo apt-get update
yes | sudo apt-get install pandoc
[[ ! -f public/theme.css ]] &&  wget -P public https://raw.githubusercontent.com/jez/pandoc-markdown-css-theme/master/public/css/theme.css
[[ ! -f build/template.html5 ]] &&  wget -P build https://raw.githubusercontent.com/jez/pandoc-markdown-css-theme/master/template.html5
pandoc --css=theme.css -s -f markdown+smart --metadata pagetitle="Processing Geopoint" --to=html5 --template build/template.html5 README.md -o ./public/index.html
cp build/geopoint.jar public
cp examples/basic/basic.png ./public
cp examples/geojson/geojson.png ./public
cp examples/polygon/polygon.png ./public
cp examples/transform/transform.png ./public
