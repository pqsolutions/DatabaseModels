USE [Eduquaydb]
GO

/****** Object:  Table [dbo].[Tbl_BlockMaster]    Script Date: 03/25/2020 22:47:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (Select 1 from sys.objects where name='Tbl_BlockMaster' and [type] = 'u')
Begin
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
END
GO

SET ANSI_PADDING OFF
GO


