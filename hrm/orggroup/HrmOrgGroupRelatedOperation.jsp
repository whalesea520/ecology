
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
    String operation =  Util.null2String(request.getParameter("operation"));
    if ("delete".equals(operation)){
      int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"),0);
      String id = Util.null2String(request.getParameter("id"));
			if(!id.equals("")){
				RecordSet.executeSql("delete from HrmOrgGroupRelated where id ="+id);
			}   
      response.sendRedirect("/hrm/orggroup/HrmOrgGroupRelated.jsp?isclose=1&orgGroupId="+orgGroupId);        
    }else if("addMutil".equals(operation)){   
    int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"),0);
		int type = 0;//关联类型
		int contentPartId = 0;
		int secLevelFrom = 0;
		int secLevelTo = 0;     

		type = Util.getIntValue(request.getParameter("sharetype"),0);
		contentPartId = Util.getIntValue(request.getParameter("relatedshareid"),0);
		secLevelFrom = Util.getIntValue(request.getParameter("seclevel"),0);
		secLevelTo = Util.getIntValue(request.getParameter("secLevelTo"),0);

		RecordSet.executeSql("select 1 from HrmOrgGroupRelated where orgGroupId="+orgGroupId+" and type="+type+" and content="+contentPartId+" and secLevelFrom="+secLevelFrom+" and secLevelTo="+secLevelTo);
		if(!RecordSet.next()){
			RecordSet.executeSql("insert into HrmOrgGroupRelated(orgGroupId,type,content,secLevelFrom,secLevelTo )  values("+orgGroupId+","+type+","+contentPartId+","+secLevelFrom+","+secLevelTo+")");
		}
     response.sendRedirect("/hrm/orggroup/HrmOrgGroupRelatedAdd.jsp?isclose=1&orgGroupId="+orgGroupId); 
	   return;
    }
%>