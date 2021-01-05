
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";

String currentYear=TimeUtil.getCurrentDateString().substring(0,4);
String CurrentUser = ""+user.getUID();
//要创建的计划的所有者类型  "1"：分部 "2":部门 "3"：人力资源
String type_d=Util.null2String(request.getParameter("type_d")); 
//要创建的计划的所有者ID
String objId=Util.null2String(request.getParameter("objId")); 


//来源于提醒 
String type=Util.null2String(request.getParameter("type")); 
String planDate=Util.null2String(request.getParameter("planDate")); 
String years=Util.null2String(request.getParameter("years"));
String days=Util.null2String(request.getParameter("days"));
String months=Util.null2String(request.getParameter("months"));
String weeks=Util.null2String(request.getParameter("weeks"));
String quarters=Util.null2String(request.getParameter("quarters"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 0);//默认为待审批
int isfromleft = Util.getIntValue(request.getParameter("isfromleft"), 0);
if (objId.equals("")) 
{
objId=CurrentUser;
type_d="3";
}
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);

String currentSeason=TimeUtil.getCurrentSeason();

String currentDay=TimeUtil.getDayOfMonth();

if("".equals(months)){
	months = currentMonth;
}
if("".equals(years)){
	years = currentYear;
}
if("".equals(quarters)){
	quarters = currentMonth;
}
if("".equals(days)){
	days = currentDay;
}



String objName="";
if (type_d.equals("1"))
{
objName=SubCompanyComInfo.getSubCompanyname(objId);
}
else if (type_d.equals("2"))
{
objName=DepartmentComInfo.getDepartmentname(objId);
}
else if (type_d.equals("3"))
{
objName=ResourceComInfo.getLastname(objId);
}

SessionOper.setAttribute(session,"hrm.objId",objId);
SessionOper.setAttribute(session,"hrm.objName",objName);
SessionOper.setAttribute(session,"hrm.type_d",type_d);
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<link rel="stylesheet" href="/worktask/js/jquery.datefamily_wev8.css" type="text/css" />
<script type="text/javascript" src="/worktask/js/jquery.plugin.datefamily_wev8.js"></script>

<script>
  
   	   function resetbanner(objid, typeid){
		    
			var years = document.all("years").value;
            var wtid = $("select[name='wtid']").val();
			var worktaskStatus = $("select[name='worktaskStatus']").val();
			if(objid != "5" && objid != "6"){
				document.all("typeid").value = typeid;
				for(i=0; i<=4; i++){
					document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
					document.all("oTDtype_"+i).className="cycleTD";
				}
				document.all("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
				document.all("oTDtype_"+objid).className="cycleTDCurrent";
			}else{
				//typeid = document.all("typeid").value;
			}
			//动态查询
			var href="RequestMonitorList.jsp?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type_d=<%=type_d%>&objId=<%=objId%>";
			var selectdateitem=$(".tab_menu").find(".current a");
			var datetype=selectdateitem.attr("_datetype");
            var datevalue=$(".dateitem").find(".datevalue").html();
			var datearray;
			if(datevalue.indexOf("_")>=0)
			  datearray=datevalue.split("_");
			else
              datearray=datevalue.split("-");
            href=href+"&years="+datearray[0];
			if(datetype==='year'){
			   href=href+"&type=0";
			}else if(datetype==='season'){
			   href=href+"&type=1&quarters="+datearray[1];
			}else if(datetype==='month'){
			   href=href+"&type=2&months="+datearray[1];
			}else if(datetype==='week'){
                href=href+"&type=3&weeks="+datearray[1];
			}else if(datetype==='day'){
			    href=href+"&type=4&months="+datearray[1]+"&days="+datearray[0]+"-"+datearray[1]+"-"+datearray[2];
			}
			$("#tabcontentframe").attr("src",href);
       }

</script>

<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
.sbSelector{
font-size:12px;
}
#objName{
margin-right:20px;
display:inline !important;
}
.dateitemwrapper{
cursor: pointer;
text-decoration: underline!important;
color: rgb(13,147,246);
}
#e8TreeSwitch{
  display:none;
}
</style>
</HEAD>
<script language=javascript>

