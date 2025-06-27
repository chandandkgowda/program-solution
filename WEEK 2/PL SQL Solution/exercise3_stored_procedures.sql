
SET SERVEROUTPUT ON;
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Accounts';
  EXECUTE IMMEDIATE 'DROP TABLE Employees';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE Accounts (
  AccountID NUMBER PRIMARY KEY,
  CustomerName VARCHAR2(100),
  AccountType VARCHAR2(20), -- e.g., 'Savings', 'Checking'
  Balance NUMBER(10,2)
);
CREATE TABLE Employees (
  EmployeeID NUMBER PRIMARY KEY,
  EmployeeName VARCHAR2(100),
  Department VARCHAR2(50),
  Salary NUMBER(10,2)
);

INSERT INTO Accounts VALUES (1, 'Alice', 'Savings', 1000.00);
INSERT INTO Accounts VALUES (2, 'Bob', 'Savings', 2000.00);
INSERT INTO Accounts VALUES (3, 'Charlie', 'Checking', 1500.00);
INSERT INTO Accounts VALUES (4, 'David', 'Savings', 3000.00);

-- Employees
INSERT INTO Employees VALUES (101, 'John', 'HR', 50000);
INSERT INTO Employees VALUES (102, 'Jane', 'IT', 60000);
INSERT INTO Employees VALUES (103, 'Mark', 'IT', 55000);
INSERT INTO Employees VALUES (104, 'Sara', 'Finance', 58000);

COMMIT;

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
  FOR acc IN (
    SELECT AccountID, Balance
    FROM Accounts
    WHERE AccountType = 'Savings'
  ) LOOP
    UPDATE Accounts
    SET Balance = Balance + (Balance * 0.01)
    WHERE AccountID = acc.AccountID;

    DBMS_OUTPUT.PUT_LINE('Interest applied to Account ID: ' || acc.AccountID);
  END LOOP;

  COMMIT;
END;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Running: ProcessMonthlyInterest ---');
  ProcessMonthlyInterest;
END;
/

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
  p_department IN VARCHAR2,
  p_bonus_percent IN NUMBER
) IS
BEGIN
  FOR emp IN (
    SELECT EmployeeID, Salary
    FROM Employees
    WHERE Department = p_department
  ) LOOP
    UPDATE Employees
    SET Salary = Salary + (Salary * (p_bonus_percent / 100))
    WHERE EmployeeID = emp.EmployeeID;

    DBMS_OUTPUT.PUT_LINE('Bonus applied to Employee ID: ' || emp.EmployeeID);
  END LOOP;

  COMMIT;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Running: UpdateEmployeeBonus (IT, 10%) ---');
  UpdateEmployeeBonus('IT', 10);
END;
/

CREATE OR REPLACE PROCEDURE TransferFunds (
  p_from_account IN NUMBER,
  p_to_account IN NUMBER,
  p_amount IN NUMBER
) IS
  v_balance NUMBER;
BEGIN
  SELECT Balance INTO v_balance FROM Accounts WHERE AccountID = p_from_account FOR UPDATE;
IF v_balance < p_amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
  END IF;
  UPDATE Accounts
  SET Balance = Balance - p_amount
  WHERE AccountID = p_from_account;


  UPDATE Accounts
  SET Balance = Balance + p_amount
  WHERE AccountID = p_to_account;

  DBMS_OUTPUT.PUT_LINE('Transferred ' || p_amount || ' from Account ' || p_from_account || ' to Account ' || p_to_account);

  COMMIT;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Running: TransferFunds (500 from 1 to 2) ---');
  TransferFunds(1, 2, 500);
END;
/
