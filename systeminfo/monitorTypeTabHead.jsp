
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
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
	String docsubject =  Util.null2String(request.getParameter("docsubject"));
%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
jQuery(function(){
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
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
		<div class="e8_tablogonew" id="e8_tablogonew"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
			      <%if(_fromURL.equals("doc")){//新建/编辑文档页面
					%>
			        <li>
			        	<a href="#" onclick="return false;" style="text-align:left;">
			        		<wea:layout>
								<wea:group context="" attributes="{'groupDisplay':'none'}">
									<wea:item>
										<span style="color:rgb(184, 184, 184)!important;display:inline-block;padding-right:8px;">
											<%=SystemEnv.getHtmlLabelName(19541,user.getLanguage())%>:
										</span>
							        		<input type="hidden" name="namerepeated" value="0">
											<input type="text" style="width:310px" id="docsubject" name="docsubject" value="<%=docsubject%>" maxlength=200							 
											<%if(isPersonalDoc.equals("false")){%>
												onChange="checkDocSubject(this);"
												onMouseDown="docSubjectMouseDown(this);"
												onBlur="checkDocSubject(this);"
											<%}else{%>
												onChange="checkinput('docsubject','docsubjectspan');"
											<%}%>
											>
											<span id="docsubjectspan" >
												<%if(docsubject.equals("")){%>
													<img src="/images/BacoError_wev8.gif" align=absMiddle>
												<%} %>
											</span>
							        	</a>
							        	</wea:item>
							        </wea:group>
	        					</wea:layout>
			        	</a>
			        </li>
			       <% }else{ %>
			       	<li class="defaultTab">
			        	<a href="#" target="tabcontentframe">
			        		<%=TimeUtil.getCurrentTimeString() %>
			        	</a>
			        </li>
			       <%} %>
			    </ul>
		    	<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box" style="overflow:auto;">
	   <div>