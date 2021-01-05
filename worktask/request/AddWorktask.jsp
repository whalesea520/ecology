
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.workflow.workflow.GetShowCondition"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
session.setAttribute("relaterequest", "new");
String currentDay = TimeUtil.getCurrentDateString();
int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
String worktaskName = "";
String hasCanCreateTasks = "false";

WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks(false);
hasCanCreateTasks = (String)canCreateTasks_hs.get("hasCanCreateTasks");
if(!"true".equals(hasCanCreateTasks)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getCreateFieldInfo();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");

//提醒设置
int remindtype = 0;
int beforestart = 0;
int beforestarttime = 0;
int beforestarttype = 0;
int beforestartper = 0;
int beforeend = 0;
int beforeendtime = 0;
int beforeendtype = 0;
int beforeendper = 0;
int annexmaincategory = 0;
int annexsubcategory = 0;
int annexseccategory = 0;
rs.execute("select * from worktask_base where id="+wtid);
if(rs.next()){
	remindtype = Util.getIntValue(rs.getString("remindtype"), 0);
	beforestart = Util.getIntValue(rs.getString("beforestart"), 0);
	beforestarttime = Util.getIntValue(rs.getString("beforestarttime"), 0);
	beforestarttype = Util.getIntValue(rs.getString("beforestarttype"), 0);
	beforestartper = Util.getIntValue(rs.getString("beforestartper"), 0);
	beforeend = Util.getIntValue(rs.getString("beforeend"), 0);
	beforeendtime = Util.getIntValue(rs.getString("beforeendtime"), 0);
	beforeendtype = Util.getIntValue(rs.getString("beforeendtype"), 0);
	beforeendper = Util.getIntValue(rs.getString("beforeendper"), 0);
	annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
	annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
	annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
}
int maxUploadImageSize = 5;
maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexseccategory), 5);
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}
String startTimeType = "";
String endTimeType = "";
if(beforestarttype == 0){
	startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
}else if(beforestarttype == 1){
	startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
}else{
	startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
}
if(beforeendtype == 0){
	endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
}else if(beforeendtype == 1){
	endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
}else{
	endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
}

String checkStr = "";
%>
<HTML><HEAD>
<title><%=Util.toScreen(worktaskName, user.getLanguage())%></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/xmlextras_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HEAD>
<%@ include file="/cowork/uploader.jsp" %>

<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage())+": "+worktaskName;
String imagefilename = "/images/hdMaintenance_wev8.gif";

String planStartDate = "";
String planEndDate = "";
String planDays = "";
String needcheckField = "";
String checkorField = "";

//根据浏览框id值获取具体的名称
GetShowCondition broconditions=new GetShowCondition();
 //多选按钮id
String browsermoreids=",17,18,37,257,57,65,194,240,135,152,162,166,168,170,";
%>
<BODY id="taskbody">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javaScript:OnSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(615, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16539,user.getLanguage()) %>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="taskform" method="post" action="AddWorktask.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
<input type="hidden" name="operationType">
<input type="hidden" id="isCreate" name="isCreate" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="AddWorktask.jsp" >
<input type="hidden" id="isRefash" name="isRefash" value="<%=isRefash%>" >
<input type="hidden" id="istemplate" name="istemplate" value="0" >

<div align="center" style="font-size:14pt;FONT-WEIGHT: bold;height:40px;line-height: 40px;">
				<%=worktaskName%>
</div>

