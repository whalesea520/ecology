<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="SCUtil.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<%@ include file="/workrelate/reportshare/ReportShareUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
                <%
                String year = Util.null2String(request.getParameter("year"));
                String month = Util.null2String(request.getParameter("month"));
                int level = Util.getIntValue(request.getParameter("level"));
                String subCpyId = Util.null2String(request.getParameter("subCpyId"));
                String curCode = Util.null2String(request.getParameter("curCode"));
                String curtype = Util.null2String(request.getParameter("curtype"));
                weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser (request , response) ;
                //是否是sql server数据库
                boolean isSqlServer = rs.getDBType().equals("sqlserver");
                int paddingSize = level * 23 + 12;
                String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
                //分数段集合
                LinkedHashMap<String,LinkedHashMap<String, String>> scoreMap = getScoreSetting();
                //分数段数
                int scoreNum = scoreMap.size();
                
                String sql = null;
                LinkedHashMap<String,LinkedHashMap<String, String>> showMap = null;
                
                if("subcpy".equals(curtype)){
	                sql = getSubcpySearchSql(year,month,scoreMap,isSqlServer);
	                rs.execute(sql);
	                //得到所有分部的数据
	                LinkedHashMap<String,LinkedHashMap<String, String>> subcpyDataMap = getWorkerResult(rs,scoreNum);
	                //查询分部树及对应的code,通过函数获得
	                rs.execute(getSubCpyTree(isSqlServer));
	                LinkedHashMap<String,LinkedHashMap<String, String>> subcpyTreeMap = getTreeMapResult(rs);
	                //组合展示集合
	                showMap = getSubcpyShowMap(subcpyDataMap,subcpyTreeMap,subCpyId,scoreNum);
	                setIsContainSub(showMap);
                }
                
                
                //得到所有部门的数据
                sql = getDeptSearchSql(year,month,scoreMap,isSqlServer);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String, String>> deptDataMap = getWorkerResult(rs,scoreNum);
                //查询部门树及对应的code
                rs.execute(getDeptTree(isSqlServer));
                LinkedHashMap<String,LinkedHashMap<String, String>> deptTreeMap = getDeptTreeMapResult(rs);
                //组合展示集合
                LinkedHashMap<String,LinkedHashMap<String, String>> deptShowMap = getDeptShowMap(deptDataMap,deptTreeMap,subCpyId,curtype,scoreNum);
                
                List<LinkedHashMap<String, String>> showList = new ArrayList<LinkedHashMap<String, String>>();
                if(showMap != null){
                    showList.addAll(showMap.values());
                }
                showList.addAll(deptShowMap.values());
                
                //得到所有可以查询的分部
                String cpyIds = getAccessCpy(user);
                //得到所有可以查询的部门
                String deptIds = getAccessDept(user);
                
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
                            <img alt="" src="../images/sub.png"/>
                        <%}else{%>
                            <img alt="" src="../images/depat.png"/>
                        <%}%>
                        <label><%=curMap.get("showname") %></label>
                    </td>
                    <%
                    for(int j=0;j<scoreMap.size();j++){
                        tempKey = "l" + j;
                        if("subcpy".equals(curMap.get("curtype")) && cpyIds.contains(curMap.get("id"))){%>
	                        <td><%=curMap.get(tempKey) %></td>
	                    <%}else if("dept".equals(curMap.get("curtype")) && deptIds.contains(curMap.get("id"))){%>
	                        <td><%=curMap.get(tempKey) %></td>
	                    <%}else{%>
	                        <td>*</td>
	                    <%}
                    }%>
                </tr>
                <%}%>

    <%!
    
    /**
     * 得到所有可以查询的部门
     */
    private String getDeptAccessView(String cpyIds){
    	if("".equals(cpyIds)){
    		return "";
    	}
        String sql = " SELECT id FROM HrmDepartment WHERE subcompanyid1 IN ("+cpyIds+")";
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        rs.execute(sql);
        StringBuffer deptIds = new StringBuffer();;
        while(rs.next()){
        	deptIds.append(","+rs.getString("id"));
        }
        if(deptIds.length()==0){
            return "";
        }
        return deptIds.substring(1);
    }
	    /**
	     * 把所有要展示的分部数据放到集合中
	     * @return
	     */
	    private LinkedHashMap<String,LinkedHashMap<String, String>> getSubcpyShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
	    		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
	    		String subCpyId,int scoreMapSize){
	        LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
	        LinkedHashMap<String,String> curMap = null;
	        LinkedHashMap<String, String> tempCurDataMap = null;
	        LinkedHashMap<String, String> tempSupDataMap = null;
	        String tempKey = null;
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
	                for(int i=0;i<scoreMapSize;i++){
	                    tempKey = "l" + i;
	                    tempSupDataMap.put(tempKey,(Integer.parseInt(tempCurDataMap.get(tempKey))+Integer.parseInt(tempSupDataMap.get(tempKey)))+"");
	                }
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
            String curtype,int scoreMapSize){
        LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        LinkedHashMap<String,String> curMap = null;
        LinkedHashMap<String, String> tempCurDataMap = null;
        LinkedHashMap<String, String> tempSupDataMap = null;
        String tempKey = null;
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
            for(int i=0;i<scoreMapSize;i++){
                tempKey = "l" + i;
                tempSupDataMap.put(tempKey,(Integer.parseInt(tempCurDataMap.get(tempKey))+Integer.parseInt(tempSupDataMap.get(tempKey)))+"");
            }
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
         * 构建部门查询sql
         *
         * @param year 年
         * @param month 月
         * @param scoreMap  分数段集合
         * @return
         */
        public String getDeptSearchSql(String year,String month,LinkedHashMap<String,LinkedHashMap<String, String>> scoreMap,boolean isSqlServer){
            year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
            String type = "1";
            String type2 = month;
            
            ArrayList<Map.Entry<String,LinkedHashMap<String,String>>> mapList=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(scoreMap.entrySet());
            StringBuffer fieldStrSB = new StringBuffer();
            StringBuffer tableStrSB = new StringBuffer();
            String beginSymbol = null;
            String beginscore = null;
            String endSymbol = null;
            String endscore = null;
            for(int i=0;i<mapList.size();i++){
                Entry<String,LinkedHashMap<String,String>> obj=mapList.get(i);
                LinkedHashMap<String,String> curMap = obj.getValue();
                beginSymbol = getSymbol(curMap.get("beginSymbol"));
                beginscore = curMap.get("beginscore");
                endSymbol = getSymbol(curMap.get("endSymbol"));
                endscore = curMap.get("endscore");
                fieldStrSB.append(", t"+i + ".l"+i);
                //如果是sql server数据库
                if(isSqlServer){
	                tableStrSB.append(" LEFT JOIN ( SELECT  hrm.departmentid , "+
	                                           "          COUNT(*) l"+i+
	                                           "  FROM    HrmResource hrm , "+
	                                           "          GP_AccessScore gp "+
	                                           "  WHERE   hrm.id = gp.userid "+
	                                           "          AND gp.status = 3 "+
	                                           "          AND hrm.status<=3 "+
	                                           "          AND gp.year = '"+year+"' "+
	                                           "          AND gp.type1 = '"+type+"' "+
	                                           "          AND gp.type2 = '"+type2+"' "+ 
	                                           "          AND gp.result"+beginSymbol+ "(" +beginscore +"/5*ISNULL((SELECT ISNULL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
	                                           "          AND gp.result"+endSymbol+ "(" +endscore +"/5*ISNULL((SELECT ISNULL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
	                                           "  GROUP BY hrm.departmentid "+
	                                          ") t"+i+" ON dept.id = t"+i+".departmentid");
                }else{
	                tableStrSB.append(" LEFT JOIN ( SELECT  hrm.departmentid , "+
	                                           "          COUNT(*) l"+i+
	                                           "  FROM    HrmResource hrm , "+
	                                           "          GP_AccessScore gp "+
	                                           "  WHERE   hrm.id = gp.userid "+
	                                           "          AND gp.status = 3 "+
	                                           "          AND hrm.status<=3 "+
	                                           "          AND gp.year = '"+year+"' "+
	                                           "          AND gp.type1 = '"+type+"' "+
	                                           "          AND gp.type2 = '"+type2+"' "+ 
	                                           "          AND gp.result"+beginSymbol+ "(" +beginscore +"/5*NVL((SELECT NVL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
	                                           "          AND gp.result"+endSymbol+ "(" +endscore +"/5*NVL((SELECT NVL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
	                                           "  GROUP BY hrm.departmentid "+
	                                          ") t"+i+" ON dept.id = t"+i+".departmentid");
                }
            }
            String sql = " SELECT  dept.id , "+
                         "         dept.departmentname showname,"+fieldStrSB.substring(1)+
                         " FROM    HrmDepartment dept " + tableStrSB.toString();
            return sql;
        }
    %>