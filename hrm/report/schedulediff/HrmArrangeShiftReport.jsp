
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-07-16 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16674,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门

String isself = Util.null2String(request.getParameter("isself"));
isself = "1";

Calendar thedate = Calendar.getInstance();

// 如果用户选择的开始日期或者结束日期为空，则默认为当天前7天和后7天的时间 
if( fromdate.equals("") || enddate.equals("")) {
    thedate.add(Calendar.DATE , 0) ; 
    fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
               Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
               Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    thedate.add(Calendar.DATE , 7) ; 
    enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
              Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
              Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
} 

// 将开始日期到结束日期的每一天及其对应的星期放入缓存
ArrayList selectdates = new ArrayList() ; 
ArrayList selectweekdays = new ArrayList() ; 

String resourceSql = "";
String backfields = " a.id,a.resourceid,a.shiftdate,a.shiftid,b.lastname,b.departmentid,c.shiftname,b.seclevel "; 
String fromSql  = " HrmArrangeShiftInfo a left join Hrmresource b on a.resourceid = b.id left join HrmArrangeShift c on a.shiftid = c.id ";
String sqlWhere = "";
String jsonStr = "";
if(isself.equals("1")) {
    // 将开始日期到结束日期的每一天及其对应的星期放入缓存
    int fromyear = Util.getIntValue(fromdate.substring(0 , 4)) ; 
    int frommonth = Util.getIntValue(fromdate.substring(5 , 7)) ; 
    int fromday = Util.getIntValue(fromdate.substring(8 , 10)) ; 
    String tempdate = fromdate ; 

    thedate.set(fromyear,frommonth - 1 , fromday) ; 

    while( tempdate.compareTo(enddate) <= 0 ) {
        selectdates.add(tempdate) ; 
        selectweekdays.add("" + thedate.get(Calendar.DAY_OF_WEEK)) ; 

        thedate.add(Calendar.DATE , 1) ; 
        tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    }

	resourceSql = "select a.id from hrmresource a, (select min(level_from) as minLevel,max(level_to) as maxLevel from HrmArrangeShiftSet where sharetype = 2 ";
    String relatedSql = "";
	String departmentSql = "";
	if(!department.equals("")) {
		relatedSql = " and relatedId = "+department;
        departmentSql = " and departmentid = " + department ; 
    } 
	resourceSql += relatedSql+" group by sharetype) b where seclevel between b.minLevel and b.maxLevel "+departmentSql;
	sqlWhere += " where b.id in ("+resourceSql+") ";
	StringBuilder sql = new StringBuilder()
	.append(" select ").append(backfields)
	.append(" from ").append(fromSql)
	.append(sqlWhere).append(" and shiftdate  between '"+fromdate+"' and '"+enddate+"' ")
	.append(" order by b.seclevel asc,a.id asc,a.shiftdate asc");
    rs.executeSql(sql.toString()); 
	StringBuilder sqlResult = new StringBuilder();
	sqlResult.append("{json:[");
    while( rs.next() ) { 
		sqlResult.append("{resourceid:'").append(Util.null2String(rs.getString("resourceid"))).append("',")
		.append("shiftdate:'").append(Util.null2String(rs.getString("shiftdate"))).append("',")
		.append("shiftname:'").append(Util.null2String(rs.getString("shiftname"))).append("'},");
    }
	jsonStr = sqlResult.toString();
	if(jsonStr.endsWith(",")){
		jsonStr = jsonStr.substring(0,jsonStr.length()-1);
	}
	jsonStr += "]}";
}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language=javascript>  
			function submitData() {
				jQuery("#frmmain").submit();
			}
			function exportExcel(){
				document.getElementById("excels").src = "HrmArrangeShiftReportExcel.jsp?fromdate=<%=fromdate%>&enddate=<%=enddate%>&department=<%=department%>";
			}
		</script>
	</head>
	<BODY>
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="exportExcel();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmArrangeShiftReport.jsp" >
			<input type="hidden" name="operation" value=save>
			<input type="hidden" name="isself" value="1">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="department" browserValue='<%=department%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
							<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
							<input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate%>">
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="contentDiv" style="<%=isself.equals("1") ? "" : "display:none"%>">
			<wea:layout type="diycol">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<%
							backfields = "a.resourceid,b.lastname,b.seclevel";
							fromSql  = " (select a.resourceid from HrmArrangeShiftInfo a left join Hrmresource b on a.resourceid = b.id "+sqlWhere+" group by a.resourceid ) a left join HrmResource b on a.resourceid = b.id";
							sqlWhere = "";
							String orderby = "b.seclevel";
							String tableString =" <table pageId=\""+Constants.HRM_Q_003+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_003,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
								" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.resourceid\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
							"	<head>"+
							"<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" />";
							for(int i = 0 ; i < selectdates.size() ; i++ ) {
								String selectDate = String.valueOf(selectdates.get(i));
								String showDate = Tools.formatDate(selectDate,"M"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+"d"+SystemEnv.getHtmlLabelName(390,user.getLanguage()))+"(";
								showDate += new weaver.hrm.common.SplitPageTagFormat().colFormat(String.valueOf(selectweekdays.get(i)),"{cmd:array["+user.getLanguage()+";1=16106,2=16100,3=16101,4=16102,5=16103,6=16104,7=16105]}");
								showDate+=")";
								tableString+="<col width=\""+(93/selectdates.size())+"%\" text=\""+showDate+"\" column=\"resourceid\" orderkey=\"lastname\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:json[shiftname;resourceid=+column:resourceid+and+shiftdate="+selectDate+";"+jsonStr+"]}\" />";
							}
							tableString+="</head></table>";
						%>
						<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
					</wea:item>
				</wea:group>
			</wea:layout>
			</div>
		</form>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
	</body>
</HTML>
