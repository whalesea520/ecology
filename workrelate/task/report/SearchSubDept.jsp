<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="Util.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
                <%
                String beginDate = Util.null2String(request.getParameter("beginDate"));
                String endDate = Util.null2String(request.getParameter("endDate"));
                String personType = Util.null2String(request.getParameter("personType"));
                int level = Util.getIntValue(request.getParameter("level"));
                String subCpyId = Util.null2String(request.getParameter("subCpyId"));
                String curCode = Util.null2String(request.getParameter("curCode"));
                String curtype = Util.null2String(request.getParameter("curtype"));
                int paddingSize = level * 23 + 12;
                String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
                //是否是sql server数据库
                boolean isSqlServer = rs.getDBType().equals("sqlserver");
              
                String sql = null;
                LinkedHashMap<String,LinkedHashMap<String, String>> showMap = null;
                
                if("subcpy".equals(curtype)){
	                sql = getSubcpySearchSql(beginDate,endDate,personType,isSqlServer);
	                rs.execute(sql);
	                //得到所有分部的数据
	                LinkedHashMap<String,LinkedHashMap<String, String>> subcpyDataMap = getWorkerResult(rs);
	                //查询分部树及对应的code,通过函数获得
                    rs.execute(getSubCpyTree(isSqlServer));
	                
	                LinkedHashMap<String,LinkedHashMap<String, String>> subcpyTreeMap = getTreeMapResult(rs);
	                //组合展示集合
	                showMap = getSubcpyShowMap(subcpyDataMap,subcpyTreeMap,subCpyId);
	                setIsContainSub(showMap);
                }
                
                //得到所有部门的数据
                sql = getDeptSearchSql(beginDate,endDate,personType,isSqlServer);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String, String>> deptDataMap = getWorkerResult(rs);
                //查询部门树及对应的code
                //查询部门树及对应的code
                rs.execute(getDeptTree(isSqlServer));
                LinkedHashMap<String,LinkedHashMap<String, String>> deptTreeMap = getDeptTreeMapResult(rs);
                //组合展示集合
                LinkedHashMap<String,LinkedHashMap<String, String>> deptShowMap = getDeptShowMap(deptDataMap,deptTreeMap,subCpyId,curtype);
                
                List<LinkedHashMap<String, String>> showList = new ArrayList<LinkedHashMap<String, String>>();
                if(showMap != null){
                    showList.addAll(showMap.values());
                }
                showList.addAll(deptShowMap.values());
                
                LinkedHashMap<String,String> curMap = null;
                String tempKey = null;
                for (int i=0;i<showList.size();i++) {
                    curMap = showList.get(i);
                %>
                
                <tr style="text-align:center;" curCode='<%=curCode%>_<%=curMap.get("id")%>' subCpyId='<%=curMap.get("id")%>' opened="no" curtype="<%=curMap.get("curtype")%>">
                    <td style="text-align:left;padding-left:<%=paddingSize%>px;" level="<%=level+1%>">
                        <input type="checkbox"/>
                        <img onmouseover="imgOver(this)" onmouseout="imgOut(this)"
                            <%if("yes".equals(curMap.get("hasSub"))){%>
                                src="/workrelate/images/wropen.png" 
                                onclick="loadSubDept()"
                            <%}else{%> 
                                src="/workrelate/images/wrnormal.png" 
                            <%}%> 
                            style="margin-top:5px;margin-right:5px;cursor:pointer;">
                        </img>
                        <%if("subcpy".equals(curMap.get("curtype"))){%>
                            <img alt="" src="/workrelate/plan/images/sub.png"/>
                        <%}else{%>
                            <img alt="" src="/workrelate/plan/images/depat.png"/>
                        <%}%>
                        <label><%=curMap.get("showname") %></label>
                    </td>
                    <td><%=curMap.get("total") %></td>
                    <td><%=curMap.get("overtime") %></td>
                    <td><%=curMap.get("doing") %></td>
                    <td><%=curMap.get("finish") %></td>
                    <td><div class="watchdetail" onclick="watchDetail()">查看明细<div></div></td>
                
               <%}%>

    <%!
	    /**
	     * 把所有要展示的分部数据放到集合中
	     * @return
	     */
	    private LinkedHashMap<String,LinkedHashMap<String, String>> getSubcpyShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
	    		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
	    		String subCpyId){
	        LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
	        LinkedHashMap<String,String> curMap = null;
	        LinkedHashMap<String, String> tempCurDataMap = null;
	        LinkedHashMap<String, String> tempSupDataMap = null;
	        for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
	            curMap = obj.getValue();
                if(dataMap.get(obj.getKey()) == null){
                    continue;
                }
	            if("1".equals(curMap.get("level"))){
	                continue;
	            }else{  	
	                tempCurDataMap = dataMap.get(curMap.get("id"));
	                tempSupDataMap = dataMap.get(curMap.get("supsubcomid"));
	                if(tempCurDataMap == null || tempSupDataMap == null){
	                    continue;
	                }
	                tempSupDataMap.put("total",(Integer.parseInt(tempCurDataMap.get("total"))+Integer.parseInt(tempSupDataMap.get("total")))+"");
	                tempSupDataMap.put("overtime",(Integer.parseInt(tempCurDataMap.get("overtime"))+Integer.parseInt(tempSupDataMap.get("overtime")))+"");
	                tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
	                tempSupDataMap.put("doing",(Integer.parseInt(tempCurDataMap.get("doing"))+Integer.parseInt(tempSupDataMap.get("doing")))+"");
	                tempSupDataMap.put("hasSub","yes");
	                //如果subCpyId是空或包含则添加
                    if(subCpyId.equals(curMap.get("supsubcomid"))){
                        tempCurDataMap.put("curtype","subcpy");
                        resultMap.put(curMap.get("id"),tempCurDataMap);
                    }
	            }
	        }
	        return resultMap;
	    }
    /**
     * 把所有要展示的部门数据放到集合中
     * @return
     */
    private LinkedHashMap<String,LinkedHashMap<String, String>> getDeptShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
            LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
            String subCpyId,
            String curtype){
        LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        LinkedHashMap<String,String> curMap = null;
        LinkedHashMap<String, String> tempCurDataMap = null;
        LinkedHashMap<String, String> tempSupDataMap = null;
        for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
            curMap = obj.getValue();
            if(dataMap.get(obj.getKey()) == null){
                continue;
            }
    
            tempCurDataMap = dataMap.get(curMap.get("id"));
            tempSupDataMap = dataMap.get(curMap.get("superid"));
            if(tempCurDataMap == null && tempSupDataMap == null){
                continue;
            }else if(tempCurDataMap != null && tempSupDataMap == null){
            	if("subcpy".equals(curtype) && subCpyId.equals(curMap.get("subcompanyid1")) && "1".equals(curMap.get("level"))){
            		tempCurDataMap.put("curtype","dept");
                    resultMap.put(curMap.get("id"),tempCurDataMap);
                }
            	continue;
            }
            tempSupDataMap.put("total",(Integer.parseInt(tempCurDataMap.get("total"))+Integer.parseInt(tempSupDataMap.get("total")))+"");
            tempSupDataMap.put("overtime",(Integer.parseInt(tempCurDataMap.get("overtime"))+Integer.parseInt(tempSupDataMap.get("overtime")))+"");
            tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
            tempSupDataMap.put("doing",(Integer.parseInt(tempCurDataMap.get("doing"))+Integer.parseInt(tempSupDataMap.get("doing")))+"");
            tempSupDataMap.put("hasSub","yes");
            
            //如果subCpyId是空或包含则添加
            if("subcpy".equals(curtype)){
	            if(subCpyId.equals(curMap.get("subcompanyid1")) && "1".equals(curMap.get("level"))){
	            	tempCurDataMap.put("curtype","dept");
	                resultMap.put(curMap.get("id"),tempCurDataMap);
	            }
            }else{
            	if(subCpyId.equals(curMap.get("superid"))){
                    tempCurDataMap.put("curtype","dept");
                    resultMap.put(curMap.get("id"),tempCurDataMap);
                }
            }
        }
        return resultMap;
    }
	
	    /**
         * 创建人员类型查询sql
         * @param personType 人员类型
         * @return
         */
        public String getPersonTypeSql(String personType){
	    	String personTypeSql = "";
	        //人员类型包含责任人
	        if(personType.contains("1")){
	            personTypeSql += "tm.principalid=hrm.id ";
	        //人员类型包含参与人
	        }else if(personType.contains("2")){
	            personTypeSql += "or hrm.id in( select partnerid from TM_TaskPartner where taskid=tm.id )";
	        //人员类型包含创建人
	        }else if(personType.contains("3")){
	            personTypeSql += "or tm.creater=hrm.id ";
	        }
	        if(personTypeSql.startsWith("or")){
	            personTypeSql = personTypeSql.substring(2);
	        }
	        if(personTypeSql.length()>0){
	            personTypeSql = " AND ("+personTypeSql+")";
	        }else{
	            personTypeSql = " AND (tm.principalid=hrm.id or tm.creater=hrm.id or hrm.id in( select partnerid from TM_TaskPartner where taskid=tm.id ))";
	        }
	        personTypeSql += " and (tm.deleted=0 or tm.deleted is null)";
	        return personTypeSql;
	    }
        /**
         * 构建部门查询sql
         * @param beginDate 开始时间
         * @param endDate 结束时间
         * @param personType 人员类型
         * @return
         */
        public String getDeptSearchSql(String beginDate,String endDate,String personType,boolean isSqlServer){
        	String personTypeSql = getPersonTypeSql(personType);
        	String sql = null;
            if(isSqlServer){
                sql = "SELECT dept.id, "+
                    "       dept.departmentname showname, "+
                    "       Isnull(total, 0) total, "+
                    "       Isnull(overtime, 0) overtime, "+
                    "       Isnull(finish, 0) finish, "+
                    "       Isnull(doing, 0) doing "+
                    " FROM  HrmDepartment dept "+
                    "       LEFT JOIN (SELECT hrm.departmentid, "+
                    "                         Sum(A.total)  total, "+
                    "                         Sum(B.overtime)  overtime, "+
                    "                         Sum(C.finish) finish, "+
                    "                         Sum(D.doing)  doing "+
                    "                  FROM   HrmResource hrm "+
                    "                         LEFT JOIN (SELECT hrm.id, "+
                    "                                           Count(1) total "+
                    "                                    FROM   TM_TaskInfo tm,"+
                    "                                           HrmResource hrm "+
                    "                                    WHERE  tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                           " + personTypeSql +
                    "                                           AND hrm.status<=3 "+
                    "                                    GROUP  BY hrm.id) A "+
                    "                                ON hrm.id = A.id "+
                    "                          LEFT JOIN (SELECT hrm.id, "+
                    "                                            Count(1) overtime "+
                    "                                     FROM   TM_TaskInfo tm,"+
                    "                                            HrmResource hrm "+
                    "                                     WHERE  tm.status = 1 "+
                    "                                            AND hrm.status<=3 "+
                    "                                            AND tm.enddate IS NOT NULL "+
                    "                                            AND LEN(tm.enddate) >0 "+
                    "                                            AND tm.enddate < CONVERT(VARCHAR(10),GETDATE(),120) "+
                    "                                            AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                            " + personTypeSql +
                    "                                     GROUP BY hrm.id) B "+
                    "                                ON hrm.id = B.id "+
                    "                         LEFT JOIN (SELECT hrm.id, "+
                    "                                           Count(1) finish "+
                    "                                    FROM   TM_TaskInfo tm,"+
                    "                                           HrmResource hrm "+
                    "                                    WHERE  tm.status = 2 "+
                    "                                           AND hrm.status<=3 "+
                    "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                           " + personTypeSql +
                    "                                    GROUP  BY hrm.id) C "+
                    "                                ON hrm.id = C.id "+
                    "                         LEFT JOIN (SELECT hrm.id, "+
                    "                                           Count(1) doing "+
                    "                                    FROM   TM_TaskInfo tm, "+
                    "                                           HrmResource hrm "+
                    "                                    WHERE  tm.status = 1 "+
                    "                                           AND hrm.status<=3 "+
                    "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                           " + personTypeSql +
                    "                                    GROUP  BY hrm.id) D "+
                    "                                ON hrm.id = D.id "+
                    "                  GROUP  BY hrm.departmentid) E "+
                    "              ON dept.id = E.departmentid ";
            }else{
                sql = "SELECT dept.id, "+
                    "       dept.departmentname showname, "+
                    "       NVL(total, 0) total, "+
                    "       NVL(overtime, 0) overtime, "+
                    "       NVL(finish, 0) finish, "+
                    "       NVL(doing, 0) doing "+
                    " FROM  HrmDepartment dept "+
                    "       LEFT JOIN (SELECT hrm.departmentid, "+
                    "                         Sum(A.total)  total, "+
                    "                         Sum(B.overtime)  overtime, "+
                    "                         Sum(C.finish) finish, "+
                    "                         Sum(D.doing)  doing "+
                    "                  FROM   HrmResource hrm "+
                    "                         LEFT JOIN (SELECT hrm.id, "+
                    "                                           Count(1) total "+
                    "                                    FROM   TM_TaskInfo tm,"+
                    "                                           HrmResource hrm "+
                    "                                    WHERE  tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                           " + personTypeSql +
                    "                                           AND hrm.status<=3 "+
                    "                                    GROUP  BY hrm.id) A "+
                    "                                ON hrm.id = A.id "+
                    "                          LEFT JOIN (SELECT hrm.id, "+
                    "                                            Count(1) overtime "+
                    "                                     FROM   TM_TaskInfo tm,"+
                    "                                            HrmResource hrm "+
                    "                                     WHERE  tm.status = 1 "+
                    "                                            AND hrm.status<=3 "+
                    "                                            AND tm.enddate IS NOT NULL "+
                    "                                            AND LENGTH(tm.enddate) >0 "+
                    "                                            AND tm.enddate < TO_CHAR(SYSDATE,'YYYY-MM-DD') "+
                    "                                            AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                            " + personTypeSql +
                    "                                     GROUP BY hrm.id) B "+
                    "                                ON hrm.id = B.id "+
                    "                         LEFT JOIN (SELECT hrm.id, "+
                    "                                           Count(1) finish "+
                    "                                    FROM   TM_TaskInfo tm,"+
                    "                                           HrmResource hrm "+
                    "                                    WHERE  tm.status = 2 "+
                    "                                           AND hrm.status<=3 "+
                    "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                           " + personTypeSql +
                    "                                    GROUP  BY hrm.id) C "+
                    "                                ON hrm.id = C.id "+
                    "                         LEFT JOIN (SELECT hrm.id, "+
                    "                                           Count(1) doing "+
                    "                                    FROM   TM_TaskInfo tm, "+
                    "                                           HrmResource hrm "+
                    "                                    WHERE  tm.status = 1 "+
                    "                                           AND hrm.status<=3 "+
                    "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
                    "                                           " + personTypeSql +
                    "                                    GROUP  BY hrm.id) D "+
                    "                                ON hrm.id = D.id "+
                    "                  GROUP  BY hrm.departmentid) E "+
                    "              ON dept.id = E.departmentid ";
            }
            return sql;
        }
    %>