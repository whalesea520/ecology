
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageElementCominfo"></jsp:useBean>
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String tabid = Util.null2String(request.getParameter("tabid"));
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String hpid = "";
	//是否为处理页面
	String ispagedeal = Util.null2String(request.getParameter("ispagedeal"));
	//页面类型 流程或文档
	String pagetype = Util.null2String(request.getParameter("pagetype"));
	if(null==request.getParameter("hpid")){
		hpid = hpc.getHpid(ebaseid);
	}else{
		hpid = Util.null2String(request.getParameter("hpid"));
	}
	String esharelevel = Util.null2String(request.getParameter("esharelevel"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String subcompanyid = Util.null2String(request.getParameter("subCompanyId"));
	String stype = Util.null2String(request.getParameter("stype"));
	String spagetype = Util.null2String(request.getParameter("spagetype"));
	String saddpage = Util.null2String(request.getParameter("saddpage"));
	String wfids=""; 
	if (session.getAttribute(eid + "_Add") != null) {
		Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
		if (tabAddList.containsKey(tabid)) {
			Hashtable tabInfo = (Hashtable) tabAddList.get(tabid);
			wfids = (String) tabInfo.get("flowids");
		} else {
			rs.executeSql("select content from workflowcentersettingdetail where eid='"+eid+"' and type='flowid'  and tabid='"+tabid+"'");
			while(rs.next()){
				wfids += Util.null2String(rs.getString("content"))+",";
			}
			//System.out.println("wfids====================="+wfids);
			if(!"".equals(wfids))
			wfids = wfids.substring(0,wfids.length()-1);
		}

	}else if(wfids.equalsIgnoreCase("")){
		rs.executeSql("select content from workflowcentersettingdetail where eid='"+eid+"' and type='flowid'  and tabid='"+tabid+"'");
		while(rs.next()){
			wfids += Util.null2String(rs.getString("content"))+",";
		}
		//System.out.println("wfids====================="+wfids);
		if(!"".equals(wfids))
		wfids = wfids.substring(0,wfids.length()-1);
	}
%>
<html style='height: 100%;'><HEAD>
<style>
 html{
  height:100%;
 }
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function() {
	$('.e8_box').Tabs({
		iframe : "tabcontentframe",
		needInitBoxHeight:false
	});
	attachUrl();
});


function attachUrl()
{
	$("[name='tabcontentframe']").attr("src","SynergyElementSet4WfFrame.jsp?ispagedeal=<%=ispagedeal%>&pagetype=<%=pagetype%>&eid=<%=eid%>&tabid=<%=tabid%>&ebaseid=<%=ebaseid%>&wfids=<%=wfids%>&subcompanyid=<%=subcompanyid%>&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=saddpage%>&esharelevel=<%=esharelevel%>");
}


</script>
</HEAD>
<BODY >
<div class="e8_box demo2">
	<div class="tab_box">
        <div style="height:100%">
			<iframe id="tabcontentframe" onload="update();" name="tabcontentframe" class="flowFrame" frameborder="0" scrolling="no" height="100%" width="100%;"></iframe>
  		</div>
    </div>
</div>
</BODY>
</html>
