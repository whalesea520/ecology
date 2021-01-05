
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%!
public boolean hasRecord(String resourceid){
	weaver.conn.RecordSet rs = new RecordSet();
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	String sql = "select count(a.id)" +
	" from HrmByCheckPeople a left join HrmCheckList b on a.checkid = b.id "+
	" where a.checkercount="+resourceid +" and b.enddate>='"+currentdate+"' " ;
	rs.executeSql(sql);
	return (rs.next()?rs.getInt(1):0)>0;
}
%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
    	getLine:1,
    	image:false,
    	needLine:false,
    	needTopTitle:true,
    	iframe:"contentframeRight"
    });
    
    //计算上一个iframe的高度，去掉滚动条
    //jQuery(document.body).css("height",jQuery("div.tab_box",parent.document).height()+"px");
    //alert(jQuery("div.tab_box",parent.document).height());
});

</script>

<%
	String url = "";
	HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _id = (String)kv.get("id");
	boolean hasFLag = hasRecord(_id);
	String iframeSrc = hasFLag?"/hrm/resource/HrmResourceRewardsRecord.jsp":"/hrm/resource/HrmResourceRewardsRecord1.jsp";
	iframeSrc += "?resourceid="+_id+"&isfromtab=true";
%>
</head>
<BODY scroll="no">
	<div class="e8_box">
		    <ul class="tab_menu">
			        <%if(hasFLag){ %>
		        	 <li class="current">
			        	<a href="/hrm/resource/HrmResourceRewardsRecord.jsp?resourceid=<%=_id %>&isfromtab=true" target="contentframeRight">
			        		<%=SystemEnv.getHtmlLabelName(17503,user.getLanguage()) %>
			        	</a>
			        </li>
			        <%} %>
			        <li>
			        	<a href="/hrm/resource/HrmResourceRewardsRecord1.jsp?resourceid=<%=_id %>&isfromtab=true" target="contentframeRight">
			        		<%=SystemEnv.getHtmlLabelName(32740,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a href="/hrm/resource/HrmResourceRewardsRecord2.jsp?resourceid=<%=_id %>&isfromtab=true" target="contentframeRight">
			        		<%=SystemEnv.getHtmlLabelName(15682,user.getLanguage()) %>
			        	</a>
			        </li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=iframeSrc %>" id="contentframeRight" name="contentframeRight" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

