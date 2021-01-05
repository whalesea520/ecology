<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="ctutil" class="weaver.workrelate.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<% 
	boolean canedit = false;
	//判断是否有权限
	if (HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)) {
		canedit = true;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style type="text/css">
			.maintable,.listtable{width: 100%;}
			.maintable td,.listtable td{line-height: 28px;padding-left: 5px;}
			.maintable td.title{background: #E9E7D8;}
			.listtable td{border-bottom: 1px #F1F0E7 solid;}
			.listtable tr.header td{font-weight: bold;border-bottom: 1px #DDD9C3 solid;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<%
		String type = Util.fromScreen3(request.getParameter("resourcetype"), user.getLanguage());
		String orgId = Util.fromScreen3(request.getParameter("resourceid"), user.getLanguage());

		String titlename = "";
		if (type.equals("1")) {
			titlename += CompanyComInfo.getCompanyname(orgId);
		} else if (type.equals("2")) {
			titlename += SubCompanyComInfo.getSubCompanyname(orgId);
		} else if (type.equals("3")) {
			titlename += DepartmentComInfo.getDepartmentname(orgId);
		} else if (type.equals("4")){
			titlename += ResourceComInfo.getLastname(orgId);
		}
		titlename += "计划报告基础设置";

		String setid = "";
		int isweek = 0;       
		int ismonth = 0;  
		int iswremind = 0;       
		int ismremind = 0;  
		int wstarttype = 0;      
		int wstartdays = 0;      
		int wendtype = 0;        
		int wenddays = 0;        
		int mstarttype = 0;      
		int mstartdays = 0;      
		int mendtype = 0;        
		int menddays = 0;        
		String programcreate = "";
		String reportaudit = "";   
		int manageraudit = 0;
		String reportview = "";
		int isself = 0;           
		int ismanager = 0;       
		String docsecid = "";
		String docpath = "";
		String sql = "select * from PR_BaseSetting where resourceid=" + orgId + " and resourcetype=" + type;
		rs.executeSql(sql);
		if(rs.next()){
			setid = Util.null2String(rs.getString("id"));
			isweek = Util.getIntValue(rs.getString("isweek"),0);      
			ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
			iswremind = Util.getIntValue(rs.getString("iswremind"),0);      
			ismremind = Util.getIntValue(rs.getString("ismremind"),0);      
			wstarttype = Util.getIntValue(rs.getString("wstarttype"),0);     
			wstartdays = Util.getIntValue(rs.getString("wstartdays"),0);     
			wendtype = Util.getIntValue(rs.getString("wendtype"),0);       
			wenddays = Util.getIntValue(rs.getString("wenddays"),0);       
			mstarttype = Util.getIntValue(rs.getString("mstarttype"),0);     
			mstartdays = Util.getIntValue(rs.getString("mstartdays"),0);     
			mendtype = Util.getIntValue(rs.getString("mendtype"),0);       
			menddays = Util.getIntValue(rs.getString("menddays"),0);       
			programcreate = ctutil.cutString(rs.getString("programcreate"),",",3);  
			reportaudit = ctutil.cutString(rs.getString("reportaudit"),",",3);  
			manageraudit = Util.getIntValue(rs.getString("manageraudit"),0);    
			reportview = ctutil.cutString(rs.getString("reportview"),",",3);  
			isself = Util.getIntValue(rs.getString("isself"),0);         
			ismanager = Util.getIntValue(rs.getString("ismanager"),0);   
			docsecid = Util.null2String(rs.getString("docsecid"));  
		}
		if(!docsecid.equals("") && !docsecid.equals("0")){
			/* int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(docsecid), -1);
		    int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid), -1);
			docpath = "/"+MainCategoryComInfo.getMainCategoryname(mainid+"")+
	    		"/"+SubCategoryComInfo.getSubCategoryname(subid+"")+
	    		"/"+SecCategoryComInfo.getSecCategoryname(docsecid); */
			docpath = SecCategoryComInfo.getAllParentName(docsecid);
	    	if(!"".equals(docpath)) docpath += "/";
			docpath += SecCategoryComInfo.getSecCategoryname(docsecid);
		}
	%>
	<BODY style="overflow: auto">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			if(canedit){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				if(type.equals("2")){
					RCMenu += "{应用到下级分部,javascript:doSync(this),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
				if(type.equals("3") && !"".equals(setid)){
					RCMenu += "{删除设置,javascript:delData(this),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="baseForm" name="baseForm" action="BaseOperation.jsp" method="post">
			<input type="hidden" name="setid" value="<%=setid %>">
			<input type="hidden" name="resourceid" value="<%=orgId %>">
			<input type="hidden" name="resourcetype" value="<%=type %>">
			<input type="hidden" id="operation" name="operation" value="">
			<input class=inputstyle type="hidden" name=num value="" />
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				</colgroup>
				<tr>
					<td height="1" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<div style="width: 100%;line-height: 28px;border-bottom:2px #D6D6D6 solid;font-size: 14px;font-weight: bold;margin-bottom: 10px;">
							<%=titlename %>
						</div>
						<%if(type.equals("2")){%>
						<table class="maintable" cellspacing="5" border="0">
							<colgroup><col width="20%"/><col width="80%"/></colgroup>
							<tr>
								<td class="title">启用报告周期</td>
								<td>
									<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="isweek" name="isweek" onclick="changeCon(this)" _index="1" <%if(isweek==1){%> checked="checked" <%}%> value="<%=isweek %>"/>周报告&nbsp;
									<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="ismonth" name="ismonth" onclick="changeCon(this)" _index="2" <%if(ismonth==1){%> checked="checked" <%}%> value="<%=ismonth %>"/>月报告
								</td>
							</tr>
							<tr>
								<td colspan="2" class="title">提交起止时间</td>
							</tr>
							<tr>
								<td colspan="2">
									<table class="listtable" cellpadding="0" cellspacing="0" border="0">
										<colgroup><col width="25%"/><col width="25%"/><col width="25%"/><col width="25%"/></colgroup>
										<tr class="header">
											<td>类型</td><td>开始时间</td><td>截止时间</td><td>是否提醒</td>
										</tr>
										<tr id="ds_1" <%if(isweek==0){%>style="display: none"<%} %>>
											<td>周报</td>
											<td>
												结束
												<%if(canedit){ %>
												<select id="wstarttype" name="wstarttype"><option value="1" <%if(wstarttype==1){ %> selected="selected" <%} %>>后</option><option value="-1" <%if(wstarttype==-1){ %> selected="selected" <%} %>>前</option></select>
												<input type="text" size="5" maxlength="10" id="wstartdays" name="wstartdays" onkeypress="ItemCount_KeyPress()" onBlur="checkcount('wstartdays')" value="<%=wstartdays %>"/>
												<%}else{ %>
													<%if(wstarttype==-1){ %>前<%}else{ %>后<%} %>
													<%=wstartdays %>
												<%} %>
												天
											</td>
											<td>
												结束
												<%if(canedit){ %>
												<select id="wendtype" name="wendtype"><option value="1" <%if(wendtype==1){ %> selected="selected" <%} %>>后</option><option value="-1" <%if(wendtype==-1){ %> selected="selected" <%} %>>前</option></select>
												<input type="text" size="5" maxlength="10" id="wenddays" name="wenddays" onkeypress="ItemCount_KeyPress()" onBlur="checkcount('wenddays')" value="<%=wenddays %>"/>
												<%}else{ %>
													<%if(wendtype==-1){ %>前<%}else{ %>后<%} %>
													<%=wenddays %>
												<%} %>
												天
											</td>
											<td>
												<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="iswremind" name="iswremind" <%if(iswremind==1){%> checked="checked" <%}%> value="<%=iswremind %>"/>
											</td>
										</tr>
										<tr id="ds_2" <%if(ismonth==0){%>style="display: none"<%} %>>
											<td>月报</td>
											<td>
												结束
												<%if(canedit){ %>
												<select id="mstarttype" name="mstarttype"><option value="1" <%if(mstarttype==1){ %> selected="selected" <%} %>>后</option><option value="-1" <%if(mstarttype==-1){ %> selected="selected" <%} %>>前</option></select>
												<input type="text" size="5" maxlength="10" id="mstartdays" name="mstartdays" onkeypress="ItemCount_KeyPress()" onBlur="checkcount('mstartdays')" value="<%=mstartdays %>"/>
												<%}else{ %>
													<%if(mstarttype==-1){ %>前<%}else{ %>后<%} %>
													<%=mstartdays %>
												<%} %>
												天
											</td>
											<td>
												结束
												<%if(canedit){ %>
												<select id="mendtype" name="mendtype"><option value="1" <%if(mendtype==1){ %> selected="selected" <%} %>>后</option><option value="-1" <%if(mendtype==-1){ %> selected="selected" <%} %>>前</option></select>
												<input type="text" size="5" maxlength="10" id="menddays" name="menddays" onkeypress="ItemCount_KeyPress()" onBlur="checkcount('menddays')" value="<%=menddays %>"/>
												<%}else{ %>
													<%if(mendtype==-1){ %>前<%}else{ %>后<%} %>
													<%=menddays %>
												<%} %>
												天
											</td>
											<td>
												<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="ismremind" name="ismremind" <%if(ismremind==1){%> checked="checked" <%}%> value="<%=ismremind %>"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%} %>
						<table class="maintable" cellspacing="5" border="0" style="margin-top: 20px;">
							<colgroup><col width="20%"/><col width="30%"/><col width="20%"/><col width="30%"/></colgroup>
							<tr>
								<td class="title">报告模版制定人</td>
								<td>
					          	 	<%if(canedit){ %>	
					          	 	<INPUT class="wuiBrowser" type="hidden" id="programcreate" name="programcreate" value="<%=programcreate %>"
										_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 		_displayText="<%=cmutil.getPerson(programcreate) %>" _param="resourceids" 
					          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
					          	 	<%}else{ %>
										<%=cmutil.getPerson(programcreate) %>
									<%} %>
								</td>
								<td class="title">报告审批人</td>
								<td>
									<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="50%" style="padding: 0px;">
											<%if(canedit){ %>	
											<input class="wuiBrowser" type="hidden" id="reportaudit" name="reportaudit" value="<%=reportaudit %>"
												_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
							          	 		_displayText="<%=cmutil.getPerson(reportaudit) %>" _param="resourceids" 
							          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
							          	 	<%}else{ %>
												<%=cmutil.getPerson(reportaudit) %>
											<%} %>
											</td>
											<td width="50%" style="padding: 0px;">
											<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="manageraudit" name="manageraudit" <%if(manageraudit==1){%> checked="checked" <%}%> value="<%=manageraudit %>"/>
									直接上级审批
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="title">报告结果查看人</td>
								<td colspan="3">
									<%if(canedit){ %>	
									<input class="wuiBrowser" type="hidden" id="reportview" name="reportview" value="<%=reportview %>"
										_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 		_displayText="<%=cmutil.getPerson(reportview) %>" _param="resourceids" 
					          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
					          	 	<%}else{ %>
										<%=cmutil.getPerson(reportview) %>
									<%} %>
								</td>
							</tr>
							<tr>
								<td class="title">个人定义方案</td>
								<td>
									<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="isself" name="isself" _index="1" <%if(isself==1){%> checked="checked" <%}%> value="<%=isself %>"/>
								</td>
								<td class="title">上级定义方案</td>
								<td>
									<input <%if(!canedit){ %> disabled="disabled"<%} %> type="checkbox" id="ismanager" name="ismanager" _index="1" <%if(ismanager==1){%> checked="checked" <%}%> value="<%=ismanager %>"/>
								</td>
							</tr>
							<tr>
								<td class="title">附件上传目录</td>
								<td colspan="3">
									<%if(canedit){ %>
					        	<div id="docseciddiv" class="browserdiv"></div>
					        <%}else{ %>
										<%=docpath %>
									<%} %>
								</td>
							</tr>
							<%if(canedit){ %>	
							<tr>
								<td class="title">应用到其他<%if("3".equals(type)){%>部门<%}else{%>分部<%} %></td>
								<td>
								<%if("3".equals(type)){ %>
								    <INPUT class="wuiBrowser" type="hidden" id="departmentids" name="departmentids" value=""
								    	_param="selectedids" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" />
								<%}else{%>
									<INPUT class="wuiBrowser" type="hidden" id="subcompanyids" name="subcompanyids" value=""
								    	_param="selectedids" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" />
								<%} %>
								</td>
							</tr>
							<%} %>
						</table>
					</td>
					<td></td>
				</tr>
			</table>
		</form>
		<script type="text/javascript" defer="defer">
			<%if(canedit){ %>	
			jQuery(document).ready(function(){
				jQuery("input[type=checkbox]").bind("click",function(){
					if(jQuery(this).attr("checked")){
						jQuery(this).val(1);
					}else{
						jQuery(this).val(0);
					}
				});
				
				jQuery("#docseciddiv").e8Browser({
				   name:"docsecid",
				   viewType:"0",
				   browserValue:"<%=docsecid%>",
				   isMustInput:"1",
				   browserSpanValue:"<%=docpath%>",
				   hasInput:false,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"",
				   //browserUrl:"/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp",
				   browserUrl:"/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp",
				   width:"",
				   hasAdd:false,
				   needHidden:true,
				   defaultRow: 1,
				   zDialog:true,
				   isAutoComplete:false,
				   _callback:"",
				   nameKey:"path"
				});
			});
			function submitData(obj) {
				if(checkVal()){
					jQuery("#operation").val("save");
					obj.disabled = true;
					jQuery("#baseForm").submit();
				}
			}
			function doSync(obj){
				if(checkVal()){
					jQuery("#operation").val("sync");
					obj.disabled = true;
					jQuery("#baseForm").submit();
				}
			}
			function delData(obj){
			   var sid = $("input[name='setid']").val();
			   if(sid=="" || sid==null){
			      alert("该部门报告暂无设置!");
			      return false;
			   }
			   if(confirm("确定删除该设置?")){
			      jQuery("#operation").val("del");
			   	  obj.disabled = true;
			      jQuery("#baseForm").submit();
			   }
			}
			function checkVal(){
				var scoremin = getFloatVal($("#scoremin").val());
				var scoremax = getFloatVal($("#scoremax").val());
				if(scoremin>scoremax){
					alert("评分最大值不能小于最小值!");
					return false;
				}
				var revisemin = getFloatVal($("#revisemin").val());
				var revisemax = getFloatVal($("#revisemax").val());
				if(revisemin>revisemax){
					alert("修正分最大值不能小于最小值!");
					return false;
				}
				return true;
			}
			function getFloatVal(val){
				if(isNaN(parseFloat(val))){
					return 0;
				}else{
					return parseFloat(val);
				}
			}
			function changeCon(obj){
				var _index = jQuery(obj).attr("_index");
				if(jQuery(obj).attr("checked")){
					jQuery("#ds_"+_index).show();
				}else{
					jQuery("#ds_"+_index).hide();
				}
			}
			function onShowCatalog() {
			    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
			    if (datas) {
			    	if (datas.id!= "") {
			    	  jQuery("#docpath").html(datas.path);
			          jQuery("#docsecid").val(datas.id);
			        }else{
			          jQuery("#docpath").html("");
			          jQuery("#docsecid").val("");
			        }
			    }
			}
			<%}%>
		</script>
	</BODY>
</HTML>