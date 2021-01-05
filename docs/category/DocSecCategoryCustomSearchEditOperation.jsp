
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String method = Util.null2String(request.getParameter("method"));
char flag=Util.getSeparator();
int userid=user.getUID();
MultiAclManager am = new MultiAclManager();

int secid = Util.getIntValue(request.getParameter("secCategoryId"),0);
int parentId = Util.getIntValue(SecCategoryComInfo.getParentId(""+secid));
boolean hasSecManageRight = false;
if(parentId>0){
	hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
}
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !hasSecManageRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(method.equalsIgnoreCase("save") ){
    
    int useCustomSearch = Util.getIntValue(Util.null2String(request.getParameter("useCustomSearch")),0);
    RecordSet.executeSql("UPDATE DocSecCategory SET useCustomSearch = " + useCustomSearch + " WHERE id = " + secid);

    String[] settingPropertyId = request.getParameterValues("propertyid");
    String[] settingDocPropertyId = request.getParameterValues("docpropertyid");
    String[] settingVisible = request.getParameterValues("visible");
    String[] settingIsCond = request.getParameterValues("isCond");
    String[] settingCondColumnWidth = request.getParameterValues("condColumnWidth");

	for(int i=0;i<settingPropertyId.length;i++){
		int tmpId = Util.getIntValue(settingPropertyId[i],-1);
		int tmpViewindex = i+1;
		int tmpSecCategoryId = secid;
		int tmpDocPropertyId = Util.getIntValue(settingDocPropertyId[i],0);
		int tmpVisible = Util.getIntValue(settingVisible[i],1);
		int tmpIsCond = Util.getIntValue(settingIsCond[i],0);
		int tmpCondColumnWidth = Util.getIntValue(settingCondColumnWidth[i],1);

    	RecordSet1.executeSql("select count(0) from DocSecCategoryCusSearch where secCategoryId = "+tmpSecCategoryId+" and docPropertyId = "+tmpDocPropertyId);
    	if(RecordSet1.next()&&RecordSet1.getInt(1)==0){
    		RecordSet.executeSql("insert into DocSecCategoryCusSearch"
					+" (secCategoryId,docPropertyId,viewindex,visible,DocSecCategoryTemplateId,isCond,condColumnWidth) "
					+" values( "
					+tmpSecCategoryId+","
					+tmpDocPropertyId+","
					+tmpViewindex+","
					+tmpVisible+","
					+"0"+","
					+"'"+tmpIsCond+"'"+","
					+tmpCondColumnWidth
					+") "
			);
    	} else {
			RecordSet.executeSql("update DocSecCategoryCusSearch"
					+" set secCategoryId = " + tmpSecCategoryId
					+" ,docPropertyId = " + tmpDocPropertyId
					+" ,viewindex = " + tmpViewindex
					+" ,visible = " + tmpVisible
					+" ,isCond = '" + tmpIsCond+"'"
					+" ,condColumnWidth = " + tmpCondColumnWidth
					+" where secCategoryId = " + tmpSecCategoryId
					+" and docPropertyId = " + tmpDocPropertyId
			);
    	}
	}
	
    SubCategoryComInfo.removeMainCategoryCache();
	SecCategoryComInfo.removeMainCategoryCache();
	
	
	SecCategoryCustomSearchComInfo.removeCache();
	
	
	response.sendRedirect("DocSecCategoryCustomSearchEdit.jsp?id="+secid+"&tab=7");
}
%>