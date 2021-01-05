
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.formmode.service.ReportInfoService"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
String appid=Util.null2String(request.getParameter("appid"));
String reportname = "";
String formID = "";	
String formName = "";
int pageCount = 10;
String defaultSql = "";
String reportdesc = "";
String modeid = "";
String dsporder = "";
String isnullFun=CommonConstant.DB_ISNULL_FUN;
ReportInfoService reportInfoService=new ReportInfoService();
BillComInfo billComInfo=new BillComInfo();
if(id!=0){
	Map<String,Object> map=reportInfoService.getReportInfoById(id);
	if(map.size()>0){
		reportname=Util.toScreen(Util.null2String(map.get("reportname")),user.getLanguage());
		formID=Util.null2String(map.get("formid"));
		if ("".equals(appid)) appid=Util.null2String(map.get("appid"));
		modeid=Util.null2String(map.get("modeid"));
		formName = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage()));
		formName = "<a href=\"#\" onclick=\"toformtab('"+formID+"')\">"+formName+"</a>";
		pageCount=Util.getIntValue(Util.null2String(map.get("reportnumperpage")),10);
		defaultSql=Util.toScreenToEdit(Util.null2String(map.get("defaultsql")),user.getLanguage());
		reportdesc=Util.toScreenToEdit(Util.null2String(map.get("reportdesc")),user.getLanguage());
		dsporder = Util.null2String(map.get("dsporder"));
	}
}
String modename = "";
RecordSet rs = new RecordSet();
int isvirtualform = 0;
if(!StringHelper.isEmpty(formID)) {
	rs.executeQuery("select isvirtualform from ModeFormExtend where formid=?",formID);
	if(rs.next()){
		isvirtualform = rs.getInt("isvirtualform");
	}
}

