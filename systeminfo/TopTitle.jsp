<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="RecordSetFavourite" class="weaver.conn.RecordSet" scope="page"/>


<%
isIncludeToptitle = 1;
String gopage = "";
String hostname = request.getServerName();
String uri = request.getRequestURI();
String querystring="";
titlename = Util.null2String(titlename) ;
String ajaxs="";
for(Enumeration En=request.getParameterNames();En.hasMoreElements();)
{
	String tmpname=(String) En.nextElement();
	
    if(tmpname.equals("ajax"))
	{
		ajaxs=tmpname;
    	continue;
	}
    String tmpvalue=Util.toScreen(request.getParameter(tmpname),user.getLanguage(),"0");
	//querystring+="^"+tmpname+"="+tmpvalue;
    String [] pvalues = request.getParameterValues(tmpname);   //修复bug，收藏的报表，列不能全部显示的问题，modify by fmj 2015-03-05
    if(pvalues.length > 0){
    	for(int _kkk = 0; _kkk < pvalues.length; _kkk++){
    		querystring+="^"+tmpname+"="+Util.toScreen(pvalues[_kkk],user.getLanguage(),"0");
    	}
    }
}
if(!querystring.equals(""))
	querystring=querystring.substring(1); 

String pagename= titlename ;

session.setAttribute("fav_pagename" , pagename ) ;
session.setAttribute("fav_uri" , uri ) ;
session.setAttribute("fav_querystring" , querystring ) ;
int addFavSuccess=Util.getIntValue(session.getAttribute("fav_addfavsuccess")+"");
session.setAttribute("fav_addfavsuccess" , "" ) ;
pagename = URLEncoder.encode(pagename);


//is workflow page
boolean isWfFomPage=false;
String strUrl=request.getRequestURL().toString();

if(strUrl.indexOf("AddRequest.jsp")!=-1
		||strUrl.indexOf("ManageRequestNoForm.jsp")!=-1
		||strUrl.indexOf("ManageRequestNoFormMode.jsp")!=-1
		||strUrl.indexOf("ManageRequestNoFormBill.jsp")!=-1
		||strUrl.indexOf("ViewRequest.jsp")!=-1){
	isWfFomPage=true;
}
%>
<DIV id="divTopTitle">	
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr>
		<td width="<%=isWfFomPage?"4px":"10px"%>">&nbsp;</td>
		<td  width="*">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0  class=TopTitle>
			  <TBODY>
			  <TR>
			  <%if(imagefilename != null && !imagefilename.equals("")){%>
			    <TD align=left width=45><IMG src="<%=imagefilename%>" height="18px"></TD>
			   <%}%>
			    <TD align=left style="padding-top:3px"><SPAN id='BacoTitle' ><%=titlename%></SPAN></TD>
			    <TD align=right>&nbsp;</TD>
			    <TD width=5></TD>    
			    <TD align=middle width=24><!-- <BUTTON style="display:none" class=btnLittlePrint id=onPrint title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>" onclick="javascript:window.print();" style="display:none"></BUTTON> -->
				</TD>
			    <%
			    if(!needhelp.equals("")){
			    %>
			    <TD align=middle width=24><!--<BUTTON style="display:none" class=btnHelp ></BUTTON> --></TD>
			    <%
			    }
			    %>
				 <TD align=middle width=24><!--<BUTTON class=btnBack id=onBack title="<%=SystemEnv.getHtmlLabelName(15408,user.getLanguage())%>" onclick="javascript:history.back();" style="display:none"></BUTTON> -->
				 </TD>
			     <td align="right">
				 <%
			    if(!ajaxs.equals("ajax")){
			    %> <BUTTON class=btnFavorite id=BacoAddFavorite
			    title="<%=SystemEnv.getHtmlLabelName(18753,user.getLanguage())%>" onclick="openFavouriteBrowser();" ></BUTTON><%}%>&nbsp;
				 <BUTTON class=btnHelp id=btnHelp
			    title="<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>" onclick="showHelp();" ></BUTTON> 
				</td>
			     <td width="10">&nbsp;</td >
			  </TR>
			  </TBODY>
			</TABLE>
		</td>
		<td width="<%=isWfFomPage?"0px":"10px"%>"></td>
		</tr>
		</TABLE>
</DIV>
<%
BaseBean baseBean_TopTitle = new BaseBean();
int userightmenu_TopTitle = 1;
try{
	userightmenu_TopTitle = Util.getIntValue(baseBean_TopTitle.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_TopTitle == 0){
%>
<div id="divTopMenuSpace" name="divTopMenuSpace" height="1" style="BACKGROUND-COLOR:#FFFFFF;border:1px solid #FFFFFF"></div>
<div id="divTopMenu" name="divTopMenu" class="topmenuTable" style="margin:0 3px 0 3px;BACKGROUND-COLOR:#ECECEC;border:1px solid #979797">
</div>
<%}%>

<script language=javascript>
<%
if(userightmenu_TopTitle == 0){
%>	
doSetTopMenu();
function doSetTopMenu(){
	var needShow = null;
	try{
		var obj = document.getElementById("needShow");
		needShow = obj.value;
	}catch(e){}
	if(needShow!=null && needShow=="1"){
		try{
			var objRightMenuDiv = document.getElementById("rightMenu");
			var rightMenuIframe = document.getElementById("rightMenuIframe");
			var objMenuDiv = document.getElementById("divTopMenu");
			if(objRightMenuDiv!=null && window.frames["rightMenuIframe"].document.getElementById("menuTable").innerHTML!=""){
				if(rightMenuIframe!=null){
					objMenuDiv.appendChild(rightMenuIframe);
				}
				objRightMenuDiv.outerHTML = "";
				objRightMenuDiv.style.height = "0px";
				window.document.body.style.marginTop = "0px";
				objRightMenuDiv.style.border = "0px";
				objRightMenuDiv.style.position = "relative";
				objRightMenuDiv.style.display = "none";
			}
		}catch(e){}
	}else{
		try{
			document.getElementById("divTopMenu").style.border = "0px";
		}catch(e){}
	}
}
<%
}
%>
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
function openFavouriteBrowser()
{  
	
	var BacoTitle = jQuery("#BacoTitle");
	var pagename = "";

	if(BacoTitle)
	{
		pagename = BacoTitle.text();
	}
	pagename =  encodeURI(encodeURI(pagename));
	//window.showModalDialog('/favourite/FavouriteBrowser.jsp?fav_pagename='+pagename+'&fav_uri=<%=URLEncoder.encode(uri)%>&fav_querystring=<%=URLEncoder.encode(querystring)%>');
	window.showModalDialog('/favourite/FavouriteBrowser.jsp?fav_pagename='+pagename+'&fav_uri=<%=URLEncoder.encode(uri)%>');
}
</script>


