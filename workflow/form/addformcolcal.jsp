<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

<%
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int isbill = Util.getIntValue(request.getParameter("isbill"),0);
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int operatelevel=UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,"FormManage:All",formid,isbill);
	if(!HrmUserVarify.checkUserRight("FormManage:All", user) || operatelevel < 0){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>

<%
	String formname="";
	String formdes="";
	String createtype = Util.null2String(request.getParameter("createtype")) ;	
	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();
	formdes = Util.StringReplace(formdes,"\n","<br>");
	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");


    String colcalstr = "";
    String maincalstr = "";
    ArrayList mainid = new ArrayList();
    ArrayList mainlable = new ArrayList();
    String sql = "select * from workflow_formdetailinfo where formid ="+formid;
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        colcalstr = RecordSet.getString("colcalstr");
        maincalstr = RecordSet.getString("maincalstr");
    }

    sql = "select t1.fieldid,t3.fieldlable " +
            "from workflow_formfield t1,workflow_formdict t2,workflow_fieldlable t3 " +
            "where (t1.isdetail<>'1' " +
            "or t1.isdetail is null) " +
            "and t1.fieldid=t2.id " +
            "and t1.fieldid=t3.fieldid " +
            "and t3.formid=t1.formid " +
            "and t3.isdefault=1 " +
            "and t2.fieldhtmltype=1 " +
            "and type in (2,3,4,5) " +
            "and t1.formid=" + formid + " "+
            "order by t1.fieldid desc";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainid.add(RecordSet.getString("fieldid"));
        mainlable.add(RecordSet.getString("fieldlable"));
    }

    sql = "select t1.fieldid,t3.fieldlable,t1.groupId " +
            "from workflow_formfield t1,workflow_formdictdetail t2,workflow_fieldlable t3 " +
            "where t1.isdetail='1' " +
            "and t1.fieldid=t2.id " +
            "and t1.fieldid=t3.fieldid " +
            "and t3.formid=t1.formid " +
            "and t3.isdefault=1 " +
            "and t2.fieldhtmltype=1 " +
            "and type in (2,3,4,5) " +
            "and t1.formid=" + formid + " "+
            "order by t1.groupId asc,t1.fieldid desc";

    RecordSet.executeSql(sql);
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6074,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(18369,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";

int colorcount1 = 0;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveRole(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:colsaveRole(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;

if(!ajax.equals("1")){
if(createtype.equals("2")) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",FormDesignMain.jsp?src=editform&formid="+formid+",_self}" ;
}
else {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
}

RCMenuHeight += RCMenuHeightStep ;
}
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="colcalfrm" method="post" action="/workflow/form/formrole_operation.jsp" >
<input type="hidden" value="colcalrole" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=createtype%>" name="createtype">
<input type=hidden name="ajax" value="<%=ajax%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel>0){ %>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:colsaveRole()">
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" cellspacing=0 id="oTable" style="height:400;overflow-x:hidden;overflow-y:auto;">
				<colgroup>
					<col width="35%">
					<col width="20%">
					<col width="35%">
				</colgroup>
				<tr class=header>
					<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(18746,user.getLanguage())%></th>
				</tr>
				<%
				while(RecordSet.next()){
				%>
				<tr class="DataLight">
					<td><%=RecordSet.getString("fieldlable")%></td>
					<td>
						<input type="checkbox" name="sumcol" tzCheckbox="true" value="<%=RecordSet.getString("fieldid")%>" <%=(colcalstr.indexOf("detailfield_"+RecordSet.getString("fieldid"))==-1?"":"checked")%>>
					</td>
					<td>
						<input type="hidden" name="detailfield" value="<%=RecordSet.getString("fieldid")%>">
						<select name="mainfield" style="width:60%">
						<option value="">
						<%
						for(int i=0; i<mainid.size();i++){
						%>
						<option value="<%=mainid.get(i)%>" <%=(maincalstr.indexOf("mainfield_"+mainid.get(i)+"=detailfield_"+RecordSet.getString("fieldid"))==-1?"":"selected")%>><%=mainlable.get(i)%>
						<%}%>
						</select>
					</td>
				</tr>
				<%}%>
			</table>
		</wea:item>
    </wea:group>    
</wea:layout>
</form>

</center>
<script type="text/javascript">
function saveRole(){
    colcalfrm.submit();
}

function colsaveRole(){
    colcalfrm.submit();
}
</script>
</body>
</html>
