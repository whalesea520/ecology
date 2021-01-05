<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="GPUtil.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
        <div>
            <table id="listTable" class="listTable" cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:160px;width:28%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                    <col style="min-width:90px;width:8%;"/>
                </colgroup>
                <thead class="orgHeader" style="border-bottom: 1px solid #59D445;">
                    <tr style="text-align:center;">
                        <td style="text-align:left;padding-left:60px;border-left:none;" rowspan="2">分部</td>
                        <td colspan="2">需提交</td>
                        <td colspan="3">考核中</td>
                        <td rowspan="2">已完成</td>
                        <td colspan="3" style="border-right:none;">已过期</td>
                    </tr>
                    <tr style="text-align:center;">
                        <td>有方案</td>
                        <td>无方案</td>
                        <td>评分中</td>
                        <td>审批中</td>
                        <td>退回</td>
                        <td>评分中</td>
                        <td>审批中</td>
                        <td style="border-right:none;">退回</td>
                    </tr>
                </thead>
                <%
                String year = Util.null2String(request.getParameter("year"));
                String month = Util.null2String(request.getParameter("month"));
                String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
                //是否是sql server数据库
                boolean isSqlServer = rs.getDBType().equals("sqlserver");
                
                String sql = getSubcpySearchSql(year,month,isSqlServer);
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
                        <img  onmouseover="imgOver(this)" onmouseout="imgOut(this)"
	                        <%if("yes".equals(curMap.get("hasSub"))){%>
	                            src="/workrelate/images/wropen.png" 
	                            onclick="loadSubDept()"
	                        <%}else{%> 
	                            src="/workrelate/images/wrnormal.png" 
	                        <%}%> 
	                        style="margin-top:5px;margin-right:5px;cursor:pointer;">
                        </img>
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
    <%!
    
	    /**
	     * 把所有分部组合成的树放到集合中
	     * @return
	     */
	    private LinkedHashMap<String,LinkedHashMap<String, String>> getShowMap(LinkedHashMap<String,LinkedHashMap<String, String>> dataMap,
	    		LinkedHashMap<String,LinkedHashMap<String, String>> treeMap,
	    		String subcompanyids){
    	    LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    	    LinkedHashMap<String,String> curMap = null;
    	    LinkedHashMap<String, String> tempCurDataMap = null;
    	    LinkedHashMap<String, String> tempSupDataMap = null;
    	    
    	    ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> i=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(treeMap.entrySet()).listIterator(treeMap.size());
            while(i.hasPrevious()) {
            	Entry<String,LinkedHashMap<String,String>> obj=i.previous();
//     	    for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
                curMap = obj.getValue();
                if("1".equals(curMap.get("level"))){
                	if(dataMap.get(obj.getKey()) == null){
                        continue;
                    }
                	if(dataMap.get(obj.getKey()).get("hasSub")==null){
                        dataMap.get(obj.getKey()).put("hasSub","no");
                    }
                	//如果subcompanyids是空或包含则添加
                	if(subcompanyids == null || "".equals(subcompanyids) || (","+subcompanyids+",").contains(","+obj.getKey()+",")){
	                	resultMap.put(obj.getKey(),dataMap.get(obj.getKey()));
                	}
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
                }        
    	    }
    	    return resultMap;
	    }
    %>