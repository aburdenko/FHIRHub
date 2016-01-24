WITH QualifyingConditions AS
(
SELECT 
PatientIdentifier.ArrayValue.ValueElement.Value as PatientFhirId,
ConditionCoding.ArrayValue.DisplayElement.Value as Condition,
1 AS Bool
FROM
Input input
OUTER APPLY GetArrayElements(input.Patient.Identifier) AS PatientIdentifier
OUTER APPLY GetArrayElements(input.Conditions) as Conditions
OUTER APPLY GetArrayElements(Conditions.ArrayValue.Code.Coding) as ConditionCoding
GROUP BY SlidingWindow(minute , 1 ), PatientIdentifier.ArrayValue.ValueElement.Value, ConditionCoding.ArrayValue.DisplayElement.Value
HAVING 
(ConditionCoding.ArrayValue.DisplayElement.Value = 'IRRITABLE BOWEL SYNDROME'
OR ConditionCoding.ArrayValue.DisplayElement.Value = 'DEPRESSION') 
AND Count(1) > 0
)
SELECT PatientIdentifier.ArrayValue.ValueElement.Value AS PatientFhirId, CASE WHEN SUM(Q.Bool) = 2 THEN 1 ELSE 0 END AS IsSuicidal
FROM 
Input input
OUTER APPLY GetArrayElements(input.Patient.Identifier) AS PatientIdentifier
LEFT OUTER JOIN QualifyingConditions Q
ON PatientIdentifier.ArrayValue.ValueElement.Value = Q.PatientFhirId
AND DATEDIFF(minute,input,Q) BETWEEN 0 AND 1
GROUP BY SlidingWindow(minute , 10), PatientIdentifier.ArrayValue.ValueElement.Value
