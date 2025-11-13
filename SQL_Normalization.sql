CREATE TABLE Academic_record (
    StudentID VARCHAR(10) PRIMARY KEY, 
    StudentName VARCHAR(100),
    DeptCode VARCHAR(10),
    DeptName VARCHAR(100),
    DeptLocation VARCHAR(100),
    CourseID VARCHAR(10),
    CourseTitle VARCHAR(100),
    CourseCredits INTEGER,
    FacultyID VARCHAR(10),
    FacultyName VARCHAR(100),
    ExamSemester VARCHAR(20),
    Grade CHAR(1)
);

INSERT INTO Academic_record (
    StudentID, StudentName, DeptCode, DeptName, DeptLocation, CourseID, CourseTitle
) VALUES
('23CS102', 'Priya Sharma', 'CS01', 'Computer Science', 'Block A, Main Campus', 'CS205', 'Data Structures'),
('23CS103', 'Arjun Mehta', 'CS01', 'Computer Science', 'Block A, Main Campus', 'CS206', 'Operating Systems'),
('23EE201', 'Neha Gupta', 'EE02', 'Electrical Engineering', 'Block B, East Campus', 'EE301', 'Circuit Theory'),
('23ME045', 'Rohan Verma', 'ME01', 'Mechanical Engineering', 'Block C, Engineering Wing', 'ME302', 'Thermodynamics');
 
 -- -----------------------------------------------------------
-- -----------------------------------------------------------
-- [Task 1] Identify the Primary Key and any potential Composite Keys for the unnormalized
-- ACADEMIC_RECORD table. Explain why your chosen key(s) uniquely identify each
-- record.
 -- -- -----------------------------------------------------------
-- 🔑 KEY CONCEPTS AND IDENTIFICATION (TASK 1 SUMMARY)
-- -----------------------------------------------------------

-- DEFINITIONS:

-- 'Primary Key': It is a field or set of fields that uniquely identifies every record in a table
--                and must enforce the NOT NULL constraint (Entity Integrity Rule).

-- 'Composite Key': It is made up of two or more columns whose values, when combined, are used 
--                  to uniquely identify each record in a table.

-- IDENTIFYING KEYS FOR THE ACADEMIC_RECORD TABLE:

-- Based on the provided data where ExamSemester is NULL (violating the NOT NULL rule for a PK):
-- The Primary Key is the Composite Key in the Academic_record table.
-- The key consists of two columns:
-- 1. StudentID
-- 2. CourseID

-- Justification:
-- The combination of these two columns ({StudentID, CourseID}) is the only valid, non-null combination
-- that can uniquely identify each record in the given dataset, thus serving as the practical Primary Key.

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- [Task 2] Identify all Functional Dependencies (FDs) present in the ACADEMIC_RECORD table. List each FD clearly and justify how it is derived from the data.
-- [Ans] 'FUNCTIONAL DEPENDENCIES': It exists when the value of one attribute dependes on another
-- (i) DEPENDENCIES BASED ON STUDENT_ID(PARTIAL_DEPENDENCIES): [a] student_id --> student_name
-- Each unique StudentID(e.g., '23CS102') is associated with exactly one StudentName ('Priya Sharma').
-- [b]Student_id --> DeptCode Each unique StudentID belongs to exactly one department code (e.g., '23CS102' is in 'CS01').

-- (ii)DEPENDENCIES BASED ON COURSE_ID(PARTIAL_DEPENDENCIES):
-- [a]course_id --> course_title :Each unique CourseID(e.g., 'CS205') is associated with exactly one CourseTitle ('Data Structures').
-- [b]course_id --> course_credit : Each unique CourseID is associated with exactly one Course_credits.

-- (iii)  Dependencies Based on 'DeptCode'(Transitive Dependencies):
-- [a]dept_code --> dept_name: Each dept have only one name
-- [b]dept_code --> dept_location : Each dept have only one location

