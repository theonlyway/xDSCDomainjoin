# Builds
|Master   |  Development |
|:------:|:------:|:-------:|:-------:|
[![Build status](https://ci.appveyor.com/api/projects/status/h03858kuyk31rwn7/branch/master?svg=true)](https://ci.appveyor.com/project/theonlyway/xdscdomainjoin/branch/master)|[![Build status](https://ci.appveyor.com/api/projects/status/h03858kuyk31rwn7?svg=true)](https://ci.appveyor.com/project/theonlyway/xdscdomainjoin)

# xDSCDomainjoin #

## Overview ##

The microsoft module has a mandatory parameter for the machine name. In my particular scenario I am already setting the machine name via vClouds sysprep and DSC doesn't neccessarialy need to know or does know the machine name when it's deploying config to the node so I basically just need to be able to switch the machine from a workgroup in to the domain.

This is basically a stripped down version of xComputer from xComputerManagement (https://github.com/PowerShell/xComputerManagement) that doesn't contain the majority of the logic surrounding the machine name.

### Parameters ###

**Domain**

- Specify the domain you want to join

*Note: This is a required parameter*

**Credentials**

- Specify the credentials that have permissions to join the domain

*Note: This is a required parameter*

**JoinOU**

- Optional paremeter to specify a specific OU to join the node to

### Example ###
    xDSCDomainjoin JoinDomain
    {
    Domain = $Domain 
    Credential = $Credential  # Credential to join to domain
    JoinOU = "CN=Computers,DC=someplace,DC=qld,DC=gov,DC=au"
    }
