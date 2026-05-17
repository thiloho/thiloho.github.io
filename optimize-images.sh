mkdir -p ./static/photography/optimized && for f in ./static/photography/*.JPG; do
  out="./static/photography/optimized/$(basename "${f%.JPG}").WEBP"
  [ -f "$out" ] && continue
  magick "$f" -resize 2560x\> -quality 75 -strip -define webp:method=6 "$out"
done