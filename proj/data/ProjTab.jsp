<%@page import="org.json.JSONObject"%>
<%@page import="weaver.cpt.util.OAuth"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="CptCardTabComInfo" class="weaver.proj.util.PrjCardTabComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
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
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
        staticOnLoad:true
    });
}); 
</script>
<link rel="stylesheet" href="/proj/css/common_wev8.css" type="text/css" />
<!-- 自定义设置tab页 -->
<%
	String url = "";
	int projectid =Util.getIntValue( Util.null2String(request.getParameter("projectid")),0);
	RecordSet.executeSql("select 1 from Prj_ProjectInfo where id="+projectid);
	if(!RecordSet.next()){
		out.println(SystemEnv.getHtmlLabelNames("101,18967",user.getLanguage()));
		return;
	}
	String isdialog =Util.null2String(request.getParameter("isdialog"));
	String querystr=request.getQueryString();

	/*权限－begin*/
	boolean canview=false;
	boolean canedit=false;
	boolean iscreater=false;
	boolean ismanager=false;
	boolean ismanagers=false;
	boolean ismember=false;
	boolean isrole=false;
	boolean isshare=false;
	String iscustomer="0";

	//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
	double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+projectid, user),0 );
	if(ptype==2.5||ptype==2){
		canview=true;
		canedit=true;
		ismanager=true;
	}else if (ptype==3){
		canview=true;
		canedit=true;
		ismanagers=true;
	}else if (ptype==4){
		canview=true;
		canedit=true;
		isrole=true;
	}else if (ptype==0.5){
		canview=true;
		ismember=true;
	}else if (ptype==1){
		canview=true;
		isshare=true;
	}
	
	if(!canview&&!(OAuth.onlyView(user, "prj", request, new JSONObject()))){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	
	url = "ViewProject.jsp?isfromProjTab=1&ProjID="+projectid;
	
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
		    
		    <%
		    CptCardTabComInfo.setTofirstRow();
			int count=1;
			while(CptCardTabComInfo.next()){
				if(!"1".equals( CptCardTabComInfo.getIsopen())){
					continue;
				}
				String linkurl=Util.null2String( CptCardTabComInfo.getLinkurl()).replaceAll("\\Q{#id}", ""+projectid);
				if("".equals( linkurl)){
					linkurl="/notice/noright.jsp";
				}else if(linkurl.indexOf("?")>=0){
					linkurl+="&isfromProjTab=1&"+request.getQueryString();
				}else{
					linkurl+="?isfromProjTab=1&"+request.getQueryString();
				}
				if("1".equals( CptCardTabComInfo.getGroupid())){//项目信息
					linkurl=linkurl+"&ProjID="+projectid+"&isdialog="+isdialog;
				}else if("2".equals(CptCardTabComInfo.getGroupid())){//任务列表
					linkurl=linkurl+"&ProjID="+projectid+"&isdialog="+isdialog;
				}else if("3".equals(CptCardTabComInfo.getGroupid())){//子项目
					linkurl=linkurl+"&parentprj="+projectid+"&isdialog="+isdialog;
				}else if("4".equals(CptCardTabComInfo.getGroupid())){//相关交流
					linkurl=linkurl+"&types=PP&sortid="+projectid+"&isdialog="+isdialog;
				}else if("5".equals(CptCardTabComInfo.getGroupid())){//共享设置
					linkurl=linkurl+"&ProjID="+projectid+"&isdialog="+isdialog;
				}else if("6".equals(CptCardTabComInfo.getGroupid())){//统计报告
					linkurl=linkurl+"&ProjID="+projectid+"&isdialog="+isdialog;
				}
				if(count==1){
					url=linkurl;
				}
				%>
				<li class="<%=count==1?"current":"" %>" >
					<a target="tabcontentframe" href="<%=linkurl %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue( CptCardTabComInfo.getLabel(),0),user.getLanguage()) %></a>
				</li>
				<%
				count++;
			}
		    
		    %>
		    
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
<script type="text/javascript">	
$(function(){
	var objname='<%=ProjectInfoComInfo.getProjectInfoname(""+projectid) %>';
	setTabObjName(objname);
});
$(function(){//加载tab数值
	getDiscussNum("getnum",'PP','<%=projectid %>');
});
function getDiscussNum(src,type,sortid){
	jQuery.ajax({
		url : "/proj/process/PrjGetDiscussNumAjax.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {src:src,type:type,sortid:sortid},
		dataType : "json",
		success: function do4Success(data){
			if(data){
				if(data.count&&data.count>0){
					$("#discussNum_span").html(data.count).show();
				}
			}
		}
	});
}
</script>
</body>
</html>

