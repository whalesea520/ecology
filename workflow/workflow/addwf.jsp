<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<%
	String wfid = Util.null2String(request.getParameter("wfid"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String iscreat = Util.null2String(request.getParameter("iscreat"));
	String from = Util.null2String(request.getParameter("from"));
	
	//如果是自由流程，则直接跳转到自由流程设置界面
	String  freewfid="0";
	//获取自由流程id(系统中只有一个流程绑定该具体单据)
	String  freeWfSql="select  id  from workflow_base a  where  a.formid=285";
	RecordSet.executeSql(freeWfSql);
	if(RecordSet.next())
	{
	  freewfid=RecordSet.getString("id");
	}

   if(freewfid.equals(wfid)  &&  !freewfid.equals("0"))
	{
	   //跳转到自由节点设置界面
	   //request.getRequestDispatcher("addfreewf.jsp").forward(request,response);
	
	}


	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(wfid), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String versionclick = Util.getIntValue(Util.null2String(request.getParameter("versionclick")), 0)+ "";
	String isnodemode = Util.null2String(request.getParameter("isnodemode"));
	String fromWfEdit = Util.null2String(request.getParameter("fromWfEdit"));
	if (wfid.equals(""))
		wfid = "0";
	//是否为流程模板
	String isTemplate = Util.getIntValue(Util.null2String(request.getParameter("isTemplate")), 0)+ "";
	int typeid = Util.getIntValue(request.getParameter("typeid"), 0);
	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	//流程版本START by CC
	//流程版本控制类
	WorkflowVersion wfversion = new WorkflowVersion(wfid);
	//是否存在版本
	boolean hasVersion = false;
	//所有版本列表
	List wfversions = null;
	//当前流程最大版本号
	int lastVersionid = 0;
	//当前流程的活动版本
	String activeVersionId = "0";
	
	String tempVersionid = "0";
	//流程模板不存在版本
	if (!"1".equals(isTemplate)) {
		wfversions = wfversion.getAllVersionList();
		
		if (wfversions.size() > 1) {
			hasVersion = true;
		}
				
		lastVersionid = wfversion.getLastVersionID();
		//当前流程的活动流程
		activeVersionId = wfversion.getActiveVersionWFID();
	
		//流程版本END by CC
		Iterator it = wfversions.iterator();
		while (it.hasNext()) {
			Map versionkv = (Map)it.next();
			String tempWfid = (String)versionkv.get("id");
			tempVersionid = (String)versionkv.get("version");

			if (tempWfid.equals(wfid)) {
				break;
			}
	 	}
 	}
	WFManager.reset();
	WFManager.setWfid(Util.getIntValue(wfid));
	WFManager.getWfInfo();
	String navName = WFManager.getWfname();
	if("".equals(navName)){		//新建
		navName=SystemEnv.getHtmlLabelNames("611,18499",user.getLanguage());
	}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.getParentWindow(window);
		dialog = parent.getDialog(window);
	}catch(e){}
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 
jQuery(document).ready(function(){ setTabObjName("<%=Util.toScreenForJs(navName) %>"); });
</script>

<%
String url = "";
if(iscreat.equals("1")){
	url = "/workflow/workflow/addwfTab.jsp?versionclick="+versionclick+"&isnodemode="+isnodemode+"&wfid="+wfid+"&fromWfEdit="+fromWfEdit+"&isTemplate="+isTemplate+"&typeid="+typeid+"&iscreat="+iscreat;
}else{
	url = "/workflow/workflow/addwfTab.jsp?versionclick="+versionclick+"&isnodemode="+isnodemode+"&wfid="+wfid+"&fromWfEdit="+fromWfEdit+"&isTemplate="+isTemplate+"&typeid="+typeid;
}
if("prjwf".equalsIgnoreCase(from)){
	url+="&"+request.getQueryString();
}

%>

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
			<div>
		    <ul class="tab_menu">
		    	<%if(!isDialog.equals("1")){ %>
			        <li class="e8_tree">
			        	<a></a>
			        </li>
			     <%} %>			    
			        <%if(!isTemplate.equals("1") && wfversions.size()>1){ %>
			        <li>
			        	<a onclick="childShowVersion()" target="tabcontentframe">V<%=tempVersionid %></a>
			        </li>	
			        <% } %>
		        	 <li class="current">
			        	<a href="<%=url %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16484, user.getLanguage())%></a>
			        </li>
			        <%
			        	//当新建路径时，不显示下面的基本信息以外的tab
			        	if(wfid != null && !"".equals(wfid) && !"0".equals(wfid)){
					%>
					<li>
			        	<a onclick="childSelectTile('tableset')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(699, user.getLanguage())%></a>
			        </li>	
					<li>
			        	<a onclick="childSelectTile('flowset')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33488, user.getLanguage())%></a>
			        </li>	
			        <li>
			        	<a onclick="childSelectTile('hightset')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(19332, user.getLanguage())%></a>
			        </li>
					<%
				        }
			        %>
		    </ul>
		    </div>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	        	<%if(isDialog.equals("1")){ %>
					<div class="zDialog_div_content" style="overflow:hidden;">
				<%} %>
	            		<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	            <%if(isDialog.equals("1")){ %> 
				  </div>
				<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				    <wea:layout needImportDefaultJsAndCss="false">
						<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
							<wea:item type="toolbar">
						    	<input type="button" accessKey=2  id=btnclose value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancel" class="zd_btn_cancle" onclick="dialog.closeByHand()">
							</wea:item>
						</wea:group>
					</wea:layout>
					<script type="text/javascript">
						jQuery(document).ready(function(){
							resizeDialog(document);
						});
					</script>
				</div>
				<%} %>   
	        </div>
	    </div>
	</div> 
</body>
<script type="text/javascript">
function mnToggleleft(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='none';
			<%}%>
		}else{ 
			window.parent.oTd1.style.display='';
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='';
			<%}%>
		}
	}
	tabcontentframe.window.lavlinit();
}

function childSelectTile(tab){
	tabcontentframe.window.selectedTitle(tab);
	childShowVersion('false');
	jQuery('#newVersionButton').hide();
}

function childShowVersion(flag){
	tabcontentframe.window.showVersion(flag);
}
</script>
</html>