<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="weaver.formmode.view.ResolveFormMode"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
Cookie cookie[]=request.getCookies();
String TreeSearchTabIndex = "";
if(cookie!=null){
  for(int i=0;i<cookie.length;i++){
     if(cookie[i].getName().equals("TreeSearchTabIndex")){
    	 TreeSearchTabIndex=cookie[i].getValue();
    	 break;
     }
   }
}
if(TreeSearchTabIndex.equals("")){
	TreeSearchTabIndex = "1";
}
String typeid = Util.null2String(request.getParameter("type"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
if("NULL".equals(selectedids)){
	selectedids = "";
}
String isview = Util.null2String(request.getParameter("isview"));
String expandfirstnode = Util.null2String(request.getParameter("expandfirstnode"));
String treerootnode = Util.null2String(request.getParameter("treerootnode"));
treerootnode = java.net.URLEncoder.encode(treerootnode,"utf-8");


//处理特殊值
String iframeurl = "/formmode/tree/treebrowser/CustomTreeBrowserIframe.jsp?type="+typeid+"&selectedids="+selectedids+"&treerootnode="+treerootnode+"&isview="+isview+"&expandfirstnode="+expandfirstnode;
String treename = "";
String isImportDetail = "";
String searchTabUrl = "";
if(!typeid.isEmpty()&&typeid.indexOf("_")!=-1){
	String[] arr = typeid.split("_");
	typeid = arr[0];
	String id = arr[0];
	String treeType = arr[1];
	String sql = "select * from mode_customtree where id = " + id;
	rs.executeSql(sql);
	if(rs.next()){
		treename = Util.null2String(rs.getString("treename"));
		String isshowsearchtab = Util.null2String(rs.getString("isshowsearchtab"));
		String searchbrowserid = Util.null2String(rs.getString("searchbrowserid"));
		if(isshowsearchtab.equals("1")){//开启显示组合查询
			sql = "select id from mode_customtreedetail where mainid="+id;
			rs.executeSql(sql);
			int count = rs.getCounts();
			String defaultUrl = "";
			if(treeType.equals("256")){
				defaultUrl = "/formmode/tree/treebrowser/TreeSingleBrowser.jsp?treeid="+id;
			}else{
				defaultUrl = "/formmode/tree/treebrowser/TreeMultiBrowser.jsp?treeid="+id+"&beanids="+selectedids;
			}
			
			if(count==0){//没有树节点--不显示组合查询
				searchTabUrl = "";
			}else if(count==1){//有一个树形节点
				if(searchbrowserid.equals("")||searchbrowserid.equals("0")){
					searchTabUrl = defaultUrl;//没有配置选择框 
				}else{//配置了选择框
					rs.next();
					String treenodeid = rs.getString("id");
					if(treeType.equals("256")){
						searchTabUrl = "/formmode/browser/CommonSingleBrowser.jsp?customid="+searchbrowserid+"&istree=1&treeid="+id+"&treenodeid="+treenodeid;
					}else{
						String ids = selectedids;
						if(!ids.equals("")){
							ids = ids.replace(treenodeid+"_","");
						}
						searchTabUrl = "/formmode/browser/CommonMultiBrowser.jsp?customid="+searchbrowserid+"&istree=1&treeid="+id+"&treenodeid="+treenodeid+"&beanids="+ids;
					}
				}
			}else{//有2个及其以上的树形节点
				searchTabUrl = defaultUrl;
			}
		}
		
	}
}

%>
<!DOCTYPE html>
<HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></SCRIPT>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        objName:"<%=treename%>"
    });
 }); 
	var dialog;
	var parentWin;
if(top!=parent){
	parentWin = window.parent.parent.getParentWindow(parent);
	dialog = window.parent.parent.getDialog(parent);
	if(!dialog){
		parentWin = window.parent.parent;
		dialog = window.parent.parent.getDialog(window);
	}
}

function changeTabCook(index){
	FormmodeUtil.writeCookie("TreeSearchTabIndex", index);
}
</script>

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
			    	<%
			    		boolean selectFirst = true;
			    		if(!searchTabUrl.equals("")&&TreeSearchTabIndex.equals("2")){//选中第二个
			    			selectFirst = false;
			    			response.addCookie(new Cookie("TreeSearchTabIndex","2"));
			    		}else{
			    			response.addCookie(new Cookie("TreeSearchTabIndex","1"));
			    		}
			    	%>
				    <li <%if(selectFirst){%>class="current"<%} %>>
						<a href="<%=iframeurl%>" target="tabcontentframe" onclick="changeTabCook(1)">
							<%=SystemEnv.getHtmlLabelName(32350,user.getLanguage())%>
						</a>
					</li>
					<%if(!searchTabUrl.equals("")){%>
					    <li <%if(!selectFirst){%>class="current"<%} %> >
							<a href="<%=searchTabUrl%>" target="tabcontentframe" onclick="changeTabCook(2)">
								<%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%>
							</a>
						</li>
					<%} %>
			    </ul>
	      <div id="rightBox" class="e8_rightBox">
	    </div>
	   </div>
	  </div>
	</div>	 
	    <div class="tab_box">
	        <div>
	        <%if(!selectFirst){
	        	iframeurl = searchTabUrl ; 
	        } %>
	            <iframe src="<%=iframeurl%>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

