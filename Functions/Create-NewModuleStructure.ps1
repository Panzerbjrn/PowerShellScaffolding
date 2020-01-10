Function Create-NewModuleStructure
{
<#
	.SYNOPSIS
		Creates a new Module Tree + Files

	.DESCRIPTION
		Creates a new Module Tree + Files

	.PARAMETER Path
		This is the path to where you want the Module + Tree created

	.PARAMETER ModuleName
		This is the name of the module you are creating.

	.PARAMETER Description
		This is the description for the module you are creating.

	.EXAMPLE
		Create-NewModuleStructure -Path C:\Temp\ -ModuleName Test-Module -Author LarsP -Description "Test PowerShell Module"

	.INPUTS
		None

	.OUTPUTS
		None

	.NOTES
		Version:				1.0
		Author:					Lars Panzerbjrn
		Creation Date:			2019.06.20
		Purpose/Change: 		Initial script development
		2018.12.03 - Update:	Added Content of PSM1 file
		2019.02.07 - Update:	Added Content of About_help file. Tidied up some code.

	.EXAMPLE
		Create-NewModuleStructure -ModuleName ServiceNowCMDB -Path C:\Temp -Description "Helper Functions to work with ServiceNow's CMDB"
#>
	[CmdletBinding(PositionalBinding=$false)]
	Param
	(
		[Parameter()][string]$Author="Lars Panzerbjørn",
		[Parameter(Mandatory)][string]$ModuleName,
		[Parameter()][string]$Path="C:\Temp",
		[Parameter()][string]$Company="Ordo Ursus",
		[Parameter()][string]$GitHub="Panzerbjrn",
		[Parameter()][string]$Email="Lars@Panzerbjrn.eu",
		[Parameter()][string]$Twitter="Panzerbjrn",
		[Parameter()][string]$LinkedIn="https://www.linkedin.com/in/lpetersson",
		[Parameter()][string]$Description = 'New PowerShell module',
		[Parameter()][switch]$Test
	)

	BEGIN
	{
		$Date = Get-Date -f yyyy.MM.dd
		Write-Verbose "Path is $Path"
		. "$PSScriptRoot\Content\Content.ps1"
	}

	PROCESS
	{
		$TFTD = Get-ThoughtForTheDay
		$Path="$Path\$ModuleName"
		Write-Verbose "Creating the module and function directories"
		IF(!(Test-Path -Path ($Path))) {New-Item ($Path) -ItemType Directory -Force}
		IF(!(Test-Path -Path ($Path+"\Helpers"))) {New-Item ($Path+"\Helpers") -ItemType Directory -Force} # For private/Helper functions that should not be exposed to end users
		IF(!(Test-Path -Path ($Path+"\Functions"))) {New-Item ($Path+"\Functions") -ItemType Directory -Force} # For public/exported functions
		IF(!(Test-Path -Path ($Path+"\en-GB"))) {New-Item ($Path+"\en-GB") -ItemType Directory -Force} # For English about_Help files
		IF(!(Test-Path -Path ($Path+"\WIP"))){New-Item ($Path+"\WIP") -ItemType Directory -Force} # For Functions that are Works in Progress
		IF(!(Test-Path -Path ($Path+"\Tests"))) {New-Item ($Path+"\Tests") -ItemType Directory -Force} # For Pester tests
		IF(!(Test-Path -Path ($Path+"\Templates"))) {New-Item ($Path+"\Templates") -ItemType Directory -Force} # For Template Files

		#Create the module and related files
		Write-Verbose "Creating the module and function files"
		IF(!(Test-Path -Path "$Path\$ModuleName.psm1")){New-Item "$Path\$ModuleName.psm1" -ItemType File}
		IF(!(Test-Path -Path "$Path\$ModuleName.psd1")){New-Item "$Path\$ModuleName.psd1" -ItemType File}
		IF(!(Test-Path -Path "$Path\en-GB\about_$ModuleName.help.txt")){New-Item "$Path\en-GB\about_$ModuleName.help.txt" -ItemType File}

		$PSMContent | Add-Content "$Path\$ModuleName.psm1" -Force
		$PSDContent | Add-Content "$Path\$ModuleName.psd1" -Force
		$AboutHelpContentenGB | Add-Content -Path "$Path\en-GB\about_$ModuleName.help.txt"
		$PowerShellTemplateDoFunction | Add-Content -Path "$Path\Templates\PowerShell.Template.Function.Do-Something.ps1"
		$PowerShellTemplateGetFunction | Add-Content -Path "$Path\Templates\PowerShell.Template.Function.Get-Something.ps1"
		$PowerShellTemplateVerbNoun | Add-Content -Path "$Path\Templates\PowerShell.Template.Function.Verb-Noun.ps1"
		$ModuleTest | Add-Content  -Path "$Path\Tests\Module.Test.ps1"
		# Put the Public Functions/exported functions into the Functions folder and Helper functions into Helpers folder
	}
	END
	{
		IF($Test) {Invoke-Pester "$Path\Tests\Module.Test.ps1"}
	}
}