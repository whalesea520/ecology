
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.rdeploy.portal.PortalUtil" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ page import="weaver.docs.docs.reply.DocReplyUtil"%>
<HTML><HEAD>
<%
HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
String urlType = Util.null2String((String)kv.get("urlType"));
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
String reply = "1";
if(!DocReplyUtil.isUseNewReply()){
    reply = Util.null2String(kv.get("dspreply"));
}
String isDetach=Util.null2String(request.getParameter("isDetach"));
String offical = Util.null2String(kv.get("offical"));
int officalType = Util.getIntValue(kv.get("officalType"),-1);
String keyword = Util.null2String(kv.get("keyword"));
if(_fromURL.equals("4")){//新建文档
	String _url = "/docs/docs/DocList.jsp?hasTab=1&"+request.getQueryString();
	boolean isuserdeploy = PortalUtil.isuserdeploy();
	if(isuserdeploy)
	{
	    _url = "/rdeploy/doc/RDocListAjax.jsp";
	}
	response.sendRedirect(_url);
	return;
}
String docdetachable="0";
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
 String hasRightSub="";
if(isUseDocManageDetach){
   docdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("docdetachable",docdetachable);
   hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"DocEdit:Edit",-1);
   session.setAttribute("docdftsubcomid",hasRightSub);
}else{
   docdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("docdetachable",docdetachable);
   session.setAttribute("docdftsubcomid","0");

}
if("1".equals(docdetachable)&&_fromURL.equals("5")){
    response.sendRedirect("/docs/category/DocMainCategory_frm.jsp?isFromMonitor=1&"+request.getQueryString());
    return;
}
 %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
/*
* 13  批量共享
* 14  查询文档
* 2   知识排名
* 15  批量调整共享
* 16  文档中心
* 18  未读文档
*/
<%if(urlType.equals("0")||urlType.equals("5")||urlType.equals("13")||urlType.equals("14")||urlType.equals("2")||urlType.equals("15")||urlType.equals("22")||urlType.equals("23")||offical.equals("1")){%>
	window.notExecute = true;
<%}%>


