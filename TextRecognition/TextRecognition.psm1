function ConvertTo-Text {
    param(
        [Parameter(            
            Position=0,
            ParameterSetName="Path",
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]        
        [string]$Path
    )

    Begin {    
        Add-Type -Path "$PSScriptRoot\tesseract\Tesseract.dll"
                
        $tesseract = New-Object Tesseract.TesseractEngine("$PSScriptRoot\tesseract\tessdata", "eng", [Tesseract.EngineMode]::Default)
    }
    
    Process {        
        $image = [Tesseract.Pix]::LoadFromFile($Path)
        $targetPage= $tesseract.Process($Image)

        [PSCustomObject][Ordered]@{
            ImageFileName=$Path
            Confidence = $targetPage.GetMeanConfidence()
            Text = $targetPage.GetText()
        }

        $image.Dispose()
        $targetPage.Dispose()
    }
}