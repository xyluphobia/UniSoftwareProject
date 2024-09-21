use betracker;
set foreign_key_checks = 0;
alter table liabilitytypes modify LiabilityTypeID int auto_increment;
set foreign_key_checks = 1;