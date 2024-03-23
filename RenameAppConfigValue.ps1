$fileName = ""
$keyName = ""
$keyValue = ""
$validFileName = $false

do {
    $fileName = Read-Host "Enter the config file name. "
    
    if (-not $fileName) {
        Write-Host "Please enter a non-empty file name."
    }
    elseif (-not (Test-Path $fileName)) {
        Write-Host "Error: File '$fileName' does not exist. Please enter a valid file name."
    }
	else {
		$validFileName = $true
	}
} until ($validFileName -eq $true)

while (-not $keyName -or -not ($keyName -match "^[a-zA-Z0-9]+$")) {
    $keyName = Read-Host "What is the key name in the config file you would like to change? "
    
    if (-not $keyName) {
        Write-Host "Please enter a non-empty name."
    }
    elseif (-not ($keyName -match "^[a-zA-Z0-9]+$")) {
        Write-Host "Please enter a key name consisting only of alphanumeric characters."
    }
}

while (-not $keyValue -or -not ($keyValue -match "^[a-zA-Z0-9]+$")) {
    $keyValue = Read-Host "What is the value in the config file you would like '$keyName' to have? "
    
    if (-not $keyValue) {
        Write-Host "Please enter a non-empty value."
    }
    elseif (-not ($keyValue -match "^[a-zA-Z0-9]+$")) {
        Write-Host "Please enter a key value consisting only of alphanumeric characters."
    }
}

# Ensure $keyValue is cast as a string before assigning it
$keyValue = [string]$keyValue

# Load the XML content from the config file 
[xml]$xml = Get-Content -Path $fileName
 
# Find the 'appSettings' section in the XML 
$appSettingsNode = $xml.configuration.appSettings 
 
# Rename specified keyName
$settingNode = $appSettingsNode.SelectSingleNode("//add[@key='$keyName']") 

 
if ($settingNode -ne $null) { 
   $settingNode.value = $keyValue
	 
   $xml.Save($fileName)

   Write-Host "Value of '$keyName' setting has been updated to '$keyValue in $fileName" 
}
else { 
   Write-Host "The '$keyName' setting was not found in $fileName" 
}
