select sales.salesorderdetail.salesorderid, sum(sales.salesorderdetail.orderqty) as TotalQty into #TotalQty from sales.salesorderdetail
join sales.salesorderheader on sales.salesorderdetail.salesorderid = sales.salesorderheader.salesorderid
where sales.salesorderdetail.salesorderid=sales.salesorderheader.salesorderid
group by sales.salesorderdetail.salesorderid


select distinct p.businessentityid, p.firstname + ' ' + p.lastname as Name, h.jobtitle, 
d.groupname, oh.salesorderid, oh.orderdate, oh.totaldue, oh.subtotal, t.totalqty, st.name as Territory, sp.name as State, sp.countryregioncode
from Person.Person as p
join humanresources.employee as h on p.businessentityid = h.businessentityid
join humanresources.employeedepartmenthistory as dh on dh.businessentityid = p.businessentityid
join humanresources.department as d on dh.departmentid = d.departmentid
left join sales.salesorderheader as oh on oh.salespersonid = p.businessentityid
join sales.salesorderdetail as o on o.salesorderid = oh.salesorderid
join #totalqty as t on t.salesorderid = oh.salesorderid
join sales.salesterritory as st on st.territoryid = oh.territoryid
join person.businessentityaddress as ba on p.businessentityid = ba.businessentityid
join person.Address as a on ba.AddressID = a.AddressID
join person.StateProvince as sp on a.StateProvinceID = sp.StateProvinceID
where sp.countryregioncode = 'US'