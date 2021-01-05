
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:include page="/systeminfo/DatepickerLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<jsp:include page="/systeminfo/WdCalendarLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<%@page import="weaver.Constants"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="java.sql.Timestamp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<html >
<head id="Head1">

	<%
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		
		String selectedUser=Util.null2String(request.getParameter("selectUser"));
		if("".equals(selectedUser)){
			selectedUser=""+user.getUID();
		}
		String selectedUserName=ResourceComInfo.getFirstname(selectedUser);
		
		String userid = ""+user.getUID();
		String logintype = ""+user.getLogintype();
		
		int userdept = user.getUserDepartment();
		int userSub = user.getUserSubCompany1();
		
		String sTime=(meetingSetInfo.getTimeRangeStart()<10?"0"+meetingSetInfo.getTimeRangeStart():meetingSetInfo.getTimeRangeStart())+":00";
		String eTime=(meetingSetInfo.getTimeRangeEnd()<10?"0"+meetingSetInfo.getTimeRangeEnd():meetingSetInfo.getTimeRangeEnd())+":59";
		
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
	 <link href="/workplan/calendar/css/editbox_wev8.css" rel="stylesheet" type="text/css" /> 
    <script src="/wui/common/jquery/jquery.min_wev8.js" type="text/javascript"></script>  
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
       
    <script src="/meeting/calendar/src/Plugins/Common_wev8.js" type="text/javascript"></script>
	
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	
    <script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>


    <script src="/meeting/calendar/src/Plugins/jquery.calendar_wev8.js" type="text/javascript"></script>   
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script src="/meeting/calendar/src/Plugins/json2_wev8.js" type="text/javascript"></script>
	<script type="text/javascript">
	var selectedUser="<%=selectedUser%>";
	var selectedType="1";
	var selectedDept="<%=userdept%>";
	var selectedSub="<%=userSub%>";
	var selectedUserName="<%=ResourceComInfo.getLastname(selectedUser)%>";
	var isShare="<%=Util.null2String(request.getParameter("isShare"))%>";
	var meetingType = "0";
	</script>

<style>
	.fcurrent{
		background:#2e9eb2!important;
		color:white;
	}

	.gcweekname ,.mv-dayname,.wk-dayname,.wk-dayname{
		background-color: #f7f7f7;
	}

	#dvwkcontaienr{		
		
	}
	#weekViewAllDaywkBox{
		height:70px;
		overflow-y:scroll;
	}
	.Line{
		padding:0;
	}
	
	
	
