-- 分页功能 LIMIT 从第几条开始，返回的记录行数
--SELECT id,name FROM T_Person LIMIT 0,2;

-- LIMIT 和条件指令 WHERE 给合使用，可以很方便的作出分页功能
--SELECT id,name FROM T_Person
--WHERE id >1
--LIMIT 2;

-- 创建 T_Person 表
CREATE TABLE IF NOT EXISTS 'T_Person' (
'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
'name' TEXT,
'age' INTEGER,
'height' REAL
);


-- 创建 T_status 表
-- createTime text: (datetime('now','localtime'))
DROP TABLE IF EXISTS "T_Status";
CREATE TABLE "T_Status" (
  "statusId" INTEGER NOT NULL,
  "status" text,
  "userId" integer,
  "createTime" text DEFAULT (datetime('now','localtime')),
  PRIMARY KEY ("statusId")
);


