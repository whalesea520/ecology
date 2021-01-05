
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="DMLActionBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.formmode.interfaces.action.WSActionManager" scope="page" />
<jsp:useBean id="sapActionManager" class="weaver.formmode.interfaces.action.SapActionManager" scope="page" />
<jsp:useBean id="baseAction" class="weaver.formmode.interfaces.action.BaseAction" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
String sql = "";

int id = Util.getIntValue(request.getParameter("id"),0);
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
String expendname = InterfaceTransmethod.toHtmlForMode(request.getParameter("expendname"));
int showtype = Util.getIntValue(request.getParameter("showtype"),1);
int opentype = Util.getIntValue(request.getParameter("opentype"),1);
int hreftype = Util.getIntValue(request.getParameter("hreftype"),1);
String hreftarget = InterfaceTransmethod.toHtmlForMode(request.getParameter("hreftarget"));
//String showcondition = InterfaceTransmethod.toHtmlForMode(request.getParameter("showcondition"));
int isshow = Util.getIntValue(request.getParameter("isshow"),0);
int hrefid = Util.getIntValue(request.getParameter("hrefid"),0);
double showorder = Util.getDoubleValue(request.getParameter("showorder"),0);
int issystem = Util.getIntValue(request.getParameter("issystem"),0);
int isbatch = Util.getIntValue(request.getParameter("isbatch"),0);
int createpage = Util.getIntValue(request.getParameter("createpage"),0);
int managepage = Util.getIntValue(request.getParameter("managepage"),0);
int viewpage = Util.getIntValue(request.getParameter("viewpage"),0);
int moniterpage = Util.getIntValue(request.getParameter("moniterpage"),0);

int istriggerwf = Util.getIntValue(request.getParameter("istriggerwf"),0);
String interfaceaction = Util.null2String(request.getParameter("interfaceaction"));

//先删除数据再重新保存
if (operation.equals("add")) {
	sql = "insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,isbatch,createpage,managepage,viewpage,moniterpage) ";
	sql += "values ("+modeid+",'"+expendname+"','"+showtype+"','"+opentype+"','"+hreftype+"','"+hrefid+"','"+hreftarget+"','"+isshow+"','"+showorder+"','"+issystem+"','"+isbatch+"','"+createpage+"','"+managepage+"','"+viewpage+"','"+moniterpage+"')";
	rs.executeSql(sql);
	sql = "select max(id) id from mode_pageexpand where modeid = " + modeid + " and expendname = '" + expendname + "'";
	rs.executeSql(sql);
	while(rs.next()){
		id = rs.getInt("id");
	}
	
	// 默认所有人都可以查看
	expandBaseRightInfo.init();
	expandBaseRightInfo.setModeid(modeid);
	expandBaseRightInfo.setExpandid(id);
	expandBaseRightInfo.setRighttype(5);
	expandBaseRightInfo.setRelatedids("0");
	
	expandBaseRightInfo.setShowlevel(10);
	expandBaseRightInfo.insertAddRight();
	
	//添加接口动作
	if(istriggerwf==1){
		sql = "insert into mode_pageexpanddetail (mainid,interfacetype,interfacevalue) values("+id+",1,'"+istriggerwf+"')";
		rs.executeSql(sql);
	}
	if(!interfaceaction.equals("")){
		sql = "insert into mode_pageexpanddetail (mainid,interfacetype,interfacevalue) values("+id+",2,'"+interfaceaction+"')";
		rs.executeSql(sql);		
	}
	
	response.sendRedirect("/formmode/interfaces/ModePageExpandEdit.jsp?id="+id);
	//response.sendRedirect("/formmode/interfaces/ModePageExpand.jsp?modeid="+modeid);
}else if (operation.equals("edit")) {
	StringBuffer sb = new StringBuffer();
	sb.append("update mode_pageexpand set ");
	sb.append("modeid = '" + modeid+"',");
	sb.append("expendname = '" + expendname+"',");
	sb.append("showtype = '" + showtype+"',");
	sb.append("opentype = '" + opentype+"',");
	sb.append("hreftype = '" + hreftype+"',");
	sb.append("hrefid = '" + hrefid+"',");
	sb.append("hreftarget = '" + hreftarget+"',");
	//sb.append("showcondition = '" + showcondition+"',");
	sb.append("isshow = '" + isshow+"',");
	
	sb.append("createpage = '" + createpage+"',");
	sb.append("managepage = '" + managepage+"',");
	sb.append("viewpage = '" + viewpage+"',");
	sb.append("moniterpage = '" + moniterpage+"',");
	
	sb.append("isbatch = '" + isbatch+"',");
	sb.append("showorder = '" + showorder+"' ");
	sb.append("where id = " + id);
	sql = sb.toString();
	rs.executeSql(sql);
	
	
	//添加接口动作
	sql = "delete from mode_pageexpanddetail where mainid = " + id;
	rs.executeSql(sql);
	if(istriggerwf==1){
		sql = "insert into mode_pageexpanddetail (mainid,interfacetype,interfacevalue) values("+id+",1,'"+istriggerwf+"')";
		rs.executeSql(sql);
	}
	if(!interfaceaction.equals("")){
		sql = "insert into mode_pageexpanddetail (mainid,interfacetype,interfacevalue) values("+id+",2,'"+interfaceaction+"')";
		rs.executeSql(sql);		
	}
	
	response.sendRedirect("/formmode/interfaces/ModePageExpandEdit.jsp?id="+id);
}else if (operation.equals("del")) {
	sql = "delete from mode_pageexpand where id = " + id;
	rs.executeSql(sql);
	response.sendRedirect("/formmode/interfaces/ModePageExpand.jsp?modeid="+modeid);
}else if (operation.equals("deletedmlaction")) {
	String[] checkdmlids = request.getParameterValues("dmlid");
	if(null!=checkdmlids)
	{
		for(int i = 0;i<checkdmlids.length;i++)
		{
			int dmlid = Util.getIntValue(checkdmlids[i],0);
			if(dmlid>0)
			{
				int actiontype_t = Util.getIntValue(request.getParameter("actiontype"+dmlid), -1);
				if(actiontype_t == 0){
					DMLActionBase.deleteDmlActionFieldMapByActionid(dmlid);
					DMLActionBase.deleteDmlActionSqlSetByActionid(dmlid);
					DMLActionBase.deleteDmlActionSetByid(dmlid);
				}else if(actiontype_t == 1){
					wsActionManager.setActionid(dmlid);
					wsActionManager.doDeleteWsAction();
				}else if(actiontype_t == 2){
					sapActionManager.setActionid(dmlid);
					sapActionManager.doDeleteSapAction();
				}
			}
		}
	}
	response.sendRedirect("/formmode/interfaces/ModePageExpandEdit.jsp?id="+id);
}

%>