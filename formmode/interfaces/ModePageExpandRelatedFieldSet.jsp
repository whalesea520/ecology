<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int id = Util.getIntValue(request.getParameter("id"),0);
int pageexpandid = Util.getIntValue(request.getParameter("pageexpandid"),0);
String modeid=Util.null2String(request.getParameter("modeid"));
String hreftype=Util.null2String(request.getParameter("hreftype"));
String hrefid=Util.null2String(request.getParameter("hrefid"));

String modename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(30180,user.getLanguage());//设置关联字段
String modedesc = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(30180,user.getLanguage());//设置关联字段
String iframeurl = "/formmode/interfaces/ModePageExpandRelatedFieldSetIframe.jsp?id="+id+"&pageexpandid="+pageexpandid+"&modeid="+modeid+"&hreftype="+hreftype+"&hrefid="+hrefid;
%>
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
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        objName:"<%=modename%>"
    });
 }); 

function doBackCustomSearch(){
	window.location.href = "/formmode/search/CustomSearchBySimple.jsp?customid=";
}

</script>
	<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
	</style>
</HEAD>
<body>
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
				    <li class="current">
						<a href="<%=iframeurl%>" target="tabcontentframe">
						<%if(!"".equals(modedesc)){%>
							<%=modedesc %>
						<%}else{ %>
							<%=modename %>
						<%}%>
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
	            <iframe src="<%=iframeurl%>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doDel(){
        if(isdel()){
			enableAllmenu();
			$("#operation").val("del");
			document.frmSearch.submit();
        }
    }
    function doClose(){
    	var dialog = parent.parent.getDialog(parent);
    	if(dialog){
    		dialog.close();
    	}else{
			window.close();
			window.parent.close();
		}
	}
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
</script>

</BODY>
</HTML>
