
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@page import="weaver.Constants"%>
<%@page import="net.sf.json.JSONObject"%> 
<%@page import="net.sf.json.JSONArray"%>
<html >
<head id="Head1">
	<%
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		String viewType = Util.null2String(request.getParameter("viewType")); 
		String hrmid = Util.null2String(request.getParameter("hrmid"));
		String userid=""+user.getUID();
		hrmid=hrmid.equals("")?userid:hrmid;
		
		String selectedUser=Util.null2String(request.getParameter("selectUser"));
		if("".equals(selectedUser)){
			selectedUser=""+hrmid;
		}
		String selectedUserName=resourceComInfo.getFirstname(selectedUser);
		
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
    <title>任务日历视图</title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css" />   
    <link href="/workplan/calendar/css/main_wev8.css" rel="stylesheet" type="text/css" /> 
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
	 <link href="/workplan/calendar/css/editbox_wev8.css" rel="stylesheet" type="text/css" /> 
    <script src="/workplan/calendar/src/jquery_wev8.js" type="text/javascript"></script>  
       
    <script src="/workplan/calendar/src/Plugins/Common_wev8.js" type="text/javascript"></script>    
    <script src="/workplan/calendar/src/Plugins/datepicker_lang_ZH_wev8.js" type="text/javascript"></script>     
    <script src="/workplan/calendar/src/Plugins/jquery.datepicker_wev8.js" type="text/javascript"></script>

    <script src="/express/js/wdCalendar_lang_ZH_wev8.js" type="text/javascript"></script>    
    <script src="/express/js/jquery.calendar_wev8.js" type="text/javascript"></script>
       
    <script type="/js/jquery/ui/ui.dialog_wev8.js"  type="text/javascript"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/workplan/workplan_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
	
	<link rel="stylesheet" href="/express/css/base_wev8.css" />