<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%;text-align: center;' valign='top'>
</div>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'  attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(18177,user.getLanguage())%></wea:item>
		<wea:item>
				<%=tasksSelectStr%>
		</wea:item>
		
		
		<%
			
			for(int i=0; i<idList.size(); i++){
				int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
				int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
				String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
				String crmname_tmp = Util.null2String((String)crmnameList.get(i));
				String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
				String type_tmp = Util.null2String((String)typeList.get(i));
				int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
				int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
				String defaultvalue_tmp = Util.null2String((String)defaultvalueList.get(i));
				String defaultvaluecn_tmp = Util.null2String((String)defaultvaluecnList.get(i));
				String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
				String sHtml = "";
				if(ismand_tmp == 1 && !"4".equals(fieldhtmltype_tmp)){
					checkStr += (",field" + fieldid_tmp + "_0");
				}
				if("planstartdate".equalsIgnoreCase(fieldname_tmp)){
					planStartDate = "field" + fieldid_tmp + "_0";
				}else if("planenddate".equalsIgnoreCase(fieldname_tmp)){
					planEndDate = "field" + fieldid_tmp + "_0";
				}else if("plandays".equalsIgnoreCase(fieldname_tmp)){
					planDays = "field" + fieldid_tmp + "_0";
					if("".equals(defaultvalue_tmp.trim())){
						defaultvalue_tmp = "0";
						defaultvaluecn_tmp = "0";
					}
				}else if("needcheck".equalsIgnoreCase(fieldname_tmp)){
					needcheckField = "field"+fieldid_tmp+"_";
				}else if("checkor".equalsIgnoreCase(fieldname_tmp)){
					checkorField = "field"+fieldid_tmp+"_";
				}
				
				int fieldtype = Util.getIntValue(type_tmp);
				
				//判断 浏览框 是否 多选
                String isSingle = browsermoreids.indexOf(","+fieldtype+",")>-1?"false":"true";
				
				if(!"3".equals(fieldhtmltype_tmp) || ("3".equals(fieldhtmltype_tmp) && (fieldtype==2 || fieldtype==19))){//非浏览框,除日期浏览框
				   sHtml = wtRequestManager.getCellHtml(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, defaultvalue_tmp, defaultvaluecn_tmp);
				}
				//out.println("<tr><td>"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
				//out.println("<tr style='height:1px;'><td class=Line2 colSpan=2></td></tr>");
			%>
			       <% if(!"3".equals(fieldhtmltype_tmp)  || ("3".equals(fieldhtmltype_tmp) && (fieldtype==2 || fieldtype==19))){//非浏览框 %>
			           <wea:item><%=crmname_tmp %></wea:item><wea:item><%=sHtml %></wea:item>
			       <%}else{//浏览框 %>
			           <wea:item><%=crmname_tmp %></wea:item>
				       <wea:item>
				               <%
				                String url=BrowserComInfo.getBrowserurl(""+fieldtype);     // 浏览按钮弹出页面的url
								String linkurl=BrowserComInfo.getLinkurl(""+fieldtype);    // 浏览值点击的时候链接的url
								//System.out.println("url="+url);
							   %>
								<%if(fieldtype==2 || fieldtype==19){// 这部分已无用%>
									<input type="hidden" name="field<%=fieldid_tmp%>_0" value="<%=defaultvalue_tmp%>" >
									<button class=Calendar type="button"   
									<%if(fieldtype==2){%>
									 onclick="onSearchWFDate(defaultvaluespan_<%=fieldid_tmp%>, field<%=fieldid_tmp%>_0)"
									<%}else{%>
									 onclick ="onSearchWFTime(defaultvaluespan_<%=fieldid_tmp%>, field<%=fieldid_tmp%>_0)"
									<%}%>
									 ></button>
									 <span name="defaultvaluespan_<%=fieldid_tmp%>" id="defaultvaluespan_<%=fieldid_tmp%>"><%=defaultvalue_tmp%></span>
								<%}else if("liableperson".equalsIgnoreCase(fieldname_tmp) ){//责任人%>
									 <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_0"%>'
										browserUrl='<%=url+"?selectedids=&resourceids="%>'
										hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
										completeUrl='<%="/data.jsp?type="+fieldtype %>'   browserValue='<%=user.getUID()+""%>' browserSpanValue='<%=user.getUsername() %>' width="260px">
							         </brow:browser> 	
								<%}else if(fieldtype==161 || fieldtype==162){%>
			                        <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_0"%>'
										browserUrl='<%=url+"?type="+fieldlen_tmp%>'
										hasInput="false" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
										completeUrl='<%="/data.jsp?type="+fieldtype %>'   browserValue='<%=defaultvalue_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", defaultvalue_tmp, "1",fieldlen_tmp) %>' width="260px">
							       </brow:browser> 	
		                        <%}else{%>
									 <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_0"%>'
									browserUrl='<%=url+"?selectedids=&resourceids="%>'
									hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1' _callback="afterBackBrowserData"
									completeUrl='<%="/data.jsp?type="+fieldtype %>' browserValue='<%=defaultvalue_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", defaultvalue_tmp, "1") %>'   width="260px">
						      			 </brow:browser> 	
								<%}%>
				        </wea:item>
			       <%} %>
			<%} %>

		 <wea:item><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></wea:item>
		 <wea:item>
					<INPUT type="radio" value="0" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 0) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="1" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
		 </wea:item>
           <wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(18177,user.getLanguage())%></wea:item>
	       <wea:item attributes="{'samePair':\"sectr\"}">
				<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %>>
				<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
				<INPUT class="InputStyle" type="text" name="beforestarttime"  id="beforestarttime" style="width:40px" size=5  value="<%= beforestarttime%>" onChange="inputChangeCheckBox('beforestarttime','beforestart')"/>
				<select name="beforestarttype" id="beforestarttype" onChange="onChangeStartTimeType(event)" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
					<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
					<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
					<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="text" name="beforestartper" id="beforestartper" style="width:40px" size=5  onChange="inputint('beforestartper')"  value="<%=beforestartper%>">
					<span id="beforestarttypespan" name="beforestarttypespan" ><%=startTimeType%></span>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
					<INPUT type="checkbox" name="beforeend" id="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %>>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="text" style="width:40px" name="beforeendtime" id="beforeendtime" size=5 value="<%= beforeendtime%>"  onChange="inputChangeCheckBox('beforeendtime','beforeend')">
						<select name="beforeendtype" id="beforeendtype" onChange="onChangeEndTimeType()" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
			</wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"sectr\"}">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="text" name="beforeendper"  id="beforeendper" style="width:40px" size=5 onChange="inputint('beforeendper')" value="<%=beforeendper%>">
					<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
			</wea:item>
		
	</wea:group>
	