</style>

   <script type="text/javascript">
   var diag_vote;
   var reloadList=true;
        $(document).ready(function() {     
           var view="month";          
           var isSubmit=false;
           
            var DATA_FEED_URL = "/meeting/data/getData.jsp";
            var op = {
                view: view,//指定显示的视图（周，月，日）
                theme:1,//指定默认模板，比如拖拽新建日程时日程的颜色
                showday: new Date(),//指定显示的日期，在视图中显示的日， 周，月为当前指定日期所在的日，周，月。
                EditCmdhandler:Edit,//编辑日程的回调函数
                DeleteCmdhandler:Delete,//删除日程的回调函数
                ViewCmdhandler:View,    //查看日程的回调函数
                onWeekOrMonthToDay:wtd,
                onBeforeRequestData: cal_beforerequest,//ajax请求前 的操作
                onAfterRequestData: cal_afterrequest,//ajax请求成功完成之后的操作
                onRequestDataError: cal_onerror, //ajax请求失败的操作
                onOtherOperate: cal_otherOperate, //ajax请求失败的操作
                autoload:true,
                defBgTimeStr:"<%=sTime%>",
				defEdTimestr:"<%=eTime%>", 
                meetingType:meetingType,//指定会议的类型
                selectedType:selectedType,//指定当前选定的类型
                selectedUser:selectedUser,//指定当前选定的人员
                selectedDept:selectedDept,//指定当前选定的部门
                selectedSub:selectedSub,//指定当前选定的分部
                isShare:isShare,//（isShare：1 显示“所有日程”，其他：显示“我的日程”
                url: DATA_FEED_URL + "?method=list&selectUser=",  //视图中日程项数据请求url
                quickAddUrl: DATA_FEED_URL + "?method=addCalendarItem&selectUser=",//拖拽方式添加日程url
                quickUpdateUrl: DATA_FEED_URL + "?method=editCalendarItemQuick&selectUser=",//拖动调整日程时间url
                quickDeleteUrl: DATA_FEED_URL + "?method=deleteCalendarItem&selectUser=" ,//快速删除日程url
                quickEndUrl: DATA_FEED_URL + "?method=deleteCalendarItem&selectUser=" ,//删除日程url
                getEventItemUrl: DATA_FEED_URL + "?method=getCalendarItem&selectUser="  ,//获取单个日程明细的url
                updateEvent:  DATA_FEED_URL + "?method=editCalendarItem&selectUser="    ,//更新日程信息的url
                getSubordinateUrl: DATA_FEED_URL+"?method=getSubordinate&selectUser=",//获取当前选中人员下属名单的url
                overCalendarItemUrl:DATA_FEED_URL+"?method=overCalendarItem&selectUser&selectUser="//结束日程url
            };
            var $dv = $("#calhead");
            var $lv = $("#listdiv");
            var _MH = document.documentElement.clientHeight;
            var dvH = $dv.height() + $dv.offset().top+10+2 + 5;
			var reminddiv=_MH - dvH - 185 - 25
			$("#reminddiv").css("height",reminddiv+"px");
			
            op.height = _MH - dvH;
			if(op.height < 240){
				op.height = 240;
			}
            op.eventItems =[];
            
            var _MW = document.documentElement.clientWidth;
            var wid = $("#lastButtons").width() > $("#firstButtons").width()?$("#lastButtons").width():$("#firstButtons").width();
            //var mgl = (($dv.width()/2) - wid - ($("#editButtons").width()/2))/2
            //if(mgl < 0){
            //	mgl = 0;
            //}
          	//$("#editButtons").css("margin-left",mgl+"px");

            var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
			
            //显示时间控件 
            $("#hdtxtshow").datepickernew({ picker: "#txtdatetimeshow", showtarget: $("#txtdatetimeshow"),
            onReturn:function(r){                      
                        var p = $("#gridcontainer").gotoDate(r).BcalGetOp();
                        if (p && p.datestrshow) {
                            $("#txtdatetimeshow").text(p.datestrshow);
							$("#txtdatetimeshow").css("display","");
                        }
						$("#hdtxtshow").val(dateFormat.call(r, i18n.datepicker.dateformat.fulldayvalue));
                 } 
            ,selectMode:"1"});
			//$("#txtdatetimeshow").click(function(e){
            //	 WdatePicker({dateFmt:i18n.xgcalendar.dateformat.yM, onpicked:function(){
			//		var myDate=new Date()
			//		myDate.setFullYear($dp.cal.getP('y'),$dp.cal.getP('M') - 1,1)
			//		var p = $("#gridcontainer").gotoDate(myDate).BcalGetOp();
            //        if (p && p.datestrshow) {
            //            $("#txtdatetimeshow").text(p.datestrshow);
			//		$("#txtdatetimeshow").css("display","");
            //        }
			//	 }});
            //});
			
            function cal_beforerequest(type)
            {
                var t="Loading data...";
                switch(type)
                {
                    case 1:
                        t="<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>"; //页面加载中，请稍候...
                        break;
                    case 2:   
                        t="<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>"; //正在保存，请稍等...
                        break;                   
                    case 3:  
                        t="<%=SystemEnv.getHtmlLabelName(28060,user.getLanguage())%>"; //正在删除日程，请稍后...
                        break;   
                    case 4:    
                        t="<%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>";                                   
                        break;
                }
                $("#errorpannel").hide();
                $("#loadingpannel").html(t).show();    
            }
            function Edit(data,a)
            {
            	if(data)
                {
                	
                    if(data[0]=="0"){
                    	NewEvent(data);
                    }else{
                    	
		            	if(window.top.Dialog){
							diag_vote = new window.top.Dialog();
						} else {
							diag_vote = new Dialog();
						}
						diag_vote.currentWindow = window;
						diag_vote.Width = 800;
						diag_vote.Height = 550;
						diag_vote.Modal = true;
						diag_vote.maxiumnable = true;
						diag_vote.checkDataChange = false;
						diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
						diag_vote.URL = "/meeting/data/EditMeetingTab.jsp?meetingid="+data[0];
						diag_vote.show();
					}
				}
            } 
			function NewEvent(data){
				if(window.top.Dialog){
					diag_vote = new window.top.Dialog();
				} else {
					diag_vote = new Dialog();
				}
				diag_vote.currentWindow = window;
				diag_vote.Width = 800;
				diag_vote.Height = 550;
				diag_vote.Modal = true;
				diag_vote.maxiumnable = true;
				diag_vote.checkDataChange = false;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
				diag_vote.URL = "/meeting/data/NewMeetingTab.jsp?startdate="+data[2]+"&enddate="+data[4]+"&starttime="+data[3]+"&endtime="+data[5];
				diag_vote.show();
			}

        function View(data)
        {
        	
            if(data)
            {
            	
                if(data[0]!="0"){
                	
			          	if(window.top.Dialog){
										diag_vote = new window.top.Dialog();
									} else {
										diag_vote = new Dialog();
									}
									diag_vote.currentWindow = window;
									diag_vote.Width = 800;
									diag_vote.Height = 550;
									diag_vote.Modal = true;
									diag_vote.maxiumnable = true;
									diag_vote.checkDataChange = false;
									<%if(user.getLanguage() == 8){%>
									diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
									<%} else {%>
									diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
									<%}%>
									
									diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?meetingid="+data[0];
									diag_vote.show();
								}
						}
        }   
            function cal_afterrequest(type)
            {
                switch(type)
                {
                    case 1:
                        $("#loadingpannel").hide();
                        break;
                    case 2:
                        $("#loadingpannel").html("<%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>!");
                        window.setTimeout(function(){ $("#loadingpannel").hide();},2000);
                    case 3:
                    case 4:
                        $("#loadingpannel").html("<%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>!");
                        window.setTimeout(function(){ $("#loadingpannel").hide();},2000);
                    break;
                }
                cal_otherOperate();
            }
            
            function cal_otherOperate(){
            	var option = $("#gridcontainer").BcalGetOp();
                var zone = new Date().getTimezoneOffset() / 60 * -1;
                if(reloadList){
                	$("#listframe").attr("src","/meeting/data/GetMeetingList.jsp?selectedType="+option.selectedType+"&meetingType="+option.meetingType+"&selectedDept="+option.selectedDept+"&selectedSub="+option.selectedSub+"&selectUser="+option.selectedUser+"&isShare="+option.isShare+"&selectdate="+dateFormat.call(option.showday, i18n.xgcalendar.dateformat.fulldayvalue)+"&viewtype="+option.view+"&timezone="+zone+"&divheight="+$("#dvCalMain").height());
               	}
               	reloadList=true;
               	setMeetingCnt();
            }
            
            function cal_onerror(type,data)
            {
                $("#errorpannel").show();
            }
              
            
          
            function wtd(p)
            {
               if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
					$("#txtdatetimeshow").css("display","");
                }
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $("#showdaybtn").addClass("fcurrent");
				
            }
            
            //refresh current View
            $("#showreflashbtn").click(function(e){
            	 $("#gridcontainer").reload();
            });
            
            //show rooms
            $("#showRoombtn").click(function(e){
            	 if(window.top.Dialog){
										diag_vote = new window.top.Dialog();
									} else {
										diag_vote = new Dialog();
									}
									diag_vote.currentWindow = window;
									diag_vote.Width = 1100;
									diag_vote.Height = 550;
									diag_vote.Modal = true;
									diag_vote.maxiumnable = true;
									diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(15881,user.getLanguage())%>";
									diag_vote.URL = "/meeting/report/MeetingRoomPlan.jsp";
									diag_vote.show();
            });
            
            $("#showModelbtn").click(function(e) {
            	var val = $(this).attr("val");
            	if(val == 0){
            		//$(this).html("时间视图");
            		$(this).attr("title","<%=SystemEnv.getHtmlLabelName(32993,user.getLanguage())%>");
            		$(this).attr("val","1");
					$(this).removeClass("showModelbtn");
					$(this).addClass("showModelbtnList");
					$("#listdiv").height($("#dvCalMain").height());
            		$("#dvCalMain").css("display","none");
            		$("#listdiv").css("display","");
					//alert($("#listdiv").height());
					if($("#listdiv").height() < 30) {
						var option = $("#gridcontainer").BcalGetOp();
						var zone = new Date().getTimezoneOffset() / 60 * -1;
						$("#listframe").attr("src","/meeting/data/GetMeetingList.jsp?selectedType="+option.selectedType+"&meetingType="+option.meetingType+"&selectedDept="+option.selectedDept+"&selectedSub="+option.selectedSub+"&selectUser="+option.selectedUser+"&isShare="+option.isShare+"&selectdate="+dateFormat.call(option.showday, i18n.xgcalendar.dateformat.fulldayvalue)+"&viewtype="+option.view+"&timezone="+zone+"&divheight="+$("#dvCalMain").height());
					}
            	} else {
            		//$(this).html("列表视图");
            		$(this).attr("title","<%=SystemEnv.getHtmlLabelName(32994,user.getLanguage())%>");
            		$(this).attr("val","0");
					$(this).removeClass("showModelbtnList");
					$(this).addClass("showModelbtn");
            		$("#dvCalMain").css("display","");
            		$("#listdiv").css("display","none");
            	}
            });
            
            //Add a new event
            $("#faddbtn").click(function(e) {
            	  var today=new Date();
            	  var year=today.getFullYear();
            	  var month=today.getMonth()+1;
            	  var day=today.getDate();
            	  var hours=today.getHours();
            	  var min=today.getMinutes();
            	  
                  var data=["0",
                         "",
                         ""+year+"-"+(month>9?month:"0"+month)+"-"+(day>9?day:"0"+day),
                         ""+(hours>9?hours:"0"+hours)+":"+(min>9?min:"0"+min),"",""];
                 Edit(data);
            	//$("#memberIDs").val(selectedUser); 
            	//$("#memberIDsSpan").text(selectedUserName);
            	
            });
            //go to today
            $("#showtodaybtn").click(function(e) {
                var p = $("#gridcontainer").gotoDate().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
					$("#txtdatetimeshow").css("display","");
                }


            });
            //previous date range
            $("#sfprevbtn").click(function(e) {
                var p = $("#gridcontainer").previousRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
					$("#txtdatetimeshow").css("display","");
                }

            });
            //next date range
            $("#sfnextbtn").click(function(e) {
                var p = $("#gridcontainer").nextRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
					$("#txtdatetimeshow").css("display","");
                }
            });
            
			
            //$("#currentUserspan").live("click",function(e){
			//	if($("#subordinateDivList").css("display")=="none"){
			//		$("#subordinateDivList").show();
			//	}else{
			//		$("#subordinateDivList").hide();
			//		return;
			//	}
			//	$("#subordinateDivList").css({
			//			"left":$(this).offset().left-$("#subordinateDivList").width()+$(this).width()+"px",
			//			"top":$(this).offset().top+$(this).height()+"px",
            //            "overflow-y":"scroll",
            //            "height":"400px"
			//		});
            // });
				
				$("#pd").click(function(e) {
					$(this).css("background-color", "#4fa7ff");
					$(this).css("color", "#fff");
					$("#stuts").css("background-color","#d1d1d1");
					$("#stuts").css("color", "#000");
					$("#statusdiv").hide();
					$("#perandorgdiv").show();
					var tree_div_height = $("#dvCalMain").height() - $("#changePerdiv").height() -10 - $("#lastButtons").height() - 11 -10 -8;
					//alert($("#dvCalMain").height()+"-"+$("#changePerdiv").height()+"-"+$("#lastButtons").height());
					$("#treediv").height(tree_div_height);
					document.getElementById('persontree').contentWindow.__zTreeNamespace__.e8HasData();
				});
				
				$("#stuts").click(function(e) {
					$(this).css("background-color", "#4fa7ff");
					$(this).css("color", "#fff");
					$("#pd").css("background-color","#d1d1d1");
					$("#pd").css("color", "#000");
					$("#statusdiv").show();
					$("#perandorgdiv").hide();
				});
				
				$("#perdiv").click(function(e) {
					$("#orgcontentdiv").hide();
					$("#percontentdiv").show();
				});
				
				$("#orgdiv").click(function(e) {
					$("#orgcontentdiv").show();
					$("#percontentdiv").hide();
				});

				jQuery(".allclss").hover(function(){
					if($("#allclss1").height() > 0) {
					$("#allclss1").animate({height:"0px"},100);
					//$("#allclss1").animate({background-color:"A5A5A5"},300);
					}
				},function(){
					if($("#allclss1").height() <= 0) {
					$("#allclss1").animate({height:"34px"},100);
					}
				});
				
				$("#descdiv .titleclass").click(function(e) {
            	if(jQuery(this).hasClass("titleselect")){
				
				} else{
					jQuery(".titleselect").each(function(){
						jQuery(this).removeClass("titleselect");
					});
					jQuery(this).addClass("titleselect");
					var meetingType = jQuery(this).attr("val");
					var p = $("#gridcontainer").BcalGetOp();
					p.meetingType=meetingType;
					$("#gridcontainer").reload();
				}
			
				if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
					$("#txtdatetimeshow").css("display","");
                }
            });
				
				jQuery(".overclss").hover(function(){
					if($("#overclss1").height() > 0) {
					$("#overclss0").html("<%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%>");
					$("#overclss1").animate({height:"0px"},100);
					}
				},function(){
					if($("#overclss1").height() <= 0) {
					$("#overclss1").animate({height:"34px"},100);
					$("#overclss0").html("");
					}
				});
				
				jQuery(".nowclss").hover(function(){
					if($("#nowclss1").height() > 0) {
					$("#nowclss1").animate({height:"0px"},100);
					//$("#allclss1").animate({background-color:"A5A5A5"},300);
					}
				},function(){
					if($("#nowclss1").height() <= 0) {
					$("#nowclss1").animate({height:"34px"},100);
					}
				});
				
				jQuery(".noclss").mouseout(function(){
					//$("#noclss1").animate({height:"34px"},100);
					$("#noclss1").height("34px");
				});
				
				jQuery(".noclss").mouseover(function(){
					$("#noclss1").animate({height:"0px"},100);
				});
			   
			 
             
            setUser(selectedUser);
			
			//$("#reminddiv").perfectScrollbar();
			
			p = $("#gridcontainer").gotoDate().BcalGetOp();
            if (p && p.datestrshow) {
                $("#txtdatetimeshow").text(p.datestrshow);
				$("#txtdatetimeshow").css("display","");
            }
        });
        function Delete(data,callback)
        {        
            Dialog.confirm(
        			"<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        				 callback(0);
        				 
        			}, function () {}, 220, 90,false
        	    );
          }
        function onUserSelected(){
        	
        	var userID = $("#currentUser").val();
        	var opts=document.getElementById("subordinate");
			 if(userID==$("#currentUser").val()){
				
			 }
			 else if(userID!=selectedUser){
			 	//$("#currentUser").val(userID);
			 	//$("#currentUserspan").text(opts[opts.selectedIndex].text);
				setCurrentUser(userID, opts[opts.selectedIndex].text);
			}else {
				//$("#currentUser").val(selectedUser);
			 	//$("#currentUserspan").text(selectedUserName);
				setCurrentUser(selectedUser, selectedUserName);
			}
        	setUser(userID);
        }
        function onCurrentUserChange(){
        	 var p = $("#gridcontainer").BcalGetOp();
			 var selectedUser1=$("#subordinate").val();
			 setUser(selectedUser1);
        }
        function showMyCalnedar(){
        	setUser(selectedUser);
        	jQuery("#selectType").val("1");
        	//$("#currentUser").val(selectedUser);
			//$("#currentUserspan").html("<a href='javascript:openhrm("+selectedUser+");' onclick='pointerXY(event);'> "+selectedUserName+"</a>");
			//jQuery("#selectType").trigger("change");
			//__callback("currentUser","currentUser",1,true);
			setCurrentUser(selectedUser, selectedUserName);
			showTypeChange();
			showPersonTree(<%=user.getUID()%>);
			
         }
        function subordinateDivListSelected(userid,userName){
			//$("#currentUserspan").html(userName);
			//$("#currentUser").val(userid);
			setCurrentUser(userid, userName);
			setUser(userid);
			$("#subordinateDivList").hide();
			
         }
        function setUser(userID){
        	var p = $("#gridcontainer").BcalGetOp();
			var  selectedUser1=userID;
			p.selectedUser=userID;
			p.selectedType="1";
			 //var opts=document.getElementById("subordinate");
			 var param={"userId":userID};
			 $.post(p.getSubordinateUrl,param,function(data){
					if(data){
						//for(var i=opts.length;i>0;i--){
						//	$(opts[i]).remove();
						//}
						//for(var i=0;i< data.length;i++){
						//	var user=data[i];
						//	$("#subordinate").append("<option value='"+user.id+"'>"+user.name+"</option");
						//}

						$("#subordinateDivList .title").text($("#currentUserspan").text()+"<%=SystemEnv.getHtmlLabelName(30805,user.getLanguage())%>:");
			        	//var subordinates=$("#subordinate").children();
			        	//var list=$($("#subordinateDivList .list")[0]);
			        	//list.empty();
			        	//for(var i=1;i<subordinates.length;i++ ){
						//	list.append("<li><a href=\"javascript:subordinateDivListSelected(\'"
						//				+$(subordinates[i]).val()+"\',\'"+$(subordinates[i]).text()+"\')\">"+$(subordinates[i]).text()+"</a></li>");
			            //}
					}
					 $("#gridcontainer").reload();
				},"json");
			 
      	}
      	
      	function setDept(deptID){
        	var p = $("#gridcontainer").BcalGetOp();
			 p.selectedDept=deptID;
			 p.selectedType="2";
			 $("#gridcontainer").reload();
      	}
      	function setSub(subID){
        	var p = $("#gridcontainer").BcalGetOp();
			 p.selectedSub=subID;
			 p.selectedType="3";
			 $("#gridcontainer").reload();
      	}
       
      	function onSharedCalendar(e){
			var targetValue=$.event.fix(e).target.value;
			var p = $("#gridcontainer").BcalGetOp();
			if(targetValue=="2"){
				isShare=1;
				p.isShare=isShare;

				$("#gridcontainer").reload();
			}else{
				isShare="";
				p.isShare=isShare;
				setUser(selectedUser);
				
			}
			
			
        }
        function validateForm(){
				isValidate=true;
				if($("#planName").val()==""){
					isValidate=false;
			    }
				/*
				if($("#description").val()==""){
					isValidate=false;
			    }
				*/
				if($("#memberIDs").val()==""){
					isValidate=false;
				}
				return isValidate;
        }
        function checkDateVali(){
            var begindate = $("#beginDate").val();
            var begintime =$("#beginTime").val();
            var enddate =  $("#endDate").val();
            var endtime = $("#endTime").val();
            if(begindate!=null &&begindate !="" && begintime !=null && begintime!=""){
                if(enddate!=null &&enddate !="" && endtime !=null && endtime!=""){
                    if(enddate==begindate){
                        if(endtime<begintime){
                            alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())%>！");
                            return false;
                        }
                    }  else if(enddate<begindate){
                        alert("<%=SystemEnv.getHtmlLabelName(83347,user.getLanguage())%>！");
                        return false;
                    }
                }   else if(enddate!=null &&enddate !="" && (endtime==""||endtime==null) ){
                    if(enddate<begindate){
                        alert("<%=SystemEnv.getHtmlLabelName(83347,user.getLanguage())%>！");
                        return false;
                    }else{
                        $("#endTime").val("23:59");
                    }
                }   else if((enddate==null || enddate=="") && endtime !=null && endtime!="" ){
                    alert("<%=SystemEnv.getHtmlLabelNames("23073,24980", user.getLanguage())%>！"); 
                    return false;
                }

            }  else{
                alert("<%=SystemEnv.getHtmlLabelName(32950,user.getLanguage())%>！");
                return false;
            }
            return true;

        }
		
		function showPersonTree(id){
			$("#persontree").attr("src","/meeting/data/SubordinateTree.jsp?id="+id);
		}
		
		function setCurrentUser(userid, username){
			_writeBackData("currentUser",1,{id:userid,name:"<a href='javascript:openhrm("+userid+");' onclick='pointerXY(event);'> "+username+"</a>"},{
					hasInput:true,
					replace:true,
					isSingle:true,
					isedit:true
				});
		}

       
    </script>    

