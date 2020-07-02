USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_StateMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_StateMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Statename] [varchar](150) NOT NULL,
	[Shortname] [varchar](10) NOT NULL,
	[State_gov_code] [varchar](50) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_DistrictMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_DistrictMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StateID] [int] NOT NULL,
	[Districtname] [varchar](150) NOT NULL,
	[District_gov_code] [varchar](50) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-----------------------------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_BlockMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_BlockMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[Blockname] [varchar](150) NOT NULL,
	[Block_gov_code] [varchar](50) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


-----------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_FacilityTypeMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_FacilityTypeMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Facility_typename] [varchar](100) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HNINMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_HNINMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Facilitytype_ID] [int] NOT NULL,
	[Facility_name] [varchar](100) NOT NULL,
	[NIN2HFI] [varchar](100) NOT NULL,
	[StateID] [int] NOT NULL,
	[DistrictID] [int] NOT NULL,
	[Taluka] [varchar](100) NULL,
	[BlockID] [int] NOT NULL,
	[Address] [varchar](500) NULL,
	[Pincode] [varchar](100) NULL,
	[Landline] [varchar](100) NULL,
	[Incharge_name] [varchar](100) NULL,
	[Incharge_contactno] [varchar](100) NULL,
	[Incharge_EmailId] [varchar](150) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
----------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CHCMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CHCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BlockID] [int] NOT NULL,
	[DistrictID] [int] NOT NULL,
	[CHC_gov_code] [varchar](100) NOT NULL,
	[CHCname] [varchar](100) NOT NULL,
	[Istestingfacility] [bit] NULL,
	[HNIN_ID]  [varchar](200) NULL,
	[Pincode] [varchar](150) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
	[AssociatedCHCID] [int] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END


-----------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PHCMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_PHCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CHCID] [int] NOT NULL,
	[PHC_gov_code] [varchar](100) NOT NULL,
	[PHCname] [varchar](100) NOT NULL,
	[HNIN_ID]  [varchar](200) NULL,
	[Pincode] [varchar](150) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SCMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_SCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CHCID] [int] NOT NULL,
	[PHCID] [int] NOT NULL,
	[SC_gov_code] [varchar](100) NOT NULL,
	[SCname] [varchar](100) NOT NULL,
	[Pincode] [varchar](100) NULL,
	[HNIN_ID] [varchar](200) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
---------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_RIMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_RIMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TestingCHCID] [int] NOT NULL,
	[PHCID] [int] NOT NULL,
	[SCID] [int] NOT NULL,
	[RI_gov_code] [varchar](100) NOT NULL,
	[RIsite] [varchar](100) NOT NULL,
	[Pincode] [varchar](100) NULL,
	[ILRID] [int] NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

----------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_UserRoleMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_UserRoleMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UsertypeID] [int] NOT NULL,
	[Userrolename] [varchar](150) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


----------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_UserTypeMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_UserTypeMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Usertype] [varchar](150) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-----------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_Gov_IDTypeMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_Gov_IDTypeMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GovIDType] [varchar](100) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SubjectTypeMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_SubjectTypeMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectType] [varchar](100) NOT NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


-------------------------------------------------------------------------------------------------------------------------
USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_UserMaster' AND [type] = 'U')
BEGIN


CREATE TABLE [dbo].[Tbl_UserMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserType_ID] [int] NOT NULL,
	[UserRole_ID] [int] NOT NULL,
	[User_gov_code] [varchar](150) NOT NULL,
	[Username] [varchar](150) NOT NULL,
	[Password] [varchar](150) NOT NULL,
	[StateID] [int] NOT NULL,
	[DistrictID] [int] NOT NULL,
	[BlockID] [int] NULL,
	[CHCID] [int]  NULL,
	[PHCID] [int]  NULL,
	[SCID] [int]  NULL,
	[RIID] [varchar](50)  NULL,
	[FirstName] [varchar](150) NOT NULL,
	[MiddleName] [varchar](150) NULL,
	[LastName] [varchar](150) NULL,
	[ContactNo1] [varchar](150) NULL,
	[ContactNo2] [varchar](150)  NULL,
	[Email] [Varchar](150) NULL,
	[GovIDType_ID] [int] NULL,
	[GovIDDetails] [varchar] (150) NULL,
	[Address] [varchar](MAX) NULL,
	[Pincode] [varchar](150) NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[DigitalSignature] [image] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ReligionMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ReligionMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Religionname] [varchar](150) NOT NULL,	
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


--------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CasteMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CasteMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Castename] [varchar](150) NOT NULL,	
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


----------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CommunityMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_CommunityMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CasteID] [int] NOT NULL,
	[Communityname] [varchar](150) NOT NULL,	
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
------------------------------------------------------------------------------------------



USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_TestTypeMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_TestTypeMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,	
	[TestType] [varchar](150) NOT NULL,	
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


---------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ThresholdValueMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_ThresholdValueMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,	
	[TestTypeID] [int] NOT NULL,
	[TestName] [varchar](150) NOT NULL,
	[ThresholdValue] [decimal](18,2) NOT NULL,	
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END


---------------------------------------------------------------------------------------------------------------



USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ClinicalDiagnosisMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ClinicalDiagnosisMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DiagnosisName] [varchar](250) NOT NULL,	
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SubjectPrimaryDetail' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_SubjectPrimaryDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectTypeID] [int] NOT NULL,
	[ChildSubjectTypeID][int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[CHCID] [int] NOT NULL,
	[PHCID] [int] NOT NULL,
	[SCID] [int] NOT NULL,
	[RIID] [int] NOT NULL,
	[SubjectTitle] [varchar] (50) NULL,
	[FirstName] [varchar] (150)NOT NULL,
	[MiddleName] [varchar] (150) NULL,
	[LastName] [varchar] (150) NULL,
	[DOB] [datetime] NULL,
	[Age] [int] NULL,
	[Gender] [varchar] (20) NULL,
	[MaritalStatus] [bit] NULL,
	[MobileNo] [varchar] (150) NULL,
	[EmailId] [varchar](200) NULL,
	[GovIdType_ID] [int] NULL,
	[GovIdDetail] [varchar] (150) NULL,
	[SpouseSubjectID] [varchar](200)  NULL,
	[Spouse_FirstName] [varchar] (150) NULL,
	[Spouse_MiddleName] [varchar] (150) NULL,
	[Spouse_LastName] [varchar] (150) NULL,
	[Spouse_ContactNo] [varchar] (150) NULL,
	[Spouse_GovIdType_ID] [int] NULL,
	[Spouse_GovIdDetail] [varchar] (150) NULL,
	[AssignANM_ID] [int] NULL,
	[DateofRegister] [datetime] NULL,
	[RegisteredFrom] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NULL
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-----------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SubjectAddressDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_SubjectAddressDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[Religion_Id] [int] NULL,
	[Caste_Id] [int] NULL,
	[Community_Id] [int] NULL,
	[Address1] [varchar] (150) NULL,
	[Address2] [varchar] (150) NULL,
	[Address3] [varchar] (150) NULL,
	[Pincode] [varchar] (150) NULL,
	[StateName] [varchar] (150) NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

------------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SubjectPregnancyDetail' AND [type] = 'U')
BEGIN


CREATE TABLE [dbo].[Tbl_SubjectPregnancyDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[RCHID] [varchar] (150) NULL,
	[ECNumber] [varchar] (150) NULL,
	[LMP_Date] [datetime] NULL,
	[Gestational_period] [decimal](18,2) NULL,
	[G] [int] NULL,
	[P] [int] NULL,
	[L] [int] NULL,
	[A] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

---------------------------------------------------------------------------------------------



USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SubjectParentDetail' AND [type] = 'U')
BEGIN


CREATE TABLE [dbo].[Tbl_SubjectParentDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,	
	[Mother_FirstName] [varchar] (150) NULL,
	[Mother_MiddleName] [varchar] (150) NULL,
	[Mother_LastName] [varchar] (150) NULL,	
	[Mother_GovIdType_ID] [int] NULL,
	[Mother_GovIdDetail] [varchar] (150) NULL,	
	[Mother_ContactNo] [varchar] (150) NULL,
	[Father_FirstName] [varchar] (150) NULL,
	[Father_MiddleName] [varchar] (150) NULL,
	[Father_LastName] [varchar] (150) NULL,	
	[Father_GovIdType_ID] [int] NULL,
	[Father_GovIdDetail] [varchar] (150) NULL,
	[Father_ContactNo] [varchar] (150) NULL,
	[Gaurdian_FirstName] [varchar] (150) NULL,
	[Gaurdian_MiddleName] [varchar] (150) NULL,
	[Gaurdian_LastName] [varchar] (150) NULL,
	[Guardian_GovIdType_ID] [int] NULL,
	[Guardian_GovIdDetail] [varchar] (150) NULL,	
	[Gaurdian_ContactNo] [varchar] (150) NULL,
	[RBSKId] [varchar] (150) NULL,
	[SchoolName] [varchar] (150) NULL,
	[SchoolAddress1] [varchar] (250) NULL,
	[SchoolAddress2] [varchar] (250) NULL,
	[SchoolAddress3] [varchar] (250) NULL,
	[SchoolPincode] [varchar] (250) NULL,
	[SchoolCity] [varchar] (200) NULL,
	[SchoolState] [varchar] (150) NULL,
	[Standard] [varchar] (10) NULL,
	[Section] [varchar](5) NULL,
	[RollNo] [varchar] (50) NULL,	
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
	
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
-----------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SampleCollection' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_SampleCollection](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar](200) NOT NULL,
	[SampleCollectionDate] [date] NOT NULL,
	[SampleCollectionTime] [time](2) NOT NULL,
	[BarcodeDamaged] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[SampleTimeoutExpiry] [bit] NULL,
	[IsAccept] [bit] NULL,
	[Reason_Id] [int] NOT NULL,
	[CollectionFrom] [int] NULL,
	[CollectedBy] [int] NULL,
	[NotifiedStatus] [bit] NULL,
	[NotifiedOn][datetime] NULL,
	[IsRecollected] [char](1) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[RejectAt] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
-------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ANMShipment' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ANMShipment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[SampleCollectionID] [int] NOT NULL,
	[ShipmentFrom] [varchar](20) NOT NULL,	
	[ShipmentID] [varchar](200) NOT NULL,
	[ANM_ID] [int] NULL,
	[TestingCHCID][int] NULL,
	[RIID] [int] NULL,
	[ILR_ID] [int] NULL,	
	[AVDID] [int] NULL,
	[ContactNo] [varchar] (150) NULL,
	[DateofShipment][date] NULL,
	[TimeofShipment] [time](2)NULL,
	[ReceivedDate] [date] NULL,
	[ProcessingDateTime] [datetime] NULL,
	[ILR_InTime] [time](2) NULL,
	[ILR_OutTime] [time](2) NULL,
	[SampleStatus] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ANMCHCShipment' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ANMCHCShipment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[SampleCollectionID] [int] NOT NULL,
	[ShipmentFrom] [int] NOT NULL,	
	[ShipmentID] [varchar](200) NOT NULL,
	[ANM_ID] [int] NULL,
	[TestingCHCID][int] NULL,
	[RIID] [int] NULL,
	[ILR_ID] [int] NULL,	
	[AVDID] [int] NULL,
	[DeliveryExecutiveName] [varchar] (250) NULL,
	[ContactNo] [varchar] (150) NULL,
	[DateofShipment][date] NULL,
	[TimeofShipment] [time](2)NULL,
	[ReceivedDate] [date] NULL,
	[ProcessingDateTime] [datetime] NULL,
	[ILR_InTime] [time](2) NULL,
	[ILR_OutTime] [time](2) NULL,
	[SampleStatus] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO


IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ANMCHCShipments' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ANMCHCShipments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentFrom] [int] NOT NULL,	
	[GenratedShipmentID] [varchar](200) NOT NULL,
	[ANM_ID] [int] NULL,
	[RIID] [int] NULL,
	[ILR_ID] [int] NULL,
	[AVDID] [int] NULL,
	[AVDContactNo] [varchar] (150) NULL,
	[CHCUserId] [int] NULL,
	[CollectionCHCID] [int] NULL,
	[LogisticsProviderId] [int] NULL,
	[DeliveryExecutiveName] [varchar] (250) NULL,
	[ExecutiveContactNo] [varchar] (150) NULL,
	[TestingCHCID][int] NULL,	
	[DateofShipment][date] NULL,
	[TimeofShipment] [time](2)NULL,
	[ReceivedDate] [date] NULL,
	[ProcessingDateTime] [datetime] NULL,
	[ILR_InTime] [time](2) NULL,
	[ILR_OutTime] [time](2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ANMCHCShipmentsDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ANMCHCShipmentsDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](250) NOT NULL,
	[BarcodeNo] [varchar] (250) NULL,
	

PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------------------------




USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ConstantValues' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ConstantValues](
	[ID] [int] IDENTITY(1,1) NOT NULL,	
	[CommonName] [varchar] (200) NOT NULL,
	[comments][varchar] (150) NULL,	
	[CreatedOn] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ILRMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ILRMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,	
	[ILRCode] [varchar] (200) NOT NULL,	
	[ILRPoint] [varchar] (200) NOT NULL,	
	[CreatedBy][int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn][datetime] NULL,
	[Comments] [varchar] (max) NULL,
	[IsActive] [bit] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------------------------
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_LogisticsProviderMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_LogisticsProviderMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProviderName] [varchar] (200) NOT NULL,	
	[CreatedBy][int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn][datetime] NULL,
	[Comments] [varchar] (max) NULL,
	[IsActive] [bit] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
------------------------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_AVDMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_AVDMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RIID] [varchar](max) NOT NULL,	
	[AVDName] [varchar] (200) NOT NULL,	
	[ContactNo] [varchar] (200)  NULL,	
	[CreatedBy][int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn][datetime] NULL,
	[Comments] [varchar] (max) NULL,
	[IsActive] [bit] NULL	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

----------------------------------------------------------------------------------------
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HPLCMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_HPLCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[HPLCCode] [varchar](100) NOT NULL,
	[HPLCName] [varchar](100) NOT NULL,
	[Pincode] [varchar](150) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

-----------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularLabMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularLabMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[MLabCode] [varchar](100) NOT NULL,
	[MLabName] [varchar](100) NOT NULL,
	[Pincode] [varchar](150) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Comments] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CBCandSSTestResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_CBCandSSTestResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[SampleCollectionID] [int] NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[MVC] [decimal](18,2) NULL,
	[RDW] [decimal](18,2) NULL,
	[CBCResult] [varchar] (max)  NULL,
	[CBCStatus] [char] (1) NULL,
	[CBCTestComplete] [bit] NULL,
	[CBC_UpdatedBy] [int] NULL,
	[CBC_UpdatedOn] [datetime] NULL,
	[SSTStatus] [char] (1) NULL,
	[SSTComplete] [bit] NULL,
	[SST_UpdatedBy] [int] NULL,
	[SST_UpdatedOn] [datetime] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-------------------------------------------------------------------------------------------------------------
