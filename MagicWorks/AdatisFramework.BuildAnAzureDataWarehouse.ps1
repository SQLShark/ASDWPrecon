############################################################################################################################################
############################################################################################################################################
##
## Process: Adatis PowerShell Azure clear and rebuild script
## Created by: Terry McCann tpm@acl
## Created on: 01/02/2017
## Notes: This powershell script is all variable and config driven. A json config file is required to populate the variables. 
## 1 Read a file
## 2 replace parts of the file
## 3 Read data from a sql database / Option to not read from a DB but from a file
############################################################################################################################################
############################################################################################################################################

Remove-Variable * -ErrorAction SilentlyContinue

$BlobAccountName = 'magicworksblob7'
$BlobStorageKey = 'dpUqFYVTcV8SCVf/sV/qX76sRGpEi/PQVlvdg/xiR8PJALPiYuJXNBn/HLbV4mQ5kX5aAurYVoBXQo4kjNCxGA=='
$DatabaseName= 'Adventureworks'
$UserNameShort  = 'acl\tpm'

$query = "EXEC datawarehouse.AdatisASDWMetadata; "



## ------ Change filepath to existing configuration file ------ ##
#$PowerShellConfigFilePath = 'C:\Users\tpm\Dropbox\Presentations\Data Factory\Introduction to ADF\Exeter 20170330\SQLSouthWest\Config.json'
#$Config = Get-Content $PowerShellConfigFilePath | ConvertFrom-Json

#Storage Sunscription
$ctx = New-AzureStorageContext -StorageAccountName $BlobAccountName -StorageAccountKey $BlobStorageKey

#Create your SQL connection string, and then a connection to Wrestlers
$ServerAConnectionString = 'Data Source='+$ServerName+';Initial Catalog='+$DatabaseName+';User Id='+ $UserNameShort +';Integrated Security = True'
$ServerAConnection = new-object system.data.SqlClient.SqlConnection($ServerAConnectionString);

#------------ 
$dataSet = new-object "System.Data.DataSet" "MetadataDataset" 
$dataAdapter = new-object "System.Data.SqlClient.SqlDataAdapter" ($query, $ServerAConnection)
$dataAdapter.Fill($dataSet) | Out-Null

#----------- Remove any existing containers ------------#
foreach ($Row in $dataSet.Tables[0].Rows)
    { 
        $ContainerName = $Row[1].ToLower()
        Write-Host $ContainerName
        $ExistingContainer = Get-AzureStorageContainer -Name $ContainerName -Context $ctx  -ErrorAction Ignore
        if ($ExistingContainer -eq $null){
            New-AzureStorageContainer -Name $ContainerName -Context $ctx
        }
    }

#Create your SQL connection string, and then a connection to Wrestlers
$ServerBConnectionString = 'Data Source='+$ServerName+';Initial Catalog=AdventureWorksDW2012;User Id='+ $UserNameShort +';Integrated Security = True'
$ServerBConnection = new-object system.data.SqlClient.SqlConnection($ServerBConnectionString);

#------------ 
$dataSetB = new-object "System.Data.DataSet" "MetadataDatasetB" 
$dataAdapterB = new-object "System.Data.SqlClient.SqlDataAdapter" ($query, $ServerBConnection)
$dataAdapterB.Fill($dataSetB) | Out-Null

#----------- Remove any existing containers ------------#
foreach ($Row in $dataSetB.Tables[0].Rows)
    { 
        $ContainerName = $Row[1].ToLower()
        Write-Host $ContainerName
        $ExistingContainer = Get-AzureStorageContainer -Name $ContainerName -Context $ctx  -ErrorAction Ignore
        if ($ExistingContainer -eq $null){
            New-AzureStorageContainer -Name $ContainerName -Context $ctx
        }
    }



#-----------------------------------------------------------------------------------------------------------
#Upload files in to blob storage. 

#MagicWorks
$ConfigFile = Import-Csv "G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorks\config.txt" -Delimiter "," -Header A,B,C, D

foreach ($item in $ConfigFile)
    {     
        # Disable TM
        Write-Host $item.B 
        iex $item.D
        ##New-AzureStorageContainer -Name $item.BlobName -Context $ctx
    } 

#MagicWorksDW
$ConfigFile = Import-Csv "G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW\config.txt" -Delimiter "," -Header A,B,C, D

foreach ($item in $ConfigFile)
    {     
        # Disable TM
        Write-Host $item.B 
        iex $item.D
        ##New-AzureStorageContainer -Name $item.BlobName -Context $ctx
    } 