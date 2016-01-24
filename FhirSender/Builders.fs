module Builders

open System.Collections.Generic
open Hl7.Fhir.Model
open Microsoft.ServiceBus.Messaging
open System
open System.ServiceModel
open System.Runtime.Serialization
open System.Xml.Serialization
open System.Text
open Hl7.Fhir.Serialization

   

let BuildFhirCarePlan(patientId: int, carePlanId : int) : CarePlan  = 
    let plan = new CarePlan ( Patient = new ResourceReference()
                              , Goal = new List<CarePlan.CarePlanGoalComponent>()                              
                              , Status = new Nullable<CarePlan.CarePlanStatus>()
                             )

    
    plan.Goal.Add(
         new CarePlan.CarePlanGoalComponent(
            Status = Nullable<CarePlan.CarePlanGoalStatus>(CarePlan.CarePlanGoalStatus.Achieved)
         )                 
    )

    let patientIdStr =  patientId.ToString()
    plan.Patient.Url <- new Uri(String.Concat( "http://patient/", patientIdStr |> string) ) 
    plan.Patient.Reference <- patientIdStr

    plan.Status <- new Nullable<CarePlan.CarePlanStatus>(CarePlan.CarePlanStatus.Completed)

    plan.Id <- carePlanId.ToString()
    
    plan    

let BuildFhirPatient(patientId : int) : Patient = 
    let patient = new Patient ( Name = new List<HumanName>() ,
                                BirthDate = "1990-01-01", 
                                Address = new List<Address>() ,                            
                                Identifier = new List<Identifier>(),
                                ManagingOrganization = new ResourceReference() )

    patient.Name.Add(
         new HumanName(
            Given = seq<string>["Alex"]
            , Family = seq<string>["Smith"]    
        ) 
    )

    patient.Identifier.Add( 
        new Identifier( 
            System = "http://test.relayhealth.com"
            , Value = "123" //Guid.NewGuid().ToString()
        )
     )

    patient.Address.Add( 
        new Address(
            City = "Boston"
            , Zip = "02446"
        )
     ) 

    let uriString = String.Concat( "http://org/", (new System.Random()).Next(1, 10) |> string) 
    patient.Id <- patientId.ToString()
    patient.ManagingOrganization.Url <- new Uri(uriString)
    patient.ManagingOrganization.Id <- "1"
    
    patient

// Test: let message = "{employees:[{firstName:John, lastName:Doe}]}"
let enQMsg( eventHubClient:EventHubClient, msg)  =                   
    printfn "Sending %s..." msg    
    eventHubClient.Send( new Microsoft.ServiceBus.Messaging.EventData(Encoding.UTF8.GetBytes(msg : string)));
    printfn "Sent %s." msg
    
    //enqMsg( jsonText )     

let testEnqMsg(connectionString, eventHubName) =
    let msg = "foo"
    let eventHubClient = EventHubClient.CreateFromConnectionString(connectionString, eventHubName)    
    enQMsg( eventHubClient, msg)

 
let BuildAndSendFhirCarePlans(n : int, connectionString, eventHubName) =            
    let rand = new System.Random()
    let eventHubClient = EventHubClient.CreateFromConnectionString(connectionString, eventHubName)                
    let carePlans = [for i in 1..n -> BuildFhirCarePlan(rand.Next(1, 10), rand.Next(1, 10)) |> FhirSerializer.SerializeResourceToJson ]             
    carePlans |> List.map (fun msg -> enQMsg( eventHubClient, msg) )
    

let BuildAndSendFhirPatients(n : int, connectionString, eventHubName) =        
    let rand = new System.Random()
    let eventHubClient = EventHubClient.CreateFromConnectionString(connectionString, eventHubName)    
    let patients = [for i in 1..n -> BuildFhirPatient(rand.Next(1, 10)) |> FhirSerializer.SerializeResourceToJson ]             
    patients |> List.map (fun msg -> enQMsg( eventHubClient, msg) )


//    let carePlans = String.Join("", strArr)
//    carePlans