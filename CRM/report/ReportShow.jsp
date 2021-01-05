
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>	
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCL" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />

<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
	<%
		String reportId = Util.null2String(request.getParameter("reportId"));
		String types="";  //“类型”Sql的初始化
		String CustomerTypes[]=request.getParameterValues("CustomerTypes");//Types是一个数组
		CRMSearchComInfo.resetSearchInfo();//对CRMSearchComInfo.set~()初始化
		if(CustomerTypes != null)
		{
			for(int i=0;i<CustomerTypes.length;i++)
			{
				CRMSearchComInfo.addCustomerType(CustomerTypes[i]);//把“类型”值传入到CRMSearchComInfo
				if(!types.equals("")){
					types=types+","+CustomerTypes[i];
				}else{
					types+=CustomerTypes[i];
				}
			}
		}
		String sector=Util.null2String(request.getParameter("CustomerSector"));
		String desc=Util.null2String(request.getParameter("CustomerDesc"));
		String status=Util.null2String(request.getParameter("CustomerStatus"));
		String size=Util.null2String(request.getParameter("CustomerSize"));
		//把值传入到CRMSearchComInfo
		CRMSearchComInfo.setCustomerSector(sector);
		CRMSearchComInfo.setCustomerDesc(desc);
		CRMSearchComInfo.setCustomerStatus(status);
		CRMSearchComInfo.setCustomerSize(size);
		
		String sqlwhere = " and m1.city <>0 ";

		int ishead = 0;//ishead = 0表示前无条件，ishead = 1表前已有条件
		if(!sector.equals("")){
			sqlwhere += " and m1.sector = "+ sector + " ";
		}
		if(!desc.equals("")){
			sqlwhere += " and m1.description = "+ desc + " ";
		}
		if(!status.equals("")){
			sqlwhere += " and m1.status = "+ status + " ";
		}
		if(!size.equals("")){
			sqlwhere += " and m1.size_n = "+ size + " ";
		}
		if(!types.equals("")){
			sqlwhere += " and m1.type in ("+ types + ") ";
		}

		request.getSession().setAttribute("SQLWhere",sqlwhere);
		
		
		//今天
		String today = TimeUtil.getCurrentDateString();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy");
		SimpleDateFormat sdf3 = new SimpleDateFormat("MM");
		Calendar calendar=Calendar.getInstance();
		calendar.setFirstDayOfWeek(Calendar.MONDAY); //以周1为首日
		calendar.setTimeInMillis(System.currentTimeMillis());//当前时间
		
		//本周
		calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		String weekDateFrom = sdf.format(calendar.getTime());
		calendar.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		String weekDateTo = sdf.format(calendar.getTime());
		//本月
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
		String monthDateFrom = sdf.format(calendar.getTime());
	    calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
	    String monthDateTo = sdf.format(calendar.getTime());
		//本季度
		String year = sdf2.format(new Date());
		int month = Integer.parseInt(sdf3.format(new Date()));
		String quarterDateFrom = "";
		String quarterDateTo = "";
		if(month>=1 && month <=3){
			quarterDateFrom = year + "-01-01";
			quarterDateTo = year + "-03-31";
		}else if(month>=4 && month <=6){
			quarterDateFrom = year + "-04-01";
			quarterDateTo = year + "-06-30";
		}else if(month>=7 && month <=9){
			quarterDateFrom = year + "-07-01";
			quarterDateTo = year + "-09-30";
		}else{
			quarterDateFrom = year + "-10-01";
			quarterDateTo = year + "-12-31";
		}
		//本年度
		String yearDateFrom = year + "-01-01";
		String yearDateTo = year + "-12-31";
		
		Map provs = (Map)request.getSession().getAttribute("MR_PROVS");
		Map citys = (Map)request.getSession().getAttribute("MR_CITYS");
		if(provs==null){
			provs = new LinkedHashMap();
			rs.executeSql("select provincename,id from HrmProvince where countryid=1 and id<>35");
			while(rs.next()){
				provs.put(rs.getString(1),rs.getString(2));
			}
		}
		if(citys==null){
			citys = new LinkedHashMap();
			rs.executeSql("select cityname,id from HrmCity where countryid=1");
			while(rs.next()){
				citys.put(rs.getString(1),rs.getString(2));
			}
		}
		
		request.getSession().setAttribute("MR_PROVS",provs);
		request.getSession().setAttribute("MR_CITYS",citys);
		
		
		String name = "";
		String unit = "";
		String ds = "";
		String sqlstr1 = "";
		String sqlstr2 = "";
		int parmtype = 1;
		String detailurl = "";
		String provparm = "";
		String cityparm = "";
		String datefromparm = "";
		String datetoparm = "";
		rs.executeSql("select name,datasource,unit,sqlstr1,sqlstr2,detailurl,parmtype,provparm,cityparm,datefromparm,datetoparm from CRM_MapReport where id = "+reportId);
		if(rs.next()){
			name = Util.null2String(rs.getString("name"));
			ds = Util.null2String(rs.getString("datasource"));
			unit = Util.null2String(rs.getString("unit"));
			sqlstr1 = Util.null2String(rs.getString("sqlstr1"));
			sqlstr2 = Util.null2String(rs.getString("sqlstr2"));
			
			parmtype = Util.getIntValue(rs.getString("parmtype"),1);
			detailurl = Util.null2String(rs.getString("detailurl"));
			provparm = Util.null2String(rs.getString("provparm"));
			cityparm = Util.null2String(rs.getString("cityparm"));
			datefromparm = Util.null2String(rs.getString("datefromparm"));
			datetoparm = Util.null2String(rs.getString("datetoparm"));
		}
		
		request.getSession().setAttribute("MR_NAME_"+reportId,name);
		request.getSession().setAttribute("MR_DATASOURCE_"+reportId,ds);
		request.getSession().setAttribute("MR_UNIT_"+reportId,unit);
		request.getSession().setAttribute("MR_SQLSTR1_"+reportId,sqlstr1);
		request.getSession().setAttribute("MR_SQLSTR2_"+reportId,sqlstr2);
		request.getSession().setAttribute("MR_PARMTYPE_"+reportId,parmtype);
		request.getSession().setAttribute("MR_DETAILURL_"+reportId,detailurl);
		request.getSession().setAttribute("MR_PROVPARM_"+reportId,provparm);
		request.getSession().setAttribute("MR_CITYPARM_"+reportId,cityparm);
		request.getSession().setAttribute("MR_DATEFROMPARM_"+reportId,datefromparm);
		request.getSession().setAttribute("MR_DATETOPARM_"+reportId,datetoparm);
		String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage());
		String needfav ="1";
		String needhelp ="";
	%>
	<head>
		<title><%=name %></title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
    	<style type="text/css">
    		html,body{overflow: hidden;margin: 0px;}
    		*,body{font-size: 12px !important;font-family: 微软雅黑;}
    		.btn_date{line-height: 18px;text-align: center;padding-left: 8px;padding-right: 8px;color: #38A6E1;float: left;margin-top: 5px;cursor: pointer;font-size: 12px;}
    		.btn_date_select{background: url('../images/tabclick_wev8.png') repeat-x;color: #fff;}
    		
    		.Calendar {BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(../images/calendar_wev8.png); OVERFLOW: hidden; BORDER-LEFT: medium none; 
    		WIDTH: 16px; CURSOR: pointer; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 16px; BACKGROUND-COLOR: transparent;float: left;
    		margin-top: 6px;margin-right: 2px;}
    	</style>
	</head>
	<body>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
	</wea:layout>

	<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
	<form name=frmmain id=weaver method=post action="/CRM/report/ReportShow.jsp?reportId=1">
	<wea:layout type="4Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item attributes="{'colspan':'3'}">
				<%//显示所有类型的及相关值
					RecordSetCT.executeProc("CRM_CustomerType_SelectAll","");
					int nCount = 0;
					while(RecordSetCT.next()){
						nCount++;
						if(CRMSearchComInfo.isCustomerTypeSel(nCount)){%>			
								<INPUT name="CustomerTypes" type="checkbox" value="<%=nCount%>" checked>
									<%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
						<%}else{%>			
								<INPUT name="CustomerTypes" type="checkbox" value="<%=nCount%>">
									<%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
						<%}
				}%>			
		  </wea:item>
          
    	  <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
    	  <wea:item>
    	  	<brow:browser viewType="0" name="CustomerStatus" 
			     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
			     browserValue='<%=CRMSearchComInfo.getCustomerStatus()+""%>' 
			     browserSpanValue = '<%=CustomerStatusComInfo.getCustomerStatusname(CRMSearchComInfo.getCustomerStatus())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			     completeUrl="/data.jsp?type=customerStatus" width="150px" ></brow:browser>
    	  </wea:item> 
		
    	  <wea:item><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></wea:item>
    	      
    	  <wea:item>
   	  	 	<brow:browser viewType="0" name="CustomerSize" 
			     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp"
			     browserValue='<%=CRMSearchComInfo.getCustomerSize()+""%>' 
			     browserSpanValue = '<%=CustomerSizeComInfo.getCustomerSizedesc(CRMSearchComInfo.getCustomerSize())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			     completeUrl="/data.jsp?type=customerSize" width="150px" ></brow:browser>
    	   </wea:item>
          
    	  <wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
    	  <wea:item>
    	  	<brow:browser viewType="0" name="CustomerSector" 
			     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
			     browserValue='<%=CRMSearchComInfo.getCustomerSector()+""%>' 
			     browserSpanValue = '<%=SectorInfoComInfo.getSectorInfoname(CRMSearchComInfo.getCustomerSector())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			     completeUrl="/data.jsp?type=sector" width="150px" ></brow:browser>
   	  	 </wea:item>
          
 	     <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
         <wea:item>
     	 	<brow:browser viewType="0" name="CustomerDesc" 
			     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
			     browserValue='<%=CRMSearchComInfo.getCustomerDesc()+""%>' 
			     browserSpanValue = '<%=CustomerDescComInfo.getCustomerDescname(CRMSearchComInfo.getCustomerDesc())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			     completeUrl="/data.jsp?type=customerDesc" width="150px" ></brow:browser>
         </wea:item>
	 </wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>
		<table style="width: 100%;height:100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div id="main" style="width: 99%;z-index: 9999;">
						<div id="divmap" style="width: 100%;height:100%">
							<iframe id="frmmap" src="" scrolling="no" frameborder="0" style="width: 100%;height: 100%;"></iframe>
							<!-- loading -->
							<div id="loading" style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp_wev8.png) repeat;display: none;'>
								<div style='width:100%;height:100%;background:url(../images/loading_wev8.gif) center no-repeat'></div>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</table>
		
		<script type="text/javascript">
			$(document).ready(function(){
				jQuery("#topTitle").topMenuTitle({searchFn:null});
				jQuery("#hoverBtnSpan").hoverBtn();
  			});
		
			var showtype = 2;//标记显示类型
			var area = "全部";//记录选择的大区
		
			$(document).ready(function(){
				doReload();

				$("#frmmap").load(function(){
					$("#loading").hide();
				});
				
				setFrameHeight();
		//		$(".btn_date_select").click();
				//doReload();
			});

			$(window).resize(function(){
				setFrameHeight();
			});
			function setFrameHeight(){
				$("#frmmap").height($(window).height());
				$("#loading").height($(window).height());
				//$("#frmmap").width($("#main").width()-2);
			}
			function setTitle(name){
				$("#title").html(name);
			}
			function showDateCon(){
			//	$("#datecon").show();
			}
			function doReload(){
				$("#loading").show();
				$("#frmmap").attr("src","ReportShowMap.jsp?reportId=<%=reportId %>&datefrom="+"&dateto="+
						+"&showtype="+showtype+"&area="+area+"&random="+Math.floor(Math.random()*100000));
			}
			function getMyDate(inputname,spanname){
			    WdatePicker({el:spanname,onpicked:function(dp){
					var returnvalue = dp.cal.getDateStr();
					$dp.$(inputname).value = returnvalue;
					$(".btn_date").removeClass("btn_date_select");
					doReload();
					},
					oncleared:function(dp){$dp.$(inputname).value = '';$(".btn_date").removeClass("btn_date_select");doReload();}});
		}
	    </script>
    </body>
</html>
