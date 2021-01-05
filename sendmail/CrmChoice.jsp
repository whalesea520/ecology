<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OpenWeb" class="weaver.web.OpenWeb" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(527,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";
String CRM_SearchWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String sql = "" ;
String issearch = Util.null2String(request.getParameter("issearch"));
String crmid = "" ;

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(),_self} " ;
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

			<FORM name=CRMID id=CRMID action="/sendmail/CrmMailMerge.jsp?issearch=1" method=post>
			<%
			String mailListUser = "" ;
			String mailListID = ""+Util.getIntValue(request.getParameter("mailList"),0);
			String sqlTemp ="" ;
			if(OpenWeb.isOpen()) {%>
				邮件列表：
				<select name="mailList" onchange="selectUser()">
				<option value="0" ></option>
				<%
				sqlTemp ="select * from webMailList order by id desc" ;
				RecordSet.executeSql(sqlTemp);
				while(RecordSet.next())
				{
				String ListId = RecordSet.getString("id") ;
				String ListName = RecordSet.getString("name") ;
				%>
					<option value="<%=ListId%>" <%if(ListId.equals(mailListID)){%>selected<%}%>><%=ListName%></option>
				<%}
				sqlTemp ="select * from webMailList where id = " + mailListID ;
				RecordSet.executeSql(sqlTemp);
				if (RecordSet.next()) mailListUser = RecordSet.getString("userList") ;
				mailListUser = "," + mailListUser + "," ;
				%>
				</select>
			<%}%>
			<TABLE class=ListStyle cellspacing="1">
			<COLGROUP>
			<COL width="5%">
			<COL width="25%">
			<COL width="20%">
			<COL width="32%">
			<COL width="18%">
			<TBODY>
			<TR class=Header>
				<TH colSpan=5>请选择需要发送的客户</TH>
			</TR>
			<TR class=Header>
				<TD></TD>
				<TD>公司名称</TD>
				<TD>公司英文名称</TD>
				<TD>地址</TD>
				<TD>联系电话</TD>
			</TR>
	

			<%
			sql = "select distinct t1.* from CRM_CustomerInfo  t1,"+leftjointable+" t2 "+ CRM_SearchWhere +" and t1.id = t2.relateditemid";
			rs.executeSql(sql) ;
			int i=0;
			boolean isLight = false;
			while(rs.next()){
				String id = Util.null2String(rs.getString("id")) ;
				String name = Util.null2String(rs.getString("name")) ;
				String engname = Util.null2String(rs.getString("engname")) ;
				String address1 = Util.null2String(rs.getString("address1")) ;
				String phone = Util.null2String(rs.getString("phone")) ;
				isLight = !isLight ;

			%>
			<TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
				<td><input type="checkbox"  style="width:100%" name="choice" value="<%=id%>"
                <%
                    if (!mailListID.equals("0")) {
                        if (mailListUser.indexOf(","+id+",")!=-1) {
                %>
                    checked
                <%
                    }
                    }else{
                %>
                    checked
                <%}%>
                >
                </td>
				<td><%=name%></td>
				<TD><%=engname%></TD>
				<TD><%=address1%></TD>
				<TD><%=phone%></TD>
			</TR>
			<%
			}
			%>
			</FORM>
			<script language="JavaScript">
			function doSubmit(){
                //document.CRMID.choice.value='submit';
                document.CRMID.submit();
			}
            function selectUser(){
                document.CRMID.action='CrmChoice.jsp';
                document.CRMID.submit();
	        }
			</script>

			</TBODY>
			</TABLE>
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

</BODY>
</HTML>
