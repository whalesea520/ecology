<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.formmodel.apps.ktree.KtreeFunction"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.util.JSONBuilder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	KtreeFunction ktreeFunction = new KtreeFunction();
	String versionid = Util.null2String(request.getParameter("versionid"));
	String search = Util.null2String(request.getParameter("search"));
// 	System.out.println(versionid+">>>>>"+search);
// 	String sql = "select f1.id,f1.functionName,(select top 1 '1' from uf_ktree_function f2 where f2.pid=f1.id  ) as havsub,f1.pid "
				
	String sql= "select * from uf_ktree_function where id in( "+
				" select fml.functionid as cou from uf_ktree_functionModifyLog fml  left join  uf_ktree_visitlog km on fml.functionId=km.functionid "+ 
				" where fml.versionid="+versionid+" and km.id is null "+
				" union "+
				" select fml.functionid as cou from uf_ktree_functionModifyLog fml,uf_ktree_visitlog vl "+ 
				" where fml.versionid=vl.versionId and fml.functionId=vl.functionId "+
				" and fml.updateDatetime>vl.visitdatetime "+
				" and vl.versionid="+versionid+" and vl.userId="+user.getUID()+" ) order by disorder ";
// 	System.out.println("二级菜单sql："+sql);
System.out.println(sql);
	rs.executeSql(sql);
	JSONArray functionarray = new JSONArray();
	String havsubNodes="";
	String pids="";
	String ids = "";
	while(rs.next()){
		JSONObject obj = new JSONObject();
		String id = Util.null2String(rs.getString("id"));
		obj.put("id", id);
		ids+=","+id;
		String functionName = Util.null2String(rs.getString("functionName"));
		boolean isnew =ktreeFunction.isnew(versionid, id, user.getUID(),"");
// 		if(isnew){
			obj.put("isNewFlag", "1");
// 		}
		obj.put("name", functionName);
// 		obj.put("isclick","true");
// 		if(Util.null2String(rs.getString("havsub")).equals("1")){
// 			havsubNodes+=","+id;
// 			obj.put("isParent", "true");
// 			obj.put("isclick","false");
// 		}
		
		int tmpPid = Util.getIntValue(rs.getString("pid"),0);
		obj.put("pId", tmpPid);
		if(tmpPid!=0)
			pids+=","+tmpPid;
		obj.put("versionid",versionid);
		functionarray.add(obj);
	}
	if(ids.length()>0){
		ids = ids.substring(1);
	}
	if(pids.length()>0){
		pids = pids.substring(1);
	}
	getParentNode(pids, functionarray, versionid, user.getUID(),ids);
	if(havsubNodes.length()>0){
		havsubNodes = havsubNodes.substring(1);
	}
	
	out.print(functionarray);
%>
<%!
public void getParentNode(String pids,JSONArray functionarray,String versionid,int userid,String ids){
	KtreeFunction ktreeFunction = new KtreeFunction();
	RecordSet rs= new RecordSet();
	String sql = "select f1.id,f1.functionName,f1.pid "
				+" from uf_ktree_function f1 where id in("+pids+") and id not in("+ids+")";
	rs.executeSql(sql);
	pids="";
	while(rs.next()){
		JSONObject obj = new JSONObject();
		String id = Util.null2String(rs.getString("id"));
		obj.put("id", id);
		ids+=","+id;
		String functionName = Util.null2String(rs.getString("functionName"));
		boolean isnew =ktreeFunction.isnew(versionid, id, userid,"");
		if(isnew){
			obj.put("isNewFlag", "1");
		}
		obj.put("name", functionName);
		obj.put("isclick","true");
		obj.put("isParent", "true");
		obj.put("isclick","false");
		
		int tmpPid = Util.getIntValue(rs.getString("pid"),0);
		obj.put("pId", tmpPid);
		if(tmpPid!=0)
			pids+=","+tmpPid;
		obj.put("versionid",versionid);
		functionarray.add(obj);
	}
	if(pids.length()>0){
		pids = pids.substring(1);
		getParentNode(pids, functionarray, versionid, userid,ids);
	}
}

%>