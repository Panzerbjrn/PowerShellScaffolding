Describe "New-PesterLab" {

    $Path = '/home/duffney/temp'
    $Name = 'pesterapp'
    New-PesterLab -Path $Path -Name $Name

    It "New Directory Should Exist" {
        (Test-Path -Path $Path) | Should Be $true
    }
    It "app folder should exist" {
        (Test-Path "$Path\$Name") | should be $true
    }
    It ".config file value should be Pester is Pretty Awesome" {
        (Get-Content -Path "$Path\$Name.config") | should be 'Pester is Pretty Awesome'
    }    
}