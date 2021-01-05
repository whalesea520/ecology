
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(19379,user.getLanguage());
String needfav ="1";
String needhelp ="";
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),30);

String usercode="";
rs.executeSql("select workcode from hrmresource where id="+user.getUID());
if(rs.next()){
    usercode=Util.null2String(rs.getString("workcode"));
}
String sqlwhere="where t1.PieceRateNo=t2.PieceRateNo and t1.subcompanyid=t2.subcompanyid and t1.subcompanyid="+user.getUserSubCompany1()+" and t1.departmentid="+user.getUserDepartment()+" and t1.UserCode='"+usercode+"' ";
String orderby = "t1.PieceYear,t1.PieceMonth,t1.PieceRateDate,t1.PieceRateNo ";

%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver action="MyPieceRateData.jsp" method=post>
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

				<TABLE width="100%">
					<tr>
						<td valign="top">
							<%
								String tableString = "";
								if(perpage <2) perpage=30;

								String backfields = "t1.id,t1.PieceYear,t1.PieceMonth,t1.PieceRateDate,t1.PieceRateNo,t2.PieceRateName,t1.PieceNum,t1.memo ";
								String fromSql  = "from HRM_PieceRateInfo t1,HRM_PieceRateSetting t2 ";
								String sqlWhere = sqlwhere;
									tableString =" <table  tabletype=\"none\" pagesize=\""+perpage+"\" >"+
									"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" />"+
									"			<head>"+
                                    "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(16221,user.getLanguage())+"\" column=\"PieceRateDate\" orderkey=\"t1.PieceRateDate\"/>"+
									"				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19383,user.getLanguage())+"\" column=\"PieceRateNo\" orderkey=\"t1.PieceRateNo\"/>"+
									"				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19384,user.getLanguage())+"\" column=\"PieceRateName\" orderkey=\"t2.PieceRateName\"/>"+
									"				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"\" column=\"PieceNum\" orderkey=\"t1.PieceNum\"/>"+
									"				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(454,user.getLanguage())+"\" column=\"memo\" orderkey=\"t1.memo\"/>"+
									"			</head>"+
									"</table>";
							%>
							<wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
						</td>
					</tr>
				</TABLE>
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
</BODY>
</HTML>
