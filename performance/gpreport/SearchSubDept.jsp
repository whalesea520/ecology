<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="GPUtil.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
                <%
                String year = Util.null2String(request.getParameter("year"));
                String month = Util.null2String(request.getParameter("month"));
                String type = Util.null2String(request.getParameter("type"));
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
	                sql = getSubcpySearchSql(year,month,isSqlServer);
	                rs.execute(sql);
	                //得到所有分部的数据
	                LinkedHashMap<String,LinkedHashMap<String, String>> subcpyDataMap = getWorkerResult(rs);
	                //查询分部树及对应的code,通过函数获得
	                rs.execute(getSubCpyTree(isSqlServer));
	                LinkedHashMap<String,LinkedHashMap<String, String>> subcpyTreeMap = getSubcpyTreeMapResult(rs);
	                //组合展示集合
	                showMap = getSubcpyShowMap(subcpyDataMap,subcpyTreeMap,subCpyId);
	                setIsContainSub(showMap);
                }
                
                
                //得到所有部门的数据
                sql = getDeptSearchSql(year,month,isSqlServer);
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String, String>> deptDataMap = getWorkerResult(rs);
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
                    <td><%=curMap.get("exist") %></td>
                    <td><%=curMap.get("without") %></td>
                    <td><%=curMap.get("scoring") %></td>
                    <td><%=curMap.get("assessing") %></td>
                    <td><%=curMap.get("back") %></td>
                    <td><%=curMap.get("finish") %></td>
                    <td><%=curMap.get("oscoring") %></td>
                    <td><%=curMap.get("oassessing") %></td>
                    <td><%=curMap.get("oback") %></td>
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
                tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
                tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
                tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
                tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
                tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
                tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
                tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
                tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
                tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
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
            tempSupDataMap.put("exist",(Integer.parseInt(tempCurDataMap.get("exist"))+Integer.parseInt(tempSupDataMap.get("exist")))+"");
            tempSupDataMap.put("without",(Integer.parseInt(tempCurDataMap.get("without"))+Integer.parseInt(tempSupDataMap.get("without")))+"");
            tempSupDataMap.put("scoring",(Integer.parseInt(tempCurDataMap.get("scoring"))+Integer.parseInt(tempSupDataMap.get("scoring")))+"");
            tempSupDataMap.put("assessing",(Integer.parseInt(tempCurDataMap.get("assessing"))+Integer.parseInt(tempSupDataMap.get("assessing")))+"");
            tempSupDataMap.put("back",(Integer.parseInt(tempCurDataMap.get("back"))+Integer.parseInt(tempSupDataMap.get("back")))+"");
            tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
            tempSupDataMap.put("oscoring",(Integer.parseInt(tempCurDataMap.get("oscoring"))+Integer.parseInt(tempSupDataMap.get("oscoring")))+"");
            tempSupDataMap.put("oassessing",(Integer.parseInt(tempCurDataMap.get("oassessing"))+Integer.parseInt(tempSupDataMap.get("oassessing")))+"");
            tempSupDataMap.put("oback",(Integer.parseInt(tempCurDataMap.get("oback"))+Integer.parseInt(tempSupDataMap.get("oback")))+"");
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
	     * 把所有分部组合成的树放到集合中
	     * @return
	     */
	    private LinkedHashMap<String,LinkedHashMap<String, String>> getSubcpyTreeMapResult(weaver.conn.RecordSet rs) {
	        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
	        String id = null;
	        String subcompanyname = null;
	        String supsubcomid = null;
	        String code = null;
	        String level = null;
	        String s3 = null;
	        LinkedHashMap<String, String> curValues = null;
	        while(rs.next()){
	            id = null2String(rs.getString("id"));
	            subcompanyname = null2String(rs.getString("subcompanyname"));
	            supsubcomid = null2String(rs.getString("supsubcomid"));
	            code = null2String(rs.getString("code"));
	            level = null2String(rs.getString("level"));
	
	            curValues = new LinkedHashMap<String, String>();
	            curValues.put("id",id);
	            curValues.put("subcompanyname",subcompanyname);
	            curValues.put("supsubcomid",supsubcomid);
	            curValues.put("code",code);
	            curValues.put("level",level);
	            map.put(id,curValues);
	        }
	        return map;
	    }
	
        /**
         * 构建部门查询sql
         *
         * @param year 年
         * @param month 月
         * @param week  周
         * @param type  查询类型（1：月；2：周）
         * @return
         */
        public String getDeptSearchSql(String year,String month,boolean isSqlServer){
            year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
            String type = "1";
            String type2 = month;
            String sql = null;
            //如果是sql server数据库
            if(isSqlServer){
                sql = "SELECT  dept.id , "+
                "        dept.departmentname showname, "+
                "        ISNULL(A.exist, 0) exist , "+
                "        ISNULL(B.without, 0) without , "+
                "        ISNULL(C.scoring, 0) scoring , "+
       		    "        ISNULL(D.assessing, 0) assessing , "+
                "        ISNULL(BK.back, 0) back , "+
                "        ISNULL(E.finish, 0) finish, "+
                "        ISNULL(F.oscoring, 0) oscoring , "+
                "        ISNULL(G.oassessing, 0) oassessing,  "+
                "        ISNULL(OBK.oback, 0) oback  "+
                "FROM    HrmDepartment dept "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) exist "+
                "                    FROM    HrmResource hrm "+
                "                    WHERE   hrm.status<=3 AND EXISTS ( SELECT 1 "+
                "                                     FROM   GP_AccessProgram ap "+
                "                                     WHERE  hrm.id = ap.userid "+
                "                                            AND ap.status = 3 ) "+
                "                    GROUP BY departmentid "+
                "                  ) A ON A.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) without "+
                "                    FROM    HrmResource hrm "+
                "                    WHERE   hrm.status<=3 AND hrm.id NOT in ( SELECT ap.userid "+
                "                                     FROM   GP_AccessProgram ap "+
                "                                     WHERE  ap.status = 3 ) "+
                "                    GROUP BY departmentid "+
                "                  ) B ON B.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) scoring "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 0 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND GETDATE()<Cast(score.enddate AS DATETIME) "+
                "                    GROUP BY departmentid "+
                "                  ) C ON C.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) assessing "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 1 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND GETDATE()<SCORE.enddate "+
                "                    GROUP BY departmentid "+
                "                  ) D ON D.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) back "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 2 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND GETDATE()<SCORE.enddate "+
                "                    GROUP BY departmentid "+
                "                  ) BK ON BK.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) finish "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 3 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                    GROUP BY departmentid "+
                "                  ) E ON E.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) oscoring "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 0 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
                "                    GROUP BY departmentid "+
                "                  ) F ON F.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) oassessing "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 1 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
                "                    GROUP BY departmentid "+
                "                  ) G ON G.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) oback "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 2 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
                "                    GROUP BY departmentid "+
                "                  ) OBK ON OBK.departmentid = dept.id ";
            }else{
                sql = "SELECT  dept.id , "+
                "        dept.departmentname showname, "+
                "        NVL(A.exist, 0) exist , "+
                "        NVL(B.without, 0) without , "+
                "        NVL(C.scoring, 0) scoring , "+
       		    "        NVL(D.assessing, 0) assessing , "+
                "        NVL(BK.back, 0) back , "+
                "        NVL(E.finish, 0) finish, "+
                "        NVL(F.oscoring, 0) oscoring , "+
                "        NVL(G.oassessing, 0) oassessing,  "+
                "        NVL(OBK.oback, 0) oback  "+
                "FROM    HrmDepartment dept "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) exist "+
                "                    FROM    HrmResource hrm "+
                "                    WHERE   hrm.status<=3 AND EXISTS ( SELECT 1 "+
                "                                     FROM   GP_AccessProgram ap "+
                "                                     WHERE  hrm.id = ap.userid "+
                "                                            AND ap.status = 3 ) "+
                "                    GROUP BY departmentid "+
                "                  ) A ON A.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) without "+
                "                    FROM    HrmResource hrm "+
                "                    WHERE   hrm.status<=3 AND hrm.id NOT in ( SELECT ap.userid "+
                "                                     FROM   GP_AccessProgram ap "+
                "                                     WHERE  ap.status = 3 ) "+
                "                    GROUP BY departmentid "+
                "                  ) B ON B.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) scoring "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 0 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
                "                    GROUP BY departmentid "+
                "                  ) C ON C.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) assessing "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 1 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
                "                    GROUP BY departmentid "+
                "                  ) D ON D.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) back "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 2 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
                "                    GROUP BY departmentid "+
                "                  ) BK ON BK.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) finish "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 3 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                    GROUP BY departmentid "+
                "                  ) E ON E.departmentid = dept.id "+
                "        LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) oscoring "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 0 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
                "                    GROUP BY departmentid "+
                "                  ) F ON F.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) oassessing "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 1 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
                "                    GROUP BY departmentid "+
                "                  ) G ON G.departmentid = dept.id "+
                "         LEFT JOIN ( SELECT  departmentid , "+
                "                            COUNT(1) oback "+
                "                    FROM    HrmResource hrm , "+
                "                            GP_AccessScore score "+
                "                    WHERE   hrm.id = score.userid "+
                "                            AND hrm.status<=3 "+
                "                            AND score.status = 2 "+
                "                            AND year = '"+year+"' "+
                "                            AND type1 = '"+type+"' "+
                "                            AND type2 = '"+type2+"' "+ 
                "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
                "                    GROUP BY departmentid "+
                "                  ) OBK ON OBK.departmentid = dept.id ";
            }
            return sql;
        }
    %>