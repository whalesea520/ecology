<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(386,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</TR>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String year = CurrentDate.substring(0,4);

String departmentid=Util.null2String(request.getParameter("departmentid"));
String feeid=Util.null2String(request.getParameter("feeid"));
String style=Util.null2String(request.getParameter("style"));
if(style.equals(""))    style="1";
char flag=2;

String sql="select * from bill_budgetdetail ";
if(!departmentid.equals(""))	sql+=" where departmentid="+departmentid;
ArrayList feeids=new ArrayList();
ArrayList deptids=new ArrayList();
ArrayList ids=new ArrayList();
ArrayList budgets=new ArrayList();

if(departmentid.equals("")){
    RecordSet.executeSql("select * from hrmdepartment");
    while(RecordSet.next()){
    	deptids.add(RecordSet.getString("id"));
    }
}else{
    deptids.add(departmentid);
}

if(feeid.equals("")){
    RecordSet.executeProc("FnaBudgetfeeType_Select","");
    while(RecordSet.next()){
        feeids.add(RecordSet.getString("id"));
    }
}else{
    feeids.add(feeid);
}

RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tmpid=RecordSet.getString("departmentid")+"_"+RecordSet.getString("feeid")+"_"+RecordSet.getString("month");
	ids.add(tmpid);
	budgets.add(RecordSet.getFloat("budget")+"");
}
%>
<form name=frmmain action="DepartmentTotalBudget.jsp" method=post>
<div style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:frmmain.submit(),self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnReset accessKey=R name=button1 onclick="frmmain.submit()"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
</div>
<table class=ViewForm>
    <col width="10%"><col width="30%">
    <col width="10%"><col width="20%">
    <col width="10%"><col width="20%">
    <tr class=Title><th colspan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></TR>
    <tr class=Spacing> <td class=Line1 colspan=15></td></TR>
    <tr>
        <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
        <td class=field><button class=browser onclick="onShowDepartment()"></button>
        <span id=departmentspan><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>">
        <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a></span>
        <input type=hidden name="departmentid" value="<%=departmentid%>">
        </td>
        <td><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td>
        <td class=field><button class=browser onclick="onShowBudgetFee()"></button>
        <span id=feespan><a href="/fna/maintenance/FnaBudgetfeeTypeEdit.jsp?id=<%=feeid%>">
        <%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(feeid),user.getLanguage())%></a></span>
        <input type=hidden name="feeid" value="<%=feeid%>">
        </td>
        <td><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%></td>
        <td class=field>
            <select name=style class=InputStyle size=1>
                <option value="1" <%if(style.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1015,user.getLanguage())%></option>
                <option value="2" <%if(style.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1016,user.getLanguage())%></option>
            </select>
        </td>
    </TR><tr><td class=Line colspan=6></td></tr>
</table>
</form>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = "<a href='/hrm/company/HrmDepartmentDsp.jsp?id='"+id(0)+"'>"+id(1)+"</a>"
	frmmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub
sub onShowBudgetFee()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	feespan.innerHtml = "<a href='/fna/maintenance/FnaBudgetfeeTypeEdit.jsp?id='"+id(0)+"'>"+id(1)+"</a>"
	frmmain.feeid.value=id(0)
	else
	feespan.innerHtml = ""
	frmmain.feeid.value=""
	end if
	end if
end sub
</script>

