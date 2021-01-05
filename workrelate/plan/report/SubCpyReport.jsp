<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="Util.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<%@ include file="SubCpyUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
        <div>
            <table id="listTable" class="listTable" cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:160px;width:28%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:7%;"/>
                    <col style="min-width:90px;width:9%;"/>
                </colgroup>
                <thead class="orgHeader" style="border-bottom: 1px solid #59D445;">
                    <tr style="text-align:center;">
                        <td style="text-align:left;padding-left:60px;border-left:none;" rowspan="2">分部</td>
                        <td rowspan="2">需提交</td>
                        <td rowspan="2">未提交</td>
                        <td colspan="3">处理中</td>
                        <td rowspan="2">已完成</td>
                        <td colspan="3">已过期</td>
                        <td rowspan="2" style="border-right:none;">操作</td>
                    </tr>
                    <tr style="text-align:center;">
                        <td>草稿</td>
                        <td>审批中</td>
                        <td>退回</td>
                        <td>草稿</td>
                        <td>审批中</td>
                        <td>退回</td>
                    </tr>
                </thead>
                <%
                String year = Util.null2String(request.getParameter("year"));
                String month = Util.null2String(request.getParameter("month"));
                String week = Util.null2String(request.getParameter("week"));
                String week2 = Util.null2String(request.getParameter("week2"));
                if(!week2.equals("") && !week2.equals(week)) week += "," + week2;
                String type = Util.null2String(request.getParameter("type"));
                String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
                //是否是sql server数据库
                boolean isSqlServer = rs.getDBType().equals("sqlserver");
                String sql = getSubcpySearchSql(year,month,week,"week".equals(type)?"2":"1",rs.getDBType().equals("sqlserver"));
                //查询所有分部的数据
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String, String>> dataMap = getWorkerResult(rs);
                //查询分部树及对应的code,通过函数获得
                rs.execute(getSubCpyTree(isSqlServer));
                LinkedHashMap<String,LinkedHashMap<String, String>> treeMap = getTreeMapResult(rs);
                //组合展示集合
                LinkedHashMap<String,LinkedHashMap<String, String>> showMap = getShowMap(dataMap,treeMap,subcompanyids);
                setIsContainSub(showMap);
               	LinkedHashMap<String,String> curMap = null;
               	
               	ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> i=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(showMap.entrySet()).listIterator(showMap.size());
                while(i.hasPrevious()) {
                    Entry<String,LinkedHashMap<String,String>> obj=i.previous();
                    curMap = obj.getValue();
                %>
                
                <tr style="text-align:center;" curCode='<%=curMap.get("id")%>' subCpyId='<%=curMap.get("id")%>' opened="no" curtype="subcpy">
                    <td style="text-align:left" level="1">
                        <input type="checkbox"/>
                        <img onmouseover="imgOver(this)" onmouseout="imgOut(this)"
	                        <%if("yes".equals(curMap.get("hasSub"))){%>
	                            src="/workrelate/images/wropen.png" 
	                            onclick="loadSubDept()"
	                        <%}else{%> 
	                            src="/workrelate/images/wrnormal.png" 
	                        <%}%> 
	                        style="margin-top:5px;margin-right:5px;cursor:pointer;"/>
                        <img alt="" src="../images/sub.png"/>
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
                    <td><div class="watchdetail" onclick="watchDetail(event)">查看明细<div></div></td>
                </tr>
                <%}%>
            </table>
        </div>
	    <script type="text/javascript">
	        $("div .watchdetail").bind("mouseover",function(){
	        	$(this).addClass("watchdetailHover");
	        }).bind("mouseout",function(){
                $(this).removeClass("watchdetailHover");
            });
	    </script>