$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        exceptHeight:true,
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID(offical.equals("1")?"offical":"doc")%>"
    });
    
    <%if(urlType.equals("0")||urlType.equals("5")||urlType.equals("15")||urlType.equals("22")||urlType.equals("23")||offical.equals("1")){%>
    	jQuery("#e8_tablogo").bind("click.user",function(){
    		parent.loadLeftTree();
    		jQuery("#e8_tablogo").unbind("click.user");
    	});
    <%}%>
    function getIframeDocument(){
    	var _contentDocument = getIframeDocument2();
    	var _contentWindow = getIframeContentWindow();
    	if(!!_contentDocument){
    		<%if(urlType.equals("1")||urlType.equals("2")||urlType.equals("3")||urlType.equals("4")){%>
				jQuery("#mostReply").bind("click",function(){
					_contentDocument = getIframeDocument2();
					try{
						//parent.refreshLeftMenu("0","0","2","DocSearchTab.jsp",{seccategory:jQuery("#seccategory",_contentDocument).val()});
					}catch(e){}
					jQuery("#urlType",_contentDocument).val("2")
					jQuery("#frmmain",_contentDocument).submit();
				});
				jQuery("#mostRead").bind("click",function(){
					_contentDocument = getIframeDocument2();
					try{
						//parent.refreshLeftMenu("0","0","1","DocSearchTab.jsp",{seccategory:jQuery("#seccategory",_contentDocument).val()});
					}catch(e){}
					jQuery("#urlType",_contentDocument).val("1")
					jQuery("#frmmain",_contentDocument).submit();
				});
				jQuery("#mostDownload").bind("click",function(){
					_contentDocument = getIframeDocument2();
					try{
						//parent.refreshLeftMenu("0","0","4","DocSearchTab.jsp",{seccategory:jQuery("#seccategory",_contentDocument).val()});
					}catch(e){}
					jQuery("#urlType",_contentDocument).val("4")
					jQuery("#frmmain",_contentDocument).submit();
				});
				jQuery("#highestScore").bind("click",function(){
					_contentDocument = getIframeDocument2();
					try{
						//parent.refreshLeftMenu("0","0","3","DocSearchTab.jsp",{seccategory:jQuery("#seccategory",_contentDocument).val()});
					}catch(e){}
					jQuery("#urlType",_contentDocument).val("3")
					jQuery("#frmmain",_contentDocument).submit();
				});
		<%}else if(urlType.equals("5")||urlType.equals("10")||urlType.equals("6")||urlType.equals("13")||urlType.equals("14")||urlType.equals("16")||urlType.equals("22")||urlType.equals("23")){%>
			jQuery("#docAll").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
				var showtype=parseInt(jQuery("#showtype",parent.document).val());
				var date2during = jQuery("#date2during",_contentDocument).val();
				var seccategory = jQuery("#seccategory",_contentDocument).val();
    			if(showtype==2){
    				var creatersubcompanyid = jQuery("#creatersubcompanyid",_contentDocument).val();
    				var departmentid = jQuery("#departmentid",_contentDocument).val();
    				_contentWindow.resetCondtion();
    				jQuery("#creatersubcompanyid",_contentDocument).val(creatersubcompanyid);
    				jQuery("#departmentid",_contentDocument).val(departmentid);
    			}else{
    				_contentWindow.resetCondtion();
    			}
    			jQuery("#dspreply",_contentDocument).val("0");
    			jQuery("#date2during",_contentDocument).val(date2during);
    			jQuery("#seccategory",_contentDocument).val(seccategory);
				try{
					//parent.refreshLeftMenu("0",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			jQuery("#notReply").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#dspreply",_contentDocument).val("1");
				try{
					//parent.refreshLeftMenu("0",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{dspreply:"1",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			jQuery("#onlyReply").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#dspreply",_contentDocument).val("2");
				try{
					//parent.refreshLeftMenu("0",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{dspreply:"2",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
		<%}else if(!_fromURL.equals("5")){%>
    		jQuery("#docAll").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
    			var urlType = jQuery("#urlType",_contentDocument).val();
    			var seccategory = jQuery("#seccategory",_contentDocument).val();
    			_contentWindow.resetCondtion();
    			jQuery("#urlType",_contentDocument).val(urlType);
				jQuery("#doccreatedateselect",_contentDocument).val("0");
				jQuery("#doccreatedateselect",_contentDocument).trigger("change");
				jQuery("#seccategory",_contentDocument).val(seccategory);
				try{
					//parent.refreshLeftMenu("0",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{offical:"<%=offical%>",officalType:"<%=officalType%>",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docToday").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("1");
				jQuery("#doccreatedateselect",_contentDocument).trigger("change");
				try{
					//parent.refreshLeftMenu("1",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{offical:"<%=offical%>",officalType:"<%=officalType%>",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docWeek").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("2");
				jQuery("#doccreatedateselect",_contentDocument).trigger("change");
				try{
					//parent.refreshLeftMenu("2",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{offical:"<%=offical%>",officalType:"<%=officalType%>",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
				return false;
			});
			
			jQuery("#docMonth").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("3");
				jQuery("#doccreatedateselect",_contentDocument).trigger("change");
				try{
					//parent.refreshLeftMenu("3",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{offical:"<%=offical%>",officalType:"<%=officalType%>",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docQuarterly").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("4");
				jQuery("#doccreatedateselect",_contentDocument).trigger("change");
				try{
					//parent.refreshLeftMenu("4",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{offical:"<%=offical%>",officalType:"<%=officalType%>",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docYear").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#doccreatedateselect",_contentDocument).val("5");
				jQuery("#doccreatedateselect",_contentDocument).trigger("change");
				try{
					//parent.refreshLeftMenu("5",jQuery("#_doccreater",_contentDocument).val(),jQuery("#urlType",_contentDocument).val(),"DocSearchTab.jsp",{offical:"<%=offical%>",officalType:"<%=officalType%>",seccategory:jQuery("#seccategory",_contentDocument).val()});
				}catch(e){}
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docCopy").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.oc(1);
			});
			
			jQuery("#docMove").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.oc(2);
			});
		<%}else{%>
			<%--jQuery("#publishDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("publishDoc");
			});
			jQuery("#archiveDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("archiveDoc");
			});
			jQuery("#invalidDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("invalidDoc");
			});
			jQuery("#cancelDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("cancelDoc");
			});
			jQuery("#reopenFromArchiveDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("reopenFromArchiveDoc");
			});
			jQuery("#reopenFromCancellationDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("reopenFromCancellationDoc");
			});
			jQuery("#deleteDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("deleteDoc");
			});
			jQuery("#checkInCompellablyDoc").bind("click",function(){
				_contentWindow = getIframeContentWindow();
		    	_contentWindow.switchOperation("checkInCompellablyDoc");
			});--%>
			
		<%}%>
    	}else{
    		window.setTimeout(function(){
    			getIframeDocument();
    		},500);
    	}
    }
   getIframeDocument();
});

