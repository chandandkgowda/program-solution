SET SERVEROUTPUT ON;
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Loans';
  EXECUTE IMMEDIATE 'DROP TABLE Customers';
EXCEPTION
  WHEN OTHERS THEN
    NULL; -- Ignore errors if tables don't exist
END;
/
CREATE TABLE Customers (
  CustomerID NUMBER PRIMARY KEY,
  CustomerName VARCHAR2(100),
  Age NUMBER,
  Balance NUMBER(10, 2),
  IsVIP VARCHAR2(5) DEFAULT 'FALSE'
);
CREATE TABLE Loans (
  LoanID NUMBER PRIMARY KEY,
  CustomerID NUMBER,
  InterestRate NUMBER(5, 2),
  DueDate DATE,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
INSERT INTO Customers (CustomerID, CustomerName, Age, Balance) VALUES (1, 'Alice', 65, 15000);
INSERT INTO Customers (CustomerID, CustomerName, Age, Balance) VALUES (2, 'Bob', 45, 8000);
INSERT INTO Customers (CustomerID, CustomerName, Age, Balance) VALUES (3, 'Charlie', 70, 12000);
INSERT INTO Customers (CustomerID, CustomerName, Age, Balance) VALUES (4, 'David', 30, 500);

-- Insert into Loans
INSERT INTO Loans (LoanID, CustomerID, InterestRate, DueDate) VALUES (101, 1, 7.5, SYSDATE + 10);
INSERT INTO Loans (LoanID, CustomerID, InterestRate, DueDate) VALUES (102, 2, 8.0, SYSDATE + 40);
INSERT INTO Loans (LoanID, CustomerID, InterestRate, DueDate) VALUES (103, 3, 6.5, SYSDATE + 20);
INSERT INTO Loans (LoanID, CustomerID, InterestRate, DueDate) VALUES (104, 4, 9.0, SYSDATE + 5);

COMMIT;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Scenario 1: Applying 1% Interest Rate Discount ---');

  FOR cust IN (
    SELECT c.CustomerID, l.LoanID, l.InterestRate
    FROM Customers c
    JOIN Loans l ON c.CustomerID = l.CustomerID
    WHERE c.Age > 60
  )
  LOOP
    UPDATE Loans
    SET InterestRate = InterestRate - 1
    WHERE LoanID = cust.LoanID;

    DBMS_OUTPUT.PUT_LINE('Updated Interest Rate for Loan ID ' || cust.LoanID);
  END LOOP;

  COMMIT;
END;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Scenario 2: Promoting VIP Customers ---');

  FOR cust IN (
    SELECT CustomerID
    FROM Customers
    WHERE Balance > 10000
  )
  LOOP
    UPDATE Customers
    SET IsVIP = 'TRUE'
    WHERE CustomerID = cust.CustomerID;

    DBMS_OUTPUT.PUT_LINE('Customer ID ' || cust.CustomerID || ' promoted to VIP.');
  END LOOP;

  COMMIT;
END;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Scenario 3: Sending Loan Due Reminders ---');

  FOR loan_rec IN (
    SELECT l.LoanID, c.CustomerName, l.DueDate
    FROM Loans l
    JOIN Customers c ON l.CustomerID = c.CustomerID
    WHERE l.DueDate BETWEEN SYSDATE AND SYSDATE + 30
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan_rec.LoanID ||
                         ' for customer ' || loan_rec.CustomerName ||
                         ' is due on ' || TO_CHAR(loan_rec.DueDate, 'DD-MON-YYYY'));
  END LOOP;
END;
/
