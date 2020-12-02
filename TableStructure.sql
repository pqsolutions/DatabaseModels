
USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ANMDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ANMDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ANMUserId] [int]  NULL,
	[ANMGovCode] [varchar] (200) NULL,
	[FirstName] [varchar](200)  NULL,
	[MiddleName] [varchar] (200) NULL,
	[LastName] [varchar](200)  NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CHCID] [int] NULL,
	[RIID] [varchar] (max) NULL,
	[IsActive] [bit] NULL,
	[ReasonforInactive] [varchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


-------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_ANMLogin' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_ANMLogin](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ANMId] [int] NOT NULL,
	[UserName] [varchar](200) NOT NULL,
	[DeviceId] [varchar](max) NULL,
	[LoginStatus][bit] NULL,
	[LastLoginFrom] [varchar](50) NULL,
	[LastLoginDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END


-------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_LoginDetails' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_LoginDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[UserName] [varchar](200) NOT NULL,
	[DeviceId] [varchar](max) NULL,
	[LoginTime] [datetime] NULL,
	[LoginFrom] [varchar] (100) NULL,
	[LogoutResetTime] [datetime]NULL,
	[IsLogout] [bit] NULL,
	[IsReset] [bit] NULL
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
	[TestingCHCID] [int] NULL,
	[CentralLabId][int] NULL
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
	[SCAddress] [varchar](max) NULL,
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
	[CHCID] [int] NOT NULL,
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
	[ANMID] [int] NULL
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
	[Descriptions] [varchar](max) NULL,
	[AccessModules] [varchar](max) NULL,
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
	[CentralLabId] [int] NULL,
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
	[DigitalSignature] [image] NULL,
	[MolecularLabId] [int] NULL,
	[OTP] [varchar](max) NULL,
	[OTPCreatedOn] [datetime] NULL,
	[OTPExpiredOn] [datetime] NULL
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
	[Communityname] [varchar](max) NULL,	
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
	[IsActive] [bit] NULL,
	[UpdatedToANM] [bit] NULL,
	[SpouseWillingness] [bit] NULL,
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
	[UpdatedToANM] [bit] NULL,
	[FollowUpBy] [int] NULL,
	[FollowUpStatus] [bit] NULL,
	[FollowUpOn] [datetime] NULL,
	[IsDamagedMolecular] [bit] NULL,
	[IsAcceptMolecular] [bit] NULL
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
	[AlternateAVD] [varchar] (250) NULL,
	[AlternateAVDContactNo] [varchar] (250) NULL,
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
	[ILRInDateTime] [datetime] NULL,
	[ILROutDateTime] [datetime] NULL,
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
	[IsAccept] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[SampleTimeoutExpiry] [bit] NULL,
	[BarcodeDamaged] [bit] NULL

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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CentralLabMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CentralLabMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[CentralLabCode] [varchar](100) NOT NULL,
	[CentralLabName] [varchar](100) NOT NULL,
	[Pincode] [varchar](150) NULL,
	[MolecularLabId] [int] NULL,
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CBCTestResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_CBCTestResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[TestingCHCId] [int] NULL,
	[MCV] [decimal](10,1) NULL,
	[RDW] [decimal](10,1) NULL,
	[CBCResult] [varchar] (max)  NULL,
	[IsPositive] [bit] NULL,
	[CBCTestComplete] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedToANM] [bit] NULL,
	[FileName] [varchar] (max) NULL,
	[TestCompleteOn] [datetime] NULL,
	[RBC] [decimal](10,1) NULL,
	[CBCTestedDetailId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_SSTestResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_SSTestResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[TestingCHCId] [int] NULL,
	[IsPositive] [bit] NULL,
	[SSTComplete] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedToANM] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CHCShipments' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CHCShipments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GenratedShipmentID] [varchar](200) NOT NULL,
	[CHCUserId] [int] NULL,
	[LabTechnicianName] [Varchar](250) NULL,
	[TestingCHCID][int] NULL,	
	[ReceivingCentralLabId] [int] NULL,
	[LogisticsProviderId] [int] NULL,
	[DeliveryExecutiveName] [varchar] (250) NULL,
	[ExecutiveContactNo] [varchar] (150) NULL,
	[DateofShipment][date] NULL,
	[TimeofShipment] [time](2)NULL,
	[ReceivedDate] [date] NULL,
	[ProcessingDateTime] [datetime] NULL,
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CHCShipmentsDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CHCShipmentsDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](250) NOT NULL,
	[BarcodeNo] [varchar] (250) NULL,
	[IsAccept] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[SampleTimeoutExpiry] [bit] NULL,
	[BarcodeDamaged] [bit] NULL
	
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HPLCTestResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_HPLCTestResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[CentralLabId] [int] NOT NULL,
	[HbF] [decimal] (10,2) NULL,
	[HbA0] [decimal] (10,2) NULL,
	[HbA2] [decimal] (10,2) NULL,
	[HbS] [decimal] (10,2) NULL,
	[HbC] [decimal] (10,2) NULL,
	[HbD] [decimal] (10,2) NULL,
	[IsNormal] [bit] NULL,
	[HPLCTestComplete] [bit] NULL,
	[HPLCTestCompletedOn] [datetime] NULL,
	[HPLCResult] [varchar] (max)  NULL,
	[IsPositive] [bit] NULL,
	[ResultUpdatedPathologistId] [int] NULL,
	[HPLCResultUpdatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedToANM] [bit] NULL,
	[FileName] [varchar] (max) NULL,
	[InjectionNo] [varchar](max)  NULL,
	[LabDiagnosis] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-------------------------------------------------------------------------------------------------------------



USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HPLCResultMaster' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_HPLCResultMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HPLCResultName] [varchar](250) NOT NULL, -- Normal, Thalassemia etc
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-------------------------------------------------------------------------------------------------------------
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HPLCDiagnosisResultCaseSheet' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_HPLCDiagnosisResultCaseSheet](
[ID] [int] IDENTITY(1,1) NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[HPLCDiagnosisResultId] [int] NULL,
	[DiagnosisSummary] [varchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HPLCDiagnosisResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_HPLCDiagnosisResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[HPLCTestResultId] [int] NULL,
	[ClinicalDiagnosisId] [varchar](max) NULL,
	[HPLCResultMasterId] [varchar] (200) NULL, -- multicheck more than one value
	[OthersResult] [varchar](max)NULL, 
	[IsConsultSeniorPathologist] [bit] NULL,
	[SeniorPathologistName] [varchar](250) NULL,
	[SeniorPathologistRemarks] [varchar](max) NULL,
	[IsNormal] [bit] NULL,
	[CentralLabId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsDiagnosisComplete] [bit] NULL,
	[DiagnosisCompletedThrough] [varchar] (max) NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON  
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CentralLabShipments' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CentralLabShipments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GenratedShipmentID] [varchar](200) NOT NULL,
	[CentralLabUserId] [int] NULL,
	[LabTechnicianName] [Varchar](250) NULL,
	[CentralLabLocation] [varchar](250) NULL,
	[CentralLabId] [int] NULL,
	[ReceivingMolecularLabId] [int] NULL,
	[LogisticsProviderName] [varchar](250) NULL,
	[DeliveryExecutiveName] [varchar] (250) NULL,
	[ExecutiveContactNo] [varchar] (150) NULL,
	[DateofShipment][date] NULL,
	[TimeofShipment] [time](2)NULL,
	[ReceivedDate] [datetime] NULL,
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CentralLabShipmentsDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CentralLabShipmentsDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](250) NOT NULL,
	[BarcodeNo] [varchar] (250) NULL,
	[IsAccept] [bit] NULL,
	[SampleDamaged] [bit] NULL,
	[SampleTimeoutExpiry] [bit] NULL,
	[BarcodeDamaged] [bit] NULL
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

---------------------------------------------------------------------------------------------------------------------



USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularTestResult' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_MolecularTestResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[ClinicalDiagnosisId] [int] NULL,
	[Result] [int] NULL, -- Normal, DNA Test Positive
	[IsDamaged] [bit] NULL,
	[IsProcessed] [bit] NULL,
	[ReasonForClose] [varchar] (max) NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[Remarks] [varchar](max) NULL,
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularResultMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularResultMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResultName] [varchar](250) NULL,
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PositiveResultSubjectsDetail' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PositiveResultSubjectsDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[BarcodeNo] [varchar] (200) NOT NULL,
	[CBCStatus] [char] (1) NULL, -- 'P' OR 'N'
	[CBCResult] [varchar] (max)  NULL,
	[CBCUpdatedOn] [datetime] NULL,
	[SSTStatus] [char] (1) NULL, -- 'P' OR 'N'
	[SSTUpdatedOn] [datetime] NULL,
	[HPLCTestResult] [varchar] (max) NULL,
	[HPLCStatus] [char] (1) NULL, -- 'P' OR 'N'
	[HPLCUpdatedOn] [datetime] NULL,
	[MolecularResult] [varchar](max) NULL,
	[MolecularUpdatedOn] [datetime] NULL,
	[HPLCNotifiedStatus] [bit] NULL,
	[HPLCNotifiedOn] [datetime] NULL,
	[HPLCNotifiedBy][int] NULL,
	[IsActive] [bit] NULL,
	[UpdatedToANM] [bit] NULL,
	[FollowUpBy] [int] NULL,
	[FollowUpStatus] [bit] NULL,
	[FollowUpOn] [datetime] NULL
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PrePNDTScheduling' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PrePNDTScheduling](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[CounsellorId] [int] NULL,
	[CounsellingDateTime] [datetime] NULL,
	[IsCounselled] [bit] NULL,
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


--------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PrePNDTCounselling' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PrePNDTCounselling](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AssignedObstetricianId] [int] NULL,
	[PrePNDTSchedulingId] [int] NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[CounsellorId] [int] NULL,
	[CounsellingRemarks] [varchar] (max) NULL,
	[IsPNDTAgreeYes] [bit] NULL,
	[IsPNDTAgreeNo] [bit] NULL,
	[IsPNDTAgreePending] [bit] NULL,
	[SchedulePNDTDate] [date] NULL,
	[SchedulePNDTTime] [time](2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsNotified] [bit] NULL,
	[NotifiedOn] [datetime] NULL,
	[NotifiedBy] [int] NULL,
	[FileName] [varchar](max) NULL,
	[FileLocation] [varchar](max) NULL,
	[FileData] [varbinary] (max) NULL,
	[IsActive] [bit] NULL,
	[ReasonForClose] [varchar] (max) NULL,
	[UpdatedToANM] [bit] NULL,
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PrePNDTReferal' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PrePNDTReferal](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[PrePNDTCounsellingDate] [datetime] NULL,
	[PNDTScheduleDateTime] [datetime] NULL,
	[IsPNDTAccept] [bit] NULL,
	[IsPNDTCompleted] [bit] NULL,
	[ReasonForClose] [varchar](max) NULL,
	[IsNotified] [bit] NULL,
	[NotifiedOn] [datetime] NULL,
	[NotifiedByANM] [int] NULL,
	[FollowUpStatus] [bit] NULL,
	[FollowUpOn] [datetime] NULL,
	[FollowUpByDC] [int] NULL,
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


--------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PNDTest' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PNDTest](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PrePNDTCounsellingId] [int] NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[PNDTDateTime] [datetime] NULL,
	[CounsellorId] [int] NULL,
	[ObstetricianId] [int] NULL,
	[ClinicalHistory] [varchar](max) NULL,
	[Examination] [varchar](max) NULL,
	[ProcedureofTestingId] [int] NULL,
	[OthersProcedureofTesting] [varchar](max) NULL,
	[PNDTDiagnosisId] [int] NULL,
	[PNDTResultId] [int] NULL,
	[PNDTComplecationsId] [varchar](100) NULL,
	[OthersComplecations] [varchar] (max) NULL,
	[IsCompletePNDT] [bit] NULL,
	[MotherVoided] [bit] NULL,
	[MotherVitalStable] [bit] NULL,
	[FoetalHeartRateDocumentScan] [bit] NULL,
	[PlanForPregnencyContinue] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedToANM] [bit] NULL,
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PostPNDTScheduling' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PostPNDTScheduling](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[CounsellorId] [int] NULL,
	[CounsellingDateTime] [datetime] NULL,
	[IsCounselled] [bit] NULL,
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


