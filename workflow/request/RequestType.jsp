
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.omg.Messaging.SYNC_WITH_TRANSPORT"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage"
	scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<%

int userid=user.getUID();
String showtype="0";
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
if(!offical.equals("1")){
	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
	if(RecordSet.next()){
        showtype =  Util.null2String(RecordSet.getString("showtype"));	
	}
}
String navName = SystemEnv.getHtmlLabelNames("82,33569",user.getLanguage());
String mouldId = MouldIDConst.getID("workflow");
if(offical.equals("1")){
	if(officalType!=1){
		navName = SystemEnv.getHtmlLabelNames("33788",user.getLanguage());
	}else{
		navName = SystemEnv.getHtmlLabelNames("33768",user.getLanguage());
	}
	mouldId = MouldIDConst.getID("offical");
}
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2")){
	usertype = 1;
}
/*
Calendar today = Calendar.getInstance();

String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
String agentWfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
*/
String commonuse = "";
if(usertype==0){
	//ArrayList selectArr=new ArrayList();
	//System.out.println(userid);
	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
	if(RecordSet.next()){
	    commonuse = RecordSet.getString("commonuse");
	}
}
/*
if(RecordSet.getDBType().equals("oracle")){
	//RecordSet.execute("SELECT * FROM (select * from WorkflowUseCount where userid =" + userid +" and (wfid in(select distinct t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.usertype = " + usertype+ " and " + agentWfcrtSqlWhere + ") or wfid in( select distinct t.workflowid from workflow_agentConditionSet t,workflow_base t1 where exists (select * from HrmResource b where t.bagentuid=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid="+userid+" and ((t.beginDate+t.beginTime+':00'<='"+currentdate+currenttime+"' and t.endDate+t.endTime+':00'>='"+currentdate+currenttime+"'))or(t.beginDate||t.beginTime='' and t.endDate||t.endTime = ''))) order by count desc) WHERE ROWNUM <= 10 ORDER BY ROWNUM ASC");
		String sql = " SELECT *  "+
				  " FROM ( "+
				  " select * from ( "+
				  " SELECT * "+
						  " FROM WorkflowUseCount "+
						 " WHERE userid = " + userid +" "+
						  "  AND wfid in "+
							  "  (SELECT t1.workflowid "+
								  " FROM ShareInnerWfCreate t1, workflow_base t2 "+
								"  WHERE t1.workflowid = t2.id "+
								  "  AND t2.isvalid = '1' "+
								  "  AND t1.usertype = " + usertype+ " "+
								  "  AND " + agentWfcrtSqlWhere + ") "+
						" union all "+
						" SELECT * "+
						" FROM WorkflowUseCount "+
						" WHERE userid = " + userid +" "+
						 "   and wfid IN (SELECT t.workflowid "+
										"   FROM workflow_agentConditionSet t, workflow_base t1 "+
										"  WHERE EXISTS (SELECT * "+
												 "  FROM HrmResource b "+
												"  WHERE t.bagentuid = b.id "+
												 "   AND b.status < 4) "+
										  "  AND t.workflowid = t1.id "+
										 "   AND t.agenttype > '0' "+
										  "  AND t.iscreateagenter = 1 "+
										  "  AND t.agentuid = "+userid+" "+
										  "  AND (( "+
													"  t.beginDate < '"+currentdate+"' or (t.beginDate ='"+currentdate+"' and t.beginTime<='"+currenttime+"')) "+
													"  and  "+
													"  ( "+
													"  t.endDate >'"+currentdate+"' or (t.endDate ='"+currentdate+"' and t.endTime>='"+currenttime+"')) "+
												 " ) OR (t.beginDate ='' and t.beginTime = '' AND t.endDate ='' and t.endTime = ''))) "+				 
						"  ORDER BY COUNT DESC "+
					"  ) "+
				"  WHERE ROWNUM <= 10 "+
				"  ORDER BY ROWNUM ASC ";
			RecordSet.execute(sql);
}else{
	RecordSet.execute("select top 12 * from WorkflowUseCount where userid ="+userid+" and (wfid in(select t1.workflowid from  ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' union all select t.workflowid from workflow_agentConditionSet t,workflow_base t1 where exists (select * from HrmResource b where t.bagentuid=b.id and b.status<4) and  t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid="+userid+" )) order by count desc");
}
*/
int cywf = 1;//RecordSet.getCounts();
if(offical.equals("1"))showtype="0";

String querystring = "";
Enumeration paramkeys = request.getParameterNames();
while (paramkeys.hasMoreElements()) {
    String paramstr = (String)paramkeys.nextElement();
    querystring += "&" + paramstr + "=" + request.getParameter(paramstr);
}
if (querystring.length() > 0) {
    querystring = querystring.substring(1);
}
%>



