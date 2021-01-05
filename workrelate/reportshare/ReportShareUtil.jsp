<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.User" %>
<%!
/**
 * 得到可以访问的所有分部
 */
public String getAccessCpy(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String cpyIds = "";
	rs.execute("SELECT * FROM WR_ReportShare WHERE reportid=1 order by id");
	String userid = ""+user.getUID();
	int userSeclevel = Util.getIntValue(user.getSeclevel(),0);
	int sharelevel = 0;
	boolean isContain = false;
	int seclevel = 0;
	boolean isSqlServer = rs.getDBType().equals("sqlserver");
	while(rs.next()){
		seclevel = Util.getIntValue(rs.getString("seclevel"),0);
		isContain = isHavAccess(rs,user);
		
		if(isContain){
		    sharelevel = Util.getIntValue(rs.getString("sharelevel"));
			if(1 == sharelevel){//个人
				continue;
			}else if(2 == sharelevel){//同部门
				continue;
			}else if(3 == sharelevel){//同分部
				cpyIds += ","+user.getUserSubCompany1();
            }else if(4 == sharelevel){//总部
            	RecordSet rstemp = new RecordSet();
            	rstemp.execute("SELECT id FROM HrmSubCompany where canceled IS NULL  OR  canceled!=1");
            	while(rstemp.next()){
            		cpyIds += ","+rstemp.getString("id");
            	}
            }else if(5 == sharelevel){//同部门及下级部门
            	continue;
            }else if(6 == sharelevel){//多部门
            	continue;
            }else if(7 == sharelevel){//同分部及下级分部
            	RecordSet rstemp = new RecordSet();
            	//是否是sql server数据库
            	String sql = null;
                if(isSqlServer){
                    sql = "SELECT id FROM GetSubcpyIdsTreeWithSelf ('"+user.getUserSubCompany1()+"')";
                }else{
                    sql = "WITH mycte(id) "+
                            "     AS (SELECT id "+
                            "         FROM   HrmSubCompany "+
                            "         WHERE  1=1 "+
                            "               and id in("+user.getUserSubCompany1()+")"+
                            "               AND (canceled IS NULL  "+
                            "                   OR  canceled!=1) "+
                            "         UNION ALL "+
                            "         SELECT hrm.id "+
                            "         FROM   HrmSubCompany hrm, "+
                            "                mycte "+
                            "         WHERE  hrm.supsubcomid = mycte.id "+
                            "                AND (canceled IS NULL  "+
                            "                   OR  canceled!=1)) "+
                            " SELECT DISTINCT * "+
                            " FROM   mycte ";
                }
                rstemp.execute(sql);
                while(rstemp.next()){
                    cpyIds += ","+rstemp.getString("id");
                }
            }else if(8 == sharelevel){//多分部
            	String cpyids = Util.null2String(rs.getString("muticpyid"));
            	cpyIds += ","+cpyids;
            }else if(9 == sharelevel){//多人员
            	continue;
            }
		}
	}
	if(cpyIds.startsWith(",")){
		return cpyIds.substring(1);
	}
	return cpyIds;
}

/**
 * 得到可以访问的所有部门
 */
