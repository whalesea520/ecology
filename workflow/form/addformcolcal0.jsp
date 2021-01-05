<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
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
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
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
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
    int subCompanyId2 = -1;
    int subCompanyId= -1;
	if(formid!=0)
		RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
		formdes = RecordSet.getString("formdes");
		formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	  subCompanyId = RecordSet.getInt("subcompanyid");
	  subCompanyId2 = subCompanyId;
		formdes = Util.StringReplace(formdes,"\n","<br>");
	}


    String colcalstr = "";
    String maincalstr = "";
    ArrayList mainid = new ArrayList();
    ArrayList mainlable = new ArrayList();
    String sql = "select * from workflow_formdetailinfo where formid ="+formid;
    if(formid!=0) RecordSet.executeSql(sql);
    if(RecordSet.next()){
        colcalstr = RecordSet.getString("colcalstr");
        maincalstr = RecordSet.getString("maincalstr");
    }

    sql = "select * from workflow_billfield where viewtype=0 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+" order by id";
    if(formid!=0) RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainid.add(RecordSet.getString("id"));
        mainlable.add(SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage()));
    }

    sql = "select * from workflow_billfield where viewtype=1 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+" order by detailtable, dsporder, id";
    if(formid!=0) RecordSet.executeSql(sql);

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int operatelevel=0;

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

<form name="colcalfrm" method="post" action="/workflow/form/formrole_operation0.jsp" >
<input type="hidden" value="colcalrole" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=createtype%>" name="createtype">
<input type=hidden name="ajax" value="<%=ajax%>">

<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
	    <wea:item><%=Util.toScreen(formname,user.getLanguage())%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></wea:item>
    	<wea:item><%=Util.toScreen(formdes,user.getLanguage())%></wea:item>
    </wea:group>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage())%>'>
    	<wea:item attributes="{'isTableList':'true'}">
    	<table class="ListStyle" cellspacing=0>
			  <COLGROUP>
			   <COL width="10%">
			   <COL width="45%">
			   <COL width="45%">
			  <tr class=header>
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18745,user.getLanguage())%></td>
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%></td>
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18746,user.getLanguage())%></td>
			  </tr>
			<%
			    while(RecordSet.next()){
			%>
			  <tr class=header>
			    <td align=center class=field>
			        <input type="checkbox" name="sumcol" value="<%=RecordSet.getString("id")%>" <%=(colcalstr.indexOf("detailfield_"+RecordSet.getString("id"))==-1?"":"checked")%>>
			    </td>
			    <td align=center class=field><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage())%></td>
			    <td align=center class=field>
			    <input type="hidden" name="detailfield" value="<%=RecordSet.getString("id")%>">
			    <select name="mainfield" style="width:100">
			    <option value="">
			    <%
			        for(int i=0; i<mainid.size();i++){
			    %>
			        <option value="<%=mainid.get(i)%>" <%=(maincalstr.indexOf("mainfield_"+mainid.get(i)+"=detailfield_"+RecordSet.getString("id"))==-1?"":"selected")%>><%=mainlable.get(i)%>
			    <%
			        }
			    %>
			    </select>
			    </td>
			  </tr>
			<%
			    }
			%>
			</table>
    	</wea:item>
    </wea:group>
</wea:layout>
</form>

</center>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function saveRole(){
    colcalfrm.submit();
}
</script>
<%}else{%>
<script type="text/javascript">
function colsaveRole(){
    colcalfrm.submit();
}
</script>
<%} %>
</body>
</html>
