
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:include page="/systeminfo/DatepickerLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<jsp:include page="/systeminfo/WdCalendarLangJs.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.Constants"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<html >
<head id="Head1">
	<%
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		String selectedUser=Util.null2String(request.getParameter("selectUser"));
		String fromES=Util.null2String(request.getParameter("fromES"));//从微搜进入,查看更多
		if("".equals(selectedUser)){
			selectedUser=""+user.getUID();
		}
		String selectedUserName=ResourceComInfo.getFirstname(selectedUser);
		
		int isfromrdeploy=Util.getIntValue(request.getParameter("isfromrdeploy"),0);//来自快速部署
		List workPlanTypeForNewList=new ArrayList();
		recordSet.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
		while(recordSet.next()){
			Map item=new HashMap();
			item.put("id",recordSet.getString("workPlanTypeID"));
			item.put("name",recordSet.getString("workPlanTypeName"));
			workPlanTypeForNewList.add(item);
		}
		List workPanTypeList=new ArrayList();
		recordSet.executeSql("SELECT * FROM WorkPlanType WHERE available = '1' ORDER BY displayOrder ASC");
		while(recordSet.next()){
			Map item=new HashMap();
			item.put("id",recordSet.getString("workPlanTypeID"));
			item.put("name",recordSet.getString("workPlanTypeName"));
			workPanTypeList.add(item);
		}
		
		int timeRangeStart=0;
		int timeRangeEnd=23;
		recordSet.executeSql("select * from WorkPlanSet order by id");
		if(recordSet.next()){
			timeRangeStart	= Util.getIntValue(recordSet.getString("timeRangeStart"), 0);
			timeRangeEnd	= Util.getIntValue(recordSet.getString("timeRangeEnd"), 23);
		}
		String sTime=(timeRangeStart<10?"0"+timeRangeStart:timeRangeStart)+":00";
		String eTime=(timeRangeEnd<10?"0"+timeRangeEnd:timeRangeEnd)+":59";
		
		String isShare=Util.null2String(request.getParameter("isShare"));
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <%if(isfromrdeploy == 1){ %>
    <link rel="stylesheet" href="/rdeploy/assets/css/workplan/workplanshow.css" type="text/css">
    <%} %>
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
	 <link href="/workplan/calendar/css/editbox_wev8.css" rel="stylesheet" type="text/css" /> 
   
	<script src="/js/ecology8/request/titleCommon_wev8.js" type="text/javascript"></script>
    <script src="/workplan/calendar/src/Plugins/Common_wev8.js" type="text/javascript"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript" src="/workplan/calendar/src/jquery.messager_wev8.js"></script>
	
    <script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>


    <script src="/workplan/calendar/src/Plugins/jquery.calendar_wev8.js" type="text/javascript"></script>   
    <script type="/js/jquery/ui/ui.dialog_wev8.js"  type="text/javascript"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/workplan/workplan_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
	<script src="/workplan/calendar/src/Plugins/json2_wev8.js" type="text/javascript"></script>
<script type="text/javascript">
var diag_vote;
var selectedUser="<%=selectedUser%>";
var selectedUserName="<%=ResourceComInfo.getLastname(selectedUser)%>";
var isShare="<%=Util.null2String(request.getParameter("isShare"))%>";
var workPlanType="";
var workPlanTypeForNewList=<%=JSONArray.fromObject(workPlanTypeForNewList).toString()%>;
var workPanTypeList=<%=JSONArray.fromObject(workPanTypeList).toString()%>;
var dialog2=new window.top.Dialog();
dialog2.currentWindow = window;
dialog2.ID="shareEvent";
dialog2.checkDataChange=false;
var dialog=new window.top.Dialog();
dialog.currentWindow = window;
dialog.ID="shareEventID";
dialog.checkDataChange=false;
//dialog.InvokeElementId="editBox";

var viewCalendarDialog=new window.top.Dialog();
viewCalendarDialog.currentWindow = window;
viewCalendarDialog.ID="viewCalendarDialog";
//viewCalendarDialog.InvokeElementId="workPlanViewSplash";
viewCalendarDialog.Height="400";
viewCalendarDialog.checkDataChange = false;

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
		border-bottom: 1px solid #59b0f2;
		
	}
	
	#weekViewAllDaywkBox{
        max-height:100px;
		overflow-y:scroll;
	}
	
	
	.Line{
		padding:0px;
	}
	TABLE.ViewForm TD {
		padding-left: 5px;
		vertical-align: middle !important;
	}
	.tg-col{
		border-bottom: 1px solid #ddd
	}
	
	<%if(isfromrdeploy == 1){%>
	.tg-dualmarker{
	  height: 20px;
	  line-height: 20px;
	  margin-bottom: 20px;
	}
	<%}%>
	