public String getAccessDept(User user){
    weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
    String deptIds = "";
    rs.execute("SELECT * FROM WR_ReportShare WHERE reportid=1 order by id");
    String userid = ""+user.getUID();
    int userSeclevel = Util.getIntValue(user.getSeclevel(),0);
    int sharelevel = 0;
    boolean isContain = false;
    int seclevel = 0;
    boolean isSqlServer = rs.getDBType().equals("sqlserver");
    while(rs.next()){
        seclevel = Util.getIntValue(rs.getString("seclevel"),0);
    	isContain = isHavAccess(rs,user);
        if(isContain){
            sharelevel = Util.getIntValue(rs.getString("sharelevel"));
            if(1 == sharelevel){//个人
                continue;
            }else if(2 == sharelevel){//同部门
            	deptIds += ","+user.getUserDepartment();
            }else if(3 == sharelevel){//同分部
                String cpyId = ""+user.getUserSubCompany1();
                RecordSet rstemp = new RecordSet();
                rstemp.execute("SELECT id FROM HrmDepartment where (canceled IS NULL  OR  canceled!=1) AND subcompanyid1="+cpyId);
                while(rstemp.next()){
                	deptIds += ","+rstemp.getString("id");
                }
            }else if(4 == sharelevel){//总部
                RecordSet rstemp = new RecordSet();
                rstemp.execute("SELECT id FROM HrmDepartment where canceled IS NULL  OR  canceled!=1");
                while(rstemp.next()){
                	deptIds += ","+rstemp.getString("id");
                }
            }else if(5 == sharelevel){//同部门及下级部门
            	 RecordSet rstemp = new RecordSet();
            	 String departmentid = ""+user.getUserDepartment();
            	 String sql = null;
            	if(isSqlServer){
                    sql = "SELECT id FROM GetDeptIdsTreeWithSelf ('"+departmentid+"')";
                }else{
                    sql = "WITH mycte(id) "+
                            "     AS (SELECT id "+
                            "         FROM   HrmDepartment "+
                            "         WHERE  1=1 "+
                            "               and id in("+departmentid+")"+
                            "               AND (canceled IS NULL  "+
                            "                   OR  canceled!=1) "+
                            "         UNION ALL "+
                            "         SELECT hrm.id "+
                            "         FROM   HrmDepartment hrm, "+
                            "                mycte "+
                            "         WHERE  hrm.supdepid = mycte.id "+
                            "                AND (hrm.canceled IS NULL  "+
                            "                   OR  hrm.canceled!=1)) "+
                            " SELECT DISTINCT * "+
                            " FROM   mycte ";
                }
            	rstemp.execute(sql);
            	while(rstemp.next()){
                    deptIds += ","+rstemp.getString("id");
                }
            }else if(6 == sharelevel){//多部门
            	String mutideptid = Util.null2String(rs.getString("mutideptid"));
            	deptIds += ","+mutideptid;
            }else if(7 == sharelevel){//同分部及下级分部
                RecordSet rstemp = new RecordSet();
                //是否是sql server数据库
                String sql = null;
                if(isSqlServer){
                    sql = "  SELECT id FROM HrmDepartment WHERE (canceled IS NULL  OR  canceled!=1) AND subcompanyid1 IN( SELECT id FROM GetSubcpyIdsTreeWithSelf ("+user.getUserSubCompany1()+"))";
                }else{
                    sql = "WITH mycte(id) "+
                            "     AS (SELECT id "+
                            "         FROM   HrmSubCompany "+
                            "         WHERE  1=1 "+
                            "               and id in("+user.getUserSubCompany1()+")"+
                            "               AND (canceled IS NULL  "+
                            "                   OR  canceled!=1) "+
                            "         UNION ALL "+
                            "         SELECT hrm.id "+
                            "         FROM   HrmSubCompany hrm, "+
                            "                mycte "+
                            "         WHERE  hrm.supsubcomid = mycte.id "+
                            "                AND (canceled IS NULL  "+
                            "                   OR  canceled!=1)) "+
                            " SELECT DISTINCT id FROM HrmDepartment WHERE (canceled IS NULL  OR  canceled!=1) AND subcompanyid1 IN("+
                            " SELECT * FROM   mycte )";
                }
                rstemp.execute(sql);
                while(rstemp.next()){
                	deptIds += ","+rstemp.getString("id");
                }
            }else if(8 == sharelevel){//多分部
                String muticpyid = Util.null2String(rs.getString("muticpyid"));
                RecordSet rstemp = new RecordSet();
                rstemp.execute("SELECT id FROM HrmDepartment WHERE (canceled IS NULL  OR  canceled!=1) AND subcompanyid1 IN("+muticpyid+")");
                while(rstemp.next()){
                    deptIds += ","+rstemp.getString("id");
                }
            }else if(9 == sharelevel){//多人员
                continue;
            }
        }
    }
    if(deptIds.startsWith(",")){
        return deptIds.substring(1);
    }
    return deptIds;
}

/**
 * 得到可以访问的所有人员
 */
