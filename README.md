# SQL Server User Permissions Script
This script generates SQL commands to display the permissions of a specified user within all databases on a SQL Server instance, excluding the system databases (master, tempdb, model, msdb).

# Overview
The script iterates through each database and, for the specified user, generates SQL commands to:

# Add the user to the appropriate roles.
Grant object-level permissions.
Grant database-level permissions.
The script prints the generated SQL commands, which can be executed manually or saved for future use.

# Requirements
SQL Server instance with access to sysadmin or equivalent permissions.
A user (login) already created on the SQL Server instance.
Usage
Copy the entire script and paste it into SQL Server Management Studio (SSMS) or your preferred SQL Server query tool.
Replace 'johndoe' in the DECLARE @UserName sysname = 'johndoe'; line with the user (login) for which you want to generate the permissions script.
Run the script. It will print the SQL commands for the specified user's permissions in each database.
Review the printed SQL commands, and if needed, execute them manually or save them for future use.
Note: Before executing the generated SQL commands on a production environment, please review them carefully and ensure that they meet your requirements. It's always a good practice to test the script on a non-production environment first.
