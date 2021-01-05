<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="MobileInit.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String operation=Util.null2String(request.getParameter("operation"));

if(operation.equals("getModeRemindTtree")){
	int level=Util.getIntValue(fu.getParameter("level"),0);
	int nodeValue=Util.getIntValue(fu.getParameter("nodeValue"),0);
	String selectids=Util.null2String(fu.getParameter("selectids"));
	JSONArray result = new JSONArray();
	
	RecordSet recordSet=new RecordSet();
	RecordSet recordSet1=new RecordSet();
	if(level==0){ //应用目录,查询有设置过微信提醒，并且已经开启的应用
		JSONArray childs = new JSONArray();
		String appsql = "select a.appid,a.remindway,a.isenable,b.showOrder,b.treeFieldName from mode_remindjob a "+
					"left join modeTreeField b on a.appid=b.id group by a.appid,a.remindway,isenable,b.treeFieldName,b.showOrder "+
					"having a.remindway = 5 and a.isenable=1 order by b.showOrder ";
		recordSet.execute(appsql);
		while(recordSet.next()) {
			JSONObject child=new JSONObject();
			
			String appid = recordSet.getString("appid");
			String appname = recordSet.getString("treeFieldName");
			
			if(!"".equals(selectids)){
				String remindsql = "select id from mode_remindjob where appid="+appid+" and isenable=1 and id in("+selectids+")";
				recordSet1.execute(remindsql);
				if(recordSet1.next()){
					child.put("open",true);
	                child.put("checked",true);
				}
			}
			
			child.put("nodeValue", appid);
			child.put("name",appname);
			child.put("isParent", true);
			childs.put(child);					
		}			
		
		Map<String, Object> root=new HashMap<String, Object>();
		root.put("name", "建模提醒");
		root.put("open", true);
		root.put("nocheck", true);
		root.put("children", childs);
		result.put(root);
	}else{
		List remindidList=Util.TokenizerString(selectids,",");
		String remindsql = "select id,name from mode_remindjob where appid="+nodeValue+" and isenable=1 and remindway = 5 ";
		recordSet1.execute(remindsql);
		while(recordSet1.next()){
			String remindid = recordSet1.getString("id");
			String name = recordSet1.getString("name");
                 
            JSONObject jsonWfObj=new JSONObject();
			jsonWfObj.put("nodeValue",remindid);
			jsonWfObj.put("name",name);				 
			if(remindidList.contains(remindid)){
                   jsonWfObj.put("checked",true);
               }
			result.put(jsonWfObj);
		}
	}
	out.print(result.toString());
}
%>