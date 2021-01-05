
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%@ page import="net.sf.json.JSONObject" %>
<%
String method = Util.null2String(request.getParameter("method"));
String parentid = Util.null2String(request.getParameter("parentid"));
StringBuffer treeStr = new StringBuffer();
treeStr.append("[");
RecordSet rs1=new RecordSet();
if(method.equals("getTreeJson"))
{
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	if(parentid.equals("")) parentid="0";
	RecordSet.executeSql(" select * from LgcAssetAssortment where supassortmentid ="+parentid);
	
	if(RecordSet.getFlag()!= 1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
	}else
	{
		while(RecordSet.next())
		{
			JSONObject json = new JSONObject ();
			int _id = RecordSet.getInt("id");
			String _fullname = RecordSet.getString("assortmentname");
			int _parentid = RecordSet.getInt("supassortmentid");
			json.put("id",_id);
			json.put("name",_fullname);
			json.put("parentId",_parentid);
			json.put("isParent",true);
			
			rs1.executeSql(" select count(0) c from LgcAssetAssortment where supassortmentid="+_id);
			if(rs1.next()&&rs1.getInt("c")>0);
			else
				json.put("isParent",false);
			RecordSet rs2 = new RecordSet();
			rs2.executeSql(" select count(t2.assetid) as c from LgcAsset t1,LgcAssetCountry t2 where t1.id=t2.assetid and t1.assortmentid="+_id);
			rs2.first();
			int havaproduct = rs2.getInt(1);	
			if(!(havaproduct>0)){
				json.put("canassort",false);
			}else
				json.put("canassort",true);
			treeStr.append(json.toString());
		    treeStr.append(",");
		}
		
		String treeJson = treeStr.toString().substring(0,treeStr.toString().length()-1)+"]";
		out.clear();
		out.print(treeJson);
	}
}else if(method.equals("vaildation"))
{
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	String assortid = Util.null2String(request.getParameter("assortid"));
	out.clear();
	out.print(assortid);
}
%>