</script>

<%
	String url = "/docs/search/DocCommonContent.jsp?hasTab=1&"+request.getQueryString();
	String cTab = "";
	if(!keyword.equals("") && urlType.equals("")){
		urlType="6";
		url+="&urlType=6&fromUrlType=1";
	}
	if(urlType.equals("22")||urlType.equals("23")){
		url="/docs/search/DocRecycleContent.jsp?hasTab=1&"+request.getQueryString();
	}
	if(_fromURL.equals("1")){//审批文档
		url = "/docs/docs/ApproveDocList.jsp?hasTab=1&"+request.getQueryString();
	}else if(_fromURL.equals("2")){//分享知识
		url = "/docs/docs/DocShareView.jsp?hasTab=1&"+request.getQueryString();
	}else if(_fromURL.equals("3")){//移动复制
		url = "/docs/tools/DocCopyMove.jsp?Action=INPUT&hasTab=1&"+request.getQueryString();
	}else if(_fromURL.equals("4")){//新建文档
		url = "/docs/docs/DocList.jsp?hasTab=1&"+request.getQueryString();
	}else if(_fromURL.equals("5")){//文档监控
		url = "/system/systemmonitor/docs/DocMonitor.jsp?hasTab=1&"+request.getQueryString();
	}else if(_fromURL.equals("6")){//虚拟目录
		url = "/docs/docdummy/DocDummyRight.jsp?hasTab=1&"+request.getQueryString();
	}else if(_fromURL.equals("1024")){//虚拟目录
		url = "/docs/transfer/MultiDocBrowserByAuth.jsp?hasTab=1&"+request.getQueryString();
	}
	String ulStyle = "";
	if(urlType.equals("13")||urlType.equals("14") || urlType.equals("15")){
		ulStyle = "visibility:hidden;";
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
		    <ul class="tab_menu" style="<%=ulStyle %>">
		    <%if((!urlType.equals("18") && !urlType.equals("16") && !urlType.equals("17") && !urlType.equals("13") && !urlType.equals("14") && !urlType.equals("9") && !urlType.equals("8") && !urlType.equals("7") && ("".equals(_fromURL)||"6".equals(_fromURL))&&!urlType.equals("2")&&!urlType.equals("15"))){ %>
		        <li class="e8_tree">
		        	<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
		        </li>
		     <%} %>
		        <%if(urlType.equals("9") || urlType.equals("8") || urlType.equals("7")){/*文档订阅*/ %>
		        	 <li class="<%=urlType.equals("7")?"current":"" %>">
			        	<a href="/docs/search/DocCommonContent.jsp?ishow=false&urlType=7&<%=request.getQueryString() %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(17713,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li class="<%=urlType.equals("8")?"current":"" %>">
			        	<a href="/docs/search/DocCommonContent.jsp?ishow=false&urlType=8&<%=request.getQueryString()%>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(17714,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li class="<%=urlType.equals("9")?"current":"" %>">
			        	<a href="/docs/search/DocCommonContent.jsp?ishow=false&urlType=9&<%=request.getQueryString()%>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(17715,user.getLanguage()) %>
			        	</a>
			        </li>
			        <script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(32121,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(urlType.equals("1")||urlType.equals("2")||urlType.equals("3")||urlType.equals("4")){/*知识排名*/%>
		        	<li id="mostReply" class="<%=urlType.equals("2")?"current":"" %>">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(32124,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="mostRead" class="<%=urlType.equals("1")?"current":"" %>">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(32120,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="mostDownload" class="<%=urlType.equals("4")?"current":"" %>">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(32123,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="highestScore" class="<%=urlType.equals("3")?"current":"" %>">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(32125,user.getLanguage()) %>
			        	</a>
			        </li>
		        <%}else if(urlType.equals("5")||urlType.equals("10") || urlType.equals("13")||urlType.equals("6")||urlType.equals("14")||urlType.equals("16")){/*我的文档|批量共享|查询文档|文档中心*/%>
		        	
		        	<% if(!DocReplyUtil.isUseNewReply()){ %>
		        	 <li id="docAll" class="<%=!(reply.equals("1")||reply.equals("2"))?"current":"" %>">
			        	<a  href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="notReply" class="<%=reply.equals("1")?"current":"" %>">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(18467,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="onlyReply" class="<%=reply.equals("2")?"current":"" %>">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(18468,user.getLanguage()) %>
			        	</a>
			        </li>
			        <% } %>
		        <%}else if(urlType.equals("22")||urlType.equals("23")){/*文档回收站*/%>
		        	<li class="defaultTab" >
			        	<a href="#" target="tabcontentframe" onclick="return false;">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
			        </li>
		        	<script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(130650,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(_fromURL.equals("1")){/*审批文档*/%>
		        	<li class="defaultTab" >
			        	<a href="#" target="tabcontentframe" onclick="return false;">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
			        </li>
		        	<script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(2069,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(_fromURL.equals("2")){/*分享知识*/%>
		        	<li class="defaultTab" >
			        	<a href="#" target="tabcontentframe" onclick="return false;">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
			        </li>
			        <script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(16396,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(_fromURL.equals("3")){/*移动复制*/%>
		        	 <li class="current">
			        	<a  id="docCopy" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docMove" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(78,user.getLanguage()) %>
			        	</a>
			        </li>
			        <script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(18052,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(_fromURL.equals("4")){/*新建文档*/%>
		        	 <li id="allDoc" class="<%=cTab.equals("1")?"current":"" %>">
			        	<a href="/docs/docs/DocList.jsp?isuserdefault=0&hasTab=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="userDoc" class="<%=(!cTab.equals("1")&&!cTab.equals("3"))?"current":"" %>">
			        	<a href="/docs/docs/DocList.jsp?isuserdefault=1&hasTab=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(18030,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="commonDoc" class="<%=cTab.equals("3")?"current":"" %>">
			        	<a href="/docs/docs/DocList.jsp?iscommondir=1&hasTab=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(28183,user.getLanguage()) %>
			        	</a>
			        </li>
			         <script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(_fromURL.equals("5")){/*文档监控*/%>
			        <script type="text/javascript">
						jQuery(document).ready(function(){
							setTabObjName("<%=SystemEnv.getHtmlLabelName(16757,user.getLanguage()) %>");
						});
					</script>
		        <%}else if(_fromURL.equals("6")){/*虚拟目录*/%>
		        	<li class="defaultTab" >
			        	<a href="#" target="tabcontentframe">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
			        </li>
		        <%} else if(_fromURL.equals("1024")){
		        	
		        }else{%>
		        	 <li class="<%=urlType.equals("0")?"":"current" %>">
			        	<a  id="docAll" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li class="<%=urlType.equals("0")?"current":"" %>">
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
		        <%} %>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()"  id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	            
	        </div>
	    </div>
	</div>     
</body>
</html>
             <% if(isDetach.equals("3")){%>
                  <script type="text/javascript">

						jQuery(document).ready(function(){
							jQuery("#e8_tablogo").trigger("click");
						});
					</script>
					<%}%>