Import-Module .\DSCResources\xDSCDomainjoin\xDSCDomainjoin.psm1

InModuleScope xDSCDomainjoin {
  $EnsurePresent = "Present"
  $EnsureAbsent = "Absent"
  $username = "USER"
  $password = "PASSWORD"
  $secureString = $password | ConvertTo-SecureString -AsPlainText -Force
  $credential = New-Object System.Management.Automation.PSCredential $username, $secureString  
  $Domain = "test.local"
  $JoinOU = "ou=test,dc=test,dc=com"


    Describe "Testing if functions return correct objects" {

    It "Get-TargetResource returns a hashtable" {
      Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU | Should Be 'System.Collections.Hashtable'
    }

    It "Test-TargetResource returns true or false" {
      (Test-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).GetType() -as [string] | Should Be 'bool'
    }
  }

    Describe "Testing if Get-TargetResource returns correct values" {
    Mock Get-WMIObject {[PSCustomObject]@{Domain = $Domain}}
    It "Get-TargetResource returns domain $domain" {
      (Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).Domain | Should Be $Domain
    }
    It "Get-TargetResource returns credentials" {
      (Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).Credential | Should Be 'MSFT_Credential'
    }
    It "Get-TargetResource returns OU $joinOU" {
      (Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).joinOU | Should Be $joinOU
    }
  }

    Describe "Testing Test-TargetResource" {
    Mock Get-WMIObject {[PSCustomObject]@{Domain = $Domain}}
    It "Test-TargetResource should return true as it matches $domain" {
      Test-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU | Should Be $true
    }
    Mock Get-WMIObject {[PSCustomObject]@{Domain = "Testing fail"}}
    It "Test-TargetResource should return false as it shouldn't match $domain" {
      Test-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU | Should Be $false
    }
  }
}

