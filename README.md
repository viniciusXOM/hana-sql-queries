# hana-sql-queries
Various SQL queries in HANA

- [tora_users.sql](https://github.com/viniciusXOM/hana-sql-queries/blob/main/tora_users.sql) - List of TORA users from YMTRTBUSER/USERTYPE tables from all STRIPES boxes, merged with GRDB data to fetch users' country information
- [fin_trades.sql](https://github.com/viniciusXOM/hana-sql-queries/blob/main/fin_trades.sql) - List of TORA financial trades from YMTRDEFUT table (NA and EU boxes), incluing additional attributes such as strategies and book from respective tables
- [basic_strategy_list.sql](https://github.com/viniciusXOM/hana-sql-queries/blob/main/basic_strategy_list.sql) - Very basic query joining main strategy related tables / attributes together
- [physical_trades.sql](https://github.com/viniciusXOM/hana-sql-queries/blob/main/physical_trades.sql) - Join of YMTRADEHDR + YMTRADEITM + other reference tables for a basic list of physical trades and attributes
