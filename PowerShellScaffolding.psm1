#region Script Header
#	Thought for the day:
#	NAME: PowerShellScaffolding.psm1
#	AUTHOR: Lars Panzerbjørn
#	CONTACT: lpetersson@hotmail.com / GitHub: Panzerbjrn / Twitter: lpetersson
#	DATE: 2019.06.20
#	VERSION: 0.1 - 2019.06.20 - Module Created with Create-NewModuleStructure by Lars Panzerbjørn
#
#	SYNOPSIS:
#
#
#	DESCRIPTION:
#	Module that will comtain scaffolding for a new module structure. This will include various template files to get started quickly.
#
#	REQUIREMENTS:
#
#endregion Script Header

#Requires -Version 4.0

[CmdletBinding(PositionalBinding=$False)]
param()

Write-Verbose $PSScriptRoot

#Get Functions and Helpers function definition files.
$Functions	= @( Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue )
$Helpers = @( Get-ChildItem -Path $PSScriptRoot\Helpers\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
ForEach ($Import in @($Functions + $Helpers))
{
	Try
	{
		. $Import.Fullname
	}
	Catch
	{
		Write-Error -Message "Failed to Import function $($Import.Fullname): $_"
	}
}

Export-ModuleMember -Function $Functions.Basename

