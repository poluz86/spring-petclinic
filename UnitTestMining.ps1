$files = Get-ChildItem "./target/surefire-reports/" -Filter "*.xml"
foreach($item in $files){
    Write-Host $item
}