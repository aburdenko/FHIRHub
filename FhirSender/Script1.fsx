#r @".\packages\WindowsAzure.ServiceBus.3.1.0\lib\net45-full\Microsoft.ServiceBus.dll"
#r @".\packages\Hl7.Fhir.0.11.5\lib\net45\Hl7.Fhir.Core.dll"
#r "System.ServiceModel.dll"
#r "System.Runtime.Serialization.dll"
#load "Builders.fs"

open System
open System.IO
open System.Collections.Generic
open Microsoft.ServiceBus.Messaging
open System.Runtime.Serialization

open System.Text
open Hl7.Fhir.Model
open System.Collections
open Hl7.Fhir.Serialization
open Hl7.Fhir.Rest


System.IO.Directory.SetCurrentDirectory (__SOURCE_DIRECTORY__)

let connectionString = "Endpoint=sb://my.servicebus.windows.net/;SharedAccessKeyName=SendPolicy;SharedAccessKey=123
let eventHubName = "myeventhub"

Builders.BuildAndSendFhirCarePlans( 10, connectionString, eventHubName)
Builders.BuildAndSendFhirPatients( 50, connectionString, eventHubName)
