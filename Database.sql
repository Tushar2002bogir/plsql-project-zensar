CREATE TABLE Owner (
    Owner_ID NUMBER PRIMARY KEY,
    Owner_Name VARCHAR2(100),
    Contact_Number VARCHAR2(15),
    Address VARCHAR2(200)
);

CREATE TABLE Vehicle (
    Vehicle_ID NUMBER PRIMARY KEY,
    Vehicle_Type VARCHAR2(50),
    Vehicle_Number VARCHAR2(20) UNIQUE,
    Registration_Date DATE DEFAULT SYSDATE,
    Owner_ID NUMBER REFERENCES Owner(Owner_ID)
);

CREATE TABLE Ownership_Transfer (
    Transfer_ID NUMBER PRIMARY KEY,
    Vehicle_ID NUMBER REFERENCES Vehicle(Vehicle_ID),
    Old_Owner_ID NUMBER REFERENCES Owner(Owner_ID),
    New_Owner_ID NUMBER REFERENCES Owner(Owner_ID),
    Transfer_Date DATE DEFAULT SYSDATE
);

CREATE TABLE Vehicle_Insurance (
    Insurance_ID NUMBER PRIMARY KEY,
    Vehicle_ID NUMBER REFERENCES Vehicle(Vehicle_ID),
    Policy_Number VARCHAR2(50),
    Start_Date DATE,
    End_Date DATE,
    Premium_Amount NUMBER(10, 2)
);

CREATE TABLE Vehicle_Tax (
    Tax_ID NUMBER PRIMARY KEY,
    Vehicle_ID NUMBER REFERENCES Vehicle(Vehicle_ID),
    Tax_Type VARCHAR2(50),
    Amount NUMBER(10, 2),
    Payment_Date DATE
);

CREATE TABLE Vehicle_Inspection (
    Inspection_ID NUMBER PRIMARY KEY,
    Vehicle_ID NUMBER REFERENCES Vehicle(Vehicle_ID),
    Inspection_Date DATE,
    Inspection_Result VARCHAR2(100)
);

