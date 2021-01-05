
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
boolean isOutDepartment = DepartmentVirtualComInfo.getVirtualtype(""+id).equals("-10000");
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)&&!isOutDepartment){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("611,30042",user.getLanguage())+",javascript:addHrmResource();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelNames("34078",user.getLanguage())+",javascript:setHrmManagers();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelNames("20230",user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResource:Log", user)&&!isOutDepartment){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("83",user.getLanguage())+",javascript:onLog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function setHrmManager(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null)id="";
	dialog.Width = 500;
	dialog.Height = 200;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceVirtualManagerSet&isdialog=1&id="+id+"&departmentid=<%=id%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(34078,user.getLanguage())%>";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function setHrmManagers(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34095,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	dialog.Width = 400;
	dialog.Height = 200;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceVirtualManagerSets&isdialog=1&ids="+id+"&departmentid=<%=id%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(34078,user.getLanguage())%>";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editHrmResource(id)
{
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id);
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=415 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=415")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function addHrmResource(){
	jQuery("#resourceBtn").click();
}

function saveHrmResource(e,datas,name){
	var resourceids = datas.id;
	if(resourceids.match(/,$/)){
		resourceids = resourceids.substring(0,resourceids.length-1);
	}

			//增加唯一校验
		jQuery.ajax({
				url:"/hrm/ajaxData.jsp",
				type:"POST",
				dataType:"json",
				async:true,
				data:{
					cmd:"checkResourceVirtual",
					virtualtype:jQuery("#virtualtype").val(),
					resourceids:resourceids
				},
				success:function(datas){
					var errInfo = "";
					for (var i = 0; i < datas.length; i++) {
						var dataitem = datas[i];
						if(errInfo.length>0)errInfo+="<br>";
						<%if(user.getLanguage()==8){%>
						errInfo += dataitem["lastname"]+"has in"+dataitem["virtualtypename"];
						<%}else if(user.getLanguage()==9){%>
						errInfo += dataitem["lastname"]+"<%=SystemEnv.getHtmlLabelName(83474,user.getLanguage())%>"+dataitem["virtualtypename"];
						<%}else{%>
						errInfo += dataitem["lastname"]+"<%=SystemEnv.getHtmlLabelName(83474,user.getLanguage())%>"+dataitem["virtualtypename"];
						<%}%>
					}
					if(i==0){
						//保存数据
						jQuery.ajax({
							url:"ResourceOperation.jsp?isdialog=1&operation=setDepartmentVirtual&resourceids="+resourceids+"&departmentid=<%=id%>",
							type:"post",
							async:true,
							complete:function(xhr,status){
								frmMain.submit();
							}
						});
					}else{
						//数据异常提示
						window.top.Dialog.alert(errInfo);
						//window.top.Dialog.confirm(errInfo,function(){
							//jQuery.ajax({
							//	url:"ResourceOperation.jsp?isdialog=1&operation=setDepartmentVirtual&resourceids="+resourceids+"&departmentid=<%=id%>",
							//	type:"post",
							//	async:true,
							//	complete:function(xhr,status){
							//		frmMain.submit();
							//	}
							//});
						//});
					}
				}
		});
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"ResourceOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}
</script>
</head>
<body>
<FORM name="frmMain" id=frmMain method=post action="HrmResourceList.jsp">
<input name="id" id="id" type="hidden" value="<%=id %>">
<input name="virtualtype" id="virtualtype" type="hidden" value="<%=DepartmentVirtualComInfo.getVirtualtype(""+id) %>">
<div style="display: none">
<brow:browser viewType="0" name="resourceids" browserValue="" 
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' browserBtnID="resourceBtn"
	completeUrl="/data.jsp" width="200px"
	_callback="saveHrmResource" browserSpanValue="">
	</brow:browser>  
	</div>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)&&!isOutDepartment){ %>
			<input type=button class="e8_btn_top" onclick="addHrmResource();"  value="<%=SystemEnv.getHtmlLabelNames("611,30042",user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="setHrmManagers()"  value="<%=SystemEnv.getHtmlLabelNames("34078",user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();"  value="<%=SystemEnv.getHtmlLabelName(20230,user.getLanguage())%>"></input>
		<%} %>	
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 <%
AppDetachComInfo adci = new AppDetachComInfo();
String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"");
//姓名	编号	性别	直接上级	岗位	登录名	   安全级别	   显示顺序	
String backfields = " a.id, a.resourceid, hrmresource.lastname, hrmresource.workcode, hrmresource.sex, a.managerid, hrmresource.jobtitle, hrmresource.loginid, hrmresource.seclevel, hrmresource.dsporder "; 
String fromSql  = " from HrmResourceVirtual a, hrmresource ";
String sqlWhere = " where hrmresource.status in (0,1,2,3) and a.resourceid = hrmresource.id " 
								+ " and a.departmentid ="+id;
								
sqlWhere += (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
String orderby = " hrmresource.dsporder " ;
String tableString = "";

//编辑   日志
//操作字符串
String  operateString= "";
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)&&!isOutDepartment){
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmResourceVirtualOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmResource:Log", user)+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:setHrmManager();\" text=\""+SystemEnv.getHtmlLabelName(34078,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(20230,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:onLog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
 	    
}
String tabletype="checkbox";
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	tabletype = "checkbox";
}
 	  		 
tableString =" <table pageId=\""+PageIdConst.HRM_ResourceListVirtual+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceListVirtual,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmEditHrmResourceName\" otherpara=\"column:resourceid\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"workcode\" orderkey=\"workcode\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getSexName\" orderkey=\"sex\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(596,user.getLanguage())+"\" column=\"managerid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" orderkey=\"managerid\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" orderkey=\"jobtitle\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(412,user.getLanguage())+"\" column=\"loginid\" orderkey=\"loginid\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceListVirtual %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
 </form> 
</body>
</html>
