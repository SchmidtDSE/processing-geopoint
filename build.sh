javac -d build java/src/org/dse/geopoint/*.java
cd build
jar cf geopoint.jar ./*