--------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO  

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PostPNDTCounselling' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_PostPNDTCounselling](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AssignedObstetricianId] [int] NULL,
	[PostPNDTSchedulingId] [int] NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[CounsellorId] [int] NULL,
	[CounsellingRemarks] [varchar] (max) NULL,
	[IsMTPTestdAgreedYes] [bit] NULL,
	[IsMTPTestdAgreedNo] [bit] NULL,
	[IsMTPTestdAgreedPending] [bit] NULL,
	[ScheduleMTPDate] [date] NULL,
	[ScheduleMTPTime] [time](2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsNotified] [bit] NULL,
	[NotifiedOn] [datetime] NULL,
	[NotifiedBy] [int] NULL,
	[FileName] [varchar](max) NULL,
	[FileLocation] [varchar](max) NULL,
	[FileData] [varbinary] (max) NULL,
	[IsFoetalDisease] [bit] NULL,
	[IsActive] [bit] NULL,
	[ReasonForClose] [varchar] (max) NULL,
	[UpdatedToANM] [bit] NULL,
	
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MTPReferal' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_MTPReferal](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[PostPNDTCounsellingDate] [datetime] NULL,
	[MTPScheduleDateTime] [datetime] NULL,
	[IsNotified] [bit] NULL,
	[NotifiedOn] [datetime] NULL,
	[NotifiedByANM] [int] NULL,
	[FollowUpStatus] [bit] NULL,
	[FollowUpOn] [datetime] NULL,
	[FollowUpByDC] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsMTPAccept] [bit] NULL,
	[IsMTPCompleted] [bit] NULL,
	[ReasonForClose] [varchar](max) NULL,
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
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MTPTest' AND [type] = 'U')
BEGIN
CREATE TABLE [dbo].[Tbl_MTPTest](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PostPNDTCounsellingId] [int] NULL,
	[ANWSubjectId] [varchar](250)NULL,
	[SpouseSubjectId] [varchar](250) NULL,
	[MTPDateTime] [datetime] NULL,
	[CounsellorId] [int] NULL,
	[ObstetricianId] [int] NULL,
	[ClinicalHistory] [varchar](max) NULL,
	[Examination] [varchar](max) NULL,
	[ProcedureofTesting] [varchar](max) NULL,
	[MTPComplecationsId] [varchar](100) NULL,
	[DischargeConditionId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[FirstFollowupStatusId] [int] NULL,
	[FirstStatusUpdatedOn] [datetime] NULL,
	[IsFirstFollowupCompleted] [bit] NULL,
	[SecondFollowupStatusId] [int] NULL,
	[SecondStatusUpdatedOn] [datetime] NULL,
	[IsSecondFollowupCompleted] [bit] NULL,
	[ThirdFollowupStatusId] [int] NULL,
	[ThirdStatusUpdatedOn] [datetime] NULL,
	[IsThirdFollowupCompleted] [bit] NULL,
	[UpdatedToANM] [bit] NULL,
	[IsActive] [bit] NULL,
	[ReasonForClose] [varchar](max) NULL,
	[FollowUpDCStatus] [bit] NULL,
	[FollowUpDCOn] [datetime] NULL,
	[FollowUpByDC] [int] NULL,
	[FirstFollowupStatusDetail] [varchar](500) NULL,
	[SecondFollowupStatusDetail] [varchar](500) NULL,
	[ThirdFollowupStatusDetail] [varchar](500) NULL
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PNDTDiagnosisMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_PNDTDiagnosisMaster](
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PNDTResultMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_PNDTResultMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResultName] [varchar](250) NOT NULL,
	[IsPositive] [bit] NULL,	
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

