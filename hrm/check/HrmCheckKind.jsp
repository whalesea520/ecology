
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
				url:"/hrm/check/HrmCheckOperation.jsp?isdialog=1&operation=DeleteCheckKindinfo&id="+idArr[i],
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
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCheckKindAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6118,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCheckKindEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6118,user.getLanguage())%>";
	}
	dialog.Width = 800;
	dialog.Height = 553;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=97 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=97")%>";
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
String titlename =SystemEnv.getHtmlLabelName(6118,user.getLanguage());
String needfav ="1";
String needhelp ="";

String kindname = Util.null2String(request.getParameter("kindname"));
String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String startdate =Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String startdateto =Util.fromScreen(request.getParameter("startdateto"),user.getLanguage());
if(!startdateselect.equals("") && !startdateselect.equals("0")&& !startdateselect.equals("6")){
	startdate = TimeUtil.getDateByOption(startdateselect,"0");//起始日期
	startdateto = TimeUtil.getDateByOption(startdateselect,"1");//结束日期
}
String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCheckKindAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmCheckKindAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(15755,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="kindname" name="kindname" class="inputStyle" value='<%=kindname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15758,user.getLanguage())%></wea:item>
			<wea:item>
      	<select name="startdateselect" id="startdateselect" onchange="changeDate(this,'spanStartdate');" style="width: 135px">
      		<option value="0" <%=startdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=startdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=startdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=startdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=startdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=startdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=startdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
				<span id=spanStartdate style="<%=startdateselect.equals("6")?"":"display:none;" %>">
					<BUTTON type="button" class=Calendar id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON>
					<SPAN id=startdatespan ><%=startdate%></SPAN>－
					<BUTTON type="button" class=Calendar id=selectstartdateTo onclick="getDate(startdatetospan,startdateto)"></BUTTON>
					<SPAN id=startdatetospan ><%=startdateto%></SPAN>
				</span>
				<input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>">
				<input class=inputstyle type="hidden" id="startdateto" name="startdateto" value="<%=startdateto%>">
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
String backfields = " id, kindname, checkcycle, checkexpecd, checkstartdate,(case when (SELECT COUNT(id) From HrmCheckList WHERE checktypeid = a.id ) > 0 then 1 else 0 end ) count "; 
String fromSql  = " from HrmCheckKind a ";
String sqlWhere = " where 1 = 1 ";
String orderby = " id " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and kindname like '%"+qname+"%'";
}		

if (!"".equals(kindname)) {  
	sqlWhere += " and kindname like '%"+kindname+"%'"; 	  	
}
  	
if(!startdate.equals("")) {//起始日期不为空

 sqlWhere +=" and checkstartdate >='"+startdate+"'";

}

if(!startdateto.equals("")){//结束日期不为空
 sqlWhere +=" and checkstartdate<='"+startdateto+"'";
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmCheckKindAdd:Add", user)+":+column:count+==0and"+HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)+" \"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_CheckKind+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_CheckKind,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:count+==0\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15755,user.getLanguage())+"\" column=\"kindname\" orderkey=\"kindname\" />"+
    "				<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15756,user.getLanguage())+"\" column=\"checkcycle\" orderkey=\"checkcycle\" transmethod=\"weaver.hrm.HrmTransMethod.getCheckCycleName\" otherpara=\""+user.getLanguage()+"\"/>"+
    "				<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15757,user.getLanguage())+"\" column=\"checkexpecd\" orderkey=\"checkexpecd\" />"+
    "				<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15758,user.getLanguage())+"\" column=\"checkstartdate\" orderkey=\"checkstartdate\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_CheckKind %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
