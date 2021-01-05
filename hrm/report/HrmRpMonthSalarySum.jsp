
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.teechart.*" %>
<!-- modified by wcd 2014-08-08 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<%
	String userid =""+user.getUID();
	/*权限判断,人力资产管理员以及其所有上级*/
	boolean canView = false;
	ArrayList allCanView = new ArrayList();
	String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
	rs.executeSql(tempsql);
	while(rs.next()){
		String tempid = rs.getString("resourceid");
		allCanView.add(tempid);
		AllManagers.getAll(tempid);
		while(AllManagers.next()){
			allCanView.add(AllManagers.getManagerID());
		}
	}// end while
	for (int i=0;i<allCanView.size();i++){
		if(userid.equals((String)allCanView.get(i))){
			canView = true;
		}
	}
	if(!canView) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	/*权限判断结束*/
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17536,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17537,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";
	
	String currentdate =  Util.null2String(request.getParameter("currentdate"));
	String movedate = Util.null2String(request.getParameter("movedate"));
	Calendar today = Calendar.getInstance();
	if(!currentdate.equals("")) {
		int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
		int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
		int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
		today.set(tempyear,tempmonth,tempdate);
	}
	int currentyear=today.get(Calendar.YEAR);
	int currentmonth=today.get(Calendar.MONTH);  
	int currentday=today.get(Calendar.DATE);  
	currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
	String cBeginDate="";
	String cEndDate="";
	today.set(currentyear,0,1) ;
	if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
	if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
	
	currentyear=today.get(Calendar.YEAR);
	currentmonth=today.get(Calendar.MONTH);  
	currentday=today.get(Calendar.DATE);  
	currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth+1,2)+"-"+Util.add0(currentday,2) ;
	
	cBeginDate = Tools.getFirstDayOfYear(today.getTime());
	cEndDate = Tools.getLastDayOfYear(today.getTime());
	
	currentyear=today.get(Calendar.YEAR);
	currentmonth=today.get(Calendar.MONTH)+1;  
	currentday=today.get(Calendar.DATE);  
	currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
	Calendar temptoday1 = Calendar.getInstance();
	temptoday1.set(currentyear,currentmonth-1,currentday) ;
	String datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

	String year = datenow;
	if(Tools.isNull(year)){
		year = Tools.getYear();
	}
	int cmd = Util.getIntValue(request.getParameter("cmd"),0);
	int tempYear = Util.getIntValue(year,0);
	tempYear += cmd;
	year = String.valueOf(tempYear);
	Date date = Tools.parseToDate(year+"-"+Tools.getMonth()+"-"+Tools.getDate());
	String startdatefrom = Tools.getFirstDayOfYear(date);
	String startdateto = Tools.getLastDayOfYear(date);
	
	DecimalFormat format = new DecimalFormat("0.00");
	
	String sqlwhere = "";
    if(!startdatefrom.equals("")){
		if(startdatefrom.length() >= 7) {
    		startdatefrom = startdatefrom.substring(0, 7);
    	}
        sqlwhere += " and t2.paydate >='" + startdatefrom +"' ";
    }
    if(!startdateto.equals("")){
		if(startdateto.length() >= 7) {
    		startdateto = startdateto.substring(0, 7);
    	}
        if(rs.getDBType().equals("oracle")){
            sqlwhere += " and (t2.paydate is not null and t2.paydate <='" + startdateto +"') ";
        }else{
            sqlwhere += " and (t2.paydate<>'' and t2.paydate <='" + startdateto +"') ";
        }
    }
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
		<link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
		<link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
		<script language="javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
		<script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>
		<script src="/meeting/calendar/src/Plugins/datepicker_lang_ZH_wev8.js" type="text/javascript"></script> 
		<script src="/meeting/calendar/src/Plugins/wdCalendar_lang_ZH_wev8.js" type="text/javascript"></script>  
		<script language=javascript>  
			function submitData() {
				jQuery("#frmmain").submit();
			}
			function toYear(cmd){
				$GetEle("cmd").value = cmd;
				submitData();
			}
		</script>
	</head>
	<BODY>
		<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<!-- <input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input> -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmRpMonthSalarySum.jsp" >
			<input type="hidden" name="isself" value="1">
			<input type="hidden" name="cmd" value="0">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
					<wea:item>
						<input  class=inputstyle type=hidden name=year id=year value="<%=year%>">
						<input class=inputstyle type=hidden name=movedate id=movedate value="">
						<input  class=inputstyle type=hidden name=currentdate id=currentdate value="<%=currentdate%>">
						<div id="calhead" class="calHd" style="height:36px;padding-left:0px;min-width:900px !important;background-color: #f7f7f7;">
							<div id="editButtons1" style="float:left;min-width:122px !important;">
								<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=SystemEnv.getHtmlLabelName( 15384 ,user.getLanguage())%>" style="height:24px;margin-left:0px;border:none;">
									 
								</div>
								<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName(33960,user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
								</div>
								<input type="hidden" name="txtshow" id="hdtxtshow" />
								<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtncls" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
									
								</div>
								<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName(33961,user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
								</div>
							</div>
						</div>
					</wea:item>
					<wea:item attributes="{'samePair':'hiddenItem'}">&nbsp;</wea:item>
					<wea:item attributes="{'samePair':'hiddenItem'}">&nbsp;</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		<div id="contentDiv" style="<%=isself.equals("1") ? "" : "display:none"%>">
		<wea:layout type="diycol">
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<TABLE class=ListStyle cellspacing=1 >
					  <TBODY>
					  <tr class=header>
					  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
					   <%
						while(SalaryComInfo.next()) {
							String itemname = Util.toScreen(SalaryComInfo.getSalaryname(),user.getLanguage()) ;
							String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
							if( !itemtype.equals("2") ) {
					   %>
					   <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=itemname%></TH>
					   <%   } else { %>
					   <TH colspan=2 style="TEXT-ALIGN:center"><nobr><%=itemname%></TH>
					   <%   }
						}
					   %>
					  </tr>
					  <tr class=header>
					   <%
						SalaryComInfo.setTofirstRow() ;
						while(SalaryComInfo.next()) {
							String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
							if( !itemtype.equals("2") ) continue ;
					   %>
					   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH>
					   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH>
					   <%
						}
					   %>
					   </tr>
					   <%
						ArrayList resourceitems = new ArrayList() ;
						ArrayList salarys = new ArrayList() ;

						String sql = "SELECT t1.payid, t1.itemid, SUM(salary) AS allsalary " +
								"FROM HrmSalaryPaydetail t1, HrmSalaryPay t2 " +
								"WHERE t1.payid = t2.id " +
								"GROUP BY t1.payid, t1.itemid ";
						rs.executeSql(sql);
						while( rs.next() ) {
							String payid = Util.null2String( rs.getString("payid") ) ;
							String itemid = Util.null2String( rs.getString("itemid") ) ;
							String salary = "" + Util.getDoubleValue( rs.getString("allsalary") , 0 ) ;
							resourceitems.add( payid + "_" + itemid ) ;
							salarys.add( salary ) ;
						}

						   sql =  " select distinct t2.id , t2.paydate from HrmSalaryPay t2, HrmSalaryPaydetail t1 "
									 + " where t2.id = t1.payid " + sqlwhere
									 + " order by paydate ";
						   rs.executeSql(sql);
						   boolean isLight = false;

						   ArrayList colSumList = new ArrayList();
						   boolean isBegin = true;
						   int curColIndex = 0;
						   double temD1 = 0.0;

						while( rs.next() ) {
							String payid = Util.null2String( rs.getString("id") ) ;
							String paydate = Util.null2String( rs.getString("paydate") ) ;
							isLight = !isLight ;
					  %>
					  <tr class='DataLight'>
					  <td style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=paydate%></td>
					  <%
							SalaryComInfo.setTofirstRow() ;
							curColIndex = 0;
							while(SalaryComInfo.next()) {
								String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
								String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
								String salary = "" ;
								String personsalary = "" ;
								String companysalary = "" ;
								String salaryview = "" ;
								String personsalaryview = "" ;
								String companysalaryview = "" ;
								
								if( !itemtype.equals("2") ) {
									int salaryindex = resourceitems.indexOf( payid + "_" + itemid ) ;
									if( salaryindex != -1) {
										salary = (String) salarys.get(salaryindex) ;
										if(!salary.equals("0") ){
											salaryview = format.format(Double.parseDouble(salary));
										}else{
											salaryview = "" ;
										}
									}
									if(isBegin){
										colSumList.add(new Double(salary+"0"));
									}else{
										colSumList.set(curColIndex,new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(salary+"0")));
										curColIndex ++;
									}
					   %>
						   <td style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=salaryview%></td>
					<%           } else {
									int salaryindex = resourceitems.indexOf( payid + "_" + itemid+"_1" ) ;
									if( salaryindex != -1) {
										personsalary = (String) salarys.get(salaryindex) ;
										if( !personsalary.equals("0") ){
											personsalaryview = format.format(Double.parseDouble(personsalary));
										}else{
											personsalaryview = "" ;
										}
									}
									salaryindex = resourceitems.indexOf( payid + "_" + itemid+"_2" ) ;
									if( salaryindex != -1) {
										companysalary = (String) salarys.get(salaryindex) ;
										if(!companysalary.equals("0") ){
											companysalaryview = format.format(Double.parseDouble(companysalary));
										}else{
											companysalaryview = "";
										}
									}
									if(isBegin){
										colSumList.add(new Double(personsalary+"0"));
										colSumList.add(new Double(companysalary+"0"));
									}else{
										colSumList.set(curColIndex, new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(personsalary+"0")));
										curColIndex ++;
										colSumList.set(curColIndex, new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(companysalary+"0")));
										curColIndex ++;
									}

					   %>
						   <td style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=personsalaryview%></td>
						   <td style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=companysalaryview%></td>
					<%           }
							}
							if(isBegin){
								isBegin = false;
							}
					   %>
					   </tr>
					   <%
						}
					   %>
					<tr class='header'>
					  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TH>
					   <%
							curColIndex = 0;
							String viewName = "";
						while(SalaryComInfo.next()) {
							String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
							if(colSumList != null && colSumList.size()>0){
								temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue()*100.0/100;
							}else{
								temD1 = 0;
							}
							if(temD1 != 0){
								viewName = format.format(temD1);
							}else{
								viewName = "";
							}
							if( !itemtype.equals("2") ) {
					   %>
					   <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="10%"><nobr><%=viewName%></TH>
					   <%   } else {  %>
					   <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=viewName%></TH>
					   <%
								if(colSumList != null && colSumList.size()>0){
									temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue()*100.0/100;
								}else{
									temD1 = 0;
								}
								if(temD1 != 0){
									viewName = format.format(temD1);
								}else{
									viewName = "";
								}

					   %>
					   <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=viewName%></TH>
					   <%   }
						}
					   %>
					  </tr>
					  </TBODY>
					 </TABLE>
				</wea:item>
			</wea:group>
		</wea:layout>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
		<script language=javascript>  
			jQuery(document).ready(function(){
				hideEle("hiddenItem");
			var cBeginDate="<%=cBeginDate%>";
			var cEndDate="<%=cEndDate%>";
			var showtime = "";
			var titletime=""; 
			titletime = CalDateShowYear(new Date(Date.parse(cBeginDate.replace(/-/g,   "/"))));
			showtime = "<%=datenow+SystemEnv.getHtmlLabelName(445, user.getLanguage())%>";
			
		   $("#showyearbtn").click(function(e) {
				changeShowType(this);
				$("#txtdatetimeshow").attr("selectMode", '1');
				ShowYear();

		   });
		   
		   $("#showtodaybtn").click(function(e) {
				document.frmmain.currentdate.value = "" ;
				submitData();
		   });
		   
		   $("#sfprevbtn").click(function(e) {
			  getSubdate();

		   });
		   
		   $("#sfnextbtn").click(function(e) {
			  getSupdate();
		   });
		   
		   $("#hdtxtshow").datepickernew({ 
			   picker: "#txtdatetimeshow", 
			   showtarget: $("#txtdatetimeshow"),
			   onReturn:function(r){
					var d = CalDateShow(r);
					if(d && r){
						jQuery("#frmmain")[0].currentdate.value = dateFormat.call(r, i18n.xgcalendar.dateformat.fulldayvalue);
						submitData();
						$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
					}
				 } 
				,selectMode:"1"
		   });
		   
			var bodyheight = document.body.offsetHeight;
			$("#subCompanytDiv").height(bodyheight - 44);
			$("#subCompanytifm").height(bodyheight - 44);
		   $(".thcls").css("border-bottom","1px solid #59b0f2");
		   $(".schtd").css("border-bottom","1px solid #59b0f2");
		   $(".schtd").css("border-left","0px");
		   $(".roomnames").css("border-left","0px");
		   $("#txtdatetimeshow").text(showtime);
		});
		function CalDateShow(startday, endday, isshowtime, isshowweek) {
  if (!endday) {
      return dateFormat.call(startday, getymformat(startday,null,isshowtime,isshowweek));
  } else {
      var strstart= dateFormat.call(startday, getymformat(startday, null, isshowtime, isshowweek));
			var strend=dateFormat.call(endday, getymformat(endday, startday, isshowtime, isshowweek));
			var join = (strend!=""? " - ":"");
			return [strstart,strend].join(join);
  }
}
function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	submitData();
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	submitData();
}
function getYear(year){
	document.frmmain.movedate.value = year ;
	submitData();
}
function ShowYear() {
	document.frmmain.currentdate.value = "" ;
	submitData();
}

