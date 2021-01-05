<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="Util.jsp" %>
<%@ include file="/workrelate/comm/SubcpyDeptUtil.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

        <!-- 展示列表 -->
        <div>
            <table id="listTable" class="listTable" cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                <colgroup>
                    <col style="min-width:160px;width:40%;"/>
                    <col style="min-width:90px;width:10%;"/>
                    <col style="min-width:90px;width:10%;"/>
                    <col style="min-width:90px;width:10%;"/>
                    <col style="min-width:90px;width:10%;"/>
                    <col style="min-width:100px;width:20%;"/>
                </colgroup>
                <thead>
                    <tr style="text-align:center;">
                        <td style="text-align:left">分部</td>
                        <td>任务数</td>
                        <td>已超期</td>
                        <td>进行中</td>
                        <td>已完成</td>
                        <td>操作</td>
                    </tr>
                </thead>
                <%
               String beginDate = Util.null2String(request.getParameter("beginDate"));
               String endDate = Util.null2String(request.getParameter("endDate"));
               String personType = Util.null2String(request.getParameter("personType"));
               //是否是sql server数据库
               boolean isSqlServer = rs.getDBType().equals("sqlserver");
               
               String sql = getSubcpySearchSql(beginDate,endDate,personType,isSqlServer);
               //查询所有分部的数据
               rs.execute(sql);
               LinkedHashMap<String,LinkedHashMap<String, String>> dataMap = getWorkerResult(rs);
               //查询分部树及对应的code,通过函数获得
               rs.execute(getSubCpyTree(isSqlServer));
               LinkedHashMap<String,LinkedHashMap<String, String>> treeMap = getTreeMapResult(rs);
               
               //组合展示集合
               LinkedHashMap<String,LinkedHashMap<String, String>> showMap = getShowMap(dataMap,treeMap,"");
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
                            style="margin-top:5px;margin-right:5px;cursor:pointer;">
                        </img>
                        <img alt="" src="/workrelate/plan/images/sub.png"/>
                        <label><%=curMap.get("showname") %></label> 
                    </td>
                    <td><%=curMap.get("total") %></td>
                    <td><%=curMap.get("overtime") %></td>
                    <td><%=curMap.get("doing") %></td>
                    <td><%=curMap.get("finish") %></td>
                    <td><div class="watchdetail" onclick="watchDetail(event)">查看明细<div></div></td>
                    
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
                tempSupDataMap.put("total",(Integer.parseInt(tempCurDataMap.get("total"))+Integer.parseInt(tempSupDataMap.get("total")))+"");
                tempSupDataMap.put("overtime",(Integer.parseInt(tempCurDataMap.get("overtime"))+Integer.parseInt(tempSupDataMap.get("overtime")))+"");
                tempSupDataMap.put("finish",(Integer.parseInt(tempCurDataMap.get("finish"))+Integer.parseInt(tempSupDataMap.get("finish")))+"");
                tempSupDataMap.put("doing",(Integer.parseInt(tempCurDataMap.get("doing"))+Integer.parseInt(tempSupDataMap.get("doing")))+"");
                tempSupDataMap.put("hasSub","yes");
            }        
        }
        return resultMap;
    }
    
%>