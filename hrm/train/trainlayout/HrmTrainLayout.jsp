<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
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
				url:"TrainLayoutOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainLayoutAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6128,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainLayoutEditDo&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6128,user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 523;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}


function doinfo(id){	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"/hrm/train/trainlayout/TrainLayoutOperation.jsp?isdialog=1&operation=info&id="+id,
			type:"post",
			async:true,
			complete:function(xhr,status){
				if(i==idArr.length-1){
					onBtnSearchClick();
				}
			}
		});
	});
}
  
function doassess(id){    
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(6102,user.getLanguage())%>";
	url = "/hrm/HrmDialogTab.jsp?_fromURL=TrainLayoutAssess&isdialog=1&id="+id;
	dialog.Width = 800;
	dialog.Height = 523;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
} 
  
function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=67 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=67")%>";
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
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6101,user.getLanguage());
String needfav ="1";
String needhelp ="";
String layoutname = Util.null2String(request.getParameter("layoutname"));
String typeid = Util.null2String(request.getParameter("typeid"));
String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<script type="text/javascript">

jQuery(document).ready(function(){
	parent.setTabObjName("<%=titlename%>");
});
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmTrainLayout:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="HrmTrainLayout.jsp" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" id="layoutname" name="layoutname" class="inputStyle"  value="<%=layoutname%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></wea:item>
			<wea:item>
	      <brow:browser viewType="0" name="typeid" browserValue='<%=typeid%>'
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/traintype/TrainTypeBrowser.jsp?selectedids="
	        hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
	        completeUrl="/data.jsp?type=HrmTrainType" width="120px" browserSpanValue='<%=TrainTypeComInfo.getTrainTypename(typeid)%>'>
	      </brow:browser>  
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
String backfields = " id,layoutname,typeid,layouttestdate,layoutassessor,(Select count(ID) as Count FROM HrmTrainPlan WHERE layoutid = t.id) as cnt "; 
String fromSql  = " from HrmTrainLayout t ";
String sqlWhere = " where 1=1 ";
String orderby = " id " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and layoutname like '%"+qname+"%'";
}		

if (!"".equals(layoutname)) {
	sqlWhere += " and layoutname like '%"+layoutname+"%'";
}  	  	

if(typeid.length()>0){
	sqlWhere += " and typeid = "+typeid;
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)+":+column:cnt+==0and"+HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmTrainLayout:log", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doassess();\" text=\""+SystemEnv.getHtmlLabelName(6102,user.getLanguage())+"\" index=\"1\"/>";
 	      operateString+="      <operate href=\"javascript:doinfo()\" text=\""+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"4\"/>";
 	       operateString+="</operates>";	
 String tabletype="none";
 if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_TrainLayout+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_TrainLayout,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:cnt+==0\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"layoutname\" orderkey=\"layoutname\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmOpenDialogName\" otherpara=\"column:id\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(6130,user.getLanguage())+"\" column=\"typeid\" orderkey=\"typeid\" transmethod=\"weaver.hrm.tools.TrainTypeComInfo.getTrainTypename\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15695,user.getLanguage())+"\" column=\"layoutassessor\" orderkey=\"layoutassessor\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMutiResourceLink\"/>"+
		"				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15696,user.getLanguage())+"\" column=\"layouttestdate\" orderkey=\"layouttestdate\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_TrainLayout %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY>
</HTML>
