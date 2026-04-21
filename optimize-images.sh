mkdir -p ./static/photography/optimized && for f in ./static/photography/*.JPG; do
  magick "$f" -resize 2560x\> -quality 75 -strip -define webp:method=6 "./static/photography/optimized/$(basename "${f%.JPG}").WEBP"
done