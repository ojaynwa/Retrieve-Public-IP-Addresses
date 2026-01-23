# Retrieve-Public-IP-Addresses
**The PowerShell** script uses the Get-AzPublicIpAddress cmdlet to retrieve public IP information across subscriptions.
Loops through all subscriptions in the tenant.
Retrieves complete metadata for each public IP 
Identifies associated resources by parsing the IP configuration ID
Exports results to CSV with timestamp
Provides progress feedback during execution
<br>
<br>

**Azure Resource Graph** is the most efficient method for querying across multiple subscriptions simultaneously using Kusto Query Language (KQL).
Azure Resource Graph is the **most efficient method** for querying across multiple subscriptions simultaneously using Kusto Query Language (KQL).
<br>
<br>
Resource Graph Query Features:
Queries all subscriptions simultaneously - no looping required.
Performs complex joins to identify associated resources.
Supports up to 1000 results per query (use skip tokens for more).
Sub-second query performance across entire tenant.
Can identify various resource types including VMs, Load Balancers, Application Gateways.
<br>
<br>
**Execute the KQL Query via Azure Portal**

Navigate to Azure Resource Graph Explorer in the Azure Portal.
<br>
Paste the KQL query
<br>
Click Run query
<br>
Export results using the Download as CSV button
<br>
<br>
**Execute the KQL Query via Azure CLI**

az graph query -q "Resources | where type =~ 'microsoft.network/publicipaddresses' and isnotempty(properties.ipAddress) | extend associatedResourceId = tostring(properties.ipConfiguration.id) | project subscriptionId, name, properties.ipAddress, resourceGroup, location, properties.publicIpAllocationMethod, sku.name, associatedResourceId | sort by subscriptionId, name asc" --first 1000 --output table
<br>
<br>
**Execute the KQL Query via Azure PowerShell**
<br>

$query = @"
Resources
| where type =~ 'microsoft.network/publicipaddresses'
| where isnotempty(properties.ipAddress)
| project subscriptionId, name, IPAddress=properties.ipAddress, resourceGroup, location, AllocationMethod=properties.publicIpAllocationMethod, SKU=sku.name, AssociatedResource=properties.ipConfiguration.id
| sort by subscriptionId, name asc
"@

Search-AzGraph -Query $query -First 1000 | Export-Csv -Path "PublicIPs_ARG.csv" -NoTypeInformation


<br>
<br>
<br>

**Disclaimer**

- This is not official Microsoft documentation or software.
- This is not an endorsement or a sign-off of an architecture or a design.
- This code sample is provided "AS IT IS" without warranty of any kind, either expressed or implied, including but not limited to the implied warranties of merchantability and/or fitness for a particular purpose.
- This sample is not supported under any Microsoft standard support program or service.
- Microsoft further disclaims all implied warranties, including, without limitation, any implied warranties of merchantability or fitness for a particular purpose.
- The entire risk arising out of the use or performance of the sample and documentation remains with you.
- In no event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the script be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample or documentation, even if Microsoft has been advised of the possibility of such damages
