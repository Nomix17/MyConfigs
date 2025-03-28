path="$HOME/Pictures/Screenshots/ocr.png"
scrot -s $path
text=$(tesseract $path -)
if [ $text ];then
  echo $text
  echo $text | xsel --clipboard --input
fi
rm $path
