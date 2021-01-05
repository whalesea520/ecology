
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mu" class="weaver.page.maint.MenuUtil" scope="page" />
<%
	String menutype = Util.null2String(request.getParameter("typeid"));
	String parentid = Util.null2String(request.getParameter("parentid"));
	String isroot = Util.null2String(request.getParameter("isroot"));
	String userId = Util.null2String(request.getParameter("userid"));
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	boolean hasRight = Boolean.parseBoolean(Util.null2String(request.getParameter("hasRight")));
	//out.print(mu.getMenuJsonStr(menutype,0,userId,subCompanyId,hasRight).toString());
	
	StringBuffer treeStr = new StringBuffer();
	treeStr.append("[");
	JSONObject json = new JSONObject ();
	if("1".equals(isroot)){
		json.put("id",0);
		json.put("isParent",true);
		json.put("parentId",0);
		json.put("name",SystemEnv.getHtmlLabelName(33368,user.getLanguage()));
		json.put("menutype",menutype);
		treeStr.append(json.toString());
	    treeStr.append(",");
	    out.print(treeStr.toString().substring(0,treeStr.toString().length()-1)+"]");
	    return;
	}
	rs.executeSql("select id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue,selectnodes from menucustom where menutype='"+menutype+"' and menuparentid="+parentid+" order by cast( menuindex as int)");
	while (rs.next()) {
		
		json.put("id",rs.getString("id"));
		json.put("isParent",true);
		json.put("parentId",rs.getString("menuparentid"));
		json.put("name",rs.getString("menuname"));
		
		json.put("openIcon",rs.getString("menuicon"));
		json.put("icon",rs.getString("menuicon"));
		json.put("menuhref",rs.getString("menuhref").replaceAll("：",":"));
		
		json.put("menutype",rs.getString("menutype"));
		json.put("menuindex",rs.getString("menuindex"));
		json.put("target",rs.getString("menutarget"));
		
		json.put("righttype",rs.getString("righttype"));
		json.put("rightvalue",rs.getString("rightvalue"));
		
		json.put("sharetype",rs.getString("sharetype"));
		json.put("sharevalue",rs.getString("sharevalue"));
		json.put("selectnodes",rs.getString("selectnode"));
		
		rs1.executeSql("select count(0) m from menucustom  where menutype='"+menutype+"' and menuparentid = " + rs.getString("id"));
	    if(rs1.next()&&rs1.getInt(1)==0) json.put("isParent",false);
	    json.put("viewIndex",rs.getString("id"));
	    treeStr.append(json.toString());
	    treeStr.append(",");
	}
	out.print(treeStr.toString().substring(0,treeStr.toString().length()-1)+"]");
%>
