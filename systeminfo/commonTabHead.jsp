
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
	User user = HrmUserVarify.getUser (request , response) ;
	String id = Util.null2String(request.getParameter("mouldID"));
	String mouldID = "";
	if(!id.equals("")){
		mouldID = MouldIDConst.getID(id);
	}
	String navName = Util.null2String(request.getParameter("navName"));
	boolean exceptHeight = Util.null2String(request.getParameter("exceptHeight")).equals("true");
	String _fromURL = Util.null2String(request.getParameter("_fromURL"));
	String isPersonalDoc = Util.null2String(request.getParameter("isPersonalDoc"));
	int docid =  Util.getIntValue(request.getParameter("docid"),-1);
	String docsubject = Util.null2String(request.getParameter("docsubject"));
	String fileName = Util.null2String(request.getParameter("fileName"));
	if(!fileName.isEmpty()){
		try{
			fileName=java.net.URLDecoder.decode(fileName, "utf-8");
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	boolean isFromAccessory="true".equals(request.getParameter("isFromAccessory"))?true:false;
	if(isFromAccessory) navName=SystemEnv.getHtmlLabelName(93,user.getLanguage());
	try{
		docsubject=java.net.URLDecoder.decode(docsubject,"UTF-8");
	}catch(Exception ex){
		ex.printStackTrace();
	}
	if(docid>0&&docsubject.trim().equals("")){
		DocManager.resetParameter();
		DocManager.setId(docid);
		DocManager.getDocInfoById();
		docsubject = DocManager.getDocsubject();
	}
	String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc"));
	String limitSec = Util.null2String(request.getParameter("limitSec"));
	
	String contentDivStyle = Util.null2String(request.getParameter("contentDivStyle"));

%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%if(_fromURL.equals("doc")){//新建/编辑文档页面
%>
<script type="text/javascript">
	var __ajaxStartMsg = "<%= SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>";
	
	var __switchTypeMsg = "<%=SystemEnv.getHtmlLabelName(18691, user.getLanguage())%>";
	
	var __reSelectCatMsg = "<%=SystemEnv.getHtmlLabelName(81565, user.getLanguage())%>";
</script>
<style type="text/css">
	.e8_outbox{
		top:19px!important;
	}
</style>
<%} %>
<script type="text/javascript">
<%if("1".equals(limitSec)){ %>
 	 window.notExecute = true;
 <%}%>
jQuery(function(){
	try{
		//jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
	}catch(e){}
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:null,
        exceptHeight:<%=exceptHeight%>,
        objName:"<%=navName%>",
        mouldID:"<%= mouldID%>"
    });
 }); 
 
</script>
<div class="e8_box demo2">
	<div class="e8_boxhead" style="<%="1".equals(fromFlowDoc)?"display:none":"" %>">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
		<div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			 <%if(_fromURL.equals("doc")){//新建/编辑文档页面
			 %>
			 <div style="float:left;margin-top:10px;margin-left:-25px;width:450px;">
				<wea:layout>
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item>
							<%if(isFromAccessory) {%>
							<span style="color:rgb(184, 184, 184)!important;display:inline-block;padding-right:8px;">
								<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>:  
							</span>
							<input type="hidden" name="namerepeated" value="0">
							<input type="text"  style="width:310px"  value="<%=fileName%>" maxlength=200	disabled=disabled >
							<input type="hidden"  id="docsubject" name="docsubject" value="<%=docsubject%>"	>
							<span id="docsubjectspan" style="display:none">
								<%if(docsubject.equals("")){%>
									<img src="/images/BacoError_wev8.gif" align=absMiddle>
								<%} %>
							</span>
							<%}else{%>
							<span style="color:rgb(184, 184, 184)!important;display:inline-block;padding-right:8px;">
								<%=SystemEnv.getHtmlLabelName(19541,user.getLanguage())%>:
							</span>
							<input type="hidden" name="namerepeated" value="0">
							<input type="text" style="width:310px" id="docsubject" name="docsubject" value="<%=docsubject%>" maxlength=200	onChange="checkinput('docsubject','docsubjectspan');">
							<span id="docsubjectspan" >
								<%if(docsubject.equals("")){%>
									<img src="/images/BacoError_wev8.gif" align=absMiddle>
								<%} %>
							</span>
							<%}%>
				        	</wea:item>
				        </wea:group>
      				</wea:layout>
      			</div>
      			 <ul class="tab_menu" style="display:none!important;">
      			 	
			    </ul>
	        	 <%}else{ %>
				    <ul class="tab_menu">
				    	<%if(!"1".equals(limitSec) && request.getRequestURI().indexOf("DocListAjax")!=-1){ %>
	      			 	<li class="e8_tree">
				        	<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
				        </li>
				    <%} %>
				    </ul>
				 <%} %>
		    	<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box <%=_fromURL.equals("doc")?"_synergyBox":"" %>" style="overflow:auto;">
	   <div style="<%=contentDivStyle %>">