<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="SCUtil.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<%@ include file="/workrelate/reportshare/ReportShareUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
        <!-- 展示列表 -->
        <div>
            <table id="listTable" class="listTable" cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:160px;width:30%;"/>
                </colgroup>
                <thead>
                        <%
                        //分数段集合
                        LinkedHashMap<String,LinkedHashMap<String, String>> scoreMap = getScoreSetting();
                        if(scoreMap.size()==0){
                        	%>
                        	<tr><td>请先在考核设置中对分数段进行设置，再进行查询!</td></tr>
                        	<%
                        	return ;
                        }
                        %>
                    <tr style="text-align:center;">
                        <td style="text-align:left">分部</td>
                        <%
                        //分数段数
                        int scoreNum = scoreMap.size();
                        LinkedHashMap<String,String> curMap = null;
                        String gardename = null;
                        String valueSize = null;
                        ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> it=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(scoreMap.entrySet()).listIterator();
                        while(it.hasNext()) {
                            Entry<String,LinkedHashMap<String,String>> obj=it.next();
                            curMap = obj.getValue();
                            gardename = curMap.get("gardename");
                            valueSize = getValueSize(curMap);
                        %>
                        <td title="<%=valueSize %>"><%=gardename %></td>
                    <%}%>
                    </tr>
                </thead>
                <%
                String year = Util.null2String(request.getParameter("year"));
                String month = Util.null2String(request.getParameter("month"));
                String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
                //是否是sql server数据库
                boolean isSqlServer = rs.getDBType().equals("sqlserver");
                String sql = getSubcpySearchSql(year,month,scoreMap,isSqlServer);
                //查询所有分部的数据
                rs.execute(sql);
                LinkedHashMap<String,LinkedHashMap<String, String>> dataMap = getWorkerResult(rs,scoreNum);
                //查询分部树及对应的code,通过函数获得
                rs.execute(getSubCpyTree(isSqlServer));
                LinkedHashMap<String,LinkedHashMap<String, String>> treeMap = getTreeMapResult(rs);
                //组合展示集合
                LinkedHashMap<String,LinkedHashMap<String, String>> showMap = getShowMap(dataMap,treeMap,subcompanyids,scoreNum);
                setIsContainSub(showMap);
                curMap = null;
                ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> itor=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(showMap.entrySet()).listIterator(showMap.size());
                String tempKey = null;
                //得到所有可以查询的分部
                String cpyIds = getAccessCpy(user);
                
                while(itor.hasPrevious()) {
                    Entry<String,LinkedHashMap<String,String>> obj=itor.previous();
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
                    <%
                    for(int i=0;i<scoreNum;i++){
                        tempKey = "l" + i;
                        if(cpyIds.contains(curMap.get("id"))){%>
                            <td><%=curMap.get(tempKey) %></td>
                        <%}else{%>
                            <td>*</td>
                        <%}
                    }%>
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
                String subcompanyids,int scoreMapSize){
            LinkedHashMap<String,LinkedHashMap<String, String>> resultMap = new LinkedHashMap<String,LinkedHashMap<String, String>>();
            LinkedHashMap<String,String> curMap = null;
            LinkedHashMap<String, String> tempCurDataMap = null;
            LinkedHashMap<String, String> tempSupDataMap = null;
            
            ListIterator<Map.Entry<String,LinkedHashMap<String,String>>> itor=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(treeMap.entrySet()).listIterator(treeMap.size());
            String tempKey = null;
            while(itor.hasPrevious()) {
                Entry<String,LinkedHashMap<String,String>> obj=itor.previous();
//             for (Entry<String,LinkedHashMap<String,String>> obj : treeMap.entrySet()) {
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
                    
                    for(int i=0;i<scoreMapSize;i++){
                    	tempKey = "l" + i;
                        tempSupDataMap.put(tempKey,(Integer.parseInt(tempCurDataMap.get(tempKey))+Integer.parseInt(tempSupDataMap.get(tempKey)))+"");
                    }
                    tempSupDataMap.put("hasSub","yes");
                }        
            }
            return resultMap;
        }
    %>