
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
   String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String url =  "";
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	if(_fromURL.equals("")){
		_fromURL = "1";
	}
	String from = kv.get("from");
	boolean hasSecManageRight = false;
	if(_fromURL.equals("1")){//归档FTP列表
		url = "/integration/exp/ExpFtpDetail.jsp";
		//url = "/docs/category/DocSecCategoryCopyRightEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("2")){//归档本地列表
		url = "/integration/exp/ExpLocalDetail.jsp";
		//url = "/docs/category/DocSecCategoryMoveRightEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("3")){//归档数据库列表
		url = "/integration/exp/ExpDBDetail.jsp";
		//url = "/docs/category/DocSecCategoryDefaultRightEdit.jsp?id="+kv.get("id");
	}else if(_fromURL.equals("4")){//归档方案列表
		url = "/integration/exp/ExpProDetail.jsp";
		//url = "/integration/exp/archiveIntegrationList.jsp"+request.getQueryString();
	}else{//创建权限
		url = "";
	}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs7_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


<script type="text/javascript">
$(function(){
	    $('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
	    	needTopTitle:true,
	    	getLine:false,
	    	iframe:"contentframeRight"
	    });

});

function clickBtn(selector){
	jQuery(selector).click();
}
</script>

</head>
<BODY scroll="no">
	<div id="topTitleDiv">
		
	</div>
	<div class="e8_box">
	
			<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<%
			if(!"tab".equals(from)){
			%>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
				<ul class="tab_menu e8_tab_menu">
	        	 <li class="<%=(_fromURL.equals("1")|| _fromURL.equals(""))?"current":"" %>" >
		        	<a href="javascript:changeUrl('1')">
		        		<%=SystemEnv.getHtmlLabelName(83256,user.getLanguage()) %>
		        	</a>
		        </li>
	        	 <li class="<%=(_fromURL.equals("2"))?"current":"" %>">
		        	<a href="javascript:changeUrl('2')">
		        		<%=SystemEnv.getHtmlLabelName(83257,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li class="<%=(_fromURL.equals("3"))?"current":"" %>">
		        	<a href="javascript:changeUrl('3')">
		        		<%=SystemEnv.getHtmlLabelName(83259,user.getLanguage()) %>
		        	</a>
		        </li>
		         <li class="<%=(_fromURL.equals("4"))?"current":"" %>">
		        	<a href="javascript:changeUrl('4')">
		        		<%=SystemEnv.getHtmlLabelName(83260,user.getLanguage()) %>
		        	</a>
		        </li>
		       
		    </ul>
		    <div id="rightBox" class="e8_rightBox"></div>
	   
	       </div>
		</div>
	  		<%
			}
			%>
		
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="contentframeRight" name="contentframeRight" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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
<script type="text/javascript">
<%
if(_fromURL.equals("1")){//归档FTP列表
%>
getTopTitleContent('1');
<%
}
%>

function changeUrl(type){
	var url = "";
	if(type=="1"){//归档FTP列表
		url = "/integration/exp/ExpFtpDetail.jsp";
	}else if(type=="2"){//归档本地列表
		url = "/integration/exp/ExpLocalDetail.jsp";
	}else if(type=="3"){//归档数据库列表
		url = "/integration/exp/ExpDBDetail.jsp";
	}else if(type=="4"){//归档方案列表
		url = "/integration/exp/ExpProDetail.jsp";
	}
	getTopTitleContent(type);
	document.contentframeRight.location.href=url;
	
	//parent.update();
}

function getTopTitleContent(type){
	$.ajax({     
        type: 'post',     
        url: '/integration/exp/ExpSettingTopTitle.jsp',     
        data: {
			"_fromURL":type
		},
		dataType:'html',
        success: function(result){ 
			$("#topTitleDiv").html(result);
			parent.update();
        },     
        error: function(){     
            return;     
        }  
	});
}
function showCornerMenu(){
	jQuery("#innerCorner").trigger("click");
}
</script>	

</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

