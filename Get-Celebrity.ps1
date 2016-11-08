Function Get-FrequencyDistribution ($Content)
{
    $Content.split(" ") |?{-not [String]::IsNullOrEmpty($_)} | %{[Regex]::Replace($_,'[^a-zA-Z0-9]','')} |group |sort count -Descending
}

Function Get-Intersection($Sentence1, $Sentence2)
{
    $CommonWords = Compare-Object -ReferenceObject $Sentence1 -DifferenceObject $Sentence2 -IncludeEqual |?{$_.sideindicator -eq '=='} | select Inputobject -ExpandProperty Inputobject

    $CommonWords.Count / ($Sentence1.Count + $Sentence2.Count) /2
}

Function Get-SentenceRank($Content)
{
    $Sentences = $content -split [environment]::NewLine | ?{$_}
    $NoOfSentences = $Sentences.count
    $values = New-Object 'object[,]' $NoOfSentences,$NoOfSentences
    $CommonContentWeight = New-Object double[] $NoOfSentences
    
    #Get important words that where length is greater than 3 to avoid - in, on, of, to, by etc
    $ImportantWords = Get-FrequencyDistribution $Content |?{$_.name.length -gt 3} | select @{n='ImportanceWeight';e={$_.Count * 0.01}}, @{n='ImportantWord';e={$_.Name}} -First 10

    Foreach($i in (0..($NoOfSentences-1)))
    {
        $ImportanceWeight = 0

        #Score each Sentence on basis of words common in every other sentence
        #More a sentence has common words from all other sentences, more it defines the complete document
                
        Foreach($j in (0..($NoOfSentences-1)))
        {
            $WordsInReferenceSentence = $Sentences[$i].Split(" ") | Foreach{[Regex]::Replace($_,'[^a-zA-Z0-9]','')}
            $WordsInDifferenceSentence = $Sentences[$j].Split(" ") | Foreach{[Regex]::Replace($_,'[^a-zA-Z0-9]','')}
        
            $CommonContentWeight[$i] = $CommonContentWeight[$i] + (Get-Intersection  $WordsInReferenceSentence $WordsInDifferenceSentence)
        }

        Foreach($Item in $WordsInReferenceSentence |select -unique)
        {
            #Keep adding ImportanceWeight if an Important word found in the sentence
            If($Item -in $ImportantWords.ImportantWord)
            {
                $ImportanceWeight += ($ImportantWords| ?{$_.ImportantWord -eq $Item}).ImportanceWeight
            }
        }
    
        ''| select  @{n='LineNumber';e={$i}},@{n='SentenceScore';e={"{0:N3}"-f ($CommonContentWeight[$i]+$ImportanceWeight)}} ,  @{n='CommonContentScore';e={"{0:N3}"-f $CommonContentWeight[$i]}}, @{n='ImportanceScore';e={$ImportanceWeight}}, @{n='WordCount';e={($Sentences[$i].Split(" ")).count}} , @{n='Sentence';e={$Sentences[$i]}}
    }
}

Function Get-Summary
{
[cmdletbinding()]
Param(
        [Parameter(Position=0, Mandatory = $true)] $Content,
        [Parameter(Position=1)] $WordLimit = 100        
)

Begin
{

}
Process
{
    $TotalWords = 0
    $Summary=@()
    
    #Extracting Best sentences with highest Ranks within the word limit
    $BestSentences = Foreach($Item in (Get-SentenceRank $Content | Sort SentenceScore -Descending))
    {
        #Condition to limit Total word Count
        $TotalWords += $Item.WordCount
    
        If($TotalWords -gt $WordLimit)
        {
            break
        }
        else
        {
            $Item
        }
    }
    
    #Constructing a paragraph with sentences in Chronological order
    Foreach($best in (($BestSentences |sort Linenumber).sentence))
    {
        If(-not $Best.endswith("."))
        {
            $Summary += -join ($Best, ".")
        
        }
        else
        {
            $Summary += -join ($Best, "")
        }
    
    }
    
    [String]$Summary
}
End
{

}

 
}
