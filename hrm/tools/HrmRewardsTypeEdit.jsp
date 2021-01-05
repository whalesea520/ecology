<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
 rs.executeProc("HrmRewardsType_SelectById",""+id);
	String flag = "";
	String name = "";
	String description = "";
 if(rs.next()){
	flag = Util.toScreen(rs.getString("flag"),user.getLanguage());
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(rs.getString("description"),user.getLanguage());
	}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(808,user.getLanguage())+":"+name;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/tools/HrmRewardsTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmRewardsType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+67+" and relatedid="+id+",_self} " ;
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
<FORM id=weaver name=frmMain action="RewardsTypeOperation.jsp" method=post>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
	<tr> 
            <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
            <td class=Field> <%if(canEdit){%>
              <select class=inputstyle id=flag name=flag>
                <option value="0" <% if (flag.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
                <option value="1" <% if (flag.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
				<option value="2" <% if (flag.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
              </select>
			  <%} else {%>
				<%if (flag.equals("0")) {%><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%><%}%>
				<%if (flag.equals("1")) {%><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%><%}%>
				<%if (flag.equals("2")) {%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%}%>
			  <%}%>
            </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	 <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage></SPAN><%}else{%><%=name%><%}%></TD>
        </TR>
       <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=60 name="description"   value="<%=description%>" onchange='checkinput("description","descriptionimage")'>
          <SPAN id=descriptionimage></SPAN><%}else{%><%=description%><%}%></TD>
        </TR>
   <TR><TD class=Line colSpan=2></TD></TR> 
  </TR>
        
 </TBODY></TABLE>
 
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
 </form> 
 
 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'name,description')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
