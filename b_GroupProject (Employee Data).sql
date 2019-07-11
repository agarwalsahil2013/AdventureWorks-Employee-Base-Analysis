SELECT EPH.businessentityID, Rate into ##T3
FROM
(SELECT BusinessEntityID,max(Ratechangedate) as RateChangeDate
FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID) AS T1
JOIN HumanResources.EmployeePayHistory EPH on t1.BusinessEntityID=eph.BusinessEntityID 
			AND T1.RateChangeDate = EPH.RateChangeDate

select distinct p.businessentityid, p.firstname + ' ' + p.lastname as Name, p.middlename, h.HireDate, h.jobtitle, 
DATEDIFF(year,h.birthdate,GETDATE()) as Age,
(CASE WHEN DATEDIFF(year,h.birthdate,GETDATE()) between 20 and 30 THEN '20-30'
		WHEN DATEDIFF(year,h.birthdate,GETDATE()) BETWEEN 31 and 40 THEN '31-40'
		WHEN DATEDIFF(year,h.birthdate,GETDATE()) BETWEEN 41 and 50 THEN '41-50'
		WHEN DATEDIFF(year,h.birthdate,GETDATE()) BETWEEN 51 and 60 THEN '51-60'
		WHEN DATEDIFF(year,h.birthdate,GETDATE()) >60 THEN '61+' END) as AgeGroup,
 h.maritalstatus, h.gender,d.groupname, dh.startdate, dh.enddate, s.salesquota, s.bonus, s.commissionpct, 
s.salesytd, s.saleslastyear, sp.name, sp.countryregioncode, ##T3.rate
from Person.Person as p
join humanresources.employee as h on p.businessentityid = h.businessentityid
left join sales.salesperson as s on p.businessentityid = s.businessentityid
join humanresources.employeedepartmenthistory as dh on dh.businessentityid = p.businessentityid
join humanresources.department as d on dh.departmentid = d.departmentid
join person.businessentityaddress as ba on p.businessentityid = ba.businessentityid
join person.Address as a on ba.AddressID = a.AddressID
join person.StateProvince as sp on a.StateProvinceID = sp.StateProvinceID
join humanresources.employeepayhistory as pr on p.businessentityid = pr.businessentityid
JOIN  ##T3 on p.businessentityid= ##T3.businessentityid
where dh.enddate is null and sp.countryregioncode = 'US'