<style>
	.fcurrent{
		background:#2e9eb2!important;
		color:white;
	}

	.gcweekname ,.mv-dayname,.wk-dayname,.wk-dayname{
		background:url('/workplan/calendar/css/images/caledartitlebg_wev8.png');
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
   		
		var selectedUser="<%=selectedUser%>";
		var selectedUserName="<%=resourceComInfo.getLastname(selectedUser)%>";
		var isShare="<%=Util.null2String(request.getParameter("isShare"))%>";
		var workPlanTypeForNewList=<%=JSONArray.fromObject(workPlanTypeForNewList).toString()%>;
		var workPanTypeList=<%=JSONArray.fromObject(workPanTypeList).toString()%>;
		var dialog2=new Dialog();
		dialog2.ID="shareEvent";
		var dialog=new Dialog();
		dialog.ID="shareEventID";
		//dialog.InvokeElementId="editBox";
		var viewCalendarDialog=new Dialog();
		viewCalendarDialog.ID="viewCalendarDialog";
		viewCalendarDialog.InvokeElementId="workPlanViewSplash";
		viewCalendarDialog.Height="400";
        
        $(document).ready(function() {    
           	var view="month";          
            var DATA_FEED_URL = "/express/calendar/getData.jsp";
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
                selectedUser:selectedUser,//指定当前选定的人员
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
            var _MH = document.documentElement.clientHeight;
            var dvH = $dv.height() + $dv.offset().top+10+2;
            op.height = _MH - dvH;
            op.eventItems =[];

            var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
            if (p && p.datestrshow) {
                $("#txtdatetimeshow").text(p.datestrshow);
            }
            $("#cancel").live("click",function(){
            	var taskid = $("#taskid").attr("value");
            	$.post("/express/calendar/WorkPlanViewOperation.jsp?method=delDefault&taskid="+taskid,function(data){
            		Dialog.getInstance1("cancel").close();
	            });
            });
            
            $("#del_img").live("click",function(){
            	var taskid = $("#taskid").attr("value");
            	$.post("/express/calendar/WorkPlanViewOperation.jsp?method=delDefault&taskid="+taskid,function(data){
            		Dialog.getInstance1("cancel").close();
            	});
            });
            
            $("#ButtonOK").live("click",function(){
            	 Dialog.getInstance1("cancel").close();
            	 $("#gridcontainer").reload();
            });
            
            //显示时间控件 
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
                        t="<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>"; //页面加载中，请稍候...
                        break;
                    case 2:   
                        t="<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>"; //正在保存，请稍等...
                        break;                   
                    case 3:  
                        t="正在删除，请稍等..."; //正在删除，请稍等...
                        break;   
                    case 4:    
                        t="<%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>";                                   
                        break;
                }
                $("#errorpannel").hide();
               
            }
            function Edit(data,a)
            {
                $("#calendarBtns").hide();
               	$("#crmTools").hide();
           	 	dialog.Width=650;
           	 	dialog.Height=550;
           	 	dialog.OnLoad=function(){
                 };
                if(data)
                {	
                    if(data[0]=="0"){
                    	NewEvent(data);
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
                        	 if(data.shareLevel>1){
                            		dialog.OKEvent=function(){
                            			$("#saveBtn").click();
                                	};
                            		 dialog.show();
                             }else{
                              }
                        },"json");
                    }
                }
            } 
            
            //新建任务
			function NewEvent(data){
				var begindate = data[2];
				var enddate = data[4];
				var name=$("#bbit-cal-what").val();
				if(name==undefined)
				    name="";
				$.post("/express/calendar/getData.jsp?method=addCalendarItem&beginDate="+begindate+"&endDate="+enddate+"&name="+name,function(data){
				        var taskid=data.Data[0];
						dialog.URL="/express/task/data/DetailView.jsp?taskid="+taskid;
						dialog.OKEvent=function(){
        			        dialog.close();
        			        $("#showreflashbtn").click();
            	        };
            	        dialog.CancelEvent=function(){
        			        $.post("/express/calendar/WorkPlanViewOperation.jsp?method=delDefault&taskid="+taskid,function(data){
				            		$("#bbit-cal-what").html("");
				            		dialog.close();
					        });
            	        };
						dialog.show();	
           	    	$("#editBox").css("visibility","visible");				
				},"json");
			}
			
            function View(data0)
            {
            	viewCalendarDialog.Width=500;
            	viewCalendarDialog.Height=400;
            	var tasktype = data0[data0.length-1];
            	var taskid = data0[0];
            	if(tasktype == 1)       //任务
	    				detailsrc="/express/task/data/DetailView.jsp?taskid="+taskid;
	   			 else if(tasktype ==2||tasktype ==9)  //流程
	    				detailsrc="/workflow/request/ViewRequest.jsp?requestid="+taskid+"&isovertime=0";
	   			 else if(tasktype==3)  //协作
	    				detailsrc="/meeting/data/ProcessMeeting.jsp?meetingid="+taskid;
	   			 else if(tasktype==4)  //文档
	    				detailsrc="/docs/docs/DocDsp.jsp?fromFlowDoc=&blnOsp=false&topage=&pstate=sub&id="+taskid;
	  			 else if(tasktype==5)  //协作
	   				 	detailsrc="/cowork/viewCowork.jsp?id="+taskid;
				 else if(tasktype==6){  //邮件
	  			        detailsrc="/email/MailView.jsp?folderId=0&id="+taskid;
	  			  }
	  			  window.open(detailsrc);
            	return ;
            	$.post(p.getEventItemUrl+p.selectedUser,param,function(data){
            		
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
                   	 alert("没有查看权限");
					return;
                  }
                 
                    if(canFinish){
                    	viewCalendarDialog.OKEvent=function(){
                   			$("#EndEventBtns").click();
                       	};
                       	
                       	viewCalendarDialog.show();
                       	viewCalendarDialog.okButton.value="<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>";
                    }
                    if(!canFinish){
                    	viewCalendarDialog.OKEvent=function(){
                   			Dialog.close();
                       	};
                    	viewCalendarDialog.show();
                    	$("#_ButtonCancel_viewCalendarDialog").hide();
                    }
                    if(canEdit){
                    	viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>",function(){
							Dialog.close();
								Edit([data.id]);
							
                         });
                    	viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>",function(){
          					$("#DeleteBtn").click();
                     	});
                    }
                    if(data.canShare=="true"){
                    	viewCalendarDialog.addButton("<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%> ","<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%> ",function(){
                   			viewCalendarDialog.close();
            					 dialog2.InvokeElementId="workPlanShareSplash";
            					 fillShare(data.id);
            					 if(data.shareLevel>1){
            						
                     			 }
                     			 dialog2.Width=500;
            	                 dialog2.Height=450;
            					 dialog2.show();
            						
                         	 });
            			 
                    }
					
                   	 
            	},"json");         
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
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $("#showdaybtn").addClass("fcurrent");
				
            }
            //to show day view
            $("#showdaybtn").click(function(e) {
                //document.location.href="#day";
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("day").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }
				
				$("#showtodaybtn").text("<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%> ");
            });
            //to show week view
            $("#showweekbtn").click(function(e) {
                //document.location.href="#week";
                $("div.fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("week").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

				$("#showtodaybtn").text("<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%> ");

            });
            //to show month view
            $("#showmonthbtn").click(function(e) {
                //document.location.href="#month";
                $(".fcurrent").each(function() {
                    $(this).removeClass("fcurrent");
                })
                $(this).addClass("fcurrent");
                var p = $("#gridcontainer").swtichView("month").BcalGetOp();
                if (p && p.datestrshow) {
                    $("#txtdatetimeshow").text(p.datestrshow);
                }

				$("#showtodaybtn").text("<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%> ");
            });
            //refresh current View
            $("#showreflashbtn").click(function(e){
            	 $("#gridcontainer").reload();
            });
            $("#_title").html("标题");
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
              
            	$("#memberIDs").val(selectedUser);
            	$("#memberIDsSpan").text(selectedUserName);
            	
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
						Dialog.close()
				},"json");
            });
            $("#DeleteBtn").click(function(){
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
				
            	
             });
            $("#EndEventBtns").click(function(){
				
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
						"top":$(this).offset().top+$(this).height()+"px"
					});
             });
            setUser(selectedUser);


		    //$("#showweekbtn").trigger("click");
           
        });
        function Delete(data,callback)
        {        
            Dialog.confirm(
        			"<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
        				 callback(0);
        				 
        			}, function () {}, 220, 90,false
        	    );
          }
        function onUserSelected(data){
        	window.location.href="/express/calendar/WorkPlanView.jsp?viewType=<%=viewType%>&hrmid="+data.id;
        	//setUser(data.id);
        }
        function onCurrentUserChange(){
        	 var p = $("#gridcontainer").BcalGetOp();
			 var selectedUser1=$("#subordinate").val();
			 setUser(selectedUser1);
        }
        function showMyCalnedar(){
        	//setUser(selectedUser);
        	window.location.href="/express/calendar/WorkPlanView.jsp?viewType=<%=viewType%>&hrmid=<%=userid%>";
         }
        function subordinateDivListSelected(userid,userName){
			//$("#currentUserSpan").text(userName);
			//$("#currentUser").val(userid);
			//setUser(userid);
			//$("#subordinateDivList").hide();
			window.location.href="/express/calendar/WorkPlanView.jsp?viewType=<%=viewType%>&hrmid="+userid;
         }
        function setUser(userID){
        	var p = $("#gridcontainer").BcalGetOp();
			var  selectedUser1=userID;
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

						$("#subordinateDivList .title").text($("#currentUserSpan").text()+"的下属:");
			        	var subordinates=$("#subordinate").children();
			        	var list=$($("#subordinateDivList .list")[0]);
			        	list.empty();
			        	for(var i=1;i<subordinates.length;i++ ){
							list.append("<li><a href=\"javascript:subordinateDivListSelected(\'"
										+$(subordinates[i]).val()+"\',\'"+$(subordinates[i]).text()+"\')\">"+$(subordinates[i]).text()+"</a></li>");
			            }
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
				if($("#description").val()==""){
					isValidate=false;
			    }
				if($("#memberIDs").val()==""){
					isValidate=false;
				}
				return isValidate;
        }
       
    </script>    

