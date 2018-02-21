# -------------------------------------------------------------------------------- # 
# Purpose: To create the Json objects for ADF
# Createded by: Terry McCann (Adatis consulting limited) 
# Created on: 30/01/2014
# Version history: 
#      V1 - 
# -------------------------------------------------------------------------------- #


#---------------- This script does the following ----------------------#

# 1 Read a file
# 2 replace parts of the file
# 3 Read data from a sql database / Option to not read from a DB but from a file

# VARIABLES:
# %CREATETIME%     - A datetime stamp for the auto-comments within the script. Populated at script runtime
# %ENTITYNAME%     - The name of the entity, this is the table name across the various warehouse stages
# %COLUMNLIST%     - Comma-separated list of columns within the entity
# %COLUMNTYPINGS%  - Comma-separated list of columns within the entity, including CAST() and ISNULL() wrappers to enforce target datatypes
# %COLUMNEXTDDL%   - Comma-separated list of columns within the entity, including polybase datatype
# %BLOBACCOUNT%    - Name of the blob storage account
# %CONTAINERNAME%  - Name of the entity-specific container within blob storage
# %FILEFORMAT%     - Name of the file format external resource that describes the filetype this entity belongs to

#----------- Vaiables -------------# 
$DatabaseName = 'AdventureWorks'
$ServerName = '.'
$UserNameShort = 'tpm'
$MasterFolderLocation = 'G:\GitHub\MagicWorks\Polybase Generation\'
$DeployFolderLocation = 'G:\GitHub\MagicWorks\Polybase Generation\SQLToBeDeployed\'

$BlobAccountName = 'magicworksblob'
$BlobStorageKey = 'WR6PLCnUMJ9Hu6Wkt7EUadRLDnoVF3cTabiGm//3FBXXJOSFAPqjrkfqqEW9qT4P2OlsKDcY0iSRUfDWtNhKrA=='
$DatabaseName= 'Adventureworks'
$UserNameShort  = 'acl\tpm'

$query = "EXEC datawarehouse.AdatisASDWMetadata; "

#----------- Do not change -----------#
$FileLocation = $MasterFolderLocation + 'Template-Staging.CreateLoad.dsql'

$ServerAConnectionString = 'Data Source='+$ServerName+';Initial Catalog='+$DatabaseName+';User Id='+ $UserNameShort +';Integrated Security = True'
$ServerAConnection = new-object system.data.SqlClient.SqlConnection($ServerAConnectionString);


$dataSet = new-object "System.Data.DataSet" "MetadataDataset" 
$dataAdapter = new-object "System.Data.SqlClient.SqlDataAdapter" ($Query, $ServerAConnection)
$dataAdapter.Fill($dataSet) | Out-Null

foreach ($RowOuter in $dataSet.Tables[0].Rows)
    { 
        $FileContent = Get-Content $FileLocation
        $EntityNameFull = $RowOuter[0] 
        $EntityName = $EntityNameFull -replace '[][]',''
        $EntityName = $EntityName.Split(".")[1] 
        
 

#-------------------- Loop -------------#
$DDLdataSet = $null
$DDLdataAdapter = $null



$DDLdataSet = new-object "System.Data.DataSet" "MetadataDataset" 
$DDLdataAdapter = new-object "System.Data.SqlClient.SqlDataAdapter" ($QueryDDL, $ServerAConnection)
$DDLdataAdapter.Fill($DDLdataSet) | Out-Null

foreach ($Row in $DDLdataSet.Tables[0].Rows)
    { 
        $ColumnDDL=  $Row[0]
        $ColumnList=  $Row[1]
    }

# ------------------ Final Export ----------------- # 
$FileContent =  $FileContent -replace "%ENTITYNAME%", $EntityName
$FileContent =  $FileContent -replace "%COLUMNLIST%", $ColumnList
$FileContent =  $FileContent -replace "%COLUMNDDL%", $ColumnDDL

$FileContent | out-file $($DeployFolderLocation + $EntityName + '.sql')
    }