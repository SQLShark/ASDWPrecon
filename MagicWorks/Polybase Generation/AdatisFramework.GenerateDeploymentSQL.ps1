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


## ------ Change filepath to existing configuration file ------ ##
$PowerShellConfigFilePath = 'G:\GitHub\MagicWorks\Polybase Generation\Config.json'
$Config = Get-Content $PowerShellConfigFilePath | ConvertFrom-Json

## ------ Set by config file ------ ##
$MetadataFilePath = $Config.MetadataFilePath
$MasterTemplateLocation = $Config.MasterTemplateLocation
$AzureSQLDataWarehouseName = $Config.AzureSQLDataWarehouseName
$AzureSQLDataWarehouseServer = $Config.AzureSQLDataWarehouseServer
$AzureSQLDataWarehouseNameAdminUserName = $Config.AzureSQLDataWarehouseNameAdminUserName
$AzureSQLDataWarehouseNameAdminPassword = $Config.AzureSQLDataWarehouseNameAdminPassword
$AzureSQLDataWarehouseNameMediumUserName = $Config.AzureSQLDataWarehouseNameMediumUserName
$AzureSQLDataWarehouseNameMediumPassword = $Config.AzureSQLDataWarehouseNameMediumPassword
$AzureSQLDataWarehouseNameLargeUserName = $Config.AzureSQLDataWarehouseNameLargeUserName
$AzureSQLDataWarehouseNameLargePassword = $Config.AzureSQLDataWarehouseNameLargePassword
$AzureSQLDataWarehouseNameExtraLargeUserName = $Config.AzureSQLDataWarehouseNameExtraLargeUserName
$AzureSQLDataWarehouseNameExtraLargePassword = $Config.AzureSQLDataWarehouseNameExtraLargePassword
$AzureSQLDataWarehouseSQLDeploymentPath = $Config.AzureSQLDataWarehouseSQLDeploymentPath
$BlobAccountNameName = $Config.BlobAccountName
$BlobAccountNameResourceGroup = $Config.BlobAccountResourceGroup
$BlobStorageKey = $Config.BlobStorageKey
$SourceDatabaseName = $Config.SourceDatabaseName
$ScheduleStartTime = $Config.ScheduleStartTime
$ScheduleEndTime = $Config.ScheduleEndTime
$PolybaseFileFormat = $Config.PolybaseFileFormat
$SQLDeploymentPath = $Config.SQLDeploymentPath
$AzureSubscriptionName = $Config.AzureSubscriptionName
 

# ------- CSV containing export of Adatis metadata ------- # 
$path = Import-Csv $($MetadataFilePath + 'MagicWorksMetadata.csv')
#$path = Import-Csv $($MetadataFilePath + 'MagicWorksDWMetadata.csv')

$CredentialName = 'AzureStorageCredential'


foreach ($item in $path)
    { 
    #----------- Do not change -----------#
       
        
$FileLocationExternal = $MasterTemplateLocation + 'Template-ExternalTable.Blob.dsql'
$FileContentExternal = Get-Content $FileLocationExternal | Out-String

$EntityNameFull = $item.TableName
$EntityName = $EntityNameFull -replace '[][]',''
$EntityName = $EntityName.Split(".")[1] 
$EntityName = $EntityName -replace 'vw',''

#-------------------- Loop -------------#
$DDLdataSet = $null
$DDLdataAdapter = $null

$EntityName

$ColumnDDL =  $item.LooselyTyped
$ColumnList =  $item.SelectColumns
$ColumnTypings = $item.StronglyTypedCast
$ContainerName = $item.BlobName

# ------------------ Final Export ----------------- # 
# ------------------ External ----------------- # 
$FileContentExternal =  $FileContentExternal -replace "%ENTITYNAME%", $EntityName
$FileContentExternal =  $FileContentExternal -replace "%COLUMNLIST%", $ColumnList
$FileContentExternal =  $FileContentExternal -replace "%COLUMNEXTDDL%", $ColumnDDL
$FileContentExternal =  $FileContentExternal -replace "%CREATETIME%", $CreateTime
$FileContentExternal =  $FileContentExternal -replace "%COLUMNTYPINGS%", $ColumnTypings
$FileContentExternal =  $FileContentExternal -replace "%BLOBACCOUNT%", $BlobAccountNameName 
$FileContentExternal =  $FileContentExternal -replace "%CONTAINERNAME%", $EntityName.ToLower() #$EntityNameFull
$FileContentExternal =  $FileContentExternal -replace "%FILEFORMAT%", $PolybaseFileFormat
$FileContentExternal =  $FileContentExternal -replace "%CREDENTIALNAME%", $CredentialName
$FileContentExternal =  $FileContentExternal -replace "%PRIMARYKEY%", $PrimaryKey
$FileContentExternal =  $FileContentExternal -replace "%LAKEROOT%", $LakeRoot
$FileContentExternal =  $FileContentExternal -replace "%EXTDATASOURCE%", $ExternalDataSource
#$FileContentExternal


$FileContentExternal | out-file $($SQLDeploymentPath + 'External.' +  $EntityName + '.dsql')

}