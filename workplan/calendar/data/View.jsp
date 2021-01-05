
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="weaver.Constants"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%><html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
	<%
		String curTheme=(String)session.getAttribute("SESSION_TEMP_CURRENT_THEME");
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		String selectedUser=Util.null2String(request.getParameter("selectUser"));
		if("".equals(selectedUser)){
			selectedUser=""+user.getUID();
		}
		String selectedUserName=ResourceComInfo.getFirstname(selectedUser);
		
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
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/editbox_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
    <script src="/workplan/calendar/src/jquery_wev8.js" type="text/javascript"></script>  
    
    <script src="/workplan/calendar/src/Plugins/Common_wev8.js" type="text/javascript"></script>    
    <script src="/workplan/calendar/src/Plugins/datepicker_lang_zh_wev8.js" type="text/javascript"></script>     
    <script src="/workplan/calendar/src/Plugins/jquery.datepicker_wev8.js" type="text/javascript"></script>

    <script src="/workplan/calendar/src/Plugins/jquery.alert_wev8.js" type="text/javascript"></script>    
    <script src="/workplan/calendar/src/Plugins/jquery.ifrmdailog_wev8.js" defer="defer" type="text/javascript"></script>
    <script src="/workplan/calendar/src/Plugins/wdCalendar_lang_zh_wev8.js" type="text/javascript"></script>    
    <script src="/workplan/calendar/src/Plugins/jquery.calendar_wev8.js" type="text/javascript"></script>   
    <script type="/js/jquery/ui/ui.dialog_wev8.js"  type="text/javascript"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/projTask/temp/jquery.z4x_wev8.js"></script>
	<script type="text/javascript" src="/js/workplan/workplan_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	wuiform.init();
});
var selectedUser="<%=selectedUser%>";
var selectedUserName="<%=ResourceComInfo.getLastname(selectedUser)%>";
var isShare="<%=Util.null2String(request.getParameter("isShare"))%>";
var workPlanTypeForNewList=<%=JSONArray.fromObject(workPlanTypeForNewList).toString()%>;
var workPanTypeList=<%=JSONArray.fromObject(workPanTypeList).toString()%>;
</script>

   <script type="text/javascript">
        $(document).ready(function() {     
           var view="week";          
           
            var DATA_FEED_URL = "/workplan/calendar/data/getData.jsp";
            var op = {
                view: view,
                theme:2,
                showday: new Date(),
                EditCmdhandler:Edit,
                DeleteCmdhandler:Delete,
                ViewCmdhandler:View,    
                onWeekOrMonthToDay:wtd,
                onBeforeRequestData: cal_beforerequest,
                onAfterRequestData: cal_afterrequest,
                onRequestDataError: cal_onerror, 
                autoload:true,
                selectedUser:selectedUser,
                isShare:isShare,
                url: DATA_FEED_URL + "?method=list&selectUser=",  
                quickAddUrl: DATA_FEED_URL + "?method=addCalendarItem&selectUser=", 
                quickUpdateUrl: DATA_FEED_URL + "?method=editCalendarItemQuick&selectUser=",
                quickDeleteUrl: DATA_FEED_URL + "?method=deleteCalendarItem&selectUser=" ,
                getEventItemUrl: DATA_FEED_URL + "?method=getCalendarItem&selectUser="  ,
                updateEvent:  DATA_FEED_URL + "?method=editCalendarItem&selectUser="    ,
                getSubordinateUrl: DATA_FEED_URL+"?method=getSubordinate&selectUser=",
                overCalendarItemUrl:DATA_FEED_URL+"?method=&selectUser&selectUser="
            };
            var $dv = $("#calhead");
            var _MH = document.documentElement.clientHeight;
            var dvH = $dv.height() + 2;
            op.height = _MH - dvH;
            op.eventItems =[];

            var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
            if (p && p.datestrshow) {
                $("#txtdatetimeshow").text(p.datestrshow);
            }
            $("#caltoolbar").noSelect();
            
            $("#hdtxtshow").datepicker({ picker: "#txtdatetimeshow", showtarget: $("#txtdatetimeshow"),
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
                        t="Loading data...";
                        break;
                    case 2:                      
                    case 3:  
                    case 4:    
                        t="The request is being processed ...";                                   
                        break;
                }
                $("#errorpannel").hide();
                $("#loadingpannel").html(t).show();    
            }
            function Edit(data,a)
            {
                $("#calendarBtns").hide();
                $("#editButtons").show();
               	$("#crmTools").hide();
                
                if(data)
                {
                    if(data[0]=="0"){
                    	var calendar1=new WorkPlanEvent({});
                    	calendar1.clearWorkPlanView();
                        $("input[name=eventId]").val(data[0]);
                        $("#planName").val(data[1]);
                        $("#beginDate").val(data[2]);
                        $("#beginTime").val(data[3]);
                        $("#endDate").val(data[4]);
                        $("#endTime").val(data[5]);
                        $("#beginDateSpan").text(data[2]);
                        $("#beginTimeSpan").text(data[3]);
                        $("#endDateSpan").text(data[4]);
                        $("#endTimeSpan").text(data[5]);
                        $("#memberIDs").val(selectedUser);
                    	$("#memberIDsSpan").text(selectedUserName);
                        $("#editBox").css("visibility","visible");
                        $("#DeleteBtn").hide();
                        $("#EndEventBtns").hide();
                   		$("#DeleteBtn").next().hide();
                   	 	$("#DeleteBtn").prev().hide();
                    }else{
                    	var param={
                    			id:data[0]
                    		};
                    	p.onBeforeRequestData && p.onBeforeRequestData(1);
                    	$.post(p.getEventItemUrl+p.selectedUser,param,function(data){
                        	var calendarEvent=new WorkPlanEvent(data);
                        	calendarEvent.FillWorkPlanView();
                        	 $("#editBox").css("visibility","visible");
                        	 p.onAfterRequestData && p.onAfterRequestData(1);
                        	 $("#DeleteBtn").show();
                             $("#EndEventBtns").show();
                       		$("#DeleteBtn").next().show();
                       	 	$("#DeleteBtn").prev().show();
                        },"json");
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
                    case 3:
                    case 4:
                        $("#loadingpannel").html("Success!");
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
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $("#showdaybtn").addClass("fcurrent");
            }
            //to show day view
            $("#showdaybtn").click(function(e) {
                //document.location.href="#day";
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("day").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            //to show week view
            $("#showweekbtn").click(function(e) {
                //document.location.href="#week";
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("week").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

            });
            //to show month view
            $("#showmonthbtn").click(function(e) {
                //document.location.href="#month";
                $("#caltoolbar div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("month").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
            });
            
            $("#showreflashbtn").click(function(e){
                $("#gridcontainer").reload();
            });
            
            //Add a new event
            $("#faddbtn").click(function(e) {
            	  $("#editButtons").show();
                  $("#calendarBtns").hide();
            	var calendar= new WorkPlanEvent({});
            	calendar.clearWorkPlanView();
            	$("#memberIDs").val(selectedUser);
            	$("#memberIDsSpan").text(selectedUserName);
            	$("#DeleteBtn").hide();
                $("#EndEventBtns").hide();
           		$("#DeleteBtn").next().hide();
           	 	$("#DeleteBtn").prev().hide();
                $("#editBox").css("visibility","visible");
                
              
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
            $("#cancelEditBtn").click(function(E){
                $("#editBox").css("visibility","hidden");
                $("#editButtons").hide();
                $("#calendarBtns").show();
                });
            $("#saveBtn").click(function(e){
                if(!validateForm()){
					alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
					return;
                }
                var data={};
				var calendar=new WorkPlanEvent({});
				calendar.generateData(data);
				var url=(data.id==""||data.id=="0")?p.quickAddUrl:p.updateEvent;
				p.onBeforeRequestData && p.onBeforeRequestData(2);
				$.post(url+p.selectedUser+"&isShare"+p.isShare,data,function(dataBack){
						$("#cancelEditBtn").click();
						
						$("#editBox").css("visibility","hidden");
						$("#showreflashbtn").click();
						p.onAfterRequestData && p.onAfterRequestData(2);
				},"json");
            });
            $("#DeleteBtn").click(function(){
            	Dialog.confirm(
             			"<%=SystemEnv.getHtmlLabelName(83501,user.getLanguage())%>", function (){
             				var workplanId=$("#workplanId").val();
                        	try{
                        		workplanId=parseInt(workplanId);
                             }catch (e) {
                            	 workplanId=0;
        					}
                             
         					if(workplanId>0){
         	 					
        						var param={id:workplanId};
        						$.post(p.quickDeleteUrl+p.selectedUser+"&isShare"+p.isShare,param,function(data){
        							if(data.IsSuccess){
        								$("#gridcontainer").reload();
        								$("#editBox").css("visibility","hidden");
        								$("#cancelEditBtn").click();
        							}
        						},"json");
         					}else{
        						alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
         	 				}
             			}, function () {}, 220, 90,false
             	    );
				
            	
             });
            $("#EndEventBtns").click(function(){
				Dialog.confirm(
					"<%=SystemEnv.getHtmlLabelName(83503,user.getLanguage())%>", function (){
						var workplanId=$("#workplanId").val();
		            	try{
		            		workplanId=parseInt(workplanId);
		                 }catch (e) {
		                	 workplanId=0;
						}
							if(workplanId>0){
							var param={id:workplanId};
							$.post(p.quickDeleteUrl+p.selectedUser+"&isShare"+p.isShare,param,function(data){
								if(data.IsSuccess){
									$("#gridcontainer").reload();
									$("#editBox").css("visibility","hidden");
									$("#cancelEditBtn").click();
								}else{
									alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
								}
							},"json");
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
			 				}
					}, function () {}, 220, 90,false
			    );
             });
            $("#currentUserSpan").click(function(e){
				if($("#subordinateDivList").css("display")=="none"){
					$("#subordinateDivList").show();
				}else{
					$("#subordinateDivList").hide();
					return;
				}
				$("#subordinateDivList").css({
						"left":$(this).offset().left-$("#subordinateDivList").width()+$(this).width()+"px",
						"top":$(this).offset().top+$(this).height()+"px"
					});
             });
            setUser(selectedUser);
           
        });
        function onUserSelected(data){
        	setUser(data.id);
        	
        }
        function onCurrentUserChange(){
        	 var p = $("#gridcontainer").BcalGetOp();
			 var selectedUser1=$("#subordinate").val();
			 setUser(selectedUser1);
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
			 var selectedUser1=userID;
			 p.selectedUser=userID;

			 var opts=document.getElementById("subordinate");
			 if(userID==$("#currentUser").val()){
				
			 }
			 else if(userID!=selectedUser){
			 	$("#currentUser").val(userID);
			 	$("#currentUserSpan").text(opts[opts.selectedIndex].text);
			}else {
				$("#currentUser").val(selectedUser);
			 	$("#currentUserSpan").text(selectedUserName);
			}
			 var param={"userId":userID};
			 $.post(p.getSubordinateUrl,param,function(data){
					if(data){
						for(var i=opts.length;i>0;i--){
							$(opts[i]).remove();
						}
						for(var i=0;i< data.length;i++){
							var user=data[i];
							$("#subordinate").append("<option value='"+user.id+"'>"+user.name+"</option");
						}

						$("#subordinateDivList .title").text($("#currentUserSpan").text()+SystemEnv.getHtmlLabelName(30805,user.getLanguage())+":");
			        	var subordinates=$("#subordinate").children();
			        	var list=$($("#subordinateDivList .list")[0]);
			        	list.empty();
			        	for(var i=1;i<subordinates.length;i++ ){
							list.append("<li><a href=\"javascript:subordinateDivListSelected(\'"
										+$(subordinates[i]).val()+"\',\'"+$(subordinates[i]).text()+"\')\">"+$(subordinates[i]).text()+"</a></li>");
			            }
					}
				},"json");
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
				var f=/^[^\$\<\>]+$/;
				if(!f.test($("#planName").val())){
					isValidate=false;
			    }
			    if(!f.test($("#description").val())){
			    	isValidate=false;
				}
				if(!f.test($("#memberIDs").val())){
					isValidate=false;
				}
				return isValidate;
        }
       
    </script>    

</head>

<body>

<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
/*
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveBtn.click(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{取消,javascript:doSave(this),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{删除,javascript:doSave(this),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{共享日程,javascript:doSave(this),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{结束日程,javascript:doSave(this),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	String addTopSpaceStr = "";
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
	if(userightmenu_self == 0){
		addTopSpaceStr = "24 + ";
	}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20169,user.getLanguage())+",javascript:changeToEventView(),_self}";
		RCMenuHeight += RCMenuHeightStep;
		
		if("month".equals(request.getParameter("from")))
		{
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		*/
%>
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>

    <div>
	
      <div id="calhead" style="padding-left:1px;padding-right:1px;">   
      			
	            <div id="caltoolbar" class="ctoolbar" style="padding-top:4px;">
	            <div id="calendarBtns">   
	              <div id="faddbtn" class="fbutton">
	                <div><span title='Click to Create New Event' class="addcal">
		<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage())%>           
	                </span></div>
	            </div>
	            <div class="btnseparator"></div>
	             <div id="showtodaybtn" class="fbutton">
	                <div><span title='Click to back to today ' class="showtoday">
	              		  <%=SystemEnv.getHtmlLabelName(31299,user.getLanguage())%></span></div>
	            </div>
	              <div class="btnseparator"></div>
	
	            <div id="showdaybtn" class="fbutton">
	                <div><span title='Day' class="showdayview"><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></span></div>
	            </div>
	              <div  id="showweekbtn" class="fbutton fcurrent">
	                <div><span title='Week' class="showweekview"><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></span></div>
	            </div>
	              <div  id="showmonthbtn" class="fbutton">
	                <div><span title='Month' class="showmonthview"><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></span></div>
	
	            </div>
	            <div class="btnseparator"></div>
	              <div  id="showreflashbtn" class="fbutton">
	                <div><span title='Refresh view' class="showdayflash"><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></span></div>
	                </div>
	             <div class="btnseparator"></div>
	            <div id="sfprevbtn" title="Prev"  class="fbutton">
	              <span class="fprev"></span>
	
	            </div>
	            <div id="sfnextbtn" title="Next" class="fbutton">
	                <span class="fnext"></span>
	            </div>
	            <div class="fshowdatep fbutton">
	                    <div>
	                        <input type="hidden" name="txtshow" id="hdtxtshow" />
	                        <span id="txtdatetimeshow" class="selectDate"><%=SystemEnv.getHtmlLabelNames("172,97",user.getLanguage())%></span>
	
	                    </div>
	            </div>
            	
            </div>
            <div id="editButtons" style="display:none;">
            	<div class="fbutton" id="saveBtn">
            		<div>
            			<span class="saveCal"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></span>
            		</div>
            	</div>
            	<div class="btnseparator"></div>
            	<div class="fbutton" id="cancelEditBtn">
            		<div>
            			<span class="cancelCalEdit"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></span>
            		</div>
            	</div>
            	<div class="btnseparator"></div>
            	<div class="fbutton" id="DeleteBtn">
            		<div>
            			<span class="deleteCal"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
            		</div>
            	</div>
            	<div class="btnseparator"></div>
            	<div class="fbutton" id="EndEventBtns">
            		<div>
            			<span class="endCal"><%=SystemEnv.getHtmlLabelNames("405,2211",user.getLanguage())%></span>
            		</div>
            	</div>
            	
            </div>
            <div style="float:right">
            	
            	<div class="fbutton"  >
            		<div>
	            		<input class="wuiBrowser" value="<%=selectedUser %>" id="currentUser"
	            			 _displayText="<%=ResourceComInfo.getLastname(selectedUser) %>"
	            			 _url="/hrm/resource/ResourceBrowser.jsp" 
	            			 _callBack="onUserSelected"
	            			 />
	            		
            		</div>
            	</div>
            	<div class="fbutton">
            		<select onchange="onCurrentUserChange()" id="subordinate" name="subordinate" style="display:none;"> 
            			<option><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></option>
            			<%
            				recordSet.executeProc("HrmResource_SelectByManagerID", selectedUser);
            				while(recordSet.next()){
            					String id=Util.null2String(recordSet.getString("id"));
            			%>
            				<option value="<%=id %>"><%=ResourceComInfo.getResourcename(id) %></option>
            			<%} %>
            		</select>
            	</div>
            	<div class="btnseparator"></div>
            	<div class="fbutton">
            		<div>
            			<span  onclick="showMyCalnedar()" class="myCal"><%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>/span>
            		</div>
            	</div>
            </div>
            <div class="clear"></div>
            </div>
      </div>
      <div style="padding:1px;">

        <div class="t1 chromeColor">
            &nbsp;</div>
        <div class="t2 chromeColor">
            &nbsp;</div>
        <div id="dvCalMain" class="calmain printborder" style="position:relative">
            <div id="gridcontainer" style="overflow-y: visible;visibility:visible">
            </div>
            <div id="editBox" class="editBox" style="visibility:hidden;">
            	<input name="workplanId" id="workplanId" type="hidden"/>
            				<form action="">
            					<table style="width:100%;padding:10;" class="ViewForm" >
            						<colgroup>
            							<col width="100px" />
            							<col width="10px"/>
            							<col width="*"/>
            						</colgroup>
            						<tbody></tbody>
            						<tr class="calLine">
            							<td ><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></td>
     										<td></td>
     										<td><select id="workPlanType" name="workPlanType"><option value="0"><%=SystemEnv.getHtmlLabelName(15090,user.getLanguage())%></option></select></td>
     										
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr >
            							<td ><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
            							<td></td>
            							<td>
            								<input name="planName" id="planName" class="InputStyle styled input" style="" size="30" onblur="if(this.value)$(this).next().hide();else $(this).next().show()"/>
            								<img align="absmiddle" src="/images/BacoError_wev8.gif">
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td  valign="top"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
            							<td></td>
            							<td>
            								<textarea id="description" name="description" rows="5" class="InputStyle styled textarea" style="width: 98%;" onblur="if(this.value)$(this).next().hide();else $(this).next().show()"></textarea>
            								<img align="absmiddle" src="/images/BacoError_wev8.gif">
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
   										<td ><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
   										<td></td>
   										<td>
   											<input type="hidden" class="wuiBrowser" name="memberIDs" id="memberIDs"
   												_param="resourceids" _required="yes"
   												_url="/hrm/resource/MutiResourceBrowser.jsp" /> 
   										</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td ><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
         										<td></td>
         										<td >
         											<select id="urgentLevel" class="styled" name="urgentLevel">
         												<option value="1"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
         												<option value="2"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
         												<option value="3"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
         											</select>
         										</td>
            						</tr>
            						<tr style="height:0;">
            							<td class="Line" colspan="3" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  valign="top"><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
            							<td></td>
            							<td>
            								<table>
            									<tr>
            										<td><select class="styled" id="remindType" name="remindType" class="float:left;" onchange="if($.event.fix(event).target.value!=1)$('#remindInfo').show();else $('#remindInfo').hide()">
            												<option value="1"><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%></option>
            												<option value="2"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></option>
            												<option value="3"><%=SystemEnv.getHtmlLabelName(22825,user.getLanguage())%></option>
            											</select></td>
            										<td>
            											
            								<table id="remindInfo">
            									<tr>
            										<td style="display:none;">
            											<input type="hidden" name="remindId"/>
            										</td>
            										<td>
            											
            										</td>
            										<td>
            											<input type="checkbox" name="remindBeforeStart" id="remindBeforeStart" value="1" />
            											<span><%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%></span>
            											<input style="width:30px" class="InputStyle styled input" value="0" name="remindDateBeforeStart" id="remindDateBeforeStart"/>
            											<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
            											<input style="width:30px" class="InputStyle styled input" value="10" name="remindTimeBeforeStart" id="remindTimeBeforeStart"/>
            											<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
            										</td>
            										<td>
            											<input type="checkbox" name="remindBeforeEnd" id="remindBeforeEnd" value="1"/>
            											<span><%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%></span>
            											<input style="width:30px" value="0" class="InputStyle styled input"   name="remindDateBeforeEnd" id="remindDateBeforeEnd" />
            											<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
            											<input style="width:30px" value="10" class="InputStyle styled input"  name="remindTimeBeforeEnd" id="remindTimeBeforeEnd"/>
            											<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
            										</td>
            									</tr>
            								</table>
            										</td>
            									</tr>
            								</table>
            								
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td ><%=SystemEnv.getHtmlLabelName(83825,user.getLanguage())%></td>
            							<td></td>
            							<td valign="middle">
            								<button type="button" class="Calendar" onclick="getTheDate('beginDate', 'beginDateSpan')"></button>
            								<input type="hidden" name="beginDate"  id="beginDate"/>
            								<span style="height: 16px;" id="beginDateSpan"></span>
            								<button type="button" class="Calendar"  onclick="onWorkPlanShowTime('beginTimeSpan','beginTime')"></button>
            								<input type="hidden" name="beginTime"  id="beginTime"/>
            								<span id="beginTimeSpan">00-00</span>
            								
            							</td>
            						</tr>
            						<tr>
            							<td><%=SystemEnv.getHtmlLabelName(83826,user.getLanguage())%></td>
            							<td></td>
            							<td>
            								<button type="button" class="Calendar"  onclick="getTheDate('endDate', 'endDateSpan')"></button>
            								<input type="hidden" name="endDate"  id="endDate"/>
            								<span id="endDateSpan">2012-01-09</span>
            								<button type="button" class="Calendar" onclick="onWorkPlanShowTime('endTimeSpan','endTime')"></button>
            								<input type="hidden" name="endTime"  id="endTime"/>
            								<span id="endTimeSpan">23:59</span>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td ><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
            							<td></td>
            							<td>
            								<INPUT class="wuiBrowser" type="hidden" id="crmIDs" name="crmIDs" value="" _param="resourceids"
													_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
													_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td ><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            							<td></td>
            							<td>
            								<INPUT class=wuiBrowser type="hidden" name="docIDs" id="docIDs"
										  		_url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
										  		_displayTemplate="<A href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</A>&nbsp;">
										  		
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td ><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
            							<td></td>
            							<td>
												<INPUT class=wuiBrowser type="hidden" id="projectIDs" name="projectIDs" 
														_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp"
														_displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}' target='_blank'>#b{name}</A>&nbsp;">
														            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td >相关流程</td>
            							<td></td>
            							<td>
            								<INPUT class=wuiBrowser type="hidden" name="requestIDs"  id="requestIDs"
												_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"
												_displayTemplate="<A href='/workflow/request/ViewRequest.jsp?requestid=#b{id}' target='_blank'>#b{name}</A>&nbsp;">
												
            							</td>
            						</tr>
            						<tr	style="height:1px;" >
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						</tbody>
            					</table>
            				</form>
            			
            </div>
        </div>
        <div class="t2 chromeColor">

            &nbsp;</div>
        <div class="t1 chromeColor">
            &nbsp;
        </div>   
        </div>
  </div>
  <div id="subordinateDivList" >
  		<div class="title">徐如晶的下属:</div>
		<ul class="list">
			<li><a href="javascript:setUser(58)">张凡杭</a></li>
			<li><a href="javascript:setUser(58)">张凡杭</a></li>
			<li><a href="javascript:setUser(58)">张凡杭</a></li>
		</ul>
	</div>
</body>
</html>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
document.oncontextmenu=function(e){
		if($("#editBox").css("visibility")=="visible"){
			showRightClickMenu(e);
		}
		else{
			return false;
		}
}

</script>

