#!/bin/sh

echo "Cleaning env after testing..."

echo "Delete js file from template..."

rm $PWD/website/scripts2.js

sed -i "" "s/\${apiBaseUrl}/localhost/g" $PWD/website/scripts2.js

echo "---- Done ----"
echo "All ok. Proceed to testing."