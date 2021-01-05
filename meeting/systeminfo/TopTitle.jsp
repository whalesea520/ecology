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
if(!querystring.equals(""))
	querystring=querystring.substring(1);
if(!querystring.equals(""))
	gopage = uri+"?"+querystring;
gopage = "http://"+hostname+"/main.jsp?gopage="+URLEncoder.encode(gopage);
//out.print(gopage);

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
<DIV class=TopTitle style="margin:0 3px 0 3px">

<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0  >
  <TBODY>
  <TR>
  <%if(imagefilename != null && !imagefilename.equals("")){%>
    <TD align=left width=55><IMG src="<%=imagefilename%>"></TD>
   <%}%>
    <TD align=left><SPAN id=BacoTitle ><%=titlename%></SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>    
    <TD align=middle width=24><BUTTON class=btnLittlePrint id=onPrint title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>" onclick="javascript:window.print();" style="display:none"></BUTTON>
	</TD>
    <%
    if(!needhelp.equals("")){
    %>
    <TD align=middle width=24><BUTTON class=btnHelp style="display:none"></BUTTON></TD>
    <%
    }
    %>
	 <TD align=middle width=24><BUTTON class=btnBack id=onBack title="<%=SystemEnv.getHtmlLabelName(15408,user.getLanguage())%>" onclick="javascript:history.back();" style="display:none"></BUTTON>
	 </TD>
     <td align="right">
	 <%
    if(!ajaxs.equals("ajax")){
    %> <BUTTON class=btnFavorite id=BacoAddFavorite
    title="<%=SystemEnv.getHtmlLabelName(18753,user.getLanguage())%>" onclick="location.href='/systeminfo/FavouriteAdd.jsp'" ></BUTTON><%}%>&nbsp;	 
	 <img src="/images/help_wev8.gif" style="CURSOR:hand" width=12 onclick="javascript:showHelp()" title="<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>"></td>
     <td width="20">&nbsp;</td >
  </TR>
  </TBODY>
</TABLE>
</DIV>
<script language=javascript>
/*
function addtofavorites(){
	window.external.AddFavorite('<%=gopage%>', '<%=titlename%>');
}
*/

function showAddFavMsg(){
    alert("<%=SystemEnv.getHtmlLabelName(18754,user.getLanguage())%>");
}

<%if(addFavSuccess==1){%>
    showAddFavMsg();
<%}%>
function showHelp(){
    var pathKey = this.location.pathname;
    //alert(pathKey);
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    //var operationPage = "http://localhost/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");



}
</script>