</style>

   <script type="text/javascript">
        $(document).ready(function() {     
           var view="week";          
           var isSubmit=false;
            var timeRangeStart=parseInt("<%=timeRangeStart%>");
			var timeRangeEnd=parseInt("<%=timeRangeEnd%>")+1;
            var DATA_FEED_URL = "/workplan/calendar/data/getData.jsp";
            var DATA_EIDT_URL = "/workplan/data/WorkPlanEdit.jsp";
            var DATA_VIEW_URL = "/workplan/data/WorkPlanDetail.jsp";
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
                autoload:true,
                defBgTime:timeRangeStart,
				defEdTime:timeRangeEnd,
				defBgTimeStr:"<%=sTime%>",
				defEdTimestr:"<%=eTime%>", 
                selectedUser:selectedUser,//指定当前选定的人员
                isShare:isShare,//（isShare：1 显示“所有日程”，其他：显示“我的日程”
                workPlanType:workPlanType,
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
            var _MH = document.documentElement.clientHeight;
            var dvH = $dv.height() + $dv.offset().top+10+2;
            op.height = _MH - dvH-18;
            op.eventItems =[];

            var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
            if (p && p.datestrshow) {
                $("#txtdatetimeshow").text(p.datestrshow);
            }
            //显示时间控件 
            $("#hdtxtshow").datepickernew({ picker: "#txtdatetimeshow", showtarget: $("#txtdatetimeshow"),
            onReturn:function(r){                      
                		   
                        var p = $("#gridcontainer").gotoDate(r).BcalGetOp();
                        if (p && p.datestrshow) {
                            $("#txtdatetimeshow").text(p.datestrshow);
                        }
                 } 
            });
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
                $("#calendarBtns").hide();
               	$("#crmTools").hide();
               
           	 	dialog.Width=600;
           	 	dialog.Height=550;
           	 	dialog.OnLoad=function(){
           	 
                 };
                if(data)
                {
                	
                    if(data[0]=="0"){
                    	NewEvent(data);
                    }else{
                    	dialog.URL = DATA_EIDT_URL+"?workid="+data[0];
		            	dialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"
		           	    dialog.show();
                    	/*
                    	var param={
                    			id:data[0]
                    		};
                    	p.onBeforeRequestData && p.onBeforeRequestData(1);
                    	$.post(p.getEventItemUrl+p.selectedUser,param,function(data){
                        	var calendarEvent=new WorkPlanEvent(data);
                        	calendarEvent.FillWorkPlanView();
                        	 $("#editBox").css("visibility","visible");
                        	 p.onAfterRequestData && p.onAfterRequestData(1);
                        	 if(data.shareLevel>1){
                            		dialog.OKEvent=function(){
                            			//$("#saveBtn").click();
										saveWorkPlan(isSubmit,p);
                            			
                                	};
									 dialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"
                            		 dialog.show();
                            		 dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>";
                            		 dialog.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
                             }else{
                              }
                        	
                        },"json");
                        */
                    }
                   
                }
            } 
			function NewEvent(data){
				/*
				var calendar1=new WorkPlanEvent({});
            	calendar1.clearWorkPlanView();
                $("input[name=eventId]").val(data[0]);
                $("#planName").val(data[1]);
                if(data[1]){
                	$("#planName").next().hide();	
                  }else{
                	  $("#planName").show();
                    }
                $("#beginDate").val(data[2]);
                $("#beginTime").val(data[3]);
                $("#endDate").val(data[4]);
                $("#endTime").val(data[5]);
                $("#beginDateSpan").text(data[2]);
                $("#beginTimeSpan").text(data[3]);
                $("#endDateSpan").text(data[4]);
                $("#endTimeSpan").text(data[5]);
                $("#memberIDs").val($("#currentUser").val());
            	$("#memberIDsSpan").text($("#currentUserSpan").text());
           	 	$("#remindInfo").hide();
           	 $("#editBox input").attr("disabled",false);
 			$("#editBox select").attr("disabled",false);
 			$("#editBox textarea").attr("disabled",false);
 			$("#editBox button").show();
 			
           	 	dialog.OKEvent=function(){
        			//$("#saveBtn").click();
					saveWorkPlan(isSubmit,p);
            	};
            	*/
            	var p = $("#gridcontainer").BcalGetOp();
            	dialog.URL = DATA_EIDT_URL+"?selectUser="+p.selectedUser+"&planName="+data[1]+"&beginDate="+data[2]+"&beginTime="+data[3]+"&endDate="+data[4]+"&endTime="+data[5];
            	dialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"
           	    dialog.show();	
           	    //dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%> "
           	    	//$("#editBox").css("visibility","visible");
           	    //dialog.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
			}

            function View(data0)
            {
            	viewCalendarDialog.Width=600;
            	viewCalendarDialog.Height=550;
				viewCalendarDialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>"
                var p = $("#gridcontainer").BcalGetOp();
                var param={
            			id:data0[0]
            		};
            		
            	
            	viewCalendarDialog.URL = DATA_VIEW_URL+"?workid="+data0[0];
            	viewCalendarDialog.show();
            	/*
            	p.onBeforeRequestData && p.onBeforeRequestData(1);
            	$.post(p.getEventItemUrl+p.selectedUser+"&operation=view",param,function(data){
            		
                	var canFinish=false;//是否可以结束日程
                	var canEdit=false;//是否可以编辑日程
                	var canView=false;//是否可以查看日程
                	var canValuate=false;//是否可以共享日程
                	var inMember=false;//是否是接收人
                	var memversIdsArr=data.executeId.split(",")
                	for(var i=0;i<memversIdsArr.length;i++){
						if(memversIdsArr[i]==selectedUser){
							inMember=true;
							break;
						}
                    }
                	if(data&&data.id){
                		canView=true;
                		if(data.shareLevel=="2"){
							canEdit=true;
                        }
                        if(data.status!="0"){
							canEdit=false;
                         }
                        if(data.status=="0"&&(canEdit||inMember)){
                        	canFinish=true;		
                         }
                        
                    }
                    
                	p.onAfterRequestData && p.onAfterRequestData(1);
               	 var calendarEvent=new WorkPlanEvent(data);
               	 if(canView){
               		calendarEvent.FillWorkPlanViewSplash();
               		
               	 }else{
                   	 Dialog.alert("<%=SystemEnv.getHtmlLabelName(30816,user.getLanguage())%>");
					return;
                  }
                 
                    if(canFinish){
                    	viewCalendarDialog.OKEvent=function(){
                   			//$("#EndEventBtns").click();
							EndEventBtnsClick(p);
                       	};
                       	
                       	viewCalendarDialog.show();
                       	viewCalendarDialog.okButton.value="<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>";
                       	viewCalendarDialog.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
                    }
                    if(!canFinish){
                    	viewCalendarDialog.OKEvent=function(){
                   			Dialog.close();
                       	};
                    	viewCalendarDialog.show();
                    	$("#_ButtonCancel_viewCalendarDialog").hide();
                    }
                    if(canEdit){
                    	var editbtn = viewCalendarDialog.addButton("editBtn","<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>",function(){
							Dialog.close();
								Edit([data.id]);
							
                         });
						 editbtn.className = "zd_btn_submit";
						//setTimeout(function(){jQuery("#"+editBtn.id).addClass("e8_btn_submit");}, 100);
                    	var delbtn = viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>",function(){
          					//$("#DeleteBtn").click();
							DeleteBtnClick(p);
                     	});
						delbtn.className = "zd_btn_submit";
                    }
                    if(data.canShare=="true"){
                    	var sharebtn = viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%> ","<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%> ",function(){
							viewCalendarDialog.close();
            					dialog2.InvokeElementId="workPlanShareSplash";
								dialog2.title="<%=SystemEnv.getHtmlLabelName(20190,user.getLanguage()) %>";
            					fillShare(data.id);
            					if(data.shareLevel>1){
            					
                     			}
                     			dialog2.Width=500;
            	                dialog2.Height=450;
								dialog2.ShowButtonRow=true;
            					dialog2.show();
								dialog2.cancelButton.value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>";
								dialog2.okButton.style.display="none";
								//var diag_vote;
								//if(window.top.Dialog){
								//	diag_vote = new window.top.Dialog();
								//} else {
								//	diag_vote = new Dialog();
								//}
								//diag_vote.currentWindow = window;
								//diag_vote.Width = 500;
								//diag_vote.Height = 450;
								//diag_vote.Modal = true;
								//diag_vote.maxiumnable = true;
								//diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(20190,user.getLanguage()) %>";
								//diag_vote.URL = "/workplan/share/WorkPlanShare.jsp?planID="+data.id;
								//diag_vote.show();
                         	 });
						sharebtn.className = "zd_btn_submit";
            			 
                    }
					
                   	setBtnHoverClass();
            	},"json");
            	*/
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
               
            }
            function cal_onerror(type,data)
            {
                $("#errorpannel").show();
            }
              
            
          
            function wtd(p)
            {
               if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
                $("div.txtbtncls").each(function() {
                    $(this).removeClass("txtbtncls");
					$(this).addClass("txtbtnnoselcls");
                })
				$("#showdaybtn").removeClass("txtbtnnoselcls");
                $("#showdaybtn").addClass("txtbtncls");
				
            }
            //to show day view
            $("#showdaybtn").click(function(e) {
                //document.location.href="#day";
                $("div.txtbtncls").each(function() {
                    $(this).removeClass("txtbtncls");
					$(this).addClass("txtbtnnoselcls");
                })
				$(this).removeClass("txtbtnnoselcls");
                $(this).addClass("txtbtncls");
                var p = $("#gridcontainer").swtichView("day").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
				
				$("#showtodaybtn").attr("title","<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%> ");
				$("#txtdatetimeshow").attr("selectMode", '0');
			});
            //to show week view
            $("#showweekbtn").click(function(e) {
                //document.location.href="#week";
                $("div.txtbtncls").each(function() {
                    $(this).removeClass("txtbtncls");
					$(this).addClass("txtbtnnoselcls");
                })
				$(this).removeClass("txtbtnnoselcls");
                $(this).addClass("txtbtncls");
                var p = $("#gridcontainer").swtichView("week").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

				$("#showtodaybtn").attr("title","<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%> ");
				$("#txtdatetimeshow").attr("selectMode", '0');
            });
            //to show month view
            $("#showmonthbtn").click(function(e) {
                //document.location.href="#month";
                $(".txtbtncls").each(function() {
                    $(this).removeClass("txtbtncls");
					$(this).addClass("txtbtnnoselcls");
                })
				$(this).removeClass("txtbtnnoselcls");
                $(this).addClass("txtbtncls");
                var p = $("#gridcontainer").swtichView("month").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

				$("#showtodaybtn").attr("title","<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%> ");
				$("#txtdatetimeshow").attr("selectMode", '1');
			});
            //refresh current View
            $("#showreflashbtn").click(function(e){
            	 $("#gridcontainer").reload();
            });
            
            //Add a new event
            $("#faddbtn").click(function(e) {
            	var calendar= new WorkPlanEvent({});
            	calendar.clearWorkPlanView();
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
                }
            });
            //previous date range
            $("#sfprevbtn").click(function(e) {
                var p = $("#gridcontainer").previousRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            //next date range
            $("#sfnextbtn").click(function(e) {
                var p = $("#gridcontainer").nextRange().BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            
            $("#showModelbtn").click(function(e) {
                 location.href='/workplan/data/WorkPlanViewList.jsp?isShare='+isShare;
            });
            $("#importbtn").click(function(e) {
                ImportWorkPlan();
            });
            $("#cancelEditBtn").click(function(E){
                $("#editBox").css("visibility","hidden");
                $("#editButtons").hide();
                $("#calendarBtns").show();
                });
            $("#saveBtn").click(function(e){
            	
                saveWorkPlan(isSubmit,p);
            });
            $("#DeleteBtn").click(function(){
            	DeleteBtnClick(p);
             });
            $("#EndEventBtns").live("click",function(){
				EndEventBtnsClick(p);
             });
            $("#currentUserSpan").live("click",function(e){
				if($("#subordinateDivList").css("display")=="none"){
					$("#subordinateDivList").show();
				}else{
					$("#subordinateDivList").hide();
					return;
				}
				$("#subordinateDivList").css({
						"left":$(this).offset().left-$("#subordinateDivList").width()+$(this).width()+"px",
						"top":$(this).offset().top+$(this).height()+"px",
                        "overflow-y":"scroll",
                        "height":"400px"
					});
             });
            setUser(selectedUser);


		    $("#showweekbtn").trigger("click");
			
           jQuery("#scrollbardiv").perfectScrollbar();
		   
		   jQuery("div#editBox TABLE.LayoutTable TD").attr("align","left");
		   jQuery("div#workPlanViewSplash TABLE.LayoutTable TD").attr("align","left");
		   jQuery("div#workPlanShareSetSplash TABLE.LayoutTable TD").attr("align","left");
		   
			var tree_div_height = $("#dvCalMain").height() - $("#changePerdiv").height() - 10 - 10 - 8;
			$("#treediv").height(tree_div_height);
			
			 window.setInterval("getNewMessage()",300000);
			 getNewMessage();
		   
		   p = $("#gridcontainer").gotoDate().BcalGetOp();
            if (p && p.datestrshow) {
                $("#txtdatetimeshow").text(p.datestrshow);
				$("#txtdatetimeshow").css("display","");
            }
        });
		
		function DeleteBtnClick(p){
			Dialog.confirm(
				"<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
					var workplanId=$("#workplanIdView").val();
					try{
						workplanId=parseInt(workplanId);
					 }catch (e) {
						 workplanId=0;
					}
					 
					if(workplanId>0){
						
						var param={id:workplanId};
						$.post(p.quickDeleteUrl+p.selectedUser+"&isShare="+p.isShare,param,function(data){
							if(data.IsSuccess){
								$("#gridcontainer").reload();
								$("#editBox").css("visibility","hidden");
								$("#cancelEditBtn").click();
								Dialog.close()
							}
						},"json");
					}else{
					}
				}, function () {}, 220, 90,false
			);
		}
		
		function EndEventBtnsClick(p){
			var workplanId=$("#workplanIdView").val();
			try{
				workplanId=parseInt(workplanId);
			 }catch (e) {
				 workplanId=0;
			}
				if(workplanId>0){
				var param={id:workplanId};
				$.post(p.overCalendarItemUrl+p.selectedUser+"&isShare="+p.isShare,param,function(data){
					if(data.IsSuccess){
						$("#gridcontainer").reload();
						$("#editBox").css("visibility","hidden");
						$("#cancelEditBtn").click();
						Dialog.close()
					}else{
					}
				},"json");
				}else{
				}
		}
		
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
			 if(userID==$("#currentUser").val()){
				
			 }else {;
				setCurrentUser(selectedUser, selectedUserName);
			}
        	setUser(userID);
        }
        function onCurrentUserChange(){
        }
        function showMyCalnedar(){
        	setUser(selectedUser);
         }
        function subordinateDivListSelected(userid,userName){
			$("#currentUserSpan").text(userName);
			$("#currentUser").val(userid);
			setUser(userid);
			$("#subordinateDivList").hide();
			
         }
        function setUser(userID){
        	var p = $("#gridcontainer").BcalGetOp();
			var  selectedUser1=userID;
			 p.selectedUser=userID;
			 var param={"userId":userID};
			 $.post(p.getSubordinateUrl,param,function(data){
					if(data){

						$("#subordinateDivList .title").text($("#currentUserSpan").text()+"<%=SystemEnv.getHtmlLabelName(30805,user.getLanguage())%>:");
			        	
					}
					 $("#gridcontainer").reload();
				},"json");
			
			 
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
                            Dialog.alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())%>！");
                            return false;
                        }
                    }  else if(enddate<begindate){
                        Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
                        return false;
                    }
                }   else if(enddate!=null &&enddate !="" && (endtime==""||endtime==null) ){
                    if(enddate<begindate){
                        Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
                        return false;
                    }else{
                        $("#endTime").val("23:59");
                    }
                }   else if((enddate==null || enddate=="") && endtime !=null && endtime!="" ){
                    Dialog.alert("<%=SystemEnv.getHtmlLabelName(24462,user.getLanguage())%>！");
                    return false;
                }

            }  else{
                Dialog.alert("<%=SystemEnv.getHtmlLabelName(32950,user.getLanguage())%>！");
                return false;
            }
            return true;

        }
		
		function getNewMessage(){
			$.post("/workplan/calendar/data/getData.jsp",{method:"getNewDisMsg"},function(data){
				if(data && data != null && data.count != null){
					if(data.count > 0){
						var msgctt = "<table style='width:100%'>";
						var msgs = data.msgs;
						var i = 0;
						for(;i < msgs.length && i < 5 ; i++ ){
						    msgctt +="<tr><td>";
						    msgctt +="<a href=javaScript:openhrm(" + msgs[i][1] + "); onclick='pointerXY(event);'>" + msgs[i][2] + "</a>&nbsp;";
							msgctt +="<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>&nbsp;" + msgs[i][3] + ":" +  msgs[i][4]+"</td><td><a href='javaScript:void();' onclick=viewNew('"+msgs[i][0]+"');><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>";
							msgctt +="<td></td></tr>";
						}
						if(msgs.length > 5){
							msgctt +="<tr><td></td><td></td><td><a href='/workplan/search/WorkPlanDiscussTab.jsp'><%=SystemEnv.getHtmlLabelName(20234,user.getLanguage())%></a></td></tr>";

						}
						msgctt +="</table>";
						var dheight = 63 + i*20;
						$.messager.lays($("#gridcontainer").width(), dheight);
						$.messager.show('<font color=#606060><%=SystemEnv.getHtmlLabelName(83512,user.getLanguage())%></font>', msgctt, 5000);
					}
				}
			},"json");
		}
		
		function viewNew(id){
			if(window.top.Dialog){
				diag_vote = new window.top.Dialog();
			} else {
				diag_vote = new Dialog();
			}
			diag_vote.currentWindow = window;
			diag_vote.Width = 800;
			diag_vote.Height = 600;
			diag_vote.Modal = true;
			diag_vote.maxiumnable = true;
			diag_vote.checkDataChange = false;
			diag_vote.isIframe=false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
			diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?workid=" + id ;
			diag_vote.show();
			
		}
		
		
		function ImportWorkPlan(){
			diag_vote = new Dialog();
			diag_vote.currentWindow = window;
			diag_vote.Width = 600;
			diag_vote.Height = 600;
			diag_vote.Modal = true;
			diag_vote.maxiumnable = false;
			diag_vote.checkDataChange = false;
			diag_vote.isIframe=false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>";
			diag_vote.URL = "/workplan/config/import/WorkplanImport.jsp";
			diag_vote.show();
		}
       
    </script>    

