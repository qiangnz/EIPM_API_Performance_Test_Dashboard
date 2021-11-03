--Create Database
--CREATE DATABASE EIPMTestingResult
--Use Database
USE EIPMTestingResult

--Import a CSV to ResultTable and Remove all contants 
SELECT * FROM LoadTestResultTable
WHERE responseCode !='200' AND responseCode !='302'
ORDER BY GlobalTransactionId
--DELETE FROM LoadTestResultTable
--DROP TABLE LoadTestResultTablelk


---------------------------------------------------------------------------------------------
--1 Create TotNumTranView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW TotNumTranView
AS
SELECT MAX(GlobalTransactionId) AS TotNumTransaction
FROM LoadTestResultTable
GO

--SELECT * FROM TotNumTranView
--DROP VIEW TotNumTranView
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--2 Create TotNumTestDaysView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW TotNumTestDaysView
AS
SELECT MAX(Day) AS TotNumTestDays
FROM LoadTestResultTable
GO

--SELECT * FROM TotNumTestDaysView
--DROP VIEW TotNumTestDaysView
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--3 Create TotNumRequestView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW TotNumRequestView
AS
SELECT COUNT(TestTransactionID) AS NumRequests
FROM LoadTestResultTable
GO

--SELECT * FROM TotNumRequestView
--DROP VIEW TotNumRequestView
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--4 Create ResponseView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW ResponseView
AS
SELECT date,TestId,
    COUNT(CASE WHEN responseCode='200' OR responseCode='302' THEN 1 END) AS NumSuccessResponse,
	COUNT(CASE WHEN responseCode='400' THEN 1 END) AS Num400Error,
    COUNT(CASE WHEN responseCode='403' THEN 1 END) AS Num403Error,
	COUNT(CASE WHEN responseCode='502' THEN 1 END) AS Num502Error,
    COUNT(CASE WHEN responseCode='504' THEN 1 END) AS Num504Error,
	COUNT(CASE WHEN responseCode LIKE'%Non%' THEN 1 END) AS NumOthersError
FROM LoadTestResultTable
GROUP BY date,TestId
GO

--SELECT * FROM ResponseView
--DROP VIEW ResponseView
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--5 Create DaySuccessView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW DaySuccessView
AS
SELECT date,TestId,TimeCategory,
    COUNT(CASE WHEN success='True' THEN 1 END) AS NumSuccess,
	COUNT(CASE WHEN success='False' THEN 1 END) AS NumFalse
FROM LoadTestResultTable
WHERE label='Completing transaction'
GROUP BY date,TestId,TimeCategory,GlobalTransactionId
GO

--SELECT * FROM DaySuccessView
--DROP VIEW DaySuccessView
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--6 Create PerformanceView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW PerformanceView
AS
SELECT GlobalTransactionId,CONCAT(date,' ',time)AS DayTime,TimeCategory,TestId,responseCode,SUM(Latency) AS TotalLatency
FROM LoadTestResultTable
GROUP BY GlobalTransactionId,CONCAT(date,' ',time),TimeCategory,TestId,responseCode
GO

--SELECT * FROM PerformanceView
--DROP VIEW PerformanceView
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--7 Create DailyView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW DailyView
AS
SELECT GlobalTransactionId,date,TimeCategory,TestId,AVG(Latency) AS AvgLatency
FROM LoadTestResultTable
GROUP BY GlobalTransactionId,date,TimeCategory,TestId
GO

--SELECT * FROM DailyView
--DROP VIEW DailyView
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--8 Create ErrorView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW ErrorView
AS
SELECT GlobalTransactionId,CONCAT(date,' ',time)AS DayTime,date,TimeCategory,TestId,responseCode,AVG(Latency) AS AvgLatency
FROM LoadTestResultTable
GROUP BY GlobalTransactionId,CONCAT(date,' ',time),date,TimeCategory,TestId,responseCode
GO

--SELECT * FROM ErrorView
--DROP VIEW ErrorView
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--9 Create TestTypeView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW TestTypeView
AS
SELECT GlobalTransactionId,TestId,date
FROM LoadTestResultTable
GO

--SELECT * FROM TestTypeView
--DROP VIEW TestTypeView
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--10 Create AvgResponseTimeView
---------------------------------------------------------------------------------------------
USE EIPMTestingResult
GO 
CREATE VIEW AvgResponseTimeView
AS
SELECT AVG(Latency) AS AvgResponseTime
FROM LoadTestResultTable
GO

--SELECT * FROM AvgResponseTimeView
--DROP VIEW AvgResponseTimeView
---------------------------------------------------------------------------------------------