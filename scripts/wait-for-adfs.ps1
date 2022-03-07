Write-Host "waiting for adfs to start"

      do {
        Start-Sleep -Seconds 5
        # query AD for the local computer
        $success = $true
        Try {
          Get-AdfsRelyingPartyTrust }
          Catch {
          Write-Host "ADFS not starting yet, waiting"
          $success = $false }
      } until ($success) # exits the loop if last call was successful

    Write-Host "succeeded."
