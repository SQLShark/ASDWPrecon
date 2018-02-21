# LAB - 00. Setup lab
The following lab is everything that is required to get you up and running. 

------------------------------------------------------------------
To get connected via SSMS you will need the following address: 

```sql
Address: magicadventure.database.windows.net
Username : gandalf
Password: Password1234!
```

![GitHub Logo](/images/usersanddesks.png)

Once connected, please use your instance. We will give you each a number. 
If you are in seat 1, then you will connect to SQLBits2018User1

There are 70 instances so there is enough for everyone. 



-------------------------------------------------------------------

1 - Create a SQL Datawarehouse
 
Click New, then on "Databases"
 
![GitHub Logo](/images/AzureSQLDW.png)

SQL Server - in Azure you create a logical server to collect databases together - this isn't a real server but acts as a way of grouping your resources. You can perform some basic logging and server management from the logical server.
 
Complete the creation blade. The SQL Server can either be an existing one or created here.
 
<img src="https://github.com/SQLShark/ASDWPrecon/blob/master/images/AzureSQLDW_Config.png" height="500">
 
In this case, we've selected Sample. This will prepopulate the warehouse with the tables and data from the Adventureworks example!
 
By default, new servers don't allow anyone to access them. You need to amend the firewall rules and create an exception for your current connection. From your new SQLDW, click on the server name to open the server blade.
 
![GitHub Logo](/images/AzureSQLDW_Config2.png)
 
 
There are two links to the Firewall area from the server overview:
 
![GitHub Logo](/images/AzureSQLDW_Config3.png)

 
One the firewall properties are open, click the "Add Client IP" button then "Save". This will add an explicit exception for your current connection.
 
It's best practice to clear this down when you are done. Customer instances should have clean firewall rules!
 
<img src="https://github.com/SQLShark/ASDWPrecon/blob/master/images/AzureSQLDW_Config4.png" height="240">
 
You can now connect through management studio! If you log in with admin access to the SQL Server, you'll see the top level "master" database here too:
 

 
 
 
 
 
 
 

