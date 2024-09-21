use betracker;
set foreign_key_checks = 0;
alter table liabilities modify LiabilityID int auto_increment;
set foreign_key_checks = 1;