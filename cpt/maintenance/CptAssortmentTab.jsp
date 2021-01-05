<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
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
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("assest")%>",
        staticOnLoad:true
    });
});


</script>
<!-- 自定义设置tab页 -->
<%
	int title = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String url = "";
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));//来源
	int parentid =Util.getIntValue( Util.null2String(request.getParameter("paraid")),0);//
	int subcompanyid1 =Util.getIntValue( Util.null2String(request.getParameter("subcompanyid1")),0);//
	//System.out.println("subcompanyid1:"+subcompanyid1);
	//System.out.println("parentid:"+parentid);
	
	//删除资产资料 资产跳转cptdelfromAss
	String cptdelfromAss =  Util.null2String(request.getParameter("cptdelfromAss"));
	String isdata =  Util.null2String(request.getParameter("isdata"));
	boolean isRoot=parentid==0;
	boolean isTop=Util.getIntValue( CapitalAssortmentComInfo.getSupAssortmentId(parentid+""))==0;
	url = "CptAssortmentManage.jsp?paraid="+parentid+(isRoot?"&isroot=1":isTop?"&istop=1":"")+(subcompanyid1>0?"&subcompanyid1="+subcompanyid1+"":"");
	int data1count=Util.getIntValue( CapitalAssortmentComInfo.getCapitalData1Count(parentid+""),0);
	int data2count=Util.getIntValue( CapitalAssortmentComInfo.getCapitaldata2Count(parentid+"", user, ""),0) ;
	
	int subassortmentcount=Util.getIntValue( CapitalAssortmentComInfo.getSubAssortmentCount(""+parentid),0);
	
	String url1 = "/cpt/search/SearchOperation.jsp?from=cptassortment&isdata=1&capitalgroupid="+parentid;
	String url2 = "/cpt/search/SearchOperation.jsp?from=cptassortment&isdata=2&capitalgroupid="+parentid;
	
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
		    <ul class="tab_menu">
		    		<li class="e8_tree">
			        	<a >&lt;&lt;结构</a>
			        </li>
		        
		        <%if(isRoot){//根
		        	%>
		        	<li <%if(!"1".equals(cptdelfromAss)){ %>class="current"<%} %>>
		        		<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32755,user.getLanguage()) %></a>
		        	</li>
				<%}else if(isTop){//1级资产组
			        %>
	       			<li <%if(!"1".equals(cptdelfromAss)){ %>class="current"<%} %>>
						<a target="tabcontentframe" href="CptAssortmentManage.jsp?istop=1&paraid=<%=parentid %>&subcompanyid1=<%=subcompanyid1%>"><%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage()) %></a>
					</li>
				<%
				if(data1count<=0){
					%>
					
					<li>
						<a target="tabcontentframe" href="CptAssortmentDsp.jsp?istop=1&paraid=<%=parentid %>&subcompanyid1=<%=subcompanyid1 %>"><%=SystemEnv.getHtmlLabelNames("27170,831",user.getLanguage()) %></a>
					</li>
					<%
				}
				%>	
					<li>
						<a target="tabcontentframe" href="CptAssortmentShareDsp.jsp?istop=1&paraid=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %></a>
					</li>
					
				<%
				if(subassortmentcount<=0){
					%>
					<li isdata=1 <%if("1".equals(cptdelfromAss)&& "1".equals(isdata)){ %>class="current"<%} %>>
						<a target="tabcontentframe" href="/cpt/search/SearchOperation.jsp?from=cptassortment&isdata=1&capitalgroupid=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage()) +"("+data1count +")" %></a>
					</li>
					<li isdata=2 <%if("1".equals(cptdelfromAss)&& "2".equals(isdata)){ %>class="current"<%} %>>
						<a target="tabcontentframe" href="/cpt/search/SearchOperation.jsp?from=cptassortment&isdata=2&capitalgroupid=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())+"("+data2count+")" %></a>
					</li>
					
					<%
				}
				%>		
					
				<%}else{//下级资产组
			        %>
	       			<li <%if(!"1".equals(cptdelfromAss)){ %>class="current"<%} %>>
						<a target="tabcontentframe" href="CptAssortmentManage.jsp?paraid=<%=parentid %>&subcompanyid1=<%=subcompanyid1 %>"><%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage()) %></a>
					</li>
				<%
				if(data1count<=0){
					%>
					<li>
						<a target="tabcontentframe" href="CptAssortmentDsp.jsp?paraid=<%=parentid %>&subcompanyid1=<%=subcompanyid1 %>"><%=SystemEnv.getHtmlLabelNames("27170,831",user.getLanguage()) %></a>
					</li>
					<%
				}
				%>
				<%
				if(subassortmentcount<=0){
					%>
					<li isdata=1 <%if("1".equals(cptdelfromAss)&& "1".equals(isdata)){ %>class="current"<%} %>>
						<a target="tabcontentframe" href="/cpt/search/SearchOperation.jsp?from=cptassortment&isdata=1&capitalgroupid=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage()) +"("+data1count +")" %></a>
					</li>
					<li isdata=2 <%if("1".equals(cptdelfromAss)&& "2".equals(isdata)){ %>class="current"<%} %>>
						<a target="tabcontentframe" href="/cpt/search/SearchOperation.jsp?from=cptassortment&isdata=2&capitalgroupid=<%=parentid %>"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())+"("+data2count+")" %></a>
					</li>
					
					<%
				}
				%>	
				<%}
				
				
				%>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	        <%if(!"1".equals(cptdelfromAss)){
	        	%>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        	<% 
	        }else if("1".equals(cptdelfromAss)&& "1".equals(isdata)){
	        	%>
	            <iframe src="<%=url1 %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        	<%
	        }else if("1".equals(cptdelfromAss)&& "2".equals(isdata)){
	        	%>
	            <iframe src="<%=url2 %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        	<% 
	        } %>
	            
	        </div>
	    </div>
	</div>     
</body>
</html>

