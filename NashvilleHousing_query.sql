

  Select *
  From PortfolioProject.dbo.NashvilleHousing




  --Standardizing the date format: 
  Select SaleDate, CONVERT(Date,SaleDate) as Date
  From PortfolioProject.dbo.NashvilleHousing

  Update PortfolioProject.dbo.NashvilleHousing
  SET SaleDate = CONVERT(Date,SaleDate) 

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  Add Sale_Date Date;

  Update PortfolioProject.dbo.NashvilleHousing
  SET Sale_Date = CONVERT(Date,SaleDate)





 --Populate property address data where blank
 Select *
 From PortfolioProject.dbo.NashvilleHousing
 --Where PropertyAddress is null
 order by ParcelID

 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 From PortfolioProject.dbo.NashvilleHousing a
 Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null






--Breaking down the column 'Address' filled with city and state into their own individual columns (Address, City, State) 
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add Property_Address nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add Property_City nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) as Address
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) as City
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1) as State
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add Owner_Address nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add Owner_City nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add Owner_State nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From PortfolioProject.dbo.NashvilleHousing



--Changing data fields of 'Y' and 'N' to 'Yes' and 'No' in 'SoldAsVacant' field. 
Select Distinct(SoldAsVacant), Count(SoldAsVacant) as Vacant_Count
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant 
	END as Updated_SoldAsVacant
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END 


--Removing duplicate data to reduce redundancies 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
				UniqueID
				) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1



--Removing unused columns to make final touches and make the data more useable

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate


Select * 
From PortfolioProject.dbo.NashvilleHousing