</wea:layout>

	
</form>
<script language="javascript">

function afterBackBrowserData(event,datas,name){
   name = name.replace("field","");
   onChangeCheckor(name);
}

function onChangeCheckor(id){
	try{
		var ids = id.split("_");
		var fieldid = ids[0];
		var rowindex = ids[1];
		var fieldname1 = "field"+id;
		var fieldname2 = "<%=checkorField%>"+rowindex;
		var name = "<%=needcheckField%>"+rowindex;
		if(fieldname1 == fieldname2){
			if(document.getElementById("<%=checkorField%>"+rowindex).value==null || document.getElementById("<%=checkorField%>"+rowindex).value==""){
			     //alert(1);
				//document.getElementById("<%=needcheckField%>"+rowindex).checked = false;
				 changeCheckboxStatus4tzCheckBox(name,false);
			}else{
				//document.getElementById("<%=needcheckField%>"+rowindex).checked = true;
				 changeCheckboxStatus4tzCheckBox(name,true);
			}
		}
	}catch(e){}
}

function changeCheckboxStatus4tzCheckBox(name, checked) {
   
	jQuery("input[name='"+name+"']").attr("checked", checked);
	if(checked){
		jQuery("input[name='"+name+"']").next("span.jNiceCheckbox").addClass("jNiceChecked");
	}else{
		jQuery("input[name='"+name+"']").next("span.jNiceCheckbox").removeClass("jNiceChecked");
	}
}

function inputChangeCheckBox(inputid,checkboxid){
  //alert(jQuery("#"+checkboxid));
  var obj = jQuery("#"+inputid);
  if(obj.val() !='' && !isNaN(obj.val()) && obj.val()>0){
     changeCheckboxStatus(jQuery("#"+checkboxid),true);
  }else{
     obj.val("0");
  }
}

function inputint(inputid){
 var obj = jQuery("#"+inputid);
  if(isNaN(obj.val()) || obj.val()==""){
     obj.val("0");
  }
}


function doChangeWorktask(obj){
	var selectedIndex = 0;
	var i = 0;
	var length = document.all("selectWorktask").options.length;
	for(i=0; i<length; i++){
		if("<%=wtid%>" == document.all("selectWorktask").options[i].value){
			selectedIndex = i;
		}
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(18691, user.getLanguage())%>")){
		var wtid = obj.value;
		location.href="/worktask/request/AddWorktask.jsp?wtid="+wtid;
	}else{
		for(i=0; i<length; i++){
			document.all("selectWorktask").options[i].selected = false;
		}
		document.all("selectWorktask").options[selectedIndex].selected = true;
	}
}

jQuery(document).ready(function(){
	jQuery(".uploadfield").each(function(){
		var fieldid=jQuery(this).attr("field");
		bindUploaderDiv(jQuery(this),"field"+fieldid+"_1"); 
	});
	jQuery(".progressCancel").live("click",function(){
		var uploaddiv=jQuery(this).parents(".uploadfield");
		var totalnumFiles=window[uploaddiv.attr("oUploaderIndex")].getStats().files_queued;
		afterChooseFile(uploaddiv,totalnumFiles);
	});
	jQuery(".btnCancel_upload").live("click",function(){
		var uploaddiv=jQuery(this).parents(".uploadfield");
		var totalnumFiles=window[uploaddiv.attr("oUploaderIndex")].getStats().files_queued;
		afterChooseFile(uploaddiv,totalnumFiles);
	});
	
	<% if(remindtype == 0){%>
	   hideEle("sectr", true);
	<%}%>
});  

