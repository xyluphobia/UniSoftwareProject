use betracker;
set foreign_key_checks = 0;
alter table assets modify AssetID int auto_increment;
set foreign_key_checks = 1;