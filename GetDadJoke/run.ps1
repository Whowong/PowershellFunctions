param(
    $Request,
    $TriggerMetadata
)

# Log the request
Write-Output "Received request for a dad joke"

# Define the API endpoint
$apiUrl = "https://icanhazdadjoke.com/"

# Call the API with the appropriate headers
try {
    $headers = @{
        "Accept" = "application/json"
        "User-Agent" = "PowerShell Function (https://github.com/Whowong/PowershellFunctions)"
    }
    
    $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get
    $statusCode = 200
    $body = $response
} catch {
    Write-Error "Error fetching data from $($apiUrl): $_"
    $statusCode = 500
    $body = "Error retrieving dad joke"
}

# Create the HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $statusCode
    Body = $body
})