function OnSave(){
	checkPlanDays();
	document.all("needcheck").value += "<%=checkStr%>";
	if(check_form(document.taskform, document.all("needcheck").value) && checkWorkPlanRemind()){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="save";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22060,user.getLanguage())%>");
		doUpload();
		enableAllmenu;
	}else{
		document.all("needcheck").value = "wtid";
	}
}

function OnSubmit(){
	document.all("needcheck").value += "<%=checkStr%>";
	if(check_form(document.taskform, document.all("needcheck").value) && checkWorkPlanRemind()){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="Submit";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22061, user.getLanguage())%>");
		doUpload();
		enableAllmenu;
	}else{
		document.all("needcheck").value = "wtid";
	}
}

function doUpload(){

	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断是否需要上传
	     	 oUploader.startUpload(); 
	    }
	});
	doSaveAfterAccUpload();
}

function afterChooseFile(uploaddiv,totalnumFiles){

	var ismand=jQuery(uploaddiv).attr("ismand");
	var field=jQuery(uploaddiv).attr("field");
	
	if(ismand=="1"){
	   if(totalnumFiles>0)
	      jQuery("#field"+field+"span").html("");
	   else
	      jQuery("#field"+field+"span").html("<IMG align=absMiddle src='/images/BacoError_wev8.gif'>");   
	}
	
}
function doSaveAfterAccUpload(){
	var isuploaded=true;
	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断上传是否完成
	     	 isuploaded=false; 
	    }
	});
	if(isuploaded){
		document.taskform.submit();
	}
}
function checkPlanDays(){
	try{
		var planDays = document.getElementById("<%=planDays%>").value;
		try{
			var days = parseInt(planDays);
			if(days < 0){
				alert(document.getElementById("<%=planDays%>").getAttribute("temptitle")+"<%=SystemEnv.getHtmlLabelName(22065, user.getLanguage())%>");
				return false;
			}
		}catch(e){
			return false;
		}
		return true;
	}catch(e){
		return true;
	}
}

function showPrompt(content){
     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     //message_table_Div.style.posTop=pTop;
     //message_table_Div.style.posLeft=pLeft;
     message_table_Div.style.top = pTop;
     message_table_Div.style.left = pLeft;
     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
</script>
<script language="vbs">
sub onShowBrowser31(id,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,2,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,2,len(names))
					descs = Mid(descs,2,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
	onChangeCheckor(id)
end sub
</script>
<script language="javascript">

function onShowPlanDateCompute(inputname, spanname, ismand){
	WdatePicker_onShowPlanDateCompute(inputname, spanname, ismand);
}
function WdatePicker_onShowPlanDateCompute(inputname, spanname, ismand){
	var returnvalue;
	var oncleaingFun = function(){
		  $dp.$(inputname).value = "";
			if(ismand == 1){
				$dp.$(spanname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}else{
				$dp.$(spanname).innerHTML = "";
			}
			try{
				document.getElementById("<%=planDays%>").value = 0;
				try{
					if(document.getElementById("<%=planDays%>").type == "hidden"){
						document.getElementById("<%=planDays%>span").innerHTML = 0;
					}
				}catch(e){}
			}catch(e){}
	  }
	 WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;
		try{
			var planStartDate = document.getElementById("<%=planStartDate%>").value;
			var planEndDate = document.getElementById("<%=planEndDate%>").value;
			<%if(canCreateHistoryWorktask == 0){%>
			try{
				if(planStartDate!=null && planStartDate!=""){
					if(planStartDate < "<%=currentDay%>"){
						alert(document.getElementById("<%=planStartDate%>").temptitle + "<%=SystemEnv.getHtmlLabelName(22269, user.getLanguage())+SystemEnv.getHtmlLabelName(15625, user.getLanguage())+SystemEnv.getHtmlLabelName(22270, user.getLanguage())%>");
						$dp.$(objinput).value = oldValue;
						$dp.$(objspan).innerHTML = oldinnerHTML;
						return false;
					}
				}
			}catch(e){
			}
		<%}%>
		try{
			if(planStartDate!=null && planStartDate!="" && planEndDate!=null && planEndDate!=""){
				if(planStartDate > planEndDate){
					alert(document.getElementById("<%=planEndDate%>").temptitle + "<%=SystemEnv.getHtmlLabelName(22269, user.getLanguage())%>" + document.getElementById("<%=planStartDate%>").temptitle + "<%=SystemEnv.getHtmlLabelName(22270, user.getLanguage())%>");
					$dp.$(objinput).value = oldValue;
					$dp.$(objspan).innerHTML = oldinnerHTML;
					return false;
				}
			}
		}catch(e){
		}
			if(planStartDate != null && planStartDate != "" && planEndDate != null && planEndDate != ""){
				var days = getnumber(planStartDate, planEndDate);
				//document.getElementById("<%=planDays%>").value = days;
				$GetEle("<%=planDays%>").value = days;
				try{
					if($GetEle("<%=planDays%>").type == "hidden"){
						//document.getElementById("<%=planDays%>span").innerHTML = days;
						$GetEle("<%=planDays%>span").innerHTML=days;
					}
				}catch(e){}
			}else{
				//document.getElementById("<%=planDays%>").value = 0;
				$GetEle("<%=planDays%>").value = 0;
				try{
					if($GetEle("<%=planDays%>").type == "hidden"){
						//document.getElementById("<%=planDays%>span").innerHTML = 0;
						$GetEle("<%=planDays%>span").innerHTML=0;
					}
				}catch(e){}
			}
		}catch(e){
			try{
				//document.getElementById("<%=planDays%>").value = 0;
				$GetEle("<%=planDays%>").value = 0;
				try{
					if($GetEle("<%=planDays%>").type== "hidden"){
						//document.getElementById("<%=planDays%>span").innerHTML = 0;
						$GetEle("<%=planDays%>span").innerHTML=0;
					}
				}catch(e){}
			}catch(e){}
		}
	},oncleared:oncleaingFun});

	//onShowFlowDate(spanname, inputname, ismand);
}

