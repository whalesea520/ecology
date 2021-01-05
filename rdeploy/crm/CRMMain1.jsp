<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@page import="weaver.crm.customer.CustomerLabelVO"%>
<%@page import="weaver.blog.HrmOrgTree"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerLabelService" class="weaver.crm.customer.CustomerLabelService" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<%

	String userid=user.getUID()+"";
	//标签id
	String labelid=Util.null2String(request.getParameter("labelid"));
	
	String name="";
	HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
%>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/CRM/css/Base1_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/CRM/js/customerUtil_wev8.js"></script>

<link type='text/css' rel='stylesheet'  href='/CRM/js/tree/js/treeviewAsync/eui.tree_wev8.css'/>
<link type='text/css' rel='stylesheet'  href='/CRM/css/tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/CRM/js/tree/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/CRM/js/tree/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>

<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css">

<link type="text/css" href="/CRM/css/Base_wev8.css" rel=stylesheet>
</head>
<style>
.scroll1{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #E0E0E0 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
			  	SCROLLBAR-FACE-COLOR: #ffffff;
}
::-webkit-scrollbar-track-piece{
	background-color:#E2E2E2;
	-webkit-border-radius:0;
}
::-webkit-scrollbar{
	width:12px;
	height:8px;
}
::-webkit-scrollbar-thumb{
	height:50px;
	background-color:#CDCDCD;
	-webkit-border-radius:1px;
	outline:0px solid #fff;
	outline-offset:-2px;
	border: 0px solid #fff;
}
::-webkit-scrollbar-thumb:hover{
	height:50px;
	background-color:#BEBEBE;
	-webkit-border-radius:1px;
}
.treeview .hitarea{
	background:url('/CRM/images/icon_arrow2_wev8.png') no-repeat center center;
	height:26px;
}
.treeview .collapsable-hitarea{
	background:url('/CRM/images/icon_arrow1_wev8.png') no-repeat center center;
}
.treeview li{background:none}
span.person{padding:1px 0px 1px 0px;background:none}
.hrmOrg span.person{padding:1px 0px 1px 0px;background:none}
.hrmOrg a{color:#000}
.labelName{color: white;padding-left:5px;padding-right:5px;line-height: 22px;};
.topImgMenu{background:none;border:none !important;}
.menuitem1{
  height: 31px;
  line-height: 31px;
  color: #786571;
  cursor: pointer;
  float: left;
  text-align: center;
  border: 1px solid #f2f2f2;
  height: 28px;
  margin-right: 5px;
  margin-top: 5px;
  width:82px;
}
.menuitem1-l{width:60px;text-align:center;}
#listoperate{width:auto;}
.searchInput{width:95px;}
TABLE.ListStyle TR.DataLight:hover TD, TABLE.ListStyle TR.DataDark:hover TD, TABLE.BroswerStyle TR.DataDark:hover TD, TABLE.BroswerStyle TR.DataLight:hover TD{
	border-bottom: 1px solid #f2f2f2 !important;
}
</style>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	
	int currentMonth=Calendar.getInstance().get(Calendar.MONTH)+1;
	
	int count = CustomerStatusCount.getContactNumber(user.getUID()+"");
	int birthdayCount=CustomerService.getBirthdayCount(userid,currentMonth);
%>
	<BODY style="overflow: hidden;">
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	
	<div class="width100 title-bg" style="border-bottom: 1px solid #eeeeee;">
      <table width="100%" height="60px" cellpadding="0" cellspacing="0">
          <colgroup><col width="60px"><col width="*"><col width="280px"></colgroup>
          <tr>
            <td style="padding:0 10px;">
              <img src="/rdeploy/assets/img/cproj/bcstom.png" width="40px" height="40px">
            </td>
            <td>
               <div class="margin-top--4">
	               <span class="size14">
	                 客户
	               </span>
	               <div class="h2"></div>
	               <span class="color-2">
	                   维护客户资源
	               </span>
               </div>
            </td>
            <td class="padding-right-20">
            	<div style="width:90px;height:30px;line-height:30px;background:#4ba9df;color:#fff;border-radius:5px;text-align:center;float:right;cursor:pointer;">
                	<span><img src="/rdeploy/crm/image/crm_import.png"></span>
                	<span>导入客户</span>
                </div>
                <div onclick="addCRM()" style="width:90px;height:30px;line-height:30px;background:#80d426;color:#fff;border-radius:5px;text-align:center;float:right;margin-right:15px;cursor:pointer;">
                	<span><img src="/rdeploy/crm/image/crm_add.png"></span>
                	<span>新建客户</span>
                </div>
                <div style="clear:both;"></div>
            </td>
          </tr>
        </table>
    </div>
    
	<div style="position:absolute;top: 62px;bottom:0px;width:100%" id="maindiv">
	 	<div id="leftdiv" class="northDiv left" style="border-right:1px solid #f2f2f2;height:100%;width:576px;">
	 		<div id="listoperate" style="height:40px;padding-left:15px;border-bottom: 1px solid #f2f2f2;">
	 			<div id="checkType"  class="main_btn menuitem1" style="width:20px;margin-right:5px;display:none;" >
					<div class="menuitem1-l">
						<span id="checkBox"><input id="chkALL" type="checkbox" onclick="setCheckState(this)"/></span>
					</div>
				</div>
				<%
				boolean isShowResource=labelid.equals("my")&&hrmOrg.isHavaHrmChildren(userid);
				isShowResource=true;
				%>
				<div id="resource" _value="<%=userid%>"  class="main_btn menuitem1" style="text-align:left;<%=isShowResource?"":"display:none"%>;" onclick="showMenu(this,'resourceMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
						<%=ResourceComInfo.getLastname(userid)%>
					</div>	
					<div class="marrow"></div>
					
				</div>
				<div id="viewtype" _value="0" class="main_btn menuitem1" style="<%=isShowResource?"":"display:none"%>" onclick="showMenu(this,'viewtypeMenu',event)">
					<div class="menuitem1-l">
						<span class="menuName"><%=SystemEnv.getHtmlLabelName(84345,user.getLanguage())%></span>
					</div>
					<div class="marrow"></div>
				</div>
				
				<div id="status" _value="" class="main_btn menuitem1" style="margin-right: 3px;" onclick="showMenu(this,'statusMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelNames("82857,25102",user.getLanguage())%>
					</div>	
					<div class="marrow"></div>
				</div>
				
				<div id="sector" _value="" class="main_btn menuitem1" style="width:65px;margin-right: 3px;display:none;" onclick="showMenu(this,'sectorMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:50px;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelNames("82857,575",user.getLanguage())%>
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				
				<div id="markType"  class="main_btn menuitem1" style="width:60px;margin-right: 3px;display:none;" onclick="showMenu(this,'markTypeMenu',event)">
					<div class="menuitem1-l">
						<span id="sortTypeName"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></span>
					</div>	
					<div class="marrow"></div>
				</div>
				
				<div id="operation"  class="main_btn menuitem1" style="width:135px;float: right;border:0px;">
					<span id="searchblockspan">
						<span class="searchInputSpan" id="searchInputSpan" style="position:relative;top:0px;height:28px;">
							<input type="text" placeholder="搜索客户" class="searchInput middle" name="flowTitle" value="" style="vertical-align: top;height:26px;">
							<span class="middle searchImg" onclick="searchCustomerName()">
								<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
							</span>
						</span>
					</span>
				</div>
				
				<div id="resourceMenu" class="drop_list" style="width:135px;overflow: auto;">
				    <div onclick="stopBubble(event)" class="btn_add_label" id="subOrgDiv">
				    	<div class="mine" onclick="showSubTree(this)">
				    		<a href="javascript:doClick(<%=userid%>,4,this,'<%=ResourceComInfo.getLastname(userid)%>')"><%=ResourceComInfo.getLastname(userid)%></a>
				    	</div>
				    </div>
				</div>
				
				<div id="viewtypeMenu" class="drop_list" style="width:82px;overflow: auto;">
				    <div class="btn_add_type" onclick="doChange(this,'viewtype',0)" _value="0"><%=SystemEnv.getHtmlLabelName(84345,user.getLanguage())%></div><!-- 全部 -->
					<div class="btn_add_type" onclick="doChange(this,'viewtype',1)" _value="1"><%=SystemEnv.getHtmlLabelName(84346,user.getLanguage())%></div><!-- 全部 -->
					<div class="btn_add_type" onclick="doChange(this,'viewtype',2)" _value="2"><%=SystemEnv.getHtmlLabelName(84347,user.getLanguage())%></div><!-- 全部 -->
				</div>
				
				<div id="operationMenu" class="drop_list" style="width:75px;overflow: auto;">
				    <div class="btn_add_type" onclick="markItemAsType(this)" _markType="add"><%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%></div><!-- 全部 -->
					<div class="btn_add_type" onclick="markItemAsType(this)" _markType="import"><%=SystemEnv.getHtmlLabelName(18038,user.getLanguage())%></div><!-- 全部 -->
					<div class="btn_add_type" style="display:none;" onclick="markItemAsType(this)" _markType="unread"><%=SystemEnv.getHtmlLabelName(21443,user.getLanguage())%></div><!-- 全部 -->
				</div>
				
				<!-- 状态 -->
				<div id="statusMenu" class="drop_list" style="width:120px;overflow: auto;">
					<div class="btn_add_type" onclick="doChange(this,'status','')"><%=SystemEnv.getHtmlLabelNames("82857,25102",user.getLanguage())%></div>
					<% 
						CustomerStatusComInfo.setTofirstRow();
						while(CustomerStatusComInfo.next()){
					%>
						<div class="btn_add_type" onclick="doChange(this,'status',<%=CustomerStatusComInfo.getCustomerStatusid()%>)"><%=CustomerStatusComInfo.getCustomerStatusname() %></div>
					<%}%>	
				</div>
				
				<!-- 行业 -->
				<div id="sectorMenu" class="drop_list" style="width:120px;overflow: auto;">
					<div class="btn_add_type" onclick="doChange(this,'sector','')"><%=SystemEnv.getHtmlLabelNames("82857,575",user.getLanguage())%></div>
					<% 
						SectorInfoComInfo.setTofirstRow();
						while(SectorInfoComInfo.next()){
					%>
						<div class="btn_add_type" onclick="doChange(this,'sector',<%=SectorInfoComInfo.getSectorInfoid()%>)"><%=SectorInfoComInfo.getSectorInfoname()%></div>
					<%}%>	
				</div>
				
				<div id="markTypeMenu" class="drop_list" style="width:120px;">
					    <div class="btn_add_type" onclick="markAsImportant(this)" _important="1"><%=SystemEnv.getHtmlLabelNames("25397",user.getLanguage())%></div><!-- 全部 -->
					    <div class="btn_add_type" onclick="markAsImportant(this)" _important="0"><%=SystemEnv.getHtmlLabelNames("25422",user.getLanguage())%></div><!-- 任务 -->
					    <div class="line-1"><div></div></div>
					    <%
					    List labelList=CustomerLabelService.getLabelList(userid+"","all");          //标签列表
					    for(int i=0;i<labelList.size();i++){
					    	CustomerLabelVO labelVO=(CustomerLabelVO)labelList.get(i);
					    	String labelId=labelVO.getId();
					    	String labelName=labelVO.getName();
					    	String labelColor =labelVO.getLabelColor();
					    %>
					    <div onclick="stopBubble(event)" class="btn_add_label" _markType="label" _labelid="<%=labelId%>">
					    	<input type="checkbox" value="<%=labelId%>" name="labelcheck"/>
					    	<span  class="labelName" style="background-color:<%=labelColor%>;"><%=labelName%></span>
					    </div>
					    <%}%>
					    <div class="btn_add_label">
					    	<div style="float: left;" onclick="applyLabels()"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></div>
					    	<div style="float: left;padding-left: 17px;" onclick="cancelLabels()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%></div>
					    	<div style="float: right;" onclick="labelManage()"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></div>
					    	<div style="clear: left;"></div>
					    </div>
				</div>
				
		    </div>
		    <div id="listdiv" style="width: 100%;height: 100%;overflow:auto" class="scroll1">
		    	<table id='list' class="ListStyle" cellspacing="1" style="margin:0px;width:100%">
					 	<colgroup>
						<col width="40%">
						<col width="20%">
						<col width="20%">
						<col width="20%">
						</colgroup>
						<tbody>
							<tr style="border-bottom:1px solid #E6E6E6;height:40px;">
								<td style="color:#8e9598;width:40%;">客户名称</td>
								<td style="color:#8e9598;width:20%;">客户经理</td>
								<td style="color:#8e9598;width:20%;">联系人</td>
								<td style="color:#8e9598;width:20%;">手机</td>
							</tr>
						</tbody>
						<tbody id="list_body">
							
						</tbody>
				  </table>
				  <div id="loadingdiv1" title="<%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>	" style="width: 100%;margin-bottom:10px;margin-top:10px;" align="center">
				         <img src='/express/task/images/loading1_wev8.gif' align="absMiddle">
				  </div>
		    </div>
	 	</div>
	 	 
	    <div id="rightdiv" class="centerDiv left" style="width:570px;overflow: hidden;height:100%">
	    	<iframe id='rightframe' src='ContactDefaultView.jsp' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
	    </div> 
	</div>    
	
	<style>
	#customerDetail {
		border: 0;
	  	box-shadow: 0 7px 21px rgba(0,0,0,0.25);
	  	width:0px;
	  	display:none;
	  	position: absolute;
	  	z-index: 9995;
	  	right:0px;
	  	top: 0px;
	  	bottom:0px;
	  	background-color: #fff;
	  	font-size: 12px;
	}
	</style>
	
	<div id="customerDetail">
		<iframe id='detailframe' src='' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
	</div>
	
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>		
		
		<script type="text/javascript">
			var layout="1";
			$(document).ready(function(){
				
				jQuery("#topTitle").topMenuTitle({searchFn:searchCustomerName});
				jQuery("#hoverBtnSpan").hoverBtn();
				
				viewDefault();
				initWidth();
				initHeight();
				initData();
				
				$(document.body).bind("click",function(){
					$("#customerDetail").css("display", "block").animate({
						'width': '0px'
					}, 400, function(){
					})
				});
			});
			
			//打开消息记录
			function addCRM(obj){
				var title="新建客户";
			    var url="/rdeploy/crm/CRMAdd.jsp";
				var diag=getPopDialog(title,720,550);
				diag.URL =url;
				diag.show();
				document.body.click();
			}
			
			function getPopDialog(title,width,height){
			    var diag =new window.top.Dialog();
			    diag.currentWindow = window; 
			    diag.Modal = true;
			    diag.Drag=true;
				diag.Width =width?width:680;	
				diag.Height =height?height:420;
				diag.ShowButtonRow=false;
				diag.Title = title;
				return diag;
			}
			
			function doChange(obj,target,value){
				
				var targetObj=$("#"+target);
				var menuName=$(obj).text();
				targetObj.find(".menuName").html(menuName);
				
				//targetObj.find(".marrow").hide();
				targetObj.attr("_value",value);
				
				reloadData();
			}
			
			function reloadData(){
				$("#list_body").html(""); //清空列表数据
				resetScrollParam();	 //重置滚动加载参数
				getData();
				viewDefault();
			}
			
			function getData(){
			
				var name =$(".searchInput").val();
				var params=getParams();
				$("#loadingdiv1").show();
			    $.post("/rdeploy/crm/CustomerList.jsp?"+params,{pageindex:pageindex,index:index,pagesize:pagesize},function(data){
			    
					    $("#list_body").append(data);
					    hght=0;//恢复滚动条总长，因为$("#mypage").scroll事件一触发，又会得到新值，不恢复的话可能会造成判断错误而再次加载……
					    stop=0;//原因同上。
					    flag=true;
					    jQuery('body').jNice();
					    $("#loadingdiv1").hide();
				});
			}
			
			function getParams(){
			
				var labelid="<%=labelid%>";
				var resourceid=$("#resource").attr("_value");
				var viewtype=$("#viewtype").attr("_value");
				var sector=$("#sector").attr("_value");
				var status=$("#status").attr("_value");
				var name =decodeURIComponent($(".searchInput").val());
				
				var params="labelid="+labelid+"&resourceid="+resourceid+"&viewtype="+viewtype+"&sector="+sector+"&status="+status+"&name="+name;
				
				return params;
			}
			
			function viewDefault(){
				var params=getParams();
				$("#rightframe").attr("src","ContactDefaultView.jsp?"+params);
			}
			
			function viewDetail(customerid,obj){
				$("#list").find("tr.selected").removeClass("selected");
				$(obj).parents("tr:first").addClass("selected");
				
				$("#customerDetail").css("display", "block").animate({
					'width': '620px'
				}, 400, function(){
					$("#detailframe").attr("src","CRMView.jsp?CustomerID="+customerid);
				})
				stopEvent();
				//$("#rightframe").attr("src","ContactDetailView.jsp?customerid="+customerid);
			}
			
			function stopEvent() {
				if (event.stopPropagation) { 
					// this code is for Mozilla and Opera 
					event.stopPropagation();
				} 
				else if (window.event) { 
					// this code is for IE 
					window.event.cancelBubble = true; 
				}
				return false;
			}
			
			function doClick(reaourceid,deptid,obj,name){
				var targetObj=$("#resource");
				targetObj.find(".menuName").html(name);
				targetObj.attr("_value",reaourceid);
				$(".drop_list").hide();
				reloadData();	
			}
			
			function setCheckState(obj){
				$("#listdiv").find("input[name='check_node']").each(function(){
					changeCheckboxStatus(this,obj.checked);
			 	});
			}
			
			function labelManage(){
	
			    var title="<%=SystemEnv.getHtmlLabelName(30884,user.getLanguage()) %>";
				diag=getDialog(title,680,400);
				diag.URL = "/CRM/customer/CrmLabelSetting.jsp";
				diag.show();
				
				//$(diag.okButton).hide();
				
				document.body.click();
			}
			
			//应用标签
			function applyLabels(){
				
				var customerids ="";
				$("#listdiv").find("input[name='check_node']:checked").each(function(){
					customerids+=","+$(this).val();
				});
				
				if(customerids==""){
					showAlert("<%=SystemEnv.getHtmlLabelName(84348,user.getLanguage())%>");
					return true;
				}
				customerids=customerids.substr(1);
				
				var labelids='';
				$("input[name=labelcheck]:checked").each(function(){
					labelids=labelids+","+$(this).val();
				});
				labelids=labelids.length>0?labelids.substr(1):labelids;
				
				jQuery.post("/CRM/customer/CrmLabelOperation.jsp", {customerid:customerids,type:"addLabel",labelids:labelids},function(data){
		        	
				});
			}
			
			function cancelLabels(){
				
				var customerids ="";
				$("#listdiv").find("input[name='check_node']:checked").each(function(){
					customerids+=","+$(this).val();
				});
				
				if(customerids==""){
					showAlert("<%=SystemEnv.getHtmlLabelName(84348,user.getLanguage())%>");
					return true;
				}
				customerids=customerids.substr(1);
				
				var labelids='';
				$("input[name=labelcheck]:checked").each(function(){
					labelids=labelids+","+$(this).val();
				});
				labelids=labelids.length>0?labelids.substr(1):labelids;
				
				jQuery.post("/CRM/customer/CrmLabelOperation.jsp", {customerid:customerids,type:"cancelLabel",labelids:labelids},function(data){
		        	
				});
			}
			
			function labelManageCallback(){
				diag.close();
				window.parent.location.reload();
			}
			
			function markImportant(obj){
				var customerid=$(obj).attr("_customerid");
				var important=$(obj).attr("_important");
				$.post("/CRM/customer/Operation.jsp?operation=markimportant&customerid="+customerid+"&important="+important,function(){
					if(important=="1")
					   $(obj).removeClass("important").addClass("important_no").attr("_important","0");
					else
					   $(obj).removeClass("important_no").addClass("important").attr("_important","1");   
				});
			}
			
			function markAsImportant(obj){
			
				if($("#listdiv").find("input[name='check_node']:checked").length==0){
					showAlert("<%=SystemEnv.getHtmlLabelName(84348,user.getLanguage())%>");
					return true;
				}
				var important=$(obj).attr("_important");
				
				$("#listdiv").find("input[name='check_node']:checked").each(function(){
					var customerid=$(this).val();
					var $this=$(this);
					$.post("/CRM/customer/Operation.jsp?operation=markAsImportant&customerid="+customerid+"&important="+important,function(){
						if(important=="1")
						   $this.parents("tr:first").find(".important_no").removeClass("important_no").addClass("important").attr("_important","1");
						else
						   $this.parents("tr:first").find(".important").removeClass("important").addClass("important_no").attr("_important","0");   
					});
				});
				
			}
			
			function showMenu(obj,target,e){
				$(".drop_list").hide();
				var targetHeight=$("#"+target).height();
				if(targetHeight>300)
					$("#"+target).height(300);
				$("#"+target).css({
					"left":(target=='checkTypeMenu'?0:$(obj).position().left)+"px",
					"top":($(obj).position().top+(target=='checkTypeMenu'?10:34))+"px"
				}).show();
				
				stopBubble(e);
			}
			
			function searchCustomerName(){
				$("#list_body").html(""); //清空列表数据
				resetScrollParam();	 //重置滚动加载参数
				getData();
			}
			
			window.onresize=function(){
				setTimeout(function(){
					initWidth(); 
					initHeight();
				},500);
			}
			
			function initWidth(){
				var mainWidth=document.body.clientWidth;
				$("#maindiv").width(mainWidth);
				//$("#leftdiv").width(mainWidth*0.5);
				$("#leftdiv").animate({width:mainWidth*0.5},200,null,function(){
				
				});
				var leftWidth=$("#leftdiv").width();
				$("#rightdiv").animate({width:mainWidth*0.5-2},200,null,function(){
				
				});
				//$("#rightdiv").width(mainWidth-leftWidth-2);
			}
			
			function initHeight(){
				var mainHeight=document.body.clientHeight;
				var operateHeight=$("#listoperate").height();
				$("#listdiv").height(mainHeight-operateHeight-61);
			}
			
			function initData(){
				$(document.body).bind("click",function(){
					$(".drop_list").hide();
				})
				$(".btn_add_type").hover(function(){
					$(this).addClass("btn_add_type_hover");
				},function(){
					$(this).removeClass("btn_add_type_hover");
				});
				
				$("#searchInputSpan").hover(function(){
					$(this).addClass("searchImg_hover");
				},function(){
					$(this).removeClass("searchImg_hover");
				});
				
				$(".searchInput").bind("keypress",function(e){
					if(e.keyCode==13){
						searchCustomerName();
					}
				});
				
				jQuery("#subOrgDiv").append('<ul id="subOrgTree" _status="1" class="hrmOrg" style="width:100%;outline:none;"></ul>');
				jQuery("#subOrgTree").treeview({
			       url:"/blog/hrmOrgTree.jsp",
			       root:"hrm|<%=user.getUID()%>"
			    });
			    
			    $(".expandable-hitarea").bind("click",function(){
			    	var subOrgDivHeight=$("#subOrgDiv").height();
			    	if(subOrgDivHeight>300)
			    		$("#resourceMenu").height(300);
			    	else
			    		$("#resourceMenu").height(subOrgDivHeight);	
			    	
			    });
			}
			
			function doMouseover(obj){
				var type=$(obj).attr("_type");
				$(obj).attr("src","/CRM/images/icon_"+type+"_h_wev8.png");
			}
			
			function doMouseout(obj){
				var type=$(obj).attr("_type");
				$(obj).attr("src","/CRM/images/icon_"+type+".png");
			}
			
			//阻止事件冒泡函数
			 function stopBubble(e)
			 {
			     if (e && e.stopPropagation){
			         e.stopPropagation()
			     }else{
			         window.event.cancelBubble=true
			     }
			}
			function doSearch(e){
				e=e?e:window.event;
				$("#mainForm").submit();
			}
			
			function reLoadList(){
				
			}
			
			function showSubTree(obj){
				
				if($('#subOrgTree').attr('_status')=='1'){
					$('#subOrgTree').hide().attr('_status','0');
					$(obj).css("background-image",'url("/CRM/images/icon_arrow2_wev8.png")');
				}else{ 
					$('#subOrgTree').show().attr('_status','1');
					$(obj).css("background-image",'url("/CRM/images/icon_arrow1_wev8.png")');
				}
			}
			
			function batchApproval(){
				$("#listFrame")[0].contentWindow.batchApproval();
			}
			
			var index=30;           //起始读取下标
			var hght=0;             //初始化滚动条总长
			var stop=0;              //初始化滚动条的当前位置
			var preTop=0;           //滚动条前一个位置，向上滚动时不加载数据
			var pagesize=30;        //每一次读取数据记录数
			var total=0;   //记录总数
			var flag=false;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
			var timeid; //定时器
			var pageindex=1;
			$(document).ready(function(){//DOM的onload事件
			    
			    getData();
				$("#listdiv").scroll( function() {//定义滚动条位置改变时触发的事件。
				    hght=this.scrollHeight;//得到滚动条总长，赋给hght变量
				    stop=this.scrollTop;//得到滚动条当前值，赋给top变量
				});
			    
			   	timeid=setInterval("cando();",500);
				
			});
			
			function resetScrollParam(){
				index=30;          
				hght=0;            
				stop=0;             
				preTop=0;           
				pagesize=30;       
				total=0;  
				flag=false;         
				window.clearInterval(timeid);
				pageindex=1;
			}
			
			function cando(){ 
				if(stop>parseInt(hght/6)&&preTop<stop){//判断滚动条当前位置是否超过总长的1/3，parseInt为取整函数,向下滚动时才加载数据
				    show();
				}
			    preTop=stop;//记录上一个位置
			}
			
			function show(){
			    if(flag){
					index=index+pagesize;
					if(index>total){                    //当读取数量大于总数时
					   index=total;                     //页面数据量等于数据总数
					   window.clearInterval(timeid);    //清除定时器
					}
					flag=false;
			        pageindex++;
				    getData();
				}
			}
			
			function setTotal(totalvalue){
				total=totalvalue;
				if(total<=index)
				   window.clearInterval(timeid);    //清除定时器
			}
			
			function openWindow(url){
				window.open(url);
			}
			
		</script>	
	</body>
</html>