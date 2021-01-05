
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
int currentyear = today.get(Calendar.YEAR) ;
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck = "name";
String id = ""+Util.getIntValue(request.getParameter("id"),0);
String typeID = "0";
String releaseYear = "";
String name = "";
String HeadDoc = "";
RecordSet.executeSql("select * from WebMagazine where id = " + id);
if (RecordSet.next()) 
{
	typeID = ""+Util.getIntValue(RecordSet.getString("typeID"),0);  
	releaseYear = Util.null2String(RecordSet.getString("releaseYear"));
	name = Util.null2String(RecordSet.getString("name"));
	HeadDoc = Util.null2String(RecordSet.getString("docID"));	
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/web/webmagazine/WebMagazineEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineList.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10"  colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<TABLE class=ViewForm>			
			<COLGROUP><COL width="10%"><COL width="90%">
			<TBODY>
			<tr> 
				<td>
					<!--刊名-->
					<%=SystemEnv.getHtmlLabelName(31517,user.getLanguage())%>
				</td>
				<td class=Field>
				<%
					String typeName = "";
					RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
					if (RecordSet.next()) 
					{
						typeName = Util.null2String(RecordSet.getString("name"));
					}
					out.print(typeName);
				%>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<tr> 
				<td>
					<!--刊号-->
					<%=SystemEnv.getHtmlLabelName(31518,user.getLanguage())%>
				</td>
				<td class=Field>
					<%=releaseYear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=name%>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<TR>
				<TD>
					<!--刊首文章-->
					<%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%>
				</TD>
				<TD class=Field>
				<%
					ArrayList docIDArray= Util.TokenizerString(HeadDoc,",");
					for(int i=0;i<docIDArray.size();i++)
					{
						out.print("<a href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>&nbsp;&nbsp;");
					}
				%>
				</TD>
			</TR>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR>			
			</TABLE>

			<table Class=ListStyle id="oTable" cellspacing="1"><COLGROUP>
				<COL width="35%">
				<COL width="30%">
				<COL width="30%">
			  <tr class=header> 
					<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(31520,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31520,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
			   </tr>
			   <TR class=Line style="height: 1px!important;"><TD colspan="3" ></TD></TR> 
			   <%
				boolean colorFlag = false ;
				RecordSet.executeSql("select * from WebMagazineDetail where mainID = " + id +" order by id asc");
				while(RecordSet.next()){
				if (colorFlag){
				%>
				<tr class="DataDark"> 
				<%}else{%>
				<tr class="DataLight"> 
				<%}%>
					<td><%=RecordSet.getString("name")%></td>
					<td>
					<%if(RecordSet.getString("isView").equals("0")){%>
					<img src="/images/BacoCross_wev8.gif" border="0">
					<%}
					else 
					if(RecordSet.getString("isView").equals("1")){%>
					<img src="/images/BacoCheck_wev8.gif" border="0">
					<%}%>
					</td>
					<td>
					<%
					docIDArray = Util.TokenizerString(Util.null2String(RecordSet.getString("docID")),",");
					for(int i=0;i<docIDArray.size();i++)
					{
						out.print("<a href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>&nbsp;&nbsp;");
					}
					%></td>
			   </tr>
 			  <%
			   colorFlag = !colorFlag;
			  }
			  %>
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
</BODY>
</HTML>