</head>
<%
      String addBtnUrl="/meeting/calendar/css/images/icons/addBtn_wev8.png";
	  if(user.getLanguage()==8){
		  addBtnUrl="/meeting/calendar/css/images/icons/addBtn_EN_wev8.png";
	  }
%>
<body scroll="no">

    <div>
	
      <div id="calhead" class="calHd" style="height:34px;padding-left:0px;min-width:920px !important;background-color: #f7f7f7;">
      		<div  id="firstButtons" style="float:left;min-width:90px !important;">
      			<div id="faddbtn" class="calHdBtn faddbtn" title="<%=SystemEnv.getHtmlLabelName( 15008 ,user.getLanguage())%>" style="margin-left:10px;border:none;height:25px;">
      			</div>
		      	<div id="showRoombtn" unselectable="on" class="calHdBtn showRoombtn" title="<%=SystemEnv.getHtmlLabelName( 15881 ,user.getLanguage())%>" style="margin-left:10px;height:24px;border:none;">
		      			
		      	</div>
				<div class="rightBorder" >|</div>
      		</div>
			
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="<%=SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage())%>" style="height:24px;margin-left:0px;border:none;">
		      			 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName( 32995 ,user.getLanguage())%>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn" style="border:none;color:#59b0f2;height:24px;width:auto;padding-left:1px;padding-right:10px;">
						
					</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName( 32996 ,user.getLanguage())%>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
		      		<div class="rightBorder" style="margin-left:10px">|</div>
				</div>
			
			
			<div id="editButtons2" style="float:left;min-width:60px !important;margin-right:220px;">
		      		<div id="showModelbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 32994 ,user.getLanguage())%>" val="0" unselectable="on" class="calHdBtn showModelbtn" style="margin-left:0px;border:none;height:24px;">
					</div>
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;">
					</div>
					
               </div>
      		
				
      		
      </div>
      <div style="min-width:920px !important;border:none;vertical-align: top;">
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<COLGROUP>
				<COL width="">
				<COL width="230">
			<TBODY>
				<tr>
				<td valign="top" style="border-top: #d0d0d0 1px solid;">
			        <div id="dvCalMain" class="calmain printborder" style="position:relative">
			            <div id="gridcontainer" style="overflow-y: visible;visibility:visible;height:200px">
			            </div>
			            
			        </div>
			        <div id="listdiv" style="display:none;overflow-y: visible;visibility:visible;margin-top:0px;">
		            	<table style="width:100%">
		            		<tr>
		            			<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
								<IFRAME name="listframe" id="listframe" src="" width="100%"  frameborder=no scrolling=no>
								</IFRAME>
								</td>
		            		</tr>
		            	</table>
		            </div>
			        <div class="t2 chromeColor">
			
			            &nbsp;</div>
			        <div class="t1 chromeColor">
			            &nbsp;
			        </div>
		        </td>
					<td valign="top" style="border-left:#d0d0d0 1px solid;border-right:#d0d0d0 1px solid;border-bottom:#d0d0d0 1px solid;background-color:#f7f7f7;">
						<table width=100% border="0" cellspacing="0" cellpadding="0" >
							<tr>
								<td>
									<div id="lastButtons" class="calHd" style="float:right;padding-right:0px;width:230px;">
											<div id="stuts" unselectable="on" class="calHdBtn" style="margin:0px;border:none;height:32px;line-height: 30px;width:115px;background-color:#4fa7ff;color:#fff">
											<%=SystemEnv.getHtmlLabelName( 22260 ,user.getLanguage())%>
											</div>
											<div id="pd" unselectable="on" class="calHdBtn" style="margin:0px;height:32px;line-height: 30px;border:none;width:115px;background-color:#d1d1d1;">
											<%=SystemEnv.getHtmlLabelName( 32997 ,user.getLanguage())%>
											</div>
									</div>
								</td>
							</tr>
							<tr>
								<td height="11px">
								</td>
							</tr>
							<tr>
							<td>
							<div id="statusdiv">
								<table width=100% border="0" cellspacing="0" cellpadding="0" >
								<tr>
									<td>
								<div id="descdiv" style="overflow-y: visible;visibility:visible;border:#d0d0d0 1px solid;height:100%;padding:5px;margin-left:8px;margin-right:8px;background-color:#fff;">
								<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
								<tr style="background-color:#fff;height:30px">
								<td colspan="2">
								<div class="titleclass titleselectall titleselect" val=0 >
								<div style="width:30px;height:30px;background-color:#219CEF;float:left;">
								<img border="0" src="/images/ecology8/meeting/all_wev8.png" style="margin-left: 8px;margin-top: 8px;">
								</div>
								
								<div style="float:left;margin-left:5px;color:#606060;" ><%=SystemEnv.getHtmlLabelName( 32998 ,user.getLanguage())%></div>
								</div>
								
								</td>
								</tr>
								<tr style="background-color:#fff;height:0px">
								<td colspan="2">
								</td>
								</tr>
								<tr style="background-color:#fff;height:30px">
								<td colspan="2">
								<div class="titleclass titleselectdone "  val=1 >
								<div style="width:30px;height:30px;background-color:#A5A5A5;float:left;">
								<img border="0" src="/images/ecology8/meeting/done_wev8.png" style="margin-left: 8px;margin-top: 8px;">
								</div>
								
								<div style="float:left;margin-left:5px;color:#606060;" ><%=SystemEnv.getHtmlLabelName( 32999 ,user.getLanguage())%></div>
								</div>
								
								</td>
								</tr>
								<tr style="background-color:#fff;height:0px">
								<td colspan="2">
								</td>
								</tr>
								<tr style="background-color:#fff;height:30px">
								<td colspan="2">
								<div class="titleclass titleselectdoing" val=2 >
								<div style="width:30px;height:30px;background-color:#66CC66;float:left;">
								<img border="0" src="/images/ecology8/meeting/doing_wev8.png" style="margin-left: 7px;margin-top: 7px;">
								</div>
								
								<div style="float:left;margin-left:5px;color:#606060;"><%=SystemEnv.getHtmlLabelName( 33000 ,user.getLanguage())%></div>
								</div>
								
								</td>
								</tr>
								<tr style="background-color:#fff;height:0px">
								<td colspan="2">
								</td>
								</tr>
								<tr style="background-color:#fff;height:30px">
								<td colspan="2">
								<div class="titleclass titleselectnostart" val=3 >
								<div style="width:30px;height:30px;background-color:#C05046;float:left;">
								<img border="0" src="/images/ecology8/meeting/nostart_wev8.png" style="margin-left: 7px;margin-top: 7px;">
								</div>
								
								<div style="float:left;margin-left:5px;color:#606060;"><%=SystemEnv.getHtmlLabelName( 33001 ,user.getLanguage())%></div>
								</div>
								
								</td>
								</tr>
								
								</table>
								</div>
								</td>
								</tr>
								<tr>
									<td height="8px">
									</td>
								</tr>
								<tr>
									<td style="vertical-align: top;">
									<div style="overflow-y: visible;visibility:visible;border:#d0d0d0 1px solid;height:100%;padding:5px;margin-left:8px;margin-right:8px;background-color:#fff;">
									<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
									<tr style="background-color:#fff;">
										<td>
									<div id="reminddiv" style="position: relative;overflow-y: hidden;min-height:10px;">
									<div id="meetingCnt" name="meetingCnt" style="color:#b2b2b2;min-height:10px;">
										
									</div>
									</div>
										</td>
									</tr>
									</table>
									</div>
									 </td>
									</tr>
								</table>
							</div>
							<div id="perandorgdiv" style="display:none;">
							<table width=100% border="0" cellspacing="0" cellpadding="0" >
								<tr>
									<td>
									<div id="perandorgbtndiv" style="overflow-y: visible;visibility:visible;border:#d0d0d0 1px solid;height:100%;margin-left:8px;margin-right:8px;background-color:#fff;">
									<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
										<tr style="background-color:#fff;">
										<td colspan="2">
										<div id="percontentdiv" style="margin-top:0px;">
											<div id="changePerdiv" style="background-color:#d0d0d0;padding:5px;height:26px;">
											<brow:browser viewType="0" name="currentUser" browserValue='<%=""+user.getUID()%>' tempTitle='<%=SystemEnv.getHtmlLabelName(33210,user.getLanguage())%>'
											browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
											hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="170px" _callback="rsCallBk" _callbackParams=""
											completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
											browserSpanValue='<%=user.getUsername()%>' ></brow:browser>
											<div style="float:right;height:24px;line-height:28px;color:#fff;cursor: pointer;width:10px;padding-right:12px;padding-left:8px;background-color:#4fa7ff" title="<%=SystemEnv.getHtmlLabelName(2102,user.getLanguage())%>" onclick="showMyCalnedar()">
											<img border="0" src="/images/ecology8/meeting/reset_wev8.png" style="margin-left: 0px;margin-top: 4px;">
											</div>
											
										</div>
										<div id="treediv" style="padding-top:5px;padding-bottom:5px;min-height:400px;">
											<IFRAME name="persontree" id="persontree" src="/meeting/data/SubordinateTree.jsp?id=<%=user.getUID()%>" width="100%" height="100%" frameborder=no style="overflow-y: hidden;" scrolling=no >
											</IFRAME>
										</div>
										</td>
										</tr>
									</table>
									</div>
									</td>
								</tr>
							</table>
							</div>
							</td>
							</tr>
						</table>
						
					</td>
				</tr>
		        <tr>
				<td height="10px" colspan="2"></td>
				</tr>
	        </TBODY>
		</table> 
        </div>
  </div>
  <div id="subordinateDivList" >
  		<div class="title"></div>
		<ul class="list">
			
		</ul>
	</div>
	
	<div id="loadingpannel" class="loading" style="height:20px;position:absolute;top:0;right:0;background:rgb(217, 102, 102);"></div>

