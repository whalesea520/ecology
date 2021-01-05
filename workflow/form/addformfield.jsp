<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
 <%@ page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    if(!ajax.equals("1")){
%>
<LINK href="/js/jquery/plugins/tooltip/simpletooltip_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/jquery/plugins/tooltip/jquery.tooltip_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style>
		.bgmulbro{
			padding:0px;
			margin:0px;
			BACKGROUND-COLOR: #F5FAFA;
			height:30px;
		}
		.bgmulbro02{
			BACKGROUND-COLOR: #F5FAFA;
		}
		.bgmulbro03{
			padding:0px;
			margin:0px;
		}
		
		TABLE.ViewForm TD {
				padding:0 0 0 0;
		}
	
</style>
<%
    }
%>
</head>

<%
	String formname="";
	String formdes="";
	int formid=0;
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int sysFormId=0;
    RecordSet.execute("select formid from workflow_base where id=1");
    
    if (RecordSet.next())
    {
    sysFormId=RecordSet.getInt(1);
    }
  

	int errorcode=Util.getIntValue(Util.null2String(request.getParameter("errorcode")),0);
	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();
	formdes = Util.StringReplace(formdes,"\n","<br>");
    
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(261,user.getLanguage());
	String needfav ="";
	if(!ajax.equals("1"))
	{
	needfav ="1";
	}
	String needhelp ="";
    
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int isbill = Util.getIntValue(request.getParameter("isbill"),0);
    int operatelevel=UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,"FormManage:All",formid,isbill);
    if(operatelevel < 0){
		response.sendRedirect("/notice/noright.jsp");
		return;
    }
