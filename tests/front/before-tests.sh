#!/bin/sh

echo "Generate js file from template..."

cp $PWD/website/scripts.tpl $PWD/website/scripts2.js

sed -i "" "s/\${apiBaseUrl}/localhost/g" $PWD/website/scripts2.js

echo "---- Done ----"
echo "All ok. Proceed to testing."