</body>
</html>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>

<script type="text/javascript">
function rsCallBk(event,id1,name,_callbackParams){
	if (id1){
		if(id1.id!="") {
			var id = wuiUtil.getJsonValueByIndex(id1,0);
			$("#currentUser").val(id);
			onUserSelected();
			showPersonTree(id);
		}
	}
}

$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if($(target).attr("id")!="currentUserspan"){
		$("#subordinateDivList").hide();
	}
});
document.oncontextmenu=function(){
	   return false;
	}
function expand(e){
	tg=e.target||e.srcElement;
	if($(tg).hasClass("expandUnClose")){
		$(tg).removeClass("expandUnClose");
	}else{
			$(tg).addClass("expandUnClose");
	}
}

function onShowResource(inputname,spanname){
	 linkurl="javaScript:openhrm(";
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	   if (datas) {
           if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
               alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>");
               return;
           }else  if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href=\"/hrm/resource/HrmResource.jsp?id="+ids[i]+"\"  target='_blank'>"+names[i]+"</a>&nbsp;";
				    	
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id.indexOf(",")!=0?datas.id:datas.id.substring(1));
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
}}
function onshowRequest(inputname,spanname){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href='/workflow/request/ViewRequest.jsp?requestid="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			$("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
		}
	}
}
function onShowProject(inputname,spanname){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href='/proj/data/ViewProject.jsp?ProjID="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			$("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
		}
	}
}
function onShowDoc(inputname,spanname){
			var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+$("input[name="+inputname+"]").val());
		if(data){
			if(data.id){
				ids = data.id.split(",");
			    names =data.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<A href='/docs/docs/DocDsp.jsp?id="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
			}else{
				$("#"+spanname).html("");
			    $("input[name="+inputname+"]").val("");
			}
		}	
}
function onshowCrms(inputname,spanname){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href=/CRM/data/ViewCustomer.jsp?CustomerID="+ids[i]+" target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			$("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
		}
	}	
	
}

