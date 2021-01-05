<%@page import="weaver.filter.XssUtil"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
XssUtil xssUtil = new XssUtil();

int filterlevel = Util.getIntValue(request.getParameter("level"),0);
String displayarchive=Util.null2String(request.getParameter("displayarchive"));//是否显示封存科目
String fromWfFnaBudgetChgApply=Util.null2String(request.getParameter("fromWfFnaBudgetChgApply")).trim();//=1：来自系统表单预算变更申请单
int orgType = Util.getIntValue(request.getParameter("orgType"),-1);
int orgId = Util.getIntValue(request.getParameter("orgId"),-1);
int orgType2 = Util.getIntValue(request.getParameter("orgType2"),-1);
int orgId2 = Util.getIntValue(request.getParameter("orgId2"),-1);
int fromFnaRequest = Util.getIntValue(request.getParameter("fromFnaRequest"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
int fieldid = Util.getIntValue(request.getParameter("fieldid"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);


String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

int tabId = Util.getIntValue(request.getParameter("tabId"), 0);

if(tabId <= 0){
	rs.executeSql("select bwTabId from FnaBudgetfeeTypeBwTab where userId = "+user.getUID());
	if(rs.next()){
		tabId = Util.getIntValue(rs.getString("bwTabId"), 1);
	}else{
		tabId = 2;
	}
}

String qryParamStr = "level="+filterlevel+"&displayarchive="+displayarchive+"&fromWfFnaBudgetChgApply="+fromWfFnaBudgetChgApply+
	"&orgType="+orgType+"&orgId="+orgId+"&orgType2="+orgType2+"&orgId2="+orgId2+"&fromFnaRequest="+fromFnaRequest+"&workflowid="+workflowid+"&fieldid="+fieldid+"&billid="+billid+
	"&sqlwhere="+xssUtil.put(sqlwhere);

String tabId1Class = "";
String tabId2Class = "";

String tabUrl1 = "/fna/maintenance/BudgetfeeTypeBrowserNewTree.jsp?"+qryParamStr+"&tabId=1";
String tabUrl2 = "/fna/maintenance/BudgetfeeTypeBrowserNewTree.jsp?"+qryParamStr+"&tabId=2";

String tabUrl = "";
if(tabId == 1){
	tabId1Class = "current";
	tabUrl = tabUrl1;
}else if(tabId == 2){
	tabId2Class = "current";
	tabUrl = tabUrl2;
}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
		    		<li class="<%=tabId1Class %>">
			        	<a id="tabId1" href="javascript:changeTab(1);">
			        		<%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><!-- 最近 --> 
			        	</a>
			        </li>
		    		<li class="<%=tabId2Class %>">
			        	<a id="tabId2" href="javascript:changeTab(2);">
			        		<%=SystemEnv.getHtmlLabelName(124987,user.getLanguage())%><!-- 按科目结构 --> 
			        	</a>
			        </li>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=tabUrl %>" onload="update();" id="tabcontentframe1" name="tabcontentframe1" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			    <wea:group context="">
			    	<wea:item type="toolbar">
						<input type="button" class="zd_btn_cancle" accessKey=2  id=btnclear onclick="onClear();" 
							value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
				        <input type="button" class="zd_btn_cancle" accessKey=T  id=btncancel onclick="btncancel_onclick();" 
				        	value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
			    	</wea:item>
			    </wea:group>
		</wea:layout>
	</div>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.parent.getParentWindow(parent);
	dialog = parent.parent.parent.getDialog(parent);
}catch(e){}

function onmouseout_td(_obj){
	jQuery(_obj).removeClass("e8_hover_tr");
}

function onmouseover_td(_obj){
	jQuery(_obj).addClass("e8_hover_tr");
}

function onSave1(id, name){
	var trunStr = {"id":id, "name":name,"flag":2};
	onSave2(trunStr);
}

function onSave2(trunStr) {
    if(trunStr && trunStr.id) {
    	if(trunStr.flag == "1"){
    		var returnjson = {"id":trunStr.id, "name":trunStr.parents+trunStr.name};	
    	}else{
    		var returnjson = {"id":trunStr.id, "name":trunStr.name};
    	}
		try{
			var _data = "opType=used&subjectId="+trunStr.id;
			jQuery.ajax({
				url : "/fna/maintenance/BudgetfeeTypeBrowserNewAjax.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "html",
				success: function do4Success(_html){
					if(dialog){
						try{
							dialog.callback(returnjson);
						}catch(e){}
						try{
							dialog.close(returnjson);
						}catch(e){}
					}else{
						window.parent.parent.returnValue = returnjson;
					  	window.parent.parent.close();
					}
				}
			});
		}catch(ex1){}
		
    }else{
		if(dialog){
			dialog.close();
		}else{
			window.parent.parent.close();
		}    
	}
}

function onClear() {
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
			dialog.close(returnjson);
		}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
	 	window.parent.parent.close();
	}
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  		window.parent.parent.close();
	}
}

function changeTab(tabId){
	changeQueryType(tabId);
}

function onCancel(){
	try{
		var dialog = parent.getDialog(window);	
		dialog.close();
	}catch(ex1){}
	doClose();
}

function doClose(){
	try{
		var parentWin = parent.parent.getParentWindow(window);
		parentWin.closeDialog();
	}catch(ex1){}
}

function changeQueryType(tabId){
	if(tabId==1){
		tabcontentframe1.location.href = "<%=tabUrl1 %>";
	}else if(tabId==2){
		tabcontentframe1.location.href = "<%=tabUrl2 %>";
	}
	try{
		var _data = "opType=tab&bwTabId="+tabId;
		jQuery.ajax({
			url : "/fna/maintenance/BudgetfeeTypeBrowserNewAjax.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(_html){
			}
		});
	}catch(ex1){}
}

jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"tabcontentframe1",
    mouldID:"<%=MouldIDConst.getID("fna") %>",
    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(27766, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>
</body>
</html>