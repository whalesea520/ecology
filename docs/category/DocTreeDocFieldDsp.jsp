
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

String treeDocFieldId=Util.null2String(request.getParameter("id"));

String treeDocFieldName=DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldId);
String superiorFieldId = DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
int level=Util.getIntValue(DocTreeDocFieldComInfo.getLevel(treeDocFieldId),0);
String showOrder = DocTreeDocFieldComInfo.getShowOrder(treeDocFieldId);
String treeDocFieldDesc = DocTreeDocFieldComInfo.getTreeDocFieldDesc(treeDocFieldId);
String mangerids = DocTreeDocFieldComInfo.getMangerids(treeDocFieldId);


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/docs/category/DocTreeDocFieldEdit.jsp?id="+treeDocFieldId+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;	 

    RCMenu += "{"+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+",/docs/category/DocTreeDocFieldAdd.jsp?superiorFieldId="+superiorFieldId+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;   
   

    if(level<DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+",/docs/category/DocTreeDocFieldAdd.jsp?superiorFieldId="+treeDocFieldId+",_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	

}


%>	

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="" method=post>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">




<table width="100%" height="100%">
    <TR valign=top> 
      <TD> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="30%"> <COL width="70%">
		  <TBODY> 
          <TR class=Title> 
              <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <%=treeDocFieldName%>
              </TD>
          </TR>

          <TR style="height: 1px"><TD class=Line  colSpan=2></TD></TR> 

			   <TR> 
				<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				<TD class=FIELD> 
					<%=treeDocFieldDesc%>           
				  </TD>
			  </TR>
			<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 

			<TR> 
				<TD><%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></TD>
				 <TD class=FIELD> 			 					  
					  <%=ResourceComInfo.getMulResourcename1(mangerids)%>    
				  </TD>
			  </TR>
			<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 


          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <%=DocTreeDocFieldComInfo.getAllSuperiorFieldName(superiorFieldId+"")%></TD>
          </TR> 
          <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 
         
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=showOrder%>
            </TD>
          </TR>
          <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
          
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
</FORM>

</BODY></HTML>