function onTypeChange(){
	showTypeChange();
	changeType();
	$(".namespan").each(function() {
    	var namespan = $(this).text();
    	$(this).attr("title", namespan);
    	if(namespan.length > 8){
    		$(this).text(namespan.substring(0,8)+"...");
    	}
    })
	
	
}

function showTypeChange(){
	var thisvalue=jQuery("#selectType").val();
	if (thisvalue == 1) {
		jQuery($GetEle("departmentidSpan")).css("display","none");
		jQuery($GetEle("subidsSpan")).css("display","none");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("currentUser")).css("display","");
 		jQuery($GetEle("currentUserspan")).css("display","");
 		jQuery($GetEle("currentUserspan")).find("a").css("vertical-align","top");
 		jQuery($GetEle("currentUserBtn")).css("display","");
    }
	else if (thisvalue == 2) {
	    jQuery($GetEle("departmentidSpan")).css("display","");
 		jQuery($GetEle("departmentidSpan")).find("a").css("vertical-align","top");
		jQuery($GetEle("subidsSpan")).css("display","none");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","");
 		jQuery($GetEle("currentUser")).css("display","none");
 		jQuery($GetEle("currentUserspan")).css("display","none");
 		jQuery($GetEle("currentUserBtn")).css("display","none");
	}
	else if (thisvalue == 3) {
	    jQuery($GetEle("departmentidSpan")).css("display","none");
		jQuery($GetEle("subidsSpan")).css("display","");
 		jQuery($GetEle("showsubcompany")).css("display","");
 		jQuery($GetEle("subidsSpan")).find("a").css("vertical-align","top");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("currentUser")).css("display","none");
 		jQuery($GetEle("currentUserspan")).css("display","none");
 		jQuery($GetEle("currentUserBtn")).css("display","none");
	}
}

