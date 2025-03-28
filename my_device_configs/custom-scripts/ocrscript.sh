path="$HOME/Pictures/Screenshots/ocr.png"
scrot -s $path
text=$(tesseract $path -)
echo $text
echo $text | xsel --clipboard --input
rm $path
