
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(699,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post" action="BillManagementList.jsp">
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
		
		<table class=liststyle cellspacing=1  >
     	<COLGROUP>
     	<!--COL width=10-->
     	<COL width="40%">
        <COL width="20%">
        <COL width="20%">
        <TR class="Header">
    	  <TH colSpan=5><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(699,user.getLanguage())%></TH></TR>

        <tr class=header>
          <!--td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td-->
          <td><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(19532,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
        </tr><TR class=Line style="height:1px;"><TD colspan="5" ></TD></TR>
          <%          
              int linecolor=0;
              RecordSet.executeSql("SELECT formid,id,isprint FROM workflow_Formmode where isbill='1' order by id");
              ArrayList showmodelist = new ArrayList();
              ArrayList printmodelist= new ArrayList();
              ArrayList formlist=new ArrayList();
              if(RecordSet.next()){
                  formlist.add(Util.null2String(RecordSet.getString("formid")));
                  int isprint=Util.getIntValue(RecordSet.getString("isprint"),-1);
                  String modeid=Util.null2String(RecordSet.getString("id"));
                  if(isprint==0){
                    showmodelist.add(modeid);
                    if(RecordSet.next()){
                        printmodelist.add(Util.null2String(RecordSet.getString("id")));
                    }else{
                        printmodelist.add(modeid);
                    }
                  }else{
                    printmodelist.add(modeid);
                    showmodelist.add("");
                  }
              }

              RecordSet.executeSql("SELECT id ,namelabel,tablename FROM workflow_bill where invalid is null order by id");
              String id = "";
              int namelabel = 0;
              String showmodeid="";
              String printmodeid="";
              while(RecordSet.next()){
              		
              		String tablename = Util.null2String(RecordSet.getString("tablename"));
              		int id_integer = RecordSet.getInt("id");
              		if(tablename.equals("formtable_main_"+id_integer*(-1)) || tablename.startsWith("uf_")) continue;
              
                  id=Util.null2String(RecordSet.getString("id"));
                  namelabel=Util.getIntValue(RecordSet.getString("namelabel"),0);
                  showmodeid="";
                  printmodeid="";
                  rs.executeSql("SELECT id,isprint FROM workflow_Formmode where isbill='1' and formid="+id+" order by id");
                  while(rs.next()){
                      int isprint=Util.getIntValue(rs.getString("isprint"),-1);
                      String modeid=Util.null2String(rs.getString("id"));
                      if(isprint==0){
                        showmodeid=modeid;
                        printmodeid=modeid;
                      }else{
                          if(isprint==1){
                              printmodeid=modeid;
                          }
                      }
                  }
                  
          %>
          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
            <!--td>
              <input type="checkbox"  name="delete_form_id" value="<%=id%>" onClick=unselectall()>
            </td-->
            <td><a href="/workflow/workflow/BillManagementDetail.jsp?billId=<%=id%>">
            	<%=SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())%></a></td>
            <td><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=id%>&isbill=1&isprint=0&modeid=<%=showmodeid%>')">
            	<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></a></td>
            <td><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=id%>&isbill=1&isprint=1&modeid=<%=printmodeid%>')">
            	<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></a></td>
          </tr>
          <%
          	if(linecolor==0)	linecolor=1;
          	else	linecolor=0;
          }
          %>
          <!--tr class="header">
            <td colspan=5>
              <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
          </tr-->
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
</form>
<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_form_id') {
if(!document.form2.elements[i].disabled){
    document.form2.elements[i].checked=(checked==true?true:false);
}
} } }


function unselectall()
{
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	len=document.form2.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.form2.elements[i].name=='delete_form_id')
			if(document.form2.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?") ;
}

</script>

<body>
</html>