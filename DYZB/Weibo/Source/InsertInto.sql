-- INSERT INTO T_Person
-- (name,height) VALUES ('zhangsan',1.5);

-- SELECT * FROM T_Person;

-- SELECT COUNT(*) FROM T_Person;

-- 分页功能
-- LIMIT 从第几条开始，返回的记录行数
-- SELECT id,name FROM T_Person LIMIT 0,2;

-- LIMIT 和条件指令 WHERE 给合使用，可以很方便的作出分页功能
SELECT id,name FROM T_Person
WHERE id >1
LIMIT 2;