String titlename=SystemEnv.getHtmlLabelName(26504,user.getLanguage());//报表设置

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_Report a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
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
<HTML>
	<HEAD>
		<title></title>
		<style>
		a:hover{color:#0072C6 !important;}
		.e8_data_virtualform{
			background: url(/formmode/images/circleBgGold_wev8.png) no-repeat 1px 1px;
			width: 16px;
			display:inline;
			color: #fff;
			font-size: 9px;
			font-style: italic;
			top: 5px;
			padding-left: 3px;
			padding-right: 6px;
			padding-top: 2px;
		}
		</style>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
		<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
		<script>
			function onShowModeSelect(inputName, spanName){
				var formid_ = $("#formid").val();
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp?formid="+formid_);
				if (datas){
				    if(datas.id!=""){
					    $(inputName).val(datas.id);
						if ($(inputName).val()==datas.id){
					    	$(spanName).html(datas.name);
						}
				    }else{
					    $(inputName).val("");
						$(spanName).html("");
					}
				}
			}
			function checkVal(){
				var valid=false;
				var checkrule='^(-?\\d+)(\\.\\d+)?$';
				var dsporder=document.getElementById("dsporder").value;
				eval("valid=/"+checkrule+"/.test(\""+dsporder+"\");");
				if (dsporder!=''&&!valid){
					alert('<%=SystemEnv.getHtmlLabelName(82018,user.getLanguage())%>');//显示顺序中请输入数字!
					document.getElementById("dsporder").value='';
				}
			}
			function checkPageNumVal(){
				var pagenumber=document.getElementById("reportnumperpage").value;
				if(!/^\+?[1-9][0-9]*$/.test(pagenumber)){
					document.getElementById("reportnumperpage").value='';
					document.getElementById("reportnumperpageimage").innerHTML="<font color='red'><%=SystemEnv.getHtmlLabelName(82019,user.getLanguage())%></font>";//输入值不符合正整数!
				}else{
					document.getElementById("reportnumperpageimage").innerHTML="";
				}
			}
		</script>
</HEAD>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	//if(editType.equals("edit")){
		if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&treelevel.equals("0")&&id!=0)||fmdetachable.equals("1")&&!treelevel.equals("0")){//保存
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		if(id!=0){
			if(operatelevel>1){//删除
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			if(operatelevel>0&&(!fmdetachable.equals("1")||fmdetachable.equals("1")&&!treelevel.equals("0"))){//新建报表
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82260,user.getLanguage())+",javascript:newReportinfo(),_self} " ;//新建报表
				RCMenuHeight += RCMenuHeightStep ;
			}
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",/formmode/setup/reportinfoShareBase.jsp?id="+id+",_self} " ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;//预览
			RCMenuHeight += RCMenuHeightStep;
			if(operatelevel>0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createMenuNew(),_self} " ;//创建菜单
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+",javascript:viewmenu(),_self} " ;//查看菜单地址ַ
			RCMenuHeight += RCMenuHeightStep;
		}
	//}else{
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
		//RCMenuHeight += RCMenuHeightStep;
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
		//RCMenuHeight += RCMenuHeightStep;
	//}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY>
	<FORM id="reportInfoForm" name="reportInfoForm" action="/weaver/weaver.formmode.servelt.ReportInfoAction" method="post">
		<input type="hidden" name="id" id="id" value="<%=id%>">
		<input type="hidden" name="action" id="action" value="reportedit">
		<input type="hidden" name="appid" id="appid" value="<%=appid %>"/>
		<input type="hidden" name="fmdetachable" id="fmdetachable" value="<%=fmdetachable %>"/>
		<input type="hidden" name="detailjson" id="detailjson" value=""/>
		
		<table class="e8_tblForm">
			<TBODY>
				<TR>									          
					<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
					<td class="e8_tblForm_field">
						<INPUT type=text class=Inputstyle style="width:80%" id="reportname" name="reportname" maxlength="50" onchange='checkinput("reportName","reportnamespan")' value="<%=reportname%>">
						<SPAN id=reportnamespan>
							<%if ("".equals(reportname)) { %>
				               <img src="/images/BacoError_wev8.gif"/>
			                <% } %>
						</SPAN>
					</TD>
				</TR>
				<TR>
					<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%><!-- 表单名称 --></TD>
					<td class="e8_tblForm_field">
						<%if(isvirtualform==1){ formName = formName + "<div class=\"e8_data_virtualform\" title=\""+SystemEnv.getHtmlLabelName(33885,user.getLanguage())+"\">V</div>";} %><!-- 虚拟表单 -->
						<%
						    String tempTitle = SystemEnv.getHtmlLabelNames("18214,31923",user.getLanguage());
						%>
						<brow:browser viewType="0" name="formid" browserValue="<%=formID%>" 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp?isReport=1"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp?isvirtualform=1&type=mdFormBrowser&rightStr=ModeSetting:All" linkUrl=""  width="228px"
						browserDialogWidth="500px" tempTitle="<%=tempTitle %>"
						browserSpanValue="<%=formName %>"
						_callback="changeModeId"
						></brow:browser>
					</td>
				</TR>
				
				<%
				String _style = "display:none;";
				if (!"".equals(formID)) { 
					_style = "";
				}%>
				<tr id="modetr" style="<%=_style%>">
					<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 --></td>
					<td class="e8_tblForm_field">
						<!-- 
						<button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
						<span id=modeidspan><%=modename%></span>
						<input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
						-->
						<select id="modeid" name="modeid" style="width: 200px;">
							<option></option>
							<%if(!formID.isEmpty()){
								String modeSql = "select id,modename from modeinfo where formid="+formID+" and "+isnullFun+"(isdelete,0)!=1 ";
								if(fmdetachable.equals("1")){
					              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
						  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"ModeSetting:All",0);
						  			String subCompanyIds = "";
						  			for(int i=0;i<mSubCom.length;i++){
						  				if(i==0){
						  					subCompanyIds += ""+mSubCom[i];
						  				}else{
						  					subCompanyIds += ","+mSubCom[i];
						  				}
						  			}
						  			if(subCompanyIds.equals("")){
						  				modeSql+= " and 1=2 ";
						  			}else{
						  				modeSql+= " and subCompanyId in ("+subCompanyIds+") ";
						  			}
					          	}
								modeSql += "order by id";
								rs.executeSql(modeSql);
								boolean isInSubCompany = false;
								while(rs.next()){
									String mid = rs.getString("id");
									String mname = rs.getString("modename");
									if(mid.equals(modeid)){
										isInSubCompany = true;
									}
							%>
									<option <%if(mid.equals(modeid)){%>selected="selected"<%} %> value="<%=mid %>"><%=mname %></option>
							<%} 
								if(!isInSubCompany){
									modeSql = "select id,modename from modeinfo where id="+modeid;
									rs.executeSql(modeSql);
									if(rs.next()){
										String mname = rs.getString("modename");
								%>
									<option  selected="selected"  value="<%=modeid %>"><%=mname %></option>
								<% } }
							
							} %>
						</select>
					</td>
				</tr>

				<TR>
					<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%></TD><!-- 每页显示记录数 -->
					<td class="e8_tblForm_field">
						<input type="text" maxlength="9" onchange="checkPageNumVal()" value="<%=pageCount%>" name="reportnumperpage" id="reportnumperpage">
						<SPAN id=reportnumperpageimage></SPAN>
					</td>
				</TR>
				<TR>
                    <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序 --></TD>
                    <td class="e8_tblForm_field">
                    	<input type="text" name="dsporder" id="dsporder" onchange="checkVal()" value="<%=dsporder %>"/>
                    </TD>
                </TR>
                <TR>
                    <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81366,user.getLanguage())%></TD><!-- 固定查询条件 -->
                    <td class="e8_tblForm_field">
                     <textarea style="height:40px;width:80%;overflow:auto;" name="defaultsql" onchange="this.value = this.value.substring(0, 2000)" maxlength="2000" class=Inputstyle><%=defaultSql%></textarea>
                      <table>
						<tr>
							<td>
								<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382960,user.getLanguage())%>&#10;' id="remind">
									<img align="absMiddle" src="/images/remind_wev8.png">
								</span>
							</td>
							<td style="padding-left: 5px;">
								<%=SystemEnv.getHtmlLabelName(31444,user.getLanguage())%><!-- 表单主表表名的别名为a，查询条件的格式为: a.a = '1' and a.b = '3' and a.c like '%22%' -->
							</td>
						</tr>
					</table>
                    </TD>
                </TR>  
                <TR>
                    <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><!-- 描述 -->
                    <td class="e8_tblForm_field">
                        <textarea style="height:40px;width:80%;overflow:auto;" name="reportdesc"><%=reportdesc%></textarea>
                    </TD>
                </TR>
			</TBODY>
		</TABLE>
  	</FORM>						
    <BR>
