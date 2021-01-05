<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="Util.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<%@ include file="SubCpyUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
                <%
                String year = Util.null2String(request.getParameter("year"));
                String month = Util.null2String(request.getParameter("month"));
                String week = Util.null2String(request.getParameter("week"));
                String week2 = Util.null2String(request.getParameter("week2"));
                if(!week2.equals("") && !week2.equals(week)) week += "," + week2;
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
	                sql = getSubcpySearchSql(year,month,week,"week".equals(type)?"2":"1",isSqlServer);
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
                sql = getDeptSearchSql(year,month,week,"week".equals(type)?"2":"1",isSqlServer);
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
                    <td><div class="watchdetail" onclick="watchDetail()">查看明细<div></div></td>
                
               <%}%>
