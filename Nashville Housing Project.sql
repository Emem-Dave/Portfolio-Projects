select * from [Nashville Housing]


select SaleDateconverted, convert(date,saledate)
from [Nashville Housing]

update [Nashville Housing]
set saledate = convert(date,saledate)

alter table [Nashville Housing]
add SaleDateConverted Date;

update [Nashville Housing]
set saledateconverted = convert(date,saledate)



--Property address

select*
from [Nashville Housing]
--where propertyaddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [Nashville Housing]
----where propertyaddress is null
--order by ParcelID

select 
SUBSTRING(propertyaddress,1,charindex(',', propertyaddress)-1) as address
,SUBSTRING(propertyaddress,charindex(',', propertyaddress)+1, len(propertyaddress)) as address


alter table [Nashville Housing]
add propertyspiltaddress nvarchar(255);

update [Nashville Housing]
set  propertyspiltaddress = SUBSTRING(propertyaddress,1,charindex(',', propertyaddress)-1) 


alter table [Nashville Housing]
add propertyspiltCity  nvarchar(255);

update [Nashville Housing]
set propertyspiltCity = SUBSTRING(propertyaddress,charindex(',', propertyaddress)+1, len(propertyaddress)) 


select * from [Nashville Housing]


from [Nashville Housing]


--For Owner Address



select owneraddress
from [Nashville Housing]



select 
parsename(replace(owneraddress, ',', '.'), 3),
parsename(replace(owneraddress, ',', '.'), 2),
parsename(replace(owneraddress, ',', '.'), 1)
from [Nashville Housing]


ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from [Nashville Housing]


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct (soldasvacant), count(soldasvacant)
from [Nashville Housing]
group by SoldAsVacant
order by 2


select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant 
	 end
from [Nashville Housing]

update [Nashville Housing]
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant 
	 end

--Remove Duplicates

with rownumcte as (
select *,
ROW_NUMBER() over ( 
partition by parcelID,
             propertyaddress,
			 saleprice,
			 saledate,
			 legalreference

			 order by 
			     uniqueID
				 ) row_num

from [Nashville Housing]
--order by parcelID
)
select * from rownumcte
where row_num > 1
order by propertyaddress





-- Delete Unused Columns


Select *
From [Nashville Housing]


ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

