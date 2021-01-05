
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.sql.Timestamp" %>	
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>	
<!-- Added by wcd 2014-12-01 [人员生日] -->
<%@ include file="/hrm/header.jsp" %>
 <%
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(22483,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean canhrmmaint = HrmUserVarify.checkUserRight("HRM:BirthdayReminder", user);
	if(!canhrmmaint){
	   response.sendRedirect("/notice/noright.jsp");
	   return ;
	}
	Timestamp timestamp = new Timestamp(new Date().getTime());
	String currentMonth = (timestamp.toString()).substring(5, 7);
	String sParam = Tools.vString(request.getParameter("sParam"));
	String bMonth = Tools.vString(request.getParameter("bMonth"),currentMonth);
	String bDate = Tools.vString(request.getParameter("bDate"));
	String lastname = Tools.vString(request.getParameter("lastname"));
	String deptid = Tools.vString(request.getParameter("deptid"));
	String subcompanyid = Tools.vString(request.getParameter("subcompanyid"));
	String searchoper = Util.null2String(request.getParameter("search"));
	
	String satrdate = Util.null2String(request.getParameter("satrdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type='text/javascript'>
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function resetValue(){
				resetCondtion();
				var _obj = jQuery("#advancedSearchDiv").find("select");
				for(var i=0;i<_obj.length;i++){
					changeSelectValue(_obj[i].name,"0");
				}
			}
		</script>
	</head>
	<body>
		<SCRIPT LANGUAGE="JavaScript">
		<!-- Hide
		function killErrors() {
			return true;
		}
		window.onerror = killErrors;
		// -->
		</SCRIPT>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>	
		<form action="" name="searchfrm" id="searchfrm">
			<input type="hidden" name="search" value="search">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="text" class="searchInput" name="sParam" value="<%=sParam %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(1964,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select name="bMonth" id="bMonth" style="width:30px">
									<option value="">&nbsp;</option>
									<%
										String tempMonth = "";
										for(int i=1;i<=12;i++){
											tempMonth = i<10?("0"+i):String.valueOf(i);
											out.println("<option value=\""+tempMonth+"\" "+(bMonth.equals(tempMonth) ? "selected" : "")+">"+tempMonth+"&nbsp;</option>");
										}
									%>
								</select>
								<select name="bDate" id="bDate" style="width:30px">
									<option value="">&nbsp;</option>
									<%
										String tempDate = "";
										for(int i=1;i<=30;i++){
											tempDate = i<10?("0"+i):String.valueOf(i);
											out.println("<option value=\""+tempDate+"\" "+(bDate.equals(tempDate) ? "selected" : "")+">"+tempDate+"&nbsp;</option>");
										}
									%>
								</select>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="lastname" name="lastname" class="inputStyle" value='<%=lastname%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="deptid" browserValue='<%=deptid%>' browserOnClick=""
								browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?excludeid=&selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(deptid)%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?excludeid="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%>'>
							</brow:browser>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetValue();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String substrFun = rs.getDBType().equals("oracle") ? "substr" : "substring";
			String backfields = "id,lastname,"+substrFun+"(birthday,6,5) as birthday,mobile,departmentid,subcompanyid1,telephone,email";
			String fromSql  = " HrmResource ";
			String sqlWhere = " (status between 0  and 3) ";
			String orderby = " birthday asc " ;

			if("search".equals(searchoper)){
				if(sParam.length()>0){
					sqlWhere += " and lastname like '%"+sParam+"%'";
				}
				if(!"".equals(lastname)){
					sqlWhere += " and lastname like '%"+lastname+"%'";
				}
				if(!"".equals(subcompanyid)){
					sqlWhere += " and subcompanyid1 in ("+subcompanyid+")";
				}
				if(!"".equals(deptid)){
					sqlWhere += " and departmentid in ("+deptid+")";
				}
				if(!"".equals(bMonth) && !"".equals(bDate)){
					sqlWhere +=  " and "+substrFun+"(birthday,6,5) = '"+(bMonth+"-"+bDate)+"'"; 
				} else if(!"".equals(bMonth)){
					sqlWhere += " and "+substrFun+"(birthday,6,2) = '"+bMonth+"'";  
				} else if(!"".equals(bDate)){
					sqlWhere += " and "+substrFun+"(birthday,9,2) = '"+bDate+"'";  
				}
			}else{
				sqlWhere += " and "+substrFun+"(birthday,6,2) = '"+currentMonth+"'";
			}
			sqlWhere += rs.getDBType().equals("oracle") ? " and birthday is not null " : " and birthday <> ''";
			String tableString =
			" <table pageId=\""+Constants.HRM_Q_040+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_040,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
			" 	<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
			"	<head>"+
			"		<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" orderkey=\"lastname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" />"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp\" linkkey=\"id\" linkvaluecolumn=\"departmentid\" target=\"_fullwindow\"/>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp\" linkkey=\"id\" linkvaluecolumn=\"subcompanyid1\" target=\"_fullwindow\"/>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage())+"\" column=\"telephone\" orderkey=\"telephone\"/>"+
			"		<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(620,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMobileShow\" otherpara=\""+user.getUID()+"\" />"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(20869,user.getLanguage())+"\" column=\"email\" orderkey=\"email\"/>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1964,user.getLanguage())+"\" column=\"birthday\" orderkey=\"birthday\" transmethod=\"weaver.splitepage.transform.SptmForContacterInfo.getCustomerBirthday\" otherpara=\""+user.getLanguage()+"\"/>"+
			"	</head>"+
			" </table>";
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%= Constants.HRM_Q_040 %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</body>
</html>
