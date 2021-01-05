
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page"/>
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page"/>
<jsp:useBean id="sod" class="weaver.synergy.SynergyOperatDoc" scope="page"/>
<html>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav ="1";
	String needhelp ="";
	String hpid = Util.null2String(request.getParameter("hpid"));
	String stype = Util.null2String(request.getParameter("stype"));
	String navName = "";
	if(stype.equals("doc")) navName = SystemEnv.getHtmlLabelName(33038,user.getLanguage());
	else if(stype.equals("wf")) navName = SystemEnv.getHtmlLabelName(33037,user.getLanguage());
	String pagetype = Util.null2String(request.getParameter("pagetype"));
	String url ="";
	if(hpid.equals("")){// hpid 如果为空， 则需要确认 当前 文档 或 流程 是否设置 协同，如果没设 需要往 synergy_base 插入 记录
		//获取 流程id 或 
		String wfdocid = Util.null2String(request.getParameter("wfdocid"));
	    String frommodule = "doc".equals(stype)?"doc":"workflow";
	    rs.execute("select id from synergy_base where wfid='"+wfdocid+"' and frommodule='"+frommodule+"'");
	    //System.out.println("select id from synergy_base where wfid='"+wfdocid+"' and frommodule='"+frommodule+"'");
		int baseid = -1;
		if(!rs.next()) {//无记录，则需要往里添加
			try{
				rs.executeSql("select max(id) from synergy_base");
				rs.first();
				baseid = (rs.getInt(1) + 1);
				rst.setAutoCommit(false);
				rst.executeSql("select max(id) id from synergy_base");
				if(stype.equals("wf")) sowf.insertBase4wf(rst,baseid,wfdocid);
				else if(stype.equals("doc")) sod.insertBase4Doc(rst,baseid,wfdocid);				
			}catch(Exception e){
				e.printStackTrace();
				rst.rollback();
			}finally{
				rst.commit();
				sc.removeSynergyInfoCache();
			}
		}else{
			baseid = rs.getInt("id");
		}
		hpid = baseid+"";
	} 
	
	// hpid 即为 synergy_base 表中的 id 值
    String dealpageurl = "";
	String newpageurl = "";
	if(pagetype.equals("")){
		newpageurl = "/synergy/maintenance/SynergyNoneDesign.jsp?stype="+stype+"&pagetype=menu";
	}else{		
		newpageurl = "/homepage/Homepage.jsp?ispagedeal=0&hpid=-"+hpid+"&subCompanyId=-1&isfromportal=&isfromhp=&isSetting=true&pagetype="+stype;
		dealpageurl = "/homepage/Homepage.jsp?hpid=-"+(Util.getIntValue(hpid)+1)+"&ispagedeal=1&subCompanyId=-1&isfromportal=&isfromhp=&isSetting=true&pagetype="+stype;
	}
		
%>
<%
	
%>
<head>
<script>
 	window.notExecute = true;
</script>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
        			<li class="e8_tree">
        				<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32769,user.getLanguage()) %></a>
        			</li>
			        <%if(pagetype.equals("operat")){ %>
			        	<li class="current">
							<a href="<%=newpageurl %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(83868,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="<%=dealpageurl %>" target="tabcontentframe">
                               		<%
								    	if(stype.equals("wf")){
								    %>
										<%=SystemEnv.getHtmlLabelName(84285,user.getLanguage()) %>
									<%}else{ %>
									     <%=SystemEnv.getHtmlLabelName(84286,user.getLanguage()) %>
								    <%}%>
                            
                            </a>
						</li>
			        <%}else{ %>
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
    <div class="tab_box">
        <div>
            <iframe src="<%=newpageurl %>" id="tabcontentframe" onload="update();" name="tabcontentframe" class="flowFrame" frameborder="0" scrolling="no" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div>
</body>
</html>

<script language="javascript">

window.e8ShowAllways=true;

jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("joint")%>",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
});
function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
		}
	}
}
</script>