</BODY>
<script>
function changeModeSel(){
	var modeid = document.getElementById("modeid");
	//删除所有的选择项
	for (var i = modeid.options.length-1; i >0; i--) {        
	        modeid.options.remove(i);        
	}
	var formid = $("#formid").val();
	if(formid!=""){
		jQuery.ajax({
		   type: "POST",
		   dataType:"json",
		   url: "/weaver/weaver.formmode.servelt.CustomSearchAction?action=getModeDataByFormId",
		   data: "formid="+formid,
		   success: function(data){
				if(data&&data.length>0){
					for(var i=0;i<data.length;i++){
						var varItem = new Option(data[i].modename, data[i].id);      
        				modeid.options.add(varItem); 
        				if(i==0){
        					modeid.value = data[i].id;
        				}
					}
				}
		   }
		});
	}
	
}

function onDelete(){
    rightMenu.style.visibility = "hidden";
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.reportInfoForm.action.value="reportdelete";
		document.reportInfoForm.submit();
	});
}

function doBack(){
	enableAllmenu();
	<%--location.href="/formmode/setup/reportinfoBase.jsp?id=<%=oldid%>";--%>
}
    
function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function submitData(){
    rightMenu.style.visibility = "hidden";
	enableAllmenu();
	if ($("#id").val()==0) {
		document.reportInfoForm.action.value="reportadd";
	}
	var checkfields = "reportname,formid,reportnumperpage";
	if (checkFieldValue(checkfields)){
		reportInfoForm.submit();
	}
}

function newReportinfo(){
	parent.document.location.href = "reportinfoManage.jsp?appid=<%=appid%>";
}

function checkSub(){
		var len = document.forms[0].elements.length;
		var i=0;
		var index;
		var selectName;
		var checkName;
		var lableName; 
		var compositororderName;
		submit = true;   
		var rowsum1 = 0;
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name.substring(0,8)=='dborder_'){
			    index = document.forms[0].elements[i].name.substring(8,document.forms[0].elements[i].name.length);
			    checkName = "dborder_" + index;
			    selectName = "dbordertype_" + index;
			    lableName = "lable_" + index;
			    compositororderName = "compositororder_" + index;
				if(document.all(checkName).checked == true){
		        	if(document.all(selectName).value=="n"){//字段的“排序类型”未选择
		        		Dialog.alert('[' + document.all(lableName).value + '] <%=SystemEnv.getHtmlLabelName(23276,user.getLanguage())%>!',function(){displayAllmenu();});
		          		submit = false;
		          		break;
					}
		    	}
			}
		}
		if(submit == true){
			submit = checkSame();
		}
		return submit;
}