function CalDateShowMonth(startday) {
    return dateFormat.call(startday, getymformatMonth(startday));
}

function getymformatMonth(date) {
	var a = [];
	a.push(i18n.xgcalendar.dateformat.yM);
	return a.join("");
}

function CalDateShowYear(startday) {
    return dateFormat.call(startday, getymformatYear(startday));
}

function getymformatYear(date) {
	var a = [];
	a.push(i18n.xgcalendar.dateformat.fulldayshow);
	return a.join("");
}

function getymformat(date, comparedate, isshowtime, isshowweek, showcompare, ishowyear) {
            var showyear = isshowtime != undefined ? (date.getFullYear() != new Date().getFullYear()) : true;
            if(ishowyear != undefined && ishowyear == false){
            	showyear = false;
            }
            var showmonth = true;
            var showday = true;
            var showtime = isshowtime || false;
            var showweek = isshowweek || false;
            if (comparedate) {
                showyear = comparedate.getFullYear() != date.getFullYear();
                //showmonth = comparedate.getFullYear() != date.getFullYear() || date.getMonth() != comparedate.getMonth();
                if (comparedate.getFullYear() == date.getFullYear() &&
					date.getMonth() == comparedate.getMonth() &&
					date.getDate() == comparedate.getDate()
					) {
                    showyear = showmonth = showday = showweek = false;
                }
            }

            var a = [];
            if (showyear) {
                a.push(i18n.xgcalendar.dateformat.fulldayshow)
            } else if (showmonth) {
                a.push(i18n.xgcalendar.dateformat.Md3)
            } else if (showday) {
                a.push(i18n.xgcalendar.dateformat.day);
            }
            a.push(showweek ? " (W)" : "", showtime ? " HH:mm" : "");
            return a.join("");
        }


