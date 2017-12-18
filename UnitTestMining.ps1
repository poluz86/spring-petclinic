$files = Get-ChildItem "/var/lib/jenkins/workspace/Commit_Phase/target/surefire-reports/" -Filter "*.xml"

foreach($item in $files){
     if (-Not($item.Name -match 'PetTypeFormatterTests.xml')){
        continue
     }

     [xml]$result = Get-Content $item.FullName
     foreach($test in $result.testsuite.ChildNodes){
         if(-Not($test.LocalName -match 'testcase')) { continue }

         Write-Host $test.name
     }
     
}