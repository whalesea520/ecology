
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="HrmRpContractTimeManager" class="weaver.hrm.report.manager.HrmRpContractTimeManager" scope="page"/>
<%
	String year = Util.null2String(request.getParameter("year"));
	if(year.equals("")){
		Calendar todaycal = Calendar.getInstance ();
		year = Util.add0(todaycal.get(Calendar.YEAR), 4);
	}
	String type = Util.null2String(request.getParameter("type"));
	String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
	String from = Util.null2String(request.getParameter("from"));

	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15943,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sqlwhereyear = "";
	if(!subcompanyid1.equals("") && from.equals("")){
		sqlwhereyear+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
	if(from.equals("time")){
		subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhereyear+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
	
	String sql = "";
	List<Integer> lsData = new ArrayList<Integer>();
	for(int month = 1;month<13;month++){
		String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
		String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
		sql = "select count(t1.id) from HrmContract t1,HrmResource t2 where 3 = 3 ";
		sql += " and (t1.contractstartdate >='"+firstday +"' and t1.contractstartdate <= '"+lastday+"')";
		if(type.length() > 0){
			sql += " and t1.contracttypeid="+type;	   
		}
		sql += sqlwhereyear;		     
	  
		rs.executeSql(sql);
		rs.next();
		lsData.add( rs.getInt(1));
	}
	String items = "";  
	for(int data : lsData){
		if(items.length()>0)items+=",";
			items +=data;
	}
	items = "["+items+"]";
	
	/*Map otherparams = new HashMap();
	otherparams.put("year",year);
	otherparams.put("from",from);
	otherparams.put("type",type);
	otherparams.put("subcompanyid1",subcompanyid1);
	List list = HrmRpContractTimeManager.getResult(user,otherparams,request,response);
	items = JSONArray.fromObject(list).toString();*/
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script> 
		<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmReport_wev8.js"></script>
		<script language=javascript>  
			var dialog = parent.parent.getDialog(parent);
			
			function submitData() {
				jQuery("#frmmain").submit();
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmRpContractTime.jsp" >
			<input type="hidden" name="isself" value="1">
			<input type="hidden" name="from" value ="<%=from%>">
			<input type="hidden" name="isdialog" value ="<%=isDialog%>">
			<input type="hidden" name="subcompanyid1" value ="<%=subcompanyid1%>">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<INPUT class=inputStyle maxLength=4 size=4 name="year" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select name=type value="<%=type%>">
								<option value=""></option>
								<%
									rs.executeSql("select id,typename from HrmContractType");
									Hashtable ht  = new Hashtable();  
									while(rs.next()){  
										ht.put(new Integer(rs.getInt("id")),rs.getString("typename"));
								%>
										<option value="<%=rs.getString("id")%>" <%if(rs.getString("id").equals(type)){%>selected <%}%>><%=rs.getString("typename")%></option>
								<%  
									}
								%> 
							</select>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="contentDiv" style="<%=isself.equals("1") ? "" : "display:none"%>">
			<wea:layout type="diycol">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<%
							String tableString =" <table datasource=\"weaver.hrm.report.manager.HrmRpContractTimeManager.getResult\" sourceparams=\"year:"+year+"+subcompanyid1:"+subcompanyid1+"+from:"+from+"+type:"+type+"\" pageId=\""+Constants.HRM_Q_030+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_030,user.getUID(),Constants.HRM)+"\" needPage=\"false\" tabletype=\"none\">"+
								" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
								"	<head>"+
								"		<col width=\"16%\" text=\""+SystemEnv.getHtmlLabelName(716,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1492,user.getLanguage())+"\" column=\"result1\" orderkey=\"result1\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1493,user.getLanguage())+"\" column=\"result2\" orderkey=\"result2\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1494,user.getLanguage())+"\" column=\"result3\" orderkey=\"result3\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1495,user.getLanguage())+"\" column=\"result4\" orderkey=\"result4\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1496,user.getLanguage())+"\" column=\"result5\" orderkey=\"result5\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1497,user.getLanguage())+"\" column=\"result6\" orderkey=\"result6\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1498,user.getLanguage())+"\" column=\"result7\" orderkey=\"result7\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1499,user.getLanguage())+"\" column=\"result8\" orderkey=\"result8\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1800,user.getLanguage())+"\" column=\"result9\" orderkey=\"result9\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1801,user.getLanguage())+"\" column=\"result10\" orderkey=\"result10\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1802,user.getLanguage())+"\" column=\"result11\" orderkey=\"result11\" />"+
								"		<col width=\"7%\" text=\""+SystemEnv.getHtmlLabelName(1803,user.getLanguage())+"\" column=\"result12\" orderkey=\"result12\" />"+
								"	</head></table>";
						%>
						<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
					</wea:item>
				</wea:group>
			</wea:layout>
			<TABLE class=ViewForm>
				<TBODY> 
				<TR> 
					<TD align=center colspan =2>
						<div id="barContainer" style="min-width:390px;height:350px"></div>
					</TD>
					<TD align=center colspan =2>
						<div id="lineContainer" style="min-width:390px;height:350px"></div>
					</TD>
				</TR>    
				</TBODY> 
			</TABLE>
			</div>
		</form>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	<script language=javascript>  
		function initBarChart(title,items){
			$('#barContainer').highcharts({
				chart: {
					type: 'column'
				},
				title: {
					text: title
				},
				xAxis: {
					categories: ['1<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','2<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','3<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','4<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','5<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','6<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','7<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','8<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','9<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','10<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','11<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','12<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>']
				},
				yAxis: {
					min: 0,
					allowDecimals:false,
					title: {
						text: ''
					}
				},
				tooltip: {
						valueSuffix: ''
				},
				plotOptions: {
					column: {
						pointPadding: 0.2,
						borderWidth: 0
					}
				},
				credits: {
					  enabled: false
				},
				legend:{
					enabled: false
				},
				series: [{
					name: '<%=SystemEnv.getHtmlLabelName(83542,user.getLanguage())%>',
					data: items

				}]
			});
		}
		function initLineChart(title,items){
			jQuery('#lineContainer').highcharts({
				title: {
					text: title,
					x: -20 //center
				},
				xAxis: {
				   categories: ['1<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','2<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','3<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','4<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','5<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','6<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','7<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','8<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','9<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','10<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','11<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>','12<%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%>']
				},
				yAxis: {
					min: 0,
					allowDecimals:false,
					title: {
						text: ''
					},
					plotLines: [{
						value: 0,
						width: 1,
						color: '#808080'
					}]
				},
				tooltip: {
					valueSuffix: ''
				},
				legend: {
					layout: 'vertical',
					align: 'right',
					verticalAlign: 'middle',
					borderWidth: 0
				},
				credits: {
					  enabled: false
				},
				legend:{
					enabled: false
				},
				series: [{
					name: '<%=SystemEnv.getHtmlLabelName(83542,user.getLanguage())%>',
					//colorByPoint: true,
					data: items
				}]
			});
		}
		var resultStr = '<%=items%>';
		var resultData = eval('('+resultStr+')');
		jQuery(document).ready(function(){
			initBarChart('',resultData);
			initLineChart('',resultData);
		});
	</script>
	</body>
</HTML>
