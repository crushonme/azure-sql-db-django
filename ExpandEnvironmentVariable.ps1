function Import-Environment {
    # Read the environment variables from the file
    Write-Host $PSScriptRoot
    $envVars = Get-Content -Path "$PSScriptRoot\env-vars.txt"

    # Loop through each line in the file
    foreach ($envVar in $envVars) {
        # Split the line into name and value
        $parts = $envVar -split '=', 2
        $name = $parts[0]
        $value = $parts[1]

        # Set the environment variable 
        [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::User)
    }

    # Display the environment variables to verify they were set
    Write-Output "Environment variables set:"
    $envVars
    [System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::User)
}

function envsubst {
    $deployment = Get-Content -Path "$PSScriptRoot\aks-deployment.yaml"
    $allinone = Get-Content -Path "$PSScriptRoot\aks-all-in-one.yaml"
    foreach ($key in [System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::User).GetEnumerator()) { 
        Set-Variable -Name  $key.Key  -Value $key.Value
    }
    foreach ($line in  $deployment) {
        $ExecutionContext.InvokeCommand.ExpandString($line) | Out-File -FilePath "$PSScriptRoot\aks-deployment-expand.yaml" -Append
    }
    foreach ($line in $allinone) {
        $ExecutionContext.InvokeCommand.ExpandString($line) | Out-File -FilePath "$PSScriptRoot\aks-all-in-one.yaml-expand.yaml" -Append
    }
}
Import-Environment
envsubst