function checkSame(){
	<%--var num = <%=tmpcount%>;--%>
	var num = 0;
	var showcount = 0;
	var ordervalue = "";
	var tempcount = -1;
	var checkcount = 0;
	for(i=1;i<=num;i++){
		if(document.all("isshow_"+i).checked == true){
			showcount = showcount+1;
		}
	}
	var arr = new Array(showcount);
	for(i=1;i<=num;i++){
		if(document.all("isshow_"+i).checked == true){
			tempcount = tempcount + 1;
			arr[tempcount] = document.all("dsporder_"+i).value;
		}
	}
	for(i=1;i<=num;i++){
		checkcount = 0;
		if(document.all("isshow_"+i).checked == true){
			ordervalue = document.all("dsporder_"+i).value;
			for(a=0;a<arr.length;a++){
				if(parseFloat(ordervalue) == parseFloat(arr[a])){
					checkcount = checkcount + 1;
				}
			}
			if(checkcount>1){//您填写的显示顺序有重复数字
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage()) %>!",function(){displayAllmenu();});
				return false;
			}
		}
	}
	return true;
}
function onPreview(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
	window.open(url);
}
function createmenu(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址ַ
}

function onCheck(index)
{
   if(document.all("dborder_" + index).checked == true){
      document.all("dbordertype_" + index).disabled = false;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = false;
      document.all("compositororder_" + index).value = "0";
	} else {
      document.all("dbordertype_" + index).disabled = true;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      document.all("compositororder_" + index).value = "";
	}
}

function onCheckShow(index)
{
   if(document.all("isshow_" + index).checked == true){
      document.all("isstat_" + index).disabled = false;
      document.all("dborder_" + index).disabled = false;
      document.all("dsporder_" + index).disabled = false;
      document.all("dsporder_" + index).value = "0";
	} else {
      document.all("dborder_" + index).disabled = true;
      document.all("dborder_" + index).checked = false;
      document.all("dbordertype_" + index).disabled = true;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      document.all("compositororder_" + index).value = "";
      document.all("isstat_" + index).disabled = true;
      document.all("isstat_" + index).checked = false;
      document.all("dsporder_" + index).disabled = true;
      document.all("dsporder_" + index).value = "";
	}
}

function onShowFormSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
			$("#modetr").css("display","");
	    }else{
		    $(inputName).val("");
		    $(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("#modeid").val("");
			$("#modetr").css("display","none");
		}
	    changeModeSel();
	} 
}

function toformtabFormChoosed(data){
	var dataArr=data.split("_");
	var formid=dataArr[0];
	var isvirtualform=dataArr[1];
	toformtab(formid,isvirtualform);
}

function toformtab(formid,isvirtualform){
    if (<%=isvirtualform%> == 1||isvirtualform==1) {
        FormmodeUtil.writeCookie(FormModeConstant._CURRENT_FORM, formid);
    	clickTopSubMenu(2);
    } else {
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;	
		var parm = "&formid="+formid;
		if(formid=='') {
			parm = '';
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
		}else{
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82022,user.getLanguage())%>";//编辑表单
		}
		diag_vote.Width = 1000;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		
		diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1"+parm;
		diag_vote.isIframe=false;
		diag_vote.show();
	}
}

function clickTopSubMenu(menuIndex){
	var tDoc = top.document;
	var $submenusUL = $("#submenu", tDoc);
	$(".menuitem:eq("+menuIndex+")", $submenusUL).click();
}

function changeModeId(e,json){
	if(<%=id%><=0){
		return;
	}
	if(json){
		var id = json.id;
		if(id==""){
			resetSelect("modeid",false);
		}else{
			$.ajax({
			   type: "POST",
			   dataType:"json",
			   url: "/weaver/weaver.formmode.servelt.CustomSearchAction",
			   data: "action=getModeDataByFormIdDetach&formid="+id+"&fmdetachable=<%=fmdetachable%>",
			   success: function(data){
			     resetSelect("modeid",true,data,true);
			   }
			});
		}
	}
}

/**
 * 
 * @param {Object} objid  要改变的select对象的id
 * @param {Object} flag  是否需要添加新数据
 * @param {Object} data  数据
 * @param {Object} isFirstSel  是否默认选中第一项
 */
function resetSelect(objid,flag,data,isFirstSel){
	var obj = jQuery("#"+objid);
	obj.selectbox("detach");
	obj.get(0).options.length = 0;
	obj.append("<option></option>");
	if(flag){
		for(var i=0;i<data.length;i++){
			if(i==0&&isFirstSel){//默认选中第一项
				obj.append("<option value='"+data[i].id+"' selected='selected' >"+data[i].name+"</option>");
			}else{
				obj.append("<option value='"+data[i].id+"' >"+data[i].name+"</option>");
			}
		}
	}
    obj.selectbox("attach");
}
 function createMenuNew(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
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
</HTML>