function changeType(){
	var thisvalue=jQuery("#selectType").val();
	if (thisvalue == 1) {
 		var id = jQuery($GetEle("currentUser")).val();
 		if(id != "" && id != null && id != "NULL" &&  id != "Null" &&  id != "null" && id > 0){
 			setUser(id);
 		}
    }
	else if (thisvalue == 2) {
 		var id = jQuery($GetEle("departmentid")).val();
 		if(id != "" && id != null && id != "NULL" &&  id != "Null" &&  id != "null" && id > 0){
 			setDept(id);
 		}
	}
	else if (thisvalue == 3) {
 		var id = jQuery($GetEle("subids")).val();
 		if(id != "" && id != null && id != "NULL" &&  id != "Null" &&  id != "null" && id > 0){
 			setSub(id);
 		}
	}
}


function setMeetingCnt(){
	  $.ajaxSetup ({ cache: false });
	  $("#meetingCnt").load("/meeting/data/getData.jsp?method=getNextMeeting&userid=<%=userid%>","",function(){
	  	if($("#sTime") && $("#sTime").val() != ""){
		  	var sTime = $("#sTime").val();
		  	if(sTime){
					var stime = Date.parse(sTime.replace(/-/g,   "/"));
					var startformat = getymformat(new Date(stime), null, true, true);
					var meetstime = dateFormat.call(new Date(stime), startformat)
					$("#showTime").html(meetstime);
					$("#reminddiv").perfectScrollbar();
				}
			}
		});
}

