USE [master]
GO
/****** Object:  Database [Quanlycongviec]    Script Date: 27/05/2024 11:03:00 CH ******/
CREATE DATABASE [Quanlycongviec]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Quanlycongviec', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Quanlycongviec.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Quanlycongviec_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Quanlycongviec_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Quanlycongviec] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Quanlycongviec].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Quanlycongviec] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Quanlycongviec] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Quanlycongviec] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Quanlycongviec] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Quanlycongviec] SET ARITHABORT OFF 
GO
ALTER DATABASE [Quanlycongviec] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Quanlycongviec] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Quanlycongviec] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Quanlycongviec] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Quanlycongviec] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Quanlycongviec] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Quanlycongviec] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Quanlycongviec] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Quanlycongviec] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Quanlycongviec] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Quanlycongviec] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Quanlycongviec] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Quanlycongviec] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Quanlycongviec] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Quanlycongviec] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Quanlycongviec] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Quanlycongviec] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Quanlycongviec] SET RECOVERY FULL 
GO
ALTER DATABASE [Quanlycongviec] SET  MULTI_USER 
GO
ALTER DATABASE [Quanlycongviec] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Quanlycongviec] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Quanlycongviec] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Quanlycongviec] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Quanlycongviec] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Quanlycongviec] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Quanlycongviec', N'ON'
GO
ALTER DATABASE [Quanlycongviec] SET QUERY_STORE = ON
GO
ALTER DATABASE [Quanlycongviec] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/****** Object:  Login [NT SERVICE\Winmgmt]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [NT SERVICE\Winmgmt] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\SQLWriter]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [NT SERVICE\SQLWriter] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\SQLTELEMETRY]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [NT SERVICE\SQLTELEMETRY] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\SQLSERVERAGENT]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [NT SERVICE\SQLSERVERAGENT] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT Service\MSSQLSERVER]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [NT Service\MSSQLSERVER] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT AUTHORITY\SYSTEM]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [MITIS\Mysterious MitiS]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [MITIS\Mysterious MitiS] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [devMitis]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [devMitis] WITH PASSWORD=N'Rn1AFjtjwHmpvKsadCWhqYwF8Ir1oR4ufJ6rt87vkhc=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [devMitis] DISABLE
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [##MS_PolicyTsqlExecutionLogin##]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [##MS_PolicyTsqlExecutionLogin##] WITH PASSWORD=N'QHgclifjuNVaEbT5/hiUKZrMLKDK+ENT9TEo4ac5eJo=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [##MS_PolicyTsqlExecutionLogin##] DISABLE
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [##MS_PolicyEventProcessingLogin##]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE LOGIN [##MS_PolicyEventProcessingLogin##] WITH PASSWORD=N'GtJl4PJiBmTNwN1z1EFEsmALmBX5ocabBuCO23NBDvg=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [##MS_PolicyEventProcessingLogin##] DISABLE
GO
ALTER AUTHORIZATION ON DATABASE::[Quanlycongviec] TO [MITIS\Mysterious MitiS]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\Winmgmt]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLWriter]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLSERVERAGENT]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT Service\MSSQLSERVER]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [MITIS\Mysterious MitiS]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [devMitis]
GO
USE [Quanlycongviec]
GO
/****** Object:  User [devMitis]    Script Date: 27/05/2024 11:03:01 CH ******/
CREATE USER [devMitis] FOR LOGIN [devMitis] WITH DEFAULT_SCHEMA=[dbo]
GO
GRANT CONNECT TO [devMitis] AS [dbo]
GO
GRANT VIEW ANY COLUMN ENCRYPTION KEY DEFINITION TO [public] AS [dbo]
GO
GRANT VIEW ANY COLUMN MASTER KEY DEFINITION TO [public] AS [dbo]
GO
/****** Object:  Table [dbo].[new]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[new](
	[news_id] [int] IDENTITY(1,1) NOT NULL,
	[news_type] [tinyint] NULL,
	[title] [nvarchar](500) NULL,
	[image] [nvarchar](500) NULL,
	[description] [nvarchar](max) NULL,
	[contents] [nvarchar](max) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [int] NULL,
	[approved_by] [varchar](50) NULL,
	[approved_date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[created_date] [datetime] NULL,
	[modified_by] [varchar](50) NULL,
	[modified_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[news_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[new] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[project]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[project](
	[project_id] [int] NOT NULL,
	[project_code] [varchar](50) NULL,
	[project_name] [nvarchar](500) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[created_by] [int] NULL,
	[created_date] [datetime] NULL,
	[modified_by] [int] NULL,
	[modified_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[project] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[stage]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stage](
	[stage_id] [int] IDENTITY(1,1) NOT NULL,
	[project_id] [int] NULL,
	[stage_name] [nvarchar](250) NULL,
	[stage_description] [nvarchar](max) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [int] NULL,
	[created_by] [int] NULL,
	[created_date] [datetime] NULL,
	[modified_by] [int] NULL,
	[modified_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[stage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[stage] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[sys_user]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_user](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](50) NULL,
	[password_hash] [varchar](max) NULL,
	[wrong_password_count] [int] NULL,
	[wrong_password_reset_time] [datetime] NULL,
	[full_name] [nvarchar](100) NULL,
	[gender] [tinyint] NULL,
	[date_of_birth] [datetime] NULL,
	[address] [nvarchar](250) NULL,
	[phone_number] [varchar](15) NULL,
	[email] [varchar](250) NULL,
	[avatar] [varchar](500) NULL,
	[status] [bit] NULL,
	[is_admin] [bit] NULL,
	[created_by] [int] NULL,
	[created_date] [datetime] NULL,
	[modified_by] [int] NULL,
	[modified_date] [datetime] NULL,
	[department_name] [nvarchar](500) NULL,
	[position_name] [nvarchar](500) NULL,
 CONSTRAINT [PK__sys_user__B9BE370F47EA67E8] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[sys_user] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[task_member]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[task_member](
	[member_id] [int] NOT NULL,
	[project_id] [int] NULL,
	[stage_id] [int] NULL,
	[task_id] [varchar](50) NULL,
	[user_id] [varchar](50) NOT NULL,
	[is_type] [int] NULL,
	[status] [bit] NULL,
	[created_by] [varchar](50) NULL,
	[created_date] [datetime] NULL,
	[modified_by] [varchar](50) NULL,
	[modified_date] [datetime] NULL,
 CONSTRAINT [PK__task_mem__B29B8534D8AFD2E6] PRIMARY KEY CLUSTERED 
(
	[member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[task_member] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[task_origin]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[task_origin](
	[task_id] [varchar](50) NOT NULL,
	[task_code] [varchar](50) NULL,
	[stage_id] [int] NULL,
	[task_name] [nvarchar](max) NULL,
	[description] [nvarchar](max) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[finish_by] [int] NULL,
	[finish_date] [datetime] NULL,
	[status] [int] NULL,
	[created_by] [int] NULL,
	[created_date] [datetime] NULL,
	[modified_by] [int] NULL,
	[modified_date] [datetime] NULL,
 CONSTRAINT [PK_task] PRIMARY KEY CLUSTERED 
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[task_origin] TO  SCHEMA OWNER 
GO
SET IDENTITY_INSERT [dbo].[sys_user] ON 

INSERT [dbo].[sys_user] ([user_id], [user_name], [password_hash], [wrong_password_count], [wrong_password_reset_time], [full_name], [gender], [date_of_birth], [address], [phone_number], [email], [avatar], [status], [is_admin], [created_by], [created_date], [modified_by], [modified_date], [department_name], [position_name]) VALUES (1, N'administrator', N'$2a$11$XcX8GWU77.6uNNPsv9Albe63jx38DZrz8x/6SlteKetUTrdenGsGe', 0, NULL, N'administrator', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, CAST(N'2024-05-16T22:39:29.083' AS DateTime), NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[sys_user] OFF
GO
ALTER TABLE [dbo].[stage]  WITH CHECK ADD FOREIGN KEY([project_id])
REFERENCES [dbo].[project] ([project_id])
GO
ALTER TABLE [dbo].[task_member]  WITH CHECK ADD  CONSTRAINT [FK__task_memb__task___5629CD9C] FOREIGN KEY([task_id])
REFERENCES [dbo].[task_origin] ([task_id])
GO
ALTER TABLE [dbo].[task_member] CHECK CONSTRAINT [FK__task_memb__task___5629CD9C]
GO
ALTER TABLE [dbo].[task_origin]  WITH CHECK ADD FOREIGN KEY([stage_id])
REFERENCES [dbo].[stage] ([stage_id])
GO
/****** Object:  StoredProcedure [dbo].[List_Users]    Script Date: 27/05/2024 11:03:01 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[List_Users]
    @PageNo int ,
    @PageSize int ,
    @UserId int,
    @Search NVARCHAR(max)
as
DECLARE @isAdmin bit= (Select is_admin
from sys_user
where user_id=@UserId)
SELECT count(*) as totalRecords
from sys_user
where (@isAdmin=1 or (@isAdmin=0 and user_id=@userId)) and (@Search is null or (@Search is not null and
    ([user_name] like N'%'+@Search+'%' or address like N'%'+@Search+'%' or email LIKE N'%'+@Search+'%' or phone_number like N'%'+@Search+'%' or full_name like N'%'+@Search+'%' or department_name like N'%'+@Search+'%' )))
SELECT *
from sys_user
where (@isAdmin=1 or (@isAdmin=0 and user_id=@userId)) and (@Search is null or (@Search is not null and
    ([user_name] like N'%'+@Search+'%' or address like N'%'+@Search+'%' or email LIKE N'%'+@Search+'%' or phone_number like N'%'+@Search+'%' or full_name like N'%'+@Search+'%' or department_name like N'%'+@Search+'%' )))
ORDER by created_date DESC
    OFFSET (@PageNo*@PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY
GO
ALTER AUTHORIZATION ON [dbo].[List_Users] TO  SCHEMA OWNER 
GO
USE [master]
GO
ALTER DATABASE [Quanlycongviec] SET  READ_WRITE 
GO
