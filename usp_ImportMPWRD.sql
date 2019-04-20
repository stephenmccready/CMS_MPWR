Create procedure dbo.usp_ImportMPWRD @path As varChar(128), @filename As varChar(128)
As

Begin

Truncate Table dbo.MPWRDIn
Declare @BulkCmd As nvarChar(MAX)
Set		@BulkCmd = "BULK INSERT tbl_MPWRD_In FROM '"+@path+@filename+"' WITH (FIELDTERMINATOR = '\n')"
Exec	(@BulkCmd)

Declare @today As DateTime 
Set @today=getDate()

---Header
Insert	Into dbo.MPWRD_HDR
Select	  Cast(SubString(MI.Col001,1,2) As VarChar(2)) As RecordType
		, Cast(SubString(MI.Col001,3,5) As VarChar(5)) As MCOContractNum
		, Cast(SubString(MI.Col001,8,8) As VarChar(8)) As PaymentDate
		, Cast(SubString(MI.Col001,16,8) As VarChar(8)) As ReportDate
		, Cast(SubString(MI.Col001,24,142) As VarChar(142)) As Filler1
		, @today As DateImported
		, @filename As [FileName]
From	MPWRDIn As MI
Left	Outer Join dbo.MPWRD_HDR As MH
		On MH.MCOContractNum = SubString(MI.Col001,3,5)
		And MH.PaymentDate = SubString(MI.Col001,8,8)
		And MH.ReportDate = SubString(MI.Col001,16,8)
		And MH.[FileName] = @filename
Where	SubString(MI.Col001,1,1) = 'H'
And		MH.RecordType Is Null

-- Detail Record
Insert	Into dbo.MPWRD_DTL
Select	  Cast(SubString(MI.Col001,1,2) As VarChar(2)) As RecordType
		, Cast(SubString(MI.Col001,3,5) As VarChar(5)) As MCOContractNum
		, Cast(SubString(MI.Col001,8,3) As VarChar(3)) As PlanBenefitPackageId
		, Cast(SubString(MI.Col001,11,3) As VarChar(3)) As PlanSegmentId
		, Cast(SubString(MI.Col001,14,12) As VarChar(12)) As BeneficiaryId
		, Cast(SubString(MI.Col001,26,7) As VarChar(7)) As Surname
		, Cast(SubString(MI.Col001,33,1) As VarChar(1)) As FirstInitial
		, Cast(SubString(MI.Col001,34,1) As VarChar(1)) As Sex
		, Cast(SubString(MI.Col001,35,8) As VarChar(8)) As DateOfBirth
		, Cast(SubString(MI.Col001,43,3) As VarChar(3)) As PPO
		, Cast(SubString(MI.Col001,46,1) As VarChar(1)) As Filler1
		, Cast(SubString(MI.Col001,47,8) As VarChar(8)) As PremiumPeriodStartDate
		, Cast(SubString(MI.Col001,55,8) As VarChar(8)) As PremiumPeriodEndDate
		, Cast(SubString(MI.Col001,63,2) As VarChar(2)) As NoMonthsInPremiumPeriod
		, Cast(SubString(MI.Col001,65,8) As VarChar(8)) As PartCPremiumsCollected
		, Cast(SubString(MI.Col001,73,8) As VarChar(8)) As PartDPremiumsCollected
		, Cast(SubString(MI.Col001,81,8) As VarChar(8)) As PartDLEPCollected
		, Cast(SubString(MI.Col001,89,10) As VarChar(10)) As CleanupId
		, Cast(SubString(MI.Col001,99,67) As VarChar(67)) As Filler2
		, @today As DateImported
		, @filename As [FileName]
From	dbo.MPWRDIn As MI
Left	Outer Join dbo.MPWRD_DTL As MP
		On MP.BeneficiaryID = SubString(MI.Col001,14,12)
		And MP.MCOContractNum = SubString(MI.Col001,3,5)
		And MP.PlanBenefitPackageId = SubString(MI.Col001,8,3)
		And MP.PlanSegmentId = SubString(MI.Col001,11,3)
		And MP.[FileName] = @filename
Where	SubString(MI.Col001,1,1) = 'D'
And		MP.BeneficiaryID Is Null

---Trailer
Insert	Into dbo.MPWRD_TRL
Select	  Cast(SubString(MI.Col001,1,2) As VarChar(2)) As RecordType
		, Cast(SubString(MI.Col001,3,5) As VarChar(5)) As MCOContractNum
		, Cast(SubString(MI.Col001,8,3) As VarChar(3)) As PlanBenefitPackageId 
		, Cast(SubString(MI.Col001,11,3) As VarChar(3)) As PlanSegmentId
		, Cast(SubString(MI.Col001,14,14) As VarChar(14)) As TotalPartCPremiumsCollected 
		, Cast(SubString(MI.Col001,28,14) As VarChar(14)) As TotalPartDPremiumsCollected 
		, Cast(SubString(MI.Col001,42,14) As VarChar(14)) As TotalPartDLEPCollected
		, Cast(SubString(MI.Col001,56,14) As VarChar(14)) As TotalPremiumsCollected
		, Cast(SubString(MI.Col001,70,96) As VarChar(96)) As Filler
		, @today As DateImported
		, @filename As [FileName]
From	MPWRDIn As MI
Left	Outer Join dbo.MPWRD_TRL As MT
		On MT.RecordType=SubString(MI.Col001,1,2)
		And MT.[FileName]=@filename
Where	SubString(MI.Col001,1,1) = 'T'
And		MT.RecordType Is Null

End
