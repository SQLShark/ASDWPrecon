$UberScript =''


# ------------ Process all transform scripts ---------- #
Get-ChildItem "G:\GitHub\MagicWorks\Polybase Generation\SQLToBeDeployed" -Filter *.dsql | 
Foreach-Object {
    $content = Get-Content $_.FullName  | Out-String
    #$content
    $spm = $content
    Write-Host $_.FullName

    $UberScript += $content

}


$UberScript | out-file $('G:\GitHub\Labs\BuildAutomation\RunAll.sql')