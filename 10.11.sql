--CREATE PROCEDURE GetTopStudent
--AS
--BEGIN
--    SELECT TOP 1 StudentFirstName, StudentLastName FROM Students
--    JOIN BorrowedBooks ON Students.StudentId = BorrowedBooks.StudentId
--    GROUP BY StudentFirstName, StudentLastName
--    ORDER BY COUNT(BorrowedBooks.BookId) DESC;
--END;

-----------------------------------

--CREATE PROCEDURE GetTotalBorrowedBooks
--AS
--BEGIN
--    SELECT (SELECT COUNT(*) FROM BorrowedBooks WHERE BorrowerType = 'Student') AS StudentBorrowed,
--           (SELECT COUNT(*) FROM BorrowedBooks WHERE BorrowerType = 'Teacher') AS TeacherBorrowed;
--END;

-----------------------------------

CREATE PROCEDURE GetBooks
    @AuthorFirstName NVARCHAR(50),
    @AuthorLastName NVARCHAR(50),
    @Theme NVARCHAR(50),
    @Category NVARCHAR(50),
    @SortColumn INT,
    @SortDirection NVARCHAR(4)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @SortColumnName NVARCHAR(50);

    SELECT @SortColumnName = 
        CASE @SortColumn
            WHEN 1 THEN 'AuthorFirstName'
            WHEN 2 THEN 'AuthorLastName'
            WHEN 3 THEN 'Theme'
            WHEN 4 THEN 'Category'
            ELSE 'BookID' 
        END;

    SET @SQL = N'SELECT * FROM Books 
                 WHERE AuthorFirstName LIKE @AuthorFirstName 
                 AND AuthorLastName LIKE @AuthorLastName 
                 AND Theme LIKE @Theme 
                 AND Category LIKE @Category 
                 ORDER BY ' + QUOTENAME(@SortColumnName) + ' ' + @SortDirection;

    EXEC sp_executesql @SQL, 
        N'@AuthorFirstName NVARCHAR(50), @AuthorLastName NVARCHAR(50), @Theme NVARCHAR(50), @Category NVARCHAR(50)', 
        @AuthorFirstName, @AuthorLastName, @Theme, @Category;
END;
