

param(

    [string]$tenantId="",

    [string]$file="C:\temp\Azure-ARM-VMs.csv"
    ) 


if (Get-Module -ListAvailable -Name AzureRM) {
Write-Host "Module exists"
} else {

Install-PackageProvider -Name "NuGet" -Confirm:$false -Force -Verbose
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -SourceLocation "https://www.powershellgallery.com/api/v2/"
Install-Module AzureRM -AllowClobber
}

Import-Module AzureRM

if ($tenantId -eq "") {
    login-azurermaccount 
    $subs = Get-AzureRmSubscription 
} else {
    login-azurermaccount -tenantid $tenantId 
    $subs = Get-AzureRmSubscription -TenantId $tenantId 
}


$vmobjs = @()

foreach ($sub in $subs)
{
    
    Write-Host Processing subscription $sub.SubscriptionName

    try
    {

        Select-AzureRmSubscription -SubscriptionId $sub.SubscriptionId -ErrorAction Continue

        $vms = Get-AzureRmVM 
       

        foreach ($vm in $vms)
        {
            $vmInfo = [pscustomobject]@{
                'Subscription'=$sub.Name
                'Location' = $vm.Location
                'ResourceGroupName' = $vm.ResourceGroupName
                'Name'=$vm.Name
                'ComputerName' = $vm.OSProfile.ComputerName
                'VMSize' = $vm.HardwareProfile.VMsize
                'DiskCount' = $vm.StorageProfile.DataDisks.Count
                'Admin' = $vm.OSProfile.AdminUsername
                'Status' = $null
                'IPAddress' = $null
                'ProvisioningState' = $vm.ProvisioningState
                'Publisher' = $vm.StorageProfile.ImageReference.Publisher
                'Offer' = $vm.StorageProfile.ImageReference.Offer
                'SKU' = $vm.StorageProfile.ImageReference.Sku
                'Version' = $vm.StorageProfile.ImageReference.Version  
                
                 }
        
           # $vmStatus = $vm | Get-AzureRmVM -Status
            $vmStatus = Get-AzureRmVM -Name $vm.Name $vm.ResourceGroupName -Status
            $vmInfo.Status = $vmStatus.Statuses[1].DisplayStatus

            $nic = Get-AzureRmPublicIpAddress -ResourceGroupName $vm.ResourceGroupName
            $vmInfo.IPAddress =  $nic.IpAddress


            $vmobjs += $vmInfo
            Write-Host $vmInfo.Subscription $vmInfo.Name
        }  
    }
    catch
    {
        Write-Host $error[0]
    }
}

$vmobjs | Export-Csv -NoTypeInformation -Path $file
Write-Host "VM list written to $file"
Invoke-Item C:\temp\Azure-ARM-VMs.csv