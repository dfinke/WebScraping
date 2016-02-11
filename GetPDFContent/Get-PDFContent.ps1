$script:dllPath = $MyInvocation.MyCommand.Path

function Get-PDFContent {
    param(
        # file name or url
        [Parameter(Mandatory=$true)]
        $pdfFile,
        $password
    )    
    
    $commandPath = Split-Path $dllPath    
    Add-Type -Path "$($commandPath)/itextsharp.dll"    

    $uri = $pdfFile -as [System.URI] 
    $testIsURI = $uri.AbsoluteURI -ne $null -and $uri.Scheme -match '[http|https]'
    if(!$testIsURI) {
        $pdfFile = (Resolve-Path $pdfFile).path
    }

    $pwd = $null
    
    if($password) {
        $pwd=([system.Text.Encoding]::ASCII).GetBytes($password)
    }

    $reader = New-Object iTextSharp.text.pdf.PdfReader $pdfFile, $pwd

    $strategy = New-Object iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy

    for ($i = 1; $i -lt $reader.NumberOfPages; $i++) { 
        [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($reader, $i, $strategy)
    }

    $reader.Close()
}