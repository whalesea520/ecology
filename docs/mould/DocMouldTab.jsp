
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "";
	String navName = "";
	String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);

	boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
    if(isUseDocManageDetach){
      detachable=1;
    }
	int isdetach = Util.getIntValue(request.getParameter("isDetach"),-1);
	if(detachable==1 && isdetach!=1&&isdetach!=3){
		if(_fromURL.equals("1")){//编辑模板
			response.sendRedirect("/docs/mouldfile/DocMouldNew_frm.jsp?"+request.getQueryString());
			return;
		}else if(_fromURL.equals("3")){//显示模板
			response.sendRedirect("/docs/mould/DocMould_frm.jsp?"+request.getQueryString());
			return;
		}
	}
	if(subcompanyId.equals("")){
		subcompanyId = Util.null2String(session.getAttribute("docdftsubcomid"));
	}
	String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
	if(_fromURL.equals("1")){//编辑模板
		url = "/docs/mouldfile/DocMould.jsp?"+request.getQueryString();
		session.setAttribute("editMould_subcompanyid",subcompanyId);
		navName = (detachable==1&&!subcompanyId.equals("")&&!subcompanyId.equals("0"))?SubCompanyComInfo.getSubCompanyname(subcompanyId):SystemEnv.getHtmlLabelName(isWorkflowDoc.equals("1")?33692:16449,user.getLanguage());
	}else if(_fromURL.equals("2")){//目录模板
		url = "/docs/category/DocSecCategoryTmplList.jsp";
		session.setAttribute("dirMould_subcompanyid",subcompanyId);
		navName = (detachable==1&&!subcompanyId.equals("")&&!subcompanyId.equals("0"))?SubCompanyComInfo.getSubCompanyname(subcompanyId):SystemEnv.getHtmlLabelName(19456,user.getLanguage());
	}else if(_fromURL.equals("3")){//显示模板
		url = "/docs/mould/DocMould.jsp?"+request.getQueryString();
		session.setAttribute("showMould_subcompanyid",subcompanyId);
		navName = (detachable==1&&!subcompanyId.equals("")&&!subcompanyId.equals("0"))?SubCompanyComInfo.getSubCompanyname(subcompanyId):SystemEnv.getHtmlLabelName(isWorkflowDoc.equals("1")?33692:16450,user.getLanguage());
	}else if(_fromURL.equals("4")){//邮件模板
		url = "/docs/mail/DocMould.jsp";
		session.setAttribute("mailMould_subcompanyid",subcompanyId);
		navName = (detachable==1&&!subcompanyId.equals("")&&!subcompanyId.equals("0"))?SubCompanyComInfo.getSubCompanyname(subcompanyId):SystemEnv.getHtmlLabelName(16218,user.getLanguage());
	}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID(isWorkflowDoc.equals("1")?"offical":"doc")%>",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
 
 }); 
 
</script>

</head>
<BODY scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
		    <%if(detachable==1){ %>
			    	<li class="e8_tree">
				    	<a onclick="javascript:refreshTab();">
			        		<%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %>
			        	</a>
			        </li>
			    <%} %>
		    <%if(isWorkflowDoc.equals("1") && (_fromURL.equals("1") || _fromURL.equals("3"))){ %>
		    	<li class="<%=_fromURL.equals("3")?"current":"" %>">
		    		<%if(detachable==1){ %>
		        		<a href="/docs/mould/DocMould_frm.jsp?isWorkflowDoc=<%=isWorkflowDoc %>" target="_parent"><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage()) %></a>
		        	<%}else{ %>
		        		<a href="/docs/mould/DocMould.jsp?isWorkflowDoc=<%=isWorkflowDoc %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage()) %></a>
		        	<%} %>
		        </li>
		        <li class="<%=_fromURL.equals("1")?"current":"" %>">
		        	<%if(detachable==1){ %>
		        		<a href="/docs/mouldfile/DocMouldNew_frm.jsp?isWorkflowDoc=<%=isWorkflowDoc%>" target="_parent"><%=SystemEnv.getHtmlLabelName(16449,user.getLanguage()) %></a>
		        	<%}else{ %>
		        		<a href="/docs/mouldfile/DocMould.jsp?isWorkflowDoc=<%=isWorkflowDoc %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16449,user.getLanguage()) %></a>
		        	<%} %>
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

