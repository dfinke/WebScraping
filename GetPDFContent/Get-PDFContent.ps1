$script:dllPath = $MyInvocation.MyCommand.Path
function Get-PDFContent {
    param(
        # file name or url
        [Parameter(Mandatory=$true)]
        $pdfFile
    )    
    
    $commandPath = Split-Path $dllPath
    Add-Type -Path "$($commandPath)/itextsharp.dll"

    $reader = New-Object iTextSharp.text.pdf.PdfReader $pdfFile    

    $strategy = New-Object iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy

    for ($i = 1; $i -lt $reader.NumberOfPages; $i++) { 
        [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($reader, $i, $strategy)
    }

    $reader.Close()
}
