<%@ page import = "weaver.general.Util,java.util.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%
int formid = Util.getIntValue(request.getParameter("formid"),0) ;
String src = Util.null2String(request.getParameter("src")) ;	

if(src.equals("editform")){
    String sql = "select count(formid) from workflow_formprop where formid = "+formid;

    RecordSet.executeSql(sql);
    if(RecordSet.next() && RecordSet.getInt(1) > 0 ){
        response.sendRedirect("FormDesignMain.jsp?src=editform&formid="+formid) ;
        return ;
    }
}


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:doNext(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",manageform.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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
<FORM id=frmmain name=frmmain method=post>
<input type="hidden" name="formid" value="<%=formid%>">
<input type="hidden" name="src" value="<%=src%>">


<table class=viewform>
  <colgroup>
  <col width="30%">
  <col width="70%">    
  <tbody>
    <tr class=Title>
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(17555,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
      
    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17555,user.getLanguage())%></TD> 
		    <TD class=Field>
              <input type="radio" name="createtype" value="1" checked> <%=SystemEnv.getHtmlLabelName(17556,user.getLanguage())%>&nbsp;
              <input type="radio" name="createtype" value="2" > <%=SystemEnv.getHtmlLabelName(17557,user.getLanguage())%>
            </TD>
		</TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
   </tbody>
</table>
</form>

<br>
<table  width = 100% border = 1 bordercolor = 'black'>
  <tbody>
  <tr>
  <td>
  <%=SystemEnv.getHtmlLabelName(17558 , user.getLanguage())%>
  </td></tr>
  </tbody>
</table>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>



<script language=javascript>
 function doNext(obj){
     if(document.frmmain.createtype[0].checked ){
         document.frmmain.action = "addform.jsp?src=<%=src%>&formid=<%=formid%>" ;
     }
     else {
         document.frmmain.action = "FormDesignMain.jsp?src=<%=src%>&formid=<%=formid%>" ;
     }
     
     obj.disabled = true ;
     document.frmmain.submit();
 }

</script>

</body>
</html>
