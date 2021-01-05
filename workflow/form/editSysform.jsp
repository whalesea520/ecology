
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");  	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
%>
</head>
<%

	String type="";
	String formname="";
	String formdes="";
	int formid=0;
    String subCompanyId2 = "";
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
    String tablename="";
 
RecordSet.executeSql("select * from workflow_bill where id="+formid);
if(RecordSet.next()){
	formname = Util.null2String(SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage()));
	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formdes = RecordSet.getString("formdes");
	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	subCompanyId = RecordSet.getInt("subcompanyid");
	subCompanyId2 = ""+subCompanyId;
	tablename = RecordSet.getString("tablename");
}

boolean candelete = true;
RecordSet.executeSql("select * from workflow_base where formid="+formid);
if(RecordSet.next()) candelete = false;

    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }
    subCompanyId2 = ""+subCompanyId;
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1")){
	needfav ="1";
}
String needhelp ="";
titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>  
<body style="overflow-y:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:addformtabretun(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="addformtabspecial" method="post" action="" >
<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
		<wea:item>
			<%=Util.toScreenToEdit(formname,user.getLanguage())%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></wea:item>
		<wea:item><%=tablename %></wea:item>
		<%if(detachable==1){%> 
		<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		<wea:item>
			    <span id=subcompanyspan1 name=subcompanyspan1> <%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%></span>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></wea:item>
		<wea:item>
			<%=Util.toScreen(formdes,user.getLanguage())%>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</td>
</tr>
</TABLE>
</body>
<script type="text/javascript">
try{
	parent.parent.setTabObjName("<%=Util.toScreenToEdit(formname,user.getLanguage()) %>");
}catch(e){}
function addformtabretun(){
	window.parent.location ="/workflow/form/manageform_sys.jsp?ajax=1";
}
</script>
</html>
