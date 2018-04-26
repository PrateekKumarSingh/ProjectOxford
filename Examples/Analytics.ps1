
Get-Sentiment -Text "Hey good morning!","Such a wonderful day","I feel sad about you"
Get-KeyPhrase -Text "Hey good morning!","Such a wonderful day","I feel sad about these poor people" | ForEach-Object documents
Trace-Language -Text "Hey good morning!", "Bonjour tout le monde", "La carretera estaba atascada" | ForEach-Object documents | % detectedlanguages