<%if(style.equals("1")){%>

<table class=ListStyle cellspacing=1>
	<col width="10%">
    <col width="10%">
	<col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
	<col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
	<col width="8%">
	<tr class=header><th colspan=15><%=SystemEnv.getHtmlLabelName(1490,user.getLanguage())%></th></TR>
	<tr class=header>
		<td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></td>
	</TR><TR class=Line><TD colSpan=15></TD></TR>
<%	
	boolean islight=true;
	boolean iswrite=true;
	boolean hasdata=true;
	String feeyeartotal="";
	String monthtotal="";
	String alltotal="";
	
	for(int i=0;i<deptids.size();i++){
		iswrite=true;
		String tmpdeptid=(String)deptids.get(i);
		String deptname=DepartmentComInfo.getDepartmentname(tmpdeptid);
		for(int j=0;j<feeids.size();j++){
		    feeyeartotal="";
			String tmpfeeid=(String)feeids.get(j);
%>	<tr <%if(islight){%> class=datalight <%}else{%> class=datadark<%}%>>
		<td><%if(iswrite){%><%=Util.toScreen(deptname,user.getLanguage())%>
			<%iswrite=!iswrite;
			}%>
		</td>
		<td>
			<%=BudgetfeeTypeComInfo.getBudgetfeeTypename(tmpfeeid)%>
		</td>	
<%
			for(int k=1;k<13;k++){
				String tmpid=tmpdeptid+"_"+tmpfeeid+"_"+k;
				String tmpbudget="";
				int tmpindex=ids.indexOf(tmpid);
				if(tmpindex==-1)	tmpbudget="0";
				else tmpbudget=(String)budgets.get(tmpindex);
				feeyeartotal=Util.getFloatValue(feeyeartotal,0)+Util.getFloatValue(tmpbudget,0)+"";
%>				<td><%=tmpbudget%></td>
<%
			}
			islight=!islight;
%>			
        <td><%=feeyeartotal%></td>
    </TR>
<%		}%>
    <tr class=header style="FONT-WEIGHT: bold">
        <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
        <td>&nbsp;</td>
<%
    monthtotal="";
    alltotal="";
    for(int m=1;m<13;m++){
        RecordSet.executeProc("bill_BudgetDetail_SMonthTotal",tmpdeptid+flag+""+m+flag+year);
        RecordSet.next();
        monthtotal=RecordSet.getString(1);
        if(monthtotal.equals(""))  monthtotal="0";
        alltotal=Util.getFloatValue(monthtotal,0)+Util.getFloatValue(alltotal,0)+"";
%>
		<td><%=Util.getFloatValue(monthtotal,0)%></td>
<%  }
%>
		<td><%=Util.getFloatValue(alltotal,0)%></td>
    </TR>
<%	}%>
    <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>><td colspan=15>&nbsp;</td></tr>
    <tr class=header style="FONT-WEIGHT: bold; COLOR: red">
        <td><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td>
        <td>&nbsp;</td>
<%
    monthtotal="";
    alltotal="";
    for(int n=1;n<13;n++){
        RecordSet.executeProc("bill_BudgetDetail_SAllMonth",""+n+flag+year);
        RecordSet.next();
        monthtotal=RecordSet.getString(1);
        if(monthtotal.equals(""))  monthtotal="0";
        alltotal=Util.getFloatValue(monthtotal,0)+Util.getFloatValue(alltotal,0)+"";
%>
		<td><%=Util.getFloatValue(monthtotal,0)%></td>
<%  }
%>
		<td><%=Util.getFloatValue(alltotal,0)%></td>        
    </TR>
</table>

<%} else {%>

<table class=ListStyle cellspacing=1>
	<col width="10%">
    <col width="10%">
	<col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
	<col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
	<col width="8%">
	<tr class=header><th colspan=15><%=SystemEnv.getHtmlLabelName(1490,user.getLanguage())%></th></TR>
	<tr class=header>
	<td><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></td>
	</TR><tr><td class=Line colspan=15></td></tr>
<%	
	boolean islight=true;
	boolean iswrite=true;
	boolean hasdata=true;
	String feeyeartotal="";
	String monthtotal="";
	String alltotal="";
	
	for(int i=0;i<feeids.size();i++){
		iswrite=true;
		String tmpfeeid=(String)feeids.get(i);
		String feename=BudgetfeeTypeComInfo.getBudgetfeeTypename(tmpfeeid);
		for(int j=0;j<deptids.size();j++){
		    feeyeartotal="";
			String tmpdeptid=(String)deptids.get(j);
%>	<tr <%if(islight){%> class=datalight <%}else{%> class=datadark<%}%>>
		<td><%if(iswrite){%><%=Util.toScreen(feename,user.getLanguage())%>
			<%iswrite=!iswrite;
			}%>
		</td>
		<td>
			<%=DepartmentComInfo.getDepartmentname(tmpdeptid)%>
		</td>	
<%
			for(int k=1;k<13;k++){
				String tmpid=tmpdeptid+"_"+tmpfeeid+"_"+k;
				String tmpbudget="";
				int tmpindex=ids.indexOf(tmpid);
				if(tmpindex==-1)	tmpbudget="0";
				else tmpbudget=(String)budgets.get(tmpindex);
				feeyeartotal=Util.getFloatValue(feeyeartotal,0)+Util.getFloatValue(tmpbudget,0)+"";
%>				<td><%=tmpbudget%></td>
<%
			}
			islight=!islight;
%>			
        <td><%=feeyeartotal%></td>
    </TR>
<%		}%>
    <tr class=header style="FONT-WEIGHT: bold">
        <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
        <td>&nbsp;</td>
<%
    monthtotal="";
    alltotal="";
    for(int m=1;m<13;m++){
        RecordSet.executeProc("bill_BudgetDetail_SMonthTotal",tmpfeeid+flag+""+m+flag+year);
        RecordSet.next();
        monthtotal=RecordSet.getString(1);
        if(monthtotal.equals(""))  monthtotal="0";
        alltotal=Util.getFloatValue(monthtotal,0)+Util.getFloatValue(alltotal,0)+"";
%>
		<td><%=Util.getFloatValue(monthtotal,0)%></td>
<%  }
%>
		<td><%=Util.getFloatValue(alltotal,0)%></td>
    </TR>
<%	}%>
    <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>><td colspan=15>&nbsp;</td></tr>
    <tr class=header style="FONT-WEIGHT: bold; COLOR: red">
        <td><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td>
        <td>&nbsp;</td>
<%
    monthtotal="";
    alltotal="";
    for(int n=1;n<13;n++){
        RecordSet.executeProc("bill_BudgetDetail_SAllMonth",""+n+flag+year);
        RecordSet.next();
        monthtotal=RecordSet.getString(1);
        if(monthtotal.equals(""))  monthtotal="0";
        alltotal=Util.getFloatValue(monthtotal,0)+Util.getFloatValue(alltotal,0)+"";
%>
		<td><%=Util.getFloatValue(monthtotal,0)%></td>
<%  }
%>
		<td><%=Util.getFloatValue(alltotal,0)%></td>        
    </TR>
</table>

<%}%>

</td>
</TR>
</TABLE>
</td>
<td></td>
</TR>
<tr>
<td height="10" colspan="3"></td>
</TR>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>