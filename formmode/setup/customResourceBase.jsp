
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />


<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
	</HEAD>
<%

	if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(30063,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String id = Util.null2String(request.getParameter("id"),"0");
	String appid = Util.null2String(request.getParameter("appid"),"1");
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	
	String resourceName = "";
	String customSearchId = "";
	String customSearchName = "";
	String titleFieldId = "";
	String startDateFieldId = "";
	String endDateFieldId = "";
	String startTimeFieldId = "";
	String endTimeFieldId = "";
	String contentFieldId = "";
	String resourceFieldId = "";
	String resourceShowFieldid = "";
	String description = "";
	String dsporder = "";
	
	String createUrl = "";
	
	String sql = "select * from mode_customResource where id="+id;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    resourceName = Util.toScreen(RecordSet.getString("resourceName"),user.getLanguage()) ;
		customSearchId = Util.null2String(RecordSet.getString("customSearchId"));
		if(!customSearchId.equals("")){
			rs.executeSql("select customname from mode_customsearch where id="+customSearchId);
			if(rs.next()){
				customSearchName = rs.getString(1);
			}
		}
		titleFieldId = Util.null2String(RecordSet.getString("titleFieldId"));
		startDateFieldId = Util.null2String(RecordSet.getString("startDateFieldId"));
		endDateFieldId = Util.null2String(RecordSet.getString("endDateFieldId"));
		startTimeFieldId = Util.null2String(RecordSet.getString("startTimeFieldId"));
		endTimeFieldId = Util.null2String(RecordSet.getString("endTimeFieldId"));
		contentFieldId = Util.null2String(RecordSet.getString("contentFieldId"));
		resourceFieldId = Util.null2String(RecordSet.getString("resourceFieldId"));
		resourceShowFieldid = Util.null2String(RecordSet.getString("resourceShowFieldid"));
		description = Util.null2String(RecordSet.getString("description"));
		dsporder = Util.null2String(RecordSet.getString("dsporder"));
		createUrl = Util.null2String(RecordSet.getString("createUrl"));
	}
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customResource a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	AppInfoService appInfoService = new AppInfoService();
	Map<String, Object> appInfo = appInfoService.getAppInfoById(Util.getIntValue(appid));
	String treelevel = Util.null2String(appInfo.get("treelevel"));
	if(subCompanyId==-1){		
		subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subcompanyid")),-1);
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	
%>
<%if(isrefresh.equals("1")){%>
<script type="text/javascript">
jQuery(function($){
	parent.parent.refreshCustomResource("<%=id%>");
});
</script>
<%}%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
		if(id.equals("0")){
			if(operatelevel>0&&!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
				RCMenuHeight += RCMenuHeightStep;
			}
		}else{
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0"))||fmdetachable.equals("1")&&!treelevel.equals("0")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>1){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(124939,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建资源面板
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createMenuNew(),_self} " ;//创建菜单
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+",javascript:viewmenu(),_self} " ;//查看菜单地址
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;//预览
			RCMenuHeight += RCMenuHeightStep;
		}
		%>

		<FORM id=weaver name=frmMain action="/formmode/setup/customResourceSettingsAction.jsp" method=post>
			<input type="hidden" name="appid" id="appid" value="<%=appid %>">
			<input type="hidden" name="operation" name="operation" value="saveorupdate">
			<input type="hidden" name="id" id="id" value="<%=id%>">

									<TABLE class="e8_tblForm">
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
									  	<TBODY>
                                            <TR>
									      		<TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
									          	<TD class="e8_tblForm_field">
									        		<INPUT type=text class=Inputstyle style="width:80%" name="resourceName" onchange='checkinput("resourceName","resourceNameimage")' value="<%=resourceName%>">
									          		<SPAN id=resourceNameimage>
									          		<%if ("".equals(resourceName)) { %>
													<img src="/images/BacoError_wev8.gif"/>
													<% } %></SPAN>
									          	</TD>
									        </TR>
									        <TR>
									      		<TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82063,user.getLanguage())%></TD><!-- 查询列表 -->
									          	<TD class="e8_tblForm_field">
									          	    <%
									          	    	String tempTitle = SystemEnv.getHtmlLabelNames("18214,30947",user.getLanguage());
									          	    %>
									        		<brow:browser viewType="0" id="customSearchId" name="customSearchId" browserValue='<%=customSearchId %>' 
								  		 				browserUrl="'+getCustomSearchUrl()+'"
														hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
														completeUrl="/data.jsp" linkUrl=""  width="228px"
														browserDialogWidth="510px"  tempTitle="<%=tempTitle %>"
														browserSpanValue='<%=customSearchName %>' 
														_callback="changeSearch" 
														></brow:browser>
													&nbsp;&nbsp;&nbsp;&nbsp;
													<input class="inputstyle" type="text" id="createUrl" name="createUrl" style="width: 300px;" value="<%=createUrl %>" title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>" >
									          	</TD>
									        </TR>
									        <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%><!-- 标题字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="titleFieldId" name="titleFieldId" style="width:200px;">
                                                  	
                                                  </select>
                                              </TD>
                                            </TR> 
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(124940,user.getLanguage())%><!-- 开始日期字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="startDateFieldId" name="startDateFieldId" style="width:200px;">
                                                  	
                                                  </select>
                                              </TD>
                                            </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(124941,user.getLanguage())%><!-- 结束日期字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="endDateFieldId" name="endDateFieldId" style="width:200px;">
                                                  	
                                                  </select>
                                              </TD>
                                            </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(124942,user.getLanguage())%><!-- 开始时间字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="startTimeFieldId" name="startTimeFieldId" style="width:200px;"
                                                  	
                                                  </select>
                                              </TD>
                                            </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(124943,user.getLanguage())%><!-- 结束时间字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="endTimeFieldId" name="endTimeFieldId" style="width:200px;">
                                                  	
                                                  </select>
                                              </TD>
                                            </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(124944,user.getLanguage())%><!-- 内容字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="contentFieldId" name="contentFieldId" style="width:200px;">
                                                  	
                                                  </select>
                                              </TD>
                                            </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(124945,user.getLanguage())%><!-- 资源字段 --></TD>
                                              <TD class="e8_tblForm_field">
                                                  <select id="resourceFieldId" name="resourceFieldId" style="width:200px;" onchange="changeResource()">
                                                  	
                                                  </select>&nbsp;&nbsp;&nbsp;&nbsp;
                                                  <%=SystemEnv.getHtmlLabelName(124946,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
                                                  <select id="resourceShowFieldId" name="resourceShowFieldId" style="width:200px;">
                                                  	
                                                  </select>
                                              </TD>
                                            </TR>
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(124986,user.getLanguage())%><!-- 描述资源面板页面的用途 --></div></TD>
                                              <TD class="e8_tblForm_field">
                                                  <textarea  style="width:80%;height:50px;" name="description" class=Inputstyle><%=description%></textarea>
                                              </TD>
                                            </TR> 
                                            <TR>
                                              <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序--></TD>
                                              <TD class="e8_tblForm_field">
                                                  <input class="inputstyle" type="text" name="dsporder" id="dsporder" value="<%=dsporder%>" size="5" onkeypress="ItemDecimal_KeyPress('dsporder',15,2)" onblur="checknumber1(this);">
                                              </TD>
                                            </TR> 
									 	</TBODY>
									</TABLE>
			</FORM>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<BR>

<script language="javascript">
$(document).ready(function(){
<%if(!customSearchId.equals("")){ %>
	changeSelectOptions("<%=customSearchId %>",0);
<%} %>
});

function getCustomSearchUrl(){
	var appid = "<%=appid %>";
	return "/systeminfo/BrowserMain.jsp?othercallback=getHrefTarget&url=/formmode/search/CustomSearchBrowserInResource.jsp?appid="+appid;
}

function changeSearch(event,datas,name,_callbackParams){
	if (datas && datas.id!=""){
  	    changeSelectOptions(datas.id,1);
  	}else{
  		
  	}
}

function changeSelectOptions(customSearchId,opt){
	if(customSearchId!=""){
  	    var url = "/formmode/setup/customResourceSettingsAction.jsp?operation=getFieldsBySearchId&customSearchId="+customSearchId;
  	    $.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI(url),
		 	data: {},
		 	success: function(responseText, textStatus) 
		 	{
		 		var datas = $.parseJSON(responseText);
		 		//var data = datas.result;
		 		var data;
		 		if(datas && datas.result) {
		 			data = datas.result;
		 		
		 		var modeid=datas.modeid;
		 		var formid=datas.formid;
		 		
		 		if(opt==1){
		 			$("#createUrl").val("/formmode/view/AddFormMode.jsp?modeId="+modeid+"&formId="+formid+"&type=1");
		 		}
		 		
		 		var titleOption = "";
		 		var startDateOption = "";
		 		var endDateOption = "";
		 		var startTimeOption = "";
		 		var endTimeOption = "";
		 		var contentOption = "";
		 		var resourceOption = "";
				for(var i=0; i<data.length; i++){
					var fieldid = data[i].fieldid;
					var fieldname = data[i].fieldname;
					var fielddbtype = data[i].fielddbtype;
					var fieldhtmltype = data[i].fieldhtmltype;
					var type = data[i].type;
					var indexdesc = data[i].indexdesc;
					
					if(fieldhtmltype=="1"){//单行文本
						if(fieldid=="<%=titleFieldId %>"){
							titleOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							titleOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
					}else if(fieldhtmltype=="2"){//多行文本
						if(fieldid=="<%=contentFieldId %>"){
							contentOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							contentOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
					}else if(fieldhtmltype=="3" && type=="2"){//日期
						if(fieldid=="<%=startDateFieldId %>"){
							startDateOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							startDateOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
						
						if(fieldid=="<%=endDateFieldId %>"){
							endDateOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							endDateOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
					}else if(fieldhtmltype=="3" && type=="19"){//时间
						if(fieldid=="<%=startTimeFieldId %>"){
							startTimeOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							startTimeOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
						
						if(fieldid=="<%=endTimeFieldId %>"){
							endTimeOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							endTimeOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
					}else if(fieldhtmltype=="3" && type=="161"){
						if(fieldid=="<%=resourceFieldId %>"){
							resourceOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							resourceOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
					}
				}
				setSelectNewOptions("title", titleOption);
				setSelectNewOptions("startDate", startDateOption);
				setSelectNewOptions("endDate", endDateOption);
				setSelectNewOptions("startTime", startTimeOption);
				setSelectNewOptions("endTime", endTimeOption);
				setSelectNewOptions("content", contentOption);
				setSelectNewOptions("resource", resourceOption);
				changeResource();
				}
		 	}
		});
  	}else{
  		
  	}
}

//给字段下拉框斌值：先清空，再斌值
function setSelectNewOptions(mainfield, options){
	$("#"+mainfield+"FieldId").empty();
	$("#"+mainfield+"FieldId").selectbox("detach");
    beautySelect($("#"+mainfield+"FieldId"));
	$("#"+mainfield+"FieldId").append(options);
	$("#"+mainfield+"FieldId").selectbox("detach");
    beautySelect($("#"+mainfield+"FieldId"));
}

function changeResource(){
	var resourceId = $("#resourceFieldId").val();
	if(resourceId!=""){
		var url = "/formmode/setup/customResourceSettingsAction.jsp?operation=getFieldsByResourceId&resourceId="+resourceId;
  	    $.ajax({
		 	type: "POST",
		 	contentType: "application/json",
		 	url: encodeURI(url),
		 	data: {},
		 	success: function(responseText, textStatus) 
		 	{
		 		var datas = $.parseJSON(responseText);
		 		//var data = datas.result;
		 		var data;
		 		if(datas && datas.result) {
		 			data = datas.result;
		 		var resourceShowOption = "<option></option>";
		 		for(var i=0; i<data.length; i++){
					var fieldid = data[i].fieldid;
					var fieldname = data[i].fieldname;
					var fielddbtype = data[i].fielddbtype;
					var fieldhtmltype = data[i].fieldhtmltype;
					var type = data[i].type;
					var indexdesc = data[i].indexdesc;
					
			 		if(fieldhtmltype=="1"){//单行文本
			 			if(fieldid=="<%=resourceShowFieldid %>"){
							resourceShowOption += "<option value="+fieldid+" selected>"+indexdesc+"("+fieldname+")"+"</option>";
						}else{
							resourceShowOption += "<option value="+fieldid+">"+indexdesc+"("+fieldname+")"+"</option>";
						}
					}
				}
				
				setSelectNewOptions("resourceShow", resourceShowOption);
				}
		 	}
		});
	}
}

function onDelete(){
	if(isdel()) {
        enableAllmenu();
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
function createmenu(){
	var url = "/formmode/view/ModeViewByResource.jsp?id=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/view/ModeViewByResource.jsp?id=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}
function submitData()
{
	var checkfields = "resourceName,customSearchId";
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
        frmMain.submit();
    }
}

function doAdd(){
	parent.location.href = "/formmode/setup/customResourceInfo.jsp?id=&appid=<%=appid%>";
}

function changeCbox(objspan){
	var objbox = $(objspan).find(".jNiceHidden");
	changeCheckboxStatus(objbox.get(0), !objbox.get(0).checked);
}

function onPreview(){
	var url = "/formmode/view/ModeViewByResource.jsp?id=<%=id%>";
	window.open(url);
}
function createMenuNew(){
	var url = "/formmode/view/ModeViewByResource.jsp?id=<%=id%>";
	var parmes = escape(url);
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;	
	diag_vote.Width = 350;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(23033,user.getLanguage())%>";
	diag_vote.URL = "/formmode/setup/modelMenuAdd.jsp?dialog=1&isFromMode=1&parmes="+parmes;
	diag_vote.isIframe=false;
	diag_vote.show();
}
</script>
</BODY></HTML>
