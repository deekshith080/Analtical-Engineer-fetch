use sampledb;

DROP TABLE User;
CREATE TABLE User (
    ID varchar(50),
    Active varchar(50),
    CreatedDate DATE,
    LastLogin DATE,
    Role varchar(50),
	SignUpSource varchar(50),
	State varchar(50),
    PRIMARY KEY (ID)
);
INSERT INTO `sampledb`.`User`
(`ID`,`Active`,`CreatedDate`,`LastLogin`,`Role`,`SignUpSource`,`State`)
VALUES
("Deekshith@25435","Active",CURDATE(),CURDATE(),"Admin","Partner Site","GLENLIVET®");

DROP TABLE Receipts;
CREATE TABLE Receipts (
    ID varchar(50),
    BonusPointsEarned int,
    BonusPointsEarnedReason varchar(50),
    CreatedDate DATE,
	DateScanned DATE,
	FinishedDate DATE,
	ModifiedDate DATE,
	PointsAwardedDate DATE,
	PointsEarned int,
	PurchaseDate DATE,
	PurchasedItemCount int,
    RewardReceiptStatus varchar(50),
	TotalSpent int,
	UserId varchar(50),
    PRIMARY KEY (ID)
);

INSERT INTO `sampledb`.`Receipts`
(`ID`,`BonusPointsEarned`,`BonusPointsEarnedReason`,`CreatedDate`,`DateScanned`,`FinishedDate`,`ModifiedDate`,
`PointsAwardedDate`,`PointsEarned`,`PurchaseDate`,`PurchasedItemCount`,`RewardReceiptStatus`,`TotalSpent`,`UserId`)
VALUES
('receipt_id', 100, 'Bonus Reason', CURDATE(), CURDATE(), CURDATE(), CURDATE(),
CURDATE(), 50, CURDATE(), 5, 'Approved', 500, 'Deekshith@25435');

DROP TABLE Brand;
CREATE TABLE Brand (
    ID varchar(50),
    BarCode varchar(50),
	BrandCode varchar(50),
	Category varchar(50),
	CategoryCode varchar(50),
	Name varchar(50),
	TopBrand Boolean,
    PRIMARY KEY (ID)
);
INSERT INTO `sampledb`.`Brand`
(`ID`,`BarCode`,`BrandCode`,`Category`,`CategoryCode`,`Name`,`TopBrand`)
VALUES
("601c5460be37ce2ead43755f","511111519928","STARBUCKS","Beverages","BEVERAGES","Starbucks",false);

DROP TABLE RewardsRecepientItem;
CREATE TABLE RewardsRecepientItem (
    ID varchar(50),
    Description varchar(50),
    DiscountedItemPrice int,
    FinalPrice int,
	ItemPrice int,
	NeedsFetchReview Boolean,
	OriginalRecepientsItemText varchar(50),
	PartnerItemID varchar(50),
	QuantityPurchased int,
	BrandId varchar(50),
    ReceiptId varchar(50),
    PRIMARY KEY (ID)
);

DROP TABLE CPG;
CREATE TABLE CPG (
    ID varchar(50),
	REF varchar(50),
    PRIMARY KEY (ID)
);
INSERT INTO `sampledb`.`CPG`
(`ID`,`REF`)VALUES("Deekshith@25435","4323");

#What are the top 5 brands by receipts scanned for most recent month?

SELECT r.ID, rri.BrandID, rri.description  FROM receipts r INNER JOIN RewardsRecepientItem rri
ON r.id = rri.receiptid where r.dateScanned BETWEEN NOW() - INTERVAL 30 DAY and NOW() 
group by r.ID, rri.BrandID, rri.description order by count(r.userid) DESC LIMIT 5;

#How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

SELECT r.ID, rri.BrandID, rri.description FROM receipts r INNER JOIN RewardsRecepientItem rri
ON r.id =  rri.receiptid where r.dateScanned BETWEEN NOW() - INTERVAL 60 DAY AND NOW() - INTERVAL 30 DAY 
group by r.ID, rri.BrandID, rri.description order by count(r.userid) DESC LIMIT 5;

ALTER TABLE Receipts ADD FOREIGN KEY (userID) REFERENCES User(ID);
ALTER TABLE RewardsRecepientItem ADD FOREIGN KEY (ReceiptID) REFERENCES Receipts(ID);
ALTER TABLE RewardsRecepientItem ADD FOREIGN KEY (brandID) REFERENCES Brand(ID);
ALTER TABLE CPG ADD FOREIGN KEY (ref) REFERENCES Brand(ID);

#Data validation checks
    
SELECT * FROM Receipts WHERE STR_TO_DATE(CreatedDate, '%d,%m,%Y') = NULL;
SELECT * FROM Receipts WHERE STR_TO_DATE(DateScanned, '%d,%m,%Y') = NULL; 
SELECT * FROM Receipts WHERE STR_TO_DATE(FinishedDate, '%d,%m,%Y') = NULL;
SELECT * FROM Receipts WHERE STR_TO_DATE(ModifiedDate, '%d,%m,%Y') = NULL;
SELECT * FROM Receipts WHERE STR_TO_DATE(PointsAwardedDate, '%d,%m,%Y') = NULL;
SELECT * FROM Receipts WHERE STR_TO_DATE(PurchaseDate, '%d,%m,%Y') = NULL;
SELECT * FROM User WHERE STR_TO_DATE(CreatedDate, '%d,%m,%Y') = NULL;
SELECT * FROM User WHERE STR_TO_DATE(LastLogin, '%d,%m,%Y') = NULL;

#General query for duplicate checks:
SELECT column_name, COUNT(*) FROM table_name GROUP BY column_name HAVING COUNT(*) > 1;

#General query for missing value checks:
SELECT * FROM table_name WHERE column_name IS NULL;

#General query for Validating Referential Integrity
SELECT * FROM child_table WHERE foreign_key_column NOT IN (SELECT primary_key_column FROM parent_table);

#example for our exercise
SELECT * FROM Receipts WHERE userId NOT IN (SELECT id FROM User);

#Check for Inconsistent Formats:
SELECT * FROM table_name WHERE column_name NOT LIKE 'expected_format%';

# Other points to consider in data checks :

#1. Checks for Missing Values: null or blank values
#2. Identify Duplicates:
#3. Checks Data Types:
#4. Look for Outliers: <data range>
#5. Checks for Inconsistent Formats:
#6. Validation for Referential Integrity: