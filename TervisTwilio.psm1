$ModulePath = (Get-Module -ListAvailable TervisTwilio).ModuleBase
. $ModulePath\Definition.ps1

Set-GetTwilioCredentialScriptBlock -ScriptBlock {
    Get-PasswordstatePassword -AsCredential -ID 5313
}

function Get-EmergencyAddress {
    param (
        $Name
    )
    $EmergencyResponseAddresses |
    Where-Object Name -EQ $Name
}

function Get-VoiceURL {
    param (    
        $Name
    )
    $voiceurls | Where-Object Name -EQ $Name
}

function Get-EmergencyResponseLocationAddresses {
    foreach ($EmergencyLocation in $EmergencyLocations) {
        $EmergencyAddress = Get-EmergencyAddress -Name $EmergencyLocation.AddressName
        $EmergencyAddress |
        Add-Member -MemberType NoteProperty -Name Address2 -Value $EmergencyLocation.Name -Force -PassThru |
        Add-Member -MemberType NoteProperty -Name DirectNumber -Value $EmergencyLocation.DirectNumber -Force -PassThru |
        Add-Member -MemberType NoteProperty -Name FriendlyName -Value $EmergencyLocation.FriendlyName -Force -PassThru      
    }
}

function Add-TervisTwilioAddress {
    param (
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$FriendlyName,
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$CustomerName,
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$Street,
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$City,
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$Region,
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$PostalCode,
        [Parameter(Mandatory,ValueFromPipeLinebyPropertyName)][String]$IsoCountry
     )
     process {
        $ExistingFriendlyName = Get-TwilioAddresses | select -ExpandProperty addresses | select -ExpandProperty friendly_name
        if ($ExistingFriendlyName -eq $FriendlyName) {
        (Write-Host "The address with the same Friendly_Name already existed")
        } else {
    Add-TwilioAddresses -FriendlyName $FriendlyName -CustomerName $CustomerName -Street $Street -City $City -Region $Region -PostalCode $PostalCode -IsoCountry $IsoCountry
          }
    }
}

function Set-TervisSipTrunkOnPhoneNumber {
    param (
       [Parameter(Mandatory,ValueFromPipeLine)][string]$FriendlyName,
       $TrunkSid,
       $ApiVersion,
       $VoiceUrl,
       $VoiceMethod,
       $VoiceFallbackUrl,
       $VoiceFallbackMethod,
       $StatusCallback,
       $StatusCallbackMethod,
       $VoiceCallerIdLookup,
       $VoiceApplicationSid,
       $SmsUrl,
       $SmsMethod,
       $SmsFallbackUrl,
       $SmsFallbackMethod,
       $SmsApplicationSid,
       $AccountSid, 
       $AddressSid
    
    )
    process {
        Set-TwilioIncomingPhoneNumber -FriendlyName $FriendlyName -TrunkSid "TK59ae204b72e3b329cd361c0060c4e17c"
    }
}

function Set-HelpDeskForwardedNumber {
    param (
        $Name
    )
        $FriendlyName = Get-TwilioIncomingPhoneNumbers | Select-Object -ExpandProperty incoming_phone_numbers | Where-Object sid -EQ PNb766129700d9fb5bd08185748a598b07 | Select-Object -ExpandProperty friendly_name
        $VoiceUrl = Get-VoiceURL -Name $Name | Select-Object -ExpandProperty URL
        Set-TwilioIncomingPhoneNumber -FriendlyName $FriendlyName -VoiceUrl $VoiceUrl

}

