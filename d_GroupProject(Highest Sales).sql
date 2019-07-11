SELECT sales.salesterritory.name as Territory, Firstname+''+Lastname as Name,sum(Totaldue) as sum_of_TotalDue,
		Person.StateProvince.countryregioncode INTO #T1
FROM sales.salesorderheader
JOIN Person.Person on sales.salesorderheader.salespersonid = person.person.businessentityid
JOIN sales.salesterritory on sales.salesorderheader.territoryid = sales.salesterritory.territoryid
join person.businessentityaddress on person.person.businessentityid = person.businessentityaddress.businessentityid
join person.Address on person.businessentityaddress.AddressID = person.address.AddressID
JOIN Person.StateProvince on person.address.stateprovinceID = person.stateprovince.stateprovinceID
GROUP BY sales.salesterritory.name ,Firstname+''+Lastname,Person.StateProvince.countryregioncode
HAVING Person.StateProvince.countryregioncode='US'

SELECT Territory,max(sum_of_TotalDue) as Employee_max INTO #T2
FROM (SELECT sales.salesterritory.name as Territory, Firstname+''+Lastname as Name,sum(Totaldue) as sum_of_TotalDue,
		Person.StateProvince.countryregioncode
FROM sales.salesorderheader
JOIN Person.Person on sales.salesorderheader.salespersonid = person.person.businessentityid
JOIN sales.salesterritory on sales.salesorderheader.territoryid = sales.salesterritory.territoryid
join person.businessentityaddress on person.person.businessentityid = person.businessentityaddress.businessentityid
join person.Address on person.businessentityaddress.AddressID = person.address.AddressID
JOIN Person.StateProvince on person.address.stateprovinceID = person.stateprovince.stateprovinceID
GROUP BY sales.salesterritory.name ,Firstname+''+Lastname,Person.StateProvince.countryregioncode
HAVING Person.StateProvince.countryregioncode='US') as a
GROUP BY territory

SELECT #T1.Territory,Name,Employee_max
FROM #T1
JOIN #T2 on #T2.territory=#T1.territory AND #T2.Employee_max=#T1.sum_of_totalDue