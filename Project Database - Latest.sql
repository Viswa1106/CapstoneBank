create database Bank_CRM;

use Bank_CRM;


Drop table  geography;

create table geography (
  GeographyId int primary key,
  GeographyLocation varchar(255)
);

INSERT into geography (GeographyId,GeographyLocation)
values (
1,'France'),
(2,'Spain'),
(3,'Germany');

create table CustomerInfo(
	CustomerId int primary key,
    Surname varchar(255),
    Age int,
    GenderID int,
    EstimatedSalary	int,
    GeographyID	int,
    BankDOJ date,
    foreign key (GenderID) references gender(GenderID),
    foreign key(GeographyId) references geography(GeographyId)
    );
    
    
create table Gender(
	GenderID int primary key,
    GenderCategory varchar(10));

INSERT INTO Gender(GenderID,GenderCategory)
values(1,'Male'),
(2,'Female');

truncate table gender;

select * from gender;

create table ActiveCustomer(
ActiveID int primary key,
ActiveCategory varchar(255));

alter table activecustomer add primary key (ActiveID);

select * from customerinfo;

	create table Bank_churn(
		CustomerId int,
		foreign key (CustomerId) references customerinfo(CustomerId),
		CreditScore int,
		Tenure int,
		Balance int,
		NumOfProducts int,
		HasCrCard int,
		foreign key (HasCrCard) references creditcard(CreditID),
		IsActiveMember int,
		foreign key (IsActiveMember) references activecustomer(ActiveID),
		Exited int,
		foreign key (Exited) references exitcustomer(ExitID)
		);
    
    create table ExitCustomer(
		ExitID int primary key,
        ExitCategory varchar(40));
        
create table creditcard(
	CreditID int primary key,
    Category varchar(55));


truncate table customerinfo;

select * from bank_churn;
 
DELETE FROM customerinfo WHERE GenderID = 2;

drop table bank_churn;

drop table activecustomer;

select * from geography;




