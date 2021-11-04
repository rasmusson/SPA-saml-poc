Write-Host "waiting for ad to start"

      do {
        Start-Sleep -Seconds 5
        # query AD for the local computer
        $success = $true
        Try {
          Get-ADComputer $env:COMPUTERNAME }
          Catch {
          Write-Host "AD not starting yet, waiting"
          $success = $false }
      } until ($success) # exits the loop if last call was successful

    Write-Host "succeeded."