function ItemCount_KeyPress_self(event){
    event = event || window.event
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}

function showRemindTime(obj){
	if("0" == obj.value){
		hideEle("sectr", true);
	}else{
		showEle("sectr");
	}
}

function checkWorkPlanRemind(){
	//alert(document.frmmain.remindtype);
	if(document.taskform.remindtype[0].checked == false){
		if(document.taskform.beforestart.checked || document.taskform.beforeend.checked){
			return true;
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21978, user.getLanguage())%>");
			return false;
		}
	}else{
		document.taskform.beforestart.checked = false;
		document.taskform.beforeend.checked = false;
		document.taskform.beforestarttime.value = 0;
		document.taskform.beforeendtime.value = 0;
		document.taskform.beforestartper.value = 0;
		document.taskform.beforeendper.value = 0;
		return true;
	}
}
function onChangeStartTimeType(){
	var timeTypeText = document.all("beforestarttype").options.item(document.all("beforestarttype").selectedIndex).innerText;
	document.getElementById("beforestarttypespan").innerHTML = timeTypeText;
}

function onChangeEndTimeType(){
	var timeTypeText = document.all("beforeendtype").options.item(document.all("beforeendtype").selectedIndex).innerText;
	document.getElementById("beforeendtypespan").innerHTML = timeTypeText;
}

function getnumber(date1,date2){
	//默认格式为"20030303",根据自己需要改格式和方法
	var year1 =  date1.substr(0,4);
	var year2 =  date2.substr(0,4);

	var month1 = date1.substr(5,2);
	var month2 = date2.substr(5,2);

	var day1 = date1.substr(8,2);
	var day2 = date2.substr(8,2);

	temp1 = year1+"/"+month1+"/"+day1;
	temp2 = year2+"/"+month2+"/"+day2;

	var dateaa= new Date(temp1); 
	var datebb = new Date(temp2); 
	var date = datebb.getTime() - dateaa.getTime(); 
	var time = Math.floor(date / (1000 * 60 * 60 * 24)+1);
	return time;
	//alert(time);
}
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    
    var fileLenth;
    /*try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert("用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！");
        createAndRemoveObj(obj);
        return  ;
    }*/
    var fileLenth=-1;
    try {
    	File.FilePath=objValue;   
        fileLenth= File.getFileSize();
    } catch (e){
        try{
            fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
			alert("<%=SystemEnv.getHtmlLabelName(31567,user.getLanguage()) %>");
			createAndRemoveObj(obj)
			return;
		}
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = fileLenth/(1024*1024) 
	var fileLenthByK =  fileLenth/1024;
	var fileLenthByM =  fileLenthByK/1024;

	var fileLenthName;
	if(fileLenthByM>=0.1){
		fileLenthName=fileLenthByM.toFixed(1)+"M";
	}else if(fileLenthByK>=0.1){
		fileLenthName=fileLenthByK.toFixed(1)+"K";
	}else{
		fileLenthName=fileLenth+"B";
	}
    if (fileLenthByM><%=maxUploadImageSize%>) {
        //alert("所传附件为:"+fileLenthByM+"M,此目录下不能上传超过<%=maxUploadImageSize%>M的文件,如果需要传送大文件,请与管理员联系!");
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthName+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");		
        createAndRemoveObj(obj);
    }
}
  function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow(-1);
    ncol=2; 
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "<input class=InputStyle  type=file size=45 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
function createAndRemoveObj(obj){
     var ie = (navigator.appVersion.indexOf("MSIE")!=-1);//IE      
     if(ie){
         jQuery(obj).select();
         document.execCommand("delete");
     }else{
         jQuery(obj).val(""); 
    }
}

