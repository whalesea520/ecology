
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
String docId = Util.null2String(request.getParameter("docId"));
String selectDateFrom = Util.null2String(request.getParameter("selectDateFrom"));
String selectDateTo = Util.null2String(request.getParameter("selectDateTo"));
String isSearch = Util.null2String(request.getParameter("isSearch"));
boolean canedit=false;
if(HrmUserVarify.checkUserRight("WebSiteView:View",user)) {
	canedit=true;
   }
if (!canedit)
{
	response.sendRedirect("/notice/noright.jsp");
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = Util.toScreen("评论列表",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaverA.submit(),_self} " ;
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

<FORM id=weaverA name="weaverA" action="CommentList.jsp" method=post >
<input type="hidden" name="isSearch" value="1">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="35%">
  <COL width="15%">
  <COL width="35%">
  <TBODY>
          <TR>
          <TD>文档</TD>
          <TD class=Field>
			 <BUTTON class=Browser onclick="showDoc()"></BUTTON>
             <input name=docId type="hidden" value="<%=docId%>">
			 <SPAN id=docIdImage><%=DocComInfo.getDocname(docId)%></SPAN>
		  </TD>
		  <TD>时间</TD>
          <TD class=Field>
			  <BUTTON class=Calendar onclick="getDate('selectDateFromImage','selectDateFrom')"></BUTTON>从：
              <input name=selectDateFrom type="hidden" value="<%=selectDateFrom%>">
			  <SPAN id=selectDateFromImage><%=selectDateFrom%></SPAN> -  
			  <BUTTON class=Calendar onclick="getDate('selectDateToImage','selectDateTo')"></BUTTON>到：
              <input name=selectDateTo type="hidden" value="<%=selectDateTo%>">
			  <SPAN id=selectDateToImage><%=selectDateTo%></SPAN>			  
		  </TD>
        </TR>
		<tr><td class=Line colspan=4></td></tr>
  </TBODY>
</TABLE>
</FORM>
<%if(!isSearch.equals("")) {%>
<FORM id=weaverD action="CommentOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">

<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=separator>
	<TD class=Sep1 colSpan=2></TD></TR>
	<TR>
	<TD colSpan=2>
	<BUTTON class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>

	</TD>
	</TR>
  </TBODY>
</TABLE>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="5%">
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="30%">
  <COL width="20%">
<TBODY>
<TR class=Header>
	<th width=10>&nbsp;</th>
	<th>文档</th>
	<th>评论人</th>
	<th>评论人邮件</th>
	<th>评论内容</th>
	<th>评论时间</th>
</TR>
<TR class=Line><TD colSpan=6></TD></TR>

<%

String sqlStr = "select * from DocWebComment where id !=0 " ;
if (!docId.equals(""))
	sqlStr += " and docId = " + docId ;
if (!selectDateFrom.equals(""))
	sqlStr += " and createDate >= '" + selectDateFrom + "' ";
if (!selectDateTo.equals(""))
	sqlStr += " and createDate <= '" + selectDateTo + "' ";
	
sqlStr += " order by id desc" ;
RecordSet.executeSql(sqlStr);
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input type=checkbox name=commentIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td>
			<%=DocComInfo.getDocname(RecordSet.getString("docId"))%>
			</td>
			<td>
			<%=RecordSet.getString("name")%>
			</td>
			<td>
			<a href="mailto:<%=RecordSet.getString("mail_1")%>" ><%=RecordSet.getString("mail_1")%></a>
			</td>
			<td>
			<%=RecordSet.getString("comment_1")%>
			</td>
			<td>
			<%=RecordSet.getString("createDate")%> - <%=RecordSet.getString("createTime")%>
			</td>	
    </tr> 
<%	
	isLight = !isLight;
}%>
	  </TBODY>
	  </TABLE>
</FORM>
<%}%>
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
<script language=vbs>
sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		if id(1)<> "" then
		weaverA.docId.value=id(0)
		docIdImage.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		else
		weaverA.docId.value=""
		docIdImage.innerHtml = ""
		end if
	end if	
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


