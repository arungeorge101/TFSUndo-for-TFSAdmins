$tfLocation = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE" 
$tfsBranchName = “{enter your TFS branch/folder/file location}“ 
$tfsCollectionName = "http://tfsserver:8080/tfscollection” 
$logFile = “{log file location}“ 


Function GetUserFileList($tfsBranchName) 
{ 
	try{
        # Array to hold the object (user/file/workspace) objects 
        $arrayFileUserMapping = @(); 
        
        If (Test-Path $logFile) 
        { 
                Remove-Item $logFile; 
        } 
        
        Set-Location $tfLocation; 
        
        .\tf.exe status $tfsBranchName /collection:$tfsCollectionName /user:* /format:detailed /recursive >> $logFile; 
        
        Set-Location $PSScriptRoot; 
        
        foreach ($line in Get-Content $logFile) 
        {         
                If($line.StartsWith("$")) 
                { 
                        $objCurrFile = New-Object System.Object; 
                        $splitStringFile = $line -Split ";"; 
                        $objCurrFile | Add-Member -type NoteProperty -name FileName -value $splitStringFile[0];                         
                } 
                Else 
                { 
                        foreach ($singleLine in $line){ 
                                If($singleLine.StartsWith("  User")) 
                                { 
                                        $splitStringUser = $singleLine -Split ":"; 
                                        $objCurrFile | Add-Member -type NoteProperty -name User -value $splitStringUser[1];                                                                                 
                                } 
                                ElseIf($singleLine.StartsWith("  Workspace")) 
                                { 
                                        $splitStringWS = $singleLine -Split ":"; 
                                        $objCurrFile | Add-Member -type NoteProperty -name Workspace -value $splitStringWS[1];                                 
                                } 
                        } 
                } 
                
                $arrayFileUserMapping += $objCurrFile; 
        }         
                
        $uniqueWorkspaceArray = $arrayFileUserMapping | Group Workspace 
        $uniqueUserArray = $arrayFileUserMapping | Group User 
        
        for($i=0;$i -lt $uniqueUserArray.count; $i++) 
        { 
                $workspaceWOSpace = $uniqueWorkspaceArray[$i].Name.Trim() 
                $userWOSpace = $uniqueUserArray[$i].Name.Trim() 
                $workspace = $workspaceWOSpace + ";" + $userWOSpace; 
                
                Set-Location $tfLocation; 
                .\tf.exe undo $tfsBranchName /collection:$tfsCollectionName /workspace:""$workspace"" /recursive /noprompt;                 
                Set-Location $PSScriptRoot; 
        } 
	}
	Catch [system.exception]
 	{
  		"Oops, something's wrong!!!"
 	}
} 

GetUserFileList($tfsBranchName);
