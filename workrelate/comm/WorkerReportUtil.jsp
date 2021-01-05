<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%! 


	/**
	 * 
	 * 得到人员sql
	 * @param hrmids
	 * @param subcompanyids
	 * @param departmentids
	 * @param cpyincludesub
	 * @param deptincludesub
	 * @param iNextNum
	 * @param ipageset
	 * @return
	 */
	public String getPageHrmSql(String hrmids, String subcompanyids, String departmentids, String cpyincludesub, String deptincludesub, int iNextNum, int ipageset, int ipagesize){
	    StringBuffer pageHrmids = new StringBuffer();
	    weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	    //是否是sql server数据库
	    boolean isSqlServer = rs.getDBType().equals("sqlserver");
	    int iTotal = 0;
	    String ids = "";
	    String backfields = null;
	    String fromSql = null;
	    String sqlWhere = null;
	    String[] orderbyFields = new String[]{"id"};
	    String order = "asc";
	    
	    //如果没有查询条件，则查询所有人的数据
	    if(isEmpty(hrmids) && isEmpty(subcompanyids) && isEmpty(departmentids)){
	        backfields = "*";
	        fromSql = " from HrmResource";
	        sqlWhere = " where 1=1 and status<=3 ";
	    //如果人员id不为空，则查询指定人员的数据
	    }else if(!isEmpty(hrmids)){
	        backfields = "*";
	        fromSql = " from HrmResource";
	        sqlWhere = " where id in("+hrmids+") and status<=3 ";
	    //如果部门id不为空，则查询指定部门的数据
	    }else if(!isEmpty(departmentids)){
	        ids = getDeptIds(departmentids,deptincludesub);
	        //如果所查询的部门id为空则返回0
	        if(isEmpty(ids)){
	            return "";
	        }
	        backfields = "*";
	        fromSql = " from HrmResource";
	        sqlWhere = " where departmentid in("+ids+") and status<=3 ";
	    //如果分部id不为空，则查询指定分部的数据
	    }else if(!isEmpty(subcompanyids)){
	        ids = getCpyIds(subcompanyids,cpyincludesub);
	        //如果所查询的分部id为空则返回0
	        if(isEmpty(ids)){
	            return "";
	        }
	        backfields = "*";
	        fromSql = " from HrmResource";
	        sqlWhere = " where subcompanyid1 in("+ids+")  and status<=3 ";
	    }
	    String sql = null;
	    if(isSqlServer){
	        sql = getPageSql(backfields,fromSql, sqlWhere, orderbyFields, order, iNextNum, ipageset);
	    }else{
	    	if(ipagesize>=10000){
	    		sql = "select "+backfields + fromSql + sqlWhere + getOrderSql(orderbyFields,order);
	    	}else{
	    		sql = "select * from (select A.*,rownum rn from (select "+
		                backfields + fromSql + sqlWhere + getOrderSql(orderbyFields,order) + 
		                " ) A where rownum<=" + iNextNum +" ) B where rn>" + (iNextNum-ipagesize);
	    	}
	    }
	    rs.execute(sql);
	    while(rs.next()){
	        pageHrmids.append(","+rs.getString("id"));
	    }
	    return sql;
	}
	/**
	 * 
	 * 得到人员id
	 * @param hrmids
	 * @param subcompanyids
	 * @param departmentids
	 * @param cpyincludesub
	 * @param deptincludesub
	 * @param iNextNum
	 * @param ipageset
	 * @return
	 */
	public String getPageHrmids(String hrmids, String subcompanyids, String departmentids, String cpyincludesub, String deptincludesub, int iNextNum, int ipageset, int ipagesize){
	    StringBuffer pageHrmids = new StringBuffer();
	    weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	    //是否是sql server数据库
	    boolean isSqlServer = rs.getDBType().equals("sqlserver");
	    int iTotal = 0;
	    String ids = "";
	    String backfields = null;
	    String fromSql = null;
	    String sqlWhere = null;
	    String[] orderbyFields = new String[]{"id"};
	    String order = "asc";
	    
	    //如果没有查询条件，则查询所有人的数据
	    if(isEmpty(hrmids) && isEmpty(subcompanyids) && isEmpty(departmentids)){
	        backfields = "id";
	        fromSql = " from HrmResource";
	        sqlWhere = " where 1=1 and status<=3 ";
	    //如果人员id不为空，则查询指定人员的数据
	    }else if(!isEmpty(hrmids)){
	        backfields = "id";
	        fromSql = " from HrmResource";
	        sqlWhere = " where id in("+hrmids+") and status<=3 ";
	    //如果部门id不为空，则查询指定部门的数据
	    }else if(!isEmpty(departmentids)){
	        ids = getDeptIds(departmentids,deptincludesub);
	        //如果所查询的部门id为空则返回0
	        if(isEmpty(ids)){
	            return "";
	        }
	        backfields = "id";
	        fromSql = " from HrmResource";
	        sqlWhere = " where departmentid in("+ids+") and status<=3 ";
	    //如果分部id不为空，则查询指定分部的数据
	    }else if(!isEmpty(subcompanyids)){
	        ids = getCpyIds(subcompanyids,cpyincludesub);
	        //如果所查询的分部id为空则返回0
	        if(isEmpty(ids)){
	            return "";
	        }
	        rs.executeSql("select count(1) from HrmResource where subcompanyid1 in("+ids+") and status<=3 ");
	        backfields = "id";
	        fromSql = " from HrmResource";
	        sqlWhere = " where subcompanyid1 in("+ids+")  and status<=3 ";
	    }
	    String sql = null;
	    if(isSqlServer){
	        sql = getPageSql(backfields,fromSql, sqlWhere, orderbyFields, order, iNextNum, ipageset);
	    }else{
	    	if(ipagesize>=10000){
	    		sql = "select "+ backfields + fromSql + sqlWhere + getOrderSql(orderbyFields,order);  
	    	}else{
	    		sql = "select * from (select A.*,rownum rn from (select "+
	                    backfields + fromSql + sqlWhere + getOrderSql(orderbyFields,order) + 
	                    " ) A where rownum<=" + iNextNum +" ) B where rn>" + (iNextNum-ipagesize);  
	    	}
	    }
	    rs.execute(sql);
	    while(rs.next()){
	        pageHrmids.append(","+rs.getString("id"));
	    }
	    return pageHrmids.length()>0?pageHrmids.substring(1):"";
	}
	
	
	/**
	 * 得到分页sql
	 * @param backfields
	 * @param fromSql
	 * @param sqlWhere
	 * @param orderbyFields
	 * @param order
	 * @return
	 */
	public String getPageSql(String backfields,String fromSql,String sqlWhere,String[] orderbyFields,String order,int maxNum,int pageset){
	    String orderby1 = getOrderSql(orderbyFields,order);
	    String orderby2 = getOrderSql(orderbyFields,"asc".equalsIgnoreCase(order)?"desc":"asc");
	    String orderby3 = getOrderSql(orderbyFields,order);
	    
	    String sql = "select top " + pageset +" A.* "
	                 + "from (" 
	                 +         "select top " + maxNum + " " + backfields 
	                 +" " +     fromSql 
	                 +" " +     sqlWhere  
	                 +" " +     orderby3 
	                 +" " +   ") A "+
	                   orderby2;
	    sql = "select top " + pageset +" B.* from (" + sql + ") B "+orderby1;
	    if(pageset>=10000){
	    	sql = "select " + backfields 
            	+" " +     fromSql 
            	+" " +     sqlWhere  
            	+" " +     orderby3;
	    }
	    	
	    return sql;
	}
	
	/**
	 * 得到排序sql
	 * @param orderbyFields 排序字段
	 * @param order 排序规则("desc"/"asc")
	 * @return
	 */
	private String getOrderSql(String[] orderbyFields, String order) {
	    StringBuffer sb = new StringBuffer(" ORDER BY ");
	    for (int i = 0; i < orderbyFields.length; i++) {
	        if(i == 0){
	            sb.append(orderbyFields[i] + " " + order + " ");
	        }else{
	            sb.append("," + orderbyFields[i] + " " + order + " ");
	        }
	    }
	    return sb.toString();
	}

    /**
     * 
     * 得到数据总数
     * @param hrmids
     * @param subcompanyids
     * @param departmentids
     * @param cpyincludesub
     * @param deptincludesub
     * @return
     */
    public int getTotalRecord(String hrmids, String subcompanyids, String departmentids, String cpyincludesub, String deptincludesub){
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        int iTotal = 0;
        String ids = "";
        //如果没有查询条件，则查询所有人的数据
        if(isEmpty(hrmids) && isEmpty(subcompanyids) && isEmpty(departmentids)){
            rs.executeSql("select count(1) from HrmResource WHERE status<=3");
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        //如果人员id不为空，则查询指定人员的数据
        }else if(!isEmpty(hrmids)){
            rs.executeSql("select count(1) from HrmResource where id in("+hrmids+") and status<=3");
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        //如果部门id不为空，则查询指定部门的数据
        }else if(!isEmpty(departmentids)){
            ids = getDeptIds(departmentids,deptincludesub);
            //如果所查询的部门id为空则返回0
            if(isEmpty(ids)){
                return 0;
            }
            rs.executeSql("select count(1) from HrmResource where departmentid in("+ids+") AND status<=3");
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        //如果分部id不为空，则查询指定分部的数据
        }else if(!isEmpty(subcompanyids)){
            ids = getCpyIds(subcompanyids,cpyincludesub);
            //如果所查询的分部id为空则返回0
            if(isEmpty(ids)){
                return 0;
            }
            rs.executeSql("select count(1) from HrmResource where subcompanyid1 in("+ids+") AND status<=3");
            if(rs.next()){
                iTotal = rs.getInt(1);
            }
        }
        return iTotal;
    }
    
    /**
     * 得到所查询的分部id
     * @param departmentids 分部id
     * @param deptincludesub 是否包含子分部
     * @return
     */
    public String getCpyIds(String subcompanyids,String cpyincludesub){
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        //是否是sql server数据库
        boolean isSqlServer = rs.getDBType().equals("sqlserver");
        String ids = "";
        //如果仅子分部
        if("2".equals(cpyincludesub)){
            rs.executeSql("SELECT id "+
                          "FROM   HrmSubCompany "+
                          "WHERE  supsubcomid IN("+subcompanyids+") ");
            StringBuffer sb = new StringBuffer();
            while(rs.next()){
                sb.append("," + rs.getInt(1));
            }
            if(sb.length()>0){
                ids = sb.substring(1);
            }
        //如果含子分部
        }else if("3".equals(cpyincludesub)){
            //递归查询本分部和子分部的id
            String sql = null;
            if(isSqlServer){
	            sql = "SELECT id FROM GetSubcpyIdsTreeWithSelf ('"+subcompanyids+"')";
            }else{
            	
                /* sql = "WITH mycte(id) "+
                        "     AS (SELECT id "+
                        "         FROM   HrmSubCompany "+
                        "         WHERE  1=1 "+
                        "               and id in("+subcompanyids+")"+
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
                        " FROM   mycte "; */
                
                sql = "select distinct id"+
                		" from HrmSubCompany where (canceled IS NULL OR canceled!=1)"+
                		" connect by prior id=supsubcomid"+
                		" start with"+
                		" supsubcomid in ("+subcompanyids+")";
            }
            rs.execute(sql);
            StringBuffer sb = new StringBuffer();
            sb.append(subcompanyids);
            while(rs.next()){
                sb.append("," + rs.getInt(1));
            }
            ids = sb.toString();
            /* if(sb.length()>0){
                ids = sb.substring(1);
            } */
        //如果仅本分部
        }else{
            ids = subcompanyids;
        }
        return ids;
    }
    
    /**
     * 得到所查询的部门id
     * @param departmentids 部门id
     * @param deptincludesub 是否包含子部门
     * @return
     */
    public String getDeptIds(String departmentids,String deptincludesub){
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        //是否是sql server数据库
        boolean isSqlServer = rs.getDBType().equals("sqlserver");
        String ids = "";
        //如果仅子部门
        if("2".equals(deptincludesub)){
            rs.executeSql("SELECT id "+
                          "FROM   HrmDepartment "+
                          "WHERE  supdepid IN("+departmentids+") ");
            StringBuffer sb = new StringBuffer();
            while(rs.next()){
                sb.append("," + rs.getInt(1));
            }
            if(sb.length()>0){
                ids = sb.substring(1);
            }
        //如果含子部门
        }else if("3".equals(deptincludesub)){
            //递归查询本部门和子部门的id
            String sql = null;
            if(isSqlServer){
	            sql = "SELECT id FROM GetDeptIdsTreeWithSelf ('"+departmentids+"')";
            }else{
                /* sql = "WITH mycte(id) "+
                        "     AS (SELECT id "+
                        "         FROM   HrmDepartment "+
                        "         WHERE  1=1 "+
                        "               and id in("+departmentids+")"+
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
                        " FROM   mycte "; */
                
                sql = "select distinct id"+
                		" from HrmDepartment where (canceled IS NULL OR canceled!=1)"+
                		" connect by prior id=supdepid"+
                		" start with"+
                		" supdepid in ("+departmentids+")";
            }
            rs.execute(sql);
            StringBuffer sb = new StringBuffer();
            sb.append(departmentids);
            while(rs.next()){
                sb.append("," + rs.getInt(1));
            }
            ids = sb.toString();
            /* if(sb.length()>0){
                ids = sb.substring(1);
            } */
        //如果仅本部门
        }else{
            ids = departmentids;
        }
        return ids;
    }

    /**
     * null转空字符串
     * @param str
     * @return
     */
    public static String null2String(String str) {
        return null2String(str, "");
    }
    /**
     * null转换为指定字符串
     * @param str 检测字符串
     * @param nullValue 替换字符串
     * @return
     */
    public static String null2String(String str, String nullValue) {
        return (str == null || "".equals(str)) ? nullValue : str;
    }
    /**
     * 字符串是否为空
     * @param str
     * @return
     */
    public static boolean isEmpty(String str){
        return str==null || "".equals(str.trim());
    }
%>