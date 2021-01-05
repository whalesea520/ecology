
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<!-- modified by wcd 2014-07-28 [E7 to E8] -->
<%@ page import="weaver.hrm.common.*,weaver.hrm.report.domain.*,weaver.hrm.report.manager.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmRpSubTemplateManager" class="weaver.hrm.report.manager.HrmRpSubTemplateManager" scope="page"/>
<jsp:useBean id="HrmRpSubTemplateConManager" class="weaver.hrm.report.manager.HrmRpSubTemplateConManager" scope="page"/>
<%
    String userid =""+user.getUID();
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
        String tempid = RecordSet.getString("resourceid");
        allCanView.add(tempid);
        AllManagers.getAll(tempid);
        while(AllManagers.next()){
            allCanView.add(AllManagers.getManagerID());
        }
    }// end while
    for (int i=0;i<allCanView.size();i++){
        if(userid.equals((String)allCanView.get(i))){
            canView = true;
        }
    }
    if(!canView) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    /*权限判断结束*/

	int scopeCmd = Util.getIntValue(request.getParameter("scopeCmd"),0);
    int scopeId = Util.getIntValue(request.getParameter("scopeId"),0);
	int templateid = Util.getIntValue(request.getParameter("templateid"),0);
	String cmd = Util.null2String(request.getParameter("cmd"));
	
	if(cmd.equals("del")){
		rs.executeSql("delete from HrmRpSubDefine where scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid +" and templateid = "+templateid);
		rs.executeSql("delete from Hrm_Rp_Sub_Template where id="+templateid);
		templateid = 0;
	}else{
		if(templateid == 0 || cmd.equals("ctrlc")){
			String templateName = Util.null2String(request.getParameter("templateName"));
			HrmRpSubTemplate bean = new HrmRpSubTemplate(true);
			bean.setName(templateName);
			bean.setAuthor(user.getUID());
			bean.setScope(scopeId+"_"+scopeCmd);
			templateid = (Integer)HrmRpSubTemplateManager.insert(bean);
		}
		
		String[] checkshows = request.getParameterValues("check_show");		
		rs.executeSql("delete from HrmRpSubDefine where scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid +" and templateid = "+templateid);
		if(checkshows != null){
			String insertSql = "insert into HrmRpSubDefine(scopeid,resourceid,colname,showorder,header,templateid) values(";
			for(int i=0;i<(checkshows==null?0:checkshows.length);i++){
				String fieldOrder = Util.null2String(request.getParameter("show"+checkshows[i]+"_sn"));
				String fieldName = ""+Util.null2String(request.getParameter("con"+checkshows[i]+"_colname"));
				String fieldLabel = ""+Util.null2String(request.getParameter("con"+checkshows[i]+"_fieldlabel"));
				rs.executeSql(insertSql + "'"+scopeId+"_"+scopeCmd+"'," + userid + ",'" + fieldName + "'," + (Tools.isNull(fieldOrder)?"0.00":fieldOrder) + ",'" + fieldLabel + "',"+templateid+")");
			}
		}
		
		String[] checkcons = request.getParameterValues("check_con");
		HrmRpSubTemplateConManager.deleteCon(templateid);
		if(checkcons!=null){
			String tmpcolname = "",tmphtmltype="",tmptype="",tmpopt = "",tmpvalue = "",tmpopt1 = "",tmpvalue1 = "";
			for(int i=0;i<checkcons.length;i++){
				tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
				tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
				tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
				tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
				tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
				tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
				tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
				HrmRpSubTemplateConManager.saveCon(templateid,tmpcolname,tmphtmltype,tmptype,tmpopt,tmpvalue,tmpopt1,tmpvalue1);
			}
		}
	}
	String method = (scopeId!=1 && scopeId!=3)?"HrmRpSubSearch":"HrmConstRpSubSearch";
	out.println("<script>");
	out.println("parent.location = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method="+method+"&scopeid="+scopeId+"&scopeCmd="+scopeCmd+"&templateid="+templateid+"';");
	out.println("</script>");
%>    