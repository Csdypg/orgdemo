-- 创建数据库，并创建权限用户
-- CREATE DATABASE 'ssm' CHARACTER SET utf8;
drop DATABASE IF EXISTS ssm;
CREATE DATABASE ssm CHARACTER SET utf8 COLLATE utf8_general_ci;

drop user 'ssm'@'localhost';
create user 'ssm'@'localhost' IDENTIFIED by 'ssm';
GRANT all PRIVILEGES on ssm.* to 'ssm'@'localhost';
flush PRIVILEGES;

-- 创建org表
drop table IF EXISTS org;
CREATE TABLE `org` (
  `org_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) DEFAULT NULL,
  `left` int(11) DEFAULT NULL,
  `right` int(11) DEFAULT NULL,
  `desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;


TRUNCATE table org;
insert into org values (1,'中国',1,18,'...');
insert into org values (2,'河南',2,11,'...');
insert into org values (3,'郑州',3,6,'...');
insert into org values (4,'金水区',4,5,'...');
insert into org values (5,'南阳',7,10,'...');
insert into org values (6,'内乡',8,9,'...');
insert into org values (7,'河北',12,17,'...');
insert into org values (8,'石家庄',13,14,'...');
insert into org values (9,'邢台',15,16,'...');


-- 创建统计层数function
drop function IF EXISTS ssm.fn_count_layer;
create function ssm.fn_count_layer(
  p_org_id int
)
returns INT
BEGIN
  DECLARE layer int default 0;
  declare p_left int;
  declare p_right int;
  if exists(select 1 from org where org_id = p_org_id) then
      select `left`,`right` from org where org_id = p_org_id into  p_left,p_right;
      select count(*) into layer from org where `left` <= p_left and `right` >= p_right;
  END IF;
  return (layer);
end;


-- 创建树形结构数据view
drop view IF EXISTS ssm.v_org;
create view ssm.v_org as
SELECT org_id, name, `left`, `right`, ssm.fn_count_layer(org_id) AS layer,`desc` FROM ssm.org ORDER BY `left`;

-- 创建根据节点org_id获取树结构列表procedure
drop procedure IF EXISTS ssm.pro_get_tree_list_by_node;
CREATE PROCEDURE ssm.pro_get_tree_list_by_node
(
in p_org_id int -- 给定节点标识
)
  BEGIN
declare p_left int;
declare p_right int;
  if exists (select 1 from org where org_id=p_org_id) then
    select `left`,`right` from org where org_id = p_org_id into  p_left,p_right;
    select * from v_org where `left` between p_left and p_right order by `left` asc;
  end if;
end;

-- 创建根据节点org_id获取下一等级的机构procedure
drop procedure IF EXISTS ssm.pro_get_next_layer_by_id;
CREATE PROCEDURE ssm.pro_get_next_layer_by_id
  (
    in p_org_id int -- 给定节点标识
  )
  BEGIN
    declare p_left int;
    declare p_right int;
    declare p_layer int;
    if exists (select 1 from v_org where org_id=p_org_id) then
      select `left`,`right`,layer from v_org where org_id = p_org_id into  p_left,p_right,p_layer;
      select * from v_org where layer = p_layer+1 and `left` between p_left and p_right order by `left` asc;
    end if;
  end;


-- 创建增加子节点procedure
drop PROCEDURE IF EXISTS ssm.pro_add_sub_node_by_node;
CREATE PROCEDURE ssm.pro_add_sub_node_by_node
(
  in p_org_id int,
  in p_name varchar(255),
  in p_desc VARCHAR(255)
)
BEGIN
  declare p_right int;
  if exists (select 1 from org where org_id= p_org_id) then
    -- SET XACT_ABORT = 'ON'; -- mysql has no such method like ohter database
      START TRANSACTION;
      select `right` from org where org_id=p_org_id into p_right;
      update org set `right`=`right`+2 where `right`>=p_right;
      update org set `left`=`left`+2 where `left`>=p_right;
      insert into org (name,`left`, `right`,`desc`) values (p_name,p_right,p_right+1,p_desc);
      COMMIT;
    -- SET XACT_ABORT = 'OFF';
  end if;
end;


-- 创建 删除节点procedure
drop procedure IF EXISTS ssm.pro_del_org_by_id;
CREATE PROCEDURE ssm.pro_del_org_by_id
  (
    in p_org_id int
  )
BEGIN
  declare p_left int;
  declare p_right int;
  if exists (select 1 from org where org_id=p_org_id) THEN
    START TRANSACTION;
    select `left`,`right` from org where org_id = p_org_id into p_left,p_right;
    delete from org where `left`>=p_left and `right`<=p_right;
    update org set `left`=`left`-(p_right-p_left+1) where `left`>p_left;
    update org set `right`=`right`-(p_right-p_left+1) where `right`>p_right;
    COMMIT;
  END IF;
End;


-- 同层上移功能(下移同理)
drop PROCEDURE IF EXISTS ssm.pro_move_org_up;
CREATE PROCEDURE ssm.pro_move_org_up
  (
    in p_org_id int
  )
  BEGIN
    declare p_left int;
    declare p_right int;
    declare p_layer int;
    declare p_brother_lft int;
    declare p_brother_rgt int;
    if exists (select 1 from org where org_id = p_org_id) then
      select `left`,`right`,`layer` from v_org where org_id = p_org_id into p_left,p_right,p_layer;
      if exists (select 1 from v_org where `right`=p_left-1 and layer=p_layer) then -- 是否存在前一节点
        select `left`,`right` from v_org where `right` = p_left-1 and layer = p_layer into p_brother_lft,p_brother_rgt;
        START TRANSACTION;
        update org set `left`=`left`-(p_brother_rgt-p_brother_lft+1) where `left`>=p_left and `right`<=p_right;-- 改变当前节点及其所有子节点右编码
        update org set `left`=`left`+(p_right-p_left+1) where `left`>=p_brother_lft and `right`<=p_brother_rgt;-- 改变前一节点及其所有子节点右编码
        update org set `right`=`right`-(p_brother_rgt-p_brother_lft+1) where `right`>p_brother_rgt and `right`<=p_right;-- 改变当前节点及其所有子节点左编码
        update org set `right`=`right`+(p_right-p_left+1) where `left`>=p_brother_lft+(p_right-p_left+1) and `right`<=p_brother_rgt;-- 改变前一节点及其所有子节点左编码
        COMMIT;
      end if;
    end if;
  end;