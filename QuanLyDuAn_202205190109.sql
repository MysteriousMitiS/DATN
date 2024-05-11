
SET DATEFORMAT ymd
SET ARITHABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS, XACT_ABORT OFF
GO
CREATE DATABASE Quanlycongviec
USE Quanlycongviec
GO

IF DB_NAME() <> N'Quanlycongviec' SET NOEXEC ON
GO

--
-- Create table [dbo].[WorkUser]
--
PRINT (N'Create table [dbo].[WorkUser]')
GO
CREATE TABLE dbo.WorkUser (
  WorkId int NOT NULL,
  UserId int NOT NULL,
  WorkRole int NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  ModifiedBy nvarchar(100) NULL,
  ModifiedDate date NULL,
  CONSTRAINT pk_WorkUser PRIMARY KEY CLUSTERED (WorkId, UserId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[WorkId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[WorkId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id công việc', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'WorkId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[UserId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[UserId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id người dùng', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'UserId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[WorkRole]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[WorkRole]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Vai trò', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'WorkRole'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[CreatedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[CreatedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'CreatedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[CreatedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[CreatedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'CreatedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[ModifiedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[ModifiedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'ModifiedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkUser].[ModifiedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkUser].[ModifiedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'WorkUser', 'COLUMN', N'ModifiedDate'
GO

--
-- Create table [dbo].[WorkCheck]
--
PRINT (N'Create table [dbo].[WorkCheck]')
GO
CREATE TABLE dbo.WorkCheck (
  WorkCheckId int IDENTITY,
  CheckResult int NOT NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  WorkId int NOT NULL,
  UserId int NOT NULL,
  PRIMARY KEY CLUSTERED (WorkCheckId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkCheck].[WorkCheckId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkCheck].[WorkCheckId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id kiểm tra', 'SCHEMA', N'dbo', 'TABLE', N'WorkCheck', 'COLUMN', N'WorkCheckId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkCheck].[CheckResult]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkCheck].[CheckResult]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Kết quả', 'SCHEMA', N'dbo', 'TABLE', N'WorkCheck', 'COLUMN', N'CheckResult'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkCheck].[CreatedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkCheck].[CreatedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'WorkCheck', 'COLUMN', N'CreatedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkCheck].[CreatedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkCheck].[CreatedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'WorkCheck', 'COLUMN', N'CreatedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkCheck].[WorkId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkCheck].[WorkId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id công việc', 'SCHEMA', N'dbo', 'TABLE', N'WorkCheck', 'COLUMN', N'WorkId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[WorkCheck].[UserId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[WorkCheck].[UserId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id người dùng', 'SCHEMA', N'dbo', 'TABLE', N'WorkCheck', 'COLUMN', N'UserId'
GO

--
-- Create table [dbo].[Work]
--
PRINT (N'Create table [dbo].[Work]')
GO
CREATE TABLE dbo.Work (
  WorkId int IDENTITY,
  StageId int NOT NULL,
  WorkCode nvarchar(50) NULL,
  WorkName nvarchar(500) NULL,
  WorkStart date NULL,
  WorkEnd date NULL,
  WorkCompleted date NULL,
  WorkStatus int NULL,
  WorkDescription nvarchar(500) NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  ModifiedBy nvarchar(100) NULL,
  ModifiedDate date NULL,
  WorkImage varchar(500) NULL,
  STT int NULL,
  PRIMARY KEY CLUSTERED (WorkId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id công việc', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[StageId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[StageId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id giai đoạn', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'StageId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkCode]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkCode]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mã công việc', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkCode'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkName]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkName]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên công việc', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkName'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkStart]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkStart]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày bắt đầu', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkStart'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkEnd]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkEnd]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày kết thúc', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkEnd'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkCompleted]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkCompleted]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày hoàn thành', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkCompleted'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkStatus]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkStatus]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Trạng thái', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkStatus'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkDescription]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkDescription]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mô tả', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkDescription'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[CreatedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[CreatedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'CreatedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[CreatedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[CreatedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'CreatedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[ModifiedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[ModifiedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'ModifiedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[ModifiedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[ModifiedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'ModifiedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[WorkImage]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[WorkImage]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Hình ảnh', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'WorkImage'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Work].[STT]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Work].[STT]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Số thứ tự', 'SCHEMA', N'dbo', 'TABLE', N'Work', 'COLUMN', N'STT'
GO

--
-- Create table [dbo].[UserP]
--
PRINT (N'Create table [dbo].[UserP]')
GO
CREATE TABLE dbo.UserP (
  UserId int IDENTITY,
  UserCode varchar(100) NOT NULL,
  Name nvarchar(500) NOT NULL,
  UserName varchar(100) NOT NULL,
  Password varchar(100) NOT NULL,
  Position nvarchar(500) NULL,
  PhoneNumber char(10) NULL,
  UserAddress nvarchar(500) NULL,
  Email char(50) NULL,
  DepartmentName nvarchar(100) NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  ModifiedBy nvarchar(100) NULL,
  ModifiedDate date NULL,
  KeyEncript nvarchar(250) NULL,
  IsAdmin bit NULL,
  Token_ID varchar(100) NULL,
  Avatar varchar(100) NULL,
  isDecentlz int NULL,
  PRIMARY KEY CLUSTERED (UserId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[UserId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[UserId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id nhân viên', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'UserId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[UserCode]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[UserCode]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mã nhân viên', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'UserCode'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[Name]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[Name]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên đăng nhập', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'Name'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[UserName]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[UserName]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên nhân viên', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'UserName'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[Password]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[Password]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mật khẩu', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'Password'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[Position]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[Position]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Vị trí', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'Position'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[PhoneNumber]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[PhoneNumber]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Số điện thoại', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'PhoneNumber'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[UserAddress]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[UserAddress]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Địa chỉ', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'UserAddress'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[Email]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[Email]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'email', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'Email'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[DepartmentName]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[DepartmentName]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Phòng ban', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'DepartmentName'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[CreatedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[CreatedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'CreatedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[CreatedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[CreatedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'CreatedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[ModifiedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[ModifiedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'ModifiedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[ModifiedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[ModifiedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'ModifiedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[KeyEncript]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[KeyEncript]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Key mã hóa', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'KeyEncript'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[IsAdmin]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[IsAdmin]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Admin', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'IsAdmin'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[Token_ID]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[Token_ID]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id token', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'Token_ID'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[Avatar]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[Avatar]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ảnh đại diện', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'Avatar'
GO

--
-- Add extended property [MS_Description] on column [dbo].[UserP].[isDecentlz]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[UserP].[isDecentlz]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Quyền', 'SCHEMA', N'dbo', 'TABLE', N'UserP', 'COLUMN', N'isDecentlz'
GO

--
-- Create table [dbo].[sysdiagrams]
--
PRINT (N'Create table [dbo].[sysdiagrams]')
GO
CREATE TABLE dbo.sysdiagrams (
  name sysname NOT NULL,
  principal_id int NOT NULL,
  diagram_id int IDENTITY,
  version int NULL,
  definition varbinary(max) NULL,
  PRIMARY KEY CLUSTERED (diagram_id),
  CONSTRAINT UK_principal_name UNIQUE (principal_id, name)
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Create table [dbo].[Sys_Token]
--
PRINT (N'Create table [dbo].[Sys_Token]')
GO
CREATE TABLE dbo.Sys_Token (
  Token_ID varchar(50) NOT NULL,
  UserName varchar(50) NULL,
  Name nvarchar(250) NULL,
  Ngay datetime NULL,
  NgayHet datetime NULL,
  FromDivice varchar(50) NULL,
  IP varchar(50) NULL,
  isDecentlz int NULL,
  CONSTRAINT PK_Sys_Token PRIMARY KEY CLUSTERED (Token_ID)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[Token_ID]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[Token_ID]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id token', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'Token_ID'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[UserName]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[UserName]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên đăng nhập', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'UserName'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[Name]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[Name]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên người dùng', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'Name'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[Ngay]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[Ngay]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'Ngay'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[NgayHet]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[NgayHet]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày hết hạn', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'NgayHet'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[FromDivice]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[FromDivice]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên máy tạo', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'FromDivice'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[IP]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[IP]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'IP', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'IP'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Sys_Token].[isDecentlz]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Sys_Token].[isDecentlz]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Quyền', 'SCHEMA', N'dbo', 'TABLE', N'Sys_Token', 'COLUMN', N'isDecentlz'
GO

--
-- Create table [dbo].[Stage]
--
PRINT (N'Create table [dbo].[Stage]')
GO
CREATE TABLE dbo.Stage (
  StageId int IDENTITY,
  StageCode varchar(50) NULL,
  StageTarget nvarchar(1000) NULL,
  StageStart date NULL,
  StageEnd date NULL,
  StageCompleted date NULL,
  StageStatus int NULL,
  StageDescription nvarchar(500) NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  ModifiedBy nvarchar(100) NULL,
  ModifiedDate date NULL,
  ProjectId int NOT NULL,
  PRIMARY KEY CLUSTERED (StageId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id giai đoạn', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageCode]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageCode]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mã giai đoạn', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageCode'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageTarget]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageTarget]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mục tiêu', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageTarget'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageStart]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageStart]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày bắt đầu', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageStart'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageEnd]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageEnd]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày kết thúc', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageEnd'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageCompleted]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageCompleted]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày hoàn thành', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageCompleted'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageStatus]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageStatus]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Trạng thái', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageStatus'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[StageDescription]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[StageDescription]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mô tả', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'StageDescription'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[CreatedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[CreatedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'CreatedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[CreatedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[CreatedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'CreatedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[ModifiedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[ModifiedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người sửa', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'ModifiedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[ModifiedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[ModifiedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày sửa', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'ModifiedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Stage].[ProjectId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Stage].[ProjectId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id dự án', 'SCHEMA', N'dbo', 'TABLE', N'Stage', 'COLUMN', N'ProjectId'
GO

--
-- Create table [dbo].[Project]
--
PRINT (N'Create table [dbo].[Project]')
GO
CREATE TABLE dbo.Project (
  ProjectId int IDENTITY,
  ProjectCode nvarchar(10) NULL,
  ProjectName nvarchar(500) NULL,
  ProjectStart date NULL,
  ProjectEnd date NULL,
  ProjectCompleted date NULL,
  ProjectStatus int NULL,
  ProjectDescription nvarchar(500) NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  ModifiedBy nvarchar(100) NULL,
  ModifiedDate date NULL,
  PRIMARY KEY CLUSTERED (ProjectId)
)
ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id dự án', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectCode]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectCode]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mã dự án', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectCode'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectName]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectName]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên dự án', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectName'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectStart]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectStart]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày bắt đầu', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectStart'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectEnd]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectEnd]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày kết thúc', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectEnd'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectCompleted]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectCompleted]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày hoàn thành', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectCompleted'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectStatus]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectStatus]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Trạng thái', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectStatus'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ProjectDescription]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ProjectDescription]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Mô tả', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ProjectDescription'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[CreatedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[CreatedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'CreatedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[CreatedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[CreatedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'CreatedDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ModifiedBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ModifiedBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ModifiedBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[Project].[ModifiedDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[Project].[ModifiedDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'Project', 'COLUMN', N'ModifiedDate'
GO

--
-- Create table [dbo].[News]
--
PRINT (N'Create table [dbo].[News]')
GO
CREATE TABLE dbo.News (
  News_ID int IDENTITY,
  UserId int NOT NULL,
  News_Name nvarchar(500) NULL,
  Image varchar(50) NULL,
  Contents nvarchar(max) NULL,
  Details nvarchar(max) NULL,
  StartDate datetime NULL,
  EndDate datetime NULL,
  CreateDate datetime NULL,
  CreateBy varchar(50) NULL,
  CreateIP varchar(50) NULL,
  Trangthai int NULL,
  STT int NULL,
  IPcapnhat varchar(50) NULL,
  Nguoicapnhat varchar(50) NULL,
  Ngaycapnhat datetime NULL,
  Nguoiduyet varchar(50) NULL,
  Ngayduyet datetime NULL,
  IPduyet varchar(50) NULL,
  IsType int NULL,
  CONSTRAINT PK__News PRIMARY KEY CLUSTERED (News_ID)
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[News_ID]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[News_ID]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id tin tức', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'News_ID'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[UserId]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[UserId]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Id người dùng', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'UserId'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[News_Name]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[News_Name]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Tên tin tức', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'News_Name'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Image]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Image]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Hình ảnh', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Image'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Contents]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Contents]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Nội dung', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Contents'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Details]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Details]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Chi tiết', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Details'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[StartDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[StartDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày đăng', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'StartDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[EndDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[EndDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày hết hạn', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'EndDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[CreateDate]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[CreateDate]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày tạo', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'CreateDate'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[CreateBy]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[CreateBy]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người tạo', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'CreateBy'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[CreateIP]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[CreateIP]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'IP người tạo', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'CreateIP'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Trangthai]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Trangthai]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Trạng thái', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Trangthai'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[STT]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[STT]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Số thứ tự', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'STT'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[IPcapnhat]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[IPcapnhat]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'IP cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'IPcapnhat'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Nguoicapnhat]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Nguoicapnhat]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Nguoicapnhat'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Ngaycapnhat]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Ngaycapnhat]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày cập nhật', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Ngaycapnhat'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Nguoiduyet]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Nguoiduyet]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Người duyệt', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Nguoiduyet'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[Ngayduyet]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[Ngayduyet]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ngày duyệt', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'Ngayduyet'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[IPduyet]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[IPduyet]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Ip của người duyệt', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'IPduyet'
GO

--
-- Add extended property [MS_Description] on column [dbo].[News].[IsType]
--
PRINT (N'Add extended property [MS_Description] on column [dbo].[News].[IsType]')
GO
EXEC sys.sp_addextendedproperty N'MS_Description', N'Loại tin', 'SCHEMA', N'dbo', 'TABLE', N'News', 'COLUMN', N'IsType'
GO

--
-- Create table [dbo].[Comment]
--
PRINT (N'Create table [dbo].[Comment]')
GO
CREATE TABLE dbo.Comment (
  CommentId int IDENTITY,
  CommentText nvarchar(500) NULL,
  CreatedBy nvarchar(100) NULL,
  CreatedDate date NULL,
  WorkId int NOT NULL,
  UserId int NOT NULL,
  PRIMARY KEY CLUSTERED (CommentId)
)
ON [PRIMARY]
GO

-- 
-- Dumping data for table WorkUser
--

-- 
-- Dumping data for table WorkCheck
--
-- 
-- Dumping data for table Work


-- 
-- Dumping data for table UserP
--
USE Quanlycongviec
GO

IF DB_NAME() <> N'QuanLyDuAn' SET NOEXEC ON
GO

--
-- Create foreign key [fk_Project_Stage] on table [dbo].[Stage]
--
PRINT (N'Create foreign key [fk_Project_Stage] on table [dbo].[Stage]')
GO
ALTER TABLE dbo.Stage WITH NOCHECK
  ADD CONSTRAINT fk_Project_Stage FOREIGN KEY (ProjectId) REFERENCES dbo.Project (ProjectId) ON DELETE CASCADE
GO

--
-- Create foreign key [fk_Stage_Work] on table [dbo].[Work]
--
PRINT (N'Create foreign key [fk_Stage_Work] on table [dbo].[Work]')
GO
ALTER TABLE dbo.Work WITH NOCHECK
  ADD CONSTRAINT fk_Stage_Work FOREIGN KEY (StageId) REFERENCES dbo.Stage (StageId) ON DELETE CASCADE
GO

--
-- Create foreign key [fk_UserP_WorkUser] on table [dbo].[WorkUser]
--
PRINT (N'Create foreign key [fk_UserP_WorkUser] on table [dbo].[WorkUser]')
GO
ALTER TABLE dbo.WorkUser WITH NOCHECK
  ADD CONSTRAINT fk_UserP_WorkUser FOREIGN KEY (UserId) REFERENCES dbo.UserP (UserId) ON DELETE CASCADE
GO

--
-- Create foreign key [fk_Work_WorkUser] on table [dbo].[WorkUser]
--
PRINT (N'Create foreign key [fk_Work_WorkUser] on table [dbo].[WorkUser]')
GO
ALTER TABLE dbo.WorkUser WITH NOCHECK
  ADD CONSTRAINT fk_Work_WorkUser FOREIGN KEY (WorkId) REFERENCES dbo.Work (WorkId) ON DELETE CASCADE
GO

--
-- Create foreign key [fk_WorkUser_Check] on table [dbo].[WorkCheck]
--
PRINT (N'Create foreign key [fk_WorkUser_Check] on table [dbo].[WorkCheck]')
GO
ALTER TABLE dbo.WorkCheck WITH NOCHECK
  ADD CONSTRAINT fk_WorkUser_Check FOREIGN KEY (WorkId, UserId) REFERENCES dbo.WorkUser (WorkId, UserId) ON DELETE CASCADE
GO

--
-- Create foreign key [fk_Comment_Check] on table [dbo].[Comment]
--
PRINT (N'Create foreign key [fk_Comment_Check] on table [dbo].[Comment]')
GO
ALTER TABLE dbo.Comment WITH NOCHECK
  ADD CONSTRAINT fk_Comment_Check FOREIGN KEY (WorkId, UserId) REFERENCES dbo.WorkUser (WorkId, UserId) ON DELETE CASCADE
GO

--
-- Create foreign key [FK_New_Userp] on table [dbo].[News]
--
PRINT (N'Create foreign key [FK_New_Userp] on table [dbo].[News]')
GO
ALTER TABLE dbo.News
  ADD CONSTRAINT FK_New_Userp FOREIGN KEY (UserId) REFERENCES dbo.UserP (UserId) ON DELETE CASCADE
GO
SET NOEXEC OFF
GO