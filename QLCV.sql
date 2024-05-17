USE [master]
GO
/****** Object:  Database [QuanLyDuAn]    Script Date: 17/05/2024 11:16:33 CH ******/
CREATE DATABASE [QuanLyDuAn]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanLyDuAn', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QuanLyDuAn.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QuanLyDuAn_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QuanLyDuAn_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [QuanLyDuAn] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyDuAn].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyDuAn] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyDuAn] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyDuAn] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QuanLyDuAn] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyDuAn] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET RECOVERY FULL 
GO
ALTER DATABASE [QuanLyDuAn] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyDuAn] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyDuAn] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLyDuAn] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLyDuAn] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QuanLyDuAn] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QuanLyDuAn] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'QuanLyDuAn', N'ON'
GO
ALTER DATABASE [QuanLyDuAn] SET QUERY_STORE = ON
GO
ALTER DATABASE [QuanLyDuAn] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
ALTER AUTHORIZATION ON DATABASE::[QuanLyDuAn] TO [devMitis]
GO
USE [QuanLyDuAn]
GO
/****** Object:  User [devMitis]    Script Date: 17/05/2024 11:16:34 CH ******/
CREATE USER [devMitis] FOR LOGIN [devMitis] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [devMitis]
GO
ALTER ROLE [db_datareader] ADD MEMBER [devMitis]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [devMitis]
GO
/****** Object:  Table [dbo].[Comment]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[CommentText] [nvarchar](500) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[WorkId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Comment] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[News]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[News_ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[News_Name] [nvarchar](500) NULL,
	[Image] [varchar](50) NULL,
	[Contents] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateIP] [varchar](50) NULL,
	[Trangthai] [int] NULL,
	[STT] [int] NULL,
	[IPcapnhat] [varchar](50) NULL,
	[Nguoicapnhat] [varchar](50) NULL,
	[Ngaycapnhat] [datetime] NULL,
	[Nguoiduyet] [varchar](50) NULL,
	[Ngayduyet] [datetime] NULL,
	[IPduyet] [varchar](50) NULL,
	[IsType] [int] NULL,
 CONSTRAINT [PK__News] PRIMARY KEY CLUSTERED 
(
	[News_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[News] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Project]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectCode] [nvarchar](10) NULL,
	[ProjectName] [nvarchar](500) NULL,
	[ProjectStart] [date] NULL,
	[ProjectEnd] [date] NULL,
	[ProjectCompleted] [date] NULL,
	[ProjectStatus] [int] NULL,
	[ProjectDescription] [nvarchar](500) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Project] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Stage]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stage](
	[StageId] [int] IDENTITY(1,1) NOT NULL,
	[StageCode] [varchar](50) NULL,
	[StageTarget] [nvarchar](1000) NULL,
	[StageStart] [date] NULL,
	[StageEnd] [date] NULL,
	[StageCompleted] [date] NULL,
	[StageStatus] [int] NULL,
	[StageDescription] [nvarchar](500) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [date] NULL,
	[ProjectId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Stage] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Sys_Token]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sys_Token](
	[Token_ID] [varchar](50) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Name] [nvarchar](250) NULL,
	[Ngay] [datetime] NULL,
	[NgayHet] [datetime] NULL,
	[FromDivice] [varchar](50) NULL,
	[IP] [varchar](50) NULL,
	[isDecentlz] [int] NULL,
 CONSTRAINT [PK_Sys_Token] PRIMARY KEY CLUSTERED 
(
	[Token_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Sys_Token] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[UserP]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserP](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserCode] [varchar](100) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Position] [nvarchar](500) NULL,
	[PhoneNumber] [char](10) NULL,
	[UserAddress] [nvarchar](500) NULL,
	[Email] [char](50) NULL,
	[DepartmentName] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [date] NULL,
	[KeyEncript] [nvarchar](250) NULL,
	[IsAdmin] [bit] NULL,
	[Token_ID] [varchar](100) NULL,
	[Avatar] [varchar](100) NULL,
	[isDecentlz] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[UserP] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Work]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Work](
	[WorkId] [int] IDENTITY(1,1) NOT NULL,
	[StageId] [int] NOT NULL,
	[WorkCode] [nvarchar](50) NULL,
	[WorkName] [nvarchar](500) NULL,
	[WorkStart] [date] NULL,
	[WorkEnd] [date] NULL,
	[WorkCompleted] [date] NULL,
	[WorkStatus] [int] NULL,
	[WorkDescription] [nvarchar](500) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [date] NULL,
	[WorkImage] [varchar](500) NULL,
	[STT] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[WorkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Work] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[WorkCheck]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkCheck](
	[WorkCheckId] [int] IDENTITY(1,1) NOT NULL,
	[CheckResult] [int] NOT NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[WorkId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[WorkCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[WorkCheck] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[WorkUser]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkUser](
	[WorkId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[WorkRole] [int] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [nvarchar](100) NULL,
	[ModifiedDate] [date] NULL,
 CONSTRAINT [pk_WorkUser] PRIMARY KEY CLUSTERED 
(
	[WorkId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[WorkUser] TO  SCHEMA OWNER 
GO
SET IDENTITY_INSERT [dbo].[News] ON 

INSERT [dbo].[News] ([News_ID], [UserId], [News_Name], [Image], [Contents], [Details], [StartDate], [EndDate], [CreateDate], [CreateBy], [CreateIP], [Trangthai], [STT], [IPcapnhat], [Nguoicapnhat], [Ngaycapnhat], [Nguoiduyet], [Ngayduyet], [IPduyet], [IsType]) VALUES (37, 14, N'Hơn 350 công nhân ngộ độc sau bữa ăn trưa', N'/Portals/News/news.png', N'Hơn 350 công nhân ngộ độc sau bữa ăn trưa', N'<h2><strong>Hơn 350 công nhân ngộ độc sau bữa ăn trưa</strong></h2><p>VĨNH PHÚCHơn 350 công nhân Công ty TNHH Shinwon Ebenezer bị ngộ độc sau bữa ăn trưa với gà xào xả ớt, súp lơ xanh, canh đỗ xanh và dưa muối.</p><p>Trưa 14/5, Công ty TNHH Shinwon Ebenezer Việt Nam tổ chức cho hơn 3.290 công nhân ăn trưa thành hai ca. Ca một lúc 11h30 gồm hơn 1.000 suất, ca hai lúc 12h30 khoảng 2.000 suất. Bữa ăn do công ty tự nấu, trưa nay có gà xào xả ớt, súp lơ xanh, canh đỗ xanh và dưa muối.</p><p>Đến khoảng 14h, 5 công nhân có biểu hiện đau bụng, buồn nôn, được đưa đến Bệnh viện Hữu nghị Lạc Việt Vĩnh Yên cấp cứu. Một lúc sau, hàng loạt công nhân ôm bụng, thậm chí có người ngất xỉu. Những người ăn ca hai gặp triệu chứng tương tự sau đó một tiếng, một nữ công nhân 49 tuổi cho biết.</p><p><img src="https://vcdn-vnexpress.vnecdn.net/2024/05/14/436571020-955708222922047-1708-3545-7492-1715694471.jpg" alt="Một nữ công nhân đang điều trị tại bệnh viện. Ảnh: P.C"></p><p>Một nữ công nhân đang điều trị tại bệnh viện. Ảnh: <i>P.C.</i></p><p>Đến 17h, thêm 351 công nhân đau bụng, buồn nôn. 49 người được đưa vào Bệnh viện Đa khoa tỉnh Vĩnh Phúc, 80 người tới Trung tâm Y tế TP Vĩnh Yên và 222 ca tới Bệnh viện Hữu nghị Lạc Việt. 60 người còn lại được theo dõi tại phòng y tế của đơn vị, theo báo cáo của Công ty TNHH Shinwon Ebenezer Việt Nam.</p><p>Đại diện Bệnh viện Hữu Nghị Lạc Việt tại cho biết đã tiếp nhận hơn 200 công nhân có biểu hiện ngộ độc thực phẩm, "may mắn chưa ai trở nặng".</p><p>Công an tỉnh Vĩnh Phúc đã cử lực lượng phối hợp với Sở Y tế, Sở Lao động Thương binh và Xã hội, Ban Quản lý các khu công nghiệp, Liên đoàn Lao động tỉnh và chính quyền làm việc với lãnh đạo doanh nghiệp, những người liên quan.</p><p>Hiện Sở Y tế tỉnh Vĩnh Phúc đã thu thập mẫu thức ăn, mẫu nước để xét nghiệm tìm nguyên nhân.</p><p>Công ty TNHH Shinwon Ebenezer nằm tại khu công nghiệp Khai Quang, TP Vĩnh Yên, 100% vốn đầu tư Hàn Quốc, chuyên sản xuất hàng may mặc xuất khẩu.</p><p><strong>Phạm Chiểu - Hồng Chiêu</strong></p>', CAST(N'2024-05-15T00:00:00.000' AS DateTime), CAST(N'2024-05-15T00:00:00.000' AS DateTime), CAST(N'2024-05-15T02:31:17.167' AS DateTime), N'administrator', N'172.25.64.1', 1, 1, N'172.25.64.1', N'administrator', CAST(N'2024-05-15T02:31:38.593' AS DateTime), N'administrator', CAST(N'2024-05-15T02:44:16.280' AS DateTime), N'172.25.64.1', 0)
INSERT [dbo].[News] ([News_ID], [UserId], [News_Name], [Image], [Contents], [Details], [StartDate], [EndDate], [CreateDate], [CreateBy], [CreateIP], [Trangthai], [STT], [IPcapnhat], [Nguoicapnhat], [Ngaycapnhat], [Nguoiduyet], [Ngayduyet], [IPduyet], [IsType]) VALUES (38, 14, N'Bộ Chính trị đề nghị Trung ương kỷ luật ông Lê Thanh Hải', N'/Portals/News/news1705.png', N'Bộ Chính trị đề nghị Trung ương kỷ luật ông Lê Thanh Hải', N'<h2><strong>Bộ Chính trị đề nghị Trung ương kỷ luật ông Lê Thanh Hải</strong></h2><p>Bộ Chính trị đề nghị Ban Chấp hành Trung ương Đảng xem xét kỷ luật ông Lê Thanh Hải, nguyên Ủy viên Bộ Chính trị, nguyên Bí thư Thành ủy, nguyên Chủ tịch UBND TP HCM.</p><p>Ngày 14/5, tại cuộc họp ở trụ sở Trung ương Đảng, Bộ Chính trị cũng cảnh cáo Ban Thường vụ Thành ủy TP HCM nhiệm kỳ 2010-2015 và các ông Lê Hoàng Quân, Nguyễn Thành Phong - nguyên Ủy viên Trung ương Đảng, nguyên Chủ tịch UBND TP HCM.</p><p>Sau khi xem xét đề nghị của Ủy ban Kiểm tra Trung ương, Bộ Chính trị, Ban Bí thư nhận thấy Ban Thường vụ Thành ủy TP HCM nhiệm kỳ 2010-2015 đã vi phạm nguyên tắc tập trung dân chủ, quy định của Đảng, quy chế làm việc; thiếu trách nhiệm, buông lỏng lãnh đạo, chỉ đạo, thiếu kiểm tra, giám sát, để xảy ra nhiều vi phạm, khuyết điểm trong quản lý, sử dụng đất, tài chính, tài sản, đầu tư, quy hoạch, xây dựng trên địa bàn, kéo dài qua các thời kỳ.</p><p>Ông Lê Thanh Hải, Lê Hoàng Quân và Nguyễn Thành Phong bị xác định vi phạm nguyên tắc tập trung dân chủ, quy định của Đảng, pháp luật; quy định những điều đảng viên không được làm và trách nhiệm nêu gương. Các ông cũng thiếu trách nhiệm, buông lỏng lãnh đạo để xảy ra nhiều vi phạm, khuyết điểm tại Đảng bộ, chính quyền thành phố.</p><p>Những vi phạm này gây "hậu quả nghiêm trọng, nguy cơ thiệt hại, thất thoát rất lớn tiền, tài sản của Nhà nước và nguồn lực xã hội, để xảy ra các vụ án hình sự nghiêm trọng, đặc biệt nghiêm trọng". Nhiều tổ chức đảng, cán bộ, đảng viên bị kỷ luật, xử lý hình sự, gây dư luận bức xúc, làm giảm uy tín của tổ chức đảng và chính quyền thành phố.</p><p><img src="https://vcdn-vnexpress.vnecdn.net/2024/05/14/CG2A1452-4690-1715680233.jpg" alt="Ông Lê Thanh Hải tại một sự kiện ở quận 1 TP HCM, tháng 4/2022. Ảnh: Quỳnh Trần"></p><p>Ông Lê Thanh Hải tại một sự kiện ở quận 1 TP HCM, tháng 4/2022. Ảnh: <i>Quỳnh Trần</i></p><p>Sáu ngày trước, Ban Thường vụ Thành ủy TP HCM nhiệm kỳ 2010-2015, ông Lê Thanh Hải, Lê Hoàng Quân, Nguyễn Thành Phong, bị Ủy ban Kiểm tra Trung ương đề nghị cấp có thẩm quyền xem xét, thi hành kỷ luật. Theo Cơ quan kiểm tra Trung ương, Ban cán sự Đảng UBND TP HCM nhiệm kỳ 2011-2016, 2016-2021 có vi phạm ở các dự án do Vạn Thịnh Phát và các gói thầu, dự án do Công ty AIC thực hiện. Nhiều tổ chức đảng, đảng viên đã bị kỷ luật hoặc xử lý hình sự.</p><p>Ông Lê Thanh Hải, 74 tuổi, quê tỉnh Tiền Giang; Ủy viên Bộ Chính trị khóa 10 và 11; Ủy viên Trung ương ba khóa 9-11. Sự nghiệp của ông gắn liền với TP HCM qua nhiều vị trí lãnh đạo như Phó chủ tịch, Chủ tịch UBND thành phố, Bí thư Thành ủy hai nhiệm kỳ liên tiếp 2005-2010, 2010-2015.</p><p>Tháng 3/2020, ông <a href="https://vnexpress.net/chu-de/le-thanh-hai-7382">Lê Thanh Hải</a> bị cách chức nguyên Bí thư Thành ủy TP HCM giai đoạn 2010-2015 do chịu trách nhiệm chính về những vi phạm, khuyết điểm của Ban thường vụ và Thường trực Thành ủy nhiệm kỳ 2010-2015 trong lãnh đạo, chỉ đạo đầu tư khu đô thị mới Thủ Thiêm.</p><p>Ông cũng bị xác định vi phạm nguyên tắc tập trung dân chủ, quy chế làm việc của Thành ủy, trực tiếp kết luận nhiều vấn đề thuộc thẩm quyền của Ban thường vụ Thành ủy. Với cương vị là Phó bí thư Thành ủy, Bí thư Ban cán sự đảng, Chủ tịch UBND thành phố giai đoạn 2001-2006, ông chịu trách nhiệm chính về các vi phạm của UBND thành phố; trực tiếp ký một số văn bản không đúng với chủ trương của HĐND thành phố và quy định của Luật Ngân sách năm 2002, Luật Xây dựng năm 2003.</p>', CAST(N'2024-05-15T02:32:34.000' AS DateTime), CAST(N'2024-05-15T02:32:39.000' AS DateTime), CAST(N'2024-05-15T02:32:25.750' AS DateTime), N'administrator', N'172.25.64.1', 1, 1, N'172.25.64.1', N'administrator', CAST(N'2024-05-15T02:32:42.593' AS DateTime), N'administrator', CAST(N'2024-05-15T02:44:14.703' AS DateTime), N'172.25.64.1', 0)
INSERT [dbo].[News] ([News_ID], [UserId], [News_Name], [Image], [Contents], [Details], [StartDate], [EndDate], [CreateDate], [CreateBy], [CreateIP], [Trangthai], [STT], [IPcapnhat], [Nguoicapnhat], [Ngaycapnhat], [Nguoiduyet], [Ngayduyet], [IPduyet], [IsType]) VALUES (39, 14, N'Thông báo nội bộ số 1', NULL, N'Thông báo nội bộ số 1', N'<p>Thông báo về các công việc tháng tới:<br>- Bắt đầu dự án văn phòng điện tử<br>- Khảo sát chất lượng phần mềm Luật…</p>', CAST(N'2024-05-15T02:59:46.000' AS DateTime), CAST(N'2024-05-15T02:59:48.000' AS DateTime), CAST(N'2024-05-15T02:59:41.967' AS DateTime), N'administrator', N'172.25.64.1', 1, 1, N'172.25.64.1', N'administrator', CAST(N'2024-05-15T02:59:53.147' AS DateTime), N'administrator', CAST(N'2024-05-15T03:23:38.050' AS DateTime), N'172.25.64.1', 1)
SET IDENTITY_INSERT [dbo].[News] OFF
GO
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (15, N'DA-01', N'Xây dựng phần mềm quản lý khách sạn cho Công ty Bắc Sơn.', CAST(N'2022-12-05' AS Date), CAST(N'2024-10-31' AS Date), NULL, 0, N'Xây dựng phần mềm cho công ty cổ phần Bắc Sơn.', N'administrator', CAST(N'2022-05-06' AS Date), N'administrator', CAST(N'2024-05-15' AS Date))
INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (17, N'DA-02', N'Xây dựng Website bán quần áo cho Cửa hàng Dệt Tiên', CAST(N'2022-05-31' AS Date), CAST(N'2023-01-10' AS Date), NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (18, N'DA-03 ', N'Xây dựng website bán đồng hồ Nam Long', CAST(N'2023-01-01' AS Date), CAST(N'2023-05-10' AS Date), NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (19, N'DA-04', N'Xây dựng website bán đồ điện tử E-Cart', CAST(N'2022-07-04' AS Date), CAST(N'2022-09-22' AS Date), NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (20, N'DA-05', N'Xây dựng Website luyện thi TOEIC', CAST(N'2022-09-15' AS Date), CAST(N'2023-02-22' AS Date), NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (21, N'DA-06', N'Xây dựng website bán đồ âu phục Mono Media ', CAST(N'2022-10-20' AS Date), CAST(N'2023-02-28' AS Date), NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL)
INSERT [dbo].[Project] ([ProjectId], [ProjectCode], [ProjectName], [ProjectStart], [ProjectEnd], [ProjectCompleted], [ProjectStatus], [ProjectDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (22, N'DA-07', N'Xây dựng Website bán thực phẩm cho cửa hàng "An Bình Market"', CAST(N'2022-10-19' AS Date), CAST(N'2023-04-01' AS Date), NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Project] OFF
GO
SET IDENTITY_INSERT [dbo].[Stage] ON 

INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (15, N'GD-01', N'Khảo sát hệ thống', CAST(N'2024-05-15' AS Date), CAST(N'2024-05-31' AS Date), NULL, 0, N'', N'administrator', CAST(N'2022-05-06' AS Date), N'administrator', CAST(N'2024-05-15' AS Date), 15)
INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (16, N'GD-02', N'Phân tích và triển khai cho khách hàng', CAST(N'2024-06-01' AS Date), CAST(N'2024-06-30' AS Date), NULL, 0, N'', N'Huavanduy', CAST(N'2022-05-12' AS Date), N'administrator', CAST(N'2024-05-15' AS Date), 15)
INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (17, N'GD-03', N'Phân tích thiết kế hệ thống', CAST(N'2024-07-01' AS Date), CAST(N'2024-07-31' AS Date), NULL, 0, N'', N'Huavanduy', CAST(N'2022-05-12' AS Date), N'administrator', CAST(N'2024-05-15' AS Date), 15)
INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (18, N'GD-05', N'Phát triển phần mềm bằng Vuejs, ASP.NET API, SQL Server.', CAST(N'2024-08-01' AS Date), CAST(N'2024-09-15' AS Date), NULL, 0, N'', N'Huavanduy', CAST(N'2022-05-12' AS Date), N'administrator', CAST(N'2024-05-15' AS Date), 15)
INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (19, N'GD-06', N'Kiểm thử và triển khai cho khách hàng.', CAST(N'2024-09-15' AS Date), CAST(N'2024-10-31' AS Date), NULL, 0, N'', N'Huavanduy', CAST(N'2022-05-12' AS Date), N'administrator', CAST(N'2024-05-15' AS Date), 15)
INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (20, N'Test 1', N'Hoàn thành test', NULL, NULL, NULL, 0, N'', N'administrator', CAST(N'2024-05-14' AS Date), NULL, NULL, 17)
INSERT [dbo].[Stage] ([StageId], [StageCode], [StageTarget], [StageStart], [StageEnd], [StageCompleted], [StageStatus], [StageDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ProjectId]) VALUES (21, N'NT', N'Nghiệm thu dự án', NULL, NULL, NULL, 0, N'', N'administrator', CAST(N'2024-05-15' AS Date), N'administrator', CAST(N'2024-05-15' AS Date), 15)
SET IDENTITY_INSERT [dbo].[Stage] OFF
GO
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'03A6682459B74FC99A139B26EA2AF4B0', N'7', N'7', CAST(N'2022-05-07T11:33:32.893' AS DateTime), CAST(N'2022-05-08T11:33:32.893' AS DateTime), N'PC', N'::1', NULL)
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'1D9401EBF24F4ACBB141C47831CA3E80', N'hoangnb', N'Nguyễn Hoàng', CAST(N'2024-05-15T01:12:46.770' AS DateTime), CAST(N'2024-05-16T01:12:46.770' AS DateTime), N'PC', N'::1', 0)
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'5F82CB073E4443A7B920104F77920790', N'Huavanduc', N'Hứa Văn Đức', CAST(N'2022-05-10T16:34:32.590' AS DateTime), CAST(N'2022-05-11T16:34:32.590' AS DateTime), N'PC', N'::1', 0)
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'7A8223F1B2434F859557219EFD709464', N'administrator', N'Administrator', CAST(N'2022-05-03T23:50:03.237' AS DateTime), CAST(N'2022-05-04T23:50:03.237' AS DateTime), N'PC', N'::1', NULL)
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'B7B5A17707714AABAEC63B57BCEE6BCE', N'Duy', N'Duy', CAST(N'2022-05-07T03:40:34.460' AS DateTime), CAST(N'2022-05-08T03:40:34.460' AS DateTime), N'PC', N'::1', NULL)
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'C9A9D9A2B3894D6DA2DAD9A40B4BC5BF', N'Huavanduy', N'Hứa Văn Duy', CAST(N'2022-05-10T11:06:53.530' AS DateTime), CAST(N'2022-05-11T11:06:53.530' AS DateTime), N'PC', N'::1', 0)
INSERT [dbo].[Sys_Token] ([Token_ID], [UserName], [Name], [Ngay], [NgayHet], [FromDivice], [IP], [isDecentlz]) VALUES (N'DAF9E70479944C42BEC048558FD2C1DC', N'Thuyenvv', N'Vũ Văn Thuyên', CAST(N'2024-05-14T16:03:25.427' AS DateTime), CAST(N'2024-05-15T16:03:25.427' AS DateTime), N'PC', N'::1', 0)
GO
SET IDENTITY_INSERT [dbo].[UserP] ON 

INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (14, N'AD1', N'Administrator', N'Administrator', N'27dX9UHOd8QeJrugykfMeA==', N'Tổng giám đốc ', NULL, NULL, NULL, N'Hội đồng quản trị', N'administrator', CAST(N'2022-05-07' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 1, NULL, N'/Portals/Users/9734139295.jpg', 6)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (15, N'NV01', N'Nguyễn Hoàng', N'hoangnb', N'Iq6KnnNcx6xG1VRihIszKw==', N'Nhân viên', N'0336872725', NULL, N'hoangnb1203@gmail.com                             ', N'Kế toán', N'administrator', CAST(N'2022-05-07' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 0, NULL, N'/Portals/Users/973413.jpg', 3)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (16, N'NS-001', N'Hứa Văn Đức', N'Huavanduc', N'27dX9UHOd8QeJrugykfMeA==', N'Quản lý', N'0355565545', NULL, N'emtestma@gmail.com                                ', N'Tài chính', N'administrator', CAST(N'2022-05-09' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 1, NULL, N'/Portals/Users/670098.jpg', 6)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (19, N'NV-001', N'Lê Văn Hạnh', N'hanhlv', N'GuXbbvJk1pcM+2O32osddFrWn4dPlAuZSE86+FXUnqg=', N'Tổng giám đốc ', NULL, NULL, NULL, N'Hội đồng quản trị', N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 1, NULL, N'/Portals/Users/670098.jpg', 6)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (20, N'NV-002', N'Vũ Văn Thuyên', N'Thuyenvv', N'Iq6KnnNcx6xG1VRihIszKw==', N'Tổng giám đốc ', N'3213213   ', NULL, N'123123123                                         ', N'2', N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 0, NULL, N'/Portals/Users/GearVN_Ghostblade_ (8).jpg', 5)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (21, N'NV-003', N'Nguyễn Thị Uyên', N'Nguyenthiuyen', N'9PX0fXE2bQcOdHFwOunK2g==', NULL, NULL, NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 0, NULL, N'/Portals/Users/670098.jpg', 0)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (22, N'NV-005', N'Lý Tuấn Anh', N'Lyanhtuan', N'6ujkMAjfuzNp0afjWHz2KA==', NULL, NULL, NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 0, NULL, N'/Portals/Users/670098.jpg', 0)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (23, N'NV-007', N'Hứa Hạo Thiên', N'Huahaothien', N'WpU67kkDLo0/7TrAs6EDZA==', NULL, NULL, NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 1, NULL, N'/Portals/Users/670098.jpg', 6)
INSERT [dbo].[UserP] ([UserId], [UserCode], [Name], [UserName], [Password], [Position], [PhoneNumber], [UserAddress], [Email], [DepartmentName], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [KeyEncript], [IsAdmin], [Token_ID], [Avatar], [isDecentlz]) VALUES (25, N'NV-008', N'Hoàng Tuấn Anh', N'hoangtuan', N'YXu00pJUngOAH5sCFNyxRA==', NULL, NULL, NULL, NULL, NULL, N'administrator', CAST(N'2022-05-12' AS Date), NULL, NULL, N'MTAxMjE5ODgxNTAyMTk4OQ==', 0, NULL, N'/Portals/Users/670098.jpg', 0)
SET IDENTITY_INSERT [dbo].[UserP] OFF
GO
SET IDENTITY_INSERT [dbo].[Work] ON 

INSERT [dbo].[Work] ([WorkId], [StageId], [WorkCode], [WorkName], [WorkStart], [WorkEnd], [WorkCompleted], [WorkStatus], [WorkDescription], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [WorkImage], [STT]) VALUES (1056, 15, N'CV01', N'Công việc test', CAST(N'2024-05-17' AS Date), CAST(N'2024-05-16' AS Date), CAST(N'2024-05-17' AS Date), 5, N'Chờ Duyệt', N'administrator', CAST(N'2024-05-17' AS Date), N'hoangnb', CAST(N'2024-05-17' AS Date), N'', 1)
SET IDENTITY_INSERT [dbo].[Work] OFF
GO
SET IDENTITY_INSERT [dbo].[WorkCheck] ON 

INSERT [dbo].[WorkCheck] ([WorkCheckId], [CheckResult], [CreatedBy], [CreatedDate], [WorkId], [UserId]) VALUES (1179, 2, N'administrator', CAST(N'2024-05-17' AS Date), 1056, 14)
SET IDENTITY_INSERT [dbo].[WorkCheck] OFF
GO
INSERT [dbo].[WorkUser] ([WorkId], [UserId], [WorkRole], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1056, 14, 1, N'hoangnb', CAST(N'2024-05-17' AS Date), NULL, NULL)
INSERT [dbo].[WorkUser] ([WorkId], [UserId], [WorkRole], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1056, 15, 0, N'hoangnb', CAST(N'2024-05-17' AS Date), NULL, NULL)
GO
ALTER TABLE [dbo].[Comment]  WITH NOCHECK ADD  CONSTRAINT [fk_Comment_Check] FOREIGN KEY([WorkId], [UserId])
REFERENCES [dbo].[WorkUser] ([WorkId], [UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [fk_Comment_Check]
GO
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_New_Userp] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserP] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_New_Userp]
GO
ALTER TABLE [dbo].[Stage]  WITH NOCHECK ADD  CONSTRAINT [fk_Project_Stage] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([ProjectId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Stage] CHECK CONSTRAINT [fk_Project_Stage]
GO
ALTER TABLE [dbo].[Work]  WITH NOCHECK ADD  CONSTRAINT [fk_Stage_Work] FOREIGN KEY([StageId])
REFERENCES [dbo].[Stage] ([StageId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Work] CHECK CONSTRAINT [fk_Stage_Work]
GO
ALTER TABLE [dbo].[WorkCheck]  WITH NOCHECK ADD  CONSTRAINT [fk_WorkUser_Check] FOREIGN KEY([WorkId], [UserId])
REFERENCES [dbo].[WorkUser] ([WorkId], [UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkCheck] CHECK CONSTRAINT [fk_WorkUser_Check]
GO
ALTER TABLE [dbo].[WorkUser]  WITH NOCHECK ADD  CONSTRAINT [fk_UserP_WorkUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserP] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkUser] CHECK CONSTRAINT [fk_UserP_WorkUser]
GO
ALTER TABLE [dbo].[WorkUser]  WITH NOCHECK ADD  CONSTRAINT [fk_Work_WorkUser] FOREIGN KEY([WorkId])
REFERENCES [dbo].[Work] ([WorkId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkUser] CHECK CONSTRAINT [fk_Work_WorkUser]
GO
/****** Object:  StoredProcedure [dbo].[MyWork_Export]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[MyWork_Export] @UserName VARCHAR(50)
AS
select 
WorkCode as [|Mã công việc|40|c], 
WorkName as [|Tên công việc|40|c], 
WorkStart as [|Ngày bắt đầu|40|c], 
WorkEnd as [|Ngày kết thúc|40|c], 
WorkDescription as [|Mô tả|80|c], 
    (select ProjectName
    from Project
    where ProjectId= (select st.ProjectId
    from Stage st
    where st.StageId=w.StageId ) )as [|Dự án|40|c], 
    (select st.StageTarget
    from Stage st
    where st.StageId=w.StageId ) as [|Giai đoạn|40|c]
from Work  w
WHERE WorkId in ( select WorkId
from WorkUser
WHERE UserId= (select UserId
    from UserP
    where UserName=@UserName) and WorkRole=0)
GO
ALTER AUTHORIZATION ON [dbo].[MyWork_Export] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[News_Count]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROC [dbo].[News_Count]
    @NewId int ,
    @Search NVARCHAR(500)
as
select count(*) as totalRecords
from News
where (@Search is null or (@Search is not null and News_Name like N'%'+@Search+'%' or Details like N'%'+@Search+'%') )
GO
ALTER AUTHORIZATION ON [dbo].[News_Count] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[News_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROC [dbo].[News_List]
    @Search NVARCHAR(500),
    @PageNo int ,
    @PageSize INT
as
select *
from News
where (@Search is null or (@Search is not null and News_Name like N'%'+@Search+'%' or Details like N'%'+@Search+'%') )
ORDER by CreateDate DESC
OFFSET (@PageNo-1)*@PageSize Rows FETCH NEXT @PageSize Rows ONLY
GO
ALTER AUTHORIZATION ON [dbo].[News_List] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[News_List_Show]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROC [dbo].[News_List_Show]
    @Search NVARCHAR(500),
    @PageNo int ,
    @PageSize INT
as
select *
from News
where IsType=0 and Trangthai=1 and
  ( StartDate is null or (StartDate is not null AND Day(GETDATE()) >= Day(StartDate) and  Month(GETDATE()) >= Month(StartDate) and year(GETDATE()) >= year(StartDate)) ) 
  AND
  ( EndDate is null or (EndDate is not null AND Day(GETDATE()) >= Day(EndDate) and  Month(GETDATE()) >= Month(EndDate) and year(GETDATE()) >= year(EndDate)) ) 
ORDER by CreateDate DESC
OFFSET (@PageNo-1)*@PageSize Rows FETCH NEXT @PageSize Rows ONLY
GO
ALTER AUTHORIZATION ON [dbo].[News_List_Show] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[News_ListExport]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[News_ListExport] @Search NVARCHAR(500)
AS
select
    News_Name as [|Tên tin tức/thông báo|40|c], 
    Contents as [|Tóm tắt|40|c], 
    Details as [|Nội dung chi tiết|80|c], 
    (case when Trangthai=0 then N'Chưa duyệt'  when Trangthai=1 then N'Đã duyệt' else '' end) as [|Trạng thái|80|c]
from News 
where (@Search is null or (@Search is not null and (News_Name like N'%'+@Search+'%' or Contents like N'%'+@Search+'%' or Details like N'%'+@Search+'%')))
GO
ALTER AUTHORIZATION ON [dbo].[News_ListExport] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Notification_List_Show]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROC [dbo].[Notification_List_Show]
    @Search NVARCHAR(500),
    @PageNo int ,
    @PageSize INT
as
select *
from News
where IsType=1 and Trangthai= 1 and
  ( StartDate is null or (StartDate is not null AND Day(GETDATE()) >= Day(StartDate) and  Month(GETDATE()) >= Month(StartDate) and year(GETDATE()) >= year(StartDate)) ) 
  AND
  ( EndDate is null or (EndDate is not null AND Day(GETDATE()) >= Day(EndDate) and  Month(GETDATE()) >= Month(EndDate) and year(GETDATE()) >= year(EndDate)) ) 
   
ORDER by CreateDate DESC
OFFSET (@PageNo-1)*@PageSize Rows FETCH NEXT @PageSize Rows ONLY
GO
ALTER AUTHORIZATION ON [dbo].[Notification_List_Show] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Project_Get]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Project_Get]
    @ProjectId int
as
select *
from Project
WHERE ProjectId=@ProjectId
GO
ALTER AUTHORIZATION ON [dbo].[Project_Get] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Project_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Project_List]
    @m_SearchText nVARCHAR(500)
as
select *
from Project
WHERE ( @m_SearchText is null or ( @m_SearchText is not null and( ProjectCode LIKE N'%'+@m_SearchText+'%' or ProjectName LIKE N'%'+@m_SearchText+'%' or ProjectDescription LIKE N'%'+@m_SearchText+'%' )))
GO
ALTER AUTHORIZATION ON [dbo].[Project_List] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Project_List_User]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[Project_List_User]
    @m_SearchText nvARCHAR(500),
    @UserName VARCHAR(50)
as
select *
from Project
WHERE CreatedBy=@UserName or ( 
		ProjectId in 
		(select ProjectId from Stage where StageId in
			(select StageId from work where WorkId in 
				(select WorkId from WorkUser where UserId=(select UserId from UserP where UserName=@UserName)))))
GO
ALTER AUTHORIZATION ON [dbo].[Project_List_User] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Project_ListExport]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Project_ListExport]
    @m_SearchText nVARCHAR(500)
as
select ProjectCode as [|Mã dự án|40|c],
        ProjectName as [|Tên dự án|40|c],
        ProjectStart as [|Ngày bắt đầu|40|c],
        ProjectEnd as [|Ngày kết thúc|40|c],
        ProjectDescription as [|Mô tả|80|c]
from Project
WHERE ( @m_SearchText is null or ( @m_SearchText is not null and( ProjectCode LIKE N'%'+@m_SearchText+'%' or ProjectName LIKE N'%'+@m_SearchText+'%' or ProjectDescription LIKE N'%'+@m_SearchText+'%' )))
GO
ALTER AUTHORIZATION ON [dbo].[Project_ListExport] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Stage_Get]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Stage_Get]
    @StageId int
as
select *
from Stage
WHERE @StageId=StageId
GO
ALTER AUTHORIZATION ON [dbo].[Stage_Get] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Stage_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Stage_List]
    @m_SearchText nVARCHAR(500)
as
select *
from Stage
GO
ALTER AUTHORIZATION ON [dbo].[Stage_List] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Stage_ListWithId]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Stage_ListWithId]
    @m_SearchText nVARCHAR(500),
    @Id int
as
select *
from Stage
WHERE ProjectId=@Id and( @m_SearchText is null or ( @m_SearchText is not null and( StageCode LIKE N'%'+@m_SearchText+'%' or StageDescription LIKE N'%'+@m_SearchText+'%' or StageTarget LIKE N'%'+@m_SearchText+'%' )))
GO
ALTER AUTHORIZATION ON [dbo].[Stage_ListWithId] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Users_Count]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Users_Count] @Search nvarchar(500), @UserName varchar(50), @IsAdmin bit
as 
select count(*) as totalRecords from UserP 
where ( @Search is null or ( @Search is not null and( UserCode like N'%'+@Search+'%' or Name like N'%'+@Search+'%' or UserName like N'%'+@Search+'%')))
and (@UserName is null or (@UserName is not null and @UserName=UserName))
and (@IsAdmin is null or  @IsAdmin =0 or @IsAdmin=1)
GO
ALTER AUTHORIZATION ON [dbo].[Users_Count] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Users_Get]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create   PROC [dbo].[Users_Get]
    @UserName VARCHAR(50)
as
select *
from UserP
where UserName=@UserName
GO
ALTER AUTHORIZATION ON [dbo].[Users_Get] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Users_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   proc [dbo].[Users_List]  @Search nvarchar(500), @UserName varchar(50), @IsAdmin bit, @PageNo int, @PageSize int
as
select * from UserP
where ( @Search is null or ( @Search is not null and( UserCode like N'%'+@Search+'%' or Name like N'%'+@Search+'%' or UserName like N'%'+@Search+'%')))
and (@UserName is null or (@UserName is not null and @UserName=UserName))
and (@IsAdmin is null or  @IsAdmin =0 or @IsAdmin=1)
order by CreatedDate desc
offset ((@PageNo-1)*@PageSize) rows fetch next  @PageSize rows only
GO
ALTER AUTHORIZATION ON [dbo].[Users_List] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Users_ListExport]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   proc [dbo].[Users_ListExport]
as
begin
			--------------------
		select ROW_NUMBER() OVER ( order by CreatedDate desc) AS [STT|STT|8|l],
			UserCode as [UserCode|Mã nhân viên|40|c],
			Name as [|Họ tên|40|c],
			UserName as [|Tài khoản|40|c],
			Position as [|Chức vụ|50|c],
			PhoneNumber as [|Số điện thoại|50|c],
			PhoneNumber as [|Email|50|c]
		from UserP 
		order by CreatedDate desc
	end
GO
ALTER AUTHORIZATION ON [dbo].[Users_ListExport] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Users_ListWork]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Users_ListWork]
as
select *
from UserP
GO
ALTER AUTHORIZATION ON [dbo].[Users_ListWork] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Work_Get]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Work_Get]
    @WorkCode VARCHAR(500)
as
select *
from Work
WHERE WorkCode=@WorkCode
GO
ALTER AUTHORIZATION ON [dbo].[Work_Get] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[Work_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[Work_List]
    @m_SearchText NVARCHAR(500),
    @StageId int
as
select *, (select Name
    from UserP
    WHERE UserId=(select UserId
    from WorkUser
    WHERE WorkRole=0 and WorkId=w.WorkId)) as[Name]
from [Work]  w
WHERE @StageId=StageId and ( @m_SearchText is null or ( @m_SearchText is not null and( WorkCode LIKE N'%'+@m_SearchText+'%' or WorkName LIKE N'%'+@m_SearchText+'%' or WorkDescription LIKE N'%'+@m_SearchText+'%' )))
GO
ALTER AUTHORIZATION ON [dbo].[Work_List] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[WorkCheck_Get]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[WorkCheck_Get]
    @WorkId int
as
select *
from WorkCheck
WHERE @WorkId= WorkId
GO
ALTER AUTHORIZATION ON [dbo].[WorkCheck_Get] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[YourCheck_Get]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[YourCheck_Get] @WorkId int
as 
select * from Work where @WorkId=WorkId 
GO
ALTER AUTHORIZATION ON [dbo].[YourCheck_Get] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[YourCheck_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[YourCheck_List]
    @m_SearchText NVARCHAR(500),
    @UserName VARCHAR(50)
as
SELECT *,
    (select ProjectName
    from Project
    where ProjectId= (select st.ProjectId
    from Stage st
    where st.StageId=w.StageId ) )as ProjectName,
    (select st.StageTarget
    from Stage st
    where st.StageId=w.StageId ) as StageTarget,
	(select UserId from WorkUser wu where wu.WorkId=w.WorkId and wu.WorkRole=0) as UserId,
	(select CheckResult from WorkCheck where WorkId=w.WorkId and UserId= (select UserId from UserP where UserName=@UserName)) as CheckResult
from Work  w
WHERE WorkId in ( select WorkId
from WorkUser
WHERE UserId= (select UserId
    from UserP
    where UserName=@UserName)and WorkRole=1) and ( @m_SearchText is null or ( @m_SearchText is not null and ( WorkCode like N'%'+@m_SearchText+'%' or WorkName like N'%'+@m_SearchText+'%' or WorkDescription like N'%'+@m_SearchText+'%')))
GO
ALTER AUTHORIZATION ON [dbo].[YourCheck_List] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[YourWork_List]    Script Date: 17/05/2024 11:16:34 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[YourWork_List]
    @m_SearchText NVARCHAR(500),
    @UserName VARCHAR(50)
as
SELECT *,
    (select ProjectName
    from Project
    where ProjectId= (select st.ProjectId
    from Stage st
    where st.StageId=w.StageId ) )as ProjectName,
    (select st.StageTarget
    from Stage st
    where st.StageId=w.StageId ) as StageTarget,
	(select UserId from WorkUser wu where wu.WorkId=w.WorkId and wu.WorkRole=0) as UserId 
from Work  w
WHERE WorkId in ( select WorkId
from WorkUser
WHERE UserId= (select UserId
    from UserP
    where UserName=@UserName) and WorkRole=0) and ( @m_SearchText is null or ( @m_SearchText is not null and ( WorkCode like N'%'+@m_SearchText+'%' or WorkName like N'%'+@m_SearchText+'%' or WorkDescription like N'%'+@m_SearchText+'%')))
GO
ALTER AUTHORIZATION ON [dbo].[YourWork_List] TO  SCHEMA OWNER 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id tin tức' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'News_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id người dùng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên tin tức' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'News_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hình ảnh' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Image'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nội dung' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Contents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chi tiết' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Details'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày đăng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày hết hạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'CreateIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trạng thái' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Trangthai'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Số thứ tự' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'STT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'IPcapnhat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Nguoicapnhat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Ngaycapnhat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người duyệt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Nguoiduyet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày duyệt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Ngayduyet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ip của người duyệt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'IPduyet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại tin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'IsType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id dự án' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã dự án' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên dự án' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày bắt đầu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày kết thúc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày hoàn thành' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trạng thái' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mô tả' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ProjectDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Project', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id giai đoạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã giai đoạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mục tiêu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageTarget'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày bắt đầu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày kết thúc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày hoàn thành' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trạng thái' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mô tả' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'StageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id dự án' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Stage', @level2type=N'COLUMN',@level2name=N'ProjectId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id token' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'Token_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên đăng nhập' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên người dùng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'Ngay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày hết hạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'NgayHet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên máy tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'FromDivice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'IP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quyền' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_Token', @level2type=N'COLUMN',@level2name=N'isDecentlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id nhân viên' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã nhân viên' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'UserCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên đăng nhập' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên nhân viên' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mật khẩu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vị trí' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'Position'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Số điện thoại' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'PhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Địa chỉ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'UserAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Phòng ban' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'DepartmentName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key mã hóa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'KeyEncript'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Admin' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'IsAdmin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id token' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'Token_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ảnh đại diện' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'Avatar'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quyền' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserP', @level2type=N'COLUMN',@level2name=N'isDecentlz'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id công việc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id giai đoạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'StageId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã công việc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên công việc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày bắt đầu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày kết thúc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày hoàn thành' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trạng thái' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mô tả' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hình ảnh' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'WorkImage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Số thứ tự' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Work', @level2type=N'COLUMN',@level2name=N'STT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id kiểm tra' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkCheck', @level2type=N'COLUMN',@level2name=N'WorkCheckId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kết quả' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkCheck', @level2type=N'COLUMN',@level2name=N'CheckResult'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkCheck', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkCheck', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id công việc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkCheck', @level2type=N'COLUMN',@level2name=N'WorkId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id người dùng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkCheck', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id công việc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'WorkId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id người dùng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vai trò' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'WorkRole'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày cập nhật' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkUser', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
USE [master]
GO
ALTER DATABASE [QuanLyDuAn] SET  READ_WRITE 
GO
