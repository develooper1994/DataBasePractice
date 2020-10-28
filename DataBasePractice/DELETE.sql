-- 'DELETE' doesn't remove the SETTINGS and auto-increment continues.
-- slow operation when compared to 'truncate'
USE ETRADE
SELECT * FROM CUSTOMERS

-- DELETE FROM CUSTOMERS  -- deletes everything
-- DELETE FROM CUSTOMERS WHERE ID=4  -- deletes with condition