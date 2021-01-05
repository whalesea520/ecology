
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String url = "/docs/category/DocSecCategoryCreateRightEdit.jsp?id="+kv.get("id");
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	int operationcode = MultiAclManager.OPERATION_CREATEDIR;
	MultiAclManager am = new MultiAclManager();
	boolean hasSecManageRight = false;
	if(_fromURL.equals("2")){//复制权限
		url = "/docs/category/DocSecCategoryCopyRightEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("3")){//移动权限
		url = "/docs/category/DocSecCategoryMoveRightEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("4")){//共享权限
		url = "/docs/category/DocSecCategoryDefaultRightEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("5")){//维护权限
		url = "/docs/category/DocSecCategoryDirRightEdit.jsp?id="+kv.get("id");
	}else{//创建权限
		url = "/docs/category/DocSecCategoryCreateRightEdit.jsp?id="+kv.get("id");
	}
	boolean canEdit = false;
	int parentId = Util.getIntValue(scc.getParentId(kv.get("id")));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, operationcode);
	}
	//hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), MultiAclManager.CATEGORYTYPE_SUB, user, MultiAclManager.OPERATION_CREATEDIR);
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight){
	    canEdit = true;
    }
	String from = kv.get("from");
	 int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(kv.get("id")+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight)
	         operatelevel=2;
 }

if(operatelevel>0){
	 canEdit = true;
	
}else{
	 canEdit = false;
	
}
	
	
%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<%if("tab".equals(from)){ %>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%}else{ %>
	<link type="text/css" href="/js/tabs/css/e8tabs7_wev8.css" rel="stylesheet" />
<%} %>
<script type="text/javascript">
$(function(){
	<%if("tab".equals(from)){ %>
		jQuery('.e8_box').Tabs({
	        getLine:1,
	        staticOnLoad:true,
	        iframe:"contentframeRight",
	        objName:"<%=scc.getSecCategoryname(kv.get("id"))%>",
	        mouldID:"<%= MouldIDConst.getID("doc")%>"
	    });
	<%}else{ %>
	    $('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
			staticOnLoad:true,
	    	needTopTitle:true,
	    	getLine:false,
	    	iframe:"contentframeRight"
	    });
    <%} %>
});


function clickBtn(selector){
	jQuery(selector).click();
}
</script>

<script type="text/javascript">
	var dialog = null;
	<%if("tab".equals(from)){%>
		dialog = parent.parent.getDialog(parent);
	<%}%>
</script>

</head>
<BODY scroll="no">
<%if("tab".equals(from)){ %>
<div class="zDialog_div_content">
<%} %>
	<form action="" name="searchfrm" id="searchfrm">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(_fromURL.equals("4") && canEdit){ %>
						<!--<input type=button class="e8_btn_top" onclick="clickBtn('#saveRight');" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>-->
					<%}else if(canEdit){ %>
						<input type=button id="agentNewRight" class="e8_btn_top" onclick="clickBtn('#newRight');" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
						<input type=button id="agentDelRight" class="e8_btn_top" onclick="clickBtn('#delRight');" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
					<%} %>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu" onclick="clickBtn('#cornerMenu');"></span>
				</td>
			</tr>
		</table>
	</form>
	<div class="e8_box">
		<%if("tab".equals(from)){ %>
			<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
				<ul class="tab_menu e8_tab_menu">
	        	 <li class="<%=(_fromURL.equals("5"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryDirRightEdit.jsp?from=tab&_fromURL=5&id=<%=kv.get("id") %>"  target="contentframeRight">
		        		<%=SystemEnv.getHtmlLabelName(81531,user.getLanguage()) %>
		        	</a>
		        </li>
	        	 <li class="<%=(_fromURL.equals("1")|| _fromURL.equals(""))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryCreateRightEdit.jsp?from=tab&_fromURL=1&id=<%=kv.get("id") %>" target="contentframeRight">
		        		<%=SystemEnv.getHtmlLabelName(21945,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li class="<%=(_fromURL.equals("2"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryCopyRightEdit.jsp?from=tab&_fromURL=2&id=<%=kv.get("id") %>" target="contentframeRight">
		        		<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
		        	</a>
		        </li>
		         <li class="<%=(_fromURL.equals("3"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryMoveRightEdit.jsp?from=tab&_fromURL=3&id=<%=kv.get("id") %>" target="contentframeRight">
		        		<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li class="<%=(_fromURL.equals("4"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryDefaultRightEdit.jsp?from=tab&_fromURL=4&id=<%=kv.get("id") %>" target="contentframeRight">
		        		<%=SystemEnv.getHtmlLabelName(15059,user.getLanguage()) %>
		        	</a>
		        </li>
		    </ul>
		    <div id="rightBox" class="e8_rightBox"></div>
		<%}else{ %>
		    <ul class="tab_menu e8_tab_menu">
	        	 <li class="<%=(_fromURL.equals("5"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=5&id=<%=kv.get("id") %>">
		        		<%=SystemEnv.getHtmlLabelName(81531,user.getLanguage()) %>
		        	</a>
		        </li>
	        	 <li class="<%=(_fromURL.equals("1")|| _fromURL.equals(""))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=1&id=<%=kv.get("id") %>">
		        		<%=SystemEnv.getHtmlLabelName(21945,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li class="<%=(_fromURL.equals("2"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=2&id=<%=kv.get("id") %>">
		        		<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
		        	</a>
		        </li>
		         <li class="<%=(_fromURL.equals("3"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=3&id=<%=kv.get("id") %>">
		        		<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li class="<%=(_fromURL.equals("4"))?"current":"" %>">
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=4&id=<%=kv.get("id") %>">
		        		<%=SystemEnv.getHtmlLabelName(15059,user.getLanguage()) %>
		        	</a>
		        </li>
		    </ul>
	    <div style="display:none;" id="rightBox" class="e8_rightBox">
	    </div>
	    <%} %>
	    <%if("tab".equals(from)){ %>
	    </div>
			</div>
		</div>
		<%} %>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="contentframeRight" name="contentframeRight" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
	<%if("tab".equals(from)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	</div>
	<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>	
	<%} %>     
</body>
</html>

