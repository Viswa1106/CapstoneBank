select * from books;

select * from authors;

select * from book_loans;

select b.book_id, b.title, a.author_name
from books b
join
authors a on b.author_id = a.author_id
join
book_loans bl on b.book_id = bl.book_id;

select * from department;

select * from student;

SELECT s.StudentID as Student_ID, s.Name as Student_Name, d.DepartmentName as Department_Name,f.facultyname as Faculty_Name	
FROM Student s 
INNER JOIN Department d ON s.DepartmentID = d.DepartmentID
inner join faculty f on d.departmentid = f.departmentid
where s.percentage > 85
order by s.percentage desc;

select * from orders;

select * from payment;

select o.order_id
from orders o
join
payment p on o.order_id = p.order_id;

select * from customers;

select * from orders;




