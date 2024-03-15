# Define the URL of the website to scan
$websiteUrl = "https://ttreact.weebly.com"

# Define the word to search for
$searchWord = "REACT"

# Function to count occurrences of the word in a string
function CountWordOccurrences {
    param (
        [string]$inputString,
        [string]$word
    )
    return ($inputString | Select-String -Pattern $word -AllMatches).Matches.Count
}

# Make a GET request to the website
$response = Invoke-WebRequest -Uri $websiteUrl

# Check if the request was successful
if ($response.StatusCode -eq 200) {
    # Count occurrences of the word in the website content
    $websiteWordCount = CountWordOccurrences -inputString $response.Content -word $searchWord
    
    Write-Host "The word '$searchWord' was found $websiteWordCount times on the main page of the website."

    # Extract hyperlinks from the webpage content
    $hyperlinks = $response.Links | Select-Object -ExpandProperty href

    # Loop through each hyperlink and count occurrences of the word
    foreach ($link in $hyperlinks) {
        $linkResponse = Invoke-WebRequest -Uri $link -ErrorAction SilentlyContinue
        if ($linkResponse -and $linkResponse.StatusCode -eq 200) {
            $linkWordCount = CountWordOccurrences -inputString $linkResponse.Content -word $searchWord
            Write-Host "The word '$searchWord' was found $linkWordCount times on the page: $link"
            $websiteWordCount += $linkWordCount
        }
    }

    Write-Host "Total occurrences of '$searchWord' on the website (including hyperlinks): $websiteWordCount"
} else {
    Write-Host "Failed to retrieve content from the website. Status code: $($response.StatusCode)"
}
