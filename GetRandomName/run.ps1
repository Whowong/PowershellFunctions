param(
    $Request,
    $TriggerMetadata,
    [Parameter(Mandatory=$false)]
    [int]$results = 1,
    [Parameter(Mandatory=$false)]
    [string]$gender
)

# Log the request
Write-Output "Received POST request"

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