Demonstrates the use of F# to stream the Hl7 FHIR data model as events over Azure EventHub that can be transformed on the fly by Azure Streaming Analytics and dropped into SQL Server. 

Project Structure
---
AzureAutomation - powershell scripts for deploying Azure Streaming Analytics SQL scripts

StreamingAnalytics - Azure Streaming Analytics SQL scripts

FhirSender - F# fsx script and related code for creating a FHIR model and sending over EventHub

PowerBI - PowerBI designer project

SSDT - Azure SQL Database project

