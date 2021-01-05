
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<style type="text/css">
	.e8_resource{
		cursor:pointer;
		color:rgb(13,147,246);
	}
	
	.weatable_e8_operatetype{
		border:none;
		vertical-align:baseline;
		top:3px;
		
	}
</style>

<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "";
	String navName = "";
	String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
	if(subcompanyId.equals("")){
		subcompanyId = Util.null2String(session.getAttribute("docdftsubcomid"));
	}
	String mouldID = "doc";
	if(_fromURL.equals("1")){//著者文档数量
		url = "/docs/report/DocRpCreater.jsp";
		navName = SystemEnv.getHtmlLabelName(16600,user.getLanguage());
	}else if(_fromURL.equals("2")){//部门文档数量
		url = "/docs/report/DocRpRelative.jsp";
		navName = SystemEnv.getHtmlLabelName(16601,user.getLanguage());
	}else if(_fromURL.equals("3")){//分部文档数量
		url = "/docs/report/DocRpOrganizationSum.jsp";
		navName = SystemEnv.getHtmlLabelName(33280,user.getLanguage());
	}else if(_fromURL.equals("4")){//文档目录报表
		url = "/docs/report/DocRpMainCategorySum.jsp";
		navName = SystemEnv.getHtmlLabelName(16605,user.getLanguage());
	}else if(_fromURL.equals("5")){//最多文档客户
		url = "/docs/report/DocRpSum.jsp?optional=crm";
		navName = SystemEnv.getHtmlLabelName(16609,user.getLanguage());
	}else if(_fromURL.equals("6")){//最多文档项目
		url = "/docs/report/DocRpSum.jsp?optional=project";
		navName = SystemEnv.getHtmlLabelName(16611,user.getLanguage());
	}else if(_fromURL.equals("7")){//最多关联人员
		url = "/docs/report/DocRpSum.jsp?optional=hrm";
		navName = SystemEnv.getHtmlLabelName(16610,user.getLanguage());
	}else if(_fromURL.equals("8")){//阅读日志统计
		url = "/docs/report/DocRpReadStatistic.jsp";
		navName = SystemEnv.getHtmlLabelName(19582,user.getLanguage());
	}else if(_fromURL.equals("9")){//最多文档语言
		url = "/docs/report/DocRpSum.jsp?optional=language";
		navName = SystemEnv.getHtmlLabelName(16608,user.getLanguage());
	}else if(_fromURL.equals("10")){//文档下载日志
		url = "/docs/docs/DocDownloadLog.jsp";
		navName = SystemEnv.getHtmlLabelName(17515,user.getLanguage());
	}else if(_fromURL.equals("11")){//文档阅读日志
		url = "/report/RpReadView.jsp?object=1&hasTab=1";
		navName = SystemEnv.getHtmlLabelName(33773,user.getLanguage());
	}else if(_fromURL.equals("12")){//文档修改日志
		url = "/report/RpModifyDoc.jsp?object=1&hasTab=1";
		navName = SystemEnv.getHtmlLabelName(33774,user.getLanguage());
	}else if(_fromURL.equals("13")){//日志首页
		int operatetype = Util.getIntValue(kv.get("operatesmalltype"),0);
		navName = "<span  class='e8_resource'><u><span id='e8_resource'>"+user.getLastname()+"</span></u></span>";
		navName += SystemEnv.getHtmlLabelName(33800,user.getLanguage());
		url = "/report/Statistics.jsp?"+request.getQueryString();
		if(operatetype!=1){
			navName += "<span  class='e8_resource'><select style='width:110px;' id='e8_operatetype' name='e8_operatetype'>"
				+"<option value=0 selected>"+SystemEnv.getHtmlLabelName(33801,user.getLanguage())+"</option>"
				+"<option value=1>"+SystemEnv.getHtmlLabelName(33802,user.getLanguage())+"</option>"
				+"</select></span>";
		}else{
			navName += "<span  class='e8_resource'><select style='width:110px;' id='e8_operatetype' name='e8_operatetype'>"
				+"<option value=0>"+SystemEnv.getHtmlLabelName(33801,user.getLanguage())+"</option>"
				+"<option value=1 selected>"+SystemEnv.getHtmlLabelName(33802,user.getLanguage())+"</option>"
				+"</select></span>";
		}
		mouldID = "setting";
	}
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID(mouldID)%>",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
 	getIframeDocument();
 	beautySelect();
 }); 
 
 function getIframeDocument(){
 	var _contentDocument = getIframeDocument2();
    var _contentWindow = getIframeContentWindow();
    if(!!_contentDocument){
    	jQuery("#docAll").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
    			var currentuser = jQuery("#currentuser",_contentDocument).val();
				_contentWindow.resetCondtion();
				jQuery("#currentuser",_contentDocument).val(currentuser);
				jQuery("#report",_contentDocument).submit();
			});
			
			jQuery("#docToday").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("1");
				jQuery("#report",_contentDocument).submit();
			});
			
			jQuery("#docWeek").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("2");
				jQuery("#report",_contentDocument).submit();
				return false;
			});
			
			jQuery("#docMonth").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("3");
				jQuery("#report",_contentDocument).submit();
			});
			
			jQuery("#docQuarterly").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("4");
				jQuery("#report",_contentDocument).submit();
			});
			
			jQuery("#docYear").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("5");
				jQuery("#report",_contentDocument).submit();
			});
			openResource(_contentDocument);
			switchOperateType(_contentDocument);
			
    }else{
    	window.setTimeout(function(){
   			getIframeDocument();
   		},500);
    }
 }
 
 function openResource(_contentDocument){
 	jQuery("#e8_resource").unbind("click").bind("click",function(){
		jQuery("button.e8_browflow",_contentDocument).trigger("click");
	});
 }
 
 function switchOperateType(_document){
 	jQuery("#e8_operatetype").unbind("change").bind("change",function(){
		//jQuery("button.e8_browflow",_contentDocument).trigger("click");
		jQuery("#operatesmalltype",_document).val(jQuery(this).val());
		jQuery("#report",_document).submit();
	});
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
		    	<%if(_fromURL.equals("10")||_fromURL.equals("11")||_fromURL.equals("12")||_fromURL.equals("13")){ %>
		    		<li>
			        	<a  id="docAll" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li class="current">
			        	<a id="docToday" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li>
			        	<a id="docWeek" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docMonth" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docQuarterly" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docYear" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %>
			        	</a>
			        </li>
		    	<%}else{ %>
		     	<li class="defaultTab" >
		        	<a href="#" target="tabcontentframe">
						<%=TimeUtil.getCurrentTimeString() %>
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
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

