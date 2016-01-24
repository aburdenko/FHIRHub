CREATE TABLE [Report].[PatientCarePlan]
(
	[Id] INT NOT NULL PRIMARY KEY identity(1,1)
	, [OrgId] int not null	
	, [PatientId] int not null	default(0)		
	, [CarePlanId] int not null default(0)	
	, [IsCompliant] bit not null default 0		
	, [Timestamp] Datetime2 not null default(getdate())	 	
)
GO

-- Lets try out to create a new Clustered Columnstore Index:
--Create Clustered Columnstore Index 
--    CC_DashboardPatientCondition on [Dashboard].[PatientCarePlan];

--GO