public String getAccessResource(User user){
    weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
    rs.execute("SELECT * FROM WR_ReportShare WHERE reportid=1 order by id");
    int userSeclevel = Util.getIntValue(user.getSeclevel(),0);
    int sharelevel = 0;
    boolean isContain = false;
    int seclevel = 0;
    boolean isSqlServer = rs.getDBType().equals("sqlserver");
    StringBuffer returnSql = new StringBuffer(" (1=2");
    while(rs.next()){
        seclevel = Util.getIntValue(rs.getString("seclevel"),0);
        isContain = isHavAccess(rs,user);
        if(isContain){
            sharelevel = Util.getIntValue(rs.getString("sharelevel"));
            if(1 == sharelevel){//个人
            	returnSql.append(" OR id =" + user.getUID() + " ");
            }else if(2 == sharelevel){//同部门
            	returnSql.append(" OR departmentid =" + user.getUserDepartment() + " ");
            }else if(3 == sharelevel){//同分部
                returnSql.append(" OR subcompanyid1 =" + user.getUserSubCompany1() + " ");
            }else if(4 == sharelevel){//总部
                return " 1=1 ";
            }else if(5 == sharelevel){//同部门及下级部门
                 RecordSet rstemp = new RecordSet();
                 String departmentid = ""+user.getUserDepartment();
                 String sql = null;
                if(isSqlServer){
                    sql = "SELECT id FROM GetDeptIdsTreeWithSelf ('"+departmentid+"')";
                }else{
                    sql = "WITH mycte(id) "+
                            "     AS (SELECT id "+
                            "         FROM   HrmDepartment "+
                            "         WHERE  1=1 "+
                            "               and id in("+departmentid+")"+
                            "               AND (canceled IS NULL  "+
                            "                   OR  canceled!=1) "+
                            "         UNION ALL "+
                            "         SELECT hrm.id "+
                            "         FROM   HrmDepartment hrm, "+
                            "                mycte "+
                            "         WHERE  hrm.supdepid = mycte.id "+
                            "                AND (hrm.canceled IS NULL  "+
                            "                   OR  hrm.canceled!=1)) "+
                            " SELECT DISTINCT * "+
                            " FROM   mycte ";
                }
                rstemp.execute(sql);
                String deptIds = "";
                while(rstemp.next()){
                	if(deptIds.length()==0){
	                    deptIds += rstemp.getString("id");
                	}else{
                		deptIds += ","+rstemp.getString("id");
                	}
                }
                returnSql.append(" OR departmentid in(" + deptIds + ") ");
            }else if(6 == sharelevel){//多部门
                String mutideptid = Util.null2String(rs.getString("mutideptid"));
                returnSql.append(" OR departmentid in(" + mutideptid + ") ");
            }else if(7 == sharelevel){//同分部及下级分部
            	RecordSet rstemp = new RecordSet();
                //是否是sql server数据库
                String sql = null;
                if(isSqlServer){
                    sql = "SELECT id FROM GetSubcpyIdsTreeWithSelf ('"+user.getUserSubCompany1()+"')";
                }else{
                    sql = "WITH mycte(id) "+
                            "     AS (SELECT id "+
                            "         FROM   HrmSubCompany "+
                            "         WHERE  1=1 "+
                            "               and id in("+user.getUserSubCompany1()+")"+
                            "               AND (canceled IS NULL  "+
                            "                   OR  canceled!=1) "+
                            "         UNION ALL "+
                            "         SELECT hrm.id "+
                            "         FROM   HrmSubCompany hrm, "+
                            "                mycte "+
                            "         WHERE  hrm.supsubcomid = mycte.id "+
                            "                AND (canceled IS NULL  "+
                            "                   OR  canceled!=1)) "+
                            " SELECT DISTINCT * "+
                            " FROM   mycte ";
                }
                rstemp.execute(sql);
                String cpyIds = "";
                while(rstemp.next()){
                    if(cpyIds.length()==0){
                    	cpyIds += rstemp.getString("id");
                    }else{
                    	cpyIds += ","+rstemp.getString("id");
                    }
                }
                returnSql.append(" OR subcompanyid1 in(" + cpyIds + ") ");
            }else if(8 == sharelevel){//多分部
                String muticpyid = Util.null2String(rs.getString("muticpyid"));
                returnSql.append(" OR subcompanyid1 in(" + muticpyid + ") ");
            }else if(9 == sharelevel){//多人员
            	String mutiuserid = Util.null2String(rs.getString("mutiuserid"));
            	returnSql.append(" OR id in(" + mutiuserid + ") ");
            }
        }
    }
    returnSql.append(")");
    return returnSql.toString();
}

/**
 * 判断是否有权限
 */
public boolean isHavAccess(RecordSet rs,User user){
    String userid = ""+user.getUID();
    int userSeclevel = Util.getIntValue(user.getSeclevel(),0);
    int sharelevel = 0;
    boolean isContain = false;
    String sharetype = Util.null2String(rs.getString("sharetype"));
    int seclevel = Util.getIntValue(rs.getString("seclevel"),0);
    if("1".equals(sharetype)){//人力资源
        String userids = Util.null2String(rs.getString("userid"));
        String[] useridArr = userids.split(",");
        //查看用户id是否在该共享中
        if(Arrays.asList(useridArr).contains(userid)){
            isContain = true;
        }
    }else if(sharetype.equals("2") && userSeclevel >= seclevel){//部门
        String deptids = Util.null2String(rs.getString("deptid"));
        String deptid = ""+user.getUserDepartment();
        String[] deptidArr = deptids.split(",");
        //查看用户id是否在该共享中
        if(Arrays.asList(deptidArr).contains(deptid)){
            isContain = true;
        }
    }else if(sharetype.equals("3") && userSeclevel >= seclevel){//角色
        int roleid = Util.getIntValue(rs.getString("roleid"));
        int rolelevel = Util.getIntValue(rs.getString("rolelevel"));
        RecordSet rstemp = new RecordSet();
        rstemp.execute("SELECT roleid,rolelevel FROM HrmRoleMembers WHERE resourceid=" + userid);
        while(rstemp.next()){
            if(roleid == rstemp.getInt("roleid") && rolelevel >= rstemp.getInt("rolelevel")){
                isContain = true;
                break;
            }
        }
    }else if(sharetype.equals("4") && userSeclevel >= seclevel){//所有人
        isContain = true;
    }
    return isContain;
}
%>