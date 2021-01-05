
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2014-09-05 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CheckComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<%
	String checkid = Util.null2String(request.getParameter("checkid")) ;
	String resource = String.valueOf(user.getUID());
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(16065,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	ArrayList checkitemids = new ArrayList() ;
	String sql = "select checkitemid from HrmCheckKindItem where checktypeid in (select checktypeid from HrmCheckList where id = "+checkid+")" ;
	rs.executeSql(sql) ;
	while(rs.next()) {
		checkitemids.add(Util.null2String(rs.getString("checkitemid"))) ;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			StringBuilder datas = new StringBuilder();
			sql = "select a.checkercount ,b.checkitemid,b.result " +
			   "from HrmByCheckPeople a , HrmCheckGrade b " +
			   "where a.id = b.checkpeopleid and a.checkid="+checkid + " and a.resourceid="+resource ;
			rs.executeSql(sql);
			while(rs.next()){
				String checkercount = Util.null2String(rs.getString(1));
				String checkitemid = Util.null2String(rs.getString(2));
				String result = Util.null2String(rs.getString(3));
				datas.append(checkercount+"_"+checkitemid+":"+result+";");
			}
	
			String backFields = "a.checkercount,b.lastname,a.result,a.proportion"; 
			String sqlFrom  = "from HrmByCheckPeople a left join HrmResource b on a.checkercount = b.id ";
			String sqlWhere = "where a.checkid = "+checkid+" and a.resourceid = "+resource;
			String orderby = "a.proportion" ;
			
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_044+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_044,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.checkercount\" sqlorderby=\""+orderby+"\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					"<head>"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15662,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"checkercount\" linkkey=\"id\" href=\"/hrm/hrmTab.jsp?_fromURL=HrmResource\" target=\"_blank\" />";
			for(int i=0;i<checkitemids.size();i++){
				String checkitemid = (String)checkitemids.get(i);
				tableString+="<col width=\"10%\" text=\""+Util.toScreen(CheckComInfo.getCheckName(checkitemid),user.getLanguage())+"\" column=\"checkercount\" orderkey=\"checkercount\" transmethod=\"weaver.hrm.HrmTransMethod.getCheckResourcesInfoResult\" otherpara=\""+(checkitemid+",,,"+datas.toString())+"\" />";
			}
			tableString+="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" />"+
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(6071,user.getLanguage())+"\" column=\"proportion\" orderkey=\"proportion\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"%\" />"+
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
