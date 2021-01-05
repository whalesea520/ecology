
ALTER PROCEDURE [dbo].[RoleStrTree_SByURId] @userid int,@roleid int, @flag integer OUTPUT,
                                                                                   @msg varchar(4000) OUTPUT AS DECLARE @temptree1 TABLE (id int,operateType_Range int) DECLARE @temptree2 TABLE (id int,parent_id int,operateType_Range int) DECLARE @temptree3 TABLE (id int,parent_id int,nodetype int,operateType_Range int) DECLARE @temptree4 TABLE (rightid int,subcomid int,rightlevel int) DECLARE @rowcount int DECLARE @c1
CURSOR DECLARE @id int
SELECT @rowcount=count(*)
FROM SystemRightRoles
WHERE roleid=@roleid IF @rowcount>0 BEGIN
  INSERT @temptree4
  SELECT b.rightid,
         c.subcompanyid,
         max(c.rightlevel)
  FROM HrmRoleMembers a,
       SystemRightRoles b,
       SysRoleSubcomRight c
  WHERE a.roleid=b.roleid
    AND a.roleid=c.roleid
    AND a.resourceid=@userid
    AND b.rightid IN
      (SELECT rightid
       FROM SystemRightRoles
       WHERE roleid=@roleid)
    --AND b.roleid<>@roleid
  GROUP BY b.rightid,
           c.subcompanyid
  INSERT @temptree1
  SELECT subcomid,
         min(rightlevel)
  FROM @temptree4
  GROUP BY subcomid
  HAVING count(subcomid)=
    (SELECT count(distinct(rightid))
     FROM @temptree4) END ELSE BEGIN
  INSERT @temptree1
  SELECT subcompanyid,
         min(rightlevel)
  FROM SysRoleSubcomRight
  WHERE roleid IN
      (SELECT roleid
       FROM HrmRoleMembers
       WHERE resourceid=@userid)
    AND roleid<>@roleid
  GROUP BY subcompanyid
  HAVING count(subcompanyid)=
    (SELECT count(roleid)
     FROM HrmRoleMembers
     WHERE resourceid=@userid
       AND roleid<>@roleid) END
  INSERT @temptree2
  SELECT a.id,
         b.supsubcomid,
         a.operateType_Range
  FROM @temptree1 a,
       hrmsubcompany b WHERE a.id=b.id
  SET @c1 =
  CURSOR FORWARD_ONLY STATIC
  FOR
  SELECT id
  FROM @temptree2 WHERE parent_id<>0
  AND parent_id NOT IN
    (SELECT id
     FROM @temptree2) OPEN @c1 FETCH NEXT
  FROM @c1 INTO @id WHILE @@FETCH_STATUS = 0 BEGIN
  SELECT @rowcount=count(*)
  FROM @temptree3
  WHERE id IN
      (SELECT id
       FROM getSubComParentTree(@id)) IF @rowcount=0 BEGIN
    INSERT INTO @temptree3
    SELECT id,
           supsubcomid,
           0,
           0
    FROM getSubComParentTree(@id) END FETCH NEXT
    FROM @c1 INTO @id END
  INSERT INTO @temptree3
  SELECT id,
         parent_id,
         1,
         operateType_Range
  FROM @temptree2
  SELECT *
  FROM @temptree3