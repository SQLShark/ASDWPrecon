# -------------------------------------------------------------------------------- # 
# Purpose: To create the Json objects for ADF
# Createded by: Terry McCann (Adatis consulting limited) 
# Created on: 30/01/2017
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
# %CREDENTIALNAME%


## Normal user
#$UserName = 'adwadmin'
#$Password = ''

## Large User
$UserName = 'gandalf'
$Password = 'Password1234!'


$DataWarehouseName = 'sqlbits2018'
$ServerName = 'tcp:magicadventure.database.windows.net'

$BlobStorageKey = ''
$BlobAccountName = ''
$CreateTime = Get-Date



# ------------ Process all transform scripts ---------- #
Get-ChildItem "G:\GitHub\MagicWorks\Polybase Generation\SQLToBeDeployed" -Filter *.dsql | 
Foreach-Object {
    $content = Get-Content $_.FullName  | Out-String
    #$content
    $spm = $content
    $_.FullName

$params = @{
  'Database' = $DataWarehouseName
  'ServerInstance' =  'tcp:magicadventure.database.windows.net'
  'Username' = $UserName
  'Password' = $Password
  'OutputSqlErrors' = $true
  'Query' = $spm
  }

  Invoke-Sqlcmd  @params

}
