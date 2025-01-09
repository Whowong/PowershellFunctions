param(
    $Request,
    $TriggerMetadata
)

$numParagraphs = 1

# Parse the request body
if ($Request.Body) {
    $body = $Request.Body | ConvertFrom-Json
    $numParagraphs = if ($body.PSObject.Properties['numParagraphs']) 
                    { 
                        $body.numParagraphs 
                    } 
                    else 
                    { 
                        $numParagraphs = 1 
                    }
} 

Write-Output "numParagraphs: $numParagraphs"
# Define the API endpoint
$apiUrl = "https://loripsum.net/api/plaintext/$numParagraphs"

# Call the API
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get
  
    Write-Output $response
    $statusCode = 200
} catch {
    Write-Error "Error fetching data from $($apiUrl): $_"
    $statusCode = 500
    $response = "Error retrieving lyrics"
}

# Create the HTTP response
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $statusCode
    Body = $response
})