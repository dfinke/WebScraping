Import-Module .\TextRecognition.psm1 -Force

ls *.tif,*.png | ConvertTo-Text | Format-List