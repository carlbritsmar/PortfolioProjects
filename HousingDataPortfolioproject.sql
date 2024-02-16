-- Standardize date format

SELECT SaleDate, CONVERT(SaleDate,DATE)
FROM PortfolioProject.HousingData;

UPDATE HousingData
set SaleDate = DATE(SaleDate);


-- populate addresses
SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingData a
         JOIN HousingData b
              on a.ParcelID = b.ParcelID
                  AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE HousingData a
    JOIN HousingData b on a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Breaking out Address into Seperate columns (Adress, City, State)
-- Could also use PARSENAME with SQL SERVER
ALTER TABLE HousingData
    ADD (PropertySplitAdress NVARCHAR(255),
         PropertySplitCity NVARCHAR(255));


UPDATE HousingData
SET HousingData.PropertySplitAdress = SUBSTRING_INDEX(HousingData.PropertyAddress, ',', 1)
WHERE HousingData.PropertySplitAdress IS NULL;

UPDATE HousingData
SET HousingData.PropertySplitCity = SUBSTRING_INDEX(HousingData.PropertyAddress, ',', -1)
WHERE HousingData.PropertySplitCity IS NULL;


ALTER TABLE HousingData
    ADD (OwnerSplitAdress NVARCHAR(255),
         OwnerSplitCity NVARCHAR(255),
         OwnerSplitState NVARCHAR(255));

UPDATE HousingData
SET HousingData.OwnerSplitState = SUBSTRING_INDEX(HousingData.OwnerAddress, ',', -1)
WHERE HousingData.OwnerSplitState IS NULL;

UPDATE HousingData
SET HousingData.OwnerSplitAdress = SUBSTRING_INDEX(HousingData.OwnerAddress, ',', 1)
WHERE HousingData.OwnerSplitAdress IS NULL;

UPDATE HousingData
SET HousingData.OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(HousingData.OwnerAddress, ',', -2), ',', 1)
WHERE HousingData.OwnerSplitCity IS NULL;



-- change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (HousingData.SoldAsVacant), count(HousingData.SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant;

UPDATE HousingData
SET HousingData.SoldAsVacant =
        CASE WHEN HousingData.SoldAsVacant = 'y' THEN 'Yes'
             WHEN HousingData.SoldAsVacant = 'n' THEN 'No' Else SoldAsVacant END;


-- Remove Duplicates

WITH RowNumCTE as (
SELECT *,
       ROW_NUMBER() over (
           PARTITION BY ParcelID,
               PropertyAddress,
               SalePrice,
               SaleDate,
               LegalReference
           ORDER BY UniqueID
           )row_num

FROM HousingData
-- ORDER BY ParcelID
) DELETE
FROM RowNumCTE
WHERE row_num > 1;
-- ORDER BY PropertyAddress


-- Delete Unused Columns

SELECT * FROM HousingData;

ALTER TABLE HousingData
DROP COLUMN OwnerAddress;

ALTER TABLE HousingData
DROP COLUMN TaxDistrict;

ALTER TABLE HousingData
DROP COLUMN PropertyAddress;

ALTER TABLE HousingData
DROP COLUMN SaleDate;