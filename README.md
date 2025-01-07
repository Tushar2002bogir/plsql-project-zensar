# Vehicle Registration Management System

## Overview

The *Vehicle Registration Management System* is a comprehensive database solution designed for managing vehicle ownership, insurance, tax, inspection, and ownership transfers. This system includes multiple components, such as the creation and management of vehicle records, ownership transfers, insurance, tax, and inspection records, with stored procedures and triggers to automate common tasks and ensure data integrity.

## Features

1. *Owner Management:*
   - Add new owners with details like name, contact number, and address.
   
2. *Vehicle Registration:*
   - Register new vehicles, assign an owner, and maintain vehicle details (type, number, registration date).
   
3. *Ownership Transfer:*
   - Transfer ownership of a vehicle from one owner to another, with automatic logging and updates.

4. *Vehicle Insurance:*
   - Add and manage vehicle insurance details, including policy numbers, start and end dates, and premium amounts.
   - A trigger ensures that expired insurance records are flagged.

5. *Vehicle Tax:*
   - Add and manage vehicle tax records, including tax type, amount, and payment date.

6. *Vehicle Inspection:*
   - Add and manage vehicle inspection records, including inspection dates and results.
   
7. *Triggers and Procedures:*
   - Automate common actions such as transferring ownership and checking insurance expiry.

## Database Schema

### Tables

- *Owner*
  - Owner_ID (Primary Key)
  - Owner_Name
  - Contact_Number
  - Address
  
- *Vehicle*
  - Vehicle_ID (Primary Key)
  - Vehicle_Type
  - Vehicle_Number (Unique)
  - Registration_Date
  - Owner_ID (Foreign Key referencing Owner)

- *Ownership_Transfer*
  - Transfer_ID (Primary Key)
  - Vehicle_ID (Foreign Key referencing Vehicle)
  - Old_Owner_ID (Foreign Key referencing Owner)
  - New_Owner_ID (Foreign Key referencing Owner)
  - Transfer_Date

- *Vehicle_Insurance*
  - Insurance_ID (Primary Key)
  - Vehicle_ID (Foreign Key referencing Vehicle)
  - Policy_Number
  - Start_Date
  - End_Date
  - Premium_Amount

- *Vehicle_Tax*
  - Tax_ID (Primary Key)
  - Vehicle_ID (Foreign Key referencing Vehicle)
  - Tax_Type
  - Amount
  - Payment_Date

- *Vehicle_Inspection*
  - Inspection_ID (Primary Key)
  - Vehicle_ID (Foreign Key referencing Vehicle)
  - Inspection_Date
  - Inspection_Result

### Sequences

- *Ownership_Transfer_SEQ*: Used for generating unique Transfer_ID values.

### Procedures

1. *Create_Owner*: Adds a new owner to the database.
2. *Create_Vehicle*: Adds a new vehicle to the database.
3. *Transfer_Ownership*: Transfers ownership of a vehicle from one owner to another.
4. *Add_Vehicle_Insurance*: Adds insurance details for a vehicle.
5. *Add_Vehicle_Tax*: Adds tax details for a vehicle.
6. *Add_Vehicle_Inspection*: Adds inspection details for a vehicle.

### Triggers

1. *Log_Ownership_Transfer*: Automatically logs ownership transfers after an update to the Vehicle table.
2. *Check_Insurance_Expiry*: Validates that insurance policies are not expired before inserting or updating insurance records.

## Setup Instructions

1. Clone the repository to your local machine.

   ```bash
   git clone https://github.com/Tushar2002bogir/plsql-project-zensar.git
   cd plsql-project-zensor
