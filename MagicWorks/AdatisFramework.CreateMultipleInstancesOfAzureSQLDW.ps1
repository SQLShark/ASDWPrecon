##############################################################################################################################
## 
## 
## 
## 
##
##############################################################################################################################

#$AzureLogin = Login-AzureRmAccount 

$resourceGroupLocation = 'North Europe'
Select-AzureRmSubscription -SubscriptionName 'MICROSOFT AZURE SPONSORSHIP'




$j = 70

for ($i=1; $i -le $j; $i++)
{

    $AzureSQLDataWarehouseName = $('sqlbits2018User'+$i)
    #######################################
    $DatabaseServer = 'magicadventure'
    $ResourceGroup = 'sqlbits2018'
    $ResourceGroupLocation = 'North Europe'
    $TemplateStore = 'G:\GitHub\MagicWorks\DeploymentTemplates\'
    #######################################
    $AzureSQLDataWarehouseServer = 'magicadventure'
    $AzureSQLDataWarehouseUser = 'gandalf'
    $AzureSQLDataWarehousePassword = 'Password1234!'
    #######################################
    
    
    $ASDW = Get-AzureRmSqlDatabase -DatabaseName $AzureSQLDataWarehouseName -ServerName $DatabaseServer -ResourceGroupName $ResourceGroup -ErrorAction SilentlyContinue

    if ($ASDW -eq $null) {

        Write-Host $AzureSQLDataWarehouseName "Started deployment" -ForegroundColor Cyan

        New-AzureRmSqlDatabase -RequestedServiceObjectiveName "DW100" -DatabaseName $AzureSQLDataWarehouseName -ServerName $DatabaseServer -ResourceGroupName $ResourceGroup -Edition "DataWarehouse" -CollationName "SQL_Latin1_General_CP1_CI_AS" -MaxSizeBytes 10995116277760 | out-null
        
        Write-Host  $AzureSQLDataWarehouseName "Created" -ForegroundColor Green
        } else {
            Write-Host $AzureSQLDataWarehouseName "Already exists" -ForegroundColor Yellow
        }
        # ------------ Process all transform scripts ---------- #
        Get-ChildItem "G:\GitHub\Labs\BuildAutomation\" -Filter *.sql | 
        Foreach-Object {
            $content = Get-Content $_.FullName  | Out-String
            #$content
            $spm = $content
            $_.FullName

        $params = @{
          'Database' = $AzureSQLDataWarehouseName
          'ServerInstance' =  'tcp:magicadventure.database.windows.net'
          'Username' = $AzureSQLDataWarehouseUser
          'Password' = $AzureSQLDataWarehousePassword 
          'OutputSqlErrors' = $true
          'Query' = $spm
          }

          Invoke-Sqlcmd  @params

        }

        

        $DataWarehouse = $null
        $ASDW = $null

}
