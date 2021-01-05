<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page"/>
<% 
if(!HrmUserVarify.checkUserRight("FnaExpensefeeTypeAdd:Add", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
char flag=2;
String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
RecordSet.executeProc("FnaExpensefeeType_SelectByID",id);
RecordSet.next();
String name=RecordSet.getString("name");
String remark=RecordSet.getString("remark");

String standardfee="";
RecordSet.executeProc("FnaExpensefeeRules_SByFandR",id+flag+"-1");
if(RecordSet.next()){
    standardfee=RecordSet.getString("standardfee");
}
boolean canedit = HrmUserVarify.checkUserRight("FnaExpensefeeTypeEdit:Edit", user) ;
int rowindex = 0 ;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(854,user.getLanguage())+" : "+Util.toScreen(name,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaExpensefeeTypeEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaExpensefeeType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+78+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM style="MARGIN-TOP: 0px" name=frmmain method=post action="FnaExpensefeeTypeOperation.jsp">
  <input class=inputstyle type="hidden" name="operation">
  <input class=inputstyle type=hidden name=nodesnum >
  <input class=inputstyle type="hidden" name="id" value="<%=id%>">
      
  <TABLE class=viewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=Field>
      <%if(canedit){%> 
        <input class=inputstyle name=name size="30" onchange='checkinput("name","nameimage")' 
        value="<%=Util.toScreenToEdit(name,user.getLanguage())%>">
        <SPAN id=nameimage></SPAN>
      <%} else {%>
      	<%=Util.toScreen(name,user.getLanguage())%>
      <%}%>
      </td>
    </tr>
   <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
      <td class=Field>
      <%if(canedit){%> 
        <textarea class=inputstyle name="remark" cols="60" rows=4><%=Util.toScreenToEdit(remark,user.getLanguage())%></textarea>
      <%} else {%>
      <%=Util.toScreen(remark,user.getLanguage())%>
      <%}%>
      </td>
    </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
      <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1031,user.getLanguage())%></td>
      <td class=Field>
      <%if(canedit){%> 
        <input class=inputstyle type=text name="standardfee" size=30 value="<%=standardfee%>"
        onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>
      <%} else {%>
      <%=Util.toScreen(standardfee,user.getLanguage())%>
      <%}%>
      </td>
    </tr>
<TR><TD class=Line colSpan=2></TD></TR> 
    </TBODY> 
  </TABLE>
  <br>
  <table class=ListStyle cellspacing=1>
    <COLGROUP> <COL width="10%"> <COL width="45%"> <COL width="45%"><TBODY> 
    <TR class=Header> 
      <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1032,user.getLanguage())%></TH>
    </TR>
 <tr class=spacing style="display:none"> 
      <td class=line1 colspan=4></td>
    </tr>
<%if(canedit){%>
    <tr class=header align=right><td colspan=3>
		<BUTTON Class=Btn type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=Btn type=button accessKey=E onclick="if(isdel()){deleteRow1();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	</td></tr>
   <tr class=spacing style="display:none"> 
      <td class=line1 colspan=4></td>
    </tr>
<%}%>
   
    <tr><td colspan=3>
        <table Class=ListStyle cellspacing=1 cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%">
          <COL width="45%"> 
          <COL width="45%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(789,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(1031,user.getLanguage())%></td>
	      </tr>
            <TR class=Line><TD colspan="4" ></TD></TR> 
<%
    RecordSet.executeProc("FnaExpensefeeRules_SByFeeid",id);
    boolean islight=true;
    while(RecordSet.next()){
        String resourceid=RecordSet.getString("resourceid");
        if(resourceid.equals("-1")) continue;
        String resourcename=ResourceComInfo.getResourcename(resourceid);
        String tmpstandardfee=RecordSet.getString("standardfee");
        if(canedit){
%>
          <tr <%if(islight){%>class=datalight<%} else {%>class=datadark<%}%>> 
	        <td><input class=inputstyle type=checkbox name="check_rules" value=<%=rowindex%>></td>
	        <td><button class=browser onclick="onShowResource(resourceid_<%=rowindex%>,resourcespan_<%=rowindex%>)"></button>
	        <span id="resourcespan_<%=rowindex%>"><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>">
	        <%=Util.toScreen(resourcename,user.getLanguage())%></a></span>
	        <input class=inputstyle type=hidden name="resourceid_<%=rowindex%>" value="<%=resourceid%>">
	        </td>
	        <td><input class=inputstyle type=text name="rules_<%=rowindex%>" value="<%=tmpstandardfee%>"
        onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></td>
	      </tr>
<%
        }else{
%>
          <tr <%if(islight){%>class=datalight<%} else {%>class=datadark<%}%>> 
	        <td>&nbsp;</td>
	        <td>
	        <span id="resourcespan_<%=rowindex%>"><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>">
	        <%=Util.toScreen(resourcename,user.getLanguage())%></a></span>
	        <input class=inputstyle type=hidden name="resourceid_<%=rowindex%>" value="<%=resourceid%>">
	        </td>
	        <td><%=Util.toScreen(tmpstandardfee,user.getLanguage())%></td>
	      </tr>
<%
        }
        islight=!islight;
        rowindex++;
    }
%>
	    </table>
    </td></tr>
  </table>
</FORM>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>
rowindex1 = <%=rowindex%> ;
var rowColor="" ;
function addRow1()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow();
    rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_rules' value="+rowindex1+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=browser name='resource_"+rowindex1+"_browser' "+
				        " onclick=onShowResource(resourceid_"+rowindex1+",resourcespan_"+rowindex1+")>"+
				        " </button> <input class=inputstyle type=hidden name='resourceid_"+rowindex1+"'> "+
				        " <span id='resourcespan_"+rowindex1+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' name='rules_"+rowindex1+"'onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break; 
		}
	}
	rowindex1 = rowindex1*1 +1;
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_rules')
			rowsum1 ++;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_rules'){
			if(document.forms[0].elements[i].checked==true)
				oTable1.deleteRow(rowsum1);	
			rowsum1--;
		}
	}
}
function doEdit(){
    var parastr = "" ;
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_rules')
			parastr+=",resourceid_"+document.forms[0].elements[i].value;
	}
	parastr+=",name";
	parastr=parastr.substring(1);
	
	if(check_form(frmmain,parastr)){
		frmmain.operation.value="edit";
		frmmain.nodesnum.value=rowindex1;
		frmmain.submit();
	}
}
function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmmain.operation.value="delete";
			frmmain.nodesnum.value=rowindex1;
			frmmain.submit();
		}
}
</script>
<script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>
