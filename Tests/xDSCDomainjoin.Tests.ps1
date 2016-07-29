Import-Module -Name .\DSCResources\xDSCDomainjoin\xDSCDomainjoin.psm1

InModuleScope -ModuleName xDSCDomainjoin -ScriptBlock {
  $username = 'USER'
  $password = 'PASSWORD'
  $secureString = $password | ConvertTo-SecureString -AsPlainText -Force
  $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $secureString  
  $Domain = 'test.local'
  $JoinOU = 'ou=test,dc=test,dc=com'


  Describe -Name 'Testing if functions return correct objects' -Fixture {
    It -name 'Get-TargetResource returns a hashtable' -test {
      Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU | Should Be 'System.Collections.Hashtable'
    }

    It -name 'Test-TargetResource returns true or false' -test {
      (Test-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).GetType() -as [string] | Should Be 'bool'
    }
  }

  Describe -Name 'Testing if Get-TargetResource returns correct values' -Fixture {
    Mock -CommandName Get-WMIObject -MockWith {
      [PSCustomObject]@{
        Domain = $Domain
      }
    }
    It -name "Get-TargetResource returns domain $Domain" -test {
      (Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).Domain | Should Be $Domain
    }
    It -name 'Get-TargetResource returns credentials' -test {
      (Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).Credential | Should Be 'MSFT_Credential'
    }
    It -name "Get-TargetResource returns OU $JoinOU" -test {
      (Get-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU).joinOU | Should Be $JoinOU
    }
  }

  Describe -Name 'Testing Test-TargetResource' -Fixture {
    Mock -CommandName Get-WMIObject -MockWith {
      [PSCustomObject]@{
        Domain = $Domain
      }
    }
    It -name "Test-TargetResource should return true as it matches $Domain" -test {
      Test-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU | Should Be $true
    }
    Mock -CommandName Get-WMIObject -MockWith {
      [PSCustomObject]@{
        Domain = 'Testing fail'
      }
    }
    It -name "Test-TargetResource should return false as it shouldn't match $Domain" -test {
      Test-TargetResource -Domain $Domain -Credential $credential -JoinOU $JoinOU | Should Be $false
    }
  }
}

