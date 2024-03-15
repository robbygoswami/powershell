 # Define the URL of the website to scan
$websiteUrl = "https://ttreact.weebly.com"

# Define the word to search for
$searchWord = "REACT"

# Make a GET request to the website
$response = Invoke-WebRequest -Uri $websiteUrl

# Check if the request was successful
if ($response.StatusCode -eq 200) {
    # Count occurrences of the word in the response content
    $count = ($response.Content | Select-String -Pattern $searchWord -AllMatches).Matches.Count
    
    Write-Host "The word '$searchWord' was found $count times on the website."
} else {
    Write-Host "Failed to retrieve content from the website. Status code: $($response.StatusCode)"
}
