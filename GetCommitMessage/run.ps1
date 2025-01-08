param($Request, $TriggerMetadata)

# Log the request
Write-Output "Received POST request"

# Perform a GET request to the website
try {
    $response = Invoke-RestMethod -Uri "https://whatthecommit.com/"
    $statusCode = 200
    $body = $response
} catch {
    Write-Error "Error fetching data from https://whatthecommit.com/: $_"
    $statusCode = 500
    $body = "Error retrieving commit message"
}

# Create the HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $statusCode
    Body = $body
})