</head>
<%
      String addBtnUrl="/workplan/calendar/css/images/icons/addBtn_wev8.png";
	  if(user.getLanguage()==8){
		  addBtnUrl="/workplan/calendar/css/images/icons/addBtn_EN_wev8.png";
	  }
%>
<body scroll="no">

	
    <div style="overflow:auto;">
		<div id="calhead" class="calHd" style="height:34px;padding-left:0px;min-width:920px !important;background-color: #f7f7f7;border-bottom: 1px solid #ddd;">
      		<div  id="firstButtons" style="float:left;min-width:60px !important;">
      			<div id="faddbtn" class="calHdBtn faddbtn" title="<%=SystemEnv.getHtmlLabelName( 18481 ,user.getLanguage())%>" style="margin-left:10px;border:none;height:25px;">
      			</div>
      			<div id="importbtn" class="calHdBtn importbtn" title="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) %>" style="margin-left:10px;border:none;height:25px;">
      			</div>
				<div class="rightBorder" style="margin-left: 10px;margin-right: 10px;" >|</div>
      		</div>
			<div id="editButtons2" style="float:left;min-width:60px !important;">
		      		  <%if(user.getLanguage()==8) {%>
      		    <div id="showdaybtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%>" class="calHdBtn     txtbtnnoselcls" style="margin-left:0px;width:30px;font-size: 15px;">
	      			D
	      		</div>
	      		<div id="showweekbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> " class="calHdBtn   txtbtncls" style="border-left:none;width:30px;font-size: 15px;">
	      			W
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%>" class="calHdBtn   txtbtnnoselcls" style="border-left:none;width:30px;font-size: 15px;">
	      			M
	      		</div>
      		    <%} else { %>
            	<div id="showdaybtn" unselectable="on" class="calHdBtn txtbtnnoselcls" style="margin-left:0px;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showweekbtn" unselectable="on" class="calHdBtn txtbtncls" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHdBtn txtbtnnoselcls" style="border-left:none;width:30px;font-size: 15px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> 
	      		</div>
	      		<%} %>
					<div id="showreflashbtn" unselectable="on" class="calHdBtn showreflashbtn" title="<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%>" style="height:24px;border:none;margin-left:10px;border:none;">
					</div>
					<div class="rightBorder" style="margin-left:10px">|</div>
               </div>
			<div id="editButtons1" style="float:left;min-width:122px !important;">
					<div id="showtodaybtn" unselectable="on" class="calHdBtn showtodaybtn" title="" style="height:24px;margin-left:0px;border:none;">
		      			 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHdBtn sfprevbtn" title="<%=SystemEnv.getHtmlLabelName( 33960 ,user.getLanguage()) %>"  style="height:24px;border:none;margin-left:10px;width:23px;_width:25px;">
		      		</div>
					<input type="hidden" name="txtshow" id="hdtxtshow" />
					<div id="txtdatetimeshow" unselectable="on" class="calHdBtn txtbtn" style="border:none;width:auto;padding-left:1px;padding-right:10px;">
						
					</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHdBtn sfnextbtn" title="<%=SystemEnv.getHtmlLabelName( 33961 ,user.getLanguage()) %>"  style="height:24px;border:none;border-left:none;width:23px;_width:25px;">
		      		</div>
		      		<%if("1".equals(isShare)&&!"1".equals(fromES)){ %>
		      		<div id="showModelbtn" unselectable="on" title="<%=SystemEnv.getHtmlLabelName( 33962 ,user.getLanguage()) %>" val="0" class="calHdBtn showModelbtn" style="margin-left:0px;border:none;height:24px;">
					</div>
					<%} %>
					
					<div style="float:left;margin-top: 5px; width: 320px;">  	
						<span style="float:left;line-height:24px;margin-right:5px;margin-left:25px; max-width:160px;white-space: nowrap;" title="<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></span>
						<SELECT id="workPlanType" name="workPlanType" onchange="changeWorkPlanType()" style="width:80px">
							<OPTION value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
			  				<%
			  				recordSet.executeSql("SELECT * FROM WorkPlanType WHERE 1=1 and available=1 ORDER BY displayOrder ASC");
				  			while(recordSet.next()){
					  			%>
					  			<OPTION value="<%= recordSet.getInt("workPlanTypeID") %>"><%=Util.forHtml(recordSet.getString("workPlanTypeName")) %></OPTION>
					  			<%
					  			}
					  			%>
				  		</SELECT>
					</div>
				</div>
      </div>
      <div style="min-width:920px !important;padding:0px;background-color: #f7f7f7;vertical-align: top;">
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<COLGROUP>
				<COL width="">
				<% if(isfromrdeploy == 1){%>
				<COL width='<%="1".equals(fromES)?"0":"145" %>'>
				<% }else{%>
				<COL width="<%="1".equals(fromES)?"0":"230" %>">
				<% }%>
				
			<TBODY>
				
				<tr>
				<td valign="top" >
					<div id="dvCalMain" class="calmain printborder" style="position:relative">
						<div id="gridcontainer" style="overflow-y: visible;visibility:visible">
						</div>
						
					</div>
				</td>
					<td valign="top" style="border-left:#d0d0d0 1px solid;border-right:#d0d0d0 1px solid;border-bottom:#d0d0d0 1px solid;background-color:#f7f7f7;">
						<table width=100% border="0" cellspacing="0" cellpadding="0" >
							<tr>
							<td>
							<div id="perandorgdiv" style='display:<%="1".equals(fromES)?"none":"" %>'>
							<table width=100% border="0" cellspacing="0" cellpadding="0" >
								<tr>
									<td>
									<% if(isfromrdeploy == 1){%>
									<div id="perandorgbtndiv" style="overflow-y: visible;visibility:visible;height:100%;background-color:#fff;">
									<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
										<tr style="background-color:#fff;">
										<td colspan="2">
										<div id="percontentdiv" >
											<div style="background:#f2f2f2;height:45px;">
												<div style="height:7px;width:1px;"></div>
												<div id="changePerdiv" style="margin-left:7px;width:127px;height:30px;border:1px solid #e9e9e9;background:#ffffff;">
												<brow:browser viewType="0" name="currentUser" browserValue='<%=""+user.getUID()%>' tempTitle="<%=SystemEnv.getHtmlLabelName(33210,user.getLanguage())%>"
												browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
												hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="117px" _callback="rsCallBk" _callbackParams=""
												completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
												browserSpanValue="<%=user.getUsername()%>" ></brow:browser>
												</div>
											</div>
											<div id="treediv" style="min-height:400px;">
												<IFRAME name="persontree" id="persontree" src="/rdeploy/chatproject/workplan/SubordinateTree.jsp?id=<%=user.getUID()%>" width="100%" height="100%" frameborder=no style="overflow-y: hidden;" scrolling=no >
												</IFRAME>
											</div>
										</div>
										</td>
										</tr>
									</table>
									</div>
									<%}else{ %>
									<div id="perandorgbtndiv" style="overflow-y: visible;visibility:visible;border:#d0d0d0 1px solid;height:100%;margin-left:8px;margin-right:8px;background-color:#fff;">
									<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
										<tr style="background-color:#fff;">
										<td colspan="2">
										<div id="percontentdiv" style="margin-top:0px;">
											<div id="changePerdiv" style="background-color:#d0d0d0;padding:5px;height:26px;">
											<brow:browser viewType="0" name="currentUser" browserValue='<%=""+user.getUID()%>' tempTitle='<%=SystemEnv.getHtmlLabelName(33210,user.getLanguage())%>'
											browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
											hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="167px" _callback="rsCallBk" _callbackParams=""
											completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
											browserSpanValue='<%=user.getUsername()%>' ></brow:browser>
											<div style="float:right;height:24px;line-height:28px;color:#fff;cursor: pointer;width:10px;padding-right:12px;padding-left:8px;background-color:#4fa7ff" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>" onclick="showMyCalnedar()">
											<img border="0" src="/images/ecology8/meeting/reset_wev8.png" style="margin-left: 0px;margin-top: 4px;">
											</div>
											
											</div>
											<div id="treediv" style="padding-top:5px;padding-bottom:5px;min-height:400px;">
												<IFRAME name="persontree" id="persontree" src="/meeting/data/SubordinateTree.jsp?id=<%=user.getUID()%>" width="100%" height="100%" frameborder=no style="overflow-y: hidden;" scrolling=no >
												</IFRAME>
											</div>
										</div>
										</td>
										</tr>
									</table>
									</div>
									<%} %>
									
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
<script type="text/javascript">
$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if($(target).attr("id")!="currentUserSpan"){
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
               Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>");
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

function showPersonTree(id){
	<%if(isfromrdeploy == 1){%>
	$("#persontree").attr("src","/rdeploy/chatproject/workplan/SubordinateTree.jsp?id="+id);
	<%}else{%>
	$("#persontree").attr("src","/meeting/data/SubordinateTree.jsp?id="+id);
	<%}%>
}

function showMyCalnedar(){
	setUser(selectedUser);
	jQuery("#selectType").val("1");
	setCurrentUser(selectedUser, selectedUserName);
	showPersonTree(<%=user.getUID()%>);
	
 }

function setCurrentUser(userid, username){
	_writeBackData("currentUser",1,{id:userid,name:"<a href='javascript:openhrm("+userid+");' onclick='pointerXY(event);'> "+username+"</a>"},{
			hasInput:true,
			replace:true,
			isSingle:true,
			isedit:true
		});
}
 
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

  
function saveWorkPlan(isSubmit,p){
	if(!validateForm()){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
			return;
		}
		if(!checkDateVali()){
			return;
		}
		if(isSubmit){ //避免重复提交
			return ;
		}else
			isSubmit=true;
		
		var data={};
		var calendar=new WorkPlanEvent({});
		calendar.generateData(data);
		var url=(data.id==""||data.id=="0")?p.quickAddUrl:p.updateEvent;
		p.onBeforeRequestData && p.onBeforeRequestData(2);
		$.post(url+p.selectedUser+"&isShare="+p.isShare,data,function(dataBack){
				$("#cancelEditBtn").click();
				
				$("#editBox").css("visibility","hidden");
				$("#showreflashbtn").click();
				p.onAfterRequestData && p.onAfterRequestData(2);
				isSubmit=false;
				Dialog.close();
		},"json");
}

function closeDlgAndRfsh(){
	$("#gridcontainer").reload();
	try{
	Dialog.close();
	}catch(e){}
	try{
	diag_vote.close();
	}catch(e){}
	try{
	dialog.close();
	}catch(e){}
	try{
	viewCalendarDialog.close();
	}catch(e){}
}

function refreshCal(){
	$("#gridcontainer").reload();
}

function showLocation(gps,nowtime){
		
		var diag = new Dialog();
	    diag.Modal = true;
	    diag.Drag=true;
		diag.Width = 620;
		diag.Height = 420;
		diag.ShowButtonRow=false;
		diag.Title ='<%=SystemEnv.getHtmlLabelNames("82639,33555",user.getLanguage())%>';

		diag.URL = "/mobile/plugin/crm/CrmShowLocation.jsp?gps="+gps+"&nowtime="+nowtime; 
	    diag.show();
	    
	    return false;
}
function onShowHrmResource(spanname,inputname, isMuti, ismand) {
	var tmpids = jQuery("#"+inputname).val();
	if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
		 tmpids = "";
	}
	var url = "";
	if(isMuti == 0){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	}
	
	var id = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	//var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value, "", "dialogWidth:550px;dialogHeight:550px;")
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id, 1);
			var sHtml = ""

			if(isMuti == 1){
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
			}
			var tlinkurl = "";
			var resourceIdArray = resourceids.split(",");
			var resourceNameArray = resourcename.split(",");
			for (var _i=0; _i<resourceIdArray.length; _i++) {
				var curid = resourceIdArray[_i];
				var curname = resourceNameArray[_i];

				if (tlinkurl != "/hrm/resource/HrmResource.jsp?id=") {
					sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
				} else {
					sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp;";
				}
			}
					
			jQuery("#"+spanname).html(sHtml);
			jQuery("#"+inputname).val(resourceids);
		} else {
			if (ismand == 0) {
 				jQuery("#"+spanname).html("");
 			} else {
 				jQuery("#"+spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
 			}
			jQuery("#"+inputname).val("");
		}
	 return true;
	}
	return false;
}

function changeWorkPlanType(){
	var p = $("#gridcontainer").BcalGetOp();
	var workplanType=$("#workPlanType").val();
	p.eventItems=[];//清空现有数据
	p.workPlanType=workplanType;
	$("#gridcontainer").reload();//根据类型重新加载
}
</script>

