If OBJECT_ID('dbo.MPWRDIn') Is Not Null Drop Table dbo.MPWRDIn
Create Table dbo.MPWRDIn (col001 varchar(max))

If OBJECT_ID('dbo.MPWRD_HDR') Is Not Null Drop Table dbo.MPWRD_HDR
Create Table dbo.MPWRD_HDR (
	RecordType				VarChar(2)		-- H = Header
,	MCOContractNum			VarChar(5)		--
,	PaymentDate				Varchar(8)		-- CCYYMMDD
,	ReportDate				Varchar(8)		-- CCYYMMDD
,	Filler					Varchar(142)	--
,	DateImported			DateTime
,	[FileName]				VarChar(256)
)

If OBJECT_ID('dbo.MPWRD_DTL') Is Not Null Drop Table dbo.MPWRD_DTL
Create Table dbo.MPWRD_DTL (
	RecordType				VarChar(2)		-- D = Detail
,	MCOContractNum			VarChar(5)		-- 
,	PlanBenefitPackageId	Varchar(3)		-- 
,	PlanSegmentId			Varchar(3)		-- 
,	BeneficiaryId			Varchar(12)		-- Health Insurance Claim Number (HICN) or Member Benefciary Identifier (MBI)
,	Surname					Varchar(7)		-- 
,	FirstInitial			Varchar(1)		-- 
,	Sex						Varchar(1)		-- F or M
,	DateOfBirth				Varchar(8)		-- CCYYMMDD
,	PPO						Varchar(3)		-- Premium Payment Option in effect for this pay month
											-- SSA = Withholding by Social Security Administration
											-- RRB = Withholding by Rail Road Board
,	Filler1					Varchar(1)		--
,	PremiumPeriodStartDate	Varchar(8)		-- CCYYMMDD
,	PremiumPeriodEndDate	Varchar(8)		-- CCYYMMDD
,	NoMonthsInPremiumPeriod	Varchar(2)		-- Number of months in the premium period
,	PartCPremiumsCollected	Varchar(8)		-- Part C Premiums Collected for this Beneficiary, Plan, and premium period. 
											-- A negative amount indicates a refund by withholding agency to Beneficiary 
											-- of premiums paid in a prior premium period.
,	PartDPremiumsCollected	Varchar(8)		-- Part D Premiums Collected (excluding LEP) for this Beneficiary, Plan, and 
											-- premium period. A negative amount indicates a refund by withholding agency
											-- to Beneficiary of premiums paid in a prior premium period
,	PartDLEPCollected		Varchar(8)		-- Part D Late Enrollment Penalties Collected for this Beneficiary, Plan, and 
											-- premium period. A negative amount indicates a refund by withholding agency
											-- to Beneficiary of penalties paid in a prior premium period.
,	CleanupId				Varchar(10)		-- If collected premium is the result of a cleanup = XXXXXXXXXX
											-- All other records will = Blank.
,	Filler2					Varchar(67)		--
,	DateImported			DateTime
,	[FileName]				VarChar(256)
)

Create Index ix_MCOContractNum On dbo.MPWRD_DTL(MCOContractNum)
Create Index ix_PlanBenefitPackageId On dbo.MPWRD_DTL(PlanBenefitPackageId)
Create Index ix_PlanSegmentId On dbo.MPWRD_DTL(PlanSegmentId)
Create Index ix_BeneficiaryId On dbo.MPWRD_DTL(BeneficiaryId)
Create Index ix_FileName On dbo.MPWRD_DTL([FileName])

If OBJECT_ID('dbo.MPWRD_TRL') Is Not Null Drop Table dbo.MPWRD_TRL
Create Table dbo.MPWRD_TRL (
	RecordType				VarChar(2)		-- T1 = Trailer Record, withheld totals at segment level
											-- T2 = Trailer Record, withheld totals at Plan Benefit Package (PBP) level
											-- T3 = Trailer record, withheld totals at contract level
,	MCOContractNum			VarChar(5)		--
,	PlanBenefitPackageId	Varchar(3)		-- 
,	PlanSegmentId			Varchar(3)		-- 
,	TotalPartCPremiumsCollected	Varchar(14)		-- 
,	TotalPartDPremiumsCollected	Varchar(14)		-- 
,	TotalPartDLEPCollected	Varchar(14)		-- Late Enrollment Penalty
,	TotalPremiumsCollected	Varchar(14)		-- TotalPartCPremiumsCollected + TotalPartDPremiumsCollected + TotalPartDLEPCollected
,	Filler					Varchar(96)	--
,	DateImported			DateTime
,	[FileName]				VarChar(256)
)
