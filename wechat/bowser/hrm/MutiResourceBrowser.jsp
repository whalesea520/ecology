
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int tabId = Util.getIntValue(request.getParameter("tabId"), 1);
String resourceids=Util.null2String(request.getParameter("resourceids"));
String publicid=Util.null2String(request.getParameter("publicid"));
//页面传过来的自定义组id

int uid=user.getUID();
    String resourcemulti = null;
    Cookie[] cks = request.getCookies();
    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("resourcemulti" + uid)) {
            resourcemulti = cks[i].getValue();
            break;
        }
    }

if(resourcemulti!=null&&resourcemulti.length()>0){
	String[] atts=Util.TokenizerString2(resourcemulti,"|");
	tabId=Util.getIntValue(atts[0])+1;
}

if(tabId==0) tabId=1;
String searchUrl = "";
String ysxxUrl = "/wechat/bowser/hrm/MultiSelect.jsp";
if(tabId==1){
	searchUrl = "/wechat/bowser/hrm/SearchByOrgan.jsp";
}else if(tabId==2){
	searchUrl = "/wechat/bowser/hrm/SearchByGroup.jsp";
}else if(tabId==3){
	searchUrl = "/wechat/bowser/hrm/Search.jsp";
}

%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>


</HEAD>
<body scroll="no">

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
		    		<li class="<%=tabId==1?"current":"" %>">
			        	<a id="tabId1" href="javascript:changeTab(1);">
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
			      <li class="<%=tabId==2?"current":"" %>">
			        	<a id="tabId2" href="javascript:changeTab(2);">
			        		<%=SystemEnv.getHtmlLabelName(18771,user.getLanguage())%><!-- 按定义的组 --> 
			        	</a>
			      </li>
		    		<li class="<%=tabId==3?"current":"" %>">
			        	<a id="tabId3" href="javascript:changeTab(3);">
			        		<%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%><!-- 组合查询 --> 
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
        		<IFRAME name=frame1 id=frame1 src="<%=searchUrl %>" width="100%" height="180px" frameborder=no scrolling=yes>
						浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
            <iframe src="<%=ysxxUrl+"?tabId="+tabId+"&selectids="+resourceids+"&publicid="+publicid %>" onload="update();" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
	    </div>
	</div>

<script type="text/javascript">
function changeTab(tabId){
	if(tabId==1){
		document.getElementById("frame1").src = "/wechat/bowser/hrm/SearchByOrgan.jsp";
	}else if(tabId==2){
		document.getElementById("frame1").src = "/wechat/bowser/hrm/SearchByGroup.jsp";
	}else if(tabId==3){
		document.getElementById("frame1").src = "/wechat/bowser/hrm/Search.jsp";
	}
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

jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame2",
	contentID:"#frame1",
  mouldID:"<%=MouldIDConst.getID("communicate") %>",
  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33210, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>

</body>
</html>