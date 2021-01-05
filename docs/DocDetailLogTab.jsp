
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	String url = "/docs/DocDetailLogNew.jsp?"+request.getQueryString();
	HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
	String isdialog=Util.null2String(kv.get("isdialog"));
	String _fromURL = Util.null2String((String)kv.get("_fromURL"));
	String height = Util.null2String(kv.get("height"));
	if(height.equals("all")){
		height="100%";
	}
	RecordSet.executeSql("select d2.isLogControl from docdetail d1,DocSecCategory d2 where d1.seccategory=d2.id and d1.id=" + kv.get("id"));
	int isLogControl = 0;
	if (RecordSet.next()) {
		isLogControl = Util.getIntValue(Util.null2String(RecordSet.getString("isLogControl")),0);
	}
	if(_fromURL.equals("1")){//未阅
		url = "/docs/DocDetailLogNoReadNew.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("2")){//该阅
		url = "/docs/DocDetailLogAllReadNew.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("3")){//打印
		url = "/docs/DocDetailLogPrintNew.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("4")){//下载
		url = "/docs/DocDetailLogDownloadNew.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("5")){//已阅
	    url = "/docs/DocDetailLogReadedNew.jsp?"+request.getQueryString();
	}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">

function initTab(height){
	if(jQuery("#divViewLog",parent.document).css("display")=="none"){
		window.setTimeout(function(){initTab(height);},1000);
	}else{
		$('.e8_box').Tabs({
	        getLine:1,
	        iframe:"tabcontentframe",
	        staticOnLoad:true,
	        mouldID:"<%=MouldIDConst.getID("doc")%>",
	        objName:"<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage()) %>"
	 	});
	}
}

$(function(){
	var height = "<%=height%>";
	if(!!height){
		initTab(height);
	}else{
	    $('.e8_box').Tabs({
	        getLine:1,
	        mouldID:"<%=MouldIDConst.getID("doc")%>",
	        objName:"<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage()) %>",
	        iframe:"tabcontentframe",
	        staticOnLoad:true
	    });
	   }
 });
    
</script>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<%if(isdialog.equals("1")){ %>
			<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
		<%} %>
		    <ul class="tab_menu">
		    		<li class="<%= _fromURL.equals("0") ? "current" : "" %>">
			        	<a href="/docs/DocDetailLogNew.jsp?isdialog=<%=isdialog %>&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(82857,user.getLanguage()) %>
			        	</a>
			        </li>
		        	 <li class="<%= _fromURL.equals("5") ? "current" : ""  %>">
			        	<a href="/docs/DocDetailLogReadedNew.jsp?isdialog=<%=isdialog %>&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21972,user.getLanguage()) %>
			        	</a>
			        </li>
			        <%if(isLogControl==1){ %>
			        <li>
			        	<a href="/docs/DocDetailLogNoReadNew.jsp?isdialog=<%=isdialog %>&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21971,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a href="/docs/DocDetailLogAllReadNew.jsp?isdialog=<%=isdialog %>&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21973,user.getLanguage()) %>
			        	</a>
			        </li>
			        <%} %>
			         <li>
			        	<a href="/docs/DocDetailLogPrintNew.jsp?isdialog=<%=isdialog %>&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(257,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li>
			        	<a href="/docs/DocDetailLogDownloadNew.jsp?isdialog=<%=isdialog %>&id=<%=kv.get("id") %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage()) %>
			        	</a>
			        </li>
			        
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <%if(isdialog.equals("1")){ %>
	     </div>
			</div>
		</div>
		<%} %>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

