<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.conn.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.common.xtable.*" %>		
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CustomerTransUtil" class="weaver.crm.report.CustomerTransUtil" scope="page"/>
<jsp:useBean id="CommonTransUtil" class="weaver.cs.util.CommonTransUtil" scope="page"/>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>
		<script language=javascript src="/js/checkData_wev8.js"></script>
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
		<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
		<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base_wev8.js'></script>
		<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>   
		<%if(user.getLanguage()==7) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
		<%} else if(user.getLanguage()==8) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
		<%}%>
		<script type="text/javascript" src="/js/WeaverTableExt_wev8.js"></script>  
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
	</head>
	<%
		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(26180, user.getLanguage())+SystemEnv.getHtmlLabelName(622, user.getLanguage());
		String needfav = "1";
		String needhelp = "";

		String customerProvince = Util.fromScreen3(request.getParameter("customerProvince"), user.getLanguage());
		String customerCity = Util.fromScreen3(request.getParameter("customerCity"), user.getLanguage());
		String fromdate = Util.fromScreen3(request.getParameter("fromdate"), user.getLanguage());
		String enddate = Util.fromScreen3(request.getParameter("enddate"), user.getLanguage());
		String accountManager = Util.fromScreen3(request.getParameter("accountManager"), user.getLanguage());
		String isFeedback = Util.fromScreen3(request.getParameter("isFeedback"), user.getLanguage());
		String isvalid = Util.fromScreen3(request.getParameter("isvalid"), user.getLanguage());
		
		String condition = CommonTransUtil.getCustomerStr(user);
		
		String sqlWhere = " where t1.source = 20 and (t1.deleted=0 or t1.deleted is null) ";
		if(!customerProvince.equals("")){
			sqlWhere += " and t1.province = "+customerProvince;
		}
		if(!customerCity.equals("")){
			sqlWhere += " and t1.city = "+customerCity;
		}
		if(!fromdate.equals("")){
			sqlWhere += " and t1.createdate >= '"+fromdate+"'";
		}
		if(!enddate.equals("")){
			sqlWhere += " and t1.createdate <= '"+enddate+"'";
		}
		ArrayList cmIdList = new ArrayList();
		cmIdList = Util.TokenizerString(accountManager, ",");
		if(cmIdList.size()>0){
			sqlWhere += " and ( ";
			for (int i = 0; i < cmIdList.size(); i++) {
				if(i == 0){
					sqlWhere += " t1.manager =" + cmIdList.get(i);
				}else{
					sqlWhere += " or t1.manager = " + cmIdList.get(i);
				}
			}
			sqlWhere +=") ";
		}
		if(isFeedback.equals("1")){//已反馈
			sqlWhere += " and exists (select t3.customerId from CRM_CustomerFeedback t3 where t3.customerId=t1.id and ";
			if(isvalid.equals("1")){
				sqlWhere += "t3.isValid=1";
			}else if(isvalid.equals("0")){
				sqlWhere += "t3.isValid=0";
			}else{
				sqlWhere += "(t3.isValid=1 or t3.isValid=0)";
			}
			sqlWhere += ")";
		}
		if(isFeedback.equals("0")){//未反馈
			sqlWhere += " and not exists (select t3.customerId from CRM_CustomerFeedback t3 where t3.customerId=t1.id and (t3.isValid=1 or t3.isValid=0))";
		}
	%>
	<BODY  style="overflow: hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:document.frmMain.submit();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{" + "Excel,javascript:exportExcel(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmMain" action="CustomerFeedbackReport.jsp" method="post">
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0" valign="top">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<TABLE class=ViewForm id=searchTable>
									<COLGROUP>
										<COL width="13%">
										<COL width="20%">
										<COL width="14%">
										<COL width="20%">
										<COL width="13%">
										<COL width="20%">
									</COLGROUP>
									<TBODY>
										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD><!-- 省份 -->
								        	<TD class=Field>
								            	<BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON>
								                <SPAN id=provinceidspan><%=ProvinceComInfo.getProvincename(customerProvince)%>
											    </SPAN>
								                <INPUT id=CustomerProvince type=hidden name="customerProvince" value="<%=customerProvince%>">
								            </TD>
											<TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD><!-- 城市 -->
									        <TD class=Field>
										    	<BUTTON class=Browser id=SelectCityID onclick="onShowCityID()"></BUTTON>
									            <SPAN id=cityidspan STYLE="width=30%"><%=CityComInfo.getCityname(customerCity)%></SPAN>
									            <INPUT id=CityCode type=hidden name="customerCity" value="<%=customerCity%>">
											</TD>
											<TD ><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD><!-- 时间 -->
									          <TD class=Field>
												  <BUTTON class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
												  <SPAN id=fromdatespan ><%=fromdate%></SPAN>
												  <input type="hidden" name="fromdate" value=<%=fromdate%>>
												      －
												  <BUTTON class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
												  <SPAN id=enddatespan ><%=enddate%></SPAN>
												  <input type="hidden" name="enddate" value=<%=enddate%>>
											  </TD>
										</TR>
										<tr>
											<td class=Line colspan=4></td>
										</tr>
										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD><!-- 客户经理-->
										    <TD class=Field>
										    	<BUTTON class=Browser id=SelectManagerID onClick="onShowResource('accountManagerspan','accountManager')"></BUTTON>
										    	<span id=accountManagerspan><%=CustomerTransUtil.getPerson(accountManager)%></span>
										        <INPUT class=InputStyle type=hidden name="accountManager" value="<%=accountManager%>">
										    </TD>
										   <TD><%=SystemEnv.getHtmlLabelName(26184, user.getLanguage())%><!-- 是否已反馈 -->
											</TD>
											<TD class=Field>
												<select class=inputstyle name=isFeedback onchange="onChangeFeedback()">
													<option value="">
													</option>
													<option value="1"  <%if("1".equals(isFeedback)){%> selected="selected" <%} %>>
														<%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%>
													</option>
													<option value="0"  <%if("0".equals(isFeedback)){%> selected="selected" <%} %>>
														<%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%>
													</option>
												</select>
											</TD>
											
											<TD id="isvalidTitle" <%if("".equals(isFeedback)||"0".equals(isFeedback)){ %> style="display:none "<%}%>><%=SystemEnv.getHtmlLabelName(15591, user.getLanguage())%><!-- 是否有效-->
											</TD>
											<TD id="isvalidSelect"  class=Field <%if("".equals(isFeedback)||"0".equals(isFeedback)){ %> style="display:none "<%}%>>
												<select class=inputstyle name=isvalid>
													<option value="">
													</option>
													<option value="1"  <%if("1".equals(isvalid)){%> selected="selected" <%} %>>
														<%=SystemEnv.getHtmlLabelName(2246, user.getLanguage())%>
													</option>
													<option value="0"  <%if("0".equals(isvalid)){%> selected="selected" <%} %>>
														<%=SystemEnv.getHtmlLabelName(2245, user.getLanguage())%>
													</option>
												</select>
											</TD>
										</TR>
										<tr>
											<td class=Line colspan=4></td>
										</tr>
									</TBODY>
								</TABLE>
											<%
												String tableString = "";
												String backfields = " t1.id,t1.name,t1.type,t1.manager,t1.status,t1.createdate,t2.isValid,t2.remark ";
												String fromSql = " CRM_CustomerInfo t1 join "+condition+" on t1.id=customerIds.id left join CRM_CustomerFeedback t2 on t1.id = t2.customerId ";
												String sqlmei = "";
												String orderby = " t1.createdate";
												//System.out.println("select "+backfields+" from "+fromSql+ sqlWhere);
											
												ArrayList xTableColumnList=new ArrayList();
												
												TableColumn xTableColumn_customerName=new TableColumn();
												xTableColumn_customerName.setColumn("id");
												xTableColumn_customerName.setDataIndex("id");
												xTableColumn_customerName.setHeader(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
												xTableColumn_customerName.setTransmethod("weaver.crm.report.CustomerTransUtil.getCustomer");
												xTableColumn_customerName.setPara_1("column:id");
												xTableColumn_customerName.setSortable(true);
												xTableColumn_customerName.setHideable(false);
												xTableColumn_customerName.setWidth(0.02); 
												xTableColumnList.add(xTableColumn_customerName);
												
												TableColumn xTableColumn_cm=new TableColumn();
												xTableColumn_cm.setColumn("manager");
												xTableColumn_cm.setDataIndex("manager");
												xTableColumn_cm.setHeader(SystemEnv.getHtmlLabelName(1278,user.getLanguage()));
												xTableColumn_cm.setTransmethod("weaver.crm.report.CustomerTransUtil.getPerson");
												xTableColumn_cm.setPara_1("column:manager");
												xTableColumn_cm.setSortable(true);
												xTableColumn_cm.setHideable(true);
												xTableColumn_cm.setWidth(0.006); 
												xTableColumnList.add(xTableColumn_cm);
												
												TableColumn xTableColumn_status=new TableColumn();
												xTableColumn_status.setColumn("status");
												xTableColumn_status.setDataIndex("status");
												xTableColumn_status.setHeader(SystemEnv.getHtmlLabelName(1929,user.getLanguage()));
												xTableColumn_status.setTransmethod("weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname");
												xTableColumn_status.setPara_1("column:status");
												xTableColumn_status.setSortable(true);
												xTableColumn_status.setHideable(true);
												xTableColumn_status.setWidth(0.006); 
												xTableColumnList.add(xTableColumn_status);
												
												TableColumn xTableColumn_createdate=new TableColumn();
												xTableColumn_createdate.setColumn("createdate");
												xTableColumn_createdate.setDataIndex("createdate");
												xTableColumn_createdate.setHeader(SystemEnv.getHtmlLabelName(722,user.getLanguage()));
												xTableColumn_createdate.setSortable(true);
												xTableColumn_createdate.setHideable(true);
												xTableColumn_createdate.setWidth(0.008); 
												xTableColumnList.add(xTableColumn_createdate);
												
												TableColumn xTableColumn_isvalid=new TableColumn();
												xTableColumn_isvalid.setColumn("isValid");
												xTableColumn_isvalid.setDataIndex("isValid");
												xTableColumn_isvalid.setHeader(SystemEnv.getHtmlLabelName(15591,user.getLanguage()));
												xTableColumn_isvalid.setTransmethod("weaver.crm.report.CustomerTransUtil.getIsvalid");
												xTableColumn_isvalid.setPara_1("column:isValid");
												xTableColumn_isvalid.setPara_2(user.getLanguage()+"");
												xTableColumn_isvalid.setSortable(true);
												xTableColumn_isvalid.setHideable(true);
												xTableColumn_isvalid.setWidth(0.006); 
												xTableColumnList.add(xTableColumn_isvalid);
												
												TableColumn xTableColumn_remark=new TableColumn();
												xTableColumn_remark.setColumn("remark");
												xTableColumn_remark.setDataIndex("remark");
												xTableColumn_remark.setHeader(SystemEnv.getHtmlLabelName(85,user.getLanguage()));
												xTableColumn_remark.setSortable(false);
												xTableColumn_remark.setHideable(true);
												xTableColumn_remark.setWidth(0.025); 
												xTableColumnList.add(xTableColumn_remark);
												

												TableSql xTableSql=new TableSql();
												xTableSql.setBackfields(backfields);
												xTableSql.setPageSize(20);
												xTableSql.setSqlform(fromSql);
												xTableSql.setSqlwhere(sqlWhere);
												xTableSql.setSqlprimarykey("t1.id");
												xTableSql.setSqlisdistinct("true");
												xTableSql.setDir(TableConst.DESC);

												Table xTable=new Table(request); 
												
												xTable.setTableGridType(TableConst.NONE);
												xTable.setTableNeedRowNumber(true);
												xTable.setTableSql(xTableSql);
												xTable.setTableColumnList(xTableColumnList);
												
												String exportSql = "select " + backfields + " from " + fromSql + sqlWhere + " order by " + orderby + " desc";
												session.setAttribute("crm_feedback_exportsql",exportSql);
											%>
											<%=xTable.toString4()%>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
		</form>
		<iframe id="searchexport" style="display:none"></iframe>
	</BODY>
<script type="text/javascript">
function onRefresh(){
	_table.refresh();
}

document.onkeydown=keyListener;
function keyListener(e){
    e = e ? e : event;   
    if(e.keyCode == 13){    
    	frmMain.submit();    
    }    
}
function onChangeFeedback(){
	var isFeedback = document.all("isFeedback").value;
	if(isFeedback == 1){
		document.all("isvalidTitle").style.display = "";
		document.all("isvalidSelect").style.display = "";
	}else{
		document.all("isvalidTitle").style.display = "none";
		document.all("isvalidSelect").style.display = "none";
		document.all("isvalid").value = "";
	}
}
function exportExcel(){
    searchexport.location="CustomerFeedbackExport.jsp";
}
</script>
<SCRIPT language=VBS>
sub onShowResource(spanname,inputname)
	v = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&document.getElementById(inputname).value)
	if (Not IsEmpty(v)) then
		if (Len(v(0)) > 2000) then '500为表结构文档字段的长度
			result = msgbox("您选择的参与人数量太多，请重新选择！",48,"注意")
		elseif v(0)<> "" then
			sHtml = ""
			resourceids = Mid(v(0),2,len(v(0)))
			resourcename = Mid(v(1),2,len(v(1)))
			document.getElementById(inputname).value= resourceids

			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href='/hrm/resource/HrmResource.jsp?v="&curid&"'>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
			document.getElementById(spanname).innerHtml = sHtml
		else	
    		document.getElementById(spanname).innerHtml = ""
    		document.getElementById(inputname).value=""
		end if
	end if
end sub
sub onShowCityID()
	cityid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(cityid)) then
	if cityid(0)<> 0 then
	cityidspan.innerHtml = cityid(1)
	frmMain.CustomerCity.value=cityid(0)
	else
	cityidspan.innerHtml = ""
	frmMain.CustomerCity.value=""
	end if
	end if
end sub
sub onShowProvinceID()
	probinceid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp")
	if (Not IsEmpty(probinceid)) then
	if probinceid(0)<> 0 then
	provinceidspan.innerHtml = probinceid(1)
	frmMain.CustomerProvince.value=probinceid(0)
	else
	provinceidspan.innerHtml = ""
	frmMain.CustomerProvince.value=""
	end if
	end if
end sub
</script>
</HTML>