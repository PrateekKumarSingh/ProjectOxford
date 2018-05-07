# get prompt for ResourceGroupName, SKUName and location
New-CognitiveServiceAccount -AccountType Bing.EntitySearch
New-CognitiveServiceAccount -AccountType Bing.Search.v7
New-CognitiveServiceAccount -AccountType ComputerVision 
New-CognitiveServiceAccount -AccountType ContentModerator 
New-CognitiveServiceAccount -AccountType Face 
New-CognitiveServiceAccount -AccountType TextAnalytics

# alternatively, specify ResourceGroupName, SKUName and location to avoid interactive prompts
New-CognitiveServiceAccount -AccountType Bing.EntitySearch -ResourceGroupName ResourceGroup1 -SKUName S1 -Verbose -WarningAction SilentlyContinue | Out-Null
New-CognitiveServiceAccount -AccountType Bing.Search.v7 -ResourceGroupName ResourceGroup1 -SKUName S1 -Verbose -WarningAction SilentlyContinue | Out-Null
New-CognitiveServiceAccount -AccountType ComputerVision  -ResourceGroupName ResourceGroup1 -Location southeastasia -SKUName S1 -WarningAction SilentlyContinue | Out-Null
New-CognitiveServiceAccount -AccountType ContentModerator  -ResourceGroupName ResourceGroup1 -Location southeastasia -SKUName S0 -Verbose -WarningAction SilentlyContinue | Out-Null
New-CognitiveServiceAccount -AccountType Face  -ResourceGroupName ResourceGroup1 -Location southeastasia -SKUName S0 -Verbose -WarningAction SilentlyContinue | Out-Null
New-CognitiveServiceAccount -AccountType TextAnalytics -ResourceGroupName ResourceGroup1 -Location southeastasia -SKUName S1 -Verbose -WarningAction SilentlyContinue | Out-Null
