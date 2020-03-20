USE [Eduquaydb]
GO

/****** Object:  Table [dbo].[Masters_State]    Script Date: 03/20/2020 10:11:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Masters_State](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Statename] [varchar](150) NOT NULL,
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
--------------------------------------------------------------------

CREATE TABLE [dbo].[Masters_District](
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

--------------------------------------------------------


CREATE TABLE [dbo].[Masters_Block](
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

----------------------------------------------------------



CREATE TABLE [dbo].[Masters_CHC](
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


------------------------------------------------------------------------


CREATE TABLE [dbo].[Masters_PHC](
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


-----------------------------------------------------------------


CREATE TABLE [dbo].[Masters_SC](
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

--------------------------------------------------------------------------


CREATE TABLE [dbo].[Masters_RI](
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

----------------------------------------------------------------------------------


CREATE TABLE [dbo].[Masters_HNIN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Facilitytype_ID] [int] NOT NULL,
	[Facility_name] [varchar](100) NOT NULL,
	[NIN-2-HFI] [int] NOT NULL,
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


-----------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Masters_Facilitytype](
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


----------------------------------------------------------------------------------------