-- (iv) DEPENDENCIES BASED ON PRIMARY KEYS {STUDENT_ID , COURSE_ID}:
-- [a]STUDENT_ID , COURSE_ID --> Faculty_id ,faculty_name , Examsemister ,Grade:
-- The combination of a student and a course uniquely determines the specific details of that enrollment record (who taught it, when it occurred, and what the grade was). While the data is currently NULL, the intent is that these values are determined by the enrollment event.

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- [Task 3] Normalize the ACADEMIC_RECORD table to First Normal Form (1NF). Explain any
-- changes made to ensure the table meets 1NF requirements (e.g., eliminating repeating groups, ensuring atomic values).
-- [ANS] The table 'ACADEMIC_RECORDS' doesnt need to be converted into INF because it already have the required criteria ,such as:
-- (i) Atomicity
-- (ii) No repeating columns
-- (iii)every row is unique

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- [Task 4] Normalize the resulting 1NF table(s) to Second Normal Form (2NF), addressing
-- any Partial Dependencies. Provide the resulting tables and explain how partial
-- dependencies were eliminated.
-- [ans]-- -----------------------------------------------------------
-- 🥈 TASK 4: NORMALIZATION TO SECOND NORMAL FORM (2NF)
-- -----------------------------------------------------------

-- The Original Practical Primary Key (PK) is the composite key: {StudentID, CourseID}.
-- 2NF requires that all non-key attributes be fully dependent on the ENTIRE PK.
-- We eliminate Partial Dependencies (attributes depending on only part of the PK).

-- -------------------------------------
-- A. ELIMINATE PARTIAL DEPENDENCY P1: StudentID --> Student-related details
-- -------------------------------------
-- StudentName, DeptCode, DeptName, and DeptLocation only depend on StudentID.
-- We move these attributes out into a new table.

-- RESULTING 2NF TABLE 1: Student_Info 
-- PRIMARY KEY: StudentID
-- Note: This table still contains the Transitive Dependency (DeptCode -> DeptName, DeptLocation).

-- StudentID | StudentName | DeptCode | DeptName | DeptLocation
-- --------------------------------------------------------------------------------
-- 23CS102   | Priya Sharma| CS01     | Computer Science | Block A, Main Campus
-- 23CS103   | Arjun Mehta | CS01     | Computer Science | Block A, Main Campus
-- 23EE201   | Neha Gupta  | EE02     | Electrical Engineering | Block B, East Campus
-- 23ME045   | Rohan Verma | ME01     | Mechanical Engineering | Block C, Engineering Wing


-- -------------------------------------
-- B. ELIMINATE PARTIAL DEPENDENCY P2: CourseID --> Course-related details
-- -------------------------------------
-- CourseTitle and CourseCredits only depend on CourseID.
-- We move these attributes out into a new table.

-- RESULTING 2NF TABLE 2: Course_Info 
-- PRIMARY KEY: CourseID

-- CourseID | CourseTitle      | CourseCredits
-- ------------------------------------------------------
-- CS205    | Data Structures  | NULL
-- CS206    | Operating Systems| NULL
-- EE301    | Circuit Theory   | NULL
-- ME302    | Thermodynamics   | NULL


-- -------------------------------------
-- C. THE REMAINDER TABLE
-- -------------------------------------
-- The remaining attributes are fully dependent on the entire PK {StudentID, CourseID}.

-- RESULTING 2NF TABLE 3: Enrollment_Grade
-- PRIMARY KEY: {StudentID, CourseID}
-- FOREIGN KEYS: StudentID, CourseID

-- StudentID | CourseID | FacultyID | FacultyName | ExamSemester | Grade
-- --------------------------------------------------------------------
-- 23CS102   | CS205    | NULL      | NULL        | NULL         | NULL
-- 23CS103   | CS206    | NULL      | NULL        | NULL         | NULL
-- 23EE201   | EE301    | NULL      | NULL        | NULL         | NULL
-- 23ME045   | ME302    | NULL      | NULL        | NULL         | NULL

