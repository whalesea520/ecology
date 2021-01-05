
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "CompanyComInfo" class = "weaver.hrm.company.CompanyComInfo" scope = "page"/>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%
String qname = Util.null2String(request.getParameter("flowTitle"));
String departmentid=Util.null2String(request.getParameter("departmentid"));
String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
String companyid=Util.null2String(request.getParameter("companyid"));
String signType = Util.null2String(request.getParameter("signType"));

String navName = "";
if(departmentid.length()>0) navName = DepartmentComInfo.getDepartmentName(departmentid);
else if(subcompanyid1.length()>0) navName = SubCompanyComInfo.getSubCompanyname(subcompanyid1);
else if(companyid.length()>0) navName = CompanyComInfo.getCompanyname(companyid);
else{
	navName = CompanyComInfo.getCompanyname("1");
}
%>
<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var common = new MFCommon();
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
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
				url:"HrmDefaultScheduleOperation.jsp?isdialog=1&operation=deleteschedule&id="+idArr[i],
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

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDefaultScheduleAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(16254,user.getLanguage())%>";
		//url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDefaultScheduleEdit&id="+id;
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDefaultScheduleTab&id="+id+"&showpage=1&isdialog=1";
		dialog.Height = 557;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(16254,user.getLanguage())%>";
		dialog.Height = 515;
	}
	url += "&subcompanyid=<%=subcompanyid1%>";
	dialog.Width = 800;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialogFortab2(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(16254,user.getLanguage())%>";
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDefaultScheduleTab&id="+id+"&showpage=2&isdialog=1";
	url += "&subcompanyid=<%=subcompanyid1%>";
	dialog.Width = 800;
	dialog.Height = 557;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=13 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=13")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16254,user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
boolean CanAdd = HrmUserVarify.checkUserRight("HrmDefaultScheduleAdd:Add" , user) ; 
%>

<BODY>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDefaultSchedule:Log" , user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%

String scheduleType = Util.null2String(request.getParameter("scheduleType")) ;
int relatedId= Util.getIntValue(subcompanyid1,0);
String relatedName="";
    //获得对象名称
if(scheduleType.equals("3")){
	relatedName=SystemEnv.getHtmlLabelName(140,user.getLanguage());
}else if(scheduleType.equals("4")){
	relatedName=SubCompanyComInfo.getSubCompanyname(""+relatedId);
}else if(scheduleType.equals("5")){
	relatedName=DepartmentComInfo.getDepartmentname(""+relatedId);
}else if(scheduleType.equals("6")){
	relatedName=ResourceComInfo.getResourcename(""+relatedId);
}
%>
<script type="text/javascript">
parent.setTabObjName('<%=relatedName%>');
</script>
<FORM id=frmMain name=frmMain method=post action="HrmDefaultScheduleList.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmDefaultScheduleAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%}%>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	    <wea:item>
		    <select class="inputstyle" id="scheduleType" name="scheduleType" style="width:150px" onChange="javascript:clearRelatedInfo()">
	      	<option value="">&nbsp;</option>
	        <option value="3" <% if(scheduleType.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
	     	  <option value="4" <% if(scheduleType.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	     </select>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(82921,user.getLanguage())%></wea:item>
	    <wea:item>
		    <select class="inputstyle" name="signType" style="width:150">
				<option value="-1">&nbsp;</option>
				<option value="1" <% if(signType.equals("1")) {%>selected<%}%>>1<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%></option>
				<option value="2" <% if(signType.equals("2")) {%>selected<%}%>>2<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%></option>
			</select>
	    </wea:item>
		  <wea:item><span id=spanShowRelatedIdLabel><%if(Util.getIntValue(scheduleType,0)>3){%><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%><%}%></span></wea:item>
		   <wea:item attributes="{'samePair':'buttonShowRelatedId'}">
				<brow:browser viewType="0"  name="subcompanyid1" browserValue='<%=subcompanyid1%>' 
			   browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
			   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164"
			   _callback="" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid1) %>'></brow:browser>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="common.resetCondition(this);"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	  	</wea:item>
	  </wea:group>	
	</wea:layout>
	
</div>
</FORM>
<%
//modified by wcd 2014-08-05
String backfields = " a.id,a.relatedId,a.scheduleType,a.valideDate as valideDate,a.relatedName,a.sign_type "; 
String fromSql  = "";
if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
	fromSql = "from( select a.id,a.relatedId,a.scheduleType,a.valideDateFrom || '~' || a.valideDateTo as valideDate,(case when a.scheduletype = 3 then b.companyname else c.subcompanyname end) as relatedName,a.sign_type from HrmSchedule a left join HrmCompany b on a.relatedid = b.id left join HrmSubCompany c on a.relatedid = c.id) a";
}else{
	fromSql = "from( select a.id,a.relatedId,a.scheduleType,a.valideDateFrom +'~'+a.valideDateTo as valideDate,(case when a.scheduletype = 3 then b.companyname else c.subcompanyname end) as relatedName,a.sign_type from HrmSchedule a left join HrmCompany b on a.relatedid = b.id left join HrmSubCompany c on a.relatedid = c.id) a";
}
String sqlWhere = " where 1=1 and scheduleType in(3,4)";
if(user.getUID()!=1){
	String subcomstr = SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmDefaultScheduleEdit:Edit",0);
	if(subcomstr.length()>0) sqlWhere += " and ("+Util.getSubINClause(subcomstr,"relatedId","in")+")";
}
String orderby = " scheduleType asc,relatedId asc " ;
String tableString = "";

if(subcompanyid1.length()>0){
	sqlWhere += " and scheduleType = 4 and relatedid = " + subcompanyid1;
}

if(!scheduleType.equals("")){
	sqlWhere+=" and scheduleType='"+scheduleType+"' ";
	if(relatedId>0){
		sqlWhere+=" and  relatedId="+relatedId;
	}
}

if(signType.length() > 0 && !signType.equals("-1")){
	if(signType.equals("1")){
		sqlWhere+=" and (sign_type is null or sign_type = "+signType+")";
	} else {
		sqlWhere+=" and sign_type = "+signType;
	}
}

if(qname.length() > 0){
	sqlWhere += " and relatedName like '%"+qname+"%'";
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.schedule.HrmDefaultSchedule.getHrmDefaultScheduleOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmDefaultSchedule:log", user)+":"+HrmUserVarify.checkUserRight("HrmkqSystemSetEdit:Edit" , user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:openDialogFortab2()\" text=\""+SystemEnv.getHtmlLabelName(34169,user.getLanguage())+"\" index=\"3\"  />";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_DefaultScheduleList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_DefaultScheduleList,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.schedule.HrmDefaultSchedule.getHrmDefaultScheduleCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" column=\"scheduleType\" orderkey=\"scheduleType\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";3=140,2=141,4=141,5=124,6=179]}\"/>"+
    "				<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage()) +"\" column=\"relatedId\" orderkey=\"relatedId\" transmethod=\"weaver.hrm.schedule.HrmDefaultSchedule.getRelatedName\" otherpara=\"column:scheduleType\"/>"+
    "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(717,user.getLanguage())+"\" column=\"valideDate\" orderkey=\"valideDate\"/>"+
	"				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(82921,user.getLanguage())+"\" column=\"sign_type\" orderkey=\"sign_type\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array[default=1"+SystemEnv.getHtmlLabelName(18083,user.getLanguage())+",2=2"+SystemEnv.getHtmlLabelName(18083,user.getLanguage())+"]}\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_DefaultScheduleList %>"/>  
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY></HTML>
<script language="javaScript">
	
