# Azure SQL DataWarehouse Manager

This suite of reports pulls from several system views to provide performance monitoring and general management of an Azure SQL DataWarehouse server.

In order to use them, you will need to deploy them to an SSRS instance, either in Azure or on-premise, and modify the central connection manager to point to your SQLDW instance.

## Overview

This high-level report gives you some basic management information - how many people are currently using the server, what is the current service objective and how many slots are currently available. How well is data distributed on the server?

## Activity Monitor

This report mirrors the traditional SSMS report many people will be familiar with. It shows recent expensive queries, queries with blockers and the top drains on the SQL and DMS engines respectively.

## Polybase Reader

This report is designed specifically for load monitoring of external tables. It queries for any queries that are currently utilising external data readers and shows the total amount read so far, the approximate read speed and an estimated remaining load time.

## Execution Explorer

Here we have simply put a wrapper around the performance management system views to show all recent query executions and the impact they had on each distribution. This can help identify recent performance issues and target the data movement responsible.
