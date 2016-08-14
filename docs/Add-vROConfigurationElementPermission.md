# Add-vROConfigurationElementPermission

## SYNOPSIS
    
Add a Permission to a vRO Configuration Element

## SYNTAX


## DESCRIPTION

Add a Permission to a vRO Configuration Element

## PARAMETERS


### Id

Configuration Element Id

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Principal

Specify the Permission Principal. Needs to be in the format user@domain or domain\user

* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: false

### Rights

Specify the Permission Rights

* Required: true
* Position: 3
* Default value: 
* Accept pipeline input: false

### WhatIf


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Confirm


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Add-vROConfigurationElementPermission -Id '3f92d2dc-a9fa-4323-900b-ef97196184ea' -Principal 
vRO_Users@vrademo.local -Rights 'View','Execute','Inspect'
```