function init(objid,typeid){
	if(objid != "5" && objid != "6"){
		document.all("typeid").value = typeid;
		for(i=0; i<=4; i++){
			document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
			document.all("oTDtype_"+i).className="cycleTD";
		}
		document.all("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
		document.all("oTDtype_"+objid).className="cycleTDCurrent";
	}else{
		typeid = document.all("typeid").value;
	}
	var o = parent.contentframe.iframes.document;
	o.location="RequestMonitorList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=months%>&planDate=<%=planDate%>&quarters=<%=quarters%>&weeks=<%=weeks%>&isfromleft=<%=isfromleft%>";
}
 </script>
<body style="overflow:auto" <%if (!type.equals("")) {%>onload="init('<%=type%>','<%=type%>')" <%}%> >
  <input name='type'  type='hidden'  value='<%=type%>'>
   <input name='type_d'  type='hidden'  value='<%=type_d%>'>
   <input name='objId'  type='hidden'  value='<%=objId%>'>
   <input name='years'  type='hidden'  value='<%=years%>'>
   <input name='wtid'  type='hidden'  value='<%=wtid%>'>
   <input name='worktaskStatus'  type='hidden'  value='<%=worktaskStatus%>'>

	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab"><a class='dateitemwrapper'><span class='dateitem'></span></a>
					<span id="objName"></span><select class='wtselect' name="wtid" onchange="resetbanner(5,5);" style="width:100px;">
				                                  <option value="0" <%if(wtid == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21979, user.getLanguage())%></option>
														<%
															RecordSet.execute("select * from worktask_base where isvalid=1 order by orderid");
															while(RecordSet.next()){
																String wtname_tmp = Util.null2String(RecordSet.getString("name"));
																int wtid_tmp = Util.getIntValue(RecordSet.getString("id"), 0);
														%>
										          <option value="<%=wtid_tmp%>" <%if(wtid_tmp == wtid){%>selected<%}%>><%=wtname_tmp%></option> <%}%>
								          	  </select>
											  <select name="worktaskStatus" onchange="resetbanner(6,6)" style="width:100px">
													<%
														RecordSet.execute("select * from SysPubRef where masterCode='WorkTaskStatus' and flag=1 and (detailCode !=5 and detailCode !=6 ) ");
														while(RecordSet.next()){
															int detailCode = Util.getIntValue(RecordSet.getString("detailCode"), 0);
															int detailLabel = Util.getIntValue(RecordSet.getString("detailLabel"), 0);
													%>
													<option value="<%=detailCode%>" <%if (worktaskStatus == detailCode){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(detailLabel, user.getLanguage())%></option>
													<%}%>
			                                  </select>
				</div>
				<div>
					<ul class="tab_menu">
						<li class="e8_tree" onclick="javascript:refreshTab();">
							<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage()) %></a>
						</li>
						<li class="current" >
							<a href="" target="tabcontentframe" _datetype="year" type='0'><%=SystemEnv.getHtmlLabelName(26577,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="season" type='1'><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="month" type='2'><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="week" type='3'><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage()) %></a>
						</li>
						<li style="display:none">
							<a href="" target="tabcontentframe" _datetype="day" type='4'><%=SystemEnv.getHtmlLabelName(82920,user.getLanguage()) %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			
		<div>
	</div>	






		<script type="text/javascript">
  
			var src="RequestMonitorList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=months%>&planDate=<%=planDate%>&quarters=<%=quarters%>&weeks=<%=weeks%>&isfromleft=<%=isfromleft%>";

			function resetDateitem(){
			
			    var doc=$("#tabcontentframe").contents();
			    doc.find("input[name='years']").val("");
				doc.find("input[name='months']").val("");
				doc.find("input[name='quarters']").val("");
				doc.find("input[name='weeks']").val("");
				doc.find("input[name='days']").val("");

			}
			//按时间索引
            function  searchDataByTime(){
			   var dateitem=arguments[0];
			   var year=arguments[1];
			   var doc=$("#tabcontentframe").contents();

			  var type_d=$("input[name='type_d']").val();
			  var objId=$("input[name='objId']").val();
			  var wtid=$("select[name='wtid']").val();
			  var worktaskStatus=$("select[name='worktaskStatus']").val();

			   var href="RequestMonitorList.jsp?type_d="+type_d+"&objId="+objId+"&wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&years="+year;

			   if(dateitem==='year'){
			          doc.find("input[name='years']").val(year);
					   href=href+"&quarters="+ arguments[2]+"&type=0";
				}else if(dateitem==='season'){
				      doc.find("input[name='years']").val(year);
			          doc.find("input[name='quarters']").val(arguments[2]);
					  href=href+"&quarters="+ arguments[2]+"&type=1";
			   }else if(dateitem==='month'){
				      doc.find("input[name='years']").val(year);
			          doc.find("input[name='months']").val(arguments[2]);
					  href=href+"&months="+ arguments[2]+"&type=2";
			   }else if(dateitem==='week'){
				      doc.find("input[name='years']").val(year);
			          doc.find("input[name='weeks']").val(arguments[2]);
					  href=href+"&weeks="+ arguments[2]+"&type=3";
			   }
			   $("#tabcontentframe").attr("src",href);
			
			}
			
			$(document).ready(function(){
              
              $(".dateitem").dateSelect({datepanel:"year",confirm:searchDataByTime});

			  $(".tab_menu").find("a").click(function(e){
			         var currentitem=$(this);
                     var type_d=$("input[name='type_d']").val();
					 var objId=$("input[name='objId']").val();
					 var wtid=$("select[name='wtid']").val();
					 var worktaskStatus=$("select[name='worktaskStatus']").val();
					 var newhref="RequestMonitorList.jsp?type_d="+type_d+"&objId="+objId+"&wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&"+currentitem.attr("dateparam");
                     currentitem.attr("href",newhref);
				     e.stopPropagation();
					 var current=$(this);
					 $(".dateitemwrapper").html("<span class='dateitem'></span>");
					 var datetype=current.attr("_datetype");
					 if(datetype==='day'){
						 var href="RequestMonitorList.jsp?type_d="+type_d+"&objId="+objId+"&wtid="+wtid+"&worktaskStatus="+worktaskStatus;
						 var cdate=new Date();
						 var cyear=cdate.getFullYear();
						 var cmonth=cdate.getMonth()+1;
						 var cdate=cdate.getDate();
						 $(".dateitem").html("<span class='datevaluelabel'>"+cyear + "<%=SystemEnv.getHtmlLabelName(26577,user.getLanguage()) %>" + cmonth+ "<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage()) %>"+cdate+"<%=SystemEnv.getHtmlLabelName(82920,user.getLanguage()) %></span><span class='datevalue' name='datevalue' id='datevalue' style='display: none'>" + cyear + "-" + cmonth+"-" +cdate+ "</span>");
					     $(".dateitem").click(function(){
						 
						       WdatePicker({el:'datevalue',onpicked:function(dp){
							        var returnvalue = dp.cal.getDateStr();	
								    var itemvals = returnvalue.split("-");
									cyear=itemvals[0];
									cmonth=itemvals[1];
									cdate=itemvals[2];
							        $(".datevaluelabel").html(cyear + "<%=SystemEnv.getHtmlLabelName(26577,user.getLanguage()) %>" + cmonth+ "<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage()) %>"+cdate+"<%=SystemEnv.getHtmlLabelName(82920,user.getLanguage()) %>");
									$(".datevalue").html(cyear + "-" + cmonth+"-" +cdate);
                                    href=href+"&years="+ cyear +"&type=4"+"&months="+cmonth+"&days="+cyear+"-"+cmonth+"-"+cdate;
                                    $("#tabcontentframe").attr("src",href);
							    }
							});
						 
						 });
					 }else
					 $(".dateitem").dateSelect({datepanel:datetype,confirm:searchDataByTime});
					 
			  });
                
              $('.e8_box').Tabs({
					getLine : 1,
					iframe : "tabcontentframe",
					mouldID:"<%= MouldIDConst.getID("worktask")%>",
					staticOnLoad:true,
					objName:"<%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%>"
				});
				attachUrl();
			});

		//获取当前所属季度
        function getSeasonNow(){
            var seasons="1";
            var monthnow=new Date().getMonth();
            if(monthnow>=0 && monthnow<=2)
                seasons="1";
            else if(monthnow>=3 && monthnow<=5)
                seasons="2";
            else if(monthnow>=6 && monthnow<=8)
                seasons="3";
            else if(monthnow>=9 && monthnow<=11)
                seasons="4";
            return seasons;
        }

         function getWeekNow(){
			var cdata=new Date();
		    var year=cdata.getFullYear();
		    var onejan = new Date(year,0,1);
            return Math.ceil((((cdata - onejan) / 86400000) + onejan.getDay()+1)/7);
		 
		 }
		  
		 function attachUrl(){
      
	       
			var cdate=new Date();
			var cyear=cdate.getFullYear();
			var cseason=getSeasonNow();
			var cmonth=cdate.getMonth()+1;
			var cdate=cdate.getDate();
			var cweek=getWeekNow();

			$("a[target='tabcontentframe']").each(function(){
				var href=src+"&type="+$(this).attr("type");
				var datetype=$(this).attr("_datetype");
				var dateparam="type="+$(this).attr("type");
				if(datetype==='year'){
				   href=href+"&years="+cyear;
				   dateparam=dateparam+"&years="+cyear;
				}else if(datetype==='month'){
				    href=href+"&years="+cyear+"&months="+cmonth;
					dateparam=dateparam+"&years="+cyear+"&months="+cmonth;
				}else if(datetype==='season'){
				    href=href+"&years="+cyear+"&quarters="+cseason;
					dateparam=dateparam+"&years="+cyear+"&quarters="+cseason;
				}else if(datetype==='week'){
				    href=href+"&years="+cyear+"&weeks="+cweek;
					dateparam=dateparam+"&years="+cyear+"&weeks="+cweek;
				}else if(datetype==='day'){
			        href=href+"&years="+cyear+"&months="+cmonth+"&days="+cyear+"-"+cmonth+"-"+cdate;
					dateparam=dateparam+"&years="+cyear+"&months="+cmonth+"&days="+cyear+"-"+cmonth+"-"+cdate;
				}
				$(this).attr("href",href);
				$(this).attr("dateparam",dateparam);
				
			});
			$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
		}

		function refreshTab(){
		}

</script>
</body>