function onSearch(){
	document.frmMain.submit();
}

function clearRelatedInfo(){
	jQuery("input[name=relatedId]").val(0);
	var scheduleType = $GetEle("scheduleType").value;
	if(scheduleType==4){
		showEle("buttonShowRelatedId");
		jQuery("#spanShowRelatedIdLabel").html("<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>");
	}else{
		hideEle("buttonShowRelatedId");
		_writeBackData('subcompanyid1','1',{'id':'','name':''});
		jQuery("#spanShowRelatedIdLabel").html("");
	}
}


function onShowRelatedId(){
	var scheduleType = $GetEle("scheduleType").value;
	if (scheduleType == "4"){
	    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
	}else if(scheduleType == "5"){
	    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	}else if (scheduleType == "6"){
	    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	}


	if(data!=null){
	    if (data.id!= ""){
		    jQuery("input[name=relatedId]").val(data.id);
		}else{
		    jQuery("input[name=relatedId]").val("<IMG src = '/images/BacoError_wev8.gif' align = absMiddle>");
		}
	}

}
jQuery(document).ready(function(){
<%if(Util.getIntValue(scheduleType,0)<=3){%>
hideEle("buttonShowRelatedId");
<%}%>
});
</script>

<script language=vbs>
sub onShowRelatedId1()
	scheduleType = document.all("scheduleType").value

	if scheduleType = "4" then
	    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmMain.relatedId.value)
	else if scheduleType = "5" then
	         id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.relatedId.value)
	     else if scheduleType = "6" then 
	              id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="&frmMain.relatedId.value)
		      end if
		 end if
	end if

	if NOT isempty(id) then
	    if id(0)<> "" then
		    relatedNameSpan.innerHtml = id(1)
		    frmMain.relatedId.value = id(0)
		else
		    relatedNameSpan.innerHtml = ""
		    frmMain.relatedId.value=""
		end if
	end if

end sub
</script>
