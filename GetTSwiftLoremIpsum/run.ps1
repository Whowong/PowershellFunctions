param(
    $Request,
    $TriggerMetadata
)

# Parse the request body
$body = $Request.Body | ConvertFrom-Json
$numParagraphs = if ($body.PSObject.Properties['numParagraphs']) { $body.numParagraphs } else { 1 }

# Define the API endpoint
$apiUrl = "https://taylor-swift-api.sarbo.workers.dev/lyrics?shouldRandomizeLyrics=true&numberOfParagraphs=$numParagraphs"

# Call the API
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get
    $lyrics = $response.lyrics -split "`n`n"  # Split lyrics into paragraphs based on double newlines

    # Convert to JSON for the response
    $responseBody = $lyrics | ConvertTo-Json -Depth 3
    Write-Output $responseBody
    $statusCode = 200
} catch {
    Write-Error "Error fetching data from $($apiUrl): $_"
    $statusCode = 500
    $responseBody = "Error retrieving lyrics"
}

# Create the HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $statusCode
    Body = $responseBody
})