<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<script type="text/javascript">		
			
			jQuery(function(){
			    jQuery('.e8_box').Tabs({
			        getLine:1,
			        mouldID:"<%= mouldId%>",
			        iframe:"tabcontentframe",
			        staticOnLoad:true,
			        objName:"<%=navName%>"
			    });
			    var showtype = "<%=showtype%>";
			    var usertype = "<%=usertype%>";
			    var cywf = "<%=cywf%>";
			    var commonuse = "<%=commonuse%>";
			    var offical = "<%=offical%>";
			    if(getcookie("wfcookie") === ""){
			    	setcookie("wfcookie",1);
			    	$("#tab_2").addClass("current");
			    	if(showtype === "1")
			    		$("tabcontentframe").attr("src","/workflow/request/RequestTypeShowWithLetter.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0")
		    		else
		    			$("tabcontentframe").attr("src","/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0");
			    }else{
			    	var _tabck = getcookie("wfcookie");
			    	$("#tab_1").removeClass("current");
			    	$("#tab_2").removeClass("current");
			    	$("#tab_3").removeClass("current");
			    	if(offical === "1"){
			    		$("#tabcontentframe").attr("src","/workflow/request/RequestTypeOffical.jsp?<%=querystring%>&officalType=<%=officalType%>&needPopupNewPage=true&dfdfid=a&needall=1");
			    	}
			    	else if(_tabck == 0)
			    	{
			    		$("#tab_1").addClass("current");
			    		if(showtype === "1")
				    		$("#tabcontentframe").attr("src","/workflow/request/RequestTypeShowWithLetter.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=a&needall=1")
			    		else
			    			$("#tabcontentframe").attr("src","/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=a&needall=1");
		    		}
			    	else if(_tabck == 1)
			    	{
			    		$("#tab_2").addClass("current");
			    		if(showtype === "1")
				    		$("#tabcontentframe").attr("src","/workflow/request/RequestTypeShowWithLetter.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0")
			    		else
			    			$("#tabcontentframe").attr("src","/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0");
		    		}
		    		else if(_tabck == 2)
		    		{
		    			if(usertype=="0"&&commonuse!="0"&&cywf>0)
		    			{
		    				$("#tab_3").addClass("current");
		    				$("#tabcontentframe").attr("src","/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=1&usedtodo=1");
		    			}
	    			}
		    	}
		    	
		    	
			});
			
			function setcookie(name,value){ 
			    var Days = 30;   
			    var exp  = new Date();   
			    exp.setTime(exp.getTime() + Days*24*60*60*1000);   
			    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();   
			}   
  
			function getcookie(name){   
			    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));    
			    if(arr != null){   
			        return unescape(arr[2]);   
			    }else{   
			        return "";   
			    }   
			}   
  
			function delcookie(name){   
			    var exp = new Date();    
			    exp.setTime(exp.getTime() - 1);   
			    var cval=getCookie(name);   
			    if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();   
			}
		</script>

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
				
				 if(showtype.equals("")  || showtype.equals("0") || offical.equals("1"))
				 {
				
				%>
				<%if(!offical.equals("1")){ 
					if (selectedContent.equals("")){
				%>
				<li id="tab_1">
                	<a onclick="setcookie('wfcookie',0)" href="/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=a&needall=1"
						target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(offical.equals("1")?33424:18015, user.getLanguage())%> </a>
				</li>
				<li id="tab_2">
					<a onclick="setcookie('wfcookie',1)" href="/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0"
						target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%></a>
				</li>
				<%if(usertype==0&&!commonuse.equals("0")) {
					if(cywf>0){%>
				<li id="tab_3">
					<a onclick="setcookie('wfcookie',2)" href="/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0&usedtodo=1"
						target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(28184, user.getLanguage())%></a>
				</li>
                <%}}}}%>
				<%
				 }
				else if(showtype.equals("1")){
					if (selectedContent.equals("")){
				%>
                 <li id="tab_1">
                	<a onclick="setcookie('wfcookie',0)" href="/workflow/request/RequestTypeShowWithLetter.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=a&needall=1"
						target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%> </a>
				</li>
				<li id="tab_2">
					<a onclick="setcookie('wfcookie',1)" href="/workflow/request/RequestTypeShowWithLetter.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=0"
						target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%></a>
				</li>
				<% 
				if(usertype==0&&!commonuse.equals("0")) {
					if(cywf>0){%>
				<li id="tab_3">
					<a onclick="setcookie('wfcookie',2)" href="/workflow/request/RequestTypeShow.jsp?<%=querystring%>&needPopupNewPage=true&dfdfid=b&needall=1&usedtodo=1"
						target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(28184, user.getLanguage())%></a>
				</li>
				<%}
				 }	}	
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

				    <%
				
				    if(showtype.equals("")  || showtype.equals("0"))
				    {
					String url = "/workflow/request/RequestTypeShow.jsp?" + querystring + "&needPopupNewPage=true&dfdfid=b&needall=0&selectedContent="+selectedContent+"";
					if(offical.equals("1")){
						url = "/workflow/request/RequestTypeOffical.jsp?offical=1&officalType="+officalType+"&needPopupNewPage=true&dfdfid=b&needall=0";
					}
				  %>
					<iframe src=""
						onload="update();" id="tabcontentframe" name="tabcontentframe"
						class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				<%
				 }else if(showtype.equals("1"))
				 {
				%>
				<iframe onload="update();" id="tabcontentframe" name="tabcontentframe"
						class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
                 <%
				 }	 
				 %>
				</div>
			</div>
			
		</div>
	</body>
</html>

