
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="meetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="session"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <!--    <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script>-->
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<link rel="stylesheet" href="/rdeploy/assets/css/workplan/workplanshow.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<style>
	.root_docu {
		background-color: transparent;
	}
	button {
		background-color: transparent;
	}
</style>
</HEAD>

<%
int uid=user.getUID();
String id=Util.null2String(request.getParameter("id"));
String treeStr = "";
if(!id.equals("")){
    treeStr = meetingUtil.getSubordinateTreeList(id,0);
}
//System.out.println("treeStr = "+treeStr);
JSONArray jsonArray = JSONArray.fromObject(treeStr);
List<Map<String,Object>> mapListJson = (List)jsonArray;
%>

<BODY style="overflow:hidden">
<FORM NAME=SearchForm STYLE="margin-bottom:0"  method=post target="contentframe">


			<div class="personnel">
			</div>
			<div class="leftrtnimg">
				<div style="float:left;width:30px;height:25px">
					<div class="rtnback" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>" onclick="refreshplan()"></div>
				</div>
				<div class="personnelname"><%=resourceComInfo.getResourcename(id)+"的下属"%></div>
			</div>
			<div class="personnel">
			</div>
			
			<div id="deeptree" style="top:27px;position: absolute;width:100%;overflow:hidden;">
			<%for(int i=0;i<mapListJson.size();i++){ 
				Map<String,Object> obj=mapListJson.get(i);
			%>
                <div class="planitem">
                	<div class="leftpart">
                		<div class="leftimg">
                			<img src="<%=resourceComInfo.getMessagerUrls(String.valueOf(obj.get("id")))%>">
                			<input type="hidden" name="userid" value="<%=String.valueOf(obj.get("id"))%>">
                			<input type="hidden" name="username" value="<%=resourceComInfo.getResourcename(String.valueOf(obj.get("id")))%>">
                		</div>
                		<div class="leftname"><%=resourceComInfo.getResourcename(String.valueOf(obj.get("id")))%></div>
                	</div>
                	<div class="rightpart">
                			<%
                			String nextNum = meetingUtil.getSubordinateTreeList(String.valueOf(obj.get("id")),0);
                			JSONArray jsonNum = JSONArray.fromObject(nextNum);
                			List<Map<String,Object>> mapListNum = (List)jsonNum;
                			if(mapListNum.size()>0){%>
	                		<div class="rightimg">
	                			<div class="subordinate">
	                				<img src="/rdeploy/assets/img/workplan/subordinate.png">
	                			</div>
	                			<div class="subordinatenum"><%=mapListNum.size()%></div>
	                		</div>
                			<%}%>
                	</div>
                </div>
			<%} %>
			
			<%if(mapListJson.size()==0){ %>
			<div class="noplanitem">
				<div class="noplanitemimg"></div>			
				<div class="noplanitemname">没有下属</div>			
			</div>
			<%} %>
            </div> 

</FORM>


<script type="text/javascript">
	$(function(){
		jQuery(".planitem").find("img").bind("click", function () {
			var id = jQuery(this).parent().find("input[name=userid]").val();
			var name = jQuery(this).parent().find("input[name=username]").val();
			parent.setUser(id);
			parent.jQuery("#selectType").val("1");
			if(jQuery(".itemchecked").length>0){
				var tempclass = jQuery(".itemchecked");
				tempclass.removeClass("itemchecked");
			}
			jQuery(this).parent().parent().parent().addClass("itemchecked"); 
		});
		
		jQuery(".planitem").find(".rightimg").bind("click", function () {
			var id = jQuery(this).parent().parent().find("input[name=userid]").val();
			var name = jQuery(this).parent().parent().find("input[name=username]").val();
			parent.setUser(id);
			parent.jQuery("#selectType").val("1");
			parent.setCurrentUser(id, name);
			parent.showPersonTree(id);
			jQuery(".personnelname").html(name+"的下属");
			if(jQuery(".itemchecked").length>0){
				var tempclass = jQuery(".itemchecked");
				tempclass.removeClass("itemchecked");
			}
		});
		
		jQuery(".rtnback").bind("mouseover",function(e){
			jQuery(this).css({"background-image":"url('/rdeploy/assets/img/workplan/rtnbackhot.png')","border":"1px solid #8d9598"});
		});
		
		jQuery(".rtnback").bind("mouseout",function(e){
			jQuery(this).css({"background-image":"url('/rdeploy/assets/img/workplan/rtnback.png')","border":"0px"});
    	});
		
		jQuery("#deeptree").height(jQuery("body").height()-27);
		jQuery("#deeptree").perfectScrollbar();
	});
	
	function refreshplan(){
		parent.showMyCalnedar();
	}
</SCRIPT>


</BODY>
</HTML>