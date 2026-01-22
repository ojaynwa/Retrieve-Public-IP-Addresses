# Connect to Azure
Connect-AzAccount

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Initialize array to hold results
$allPublicIPs = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Set context to current subscription
    Write-Host "Processing subscription: $($subscription.Name)" -ForegroundColor Green
    Set-AzContext -SubscriptionId $subscription.Id | Out-Null
    
    # Get all public IP addresses
    $publicIPs = Get-AzPublicIpAddress
    
    # Process each public IP
    foreach ($pip in $publicIPs) {
        $ipInfo = [PSCustomObject]@{
            SubscriptionId       = $subscription.Id
            SubscriptionName     = $subscription.Name
            PublicIPName         = $pip.Name
            IPAddress            = $pip.IpAddress
            ResourceGroupName    = $pip.ResourceGroupName
            Location             = $pip.Location
            AllocationMethod     = $pip.PublicIpAllocationMethod
            SKU                  = $pip.Sku.Name
            AssociatedResource   = if ($pip.IpConfiguration.Id) { 
                                       ($pip.IpConfiguration.Id -split '/')[-3..-1] -join '/' 
                                   } else { 
                                       "Not Associated" 
                                   }
            ResourceId           = $pip.Id
        }
        $allPublicIPs += $ipInfo
    }
}

# Export to CSV
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = "Azure_PublicIPs_$timestamp.csv"
$allPublicIPs | Export-Csv -Path $outputFile -NoTypeInformation
Write-Host "Exported $($allPublicIPs.Count) public IPs to $outputFile" -ForegroundColor Cyan

# Display results
$allPublicIPs | Format-Table -AutoSize
