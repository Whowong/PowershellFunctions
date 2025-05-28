Describe 'GetDadJoke Function Tests' {
    BeforeAll {
        # Define HttpResponseContext class for testing
        class HttpResponseContext {
            [int]$StatusCode
            [object]$Body
        }

        # Load the function script
        $functionPath = Join-Path -Path $PSScriptRoot -ChildPath '..\GetDadJoke\run.ps1'
        if (Test-Path $functionPath) {
            # Define the output binding that would be provided by Azure Functions
            function Push-OutputBinding {
                param($Name, $Value)
                if ($Name -eq 'Response') {
                    $Global:Response = $Value
                }
            }
        } else {
            throw "Function script not found at $functionPath"
        }

        # Mock data
        $mockJokeResponse = @{
            id = "abc123"
            joke = "Why don't scientists trust atoms? Because they make up everything!"
            status = 200
        }
    }

    Context 'Successful API call' {
        BeforeEach {
            # Mock the Invoke-RestMethod call
            Mock Invoke-RestMethod {
                return $mockJokeResponse
            }
            
            # Mock Write-Output to prevent console output during tests
            Mock Write-Output {}
            
            # Reset the response variable
            $Global:Response = $null
            
            # Execute the function
            & $functionPath -Request @{} -TriggerMetadata @{}
        }

        It 'Should call the icanhazdadjoke API with correct parameters' {
            Should -Invoke -CommandName Invoke-RestMethod -ParameterFilter {
                $Uri -eq 'https://icanhazdadjoke.com/' -and 
                $Headers.Accept -eq 'application/json' -and
                $Method -eq 'Get'
            }
        }

        It 'Should return status code 200 on success' {
            $Global:Response.StatusCode | Should -Be 200
        }

        It 'Should return the joke data in the response body' {
            $Global:Response.Body | Should -Be $mockJokeResponse
        }
    }

    Context 'Failed API call' {
        BeforeEach {
            # Mock Invoke-RestMethod to throw an exception
            Mock Invoke-RestMethod {
                throw "API Error"
            }
            
            # Mock Write-Error to prevent console output during tests
            Mock Write-Error {}
            Mock Write-Output {}
            
            # Reset the response variable
            $Global:Response = $null
            
            # Execute the function
            & $functionPath -Request @{} -TriggerMetadata @{}
        }

        It 'Should handle errors correctly' {
            Should -Invoke -CommandName Write-Error
        }

        It 'Should return status code 500 on error' {
            $Global:Response.StatusCode | Should -Be 500
        }

        It 'Should return an error message in the response body' {
            $Global:Response.Body | Should -Be "Error retrieving dad joke"
        }
    }
}