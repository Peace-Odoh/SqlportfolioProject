SELECT * FROM PortfolioProject..NashvilleHousing

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

SELECT SaleDateConverted 
FROM  PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add saledateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress is not null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing  b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is  null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing  b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is  null

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is not null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX( ',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX( ',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar (255)

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX( ',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar (255)

Update Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar (255)

Update Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT Distinct(SoldAsVacant), Count(soldasvacant)
 FROM PortfolioProject..NashvilleHousing
 group by SoldAsVacant
 order by 2



 SELECT SoldAsVacant
 , CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
 FROM PortfolioProject..NashvilleHousing

 UPDATE NashvilleHousing
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

SELECT *
FROM PortfolioProject..NashvilleHousing

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
FROM PortfolioProject..NashvilleHousing
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM PortfolioProject..NashvilleHousing

AlTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAdDress, TaxDistrict, PropertyAddress

AlTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