</head>

<body scroll="no">

    <div>
	   <div style="width: 100%;height: 40px;position: relative;border-bottom: 1px solid #e5e5e5;">
			<div id="micon" style="position: absolute;left: 14px;top: 7px;width:100px;height: 25px;">
			     <img src="<%=resourceComInfo.getMessagerUrls(userid)%>" width="25px"/>
			</div>
			<div id="mtitle" style="position: absolute;left: 46px;top: 0px;line-height: 38px;font-weight: bold;;color: #2673ad">
			    <%=resourceComInfo.getLastname(hrmid)%>的工作中心<span style="margin-left: 15px;color: #000000;font-weight: normal;"><%=departmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(hrmid))%></span>
			</div>
		    <div id="help" style="width:75px;height: 24px;position: absolute;right: 10px;top: 8px;cursor: pointer;">
		         <div class="btn_operate" id="timeView" onclick="showListView()" title="列表视图">列表视图</div>
		    </div>
	  </div>
      <div id="calhead" class="calHead" style="padding-left:10px;margin-top:4px;">
      		<div  style="float:left;">
      			<div id="faddbtn" class="calHeadBtn" style="border:none;height:25px;width:65px;background:url(/workplan/calendar/css/images/icons/addBtn_wev8.png) no-repeat;">
      				
      			</div>
		      		<div id="showtodaybtn" unselectable="on" class="calHeadBtn" style="margin-left:10px;">
		      			<%=SystemEnv.getHtmlLabelName( 15537 ,user.getLanguage())%> 
		      		</div>
		      		<div id="sfprevbtn" unselectable="on" class="calHeadBtn" style="margin-left:10px;width:23px;_width:25px;">
		      			&#60;
		      		</div>
		      		<div id="sfnextbtn" unselectable="on" class="calHeadBtn" style="border-left:none;width:23px;_width:25px;">
		      			&#62;
		      		</div>
		      		
		      		<div id="txtdatetimeshow" unselectable="on" class="calHeadBtn" style="margin-left:10px;width:auto;padding-left:25px;padding-right:10px;background:url(/workplan/calendar/css/images/icons/date_wev8.png) no-repeat;background-position:6px 50%">
		      			<input type="hidden" name="txtshow" id="hdtxtshow" />
		      			<%=SystemEnv.getHtmlLabelName( 27938 ,user.getLanguage())%> 
		      		</div>
      		</div>
      		<div id="editButtons" style="float:left;display:none;">
            	<div class="calHeadBtn" id="saveBtn">
            			<span class="saveCal"><%=SystemEnv.getHtmlLabelName( 86 ,user.getLanguage())%> </span>
            	</div>
            	<div class="calHeadBtn" id="cancelEditBtn">
            			<span class="cancelCalEdit"><%=SystemEnv.getHtmlLabelName( 201 ,user.getLanguage())%> </span>
            	</div>
            	<div class="calHeadBtn" id="DeleteBtn">
            			<span class="deleteCal"><%=SystemEnv.getHtmlLabelName( 23777 ,user.getLanguage())%> </span>
            	</div>
            	<div class="calHeadBtn" id="EndEventBtns">
            			<span class="endCal"><%=SystemEnv.getHtmlLabelName( 22177 ,user.getLanguage())%>  </span>
            	</div>
            	
            </div>
      		<div style="float:right;padding-right:10px;">
      			
	      		<div id="showdaybtn" unselectable="on" class="calHeadBtn" style="margin-left:10px;width:50px;_width:25px;display: none;">
	      			<%=SystemEnv.getHtmlLabelName( 27296 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showweekbtn" unselectable="on" class="calHeadBtn" style="width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 1926 ,user.getLanguage())%> 
	      		</div>
	      		<div id="showmonthbtn" unselectable="on" class="calHeadBtn fcurrent" style="border-left:none;width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 6076 ,user.getLanguage())%> 
	      		</div>
	      		
	      		<div id="showreflashbtn" unselectable="on" class="calHeadBtn" style="border-left:none;width:50px;_width:25px;">
	      			<%=SystemEnv.getHtmlLabelName( 354 ,user.getLanguage())%> 
	      		</div>
	      		
	      		<div  unselectable="on" class="calHeadBtn" style="margin-left:10px;width:auto !important;padding-left:10px;padding-right:10px;text-align:left;" >
            		
								<input type="hidden" class="wuiBrowser" value="<%=selectedUser %>" id="currentUser"
										 _displayText="<%=resourceComInfo.getLastname(selectedUser) %>"
										 _url="/hrm/resource/ResourceBrowser.jsp" 
										 _callBack="onUserSelected"
								 />
								<select onchange="onCurrentUserChange()" id="subordinate" name="subordinate" style="display:none;"> 
									<option>请选择</option>
									<%
										recordSet.executeProc("HrmResource_SelectByManagerID", selectedUser);
										while(recordSet.next()){
											String id=Util.null2String(recordSet.getString("id"));
									%>
										<option value="<%=id %>"><%=resourceComInfo.getResourcename(id) %></option>
									<%} %>
								</select>
	      		</div>
	      		<div  unselectable="on" class="calHeadBtn" style="border-left:none;width:90px;" onclick="showMyCalnedar()">
	      			我的工作中心
	      		</div>
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
            
        </div>
        <div class="t2 chromeColor">

            &nbsp;</div>
        <div class="t1 chromeColor">
            &nbsp;
        </div>   
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
		    if (datas.id!= "") {
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

//显示列表视图
function showListView(){
   window.location.href="/express/TaskMain.jsp?viewType=<%=viewType%>&hrmid=<%=hrmid%>";
}
</script>

