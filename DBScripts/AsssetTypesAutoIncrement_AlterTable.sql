use betracker;
set foreign_key_checks = 0;
alter table assettypes modify AssetTypeID int auto_increment;
set foreign_key_checks = 1;