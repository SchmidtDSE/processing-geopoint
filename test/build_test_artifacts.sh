echo "[1 / 7] System setup"
yes | sudo apt-get update
yes | sudo apt-get install xvfb libxrender1 libxtst6 libxi6 default-jdk

echo "[2 / 7] Loading Processing"
mkdir scratch
cd scratch
[[ -f processing-4.2-linux-x64.tgz ]] && wget https://github.com/processing/processing4/releases/download/processing-1292-4.2/processing-4.2-linux-x64.tgz
tar -xf processing-4.2-linux-x64.tgz
cd ..

echo "[3 / 7] Building polygon CSV"
python polygon_to_csv.py ./examples/geojson/data/bayarea.geojson ./examples/geojson/data/bayarea.csv

echo "[4 / 7] Distributing copides of geotools..."
cp geotools.pde ./examples/basic
cp geotools.pde ./examples/geojson
cp geotools.pde ./examples/polygon
cp geotools.pde ./examples/transform

echo "[5 / 7] Clear prior results"
[[ -f examples/basic/basic.png ]] && rm examples/basic/basic.png

echo "[6 / 7] Running sketches"
xvfb-run ./scratch/processing-4.2/processing-java --sketch=examples/basic --run

echo "[7 / 7] Checking results"