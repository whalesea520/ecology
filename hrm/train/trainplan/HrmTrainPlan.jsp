<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
// 增加一个培训工作流的获取, 目前默认用培训单据创建的有效工作流为默认培训工作流,如果有多个, 选择第一个
String applyworkflowid = "" ;
String sql = "select id from workflow_base  where formid = 48 and isbill='1' and isvalid = '1' " ;
rs.executeSql(sql);
if( rs.next() ) applyworkflowid = Util.null2String(rs.getString("id")); 
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#weaver").submit();
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
				url:"/hrm/train/trainplan/TrainPlanOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						onBtnSearchClick();
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
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainPlanAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6156,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainPlanEditDo&id="+id;
		dialog.Width = 1000;
		dialog.Height = 613;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6156,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 513;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialogRange(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainPlanRange&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(6104,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 613;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}



function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=82 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=82")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function addRequest(id){
	openFullWindowForXtable("/workflow/request/AddRequest.jsp?workflowid=<%=applyworkflowid%>&TrainPlanId="+id);
}

function doinfo(id){	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"/hrm/train/trainplan/TrainPlanOperation.jsp?isdialog=1&operation=info&id="+id,
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
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage());
String needfav ="1";
String needhelp ="";

String qname = Util.null2String(request.getParameter("flowTitle"));
String planname = Util.null2String(request.getParameter("planname"));
String layoutid = Util.null2String(request.getParameter("layoutid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceTrainRecordAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//if(HrmUserVarify.checkUserRight("HrmTrainResourceDelete:Delete", user)){}
	


if(HrmUserVarify.checkUserRight("HrmTrain:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="HrmTrainPlan.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmResourceTrainRecordAdd:Add", user)){ %>
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
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
			<wea:item><input type="text" id="planname" name="planname" class="inputStyle" value='<%=planname%>'></wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></wea:item>
	    <wea:item>
		  <brow:browser viewType="0" name="layoutid" browserValue='<%=layoutid %>'
	       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp?selectedids="
	       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	       completeUrl="/data.jsp?type=HrmTrainLayout" browserSpanValue='<%=TrainLayoutComInfo.getLayoutname(layoutid) %>'>
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
String backfields = " id, planname, layoutid, planstartdate, planenddate, createdate ";
String fromSql  = " HrmTrainPlan ";
String sqlWhere = " where 1=1 ";
String orderby = " createdate " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and planname like '%"+qname+"%'";
}		

if(!layoutid.equals("")){
	sqlWhere += " and layoutid ="+layoutid;
}		

if(!planname.equals("")){
	sqlWhere += " and planname like '%"+planname+"%'";
}		
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainPlanOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmTrain:Log", user)+"\" otherpara2=\""+user.getUID()+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="     <operate href=\"javascript:openDialogRange()\" text=\""+SystemEnv.getHtmlLabelName(6104,user.getLanguage())+"\" index=\"2\"/>";
 	       operateString+="     <operate href=\"javascript:doinfo()\" text=\""+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+"\" index=\"3\"/>";
 	       operateString+="     <operate href=\"javascript:addRequest()\" text=\""+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"\" index=\"4\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"5\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_TrainPlan+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_TrainPlan,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainPlanCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+		
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
		    operateString+
    "			<head>"+
    "				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"planname\" orderkey=\"planname\"/>"+
    "				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(6128,user.getLanguage())+"\" column=\"layoutid\" orderkey=\"layoutid\" transmethod=\"weaver.hrm.train.TrainLayoutComInfo.getLayoutname\"/>"+
    "				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"planstartdate\" orderkey=\"planstartdate\"/>"+
    "				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"planenddate\" orderkey=\"planenddate\"/>"+
    "				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\"/>"+
    "			</head>"+
    " </table>";
%>
 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_TrainPlan %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</BODY>
</HTML>
