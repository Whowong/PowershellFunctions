# Input: Number of paragraphs from the request body (default to 1 if not provided)
param(
    [Parameter(Mandatory=$false)]
    [int]$numParagraphs = 1
)

# Define the API endpoint
$apiUrl = "https://taylor-swift-api.sarbo.workers.dev/lyrics?shouldRandomizeLyrics=true&numberOfParagraphs=$numParagraphs"

# Call the API
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get
    $lyrics = $response.lyrics -split "`n`n"  # Split lyrics into paragraphs based on double newlines

    # Convert to JSON for the response
    $responseBody = $lyrics | ConvertTo-Json -Depth 3
    Write-Output $responseBody
} catch {
    Write-Error "Error fetching data from $($apiUrl): $_"
}