%>
<%
if(!ajax.equals("1")){
%>
<script language="JavaScript">
var operatelevel = <%=operatelevel%>;
<!--Begin
// Add the selected items in the parent by calling method of parent
function addSelectedItemsToParent() {
self.opener.addToParentList(window.document.tabfieldfrm.destList);
window.close();
}
// Fill the selcted item list with the items already present in parent.
function fillInitialDestList() {
	var destList = window.document.tabfieldfrm.destList;
	var srcList = self.opener.window.document.tabfieldfrm.parentList;
	for (var count = destList.options.length - 1; count >= 0; count--) {
		destList.options[count] = null;
	}
	if(srcList != null){
		for(var i = 0; i < srcList.options.length; i++) {
			if (srcList.options[i] != null)
				destList.options[i] = new Option(srcList.options[i].text,srcList.options[i].value);
   		}
   	}
}
// Add the selected items from the source to destination list
function addSrcToDestList() 
{
	
	if(operatelevel<=0)
	{
		return false;
	}
	destList = window.document.tabfieldfrm.destList;
	srcList = window.document.tabfieldfrm.srcList;
	var len = destList.length;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}

// Add the selected items from the source to destination list2
function addSrcToDestList2() {
	if(operatelevel<=0)
	{
		return false;
	}
	destList = window.document.tabfieldfrm.destList2;
	srcList = window.document.tabfieldfrm.srcList2;
	var len = destList.length;
	var rowindex = fromfieldoTable.tBodies[0].rows.length - 1;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			
			for (var count=0;count<rowindex;count++)
			{
			destListTemp=document.all("destListMul"+count);
		    var len1 = destListTemp.length;
			for(var count1 = 0; count1 < len1; count1++) 
			{
			if (destListTemp.options[count1] != null) {
					if (srcList.options[i].value == destListTemp.options[count1].value) {
						found = true;
						break;
			  		}
  				 }
			}
			}
			
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}

// Add the selected items from the source to destination listMul
function addSrcToDestList3(src,dst) {
	if(operatelevel<=0)
	{
		return false;
	}
	srcList= document.all(src);
	destList=document.all(dst);
	var len = destList.length;
	//window.document.tabfieldfrm.destList2;
	//srcList = window.document.tabfieldfrm.srcList2;	
	var rowindex = fromfieldoTable.tBodies[0].rows.length - 1;
	destList1 = window.document.tabfieldfrm.destList2;
	var len2 = destList1.length;
	
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			//var found1 = false;
			for(var count = 0; count < len2; count++) {
				if (destList1.options[count] != null) {
				  
					if (srcList.options[i].value == destList1.options[count].value) {
					   
						found = true;
						
						break;
			  		}
  				 }
			}
			//var found2 = false;
			for (var count=0;count<rowindex;count++)
			{
			destListTemp=document.all("destListMul"+count);
			//alert(destListTemp);
			
			if (destListTemp!=destList)
			{var len1 = destListTemp.length;
			for(var count1 = 0; count1 < len1; count1++) 
			{
			if (destListTemp.options[count1] != null) {
			         //alert("src:"+srcList.options[i].text);
			         //alert("dst:"+destListTemp.options[count1].text);
					if (srcList.options[i].value == destListTemp.options[count1].value) {
						found = true;
						
						break;
			  		}
  				 }
			}
			}
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}
// Deletes from the destination mul.
function deleteFromDestList3(src,dst) {
if(operatelevel<=0)
{
	return false;
}
var destList  = destList=document.all(dst);
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}

// Up selections from the destination mul.
function upFromDestList3(dst) {
if(operatelevel<=0)
{
	return false;
}
var destList  = destList=document.all(dst);
var len = destList.options.length;
for(var i = 0; i <= (len-1); i++) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i>0 && destList.options[i-1] != null){
		fromtext = destList.options[i-1].text;
		fromvalue = destList.options[i-1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i-1] = new Option(totext,tovalue);
		destList.options[i-1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
// Down selections from the destination mul.
function downFromDestList3(dst) {
if(operatelevel<=0)
{
	return false;
}
var destList  = destList=document.all(dst);
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i<(len-1) && destList.options[i+1] != null){
		fromtext = destList.options[i+1].text;
		fromvalue = destList.options[i+1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i+1] = new Option(totext,tovalue);
		destList.options[i+1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
// Deletes from the destination list.
function deleteFromDestList() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// Deletes from the destination list2.
function deleteFromDestList2() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// Up selections from the destination list.
function upFromDestList() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = 0; i <= (len-1); i++) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i>0 && destList.options[i-1] != null){
		fromtext = destList.options[i-1].text;
		fromvalue = destList.options[i-1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i-1] = new Option(totext,tovalue);
		destList.options[i-1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
// Up selections from the destination list2.
function upFromDestList2() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = 0; i <= (len-1); i++) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i>0 && destList.options[i-1] != null){
		fromtext = destList.options[i-1].text;
		fromvalue = destList.options[i-1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i-1] = new Option(totext,tovalue);
		destList.options[i-1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
// Down selections from the destination list.
function downFromDestList() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i<(len-1) && destList.options[i+1] != null){
		fromtext = destList.options[i+1].text;
		fromvalue = destList.options[i+1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i+1] = new Option(totext,tovalue);
		destList.options[i+1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}

// Down selections from the destination list2.
function downFromDestList2() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i<(len-1) && destList.options[i+1] != null){
		fromtext = destList.options[i+1].text;
		fromvalue = destList.options[i+1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i+1] = new Option(totext,tovalue);
		destList.options[i+1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
  
    //oPopup   =   window.createPopup();   
    function   showtitle(evt){   
    	//var evt = e ? e : (window.event ? window.event : null);
    	
    	if($.browser.msie){
			obj = evt.srcElement
			if(obj.selectedIndex!=-1){   
				
				if(obj.options[obj.selectedIndex].text.length > 2){  					
					$("#simpleTooltip").remove();					
					var  tipX;
					var  tipY;
					tipX=evt.clientX+document.body.scrollLeft+6;
					tipY=evt.clientY+document.body.scrollTop+6;		
					$("body").append("<div id='simpleTooltip' style='position: absolute; z-index: 100; display: none;'>" + obj.options[obj.selectedIndex].text + "</div>");
					var tipWidth = $("#simpleTooltip").outerWidth(true)
					$("#simpleTooltip").width(tipWidth);
					$("#simpleTooltip").css("left", tipX).css("top", tipY).fadeIn("medium");
				}
			}
		}
    }   


function selectall(obj){
	tmpstr="";
	destinationList = window.document.tabfieldfrm.destList;
	for(var count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.tabfieldfrm.formfields.value=tmpstr;

    tmpstr="";
	destinationList = window.document.tabfieldfrm.destList2;
	for(count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.tabfieldfrm.formfields2.value=tmpstr;
	window.document.tabfieldfrm.rownum.value=fromfieldoTable.tBodies[0].rows.length - 1;
	var len=fromfieldoTable.tBodies[0].rows.length - 1;
	for(var i=0;i<len;i++)
	{
	dstlists=document.all("destListMul"+i);
	for(var count = 0; count <= dstlists.options.length - 1; count++)
     {
      dstlists.options[count].selected=true;
	 }
	 }
//	alert(tmpstr);
	window.document.tabfieldfrm.submit();
    obj.disabled=true;
}
// End -->
</script>
<%}%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<form name="tabfieldfrm" method=post action="/workflow/form/form_operation.jsp">
<input type="hidden" value="formfield" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="" name="formfields">
<input type="hidden" value="" name="formfields2">
<input type="hidden" value="" name="rownum">
<input type=hidden name="ajax" value="<%=ajax%>">
<%
if(operatelevel>0){
%>
<DIV class=BtnBar>
	  <%
if (formid!=sysFormId)
{
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(this),_self}" ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldselectall(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
}
%>
<%
String nocancelmenuflag = Util.null2String(request.getParameter("nocancelmenuflag"));
if(!ajax.equals("1")&&!nocancelmenuflag.equals("nocancelmenu")){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addDefineForm.jsp?isoldform=1&formid="+formid+",_parent}" ;
//RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel > 0){ %>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" <%if(!ajax.equals("1")) {%> onclick="javascript:selectall(this)" <%}else{ %> onclick="javascript:fieldselectall(this)"<%}%> >
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>

<%
if (formid==sysFormId)  //如果是系统提醒工作流不能修改字段
{
   out.print("<font color='red'>"+SystemEnv.getHtmlLabelName(19318,user.getLanguage())+"</font>");  
   return;
}

boolean flags=false;
String browmark="";
String sHtmlzzl="";	
int sapclos=1;
%>
<%if(errorcode==1){%>
	<font color="red"><%=SystemEnv.getHtmlLabelName(22410,user.getLanguage())%>！</font>
<%}else if(errorcode==2){%>
	<font color="red"><%=SystemEnv.getHtmlLabelName(24311,user.getLanguage())%>！</font>
<%}%>
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%>'>
    	<wea:item attributes="{'colspan':'full'}">
			<table class="viewform">
				<colgroup>
				<col width="45%">
				<col width="10%">
				<col width="45%">
				</colgroup>
				<tr class=header>
					<td align=center class=field><%=SystemEnv.getHtmlLabelName(15453,user.getLanguage())%></td>
					<td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>    
					<td align=center class=field><%=SystemEnv.getHtmlLabelName(18765,user.getLanguage())%></td>
					<td>&nbsp;</td>
				</tr>
				<tr class="Spacing" style="height: 1px"><td class="Line" colSpan=3></td></tr>
				<tr>
					<td vaglin="middle">
						<select class=inputstyle  size="15" name="srcList" multiple style="width:100%;height:100%" onchange="showtitle(event)" ondblclick="addSrcToDestList()">
							<%
							FieldMainManager.resetParameter() ;
							FieldMainManager.setUserid(user.getUID());
							FieldMainManager.selectAllCodViewField();
							%>
							<%while(FieldMainManager.next()){%>
							<option class="vtip" title="<%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>" value="<%=FieldMainManager.getFieldManager().getFieldid() %>"><%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>
							</option>
							<%}%>
						</select>
					</td>
					<td align=center>   
						<img class="upimg" src="/js/dragBox/img/up_wev8.png" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList();">
						<br><br>
						<img class="leftimg" src="/js/dragBox/img/5_wev8.png" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestList();">
						<br><br>
						<img class="rightimg" src="/js/dragBox/img/4_wev8.png"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:addSrcToDestList();">
						<br><br>
						<img class="downimg" src="/js/dragBox/img/down_wev8.png"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList();">
					</td>
					<td align=center>
						<select class=inputstyle  size=15 name="destList" multiple style="width:100%;height:100%" onchange="showtitle(event)" ondblclick="deleteFromDestList()">
							<%
							FormFieldMainManager.setFormid(formid);
							FormFieldMainManager.selectFormField();
							while(FormFieldMainManager.next()){
							%>
							<option class="vtip" title="<%=FieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>" value="<%=FormFieldMainManager.getFieldid()%>"><%=FieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>
							</option>
							<%}%>
						</select>
					</td>
					<td >&nbsp;</td>
				</tr>
				<tr class=header>
				    <td align=center class=field><%=SystemEnv.getHtmlLabelName(15453,user.getLanguage())%></td>
					<td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
					<td align=left class=field>
					<%
					RecordSet02.execute("select * from sap_multiBrowser where mxformname='0' and mxformid='"+formid+"'");
					if(RecordSet02.next()){
						browmark=RecordSet02.getString("browsermark");
					}
					//sHtmlzzl+=<div style="display:block;float:left;">SystemEnv.getHtmlLabelName(30313,user.getLanguage())</div>;
					//"<button id='newsapmultiBrowser_0' class=browser onclick='OnsapMultiBrowser(this,0)' name='newsapmultiBrowser_0' type='button'></BUTTON>"+
					//out.println(sHtmlzzl);
					//" <div style='display:block;float:left;width:120px;'>"
					//" <brow:browser viewType='0' name='newsapmultiBrowser_0' " +
					//" browserValue='' browserOnClick='OnsapMultiBrowser(this,0)' " +
					//" hasInput='true' isSingle='true' hasBrowser='true' isMustInput='0' completeUrl='' "+
					//" browserSpanValue=''> </brow:browser>";
					//" </div>"
					%>
					
					
					<div style="display:block;float:left;">
						<%=SystemEnv.getHtmlLabelName(30313,user.getLanguage())%>&nbsp;&nbsp;
					</div>
					<div style="display:block;float:left;width:120px;">
					<!--  
					<brow:browser viewType="0" name="newsapmultiBrowservalue_0" browserValue='<%=browmark %>' 
					          browserSpanValue='<%=browmark %>' browserOnClick="OnsapMultiBrowser('this',0)" 
					          hasInput="true" isSingle="true" hasBrowser = "true"  
					          isMustInput='1' completeUrl="" 
					          needHidden="true" ></brow:browser>
					 -->         
					 <input style="border:0px;cursor: pointer;" id='newsapmultiBrowser_0' class=e8_browflow onclick='OnsapMultiBrowser(this,0)' name='newsapmultiBrowser_0' type='button'>
					 <SPAN  id='newsapmultiBrowserinner_0'><%=browmark %></SPAN>
					 <INPUT id='newsapmultiBrowservalue_0'   name='newsapmultiBrowservalue_0'   type=hidden value="<%=browmark %>"/>
				
					 
					</div>
					<div style="display:block;float:left;">
						&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18766,user.getLanguage())%>
					</div>
					 
					 <%--
					 <%=SystemEnv.getHtmlLabelName(30313,user.getLanguage())%>&nbsp;&nbsp;
					 <button id='newsapmultiBrowser_0' class=browser onclick='OnsapMultiBrowser(this,0)' name='newsapmultiBrowser_0' type='button'></BUTTON>
					 <SPAN  id='newsapmultiBrowserinner_0'><%=browmark %></SPAN>
					 <INPUT id='newsapmultiBrowservalue_0'   name='newsapmultiBrowservalue_0'   type=hidden value="<%=browmark %>"/>
					 &nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18766,user.getLanguage())%>
					 --%>
					<%
					//"<SPAN  id='newsapmultiBrowserinner_0'>"+browmark+"</SPAN>"+
					//"<INPUT id='newsapmultiBrowservalue_0'   name='newsapmultiBrowservalue_0'   type=hidden value='"+browmark+"'/>";
					//System.out.println(sHtmlzzl);
					%>
					<%--
					 --%>
					
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td vaglin="middle">
						<select class=inputstyle  size="15" name="srcList2" multiple style="width:100%;height:262px" onchange="showtitle(event)"  ondblclick="addSrcToDestList2()">
						<%
						FieldMainManager.resetParameter() ;
						FieldMainManager.setUserid(user.getUID());
						FieldMainManager.selectAllCodViewDetailField() ;
						%>
						<%while(FieldMainManager.next()){%>
						<option class="vtip" title="<%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>" value="<%=FieldMainManager.getFieldManager().getFieldid() %>"><%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>
						</option>
						<%}%>
						</select>
					</td>
					<td align=center>
						<img class="upimg" src="/js/dragBox/img/up_wev8.png" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList2();">
						<br><br>
						<img class="leftimg" src="/js/dragBox/img/5_wev8.png" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestList2()">
						<br><br>
						<img class="rightimg" src="/js/dragBox/img/4_wev8.png"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:addSrcToDestList2();">
						<br><br>
						<img class="downimg" src="/js/dragBox/img/down_wev8.png"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList2();">
					</td>
					<td align=center>     
						<select class=inputstyle  size=15 name="destList2" multiple style="width:100%;height:262px" onchange="showtitle(event)" ondblclick="deleteFromDestList2()">
						<%
						FormFieldMainManager.setFormid(formid);
						FormFieldMainManager.selectDetailFormField();
						while(FormFieldMainManager.next()){
							flags=true;
						%>
							<option class="vtip" title="<%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>" value="<%=FormFieldMainManager.getFieldid()%>"><%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>
							</option>
						<%}%>
						</select>
					</td>
					<td >&nbsp;</td>
				</tr>
			</table>    
			<%if (flags) {%>
			<table class="viewform" width="100%">
				<tr>
					<td>
						<button class=addbtn type=button accessKey=A onclick="addRowx('fromfieldoTable');" title="A-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18903,user.getLanguage())%>"></button>
					</td>
				</tr>
			</table>
			<%}%>	
			<table  class="viewform" id="fromfieldoTable"  width="100%">
				<colgroup>
					<col width="45%">
					<col width="10%">
					<col width="45%">
				</colgroup>
				<tbody>
				<%
				if (flags) { %>
				<tr class=header>
					<td align=center class=field><%=SystemEnv.getHtmlLabelName(15453,user.getLanguage())%></td>
					<td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
					<td align=left class=field>
						<%
						browmark="";
						sHtmlzzl="";
						RecordSet02.execute("select distinct groupId from workflow_formfield where formid='"+formid+"'  and isdetail='1'  and groupId>0 order by groupId");
						if(RecordSet02.next()){
							String tempgid=RecordSet02.getString("groupId");//得到最开始的一个
							RecordSet02.execute("select * from sap_multiBrowser where isbill='0' and mxformname='"+tempgid+"' and mxformid='"+formid+"'");
							if(RecordSet02.next()){
								browmark=RecordSet02.getString("browsermark");
							}
						}
						%>
						
						<div style="display:block;float:left;">
						<%=SystemEnv.getHtmlLabelName(30313,user.getLanguage())%>&nbsp;&nbsp;
						</div>
						<div style="display:block;float:left;width:120px;">
						<!--<brow:browser viewType="0" name="newsapmultiBrowservalue_1" browserValue='<%=browmark %>' 
						          browserSpanValue='<%=browmark %>' browserOnClick="OnsapMultiBrowser('this',1)" 
						          hasInput="true" isSingle="true" hasBrowser = "true"  
						          isMustInput='1' completeUrl="" 
						          needHidden="true" ></brow:browser>
						          -->
					 <input style="border:0px;cursor: pointer;" id='newsapmultiBrowser_1' class=e8_browflow onclick='OnsapMultiBrowser(this,1)' name='newsapmultiBrowser_1' type='button'>
					 <SPAN  id='newsapmultiBrowserinner_1'><%=browmark %></SPAN>
					 <INPUT id='newsapmultiBrowservalue_1'   name='newsapmultiBrowservalue_1'   type=hidden value="<%=browmark %>"/>
				
						</div>
						<div style="display:block;float:left;">
							&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18766,user.getLanguage())%>
						</div>
						<%--
						<%sHtmlzzl+=SystemEnv.getHtmlLabelName(30313,user.getLanguage())+"<button id='newsapmultiBrowser_1' class=browser onclick='OnsapMultiBrowser(this,1)' name='newsapmultiBrowser_1' type='button'></BUTTON>"+
						"<SPAN  id='newsapmultiBrowserinner_1'>"+browmark+"</SPAN>"+
						"<INPUT id='newsapmultiBrowservalue_1'   name='newsapmultiBrowservalue_1'   type=hidden value='"+browmark+"'/>";
						out.println(sHtmlzzl);
						%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<%=SystemEnv.getHtmlLabelName(18766,user.getLanguage())%> --%>
					</td>
					<td>&nbsp;</td>
				</tr>
				<%	
				int clos=0;	
				RecordSet.execute("select distinct groupId from workflow_formfield where formid="+formid+" and isdetail='1'  and groupId>0 order by groupId");
				//System.out.println("select distinct groupId from workflow_formfield where formid="+formid+" and isdetail='1'  and groupId>0 order by groupId");
				while (RecordSet.next())
				{
				%>
				<tr>
				    <td vaglin="middle">
				    <%   		
				   	if(clos>0){    			
						out.println("<div class='bgmulbro'></div>");
					}
				    %>
						<select class=inputstyle  size="15" name="srcListMul<%=clos%>" multiple style="width:100%;height:262px" onchange="showtitle(event)" ondblclick="addSrcToDestList3('srcListMul<%=clos%>','destListMul<%=clos%>')">
					    <%
					        FieldMainManager.resetParameter() ;
					        FieldMainManager.setUserid(user.getUID());
					        FieldMainManager.selectAllCodViewDetailField() ;
					    %>
						<%while(FieldMainManager.next()){%>
							<option class="vtip" title="<%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>" value="<%=FieldMainManager.getFieldManager().getFieldid() %>"><%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>
							</option>
						<%}%>
						</select>
					</td>
				    <td align=center>
				    <%
				   	if(clos>0){
						out.println("<div class='bgmulbro'></div>");
					}
				    %>    
					    <div style="text-align: center; height: 262px;">
						    <img class="upimg" src="/js/dragBox/img/up_wev8.png" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList3('destListMul<%=clos%>');">
							<br><br>
						    <img class="leftimg" src="/js/dragBox/img/5_wev8.png" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestList3('srcListMul<%=clos%>','destListMul<%=clos%>')">
							<br><br>
							<img class="rightimg" src="/js/dragBox/img/4_wev8.png"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:addSrcToDestList3('srcListMul<%=clos%>','destListMul<%=clos%>');">
							<br><br>
							<img class="downimg" src="/js/dragBox/img/down_wev8.png"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList3('destListMul<%=clos%>');">
						</div>
				    </td>
				    <td align=left>    
						<%
						if(clos>0){
							browmark="";
							sHtmlzzl="";
							String groupId=RecordSet.getString("groupId");
							RecordSet02.execute("select * from sap_multiBrowser where mxformname='"+groupId+"' and mxformid='"+formid+"'");
							if(RecordSet02.next()){
								browmark=RecordSet02.getString("browsermark");
							}
							//sHtmlzzl+=SystemEnv.getHtmlLabelName(30313,user.getLanguage())+"<button id='newsapmultiBrowser_"+sapclos+"' class=browser onclick='OnsapMultiBrowser(this,"+sapclos+")' name='newsapmultiBrowser_"+sapclos+"' type='button'></BUTTON>"+
							//"<SPAN  id='newsapmultiBrowserinner_"+sapclos+"'>"+browmark+"</SPAN>"+
							//"<INPUT id='newsapmultiBrowservalue_"+sapclos+"'   name='newsapmultiBrowservalue_"+sapclos+"'   type=hidden value='"+browmark+"'>";
							//out.println("<div class='bgmulbro'>"+sHtmlzzl+"</div>");
						
						 String browsername = "newsapmultiBrowservalue_"+sapclos;
						 String browserclick = "OnsapMultiBrowser('this',"+sapclos+")";
						%>
						
						<div style="display:block;float:left;">
						<%=SystemEnv.getHtmlLabelName(30313,user.getLanguage())%>&nbsp;&nbsp;
						</div>
						<div style="display:block;float:left;width:120px;">
						<!--<brow:browser viewType="0" name='<%=browsername %>' browserValue='<%=browmark %>' 
						          browserSpanValue='<%=browmark %>' browserOnClick='<%=browserclick %>' 
						          hasInput="true" isSingle="true" hasBrowser = "true"  
						          isMustInput='1' completeUrl="" 
						          needHidden="true" ></brow:browser>-->
					<input style="border:0px;cursor: pointer;" id='newsapmultiBrowser_<%=sapclos %>' class=e8_browflow onclick='OnsapMultiBrowser(this,<%=sapclos %>)' name='newsapmultiBrowser_<%=sapclos %>' type='button'>
					 <SPAN  id='newsapmultiBrowserinner_<%=sapclos %>'><%=browmark %></SPAN>
					 <INPUT id='newsapmultiBrowservalue_<%=sapclos %>'   name='newsapmultiBrowservalue_<%=sapclos %>'   type=hidden value="<%=browmark %>"/>
				
						</div>
						
						<%
						}
							sapclos++;
						%>
						<div style="display:block;float:left;">
						<select class=inputstyle  size=15 name="destListMul<%=clos%>" multiple style="width:100%;height:262px" onchange="showtitle(event)" ondblclick="deleteFromDestList3('srcListMul<%=clos%>','destListMul<%=clos%>')">
						<%
						FormFieldMainManager.setFormid(formid);
						FormFieldMainManager.setGroupId(RecordSet.getInt(1));
						FormFieldMainManager.selectDetailFormField();
						
						while(FormFieldMainManager.next()){
						%>
							<option class="vtip" title="<%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>" value="<%=FormFieldMainManager.getFieldid()%>"><%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>
							</option>
						<%}%>
						</select>
						</div>
				    </td>
				    <td >&nbsp;</td>
				</tr>
				<%
				clos++;
				}
				%>
				</tbody>
			</table>               
			<input type='hidden' id="nodesnum" name="nodesnum" value="0">
			<input type='hidden' id="indexnum" name="indexnum" value="0">
			<%}%>	
			<br/>		
    	</wea:item>
    </wea:group>
</wea:layout>
<input type='hidden' id="sapclos" name="sapclos" value="<%=sapclos%>">
</form>
<script type="text/javascript">
jQuery(document).ready(function(){
	initUDLR();
});

function initUDLR(){
	jQuery(".upimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/up-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/up_wev8.png");
	});
	
	jQuery(".leftimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/5_wev8.png");
	});
	
	jQuery(".rightimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/4-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/4_wev8.png");
	});
	
	jQuery(".downimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/down-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/down_wev8.png");
	});		
}
</script>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
jQuery(document).ready(function(){
	jQuery(".vtip").simpletooltip("click");
	if($.browser.msie){
		jQuery(".vtip").attr("title","");
	}
})
function submitData()
{
	if (checksubmit())
		tabfieldfrm.submit();
}

