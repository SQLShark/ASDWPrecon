# Azure Sql Data Warehouse Training Materials

Welcome to SQLBits. We hope that you have a magical time. 
As we move through the day you will be asked to complete a series of labs. You will find all the resources required to complete the labs on this GitHub Repository. 
You can choose to either copy the files directly from GitHub, download or fork and set up a local repo on your machine. For ease I recommend downloading the lot. 

We appreciate that this is not an easy topic to absorb in a single day. As such we have a few games and quizzes we will play through out the day, so make sure that you pay attention for a chance to win some prizes. We might also ask you to move around, if you're not able to/wish not to participate, please let us know (it's just a bit of fun).

This Github repo will be available when you next need it. As material changes, we endeavour to keep this up-to-date. If there is something you think should be added, please make branch the codebase and submit a pull request. 

## Agenda
- Introduction
- Service Architecture
- Designing Tables
- Data loading performance
- Querying data
- Extending the data warehouse and patterns
- Closing slides

We will have breaks at around 10:00, 12:00 and 15:00. 

## Labs
This session is designed to be a hands on workshop. You will get a mixture of Theory and real world solutions.
To back this up we have a series of labs. 
- [000 - Connecting to Azure SQL Data Warehouse](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_00)
- [001 - Creating a New Instance of Azure SQL Data Warehouse](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_01)
- [002 - Monitoring data skew](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_02)
- [003 - Redistributing data](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_03)
- [004 - Loading data with Polybase](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_04)
- [005 - Managing surrogate keys](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_05)
- [006 - Performance DMV and EXPLAIN](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_06)
- [007 - Performance tuning](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_07)

Each lab will last less than 20 minutes. If you're not able to complete the lab in time, there will either be a procedure you can run to get you up to date, or a script to run. 

## Tools required for today
These labs require tools most Azure developers have on their development machines. They do need to be the latest edition for some of the new features to work. 

