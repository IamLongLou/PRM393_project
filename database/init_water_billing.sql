USE [master]
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'WaterBillingDb')
BEGIN
    CREATE DATABASE [WaterBillingDb]
END
GO

USE [WaterBillingDb]
GO

/****** Object:  Table [dbo].[customers] ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[customers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](50) NOT NULL,
	[name] [nvarchar](255) NULL,
	[address] [nvarchar](500) NULL,
	[phone] [nvarchar](20) NULL,
	[currentReading] [int] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [UQ_customers_code] UNIQUE NONCLUSTERED ([code] ASC)
)
END
GO

/****** Object:  Table [dbo].[bills] ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bills]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[bills](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customerId] [int] NULL,
	[customerName] [nvarchar](255) NULL,
	[customerCode] [nvarchar](50) NULL,
	[billCode] [nvarchar](50) NOT NULL,
	[date] [datetime] NULL,
	[oldReading] [int] NULL,
	[newReading] [int] NULL,
	[consumption] [float] NULL,
	[unitPrice] [float] NULL,
	[amount] [float] NULL,
	[vat] [float] NULL,
	[totalAmount] [float] NULL,
	[imagePath] [nvarchar](max) NULL,
	[isSynced] [bit] NULL,
 CONSTRAINT [PK_bills] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [UQ_bills_billCode] UNIQUE NONCLUSTERED ([billCode] ASC)
)
END
GO

/****** Object:  Table [dbo].[user_session] ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_session]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user_session](
	[username] [nvarchar](100) NOT NULL,
	[fullName] [nvarchar](255) NULL,
	[role] [nvarchar](50) NULL,
	[email] [nvarchar](100) NULL,
	[phone] [nvarchar](20) NULL,
	[token] [nvarchar](max) NULL,
	[lastLoginAt] [datetime] NULL,
 CONSTRAINT [PK_user_session] PRIMARY KEY CLUSTERED ([username] ASC)
)
END
GO