function submitClear(){
	//if (isdel())
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		deleteRow1();
	}, function () {}, 320, 90,true);
}


function addRowx(obj)
{ 
        var oTbody = fromfieldoTable.tBodies[0];
			
		var ncol = oTbody.rows[0].cells.length;
			
		var oRow = oTbody.insertRow(-1);
			
		var rowindex = oRow.rowIndex - 1;
		
	  
	     var sapclos=$("#sapclos").val();
	      $("#sapclos").attr("value",parseInt($("#sapclos").val())+1);
        <%
	         String sHtml1="";
	         String sHtml2="";
	         String sHtml3="";
	         String sHtml4="";
	         String sHtml5="";
	         String sHtml6="";
	        // sHtml1="<tr class=header>";
	        // sHtml1+="<td width=45% align=center class=field>"+SystemEnv.getHtmlLabelName(15453,user.getLanguage())+"</td>";
		    // sHtml1+="<td width=10% align=center class=field>"+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"</td>";
		    // sHtml1+="<td width=45% align=center class=field>"+SystemEnv.getHtmlLabelName(18766,user.getLanguage())+"</td>";
		    // sHtml1+="<td>&nbsp;</td></tr>";
	  
	         //sHtml1+="<tr><td vaglin=middle>";
		     sHtml1+="<select class=inputstyle  size=15 name='srcListMul"+"\"+rowindex+\"' multiple style='width:100%;height:262px' onchange=showtitle(event) ondblclick=addSrcToDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
	    
	        FieldMainManager.resetParameter() ;
	        FieldMainManager.setUserid(user.getUID());
	        FieldMainManager.selectAllCodViewDetailField() ;
	         while(FieldMainManager.next()){
	       	 String text = FieldMainManager.getFieldManager().getFieldname()+"["+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+FieldMainManager.getFieldManager().getFielddbtype()+"]";
	       	 if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){
	       		text+="["+SystemEnv.getHtmlLabelName(433,user.getLanguage())+":"+FieldMainManager.getFieldManager().getDescription()+"]";
	   	     }
		     sHtml1+="<option class='vtip' title='"+text+"' value='"+FieldMainManager.getFieldManager().getFieldid()+"'>"+text;
		     
	         sHtml1+="</option>";
		    }
		    sHtml1+="</select>";
		    //"</td>";
	    
	        //sHtml1+="<td align=center>
	        sHtml2+="<img class='upimg' src='/js/dragBox/img/up_wev8.png' title='"+SystemEnv.getHtmlLabelName(15084,user.getLanguage())+"' onclick=upFromDestList3('destListMul"+"\"+rowindex+\"')>";
		    sHtml2+="<br><br>";
	    	sHtml2+="<img class='leftimg' src='/js/dragBox/img/5_wev8.png' title='"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"' onClick=deleteFromDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
		    sHtml2+="<br><br>";
		    sHtml2+="<img class='rightimg' src='/js/dragBox/img/4_wev8.png'  title='"+SystemEnv.getHtmlLabelName(456,user.getLanguage())+"' onclick=addSrcToDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
		    sHtml2+="<br><br>";
		    sHtml2+="<img class='downimg' src='/js/dragBox/img/down_wev8.png'   title='"+SystemEnv.getHtmlLabelName(15085,user.getLanguage())+"' onclick=downFromDestList3('destListMul"+"\"+rowindex+\"')>";
	       //sHtml1+="</td>";
	
	     //sHtml1+="<td align=center>";
		   sHtml3+="<select class=inputstyle  size=15 name='destListMul"+"\"+rowindex+\"' multiple style='width:100%;height:262px' onchange=showtitle(event) ondblclick=deleteFromDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
	
		   FormFieldMainManager.setFormid(formid);
		   FormFieldMainManager.setGroupId(-1);
		   FormFieldMainManager.selectDetailFormField();
		
		   while(FormFieldMainManager.next()){
		  sHtml3+="<option value='"+FormFieldMainManager.getFieldid()+"'>"+DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid());
	      sHtml3+="["+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+FormFieldMainManager.getFieldDbType()+"]";
		  if (!FormFieldMainManager.getDescription().equals("")){
		  sHtml3+="["+SystemEnv.getHtmlLabelName(433,user.getLanguage())+":"+FormFieldMainManager.getDescription()+"]";
		  }
		  sHtml3+="</option>";
		}
		 sHtml3+="</select>";
        
    	//browmark="";
	 	//sHtmlzzl="";
	    sHtmlzzl+=SystemEnv.getHtmlLabelName(30313,user.getLanguage())+
	    "<input style='border:0px;cursor: pointer;' id='newsapmultiBrowser_"+"\"+sapclos+\"' class=e8_browflow onclick='OnsapMultiBrowser(this,"+"\"+sapclos+\")' name='newsapmultiBrowser_"+"\"+sapclos+\"' type='button'>"+
	    "<SPAN  id='newsapmultiBrowserinner_"+"\"+sapclos+\"'>"+browmark+"</SPAN>"+
	    "<INPUT id='newsapmultiBrowservalue_"+"\"+sapclos+\"'   name='newsapmultiBrowservalue_"+"\"+sapclos+\"'   type=hidden value='"+browmark+"'/>";

		////String browsername = "newsapmultiBrowservalue_"+"\"+sapclos+\"";
		//String browserclick = "OnsapMultiBrowser(this,\"+sapclos+\")";
	  	//String divid = "addclickbrowser\"+sapclos+\"";
		
	  	//sHtmlzzl+="<div style='display:block;float:left;'>" +
	  	//SystemEnv.getHtmlLabelName(30313,user.getLanguage())+"&nbsp;&nbsp;</div>" +
		//" <div id='"+divid+"' style='display:block;float:left;width:120px;'>" +
		//" </div> ";

        sHtml4=""+sHtml1;
        sHtml5=""+sHtml2;
        sHtml6=sHtml3;
        %>
		if(rowindex<=0){
					for(j=0; j<ncol; j++) {
				        oCell = oRow.insertCell(-1);
						oCell.style.height = 24;
						switch(j) {
						case 0:
						{ 
								var oDiv = document.createElement("div");
						        var sHtml = "<%=sHtml1%>" ;
						        //alert(sHtml);
						        oDiv.innerHTML = sHtml;
						        oCell.appendChild(oDiv);
						        break;}
								case 1:
								{
								var oDiv = document.createElement("div");
								oDiv.style.textAlign = "center";
						        var sHtml = "<%=sHtml2%>" ;
						        //alert(sHtml);
						        oDiv.innerHTML = sHtml;
						        oCell.appendChild(oDiv);
						        break;
								}
								case 2:
								{
								var oDiv = document.createElement("div");
						        var sHtml = "<%=sHtml3%>" ;
						        //alert(sHtml);
						        oDiv.innerHTML = sHtml;
						        oCell.appendChild(oDiv);
						        break;
								}
								case 3:
						}
						
				        }	
		}else{
		
				for(j=0; j<ncol; j++) {
				        oCell = oRow.insertCell(-1);
						oCell.style.height = 24;
						if(j==1){
							oCell.className="bgmulbro03";
						}
						switch(j) {
						case 0:
						{ 
								var oDiv = document.createElement("div");
								var oDiv01 = document.createElement("div");
						        var sHtml = "<%=sHtml4%>" ;
						        oDiv01.className="bgmulbro";
						        //alert(sHtml);
						        oDiv.innerHTML = sHtml;
						        oCell.appendChild(oDiv01);
						        oCell.appendChild(oDiv);
						        break;}
								case 1:
								{
								var oDiv01 = document.createElement("div");
								var oDiv = document.createElement("div");
								oDiv.style.textAlign = "center";
								$(oDiv).height("262px");
								//oDiv.style.backgroundColor="white";
								oDiv01.className="bgmulbro";
								
						        var sHtml = "<%=sHtml5%>" ;
						        //alert(sHtml);
						        oDiv.innerHTML = sHtml;
						        oDiv01.innerHTML="";
						         oCell.appendChild(oDiv01);
						        oCell.appendChild(oDiv);
						        break;
								}
								case 2:
								{
								var oDiv = document.createElement("div");
								var oDiv01 = document.createElement("div");
								 oDiv01.className="bgmulbro";
								//oDiv.className="bgmulbro02";
						        var sHtml = "<%=sHtml6%>" ;
						        //alert(sHtml);
						        oDiv.innerHTML = sHtml;
						        oDiv01.innerHTML="<%=sHtmlzzl%>";
						          oCell.appendChild(oDiv01);
						        oCell.appendChild(oDiv);
						        break;
								}
								case 3:
						}
						
				        }	
		
		}
       // rowindex = rowindex*1 +1;
       //curindex = curindex*1 +1;
        //document.all("nodesnum"+obj).value = curindex ;
        //document.all('indexnum'+obj).value = rowindex;
        jQuery(".vtip").simpletooltip("click");
        if($.browser.msie){
    		jQuery(".vtip").attr("title","");
    	}
 
      
    	
    	initUDLR();
    
}
</script>
<%}%>

