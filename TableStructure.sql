USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


-------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



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
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


-----------------------------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



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
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


-----------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



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

GO

SET ANSI_PADDING OFF
GO


--------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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

GO

SET ANSI_PADDING OFF
GO


----------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_CHCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BlockID] [int] NOT NULL,
	[DistrictID] [int] NOT NULL,
	[CHC_gov_code] [varchar](100) NOT NULL,
	[CHCname] [varchar](100) NOT NULL,
	[Istestingfacility] [bit] NULL,
	[HNIN_ID] [int] NULL,
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

GO

SET ANSI_PADDING OFF
GO


-----------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_PHCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CHCID] [int] NOT NULL,
	[PHC_gov_code] [varchar](100) NOT NULL,
	[PHCname] [varchar](100) NOT NULL,
	[HNIN_ID] [int] NULL,
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

GO

SET ANSI_PADDING OFF
GO

--------------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Tbl_SCMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CHCID] [int] NOT NULL,
	[PHCID] [int] NOT NULL,
	[SC_gov_code] [varchar](100) NOT NULL,
	[SCname] [varchar](100) NOT NULL,
	[Pincode] [varchar](100) NULL,
	[HNIN_ID] [int] NULL,
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

GO

SET ANSI_PADDING OFF
GO


---------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_RIMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PHCID] [int] NOT NULL,
	[SCID] [int] NOT NULL,
	[RI_gov_code] [varchar](100) NOT NULL,
	[RIsite] [varchar](100) NOT NULL,
	[Pincode] [varchar](100) NULL,
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

GO

SET ANSI_PADDING OFF
GO


----------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



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

GO

SET ANSI_PADDING OFF
GO



----------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



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

GO

SET ANSI_PADDING OFF
GO



-----------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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

GO

SET ANSI_PADDING OFF
GO


--------------------------------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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

GO

SET ANSI_PADDING OFF
GO


-------------------------------------------------------------------------------------------------------------------------
USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



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
	[RIID] [int]  NULL,
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

GO

SET ANSI_PADDING OFF
GO



-------------------------------------------------------------------------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_SubjectPrimaryDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectTypeID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[DistrictID] [int] NOT NULL,
	[CHCID] [int] NOT NULL,
	[PHCID] [int] NOT NULL,
	[SCID] [int] NOT NULL,
	[RIID] [int] NOT NULL,
	[FirstName] [varchar] (150)NOT NULL,
	[MiddleName] [varchar] (150) NULL,
	[LastName] [varchar] (150) NULL,
	[DOB] [datetime] NULL,
	[Age] [int] NULL,
	[Gender] [varchar] (20) NULL,
	[MaritalStatus] [bit] NULL,
	[MobileNo] [varchar] (150) NULL,
	[SpouseSubjectID] [varchar](200)  NULL,
	[Spouse_FirstName] [varchar] (150) NULL,
	[Spouse_MiddleName] [varchar] (150) NULL,
	[Spouse_LastName] [varchar] (150) NULL,
	[Spouse_ContactNo] [varchar] (150) NULL,
	[GovIdType_ID] [int] NULL,
	[GovIdDetail] [varchar] (150) NULL,
	[AssignANM_ID] [int] NULL,
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

GO

SET ANSI_PADDING OFF
GO


-----------------------------------------------------------------------------------------------------------

USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_SubjectAddressDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectTypeID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,
	[Religion_Id] [int] NULL,
	[Caste_Id] [int] NULL,
	[Community_Id] [int] NULL,
	[Address1] [varchar] (150) NULL,
	[Address2] [varchar] (150) NULL,
	[Address3] [varchar] (150) NULL,
	[Pincode] [varchar] (150) NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	
	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


------------------------------------------------------------------


USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_SubjectPregnancyDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectTypeID] [int] NOT NULL,
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

GO

SET ANSI_PADDING OFF
GO


---------------------------------------------------------------------------------------------



USE [Eduquaydb]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [dbo].[Tbl_SubjectParentDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectTypeID] [int] NOT NULL,
	[UniqueSubjectID] [varchar](200) NOT NULL,	
	[Mother_FirstName] [varchar] (150) NULL,
	[Mother_MiddleName] [varchar] (150) NULL,
	[Mother_LastName] [varchar] (150) NULL,	
	[Mother_UniquetID] [varchar](200)  NULL,	
	[Mother_ContactNo] [varchar] (150) NULL,
	[Father_FirstName] [varchar] (150) NULL,
	[Father_MiddleName] [varchar] (150) NULL,
	[Father_LastName] [varchar] (150) NULL,	
	[Father_UniquetID] [varchar](200)  NULL,	
	[Father_ContactNo] [varchar] (150) NULL,
	[Gaurdian_FirstName] [varchar] (150) NULL,
	[Gaurdian_MiddleName] [varchar] (150) NULL,
	[Gaurdian_LastName] [varchar] (150) NULL,	
	[Gaurdian_ContactNo] [varchar] (150) NULL,
	[RBSKId] [varchar] (150) NULL,
	[SchoolName] [varchar] (150) NULL,
	[SchoolAddress1] [varchar] (250) NULL,
	[SchoolAddress2] [varchar] (250) NULL,
	[SchoolAddress3] [varchar] (250) NULL,
	[SchoolPincode] [varchar] (250) NULL,
	[SchoolCity] [varchar] (200) NULL,
	[SchoolState] [int] NULL,
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

GO

SET ANSI_PADDING OFF
GO


-------------------------------------------------------------------------------------