
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.email.MailSend"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">
    <link rel="stylesheet" href="/mobile/plugin/1/css/r4_wev8.css" type="text/css">
    <link rel="stylesheet" href="/mobile/plugin/crm/css/crm_wev8.css" type="text/css">
</head>
<body style="padding: 0px;margin: 0px;height: 100%">


<%
	String customerid=Util.null2String((String)request.getParameter("customerid"));
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
	String opengps = Util.null2String((String)request.getParameter("opengps"));
	
	boolean canview=false;
	boolean canedit=false;
	
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),customerid);
	if(sharelevel>0){
	     canview=true;
	     //canviewlog=true;
	     //canmailmerge=true;
	     if(sharelevel==2) canedit=true;
	     if(sharelevel==3||sharelevel==4){
	         canedit=true;
	         //canapprove=true;
	     }
	}
%>


<table id="page"  style="width: 100%;"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" valign="top" align="left">
		<form action="/mobile/plugin/crm/ShareOperation.jsp?method=add&module=<%=module%>&scope=<%=scope%>&CustomerID=<%=customerid%>" method="post" name="weaver" id="weaver" enctype="multipart/form-data">
		
		<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
					<table style="width: 100%; height: 40px;">
						<tr>
							<td width="10%" align="left" valign="middle" style="padding-left:5px;">
							    <a href="/mobile/plugin/crm/CrmView.jsp?customerid=<%=customerid%>&module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>">
									<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
										<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>
									</div>
								</a>
							</td>
							<td align="center" valign="middle">
								<div id="title"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %></div>
							</td>
							<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									
							</td>
						</tr>
					</table>
			</div>
				
			<div class='listitem' >
	    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
			    	<tr>
					    	<td class='itempreview'></td>
					    	<td class='itemcontent' >
					    	  <%if(canedit){%>
					    		<div style="height:10px;overflow:hidden;"></div>
								<div class="blockHead">
							   		<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
							   			<tr>
							   				<td align="left"><span class="m-l-14">添加共享</span></td>
							   			</tr>
							   		</table>
								</div>
								<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
									<table id="head" cellspacing="0" cellpadding="0" style="width: 100%" class="mainFormTable">
											<tr>
										    	<td class="mainFormRowNameTD" align="left">共享类型</td>
										    	<td style="width:15px;"></td>
										    	<td width="*" class="mainFormRowValueTD">
										    		 <select id="sharetype" name="sharetype" onchange="changeType()">
										    		 	<option value="1">人力资源</option>
										    		 	<option	value="2">部门</option>
										    		 	<option value="4">所有</option>
										    		 </select>	
										    	</td>
											</tr>
											<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
											<tr class="sharevaluetr">
												 <td class="mainFormRowNameTD" align="left">共享内容</td>
												 <td style="width:15px;"></td>
												 <td width="*" class="mainFormRowValueTD">
												 	<div onclick="showDialog()"  id="selfid01" style="float: left;width: 30px; height: 36px;background: url('/images/search_icon_wev8.png') no-repeat;margin-top: 2px" class="selectPop"></div> 
							    					<div style="float: left;height: 36px;line-height: 36px;">	
								    					<input  type="hidden" name="relatedshareid" id="shareValue"   value="">
														<span id="forwardresources01"></span>	
														<span  id=tospan >
								    						<img src='/images/BacoError_wev8.gif' align="absMiddle" >
								    					</span>
							    					</div>
							    					<div style="clear: left;"></div>
												 </td>
											</tr>
											<tr width="100%" class="sharevaluetr"><td colspan="3" class="mainFromSplitLine"></td></tr>
											<tr>
												 <td class="mainFormRowNameTD" align="left">共享级别</td>
												 <td style="width:15px;"></td>
												 <td width="*" class="mainFormRowValueTD">
										    		<select id="sharelevel" name="sharelevel">
										    			<option value="1">查看</option>
										    			<option value="2">编辑</option>
										    		</select>
												 </td>
											</tr>
											<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
											<tr class="secleveltr" style="display: none;">
												 <td class="mainFormRowNameTD" align="left">安全级别</td>
												 <td style="width:15px;"></td>
												 <td width="*" class="mainFormRowValueTD">
										    		<input type="text" id="seclevel" name="seclevel" onblur="checkNumber(this)" value="0" style="width: 60%" maxlength="4"/>
												 </td>
											</tr>
											<tr class="secleveltr" width="100%" style="display: none;"><td colspan="3" class="mainFromSplitLine"></td></tr>
											<tr>
												<td colspan="3" align="center" class="mainFormRowValueTD">
													<div class="operationBtright  " onclick="submitdata()"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %></div>
												</td>
											</tr>
											<tr width="100%"><td colspan="3" class="mainFromSplitLine"></td></tr>
								</table>
								</div>
							    <%}%>
								<div style="height:10px;overflow:hidden;"></div>
								<div class="blockHead">
							   		<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
							   			<tr>
							   				<td align="left"><span class="m-l-14">共享信息</span></td>
							   			</tr>
							   		</table>
								</div>
								<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
									<table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
										<%
											rs.executeProc("CRM_ShareInfo_SbyRelateditemid",customerid);
											while(rs.next()){
												int id=rs.getInt("id");
												int shareType=rs.getInt("sharetype");
												//int sharelevel=rs.getInt("sharelevel");
										%>
										<tr class="share_<%=id%>">
											<td class="mainFormRowNameTD" align="left">
												<%if(shareType==1){%>
													<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
												<%}else if(shareType==2){%>
													<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
												<%}else if(shareType==3){%>
													<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
												<%}else if(shareType==4){%>
													<%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
												<%} %>
											</td>
											<td style="width:15px;"></td>
											<td width="*" class="mainFormRowValueTD">
												<%if(shareType==1){%>
													<%=Util.toScreen(ResourceComInfo.getResourcename(rs.getString("userid")),user.getLanguage())%>
												<%}else if(shareType==2){%>
													<%=Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(rs.getString("seclevel"),user.getLanguage())%>/
												<%}else if(shareType==3){%>
													<%=Util.toScreen(RolesComInfo.getRolesRemark(rs.getString("roleid")),user.getLanguage())%>/
													<% if(rs.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
													<% if(rs.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
													<% if(rs.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%> /
													<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(rs.getString("seclevel"),user.getLanguage())%>
												<%}else if(shareType==4){%>
													<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(rs.getString("seclevel"),user.getLanguage())%>
												<%} %>
													/
												 <% if(rs.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
												 <% if(rs.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
											</td>
											<td>
											<%if(canedit){%>
												<div class="operationBtright  " onclick="delShare(<%=id%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %></div>
											<%}%>
											</td>
										</tr>	
										<tr width="100%" class="share_<%=id%>"><td colspan="4" class="mainFromSplitLine"></td></tr>
										<%}%>
																		
									</table>
								</div>
							    
					    	</td>
					    	<td class='itemnavpoint'></td>
			    	</tr>
	    	</table>
    	</div> 
		</form>
	</td>
</tr>
</table>


<script type="text/javascript">
		
		function delShare(shareid){
		    if(confirm("确认删除共享？")){
				$.post("/mobile/plugin/crm/ShareOperation.jsp?method=delete&module=<%=module%>&scope=<%=scope%>&id="+shareid,{},function(data){
					$(".share_"+shareid).remove();
				})
			}
		}
		
		function checkNumber(obj){
			if(!isdigit($(obj).val()))
			   $(obj).val("0");
		}
		
		function isdigit(s){
			var r,re;
			re = /\d*/i; //\d表示数字,*表示匹配多个数字
			r = s.match(re);
			return (r==s)?true:false;
        }
		
		function changeType(){
			
			$("#forwardresources01").html("");
			$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
			$("#sharevalue").val("");
			$("#seclevel").val("0");
			var sharetype=$("#sharetype").val();
			$(".sharevaluetr").show();
			
			if(sharetype=="1"){
				$(".secleveltr").hide();
			}
			
			if(sharetype=="2"){
				$(".secleveltr").show();
			}
			
			if(sharetype=="4"){
				$(".secleveltr").show();
				$(".sharevaluetr").hide();
				$("#shareValue").val("1");
			}
			
		}
		function showDialog(){
				var _xuhao=$("#sharetype").val()
				var  selected_input=$("#selected_input").val();
				var  selected_selfid=$("#_selfid").val();
				var selectobj=$("#"+selected_input);
				var _selfid=$("#"+selected_selfid);
				var allid=_selfid.next().next().next().attr("id");
				if(_xuhao=="1"||_xuhao=="2"){
						 //点击的是人力资源
						var _totdid="forwardresources01";
						var _name="shareValue";
						var selids=$("#shareValue").val();
						var url="/mobile/plugin/crm/browser.jsp";
						var data="&returnIdField="+_name+"&returnShowField="+_totdid+"&method=listUser&isMuti=1&selids="+selids+"&allid="+allid;
						if(_xuhao=="2")
							data="&returnIdField="+_name+"&returnShowField="+_totdid+"&method=listDepartment&isMuti=1&selids="+"&allid="+allid;
								
						var top = ($( window ).height()-150)/2;
						var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
						$.open({
							id : "selectionWindow",
							url : url,
							data: "r=" + (new Date()).getTime() + data,
							title : "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>",
							width : width,
							height : 155,
							scrolling:'yes',
							top: top,
							callback : function(action, returnValue){
							}
						}); 
						$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() +data);  
				}
		}
	
	
		//发送邮件
		function submitdata(){
			if($("#sharetype").val()=="4"||checkRequired()){
				//$("#weaver").submit();
			
				var formData=$("#weaver").serialize()+"&data="+new Date().getTime();
				$.post("/mobile/plugin/crm/ShareOperation.jsp?method=add&module=<%=module%>&scope=<%=scope%>&CustomerID=<%=customerid%>&"+formData, "", function(Data){
						window.location.reload();	
				});
			
			}
		}
		
		
		function Savedata(){
				if(checkRequired()){
					//$("#mouldtext").attr("value",$("#mouldtext").val());
					$("#folderid").attr("value","-2");//设置为草稿状态
					$("#savedraft").attr("value","1");//只保存到草稿
					 if(flag!="4"){
					 	//非草稿状态的邮件不要传递邮件id到后台
					 	$("#mailid").val("");
					 } 
					$("#weaver").submit();
				}
		}	
			
		function checkRequired()
	 	{
	 		var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			if(temp!=0){
				alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>"+"!");
				return false;
			}else{
				return true;
			}
	 	}
	 	function closeDialog(){
	 			$.close("selectionWindow");
	 			var internalto=$("#internalto").val();
	 			var internaltodpid=$("#internaltodpid").val();
	 			var internaltoall=$("#internaltoall").val();
	 			if(internalto==""&&internaltodpid==""&&internaltoall==""){
	 				$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
	 			}else{
	 				$("#tospan").html("");
	 			}
	 	}
	 	function getDialogId(){
				return "selectionWindow";
	 	}

		//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
		function doLeftButton() {
				window.location.href="/mobile/plugin/crm/CrmView.jsp?customerid=<%=customerid%>&module=<%=module%>&scope=<%=scope%>&opengps=<%=opengps%>";
				return "1";
		}
		
		function getLeftButton(){
				return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		
		// 取消输入框后面跟随的红色惊叹号
		function checkinput02(elementname,spanid){
				
			var tmpvalue = $("#"+elementname).value;
		
			// 处理$GetEle可能找不到对象时的情况，通过id查找对象
		    if(tmpvalue==undefined)
		        tmpvalue=document.getElementById(elementname).value;
		
			while(tmpvalue.indexOf(" ") >= 0){
				tmpvalue = tmpvalue.replace(" ", "");
			}
			if(tmpvalue != ""){
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}
			
				if(tmpvalue != ""){
					$("#"+spanid).html("");
				}else{
					$("#"+spanid).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
					//$GetEle(elementname).value = "";
				}
			}else{
				$("#"+spanid).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				//$GetEle(elementname).value = "";
			}
		}

</script>

</body>
</html>