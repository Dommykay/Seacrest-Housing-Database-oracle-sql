/* Dropping every table */
DROP TABlE IF EXISTS ViewingBuyer;
DROP TABlE IF EXISTS ViewingEmployee;
DROP TABlE IF EXISTS Viewing;
DROP TABlE IF EXISTS Sale;
DROP TABlE IF EXISTS Room;
DROP TABlE IF EXISTS RoomTypeDropdown;
DROP TABlE IF EXISTS PropertyType;
DROP TABlE IF EXISTS PropertyTypeDropdown;
DROP TABlE IF EXISTS Property;
DROP TABlE IF EXISTS EmployeeContact;
DROP TABlE IF EXISTS Employee;
DROP TABlE IF EXISTS BranchContact;
DROP TABlE IF EXISTS PropertyOwnerContact;
DROP TABlE IF EXISTS PropertyOwner;
DROP TABlE IF EXISTS BuyerInterests;
DROP TABlE IF EXISTS BuyerContact;
DROP TABlE IF EXISTS InterestsTypeDropdown;
DROP TABlE IF EXISTS ContactTypeDropdown;
DROP TABlE IF EXISTS Buyer;
DROP TABlE IF EXISTS Branch;

/* Main table for company branches */

CREATE TABLE Branch (
    BranchID NUMBER(4),
    branch_name VARCHAR2(30),
    branch_address VARCHAR2(30),
    PRIMARY KEY (BranchID)
);

/* Main table for buyers */

CREATE TABLE Buyer (
    BuyerID NUMBER(6),
    buyer_firstname VARCHAR2(20),
    buyer_lastname VARCHAR2(20),
    PRIMARY KEY (BuyerID)
);

/* Dropdown table for contact types, like phone number, landline, email, fax, ect */

CREATE TABLE ContactTypeDropdown (
    ContactTypeItemID NUMBER(3),
    contact_type VARCHAR2(20),
    PRIMARY KEY (ContactTypeItemID)
);

/* Dropdown table for interest types, like price range, location, house type, ect */

CREATE TABLE InterestsTypeDropdown (
    InterestsTypeID NUMBER(4) PRIMARY KEY,
    interests_type VARCHAR2(20)
);

/* Link table between buyer and contact type tables */

CREATE TABLE BuyerContact (
    BuyerContactID NUMBER(6) PRIMARY KEY,
    BuyerID NUMBER(6),
    ContactTypeItemID NUMBER(3),
    buyer_contactinfo VARCHAR2(30),
    FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID),
    FOREIGN KEY (ContactTypeItemID) REFERENCES ContactTypeDropdown(ContactTypeItemID)
);

/* Link table between buyer and interest type tables */

CREATE TABLE BuyerInterests (
    BuyerInterestsID NUMBER(6) PRIMARY KEY,
    BuyerID NUMBER(6),
    InterestsTypeID NUMBER(4),
    buyerinterests_info VARCHAR2(30),
    FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID),
    FOREIGN KEY (InterestsTypeID) REFERENCES InterestsTypeDropdown(InterestsTypeID)
);

/* Main table for owners table, would have named just owners but apparently thats a keyword */

CREATE TABLE PropertyOwner (
    PropertyOwnerID NUMBER(6),
    propertyowner_firstname VARCHAR2(20),
    propertyowner_lastname VARCHAR2(20),
    PRIMARY KEY (PropertyOwnerID)
);

/* Link table between property owner and contact type tables */

CREATE TABLE PropertyOwnerContact (
    PropertyOwnerContactID NUMBER(7) PRIMARY KEY,
    PropertyOwnerID NUMBER(6),
    ContactTypeItemID NUMBER(4),
    propertyowner_contactinfo VARCHAR2(30),
    FOREIGN KEY (PropertyOwnerID) REFERENCES PropertyOwner(PropertyOwnerID),
    FOREIGN KEY (ContactTypeItemID) REFERENCES ContactTypeDropdown(ContactTypeItemID)
);

-- Link table between branch and contact type tables

