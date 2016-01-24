USE [FalconDB]
GO

/****** Object: Table [Dashboard].[PatientCondition] Script Date: 12/18/2015 5:27:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dashboard].[PatientCondition] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [OrgId]            VARCHAR (255) NOT NULL,
    [PatientId]        VARCHAR (255) NOT NULL,
    [ConditionId]      INT           NOT NULL,
    [IsCompliant]      BIT           NOT NULL,
    [UpdatedTimestamp] DATETIME2 (7) NOT NULL
);

Create Clustered Columnstore Index 
    CC_DashboardPatientCondition on [Dashboard].[PatientCondition];