dateFormat = function(format) {
			var __WDAY = new Array(i18n.xgcalendar.dateformat.sun, i18n.xgcalendar.dateformat.mon, i18n.xgcalendar.dateformat.tue, i18n.xgcalendar.dateformat.wed, i18n.xgcalendar.dateformat.thu, i18n.xgcalendar.dateformat.fri, i18n.xgcalendar.dateformat.sat);                                                                                                                                                                      
			var __MonthName = new Array(i18n.xgcalendar.dateformat.jan, i18n.xgcalendar.dateformat.feb, i18n.xgcalendar.dateformat.mar, i18n.xgcalendar.dateformat.apr, i18n.xgcalendar.dateformat.may, i18n.xgcalendar.dateformat.jun, i18n.xgcalendar.dateformat.jul, i18n.xgcalendar.dateformat.aug, i18n.xgcalendar.dateformat.sep, i18n.xgcalendar.dateformat.oct, i18n.xgcalendar.dateformat.nov, i18n.xgcalendar.dateformat.dec); 
			
            var o = {
                "M+": this.getMonth() + 1,
                "d+": this.getDate(),
                "h+": this.getHours(),
                "H+": this.getHours(),
                "m+": this.getMinutes(),
                "s+": this.getSeconds(),
                "q+": Math.floor((this.getMonth() + 3) / 3),
                "w": "0123456".indexOf(this.getDay()),
                "W": __WDAY[this.getDay()],
                "L": __MonthName[this.getMonth()] //non-standard
            };
            if (/(y+)/.test(format)) {
                format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            }
            for (var k in o) {
                if (new RegExp("(" + k + ")").test(format))
                    format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
            }
            return format;
};
		</script>
	</body>
</HTML>