function onShowBrowser3(id,url,linkurl,type1,ismand){
	if(type1==2||type1 ==19){
	    spanname = "field"+id+"span";
	    inputname = "field"+id;
		if(type1 ==2)
		  onFlownoShowDate(spanname,inputname,ismand);
        else
	      onWorkFlowShowTime(spanname,inputname,ismand);
	}else{
		if(type1!=152 && type1 !=142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170)
		{
			id1 = window.showModalDialog(url);
		}else{
            if(type1==135){
			    tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?projectids="+tmpids)
			}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
                tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?selectedids="+tmpids);
			}else if(type1==37) {
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?documentids="+tmpids);
            }else if (type1==142){
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
            }else if( type1==165 || type1==166 || type1==167 || type1==168){
                //index=InStr(id,"_");
                index=id.indexOf("_");
	            if (index!=-1){
		            //Mid(id,1,index-1)
		            tmpids=uescape("?isdetail=1&fieldid="+substr(id,0,index-1)+"&resourceids="+document.all("field"+id).value)
		            id1 = window.showModalDialog(url+tmpids);
	            }else{
		            tmpids=uescape("?fieldid="+id+"&resourceids="+document.all("field"+id).value);
		            id1 = window.showModalDialog(url+tmpids);
	            }
            }else{
               tmpids = document.all("field"+id).value;
			   id1 = window.showModalDialog(url+"?resourceids="+tmpids);
			}
           }
		
		if(id1){
			if  (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) 
			{
				if (id1.id!==""  && id1.id!=="0"){
					resourceids = id1.id;
					resourcename = id1.name;
					sHtml = "";
					resourceidss =resourceids.substr(1);
					resourceids = resourceids.substr(1);
					resourcename =resourcename.substr(1);
					
					ids=resourceids.split(",");
					names=resourcename.split(",");
					for(var i=0;i<ids.length;i++){
					   if(ids[i]!="")
					      sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp";
					}
					//$GetEle("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id).value= resourceidss;
				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					document.all("field"+id).value="";
				}
			}else{
			   if  (id1.id!=""  && id1.id!="0"){
                   if (type1==162){
				     ids = id1.id;
					names = id1.name;
					descs = wuiUtil.getJsonValueByIndex(id1,2);
					sHtml = "";
					ids =ids.substr(1);
					document.all("field"+id).value= ids;
					names =names.substr(1).split(",");
					descs =descs.substr(1).split(",");
					for(var i=0;i<names.length;i++){
					   sHtml = sHtml+"<a title='"+descs[i]+"' >"+names[i]+"</a>&nbsp";
					}
					document.all("field"+id+"span").innerHTML = sHtml;
					return;
				   }
				   if (type1==161){
				     name =wuiUtil.getJsonValueByIndex(id1,1);
					 desc = wuiUtil.getJsonValueByIndex(id1,2);
				     document.all("field"+id).value=wuiUtil.getJsonValueByIndex(id1,0);
					 sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp";
					 document.all("field"+id+"span").innerHTML = sHtml;
					 return;
				   }
			        if (linkurl == "") 
						document.all("field"+id+"span").innerHTML =wuiUtil.getJsonValueByIndex(id1,1);
					else
						document.all("field"+id+"span").innerHTML = "<a href="+linkurl+id1.id+" target='_blank'>"+id1.name+"</a>";
					document.all("field"+id).value=id1.id;

				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					
					document.all("field"+id).value=""
				}
              }  			
		}
	 }	
	onChangeCheckor(id);
}
</script>
</BODY>
</HTML>

