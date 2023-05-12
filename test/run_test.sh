echo "[1 / 7] System setup"
yes | sudo apt-get update
yes | sudo apt-get install xvfb libxrender1 libxtst6 libxi6 default-jdk

echo "[2 / 7] Loading Processing"
mkdir -p scratch
cd scratch
[[ ! -f processing-4.2-linux-x64.tgz ]] && wget https://github.com/processing/processing4/releases/download/processing-1292-4.2/processing-4.2-linux-x64.tgz
tar -xf processing-4.2-linux-x64.tgz
cd ..

echo "[3 / 7] Clear prior results"
[[ -f examples/geojson/data/bayarea.csv ]] && rm examples/geojson/data/bayarea.csv
[[ -f examples/basic/basic.png ]] && rm examples/basic/basic.png
[[ -f examples/transform/transform.png ]] && rm examples/transform/transform.png
[[ -f examples/polygon/polygon.png ]] && rm examples/polygon/polygon.png
[[ -f examples/polygon/geojson.png ]] && rm examples/geojson/geojson.png

echo "[4 / 7] Building polygon CSV"
python polygon_to_csv.py ./examples/geojson/data/bayarea.geojson ./examples/geojson/data/bayarea.csv

echo "[5 / 7] Distributing copides of geotools..."
mkdir -p examples/basic/code
mkdir -p examples/geojson/code
mkdir -p examples/polygon/code
mkdir -p examples/transform/code
cp build/geopoint.jar examples/basic/code
cp build/geopoint.jar examples/geojson/code
cp build/geopoint.jar examples/polygon/code
cp build/geopoint.jar examples/transform/code

echo "[6 / 7] Running sketches"
xvfb-run ./scratch/processing-4.2/processing-java --sketch=examples/basic --run
sleep 1
xvfb-run ./scratch/processing-4.2/processing-java --sketch=examples/transform --run
sleep 1
xvfb-run ./scratch/processing-4.2/processing-java --sketch=examples/polygon --run
sleep 1
xvfb-run ./scratch/processing-4.2/processing-java --sketch=examples/geojson --run
sleep 1

echo "[7 / 7] Checking results"
[[ ! -f examples/geojson/data/bayarea.csv ]] && exit 1
[[ ! -f examples/basic/basic.png ]] && exit 1
[[ ! -f examples/transform/transform.png ]] && exit 1
[[ ! -f examples/polygon/polygon.png ]] && exit 1
[[ ! -f examples/geojson/geojson.png ]] && exit 1

echo "[ Success ]"