<script language="javascript">
//sap多选浏览按钮的配置


function OnsapMultiBrowser(obj,detailtables){
	var updateTableName="";
	try{
		 updateTableName=$G("detailTable_name_"+detailtables).value;//得到明细表的名字
	 }catch(e){
	 	updateTableName="$_$";
	 }
	var browsertype="227";//多选的sap按钮都是227的标识
	//var mark=$G("newsapmultiBrowservalue_"+detailtables+"span").innerHTML;
	var showinner=$G("newsapmultiBrowserinner_"+detailtables);
	var showvalue=$G("newsapmultiBrowservalue_"+detailtables);
	var mark = showvalue.value;
	var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
	var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=0&updateTableName="+updateTableName;
    //var temp=window.showModalDialog(urls,"",tempstatus);
    var dialogaction = new window.top.Dialog();
	dialogaction.currentWindow = window;
	dialogaction.URL = urls;
	dialogaction.DefaultMax = true;
	dialogaction.Width = 600 ;
	dialogaction.Height = 500 ;
	dialogaction.callbackfun = function (paramobj, id1) {
		if(id1)
		{
			showvalue.value=id1;
			showinner.innerHTML=id1;
		}
	}
	dialogaction.maxiumnable = true;
	dialogaction.Title = "SAP";
	dialogaction.Drag = true;

	dialogaction.show();
	
}
</script>
</body>
</html>
