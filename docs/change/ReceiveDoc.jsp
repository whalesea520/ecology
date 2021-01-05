
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReceiveUnitUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<SCRIPT language="javascript" src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:doRefresh});
		jQuery("#hoverBtnSpan").hoverBtn();
	});
</script>
<%
if(!HrmUserVarify.checkUserRight("DocChange:Receive", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23083,user.getLanguage());
String needfav ="1";
String needhelp ="";

String status = Util.null2String(request.getParameter("status"));
if(status.equals("")) status = "0";
//解决创建流程后,再修改"当前状态",选择其他状态无效,始终回到"已签收"状态
String status_session = Util.null2String((String) session.getAttribute("createworkflow_status" + user.getUID()));
session.removeAttribute("createworkflow_status" + user.getUID());
if(!"".equals(status_session)) status = status_session;
String title = Util.null2String(request.getParameter("title"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18526,user.getLanguage())+",javascript:doReceive(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(status.equals("0")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(20569,user.getLanguage())+",javascript:doAction(null,1,this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(23048,user.getLanguage())+",javascript:doAction(null,2,this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doAction(null,3,this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(status.equals("1")) {//创建流程按钮
RCMenu += "{"+SystemEnv.getHtmlLabelName(23087,user.getLanguage())+",javascript:doAction(null,4,this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<LINK href="../css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())%>" class="e8_btn_top" onclick="doReceive(this);"/>
			<%if(status.equals("0")) { %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(20569,user.getLanguage())%>" class="e8_btn_top" onclick="doAction(null,1);"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(23048,user.getLanguage())%>" class="e8_btn_top" onclick="doAction(null,2);"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" class="e8_btn_top" onclick="doAction(null,3);"/>
			<%}else if(status.equals("1")){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(23087,user.getLanguage())%>" class="e8_btn_top" onclick="doAction(null,4);"/>
			<%} %>
			<input type="text" class="searchInput" id="flowTitle" name="flowTitle" onchange="setKeyword('flowTitle','title','frmmain');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<FORM name="frmmain" action="/docs/change/ReceiveDocOpterator.jsp" method="post">
<input type="hidden" name="src" value="receive" />
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'> 
    <wea:item><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></wea:item>
    <wea:item>
	<select id="status" name="status" onChange="doRefresh(this)">
	<option value="0" <%if(status.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23079,user.getLanguage())%></option>
	<option value="1" <%if(status.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23078,user.getLanguage())%></option>
	<option value="2" <%if(status.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(33566,user.getLanguage())%></option>
	<option value="3" <%if(status.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(33567,user.getLanguage())%></option>
	</select>
	</wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></wea:item>
    <wea:item>
	    <span class="wuiDateSpan" selectId="doccreatedateselect">
	       <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
	       <input class=wuiDateSel  type="hidden" name="enddate" value="<%=enddate%>">
	   </span>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(23038,user.getLanguage())%></wea:item>
    <wea:item><INPUT class="InputStyle" name=title value='<%=title%>'></wea:item>
</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" onclick="doRefresh(this)" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
<input name=start id="start" type=hidden value="<%=start%>">
<input name=ids id="ids" type=hidden value="">
<input name=companyid id="companyid" type=hidden value="">
<input name=chageFlag id="chageFlag" type=hidden value="">
<input name=newversionid id="newversionid" type=hidden value="">
<input name=sn id=sn type=hidden value="">
<div style="display:none">
	<brow:browser name="fieldConfigWfid" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="name"
	browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/docs/change/WfBrowser.jsp" isMustInput="1" isSingle="true" hasInput="false"
	temptitle='<%= SystemEnv.getHtmlLabelName(2118,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
	completeUrl="/data.jsp?type=categoryBrowser" _callback="doFieldConfig" width="300px" browserValue="" browserSpanValue="" />
	
	<brow:browser name="createWfid" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="name"
	browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/docs/change/WfBrowser.jsp" isMustInput="1" isSingle="true" hasInput="false"
	temptitle='<%= SystemEnv.getHtmlLabelName(2118,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
	completeUrl="/data.jsp?type=categoryBrowser" _callback="doCreate" width="300px" browserValue="" browserSpanValue="" />
</div>
</form>
</div>
<%
String statusText = "23079";
if(status.equals("0")) statusText = "23079";
if(status.equals("1")) statusText = "23078";
if(status.equals("2")) statusText = "33566";
if(status.equals("3")) statusText = "33567";

String sqlwhere = " type='1' AND status = '"+status+"' ";
//取未发送的
if(!fromdate.equals("")) sqlwhere += " and receivedate>='"+fromdate+"' ";
if(!enddate.equals("")) sqlwhere += " and receivedate<='"+enddate+"' ";
if(!title.equals("")) sqlwhere += " and title like '%"+title+"%'";

int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
String tableString = "";
String backfields = " id,title,sn,companyid,chageFlag,flagTitle,version,executedate,executetime,receivedate,receivetime,status ";
String fromSql  = " DocChangeReceive ";
//out.print("select "+backfields + "from "+fromSql+" where "+sqlwhere);
//处理交换字段
String fdStr = "";
String sql = "select distinct t2.id,t1.version from DocChangeFieldConfig t1,"
	+ "(select "+backfields + "from "+fromSql+" where "+sqlwhere+") t2 "
	+ " where t1.companyid=t2.companyid and t1.chageflag=t2.chageflag and t1.version=t2.version ";
RecordSet.executeSql(sql);
//out.println(sql);
while(RecordSet.next()) {
	fdStr += ","+RecordSet.getString("version")+"|"+RecordSet.getString("id");
}
fdStr += ",";
//out.println(fdStr);
String  operateString= "";
if(status.equals("0")) {
	operateString = "<operates width=\"20%\">";
	operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
	operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:doAction();\" otherpara=\"1\" text=\""+SystemEnv.getHtmlLabelName(20569,user.getLanguage())+"\" index=\"0\"/>";
	operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:doAction();\" otherpara=\"2\" text=\""+SystemEnv.getHtmlLabelName(23048,user.getLanguage())+"\" index=\"1\"/>";
	operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:doAction();\" otherpara=\"3\" text=\""+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"\" index=\"2\"/>";
	operateString+="</operates>";
}else if(status.equals("1")){
	operateString = "<operates width=\"20%\">";
	operateString+=" <popedom transmethod=\"weaver.docs.change.DocChangeManager.getPopedom\" otherpara=\"column:sn+column:version\"></popedom> ";
	operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:doAction();\" otherpara=\"4\" text=\""+SystemEnv.getHtmlLabelName(23087,user.getLanguage())+"\" index=\"0\"/>";
	operateString+="     <operate  href=\"javascript:doConfig();\" otherpara=\"column:chageFlag+column:version+column:companyid+"+user.getLanguage()+"+column:sn\" text=\""+SystemEnv.getHtmlLabelName(724,user.getLanguage())+"\" index=\"1\"/>";
	operateString+="     <operate  href=\"javascript:doConfigView();\" otherpara=\"column:chageFlag+column:version+column:companyid+"+user.getLanguage()+"+column:sn+column:workflowid\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"2\"/>";
	operateString+="</operates>";
}	 
tableString =   " <table instanceid=\"receiveDocListTable\" tabletype=\"checkbox\" pageId=\""+PageIdConst.OWF_RECEIVEDOC+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.OWF_RECEIVEDOC,user.getUID(),PageIdConst.DOC)+"\" >";
if(status.equals("1")) {
	tableString =   " <table instanceid=\"receiveDocListTable\" tabletype=\"radio\" pagesize=\""+perpage+"\" >";
	tableString += " <checkboxpopedom popedompara=\"column:id+"+"|"+"column:version+"+fdStr+"\" showmethod=\"weaver.docs.change.DocReceiveManager.showMethod\" />";
}
tableString +=  "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"receivedate,receivetime,chageFlag,version,companyid\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
				operateString+
                "       <head>"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18002,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(18321,user.getLanguage())+"\" column=\"companyid\" orderkey=\"companyid\" transmethod=\"weaver.docs.senddoc.DocReceiveUnitComInfo.getReceiveUnitName\" />";
if(status.equals("1")) {
	tableString +=  "       <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23775,user.getLanguage())+"\" column=\"flagTitle\" orderkey=\"flagTitle\" />"+
				"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22186,user.getLanguage())+"\" column=\"version\" />";
}                
tableString +=  "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(23038,user.getLanguage())+"\" column=\"title\" orderkey=\"title\" href=\"ReceiveDocShow.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"id\" otherpara=\""+statusText+","+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getFieldname\" />";
if(status.equals("1")) {
	//tableString +=  "           <col width=\"80\"  text=\""+SystemEnv.getHtmlLabelName(724,user.getLanguage())+"\" column=\"chageFlag\" otherpara=\"column:version+column:companyid+"+user.getLanguage()+"+column:sn\" transmethod=\"weaver.docs.change.DocReceiveManager.showConfigStr\" />";
}
tableString +=  "       </head>"+
                " </table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.OWF_RECEIVEDOC %>"/>
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>

<script>

jQuery(document).ready(function(){
	try{
		var status = jQuery("#status").val();
		jQuery("li",parent.document).removeClass("current");
		if(status=="0"){
			jQuery("li a#unSendTab",parent.document).parent().addClass("current");
		}else if(status=="1"){
			jQuery("li a#sentTab",parent.document).parent().addClass("current");
		}else if(status=="2"){
			jQuery("li a#rejectTab",parent.document).parent().addClass("current");
		}else if(status=="3"){
			jQuery("li a#returnTab",parent.document).parent().addClass("current");
		}else{
			jQuery("li a#unSendTab",parent.document).parent().addClass("current");
		}
	}catch(e){
		jQuery("li",parent.document).removeClass("current");
		jQuery("li a#unSendTab",parent.document).parent().addClass("current");
	}
	parent.registerClickEventForReceiveDoc(null,document,window);
});

function doReceive(mobj) {
	document.frmmain.src.value = 'receive';
	document.frmmain.submit();
	mobj.disabled = true;
}
//刷新动作
function doRefresh(obj) {
	document.frmmain.action = 'ReceiveDoc.jsp';
	document.frmmain.submit();
	if(obj)
		obj.disabled = true;
}

//动作
function doAction(id,type,mobj) {
	if(type=='1') type = 'signin';//签收
	if(type=='2') type = 'reject';//拒收
	if(type=='3') type = 'back';//退回
	if(type=='4') {
		type = 'createworkflow';//创建流程
		if(!id)id = _xtable_CheckedRadioId();
		if(!id) top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
		else {
			//onShowWorkFlowSerach('createWfid','createWfidSpan');
			//回调函数    
			function callBackFun(data) {
				if(data=="_"){
					document.getElementById("sn").value = "-1";
					//onShowWorkFlowSerach('createWfid','createWfidSpan');
					jQuery("#outcreateWfiddiv").next("div.e8_innerShow_button").find("button").click();
				}else{
					document.getElementById("sn").value = data.split("_")[1];
					document.getElementById("createWfid").value = data.split("_")[0];
					doCreate();
				}
				jQuery("#ids").val(id);
			}
			document.frmmain.ids.value = id;
			DocReceiveUnitUtil.whetherCanCreateRequest(id, callBackFun);
			return;
		}
	}
	else {
		if(!id){
			id = _xtable_CheckedCheckboxId();
		}
		if(!id) top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
		else {
			if(type!='signin') {
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=74&isdialog=1&ids="+id+"&src="+type;
				if(type=="reject"){
					dialog.Title = "<%=SystemEnv.getHtmlLabelNames("23048,33424",user.getLanguage())%>";
				}else if(type=="back"){
					dialog.Title = "<%=SystemEnv.getHtmlLabelNames("236,33424",user.getLanguage())%>";
				}
				dialog.Width = 600;
				dialog.Height = 300;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
			}else{
				document.frmmain.src.value = type;
				document.frmmain.ids.value = id;
				document.frmmain.submit();
				mobj.disabled = true;
			}
		}
	}
}
//创建流程
function doCreate(e,datas,name,params) {
	var obj = document.frmmain.createWfid;
	if(obj.value=='') return;
	else {
		document.frmmain.src.value = 'createworkflow';
		//document.frmmain.ids.value = _xtable_CheckedRadioId();
		document.frmmain.submit();
		//mobj.disabled = true;
		enableAllmenu();
	}
}
//点击配置按钮事件
function doConfig(id,params,obj,isedit ) {
	var paramsArr = params.split(/\+/);
	var chageFlag = paramsArr[0];
	var version = paramsArr[1];
	var companyid = paramsArr[2];
	var sn = paramsArr[4];
	document.frmmain.chageFlag.value = chageFlag;
	document.frmmain.companyid.value = companyid;
	document.frmmain.newversionid.value = version;
	document.frmmain.sn.value = sn;
	//onShowWorkFlowSerach('fieldConfigWfid','fieldConfigWfidSpan');
	//jQuery("#outfieldConfigWfiddiv").next("div.e8_innerShow_button").find("button").click();
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=73&isdialog=1&chageFlag="+chageFlag+"&newversionid="+version+"&companyid="+companyid+"&sn="+sn;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("724,33569",user.getLanguage())%>";
	if(isedit==1){
		url=url+"&isedit=1";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,33569,724",user.getLanguage())%>";
	}else{
		url=url+"&wfid=0";
	}
	dialog.Width = 600;
	dialog.Height = 500;
	dialog.maxiumnable = true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
//配置流程字段
function doFieldConfig(e,datas,name,params) {
	//var obj = document.frmmain.fieldConfigWfid;
	//if(obj.value=='') return;
	//else {
		//document.frmmain.action='WorkflowFieldConfig.jsp?wfid='+obj.value;
		//document.frmmain.submit();
		//mobj.disabled = true;
		//enableAllmenu();
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=73&isdialog=1&wfid="+datas.id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("724,33569",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 500;
		dialog.maxiumnable = true;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	//}
}
function doConfigView(id,params,obj) {
	/*var paramsArr = params.split(/\+/);
	var chageFlag = paramsArr[0];
	var version = paramsArr[1];
	var companyid = paramsArr[2];
	var sn = paramsArr[3];
	document.frmmain.sn.value = sn;
	document.frmmain.action='WorkflowFieldConfig.jsp?chageFlag='+chageFlag+'&companyid='+companyid+'&sn='+sn+"&version="+version;
	document.frmmain.submit();*/
	//alert(chageFlag+'--'+version+'--'+companyid);
	doConfig(null,params,obj,1);
}

</script>
