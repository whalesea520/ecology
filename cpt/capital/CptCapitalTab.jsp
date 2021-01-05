<%@page import="org.json.JSONObject"%>
<%@page import="weaver.cpt.util.OAuth"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptCardTabComInfo" class="weaver.cpt.util.CptCardTabComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page"/>
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
        mouldID:"<%= MouldIDConst.getID("assest")%>",
        staticOnLoad:true
    });
}); 
</script>
<!-- 自定义设置tab页 -->
<%
	String url = "";
	String querystr=request.getQueryString();
	int capitalid =Util.getIntValue( Util.null2String(request.getParameter("capitalid")),0);
	String isdialog = Util.null2String(request.getParameter("isdialog"));
	url = "CptCapital.jsp?isfromCapitalTab=1&id="+capitalid+"&isdialog="+isdialog+"&"+querystr;
	String isdata= CapitalComInfo.getIsData(capitalid+"");
	
	
	
	/*显示权限判断*/
	int requestid = Util.getIntValue(request.getParameter("requestid"),0);
	int userid = user.getUID();
	String logintype = ""+user.getLogintype();

	boolean displayAll = false;
	boolean canedit = false;
	boolean canview = false;
	boolean canDelete = false;
	boolean canviewlog = false;
	boolean onlyview=false;
	/*有显示权限的可以查看所有资产*/
	if(HrmUserVarify.checkUserRight("CptCapital:Display",user))  {
		displayAll=	true;
		canview=true;
	}
	/*可否编辑*/
	/*由于现在资产资料和资产的权限控制完全不同所以需做以下区分*/
	if (isdata.equals("1")) {
	    // added by lupeng 2204-07-21 for TD558
	    if (HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
	        canview = true;
			canedit = true;
			canDelete = true;
			canviewlog	= true;/*可否查看日志*/
		}
	    // end
	} else {
		if (HrmUserVarify.checkUserRight("CptCapitalEdit:Delete",user)) {
			canDelete = true;
		}
		/*共享权限判断*/
		
		//int sharelevel=Util.getIntValue( CommonShareManager.getSharLevel("cpt", ""+capitalid, user),0);
		RecordSetShare.executeSql(CommonShareManager.getSharLevel("cpt", ""+capitalid, user));
		if( RecordSetShare.next()) {
			int sharelevel = Util.getIntValue(RecordSetShare.getString(1), 0) ;
			if( sharelevel >= 2 ) {
				canedit=true;
				canviewlog=true;
				canview=true;
			}else if(sharelevel>0){
				canview=true ;
			}
		}
	}

	if(!canview){
		boolean isurger=WFUrgerManager.UrgerHaveCrmViewRight(requestid,userid,Util.getIntValue(logintype),""+capitalid);
		boolean ismoitor=WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+capitalid,"3");
		if(OAuth.onlyView(user, "cpt", request, new JSONObject())){
			onlyview=true;
		}else if(!isurger && !ismoitor){
	        response.sendRedirect("/notice/noright.jsp") ;
	        return ;
	    }else{
	        onlyview=true;
	    }
	}

	if(!canview&&!onlyview){
		response.sendRedirect("/notice/noright.jsp") ;
	    return ;
	}
	/*权限判断结束*/	
	
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
					if(!"1".equals( isdata)){
						CptCardTabComInfo.setTofirstRow();
						int count=1;
						while(CptCardTabComInfo.next()){
							if(!"1".equals( CptCardTabComInfo.getIsopen())){
								continue;
							}
							String linkurl=Util.null2String( CptCardTabComInfo.getLinkurl()).replaceAll("\\Q{#id}", ""+capitalid);
							if("".equals(linkurl)){
								linkurl="/notice/noright.jsp";
							}else{
								if(linkurl.indexOf("?")>=0){
									linkurl+="&isfromCapitalTab=1&"+querystr;
								}else{
									linkurl+="?isfromCapitalTab=1&"+querystr;
								}
							}
							
							if("1".equals( CptCardTabComInfo.getGroupid())){//资产卡片基本信息,有特殊参数id
								linkurl=linkurl+"&id="+capitalid+"&isdialog="+isdialog+"&"+querystr;
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
						
					}else{
						%>
						<li class="">
							<a target="tabcontentframe" <%="1".equals(isdata)?"class='defaultTab' onclick='return false' ":"" %> href="<%=url %>" ><%="1".equals(isdata)?"":""+SystemEnv.getHtmlLabelNames("15806",user.getLanguage()) %></a>
						</li>
						<%
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
	var objname='<%=CapitalComInfo.getCapitalname(""+capitalid) %>';
	setTabObjName(objname);
});
</script>
</body>
</html>

