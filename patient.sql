Create table [dbo].[TBL_PATIENT] (
	ID [int] IDENTITY(1,1) not null,
	FIRSTNAME varchar(100) not null,
	LASTNAME varchar(100) not null,
	CITY varchar(50) null,
	STATE varchar(50) null,
	 CONSTRAINT [PK_TBL_PATIENT] PRIMARY KEY CLUSTERED (ID ASC) 
) ON [PRIMARY]
