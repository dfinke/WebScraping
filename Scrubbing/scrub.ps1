cls

function Test-IsCommonWord ($words) {
    $commonWords = @{"the"=0; "be"=0; "and"=0; "of"=0; "a"=0; "in"=0; "to"=0; "have"=0; "it"=0;
        "i"=0; "for"=0; "you"=0; "he"=0; "with"=0; "on"=0; "do"=0; "say"=0; "this"=0;
        "they"=0; "is"=0; "an"=0; "at"=0; "but"=0;"we"=0; "his"=0; "from"=0; "that"=0; "not"=0;
        "by"=0; "she"=0; "or"=0; "as"=0; "what"=0; "go"=0; "their"=0;"can"=0; "who"=0; "get"=0;
        "if"=0; "would"=0; "her"=0; "all"=0; "my"=0; "make"=0; "about"=0; "know"=0; "will"=0;
         "up"=0; "one"=0; "time"=0; "has"=0; "been"=0; "there"=0; "year"=0; "so"=0;
        "think"=0; "when"=0; "which"=0; "them"=0; "some"=0; "me"=0; "people"=0; "take"=0;
        "out"=0; "into"=0; "just"=0; "see"=0; "him"=0; "your"=0; "come"=0; "could"=0; "now"=0;
        "than"=0; "like"=0; "other"=0; "how"=0; "then"=0; "its"=0; "our"=0; "two"=0;
        "these"=0; "want"=0; "way"=0; "look"=0; "first"=0; "also"=0; "new"=0; "because"=0;
        "day"=0; "more"=0; "use"=0; "no"=0; "man"=0; "find"=0; "here"=0; "thing"=0; "give"=0;
        "many"=0; "well"=0}
    
    foreach($word in $words) {
        if($commonWords.ContainsKey($word)) {return $true}
    }

    $false
}

function cleaninput ($d) {   
    
    filter stripPunctuation {        
        $_.ToCharArray().where({![char]::IsPunctuation($_)}) -join ''
    }

    $cleanerData = $d -replace "[0-9]*", "" -replace " +|\r\n", " " -split ' '

    foreach ($item in $cleanerData) { 
        $item = $item | stripPunctuation
        if($item.Length -gt 1 -or ($item.ToLower() -eq 'a' -or  $item.ToLower() -eq 'i')) {
            $item
        }
    }
}

function getNgrams ($d,$n=2) {
    
    $data = cleaninput $d    
    
    $hash = @{}
    foreach ($i in 0..($data.Length - $n + 1)) {

        $words = $data[$i..($i+$n-1)]
        
        if(Test-IsCommonWord $words) {continue}        

        $ngramTemp = '' + $words
        
        if(!$hash.Contains($ngramTemp)) {        
            $hash[$ngramTemp]=0
        }
        
        $hash[$ngramTemp]+=1
    } 
    
    $hash.GetEnumerator() | 
        sort @{expression='Value'; descending=$true},
             @{expression='Name'; ascending=$true} 
}

$speech = Invoke-RestMethod "http://pythonscraping.com/files/inaugurationSpeech.txt"

$ngrams = getNgrams $speech | select -First 4

$speechArray = $speech -split "`n|\."

$h=[ordered]@{}

foreach ($ngram in $ngrams) {  
    $found=$false
    for ($i = 0; $i -lt $speechArray.Count; $i++) {            
        if($found -eq $false) {
            if($speechArray[$i].Contains($ngram.Name)) {
                $h.$($ngram.Name)=$speechArray[$i]
                $found=$true
            }
        }
    }
}

$h.GetEnumerator() |% {
    "** $($_.key) **"  | Out-String
    $_.value| Out-String
}