CREATE OR REPLACE PROCEDURE Create_Owner (
    P_Owner_ID IN NUMBER,
    P_Owner_Name IN VARCHAR2,
    P_Contact_Number IN VARCHAR2,
    P_Address IN VARCHAR2
) IS
BEGIN
    INSERT INTO Owner (Owner_ID, Owner_Name, Contact_Number, Address)
    VALUES (P_Owner_ID, P_Owner_Name, P_Contact_Number, P_Address);
    DBMS_OUTPUT.PUT_LINE('Owner added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Create_Vehicle (
    P_Vehicle_ID IN NUMBER,
    P_Vehicle_Type IN VARCHAR2,
    P_Vehicle_Number IN VARCHAR2,
    P_Owner_ID IN NUMBER
) IS
BEGIN
    INSERT INTO Vehicle (Vehicle_ID, Vehicle_Type, Vehicle_Number, Owner_ID)
    VALUES (P_Vehicle_ID, P_Vehicle_Type, P_Vehicle_Number, P_Owner_ID);
    DBMS_OUTPUT.PUT_LINE('Vehicle added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


CREATE SEQUENCE Ownership_Transfer_SEQ
START WITH 1
INCREMENT BY 1;



CREATE OR REPLACE PROCEDURE Transfer_Ownership (
    P_Vehicle_ID IN NUMBER,
    P_New_Owner_ID IN NUMBER
) IS
    L_Old_Owner_ID NUMBER;
BEGIN
    SELECT Owner_ID INTO L_Old_Owner_ID
    FROM Vehicle
    WHERE Vehicle_ID = P_Vehicle_ID;

    -- Insert into ownership_transfer
    INSERT INTO Ownership_Transfer (Transfer_ID, Vehicle_ID, Old_Owner_ID, New_Owner_ID, Transfer_Date)
    VALUES (Ownership_Transfer_SEQ.NEXTVAL, P_Vehicle_ID, L_Old_Owner_ID, P_New_Owner_ID, SYSDATE);

    -- Update the vehicle's current owner
    UPDATE Vehicle
    SET Owner_ID = P_New_Owner_ID
    WHERE Vehicle_ID = P_Vehicle_ID;

    DBMS_OUTPUT.PUT_LINE('Ownership transferred successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER Log_Ownership_Transfer
AFTER UPDATE OF Owner_ID ON Vehicle
FOR EACH ROW
BEGIN
    INSERT INTO Ownership_Transfer (Transfer_ID, Vehicle_ID, Old_Owner_ID, New_Owner_ID, Transfer_Date)
    VALUES (Ownership_Transfer_SEQ.NEXTVAL, :OLD.Vehicle_ID, :OLD.Owner_ID, :NEW.Owner_ID, SYSDATE);
END;
/


CREATE OR REPLACE TRIGGER Check_Insurance_Expiry
BEFORE INSERT OR UPDATE ON Vehicle_Insurance
FOR EACH ROW
BEGIN
    IF :NEW.End_Date < SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Warning: The insurance policy has already expired.');
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE Add_Vehicle_Insurance (
    P_Insurance_ID IN NUMBER,
    P_Vehicle_ID IN NUMBER,
    P_Policy_Number IN VARCHAR2,
    P_Start_Date IN DATE,
    P_End_Date IN DATE,
    P_Premium_Amount IN NUMBER
) IS
BEGIN
    INSERT INTO Vehicle_Insurance (Insurance_ID, Vehicle_ID, Policy_Number, Start_Date, End_Date, Premium_Amount)
    VALUES (P_Insurance_ID, P_Vehicle_ID, P_Policy_Number, P_Start_Date, P_End_Date, P_Premium_Amount);
    DBMS_OUTPUT.PUT_LINE('Vehicle insurance added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



CREATE OR REPLACE PROCEDURE Add_Vehicle_Tax (
    P_Tax_ID IN NUMBER,
    P_Vehicle_ID IN NUMBER,
    P_Tax_Type IN VARCHAR2,
    P_Amount IN NUMBER,
    P_Payment_Date IN DATE
) IS
BEGIN
    INSERT INTO Vehicle_Tax (Tax_ID, Vehicle_ID, Tax_Type, Amount, Payment_Date)
    VALUES (P_Tax_ID, P_Vehicle_ID, P_Tax_Type, P_Amount, P_Payment_Date);
    DBMS_OUTPUT.PUT_LINE('Vehicle tax added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/




CREATE OR REPLACE PROCEDURE Add_Vehicle_Inspection (
    P_Inspection_ID IN NUMBER,
    P_Vehicle_ID IN NUMBER,
    P_Inspection_Date IN DATE,
    P_Inspection_Result IN VARCHAR2
) IS
BEGIN
    INSERT INTO Vehicle_Inspection (Inspection_ID, Vehicle_ID, Inspection_Date, Inspection_Result)
    VALUES (P_Inspection_ID, P_Vehicle_ID, P_Inspection_Date, P_Inspection_Result);
    DBMS_OUTPUT.PUT_LINE('Vehicle inspection record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN
    -- Calling the Create_Owner procedure for the dummy data
    Create_Owner(1, 'John Doe', '9876543210', '123, Elm Street, Springfield');
    Create_Owner(2, 'Jane Doe', '9123456789', '456, Maple Street, Springfield');
    
    -- Calling the Create_Vehicle procedure for the dummy data
    Create_Vehicle(101, 'Car', 'AB123CD456', 1);
    Create_Vehicle(102, 'Motorbike', 'XY987ZT654', 2);
    
    -- Calling the Add_Vehicle_Insurance procedure for the dummy data
    Add_Vehicle_Insurance(201, 101, 'POL123456', SYSDATE, SYSDATE + 365, 10000.50);
    Add_Vehicle_Insurance(202, 102, 'POL987654', SYSDATE, SYSDATE + 365, 5000.75);
    
    -- Calling the Add_Vehicle_Tax procedure for the dummy data
    Add_Vehicle_Tax(301, 101, 'Road Tax', 5000.75, SYSDATE);
    Add_Vehicle_Tax(302, 102, 'Road Tax', 3000.25, SYSDATE);
    
    -- Calling the Add_Vehicle_Inspection procedure for the dummy data
    Add_Vehicle_Inspection(401, 101, SYSDATE, 'Passed');
    Add_Vehicle_Inspection(402, 102, SYSDATE, 'Failed');
    
    -- Calling the Transfer_Ownership procedure for testing ownership transfer
    Transfer_Ownership(101, 2);  -- Transfer the ownership of Vehicle 101 to Owner 2
    Transfer_Ownership(102, 1);  -- Transfer the ownership of Vehicle 102 to Owner 1
    
    COMMIT;
END;
/


BEGIN

select * from Owner;
select * from Vehicle;
select *  from Ownership_Transfer;
END;
/