# Script Name: - asa.ps1
# Created by:   - Alex Burdenko
# Created on:   - 01/22/2016

# Usage:
#---------------  
# 
# Example:- PS> PowerShell asa.ps1 -jobName TransformPatient

# Parameters
param (	
	[string]$jobName="CarePlan"
	, [string]$resourceGroupName = "StreamAnalytics-Default-East-US-2"
	, [string]$location = "East US 2"	
	, [string]$subscriptionName
	, [switch]$start = $false
	, [switch]$stop = $false
 ) 

Clear-Host

#Imports
Import-Module "Azure.psd1"
Import-Module "AzureRM.Profile.psd1"
Import-Module "AzureRM.StreamAnalytics.psd1"
Import-Module "AzureRM.Resources.psd1"

function doAll()
{	
	stopJob

	# TODO: Test if the resource group exists. If not, create it.
	$resourceGroup = Find-AzureRmResourceGroup | Select-String $resourceGroupName
	if (!$resourceGroup )
	{
		New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
	}

	$path = resolve-path "..\StreamingAnalytics\$jobName.json"
	Write-Host "Processing file: $path ..."
	#New-AzureRmStreamAnalyticsJob –File "$path" –Name $jobName -ResourceGroupName $resourceGroupName -Force -WarningAction SilentlyContinue

	New-AzureRmStreamAnalyticsJob `
		-ResourceGroupName "$resourceGroupName" `
		-File "$path" `
		-Name "$jobName" -Force

	Write-Host "Done." 
	
	startJob	
}

function startJob() {
	Write-Host "Starting Azure Streaming Analytics Job $jobName ..."
	$res = Start-AzureRmStreamAnalyticsJob -Name "$jobName" `
		-ResourceGroupName "$resourceGroupName" 	

	if ($res -ne $true) {
		Write-Error "Could not start job $jobName."
	}

	Write-Host "Done." 	
}

function stopJob() {
	Write-Host "Stoping Azure Streaming Analytics Job $jobName ..."
	$res = Stop-AzureRmStreamAnalyticsJob -Name "$jobName" `
		-ResourceGroupName "$resourceGroupName" 	

	if ($res -ne $true) {
		Write-Error "Could not stop job $jobName."
	}

	Write-Host "Done." 	
}

# Start Main Control Flow Below

$subscriptionStr = Get-AzureSubscription –SubscriptionName $subscriptionName | out-string -stream | select-string SubscriptionId 
$subscriptionId = $subscriptionStr.Line.split(":")[1].Trim()

#Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId $subscriptionId

if( $start ) {
	startJob
}
elseif( $stop ) {
	stopJob
}
else {
	doAll
}
