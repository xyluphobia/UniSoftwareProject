use betracker;
select * from incometypes;

set foreign_key_checks = 0;
alter table incomes modify IncomeID int auto_increment;
alter table incometypes modify IncomeTypeID int auto_increment;
alter table expenses modify ExpenseID int auto_increment;
alter table expensetypes modify ExpenseTypeID int auto_increment;
set foreign_key_checks = 1;