function getymformat(date, comparedate, isshowtime, isshowweek, showcompare) {
            var showyear = isshowtime != undefined ? (date.getFullYear() != new Date().getFullYear()) : true;
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


Date.prototype.format = function(format)   
{   
   var o = {   
     "M+" : this.getMonth()+1, //month   
     "d+" : this.getDate(),    //day   
     "h+" : this.getHours(),   //hour   
     "m+" : this.getMinutes(), //minute   
     "s+" : this.getSeconds(), //second   
     "q+" : Math.floor((this.getMonth()+3)/3), //quarter   
     "S" : this.getMilliseconds() //millisecond   
   }   
   if(/(y+)/.test(format)) format=format.replace(RegExp.$1,   
     (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
   for(var k in o)if(new RegExp("("+ k +")").test(format))   
     format = format.replace(RegExp.$1,   
       RegExp.$1.length==1 ? o[k] :    
         ("00"+ o[k]).substr((""+ o[k]).length));   
   return format;   
}

function showDlg(title,url,diag,_window)
            {
            if(diag){
            	diag.close();
            }
            
			diag.currentWindow = _window;
			diag.Width = 800;
			diag.Height = 550;
						diag.Modal = true;
						diag.maxiumnable = true;
						diag.Title = title;
						diag.URL = url;
						diag.show();
            } 

function setWindowSize(_document){
	if(!!_document)_document = document;
	var bodyheight = _document.body.offsetHeight;
	var listframeh = jQuery("#tablediv",window.frames["listframe"].document).height() + 10;
	//listframeh = 305;
	jQuery("#listframe").height(listframeh);
	var bottomheight = listframeh+2;
	//jQuery("#listdiv").height(listframeh+2);
	
}

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	dataRfsh();
}
function dataRfsh(){
	$("#gridcontainer").reload();
	$("#listframe")[0].contentWindow._table.reLoad();
}
function dataRfsh4List(){
	reloadList=false;
	$("#gridcontainer").reload();
}

</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
