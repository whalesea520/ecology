<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainResourceAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>	
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
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
				url:"/hrm/train/trainresource/TrainResourceOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainResourceAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelNames("532,6105",user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainResourcetEditDo&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelNames("532,6105",user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 353;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=68 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=68")%>";
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6105,user.getLanguage());
String needfav ="1";
String needhelp ="";

String qname = Util.null2String(request.getParameter("flowTitle"));
String name = Util.null2String(request.getParameter("name"));
String fare = Util.null2String(request.getParameter("fare"));
String time = Util.null2String(request.getParameter("time"));
String type = Util.null2String(request.getParameter("type"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainResourceAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainResourceDelete:Delete", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmTrainResource:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="searchfrm" id="searchfrm" action="HrmTrainResource.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmTrainResourceAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmTrainResourceDelete:Delete", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" id="name" name="name" class="inputStyle" value="<%=name%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" id="fare" name="fare" class="inputStyle" value="<%=fare%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("15879,15386",user.getLanguage())%></wea:item>
			<wea:item><input class="inputstyle" type="text" size="20" name="time" value='<%=time%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("15879,63",user.getLanguage())%></wea:item>
			<wea:item>
				<select class="InputStyle" id="type" name="type">
					<option value="" <%if (type.equals("")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></option>
					<option value="1" <%if (type.equals("1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(16165,user.getLanguage())%></option>
					<option value="0" <%if (type.equals("0")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(16166,user.getLanguage())%></option>
				</select>
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel" />
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
String backfields = " id, name, fare,time, type_n"; 
String fromSql  = " from HrmTrainResource ";
String sqlWhere = " where 1 = 1 ";
String orderby = " id " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and name like '%"+qname+"%'";
}
if(!name.equals("")){
	sqlWhere += " and name like '%"+name+"%'";
}		
if(!"".equals(fare)) {
	sqlWhere += "and fare like '%" + fare + "%' ";
}
if(!"".equals(time)) {
	sqlWhere += "and time like '%" + time + "%' ";
}
if(!"".equals(type)) {
	sqlWhere += "and type_n = '" + type + "' ";
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainResourceOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmTrainResourceEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmTrainResourceDelete:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmTrainResource:log", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmTrainResourceDelete:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_TrainResource+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_TrainResource,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainResourceCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmOpenDialogName\" otherpara=\"column:id\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(1491,user.getLanguage())+"\" column=\"fare\" orderkey=\"fare\" />"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15386,user.getLanguage())+"\" column=\"time\" orderkey=\"time\" />"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.hrm.HrmTransMethod.getTrainResourceTypeName\" otherpara=\""+user.getLanguage()+"\"  />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_TrainResource %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</BODY>
</HTML>