-- -----------------------------------------------------------
-- ALL 2NF REQUIREMENTS ARE NOW MET.
-- The next step is to normalize the Student_Info table to 3NF to eliminate the Transitive Dependency.
-- -----------------------------------------------------------

-- -----------------------------------------------------------
-- ------------------------------------------------------------- -----------------------------------------------------------
-- [Task 5] Normalize the resulting 2NF table(s) to Third Normal Form (3NF) and, if necessary, Boyce-Codd Normal Form (BCNF), addressing Transitive Dependencies. Provide the final normalized tables, their Primary Keys (PK), Foreign Keys (FK), and
-- explain the normalization process.
-- -----------------------------------------------------------
-- [ANS]
-- -----------------------------------------------------------
-- 🏆 TASK 5: NORMALIZATION TO THIRD NORMAL FORM (3NF) and BCNF
-- -----------------------------------------------------------

-- The remaining issue is the Transitive Dependency in the Student_Info table:
-- StudentID --> DeptCode --> DeptName, DeptLocation.
-- To achieve 3NF, we must eliminate this dependency by isolating the DeptCode-dependent attributes.

-- -------------------------------------
-- A. ELIMINATE TRANSITIVE DEPENDENCY: DeptCode --> Department-related details
-- -------------------------------------
-- We decompose the 2NF Table 1 (Student_Info) into two 3NF tables.

-- RESULTING 3NF TABLE 1: Department (New table for department details)
-- PRIMARY KEY: DeptCode (The determinant in the transitive dependency)

-- DeptCode | DeptName               | DeptLocation
-- --------------------------------------------------------------------------------
-- CS01     | Computer Science       | Block A, Main Campus
-- EE02     | Electrical Engineering | Block B, East Campus
-- ME01     | Mechanical Engineering | Block C, Engineering Wing

-- RESULTING 3NF TABLE 2: Student (Remaining student-specific details)
-- PRIMARY KEY: StudentID
-- FOREIGN KEY: DeptCode (Link to the new Department table)

-- StudentID | StudentName | DeptCode
-- ----------------------------------------
-- 23CS102   | Priya Sharma| CS01
-- 23CS103   | Arjun Mehta | CS01
-- 23EE201   | Neha Gupta  | EE02
-- 23ME045   | Rohan Verma | ME01

-- -------------------------------------
-- B. FINAL NORMALIZED TABLES (3NF/BCNF)
-- -------------------------------------
-- The other 2NF tables (Course_Info and Enrollment_Grade) already meet 3NF requirements.
-- We also introduce a dedicated Faculty table to further reduce redundancy/nulls in Enrollment.

-- FINAL TABLE 1: Department (3NF/BCNF)
-- PK: DeptCode
-- Attributes: DeptCode, DeptName, DeptLocation

-- FINAL TABLE 2: Course (3NF/BCNF)
-- PK: CourseID
-- Attributes: CourseID, CourseTitle, CourseCredits

-- FINAL TABLE 3: Student (3NF/BCNF)
-- PK: StudentID
-- FK: DeptCode
-- Attributes: StudentID, StudentName, DeptCode

-- FINAL TABLE 4: Faculty (New Entity Table - Recommended for 3NF completeness)
-- PK: FacultyID
-- Attributes: FacultyID, FacultyName

-- FINAL TABLE 5: Enrollment (3NF/BCNF)
-- PK: {StudentID, CourseID}
-- FKs: StudentID, CourseID, FacultyID
-- Attributes: StudentID, CourseID, FacultyID, ExamSemester, Grade
-- Note: FacultyName was removed from this table to eliminate redundancy based on FacultyID.

-- -----------------------------------------------------------
-- ALL TABLES ARE NOW IN THIRD NORMAL FORM (3NF) and BCNF.
-- -----------------------------------------------------------


