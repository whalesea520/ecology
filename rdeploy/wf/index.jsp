<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

//权限校验
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String modename = SystemEnv.getHtmlLabelName(33569,user.getLanguage());
String modeurl = "/workflow/workflow/managewf_frm.jsp";

List wfidList = new ArrayList();
List wfEditList = new ArrayList();
List orderidList = new ArrayList();
String wfid = "";
String orderid = "";
//and id in (2620,3183,3223)
RecordSet.execute("SELECT id FROM workflow_base where id != 1 and (isvalid = 0 or isvalid =1) order by isvalid desc ,id asc ");
while(RecordSet.next()){
	
	wfid =  Util.null2String(RecordSet.getString("id"));
	//orderid =  Util.null2String(RecordSet.getString("orderid"));
	wfidList.add(wfid);
	//orderidList.add(orderid);
}

RecordSet.execute("select wfid,orderid from Workflow_Initialization");
while(RecordSet.next()){
	wfid =  Util.null2String(RecordSet.getString("wfid"));
	wfEditList.add(wfid);
}
String wfname = "";
String isvalid = "";

boolean altMesFlog = true;
String checkAltMesSql = "SELECT count(1) from Workflow_RecordNavigation where userid = "+user.getUID();
RecordSet.executeSql(checkAltMesSql);
if(RecordSet.next()){
	if (RecordSet.getInt(1) > 0) {
    	altMesFlog = false;
	}
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
  	<script type="text/javascript">
  		$(function () {
  			/////////////////////////////////////
  			var altNavigation= <%=altMesFlog%>;
		    if(altNavigation){
	  			$(".content").find(".item::eq(1)").find(".itemico").css("display","none");
	  			var secondleft = $(".content").find(".item::eq(1)").position().left+52;
	  			var secondtop = $(".content").find(".item::eq(1)").position().top-5;
	  			jQuery(".secondimg").css({"top":secondtop+"px","left":secondleft+"px"});
	  			jQuery(".secondimgover").css({"top":secondtop+54+"px","left":secondleft+12+"px"});
	  			jQuery(".secondmsg").css({"top":secondtop+265+"px","left":secondleft+100+"px"});
	  			jQuery(".secondbtn").css({"top":secondtop+330+"px","left":secondleft+200+"px"});
	  			jQuery(document.body).css("overflow-y","hidden");
	  			jQuery("#shownavigation").css("display","block");
	  			jQuery(".secondbtn").bind("click", function () {
	  				//--
					$.ajax({
						type: "post",
					    url: "/rdeploy/wf/request/recordNavigation.jsp?_" + new Date().getTime() + "=1&",
					    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					    complete: function(){
						},
					    error:function (XMLHttpRequest, textStatus, errorThrown) {
					    } , 
					    success:function (data, textStatus) {
					    	$(".content").find(".item::eq(1)").find(".itemico").css("display","block");
							jQuery("#shownavigation").css("display","none");
							jQuery(document.body).css("overflow-y","auto");
					    	/////////////
					    } 
			    	});	  				
				});
  			}
  			/////////////////////////////////////
  			
  			//鼠标移到图标上触发事件，显示设置和启用图标
  			$(".item .itemico img").hover(function (e) {
  				var imgobj = $(this).parent().parent().find("img");
  				
  				$(this).attr("src", "/rdeploy/assets/img/wf/wf_slt.png");
  				var status = 1;
  				try {
  					status = parseInt($(this).parent().parent().find(".operationspan").attr("status"));
  				} catch (e) {}
  				
  				$(this).closest(".item").find(".itemoperation").show();
  			});
  			//只有鼠标移除整个item范围才会隐藏图标
  			$(".item").hover(null, function () {
  				var imgobj = $(this).find("img");
  				
  				var status = 1;
  				try {
  					status = parseInt($(this).find(".operationspan").attr("status"));
  				} catch (e) {}
  				
  				if (status == 1) {
  					imgobj.attr("src", "/rdeploy/assets/img/wf/wf.png");
  				} else {
  					imgobj.attr("src", "/rdeploy/assets/img/wf/wf_dis_wev8.png");
  				}
  				
  				$(this).find(".itemoperation").hide();
  			});
  			//是否启用
  			$(".operationspan").bind("click", function () {
  				try {
  					var _this = this;
	  				var wfid = $(this).parent().parent().find("input[name=wfid]").val();
	  				var status = parseInt($(this).attr("status"));
  				} catch (e) {}	
  				//------
  				$.ajax({
					type: "post",
				    url: "/rdeploy/wf/request/wfStatusOperation.jsp?_" + new Date().getTime() + "=1&",
				    data: {
				    	"wfid":wfid,
				    	"isvalid":status,
				    	"actionkey":"statuschange"
				    	},
				    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				    complete: function(){
					},
				    error:function (XMLHttpRequest, textStatus, errorThrown) {
				    } , 
				    success:function (data, textStatus) {
				    	var _data = jQuery.parseJSON(data);
				    	var _status = _data.isvalid;
				    	/////////////
		  				if (status == 1) {
		  					jQuery(_this).attr("status", "0");
		  					jQuery(_this).css("backgroundImage", "url('/rdeploy/assets/img/wf/stop.png')");
		  				} else {
		  					jQuery(_this).attr("status", "1");
		  					jQuery(_this).css("backgroundImage", "url('/rdeploy/assets/img/wf/start.png')");
		  				}
				    	/////////////
				    } 
		    	});
  			});
  			
  			/*$(".item .itemico img").bind("click", function () {
  				//////
  				
  				//////
  				var dialog = new window.top.Dialog();
  				dialog.currentWindow = window;
  				var contain = jQuery(this).parent().parent().find("input[name=contain]").val();
  				if(contain != 1){
  					
  					var dialogFrameDocument = top.document.getElementById("_DialogFrame_"+dialog.ID).contentWindow.document;
					if(dialogFrameDocument != null){
						var dialogFrameDiv = dialogFrameDocument.getElementById('tabcontentframe').parentNode;
						dialogFrameDocument.getElementById('e8TreeSwitch').remove();
	  					var altMes = document.createElement("div"); 
						altMes.innerHTML = '此流程进行过高级设置，现为您打开高级模式';
						var style = document.createElement('style');
						style.type = 'text/css';
						style.innerHTML=".altMes {width: 330px;height: 64px;background-color: #272727;position: absolute;top: 34%;left: 36%;font-size: 14px;color: white;filter: alpha(opacity=50);filter: alpha(opacity=50);-moz-opacity: 0.4;-khtml-opacity: 0.4; opacity: 0.4; text-align: center; vertical-align: middle; line-height: 64px;}";
							
						altMes.appendChild(style);
						altMes.className = "altMes";
						dialogFrameDiv.appendChild(altMes);
						setTimeout(function(){
							altMes.remove();
						},2000);
					}
  					
  					top.Dialog.alert("该流程已经在高级设置中修改，将自动进入高级设置！");
  				}
				var wfid = jQuery(this).parent().parent().find("input[name=wfid]").val();
  				
	 			var wfname = jQuery(this).parent().parent().find("input[name=wfname]").val();
				//var orderid = jQuery(this).parent().parent().find("input[name=orderid]").val();
				//var url = "/rdeploy/wf/request/wfEditInterface.jsp?wfid="+wfid+"&orderid="+orderid;
				var url = "";
				if(contain == 1){
					url = "/rdeploy/wf/request/wfEditInterfaceTab.jsp?wfid="+wfid;
					dialog.Width = 950;
				}else{
					url = "/workflow/workflow/addwf.jsp?src=editwf&wfid="+wfid+"&isTemplate=0&versionid_toXtree=1";
					//var width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
					dialog.Width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
				}
				dialog.Title = wfname;
				//dialog.Height = 558;
				//dialog.Width = window.top.window.document.body.offsetWidth*0.9 ;
	 			//dialog.Height = window.top.window.document.body.offsetHeight*0.8 ;
				var height = window.innerHeight || (window.document.documentElement.clientHeight || window.document.body.clientHeight);
				dialog.Height = height*0.8;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.
				dialog.URL = url;
				dialog.show();
  			});*/
  			
  			$(".item .itemico img").bind("click", function () {
				var wfid = jQuery(this).parent().parent().find("input[name=wfid]").val();
	 			var wfname = jQuery(this).parent().parent().find("input[name=wfname]").val();
  				var dialog = new window.top.Dialog();
  				var contain = jQuery(this).parent().parent().find("input[name=contain]").val();
  				var width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
  				var height = window.innerHeight || (window.document.documentElement.clientHeight || window.document.body.clientHeight);
  				dialog.currentWindow = window;
  				if (contain == 1) {
  					url = "/rdeploy/wf/request/wfEditInterfaceTab.jsp?wfid="+wfid;
  					dialog.URL = url;
  					dialog.Title = wfname;
					dialog.Width = 950;
  					dialog.Height = height*0.8;
  					dialog.normalDialog = false;
  					dialog.Drag = true;
  					dialog.maxiumnable = true;
					dialog.show();
  				} else {
  					url = "/workflow/workflow/addwf.jsp?src=editwf&wfid="+wfid+"&isTemplate=0&versionid_toXtree=1";
		 			dialog.URL = url;
	  				dialog.Title = wfname;
					dialog.Width = width*0.9;
	  				dialog.Height = height*0.9;
	  				dialog.normalDialog = false;
	  				dialog.Drag = true;
	  				dialog.maxiumnable = true;
					dialog.show();
						 
					/*myInterval = setInterval((function(){
						return(function(){
							var dialogFrameDocument = 
							top.document.getElementById("_DialogFrame_"+dialog.ID).contentWindow.document;
							if(dialogFrameDocument != null){
								var dialogFrameDiv = dialogFrameDocument.getElementById('tabcontentframe').parentNode;
								dialogFrameDocument.getElementById('e8TreeSwitch').remove();
								
								var altMes = document.createElement("div"); 
								altMes.innerHTML = '此流程进行过高级设置，现为您打开高级模式';
								var style = document.createElement('style');
								style.type = 'text/css';
								style.innerHTML=".altMes {width: 330px;height: 64px;background-color: #272727;position: absolute;top: 34%;left: 36%;font-size: 14px;color: white;filter: alpha(opacity=50);filter: alpha(opacity=50);-moz-opacity: 0.4;-khtml-opacity: 0.4; opacity: 0.4; text-align: center; vertical-align: middle; line-height: 64px;}";
								altMes.appendChild(style);
								altMes.className = "altMes";
								dialogFrameDiv.appendChild(altMes);
								clearInterval(myInterval);
								setTimeout(function(){
									(function(o,i,s){
										i=0.4;
										s=0.01;
										outInterval = setInterval((function(){
										 return(function(){
										 	i+=s;
											s = -0.05;
											if(o.filters)
											o.filters[0].opacity=i*100;
											else
											 o.style.opacity=i;
										 	if(i < 0)
											{
												clearInterval(outInterval);
												altMes.remove();
											}
										 })
										 })(),100);
									})(altMes);
								},2000);
							}
						})
					})(),100);*/
					//////////////////////////////

				    var altMesflog = true;
				    jQuery.ajax({
					    type: "POST",
					    url: "/rdeploy/wf/request/checkRecordMesConfig.jsp",
						cache: false,
						async:false,
						dataType: 'json',
						success: function(msg){
							altMesflog = msg.altMesFlog;
						}
					});
													  
				 if(altMesflog)
				 {
				 	myInterval = setInterval((function(){
								return(function(){
								var dialogFrameDocument = top.document.getElementById("_DialogFrame_"+dialog.ID).contentWindow.document;
								if(dialogFrameDocument != null){
									var dialogFrameDiv = dialogFrameDocument.getElementById('tabcontentframe').parentNode;
									
									var e8TreeSwitch = dialogFrameDocument.getElementById('e8TreeSwitch');
									
									if(e8TreeSwitch != null){
										e8TreeSwitch.remove();
									}
									
									var style = document.createElement('style');
									style.type = 'text/css';
									style.innerHTML = "@import url('/rdeploy/assets/css/wf/altmes.css')";
									
									var altDiv = document.createElement("div"); 
									altDiv.className = "altDiv";
									
									var altMes = document.createElement("div"); 
									altMes.innerHTML = '此流程进行过高级设置，现为您打开高级模式';
									altMes.className = "altMes";
									 
									var btnDiv = document.createElement("div"); 
									
									btnDiv.innerHTML = '我知道了，下次不再显示';
									btnDiv.className = "btnDiv";
									
									altDiv.appendChild(altMes);
									dialogFrameDiv.appendChild(style);
									dialogFrameDiv.appendChild(btnDiv);
									dialogFrameDiv.appendChild(altDiv);
									
									var flag = true;
									btnDiv.onclick = function(){
										jQuery.ajax({
										type: "POST",
										url: "/rdeploy/wf/request/recordMesConfig.jsp",
										cache: false,
										async:false,
										dataType: 'json'
										});
										flag = false;
										clearInterval(myInterval);
										
										(function(o,i,s){
											i=0.4;
											s=0.01;
											outInterval = setInterval((function(){
											 return(function(){
											 	i+=s;
												s = -0.05;
												if(o.filters)
												o.filters[0].opacity=i*100;
												else
												 o.style.opacity=i;
											 	if(i < 0)
												{
													clearInterval(outInterval);
													altDiv.remove();
												}
												
												if(i < 0.3)
												{
													btnDiv.remove();
												}
											 })
											 })(),50);
										})(altDiv);
									}
									
									if(flag)
									{
									clearInterval(myInterval);
									////////////////////
									var altDivLeft = width*0.36 + 110;
									var altDivTop = height*0.405 + 80;
									jQuery(btnDiv).css({"top":altDivTop+"px","left":altDivLeft+"px"});
									////////////////////
									setTimeout(function(){
										(function(o,i,s){
											i=0.4;
											s=0.01;
											outInterval = setInterval((function(){
											 return(function(){
											 	i+=s;
												s = -0.05;
												if(o.filters)
												o.filters[0].opacity=i*100;
												else
												 o.style.opacity=i;
											 	if(i < 0)
												{
													clearInterval(outInterval);
													altDiv.remove();
												}
												if(i < 0.3)
												{
													btnDiv.remove();
												}
											 })
											 })(),50);
										})(altDiv);
										
										
									},8000);
									}
								}
								})
								})(),100);
				 }
					//////////////////////////////
				}
  			});
  		});
  	</script>
  	
  	
  </head>
  <body>
  	<!-- 顶部 -->
	<jsp:include page="/rdeploy/indexTop.jsp" flush="false">
		<jsp:param name="modename" value="<%=modename %>"/>
		<jsp:param name="modeurl" value="<%=modeurl %>"/>
	</jsp:include>  
  
  	<div class="content">
  		<!-- item block 循环开始 -->
		<% 
		for(int z=0;z<wfidList.size();z++){ 
			int workflowid = Integer.parseInt((String) wfidList.get(z));
			//orderid = (String) orderidList.get(z);
			int contain = 0;
			WFManager.reset();
			WFManager.setWfid(workflowid);
  			WFManager.getWfInfo();
  			wfname = WFManager.getWfname();
  			isvalid=WFManager.getIsValid();
  			//System.out.println("workflowid = "+workflowid);
  			if(wfEditList.contains(String.valueOf(workflowid))){
  				contain = 1;
  			}
  		%>
  		<div class="item">
  			<div class="itemtitle">
  				<%=wfname%>
  			</div>
  			<div class="itemico" >
  				<% if("0".equals(isvalid)){%>
  				<img src="/rdeploy/assets/img/wf/wf_dis_wev8.png">
  				<%}else{ %>
  				<img src="/rdeploy/assets/img/wf/wf.png">
  				<%} %>
  			</div>
  			<!-- 流程状态 0：无效 1：有效 -->
  			<div class="itemoperation">
  				<% if("0".equals(isvalid)){%>
  				<span class="operationspan" style="background:url('/rdeploy/assets/img/wf/stop.png') 0 0 no-repeat;" status="<%=isvalid%>"></span>
  				<%}else{ %>
  				<span class="operationspan" style="background:url('/rdeploy/assets/img/wf/start.png') 0 0 no-repeat;" status="<%=isvalid%>"></span>
  				<%} %>
  			</div>
  			<input type="hidden" name="contain" value="<%=contain%>">
  			<input type="hidden" name="wfid" value="<%=workflowid%>">
  			<input type="hidden" name="wfname" value="<%=wfname%>">
  			<%--
  			<input type="hidden" name="orderid" value="<%=orderid%>"> --%>
  		</div><!-- item block -->
  		<%} %>
  	</div>

	<div id="shownavigation" style="display:none">
	  	<div class="wfnavigation" >
		  	<div class="secondimg"></div>
	  		<div class="secondmsg">鼠标移入可 <font size=4 color="green">启用</font>、<font size=4 color="red">禁用</font> 流程或进行流程设置！</div>
	  	</div>
	 	<div class="secondimgover"></div>
	 	<div class="secondbtn">我知道啦</div>
	</div>

  </body>
</html>
