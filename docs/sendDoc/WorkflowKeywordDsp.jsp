
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page"/>\
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

int id=Util.getIntValue(request.getParameter("id"),0);

String keywordName="";
String keywordDesc="";
int parentId=0;
String isKeyword="";
double showOrder=0;

RecordSet.executeSql("select * from Workflow_Keyword where id="+id);
if(RecordSet.next()){
	keywordName=Util.null2String(RecordSet.getString("keywordName"));
	keywordDesc=Util.null2String(RecordSet.getString("keywordDesc"));
	parentId=Util.getIntValue(RecordSet.getString("parentId"),0);
	isKeyword=Util.null2String(RecordSet.getString("isKeyword"));
	showOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0);
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16978,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
    
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordEdit.jsp?id="+id+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;	 

    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordAdd.jsp?parentId="+parentId+"&hisId="+id+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;   
   
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordAdd.jsp?parentId="+id+"&hisId="+id+",_self} " ;
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

<div id=divMessage style="color:red">
</div>

<FORM id=weaver name=frmMain action="WorkflowKeywordOperation.jsp" method=post target="_parent">

        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="30%"> <COL width="70%">
		  <TBODY> 
          <TR class=Title> 
              <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <%=keywordName%>
              </TD>
          </TR>

          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

			   <TR> 
				<TD><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></TD>
				<TD class=FIELD> 
					<%=keywordDesc%>           
				  </TD>
			  </TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

			<TR> 
				<TD><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></TD>
				 <TD class=FIELD> 			 					  
                    <%=WorkflowKeywordComInfo.getKeywordName(parentId+"")%> 
				  </TD>
			  </TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 


          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(21512,user.getLanguage())%></TD>
            <TD class=FIELD> 
<%if("1".equals(isKeyword)){%>
                     <%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
<%}else{%>
                     <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
<%}%>
			  </TD>
          </TR> 
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
         
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=showOrder%>
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=id%>">          
</FORM>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

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


</BODY></HTML>

<script language=javascript>
//o为错误类型 1:当前字段有下级节点，不能删除。
function checkForDelete(o){
	if(o=="1"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19441,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="Delete";
		document.frmMain.submit();	
	}
}


function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		var keywordId=<%=id%>;
		document.all("workflowKeywordIframe").src="WorkflowKeywordIframe.jsp?operation=Delete&keywordId="+keywordId;
    }
}

</script>