--Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject..NashvilleHousing;

--Standardize Date Format

SELECT saleDateConverted, CAST(SaleDate AS date)
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD saleDateConverted Date;

UPDATE NashvilleHousing
SET saleDateConverted = CAST(SaleDate AS date);

--Populate Property Address data

SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID
--WHERE PropertyAddress IS NULL;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Breaking out Address into Individual Columns (Address, City, State)

SELECT *
FROM PortfolioProject..NashvilleHousing;

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) -1, LEN(PropertyAddress)) AS address
FROM PortfolioProject..NashvilleHousing;

--Deleting columns
ALTER TABLE NashvilleHousing
DROP COLUMN PropertySplitStr, PropertySplitCity;


ALTER TABLE NashvilleHousing
ADD PropertySplitStr VARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitStr = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity VARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) -1, LEN(PropertyAddress));


SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing;

SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitStr VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitStr = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

SELECT *
FROM PortfolioProject..NashvilleHousing;


--Change Y and N to Yes and No in 'Sold as Vacant' field

SELECT DISTINCT SoldAsVacant, COUNT(*)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(*);

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'N' THEN 'NO'
		 WHEN SoldAsVacant = 'Y' THEN 'YES'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'N' THEN 'NO'
		 WHEN SoldAsVacant = 'Y' THEN 'YES'
		 ELSE SoldAsVacant
		 END


--Remove Duplicates
WITH RowNumCTE AS (SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY ParcelID,
						 PropertyAddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
						 ORDER BY 
							uniqueID
							) AS row_num
FROM PortfolioProject.dbo.NashvilleHousing)

--DELETE FROM RowNumCTE WHERE row_num > 1; 

SELECT *
FROM RowNumCTE
WHERE row_num > 1;


--Delete Unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate;