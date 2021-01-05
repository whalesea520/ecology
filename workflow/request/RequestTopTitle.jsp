<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="RecordSetFavourite" class="weaver.conn.RecordSet" scope="page"/>

<%
String gopage = "";
String hostname = request.getServerName();
String uri = request.getRequestURI();
String querystring="";
titlename = Util.null2String(titlename) ;
String ajaxs="";
try{
for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
	String tmpname=(String) En.nextElement();
	
    if(tmpname.equals("ajax"))
	{
	ajaxs=tmpname;
    continue;
	}
    String tmpvalue=Util.toScreen(request.getParameter(tmpname),user.getLanguage(),"0");
	querystring+="^"+tmpname+"="+tmpvalue;
}
}catch(Exception e){}
if(!querystring.equals(""))
	querystring=querystring.substring(1);
if(!querystring.equals(""))
	gopage = uri+"?"+querystring;
gopage = "http://"+hostname+"/main.jsp?gopage="+URLEncoder.encode(gopage);

String pagename= titlename ;
int start_1234567kick = titlename.indexOf("<a");
int end_1234567kick = titlename.indexOf("/a>");
while(start_1234567kick!=-1){
	pagename = pagename.substring(0,start_1234567kick)+pagename.substring(end_1234567kick+3,pagename.length());
	start_1234567kick = pagename.indexOf("<a");
	end_1234567kick = pagename.indexOf("/a>");
}

session.setAttribute("fav_pagename" , pagename ) ;
session.setAttribute("fav_uri" , uri ) ;
session.setAttribute("fav_querystring" , querystring ) ;
    int addFavSuccess=Util.getIntValue(session.getAttribute("fav_addfavsuccess")+"");
    session.setAttribute("fav_addfavsuccess" , "" ) ;

%>
<DIV id="divTopTitle">

</DIV>
<%if(helpdocid!=0){%>
<script language="javascript">
function showHelp(){
    var operationPage = "/docs/docs/DocDsp.jsp?id=<%=helpdocid%>";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
</script>
<%} else {%>
<script language=javascript>

function showAddFavMsg(){
    alert("<%=SystemEnv.getHtmlLabelName(18754,user.getLanguage())%>");
}

<%if(addFavSuccess==1){%>
    showAddFavMsg();
<%}%>
function showHelp(){
    var pathKey = this.location.pathname;
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }
    var operationPage = "http://www.e-cology.com.cn/formmode/apps/ktree/ktreeHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
    
}
</script>
<%}%>


