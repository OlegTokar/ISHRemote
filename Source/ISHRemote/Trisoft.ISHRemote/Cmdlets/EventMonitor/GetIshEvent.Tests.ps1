Write-Host ("`r`nLoading ISHRemote.PesterSetup.ps1 for MyCommand[" + $MyInvocation.MyCommand + "]...")
. (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\..\ISHRemote.PesterSetup.ps1")
$cmdletName = "Get-IshEvent"
try {

Describe �Get-IshEvent" -Tags "Create" {
	Write-Host "Initializing Test Data and Variables"
	$requestedMetadata = Set-IshRequestedMetadataField -IshSession $ishSession -Name "FNAME" |
	                     Set-IshRequestedMetadataField -IshSession $ishSession -Name "FDOCUMENTTYPE" |
	                     Set-IshRequestedMetadataField -IshSession $ishSession -Name "READ-ACCESS" -ValueType Element |
	                     Set-IshRequestedMetadataField -IshSession $ishSession -Name "FUSERGROUP" -ValueType Element 
	$ishFolderTestRootOriginal = Get-IshFolder -IShSession $ishSession -FolderPath $folderTestRootPath -RequestedMetadata $requestedMetadata
	$folderIdTestRootOriginal = $ishFolderTestRootOriginal.IshFolderRef
	$folderTypeTestRootOriginal = $ishFolderTestRootOriginal.IshFolderType
	Write-Debug ("folderIdTestRootOriginal[" + $folderIdTestRootOriginal + "] folderTypeTestRootOriginal[" + $folderTypeTestRootOriginal + "]")
	$ownedByTestRootOriginal = Get-IshMetadataField -IshSession $ishSession -Name "FUSERGROUP" -ValueType Element -IshField $ishFolderTestRootOriginal.IshField
	$readAccessTestRootOriginal = (Get-IshMetadataField -IshSession $ishSession -Name "READ-ACCESS" -ValueType Element -IshField $ishFolderTestRootOriginal.IshField).Split($ishSession.Seperator)

	$global:ishFolderCmdlet = Add-IshFolder -IShSession $ishSession -ParentFolderId $folderIdTestRootOriginal -FolderType $folderTypeTestRootOriginal -FolderName $cmdletName -OwnedBy $ownedByTestRootOriginal -ReadAccess $readAccessTestRootOriginal
	$ishFolderTopic = Add-IshFolder -IshSession $ishSession -ParentFolderId ($global:ishFolderCmdlet.IshFolderRef) -FolderType ISHModule -FolderName "Topic" -OwnedBy $ownedByTestRootOriginal -ReadAccess $readAccessTestRootOriginal
	$ishTopicMetadata = Set-IshMetadataField -IshSession $ishSession -Name "FTITLE" -Level Logical -Value "Topic $timestamp" |
						Set-IshMetadataField -IshSession $ishSession -Name "FAUTHOR" -Level Lng -ValueType Element -Value $ishUserAuthor |
						Set-IshMetadataField -IshSession $ishSession -Name "FSTATUS" -Level Lng -ValueType Element -Value $ishStatusDraft
	# Forcing a status transition to release, triggers Translation Management which means a BackgroundTask and EventMonitor entry
	$ishObject = Add-IshDocumentObj -IshSession $ishSession -FolderId $ishFolderTopic.IshFolderRef -IshType ISHModule -Lng $ishLng -Metadata $ishTopicMetadata -FileContent $ditaTopicFileContent |
	             Set-IshMetadataField -IshSession $ishSession -Name "FSTATUS" -Level Lng -ValueType Element -Value $ishStatusReleased |
				 Set-IshDocumentObj -IshSession $ishSession


    $allProgressMetadata = Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name PROGRESSID | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name EVENTID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name CREATIONDATE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name MODIFICATIONDATE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name EVENTTYPE | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name DESCRIPTION |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name STATUS -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name STATUS -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name USERID -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name USERID -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name PARENTPROGRESSID | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name MAXIMUMPROGRESS |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name CURRENTPROGRESS
    $allDetailMetadata = Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name DETAILID | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name PROGRESSID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name CREATIONDATE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name HOSTNAME |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name ACTION | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name DESCRIPTION |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name STATUS -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name STATUS -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTLEVEL -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTLEVEL -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name PROCESSID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name THREADID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTDATATYPE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTDATASIZE
    $allMetadata = Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name PROGRESSID | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name EVENTID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name CREATIONDATE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name MODIFICATIONDATE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name EVENTTYPE | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name DESCRIPTION |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name STATUS -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name STATUS -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name USERID -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name USERID -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name PARENTPROGRESSID | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name MAXIMUMPROGRESS |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name CURRENTPROGRESS |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name DETAILID | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name PROGRESSID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name CREATIONDATE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name HOSTNAME |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name ACTION | 
			           Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name DESCRIPTION |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name STATUS -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name STATUS -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTLEVEL -ValueType Value |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTLEVEL -ValueType Element |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name PROCESSID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name THREADID |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTDATATYPE |
					   Set-IshRequestedMetadataField -IshSession $ishSession -Level Detail -Name EVENTDATASIZE


	Context "Get-IshEvent" {
		$metadata = Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name PROGRESSID | 
		            Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name EVENTID |
					Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name EVENTTYPE |
					Set-IshRequestedMetadataField -IshSession $ishSession -Level Progress -Name STATUS
		$ishEvent = (Get-IshEvent -IshSession $ishSession -UserFilter All -RequestedMetadata $metadata)[0]
		It "GetType().Name" {
			$ishEvent.GetType().Name | Should BeExactly "IshEvent"
		}
		It "ishObject.IshField" {
			$ishEvent.IshField | Should Not BeNullOrEmpty
		}
		It "ishObject.IshRef" {
			$ishEvent.IshRef | Should Not BeNullOrEmpty
		}
		# Double check following 2 ReferenceType enum usage 
		It "ishEvent.ObjectRef[Enumerations.ReferenceType.EventProgress]" {
			$ishEvent.ObjectRef["EventProgress"] | Should Not BeNullOrEmpty
		}
		#It "ishEvent.ObjectRef[Enumerations.ReferenceType.EventDetail]" {
		#	$ishEvent.ObjectRef["EventDetail"] | Should Not BeNullOrEmpty
		#}
		It "Parameter IshSession/ModifiedSince/UserFilter invalid" {
			{ Get-IshEvent -IShSession "INVALIDISHSESSION" -ModifiedSince "INVALIDDATE" -UserFilter "INVALIDUSERFILTER" } | Should Throw
		}
		It "Parameter RequestedMetadata/MetadataFile invalid" {
			{ Get-IshEvent -IShSession $ishSession -RequestedMetadata "INVALIDMETADATA" -MetadataFilter "INVALIDFILTER"  } | Should Throw
		}
		It "Parameter IshSession/UserFilter/MetadataFilter are optional" {
			$ishEvent = (Get-IshEvent -ModifiedSince ((Get-Date).AddSeconds(-10)) -RequestedMetadata $allProgressMetadata)[0]
			($ishEvent | Get-IshMetadataField -IshSession $ishSession -Level Task -Name USERID -ValueType Element).StartsWith('VUSER') | Should Be $true
			($ishEvent | Get-IshMetadataField -IshSession $ishSession -Level Task -Name STATUS -ValueType Element).StartsWith('VEVENT') | Should Be $true
		}
		It "Option IshSession.DefaultRequestedMetadata" {
			$oldDefaultRequestedMetadata = $ishSession.DefaultRequestedMetadata
			$ishSession.DefaultRequestedMetadata = "Descriptive"
			$ishEvent = (Get-IshEvent -IShSession $ishSession)[0]
			(($ishEvent.IshField.Count -eq 1) -or ($ishEvent.IshField.Count -eq 2)) | Should Be $true  # Either BackgroundTask has run and you get progressid/detailid, or it didn't and you only get progressid
			$ishSession.DefaultRequestedMetadata = "Basic"
			$ishEvent = (Get-IshEvent -IShSession $ishSession)[0]
			$ishEvent.status.Length -ge 1 | Should Be $true
			$ishEvent.status_task_element.StartsWith('VEVENTSTATUS') | Should Be $true 
			(($ishEvent.IshField.Count -eq 13) -or ($ishEvent.IshField.Count -eq 19)) | Should Be $true
			$ishSession.DefaultRequestedMetadata = "All"
			$ishEvent = (Get-IshEvent -IShSession $ishSession)[0]
			(($ishEvent.IshField.Count -eq 18) -or ($ishEvent.IshField.Count -eq 26)) | Should Be $true
			$ishSession.DefaultRequestedMetadata = $oldDefaultRequestedMetadata
		}
		It "Parameter ModifiedSince is now" {
			(Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(1)) -UserFilter All).Count | Should Be 0
		}
		It "Parameter RequestedMetadata only all of Task level" {
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddSeconds(-10)) -UserFilter All -RequestedMetadata $allProgressMetadata)[0]
			$ishEvent.ObjectRef["EventProgress"] -gt 0 | Should Be $true
			#$ishEvent.ObjectRef["EventDetail"] -gt 0 | Should Be $true
			$ishEvent.IshField.Count -ge 16 | Should Be $true
		}
		It "Parameter RequestedMetadata only all of History level" {
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(-1)) -UserFilter All -RequestedMetadata $allDetailMetadata)[0]
			$ishEvent.ObjectRef["EventProgress"] -gt 0 | Should Be $true
			#$ishEvent.ObjectRef["EventDetail"] -gt 0 | Should Be $true
			$ishEvent.IshField.Count -ge 1 | Should Be $true  # At least 1 entries returned if BackgroundTask service is not running, otherwise more
		}
		It "Parameter RequestedMetadata PipelineObjectPreference=PSObjectNoteProperty" {
			$ishSession.PipelineObjectPreference | Should Be "PSObjectNoteProperty"
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(-1)) -UserFilter All -RequestedMetadata $allMetadata)[0]
			$ishEvent.GetType().Name | Should BeExactly "IshEvent"  # and not PSObject
			[bool]($ishEvent.PSobject.Properties.name -match "status_task_element") | Should Be $true
			[bool]($ishEvent.PSobject.Properties.name -match "userid_task_element") | Should Be $true
			[bool]($ishEvent.PSobject.Properties.name -match "modificationdate") | Should Be $true
			$ishEvent.modificationdate -like "*/*" | Should Be $false  # It should be sortable date format: yyyy-MM-ddTHH:mm:ss
		}
		It "Parameter RequestedMetadata PipelineObjectPreference=Off" {
		    $pipelineObjectPreference = $ishSession.PipelineObjectPreference
			$ishSession.PipelineObjectPreference = "Off"
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(-1)) -UserFilter All -RequestedMetadata $allMetadata)[0]
			$ishEvent.GetType().Name | Should BeExactly "IshEvent"
			[bool]($ishEvent.PSobject.Properties.name -match "status_task_element") | Should Be $false
			[bool]($ishEvent.PSobject.Properties.name -match "userid_task_element") | Should Be $false
			[bool]($ishEvent.PSobject.Properties.name -match "modificationdate") | Should Be $false
			$ishSession.PipelineObjectPreference = $pipelineObjectPreference
		}
		It "Parameter MetadataFilter Filter to exactly one" {
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(-1)) -UserFilter All -RequestedMetadata $allProgressMetadata)[0]
			$filterMetadata = Set-IshMetadataFilterField -IshSession $ishSession -Level Task -Name USERID -ValueType Element -Value ($ishEvent | Get-IshMetadataField -IshSession $ishSession -Level Task -Name USERID -ValueType Element) |
			                  Set-IshMetadataFilterField -IshSession $ishSession -Level Task -Name TASKID -ValueType Element -Value ($ishEvent | Get-IshMetadataField -IshSession $ishSession -Level Task -Name TASKID)
			$ishEventArray = Get-IshEvent -IshSession $ishSession -MetadataFilter $filterMetadata
			#Write-Host ("ishEvent.IshRef["+ $ishEvent.IshRef + "] ishEventArray.IshRef["+ $ishEvent.IshRef + "]")
			$ishEventArray.Count -ge 1 | Should Be $true  # earlier on, also filter on HISTORYID, but that is not always filled in, even with the windows service off
		}
		It "Parameter IshEvent invalid" {
			{ Get-IshEvent -IshSession $ishSession -IshEvent "INVALIDISHEVENT" } | Should Throw
		}
		It "Parameter IshEvent Single" {
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(-1)) -UserFilter Current)[0]
			$taskId = $ishEvent | Get-IshMetadataField -IshSession $ishSession -Level Task -Name TASKID
			$ishEventArray = Get-IshEvent -IshSession $ishSession -IshEvent $ishEvent
			$ishEventArray.Count -ge 1 | Should Be $true
			$ishEventArray.IshRef | Should Be $taskId
		}
		<# TODO It "Parameter IshEvent Multiple" {
		}
		#>
		It "Pipeline IshEvent Single" {
			$ishEvent = (Get-IshEvent -IshSession $ishSession -ModifiedSince ((Get-Date).AddMinutes(-1)) -UserFilter Current)[0]
			$taskId = $ishEvent | Get-IshMetadataField -IshSession $ishSession -Level Task -Name TASKID
			$ishEventArray = $ishEvent | Get-IshEvent -IshSession $ishSession
			$ishEventArray.Count -ge 1 | Should Be $true
			$ishEventArray.IshRef | Should Be $taskId
		}
		<# TODO It "Pipeline IshEvent Multiple" {
		}
		#>
	}
	#>
}


} finally {
	Write-Host "Cleaning Test Data and Variables"
	$folderCmdletRootPath = (Join-Path $folderTestRootPath $cmdletName)
	try { Get-IshFolder -IshSession $ishSession -FolderPath $folderCmdletRootPath -Recurse | Get-IshFolderContent -IshSession $ishSession | Remove-IshDocumentObj -IshSession $ishSession -Force } catch { }
	try { Remove-IshFolder -IshSession $ishSession -FolderPath $folderCmdletRootPath -Recurse } catch { }
}