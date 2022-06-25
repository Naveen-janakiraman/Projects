
-- Question 1
SELECT DATENAME(month,[HireDate]) as month ,count(*) as no_of_employees
from [AdventureWorks2019].[HumanResources].[Employee] 
group by DATENAME(month,[HireDate])


-- Question 2

select D.name,count(E.LoginID) as no_employees ,Year([HireDate]) as year
from [AdventureWorks2019].[HumanResources].[Employee] as E
left join [AdventureWorks2019].[HumanResources].[EmployeeDepartmentHistory] as ED
on E.[BusinessEntityID] = ED.[BusinessEntityID]
left join [AdventureWorks2019].[HumanResources].[Department] D
on D.[DepartmentID]=ED.[DepartmentID]
group by D.name,Year([HireDate])


-- question 3

select P.FirstName , CR.Name
from [AdventureWorks2019].[HumanResources].[Employee] as E
left join [AdventureWorks2019].[Person].[Person] P
on E.[BusinessEntityID] <> P.[BusinessEntityID]
left join [AdventureWorks2019].[Person].[BusinessEntityAddress] as BEA
on P.[BusinessEntityID] = BEA.[BusinessEntityID]
left join [AdventureWorks2019].[Person].[Address] A
on A.[AddressID]= BEA.[AddressID]
left join [AdventureWorks2019].[Person].[StateProvince] SP
on SP.[StateProvinceID]=A.[StateProvinceID]
left join [AdventureWorks2019].[Person].[CountryRegion] CR
on CR.[CountryRegionCode] = SP.[CountryRegionCode]
where P.FirstName like 'S%'


-- Q4

select MN.[OrganizationLevel],MN.[JobTitle],MN.Name 
from (select A.[OrganizationLevel],A.[JobTitle],concat(P.[FirstName],' ',P.[LastName]) as Name,count(B.[OrganizationLevel])
from [AdventureWorks2019].[HumanResources].[Employee] A
left join [AdventureWorks2019].[HumanResources].[Employee] B
on A.[OrganizationLevel] = B.[OrganizationLevel]
left join [AdventureWorks2019].[Person].[Person] P
on A.[BusinessEntityID]=P.[BusinessEntityID]
group by A.[OrganizationLevel],A.[JobTitle],concat(P.[FirstName],' ',P.[LastName])
order by A.[OrganizationLevel]) MN


-- Q5

SELECT P.[ProductID] ,P.[Name],E.[TransactionDate],
(select SUM(Q.[Quantity])   
 from [AdventureWorks2019].[Production].[TransactionHistory]  Q 
 where(P.[ProductID]=Q.[ProductID])) As "Cumulative Quantity",
 (select SUM(Q.[ActualCost]) from [AdventureWorks2019].[Production].[TransactionHistory]  Q where(P.[ProductID]=Q.[ProductID])) As "Cumulative Quantity"
FROM [AdventureWorks2019].[Production].[Product] as P
left JOIN  [AdventureWorks2019].[Production].[TransactionHistory]  E 
ON (P.[ProductID]=E.[ProductID])

-- Q9

SELECT CRC.CountryRegionCode, CR.ModifiedDate, CR.EndOfDayRate,
DENSE_RANK() OVER(Partition by CR.ModifiedDate Order BY EndOfDayRate) as Rank
FROM [Sales].CountryRegionCurrency CRC
inner JOIN [Sales].CurrencyRate CR
on CRC.CurrencyCode=CR.ToCurrencyCode;


--Q10

SELECT  P.Name, CC.CreditCardID,SOH.SalesOrderID, CC.ExpMonth,  SOH.OrderDate 
FROM [Sales].[CreditCard] as CC
JOIN [Sales].[SalesOrderHeader] SOH
ON CC.CreditCardID=SOH.CreditCardID
JOIN [Sales].[SalesOrderDetail] as SOD
ON SOD.SalesOrderID=SOH.SalesOrderID
JOIN [Production].Product as P
On SOD.ProductID=P.ProductID
WHERE CC.ExpMonth=Month(SOH.OrderDate);
