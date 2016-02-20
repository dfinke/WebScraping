Import-Module .\TextRecognition.psm1 -Force

$pngFile = "$pwd\text.png"

rm $pngFile -ErrorAction ignore

Invoke-WebRequest "https://www.w3.org/TR/ttaf1-dfxp/images/textOutline.png" -OutFile $pngFile

ConvertTo-Text $pngFile | Format-List

rm $pngFile -ErrorAction ignore