----------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PNDTProcedureOfTestingMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_PNDTProcedureOfTestingMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcedureName] [varchar](250) NOT NULL,
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PNDTComplicationsMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_PNDTComplicationsMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ComplecationsName] [varchar](250) NOT NULL,	
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MTPComplicationsMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MTPComplicationsMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ComplecationsName] [varchar](250) NOT NULL,	
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_DischargeConditionMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_DischargeConditionMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DischargeConditionName] [varchar](250) NOT NULL,	
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_UserDistrictMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_UserDistrictMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[DistrictId] [int] NULL,
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MTPFollowUpMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MTPFollowUpMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](250) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CHCSampleStatusMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CHCSampleStatusMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](250) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CentralLabSampleStatusMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CentralLabSampleStatusMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](250) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MolecularSampleStatusMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MolecularSampleStatusMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](250) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_PathologistSampleStatusMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_PathologistSampleStatusMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](250) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_CBCTestedDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_CBCTestedDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Barcode] [varchar](200) NOT NULL,
	[FileName] [varchar](max) NOT NULL,
	[MCV] [decimal](10,1) NOT NULL,
	[RDW-SD] [decimal](10,1) NOT NULL,
	[TestedDateTime][datetime] NOT NULL,
	[ProcessStatus] [bit] NULL,
	[ConfirmationStatus] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](200) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Reason][varchar](max) NULL,
	[RDW] [decimal](10,1)  NULL,
	[RBC] [decimal](10,1)  NULL,
	[MachineId] [varchar](max) NULL,
	[MPV] [decimal](10,1)  NULL,
	[PDW] [decimal](10,1)  NULL,
	[PLT] [decimal](10,1)  NULL,
	[THT] [decimal](10,3)  NULL,
	[HCT] [decimal](10,1)  NULL,
	[HGB] [decimal](10,1)  NULL,
	[MCH] [decimal](10,1)  NULL,
	[MCHC] [decimal](10,1)  NULL,
	[GRA#] [decimal](10,2)  NULL,
	[GRA%] [decimal](10,1)  NULL,
	[LYM#] [decimal](10,2)  NULL,
	[LYM%] [decimal](10,1)  NULL,
	[MON#] [decimal](10,2)  NULL,
	[MON%] [decimal](10,1)  NULL,
	[WBC] [decimal](10,1)  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------




USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HPLCTestedDetail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_HPLCTestedDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Barcode] [varchar](200) NOT NULL,
	[FileName] [varchar](max) NOT NULL,
	[PdfFileName] [varchar](max) NULL,
	[InjectionNo] [varchar](max) NOT NULL,
	[RunNo] [int] NULL,
	[HbF] [decimal] (10,3) NOT NULL,
	[HbA0] [decimal] (10,3) NOT NULL,
	[HbA2] [decimal] (10,3) NOT NULL,
	[HbS] [decimal] (10,3) NOT NULL,
	[HbD] [decimal] (10,3) NOT NULL,
	[TestedDateTime][datetime] NOT NULL,
	[ProcessStatus] [bit] NULL,
	[SampleStatus] [int] NULL,
	[ReasonOfStatus] [varchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](200) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[MachineId] [varchar](max)  NULL,
	[OperatorId] [varchar](max)  NULL,
	[ValuesUpdatedBy] [int] NULL,
	[ValuesUpdatedOn] [datetime] NULL,
	[HbF_CArea] [decimal] (10,3)  NULL,
	[HbA0_CArea] [decimal] (10,3)  NULL,
	[HbA2_CArea] [decimal] (10,3)  NULL,
	[HbS_CArea] [decimal] (10,3)  NULL,
	[HbD_CArea] [decimal] (10,3)  NULL,
	[HbF_Area] [decimal] (10,3)  NULL,
	[HbA0_Area] [decimal] (10,3)  NULL,
	[HbA2_Area] [decimal] (10,3)  NULL,
	[HbS_Area] [decimal] (10,3)  NULL,
	[HbD_Area] [decimal] (10,3)  NULL,
	[HbF_PArea] [decimal] (10,3)  NULL,
	[HbA0_PArea] [decimal] (10,3)  NULL,
	[HbA2_PArea] [decimal] (10,3)  NULL,
	[HbS_PArea] [decimal] (10,3)  NULL,
	[HbD_PArea] [decimal] (10,3)  NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

-------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_AuditTrail' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_AuditTrail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [char](1) NULL,
	[TableName] [varchar](max) NULL,
	[PK] [varchar](max) NULL,
	[PKFieldName] [varchar](max) NULL,
	[PKValue] [varchar](max) NULL,
	[FieldName] [varchar](max) NULL,
	[OldValue] [varchar](max) NULL,
	[NewValue] [varchar](max) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

--------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_HoribaMachineLocationMaster' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_HoribaMachineLocationMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MachineId] [varchar](max) NULL,
	[TestingCHCId] [int] NULL,
	[TestingCHCName] [varchar] (250) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MobileAppLeftSideMenu' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MobileAppLeftSideMenu](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MenuName][varchar](200) NULL,
	[MenuLink] [varchar](max)  NULL,
	[Createdon] [datetime] NULL,
	[Createdby] [int] NULL,
	[Updatedon] [datetime] NULL,
	[Updatedby] [int] NULL,
	[Comments] [varchar](max) NULL,
	[Isactive] [bit] NULL,
	[OdiyaName] [varchar] (200) NULL,
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

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name='Tbl_MobileAppAlert' AND [type] = 'U')
BEGIN

CREATE TABLE [dbo].[Tbl_MobileAppAlert](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AlertMsg] [varchar](max) NULL,
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

---------------------------------------------------------------------------------------------------------------------------------

