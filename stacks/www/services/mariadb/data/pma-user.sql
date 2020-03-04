create user 'pma'@'%' identified by 'ja2WyLe2Ebx96mdP';
GRANT USAGE ON mysql.* TO 'pma'@'%';
GRANT SELECT ON mysql.db TO 'pma'@'%';
GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv) ON mysql.tables_priv TO 'pma'@'%';
GRANT SELECT (Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv) ON mysql.user TO 'pma'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'%';

SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";
USE phpmyadmin;

TRUNCATE TABLE `pma__userconfig`;

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2020-02-24 10:08:51', '{\"Console\\/Mode\":\"collapse\",\"Server\\/hide_db\":\"^(information_schema|performance_schema|mysql|phpmyadmin)$\",\"2fa\":{\"type\":\"db\",\"backend\":\"\",\"settings\":[]}}');

COMMIT;
