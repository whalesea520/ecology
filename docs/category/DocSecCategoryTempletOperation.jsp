
<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String method=Util.null2String(request.getParameter("method"));

int id = Util.getIntValue(Util.null2o(request.getParameter("id")));
int secCategoryId = Util.getIntValue(Util.null2o(request.getParameter("secCategoryId")));
int mouldType = Util.getIntValue(Util.null2o(request.getParameter("mouldType")));
int mouldId = Util.getIntValue(Util.null2o(request.getParameter("mouldId")));
int isDefault = Util.getIntValue(Util.null2o(request.getParameter("isDefault")));
int mouldBind = Util.getIntValue(Util.null2o(request.getParameter("mouldBind")));

MultiAclManager am = new MultiAclManager();
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secCategoryId),0);
int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid),0);
int parentid =  Util.getIntValue(SecCategoryComInfo.getParentId(""+secCategoryId),0);
boolean hasSecRight = false;
if(parentid>0){
	hasSecRight = am.hasPermission(parentid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
}
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !hasSecRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

RecordSet rs = new RecordSet();
  
if("add".equals(method)) {
	rs.executeSql("insert into DocSecCategoryMould(secCategoryId,mouldType,mouldId,isDefault,mouldBind) values("+secCategoryId+","+mouldType+","+mouldId+","+isDefault+","+mouldBind+")");
	rs.executeSql("select max(id) from DocSecCategoryMould where secCategoryId = "+secCategoryId);
    if(rs.next()){
    	int rtn = rs.getInt(1);
    	net.sf.json.JSONObject json = new net.sf.json.JSONObject();
    	json.put("id",rtn);
    	out.println(json.toString());
    }
} else if("delete".equals(method)) {
	rs.executeSql("delete from DocSecCategoryMouldBookMark where DocSecCategoryMouldId = " + id);
	rs.executeSql("delete from DocSecCategoryMould where id = " + id);
	if(mouldType==3||mouldType==7){
	    rs.executeSql("select 1 from DocSecCategoryMould where  secCategoryId="+secCategoryId+" and mouldId=" + mouldId);
		if(!rs.next()){
			rs.executeSql("delete from workflow_docshow where secCategoryId="+secCategoryId+" and docMouldId=" + mouldId);
		}
	}
	net.sf.json.JSONObject json = new net.sf.json.JSONObject();
   	json.put("id",id);
   	out.println(json.toString());
} else if("save".equals(method)){
	String[] ids = request.getParameterValues("id");
	String[] mouldTypes = request.getParameterValues("mouldType");
	String[] mouldIds = request.getParameterValues("mouldId");
	String[] isDefaults = request.getParameterValues("isDefault");
	String[] mouldBinds = request.getParameterValues("mouldBind");
	for(int i=0;ids!=null&&i<ids.length;i++){
		int currIsDefault = 0;
		for(int j=0;isDefaults!=null&&j<isDefaults.length;j++){
			if(isDefaults[j].equals(ids[i]))
				currIsDefault = 1;
		}
		if(currIsDefault==1){
			rs.executeSql("update DocSecCategoryMould set isDefault=0 where secCategoryId="+secCategoryId+" and mouldType="+Util.getIntValue(mouldTypes[i],1));
		}
		rs.executeSql("update DocSecCategoryMould set mouldBind=1 where secCategoryId="+secCategoryId+" and mouldType="+Util.getIntValue(mouldTypes[i],1)+" and mouldBind="+Util.getIntValue(mouldBinds[i]));
		//System.out.println(mouldIds[i].trim());
		String sql = " update DocSecCategoryMould set " +
		" secCategoryId = " + secCategoryId + "," +
		" mouldType = " + Util.getIntValue(mouldTypes[i],1) + "," +
		" mouldId = " + Util.getIntValue(Util.null2String(mouldIds[i]).trim(),0) + "," +
		" isDefault = " + currIsDefault + "," +
		" mouldBind = " + Util.getIntValue(mouldBinds[i]) + "" +
		" where id = " + ids[i];
		rs.executeSql(sql);
	}
	response.sendRedirect("DocSecCategoryTempletEdit.jsp?id="+secCategoryId+"&tab=4");
}
SecCategoryMouldComInfo.removeCache();
%>