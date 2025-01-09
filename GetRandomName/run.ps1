param(
    $Request,
    $TriggerMetadata
)

# Parse the request body
$body = $Request.Body | ConvertFrom-Json
$results = $body.results
$gender = $body.gender

# Log the request
Write-Output "Received POST request with results=$results and gender=$gender"

# Build the API URL with optional parameters
$apiUrl = "https://randomuser.me/api/?results=$results"
if ($gender) {
    $apiUrl += "&gender=$gender"
}

# Perform a GET request to the website
try {
    $response = Invoke-RestMethod -Uri $apiUrl
    $statusCode = 200
    $body = $response
} catch {
    Write-Error "Error fetching data from $($apiUrl): $_"
    $statusCode = 500
    $body = "Error retrieving user data"
}

# Create the HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $statusCode
    Body = $body
})