Can you please ensure that you have the following installed. 
- SQL Server Management Studio 17+ (17.5 is best) download [here](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- Visual Studio 17
OR Vscode
- Azure Storage Explorer download [here](https://azure.microsoft.com/en-us/features/storage-explorer/)
- PowerShell - We wont do any labs in PowerShell, but there is content for you to use. 

## Structure of GitHub 
- Slides - You will find the latest version of all the slides located [here](https://github.com/SQLShark/ASDWPrecon/tree/master/Slides). 
- MagicWorks - We will use a very magical version of Adventure Works for all our demos. All files required are located in blob storage and also in their relevant files. You do not need to run these scripts, they are for reference only. 
- Labs - All the labs we will run through during this session. 
- Code Examples - You will see as we go through the session a lot of code in the slides. Rather than copying this from the slides, all content is here too. 
- Images - All the images used as documentation in labs.  

## The Slack Channel
Slack is a great resource for you to ask questions as we are going. 
Feel free to stop the speakers and ask a question, however if there is something that is not clear to you or you want to share something with the group you can do so in Slack. 
Terry will monitor the slack channel all day answering questions helping where needed. 

This Slack channel will be available for 12 weeks after the session has finished. If you start working with Azure SQL Data Warehouse and you have questions or you need support, we will be able to help you. 

### How to access the Slack Channel? 
You will need to register. Follow the link below to register. 
https://join.slack.com/t/sqlbits-azure-sqldw/shared_invite/enQtMzEwNTc2NDQyMzc1LWM5ZGJjOTA0ZWFlMjE3ZTdjNGJjYmI0N2I0OTkxMDczY2MwN2ZmZGE4MmEyMWU2YmUxNmYxOTBiYmE4YjYxYjI

Slack has both a web version and a desktop version. You can download the desktop version here: 
https://slack.com/

## Connecting to the Demo Azure SQLDW. 
If you do not have an Azure subscription, you can connect to a version we have published already. 
Terry will come and ask you if you require access to this before we start. You will be given a Server to connect to, a username and password. If you have problems connecting please let me know either in person or on Skype. 
This environment will only be available for today. Please do not scale Azure SQLDW beyond 400DWU. There is a job running to check for instances running more than 400 DWU and they will automatically scale down to 100 DWU. This takes time and as a result you will be delayed slightly. 

Details about how to connect to Azure SQLDW are listed in [LAB_000](https://github.com/SQLShark/ASDWPrecon/tree/master/Labs/LAB_00)

## About the speakers
There are business cards for all speakers on the desk at the front. 

### James Rowland-Jones Principal Program Manager - Microsoft
James Rowland-Jones (JRJ) is a Principal Program Manager at Microsoft. He is part of the Azure SQL Data Warehouse team and is passionate about delivering highly scalable solutions that are creative, simple and elegant in their design. JRJ is also a keen advocate for the worldwide SQL community. He has previously served on the Board of Directors for PASS and helped organise SQLBits. James was awarded Microsoft’s MVP accreditation from 2008 - 2015 for his services to the community. Yesterday it was James' birthday. Make sure you with him a very happy birthday. 

You can contact James on Twitter [@jrowlandjones](https://twitter.com/jrowlandjones)

### Terry McCann | Principal Consultant - Adatis
Terry has about 10 years experience implementing data warehouses and has delivered Azure Data warehouse projects on behalf of Adatis Consulting Limited to some of the UK's largest Azure consumers. If you want to know more about these projects or Adatis, make sure that you visit our stand through out the conference. 

Microsoft Data Platform MVP. Principal Data Science & Advanced Analytics Consultant for Adatis Consulting Limited a Microsoft Data & Analytics consultancy in the UK. Data Science Master's degree, organizer of the Data Science Exeter user group, frequent speaker at conferences across the world. 

You can contact Terry here: tpm@adatis.co.uk or via [@SQLShark](https://twitter.com/SQLShark) on Twitter

### Simon Whiteley | Chief Cloud Architect - Adatis
Simon is technical lead for Adatis, driving their adoption of new architectures and leading Research & Development within the company. He has over a decade of analytics experience, largely within the Microsoft realm and has been pushing distributed cloud architectures for analytics for the past few years.

A newly-minted Microsoft Data Platform MVP, Simon runs the SQLSurrey PASS Chapter, speaks at a variety of conferences and user groups throughout the UK and Europe and will happily talk your ear off about the various new approaches we're currently working on.

You can contact Simon here: saw@adatis.co.uk or via [@MrSiWhiteley](https://twitter.com/MrSiWhiteley) on Twitter

### Links mentioned during the talk. 

- https://docs.microsoft.com/en-us/azure/sql-data-warehouse/resource-classes-for-workload-management
- https://docs.microsoft.com/en-us/azure/sql-data-warehouse/sql-data-warehouse-manage-monitor
- http://download.microsoft.com/download/F/8/6/F8654654-6784-48F5-83C0-2D46186EEC66/Data_Warehouse_Fast_Track_Reference_Guide_for_SQL_Server_2016_EN_US.pdf
- https://www.amazon.co.uk/Big-Data-Principles-practices-scalable/dp/1617290343/ref=sr_1_1?ie=UTF8&qid=1519221273&sr=8-1&keywords=big+data+nathan+marz
Simon Talking about the process of Lambda in Azure. 
- https://www.youtube.com/watch?v=lcFDrIbTyxE
Additional links for CTAS statements
- http://blogs.adatis.co.uk/simonwhiteley/post/Azure-SQLDW-CTAS-Statements
- https://channel9.msdn.com/Shows/Cortana-Intelligence-Corner/Loading-data-into-Azure-SQL-Datawarehouse
- https://azure.microsoft.com/en-gb/blog/introducing-select-into-in-azure-sql-data-warehouse/
When should I use Azure SQL Data Warehouse? 
- https://www.blue-granite.com/blog/is-azure-sql-data-warehouse-a-good-fit