CREATE TABLE BranchContact (
    BranchContactID NUMBER(6) PRIMARY KEY,
    BranchID NUMBER(4),
    ContactTypeItemID NUMBER(4),
    branch_contactinfo VARCHAR2(30),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (ContactTypeItemID) REFERENCES ContactTypeDropdown(ContactTypeItemID)
);

/* Main table for employees */

CREATE TABLE Employee(
    EmployeeID NUMBER(6),
    BranchID NUMBER(4),
    employee_firstname VARCHAR2(20),
    employee_lastname VARCHAR2(20),
    employee_address VARCHAR2(30),
    employee_dob DATE,
    employee_nin VARCHAR2(9),
    employee_sal NUMBER(7,2),
    employee_startdate DATE,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

/* Link table between employee and contact type tables */

CREATE TABLE EmployeeContact (
    EmployeeContactID NUMBER(7),
    EmployeeID NUMBER(6),
    ContactTypeItemID NUMBER(3),
    employee_contactinfo VARCHAR2(30),
    PRIMARY KEY (EmployeeContactID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ContactTypeItemID) REFERENCES ContactTypeDropdown(ContactTypeItemID)
);

/* Main table for properties */

CREATE TABLE Property (
    PropertyID NUMBER(7),
    BranchID NUMBER(4),
    PropertyOwnerID NUMBER(6),
    property_address VARCHAR2(30),
    property_askingprice NUMBER(10,2),
    property_length NUMBER(5,3),
    property_width NUMBER(5,3),
    PRIMARY KEY (PropertyID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (PropertyOwnerID) REFERENCES PropertyOwner(PropertyOwnerID)
);

-- Dropdown table for property types

CREATE TABLE PropertyTypeDropdown (
    PropertyTypeItemID NUMBER(4),
    property_type VARCHAR2(20),
    PRIMARY KEY (PropertyTypeItemID)
);

-- Link table between property types and properties

CREATE TABLE PropertyType (
    PropertyTypeID NUMBER(4),
    PropertyID NUMBER(7),
    PropertyTypeItemID NUMBER(4),
    PRIMARY KEY (PropertyTypeID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (PropertyTypeItemID) REFERENCES PropertyTypeDropdown(PropertyTypeItemID)
);

-- Dropdown table for room types

CREATE TABLE RoomTypeDropdown (
    RoomTypeID NUMBER(4),
    room_type VARCHAR2(20),
    PRIMARY KEY (RoomTypeID)
);

-- Main table for every room in a property

CREATE TABLE Room (
    RoomID NUMBER(8),
    PropertyID NUMBER(7),
    RoomTypeID NUMBER(4),
    room_windows NUMBER(2),
    room_length NUMBER(5,3),
    room_width NUMBER(5,3),
    PRIMARY KEY (RoomID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypeDropdown(RoomTypeID)
);

/* Table containing sales */

CREATE TABLE Sale (
    SaleID NUMBER(7),
    BuyerID NUMBER(6),
    PropertyID NUMBER(7),
    sale_agreedprice NUMBER(10,2),
    sale_date DATE,
    PRIMARY KEY (SaleID),
    FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

/* Table containing booked viewings */

CREATE TABLE Viewing (
    ViewingID NUMBER(7),
    PropertyID NUMBER(6),
    viewing_datetime DATE,
    PRIMARY KEY (ViewingID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

/* Link table between viewings and buyers*/

CREATE TABLE ViewingBuyer (
    ViewingBuyerID NUMBER(7),
    ViewingID NUMBER(7),
    BuyerID NUMBER(6),
    PRIMARY KEY (ViewingBuyerID),
    FOREIGN KEY (ViewingID) REFERENCES Viewing(ViewingID),
    FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID)
);

/* Link table between viewings and employees*/

CREATE TABLE ViewingEmployee (
    ViewingEmployeeID NUMBER(7),
    ViewingID NUMBER(7),
    EmployeeID NUMBER(6),
    PRIMARY KEY (ViewingEmployeeID),
    FOREIGN KEY (ViewingID) REFERENCES Viewing(ViewingID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- ContactTypeDropdown Data

INSERT INTO ContactTypeDropdown VALUES (1, 'Email');
INSERT INTO ContactTypeDropdown VALUES (2, 'Phone');
INSERT INTO ContactTypeDropdown VALUES (3, 'Fax');
INSERT INTO ContactTypeDropdown VALUES (4, 'Website');
INSERT INTO ContactTypeDropdown VALUES (5, 'SMS');

-- InterestTypesDropdown Data

INSERT INTO InterestsTypeDropdown VALUES (1, 'Location');
INSERT INTO InterestsTypeDropdown VALUES (2, 'Minimum Price');
INSERT INTO InterestsTypeDropdown VALUES (3, 'Maximum Price');
INSERT INTO InterestsTypeDropdown VALUES (4, 'Number of Floors');
INSERT INTO InterestsTypeDropdown VALUES (5, 'Number of Bathrooms');
INSERT INTO InterestsTypeDropdown VALUES (6, 'Number of Rooms');

-- PropertyTypeDropdown Data

INSERT INTO PropertyTypeDropdown VALUES (1, 'Detached');
INSERT INTO PropertyTypeDropdown VALUES (2, 'Semi-Detached');
INSERT INTO PropertyTypeDropdown VALUES (3, 'Terraced');
INSERT INTO PropertyTypeDropdown VALUES (4, 'Flat');

-- RoomTypeDropdown Data

INSERT INTO RoomTypeDropdown VALUES (1, 'Bathroom');
INSERT INTO RoomTypeDropdown VALUES (2, 'Bedroom');
INSERT INTO RoomTypeDropdown VALUES (3, 'Living Room');
INSERT INTO RoomTypeDropdown VALUES (4, 'Hallway');
INSERT INTO RoomTypeDropdown VALUES (5, 'Conservatory');


-- Branch Data

INSERT INTO Branch VALUES (1,'Clownfish','1 Fish Way');
INSERT INTO Branch VALUES (2,'Starfish','2 Reef Street');
INSERT INTO Branch VALUES (3,'Seagulls','3 Sand Valley');
INSERT INTO Branch VALUES (4,'Sharks','4 Plankton Avenue');

-- Buyer Data

INSERT INTO Buyer VALUES (1, 'Monica', 'Mackerel');
INSERT INTO Buyer VALUES (2, 'Erica', 'Eel');
INSERT INTO Buyer VALUES (3, 'Rita', 'Rockfish');
INSERT INTO Buyer VALUES (4, 'Tina', 'Tuna');
INSERT INTO Buyer VALUES (5, 'Sandra', 'Shark');
INSERT INTO Buyer VALUES (6, 'Mary', 'Monkfish');
INSERT INTO Buyer VALUES (7, 'Jessica', 'Jewelfish');

-- Employee Data

INSERT INTO Employee VALUES (1, 1, 'Harold', 'Hammerhead', '1 Seaweed Road', TO_DATE('01/02/2003', 'dd/mm/yyyy'), 'AB123456C', 1234.56, TO_DATE('01/04/2024', 'dd/mm/yyyy'));
INSERT INTO Employee VALUES (2, 2, 'Samuel', 'Sanders', '2 Seaweed Road', TO_DATE('02/02/1997', 'dd/mm/yyyy'), 'BC234567D', 9823.23, TO_DATE('02/01/2010', 'dd/mm/yyyy'));
INSERT INTO Employee VALUES (3, 3, 'Carl', 'Reef', '3 Seaweed Road', TO_DATE('01/07/2001', 'dd/mm/yyyy'), 'CD345678E', 8365.01, TO_DATE('14/07/2019', 'dd/mm/yyyy'));
INSERT INTO Employee VALUES (4, 3, 'Terry', 'Trout', '4 Fishy Valley', TO_DATE('11/09/1992', 'dd/mm/yyyy'), 'DE456789F', 7331.98, TO_DATE('17/11/2012', 'dd/mm/yyyy'));
INSERT INTO Employee VALUES (5, 1, 'Dory', 'Fromthemovie', '5 Fishy Valley', TO_DATE('21/04/1991', 'dd/mm/yyyy'), 'EF567890G', 1823.32, TO_DATE('08/12/2015', 'dd/mm/yyyy'));

-- PropertyOwner Data

INSERT INTO PropertyOwner VALUES (1, 'Sharon', 'Seawaters');
INSERT INTO PropertyOwner VALUES (2, 'Felix', 'Fins');
INSERT INTO PropertyOwner VALUES (3, 'Cara', 'Carp');
INSERT INTO PropertyOwner VALUES (4, 'Perry', 'Pirahna');

-- BranchContact Data

-- Each branch is required to have an email, phone and fax number 
INSERT INTO BranchContact VALUES (1, 1, 1, 'SeacrestClownfish@Fishmail.sea');
INSERT INTO BranchContact VALUES (2, 1, 3, '19725329272');
INSERT INTO BranchContact VALUES (3, 1, 2, '06722353869');
INSERT INTO BranchContact VALUES (4, 2, 1, 'SeacrestStarfish@Fishmail.sea');
INSERT INTO BranchContact VALUES (5, 2, 3, '442038089463');
INSERT INTO BranchContact VALUES (6, 2, 2, '03529417333');
INSERT INTO BranchContact VALUES (7, 3, 1, 'SeacrestSeagulls@Fishmail.sea');
INSERT INTO BranchContact VALUES (8, 3, 3, '61261039109');
INSERT INTO BranchContact VALUES (9, 3, 2, '06462176624');
INSERT INTO BranchContact VALUES (10, 4, 1, 'SeacrestSharks@Fishmail.sea');
INSERT INTO BranchContact VALUES (11, 4, 3, '12383183401');
INSERT INTO BranchContact VALUES (12, 4, 2, '05142582018');

-- BuyerContact Data

-- Buyers must have at least one point of contact, but can have more
INSERT INTO BuyerContact VALUES (1, 1, 1, 'MMackerel@Fishmail.sea');
INSERT INTO BuyerContact VALUES (2, 2, 1, 'EEel@Fishmail.sea');
INSERT INTO BuyerContact VALUES (3, 3, 1, 'RRockfish@Fishmail.sea');
INSERT INTO BuyerContact VALUES (4, 4, 1, 'TTuna@Fishmail.sea');
INSERT INTO BuyerContact VALUES (5, 5, 1, 'SShark@Fishmail.sea');
INSERT INTO BuyerContact VALUES (6, 6, 1, 'MMonkfish@Fishmail.sea');
INSERT INTO BuyerContact VALUES (7, 7, 1, 'JJewelfish@Fishmail.sea');
INSERT INTO BuyerContact VALUES (8, 7, 3, '12345678910'); -- Cardinality, Jessica Jewelfish also has a phone number

-- EmployeeContact Data

-- Employees must have at least an email and a phone number, but can have extra
INSERT INTO EmployeeContact VALUES (1, 1, 1, 'HHammerhead@Fishmail.sea');
INSERT INTO EmployeeContact VALUES (2, 5, 2, '07591024123');
INSERT INTO EmployeeContact VALUES (3, 2, 1, 'SSanders@Fishmail.sea');
INSERT INTO EmployeeContact VALUES (4, 5, 2, '03278543394');
INSERT INTO EmployeeContact VALUES (5, 3, 1, 'CReef@Fishmail.sea');
INSERT INTO EmployeeContact VALUES (6, 5, 2, '02917245306');
INSERT INTO EmployeeContact VALUES (7, 4, 1, 'TTrout@Fishmail.sea');
INSERT INTO EmployeeContact VALUES (8, 5, 2, '06465283523');
INSERT INTO EmployeeContact VALUES (9, 5, 1, 'DFromthemovie@Fishmail.sea');
INSERT INTO EmployeeContact VALUES (10, 5, 2, '04923756523');

-- PropertyOwnerContact Data

-- PropertyOwners must have at least one point of contact, but can have more than one.
INSERT INTO PropertyOwnerContact VALUES (1, 1, 1, 'SSeawaters@Fishmail.sea');
INSERT INTO PropertyOwnerContact VALUES (2, 1, 2, '07591234123');
INSERT INTO PropertyOwnerContact VALUES (3, 2, 1, 'FFins@Fishmail.sea');
INSERT INTO PropertyOwnerContact VALUES (4, 2, 2, '07512398123');
INSERT INTO PropertyOwnerContact VALUES (5, 3, 1, 'CCarp@Fishmail.sea');
INSERT INTO PropertyOwnerContact VALUES (6, 3, 2, '07591087923');
INSERT INTO PropertyOwnerContact VALUES (7, 4, 1, 'PPiranha@Fishmail.sea');

-- Property Data

INSERT INTO Property VALUES (1, 1, 1, '1 Anchor Alley', 891232.92, 50.50, 35.00);
INSERT INTO Property VALUES (2, 2, 1, '5 Crustacean Crossing', 350999.50, 20.50, 10.00); -- Cardinality - Sharon Seawaters has two properties listed
INSERT INTO Property VALUES (3, 3, 2, '7 Mackerel Drive', 426863.00, 30.00, 30.00);
INSERT INTO Property VALUES (4, 3, 4, '2 Shell Spur', 523384.82, 2.00, 1.00);
-- I wouldn't buy the last one...

-- Optionality - Cara Carp does not have any properties listed.

-- PropertyType Data

INSERT INTO PropertyType VALUES (1, 1, 1);
INSERT INTO PropertyType VALUES (2, 2, 2);
INSERT INTO PropertyType VALUES (3, 3, 3); -- Cardinality - One property can match multiple types
INSERT INTO PropertyType VALUES (4, 4, 3);

-- Optionality - 2 Shell Spur does not have any types applied to it

-- Room Data

INSERT INTO Room VALUES (1, 1, 1, 2, 5.00, 6.00);
INSERT INTO Room VALUES (2, 1, 2, 3, 4.00, 7.00); 
INSERT INTO Room VALUES (3, 1, 3, 5, 2.00, 3.00); 
INSERT INTO Room VALUES (4, 1, 5, 6, 3.00, 2.00); 
INSERT INTO Room VALUES (5, 2, 1, 2, 4.00, 8.00); 
INSERT INTO Room VALUES (6, 2, 2, 3, 6.00, 2.00);  -- Cardinality - A property can have multiple rooms
INSERT INTO Room VALUES (7, 2, 3, 5, 2.00, 6.00);  -- Cardinality - There can be multiple of the same room type in a property
INSERT INTO Room VALUES (8, 3, 1, 3, 2.00, 6.00); 
INSERT INTO Room VALUES (9, 3, 2, 7, 3.00, 4.00); 
INSERT INTO Room VALUES (10, 3, 3, 3, 7.00, 3.00); 
INSERT INTO Room VALUES (11, 3, 3, 5, 2.00, 3.50); 
INSERT INTO Room VALUES (12, 4, 1, 2, 2.00, 0.50); 
INSERT INTO Room VALUES (13, 4, 1, 1, 1.00, 0.50); 
INSERT INTO Room VALUES (14, 4, 1, 0, 1.00, 0.50); 

-- Optionality - Not every room type must be present in a property

-- BuyerInterests Data

INSERT INTO BuyerInterests VALUES (1, 1, 1, 'St Ives');
INSERT INTO BuyerInterests VALUES (2, 1, 3, '300000');
INSERT INTO BuyerInterests VALUES (3, 1, 4, '2');
INSERT INTO BuyerInterests VALUES (4, 1, 5, '2'); -- Cardinality - A buyer can have multiple interests
INSERT INTO BuyerInterests VALUES (5, 2, 1, 'Looe');
INSERT INTO BuyerInterests VALUES (6, 2, 1, 'Seaton'); -- Cardinality - An interest can be had by multiple buyers
INSERT INTO BuyerInterests VALUES (7, 2, 3, '500000');
INSERT INTO BuyerInterests VALUES (8, 2, 4, '3');
INSERT INTO BuyerInterests VALUES (9, 3, 3, '600000');
INSERT INTO BuyerInterests VALUES (10, 4, 1, 'Lyme Regis');
INSERT INTO BuyerInterests VALUES (11, 4, 3, '400000');
INSERT INTO BuyerInterests VALUES (12, 5, 1, 'Weymouth');
INSERT INTO BuyerInterests VALUES (13, 5, 1, 'Swanage');
INSERT INTO BuyerInterests VALUES (14, 5, 1, 'Ringstead');
INSERT INTO BuyerInterests VALUES (15, 5, 3, '500000');
INSERT INTO BuyerInterests VALUES (16, 5, 4, '2');
INSERT INTO BuyerInterests VALUES (17, 6, 1, 'Swanage');
INSERT INTO BuyerInterests VALUES (18, 6, 3, '450000');
INSERT INTO BuyerInterests VALUES (19, 6, 4, '1');
INSERT INTO BuyerInterests VALUES (20, 2, 6, '2');
INSERT INTO BuyerInterests VALUES (21, 3, 6, '3');
INSERT INTO BuyerInterests VALUES (22, 4, 6, '4');
INSERT INTO BuyerInterests VALUES (23, 5, 6, '5');

-- Optionality - A buyer can lack interests
-- Optionality - An interest may not be had by any buyers

-- Sale Data

INSERT INTO Sale VALUES (1, 1, 1, 890000.00, TO_DATE('02/09/2012', 'dd/mm/yyyy'));
INSERT INTO Sale VALUES (2, 3, 2, 350000.00, TO_DATE('12/08/2024', 'dd/mm/yyyy'));
INSERT INTO Sale VALUES (3, 5, 3, 420000.00, TO_DATE('22/04/2013', 'dd/mm/yyyy'));

-- Optionality - A property can be listed on the site without having been sold

-- Viewing Data

INSERT INTO Viewing VALUES (1, 1, TO_DATE('03/05/2017', 'dd/mm/yyyy'));
INSERT INTO Viewing VALUES (2, 1, TO_DATE('17/03/2022', 'dd/mm/yyyy')); -- Cardinality - A property may have multiple viewings 
INSERT INTO Viewing VALUES (3, 2, TO_DATE('08/06/2023', 'dd/mm/yyyy'));
INSERT INTO Viewing VALUES (4, 2, TO_DATE('05/05/2025', 'dd/mm/yyyy'));
INSERT INTO Viewing VALUES (5, 3, TO_DATE('03/12/2021', 'dd/mm/yyyy'));

-- Optionality - A property may not have any viewings

-- ViewingBuyer Data

INSERT INTO ViewingBuyer VALUES (1, 1, 1);
INSERT INTO ViewingBuyer VALUES (2, 1, 1); -- Cardinality - A viewing may have multiple buyers on it 
INSERT INTO ViewingBuyer VALUES (3, 1, 2);
INSERT INTO ViewingBuyer VALUES (4, 2, 2);
INSERT INTO ViewingBuyer VALUES (5, 2, 7);
INSERT INTO ViewingBuyer VALUES (6, 2, 5);
INSERT INTO ViewingBuyer VALUES (7, 4, 2);
INSERT INTO ViewingBuyer VALUES (8, 4, 3);

-- ViewingEmployee Data

INSERT INTO ViewingEmployee VALUES (1, 1, 1);
INSERT INTO ViewingEmployee VALUES (2, 1, 5); -- Cardinality - A viewing may have multiple employees on it 
INSERT INTO ViewingEmployee VALUES (3, 1, 2);
INSERT INTO ViewingEmployee VALUES (4, 2, 2);
INSERT INTO ViewingEmployee VALUES (5, 2, 3);
INSERT INTO ViewingEmployee VALUES (6, 2, 5);
INSERT INTO ViewingEmployee VALUES (7, 4, 2);


-- Queries


-- A list of all the Branch details for the company.

SELECT b.branch_name, b.branch_address, 
    LISTAGG(ctd.contact_type || ' : ' || bc.branch_contactinfo || CHR(10))
        WITHIN GROUP (ORDER BY ctd.contact_type) AS contacts
FROM Branch b
JOIN BranchContact bc
    ON bc.BranchID = b.BranchID
JOIN ContactTypeDropdown ctd
    ON ctd.ContactTypeItemID = bc.ContactTypeItemID
GROUP BY b.branch_name, b.branch_address;

-- A list of staff details (staff number and name) and which branch (branch number and name) they are based at.

SELECT e.employee_firstname, e.employee_lastname, b.BranchID, b.branch_name
FROM Employee e, Branch b
WHERE e.BranchID = b.BranchID;

-- A list of properties where the final price on the contract is less than the asking price for the property.

SELECT p.PropertyID, p.property_address, p.property_askingprice, s.sale_agreedprice
FROM Property p, Sale s
WHERE p.PropertyID = s.PropertyID AND p.property_askingprice > s.sale_agreedprice;

-- A list of properties where the asking price is less than the maximum price of a specified customer.

SELECT b.BuyerID, (b.buyer_firstname || ' ' || b.buyer_lastname) AS buyer_name, ('£' || bi.buyerinterests_info) AS max_price, 
    LISTAGG(p.property_address || ', £' || p.property_askingprice || CHR(10))
        WITHIN GROUP (ORDER BY p.PropertyID) AS property
FROM Property p, Buyer b
JOIN BuyerInterests bi
    ON b.BuyerID = bi.BuyerID
WHERE bi.InterestsTypeID = 3 AND p.property_askingprice < TO_NUMBER(bi.buyerinterests_info) AND 
b.BuyerID = 2
-- EDIT THE ABOVE LINE TO MATCH THE ID OF THE DESIRED BUYER
GROUP BY b.BuyerID, b.buyer_firstname, b.buyer_lastname, bi.buyerinterests_info;

-- A list of sales properties registered at a specific branch, along with details of owners.

WITH PropertyOwnerContactInfo AS (
    SELECT po.PropertyOwnerID,
        (po.propertyowner_firstname || ' ' || po.propertyowner_lastname) AS propertyonwer_name, 
        LISTAGG(ctd.contact_type || ' : ' || poc.propertyowner_contactinfo || CHR(10)) 
            WITHIN GROUP (ORDER BY ctd.contact_type) AS all_contact_info
    FROM PropertyOwner po
    JOIN PropertyOwnerContact poc
        ON poc.PropertyOwnerID = po.PropertyOwnerID
    JOIN ContactTypeDropdown ctd
        ON ctd.ContactTypeItemID = poc.ContactTypeItemID
    GROUP BY po.PropertyOwnerID, po.propertyowner_firstname, po.propertyowner_lastname
)
SELECT b.BranchID, b.branch_name,
    LISTAGG(p.property_address || ' is listed for ' || '£' ||p.property_askingprice || CHR(10) || 
    'Sold by ' || poci.propertyonwer_name || ', Contact by' || CHR(10) || poci.all_contact_info)
        WITHIN GROUP (ORDER BY p.property_address) AS Properties
FROM Branch b
JOIN Property p
    ON p.BranchID = b.BranchID
JOIN PropertyOwner po
    ON po.PropertyOwnerID = p.PropertyOwnerID
JOIN PropertyOwnerContactInfo poci
    ON poci.PropertyOwnerID = po.PropertyOwnerID
WHERE
b.BranchID = 2
-- EDIT THE ABOVE LINE TO MATCH THE ID OF THE BRANCH YOU WANT TO SEARCH FOR
GROUP BY b.BranchID, b.branch_name;


-- A list of viewings for a specific property along with the name of which buyer requested them and the name of which member of staff supervised the viewing.

WITH ViewingBuyerInfo AS (
    SELECT v.PropertyID AS PropertyID, v.viewing_datetime AS viewing_datetime, 
    LISTAGG(b.buyer_firstname || ' ' || b.buyer_lastname || CHR(10)) 
        WITHIN GROUP (ORDER BY b.buyer_firstname) AS buyer_names
    FROM Viewing v
    JOIN ViewingBuyer vb
        ON vb.ViewingID = v.ViewingID
    JOIN Buyer b
        ON b.BuyerID = vb.BuyerID
    GROUP BY PropertyID, viewing_datetime
),
    ViewingEmployeeInfo AS (
        SELECT v.PropertyID AS PropertyID, v.viewing_datetime AS viewing_datetime,
        LISTAGG(e.employee_firstname || ' ' || e.employee_lastname || CHR(10)) 
            WITHIN GROUP (ORDER BY e.employee_firstname) AS employee_names
        FROM Viewing v
        JOIN ViewingEmployee ve
            ON ve.ViewingID = v.ViewingID
        JOIN Employee e
            ON e.EmployeeID = ve.EmployeeID
        GROUP BY PropertyID, viewing_datetime
    )
SELECT p.PropertyID, p.property_address,
    LISTAGG(vbi.viewing_datetime || ' : ' || CHR(10) || 'Buyers: ' || vbi.buyer_names || CHR(10) || 'Employees: ' || vei.employee_names)
        WITHIN GROUP (ORDER BY vbi.viewing_datetime) AS viewings
FROM Property p
JOIN ViewingBuyerInfo vbi
    ON vbi.PropertyID = p.PropertyID
JOIN ViewingEmployeeInfo vei
    ON vei.PropertyID = p.PropertyID
WHERE p.PropertyID = 1
-- EDIT THE ABOVE LINE TO THE PROPERTYID OF THE DESIRED PROPERTY
GROUP BY p.PropertyID, p.property_address;

-- A total of all the final prices paid for all properties for which contracts have been signed.

SELECT SUM(s.sale_agreedprice) AS sale_total
FROM sale s;

-- A total of all the prices paid for all properties for which contracts were signed before a specified date.

SELECT SUM(s.sale_agreedprice) AS sale_total
FROM sale s
WHERE s.sale_date < 
TO_DATE('03/12/2021', 'dd/mm/yyyy');
-- EDIT THE ABOVE DATE TO THE DATE OF THE DESIRED CUTOFF

-- The details of the most expensive property on the estate agents list.

SELECT p.PropertyID, p.property_address, p.property_askingprice
FROM Property p
ORDER BY p.property_askingprice DESC
FETCH FIRST 1 ROWS ONLY;

-- A list of properties showing the number of rooms that each has.

SELECT p.PropertyID, p.property_address, COUNT(r.RoomID)
FROM Property p
JOIN Room r
    ON r.PropertyID = p.PropertyID
GROUP BY p.PropertyID, p.property_address;

-- A list of properties that have the same number of rooms as the desired number of rooms of a specified customer.

WITH PropertyInfo AS (
    SELECT p.PropertyID, p.property_address, COUNT(r.RoomID) AS room_count
    FROM Property p
    JOIN Room r
        ON r.PropertyID = p.PropertyID
    GROUP BY p.PropertyID, p.property_address
)
SELECT b.BuyerID, (b.buyer_firstname || ' ' || b.buyer_lastname) as buyer_name,
    LISTAGG(pi.PropertyID || ', ' || pi.property_address || ', ' || TO_CHAR(pi.room_count) || ' Rooms' || CHR(10))
        WITHIN GROUP (ORDER BY pi.PropertyID) AS properties
FROM Buyer b, BuyerInterests bi
JOIN PropertyInfo pi
    ON pi.room_count = TO_NUMBER(bi.buyerinterests_info)
WHERE bi.InterestsTypeID = 6 AND b.BuyerID = bi.BuyerID AND
b.BuyerID = 4
-- EDIT THE ABOVE VALUE TO MATCH THE ID OF THE DESIRED BUYER
GROUP BY b.BuyerID, b.buyer_firstname, b.buyer_lastname;

-- A list of all properties sold in the last five years, showing the names of the seller and buyer, the price of the property that was agreed to by both parties, and the date that the sale was completed.

SELECT p.PropertyID, p.property_address, s.sale_date, p.property_askingprice AS asking_price, s.sale_agreedprice AS final_price, 
    (b.buyer_firstname || ' ' || b.buyer_lastname) AS buyer_name, 
    (po.propertyowner_firstname || ' ' || po.propertyowner_lastname) AS propertyowner_name 
    FROM Property p, Sale s, Buyer b, PropertyOwner po
    WHERE p.PropertyID = s.PropertyID AND
        b.BuyerID = s.BuyerID AND
        p.PropertyOwnerID = po.PropertyOwnerID AND
        s.sale_date > ADD_MONTHS(SYSDATE, -60);