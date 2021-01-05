<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainResourceEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String id = request.getParameter("id");

String name = "";
int type = 1;
String fare = "";
String time = "";
String memo = "";

String sql = "select * from HrmTrainResource where id ="+id;
rs.executeSql(sql); 
while(rs.next()){
  name = Util.null2String(rs.getString("name"));
  type = Util.getIntValue(rs.getString("type_n"));
  fare = Util.null2String(rs.getString("fare"));
  time = Util.null2String(rs.getString("time"));
  memo = Util.null2String(rs.getString("memo"));
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6105,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(89,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainResourceEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainResource:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+68+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainresource/HrmTrainResource.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver name=frmMain action="TrainResourceOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
            <%=name%>          
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>            
              <%if(type == 1){%><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%}%>
              <%if(type == 0){%><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%><%}%>
            </select>
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td>
          <td class=Field >            
            <%=fare%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
          <td class=Field>            
            <%=time%>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
          <td class=Field>
            <%=memo%>
          </td>
        </tr>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
 </form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
 <script language=javascript>
 function doedit(){
  location="HrmTrainResourcetEditDo.jsp?id=<%=id%>";
 }
 function dodelete(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
     document.frmMain.operation.value="delete";
     document.frmMain.submit();
   }
 }
</script>
</BODY>
</HTML>