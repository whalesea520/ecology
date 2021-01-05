
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.SimpleTimeZone" %>
<%@ page import="com.simplerss.dataobject.Item" %>
<%@ page import="com.simplerss.handler.RSSHandler" %>
<%@ page language="java" import="weaver.file.Prop" %>

<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="sci" class="weaver.system.SystemComInfo" scope="page" />

<%
	int isIncludeToptitle = 0;
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	int userLanguage = 7;
	if(user!=null){
		user = HrmUserVarify.getUser (request , response) ;
		userLanguage = user.getLanguage();
	}
	String eid=Util.null2String(request.getParameter("eid"));
	String tabid = Util.null2String(request.getParameter("tabid"));

	int perpage=10;
	if(null!=Prop.getPropValue("RSS", "prepage")&&!"".equals(Prop.getPropValue("RSS", "prepage"))){
		perpage=Integer.parseInt(Prop.getPropValue("RSS", "prepage"));
	}
	String key=hpec.getStrsqlwhere(eid);	
	if("".equals(tabid)){
		rs.execute("select * from hpNewsTabInfo where eid="+eid +" order by tabId");
		rs.next();
		tabid = rs.getString("tabId");
	}


	rs.execute("select sqlWhere from hpNewsTabInfo where eid = '"+eid+"' and tabId='"+tabid+"'");
	if(rs.next()){
		key = rs.getString("sqlWhere");
	}
	String rssReadType="";
	String[] rssSettingList = Util.TokenizerString2(key,"^,^");
	if(rssSettingList.length==4){
		rssReadType = rssSettingList[3];
		key = rssSettingList[0]+"^,^"+rssSettingList[1]+"^,^"+rssSettingList[2];
	}else{
		if(rssSettingList.length>=3){
			rssReadType = rssSettingList[2];
			key = ""+"^,^"+rssSettingList[0]+"^,^"+rssSettingList[1];
		}
	}
	
	String rssUrl = hpes.getRssUrlStr(key,perpage);
	//LinkedList rssElementList = hpes.getRssElementList(rssUrl);  

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = "RSS"+SystemEnv.getHtmlLabelName(260,userLanguage);
	String needfav ="1";
	String needhelp ="";
%>
    
<HTML>
<HEAD>
<script type="text/javascript" src="/js/jquery.table_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
<style>
.headTable,.contentDiv{
	padding-left :10px;
	overflow-y: hidden;
	background-color: rgb(248,248,248);
}
.headTr{
}
.headTable th{
    background-color: rgb(248, 248, 248);
	border-bottom-color: rgb(183, 224, 254);
	border-bottom-style: solid;
	border-bottom-width: 2px;
	border-collapse: collapse;

	color: rgb(0, 0, 0);
	cursor: pointer;
	display: table-cell;
	font-family: 'Microsoft YaHei';
	font-size: 12px;
	font-weight: normal;
	height: 32px;
	line-height: 30px;
	list-style-type: circle;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	max-width: 35px;
	padding-bottom: 0px;
	padding-left: 10px;
	padding-right: 5px;
	padding-top: 0px;
	text-align: left;
	text-overflow: clip;
	vertical-align: middle;
	white-space: nowrap;
	word-break: keep-all;
}
.headTable,.contentDiv tr{
	vertical-align: middle;
	 height: 30px;
}
.headTable,.contentDiv td{
    background-color: rgb(255, 255, 255);
	border-collapse: collapse;
	color: rgb(36, 36, 36);
	display: table-cell;
	font-family: 'Microsoft YaHei';
	font-size: 12px;
	height: 30px;
	list-style-type: circle;
	margin-bottom: 0px;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	overflow-x: hidden;
	overflow-y: hidden;
	padding-bottom: 0px;
	padding-left: 12px;
	padding-right: 5px;
	padding-top: 0px;
	text-align: left;
	text-overflow: ellipsis;
	vertical-align: middle;
	white-space: nowrap;
	word-break: keep-all;
}
.contentDiv{
	margin-top: 5px;
    text-align: right;
    font-size: 9pt;
}
a{
	text-decoration: none!important;
	color:#242424; 
}
</style>
</HEAD>
<BODY>
<% if(user!=null){ %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%} %>
<div class="headTable">
	<table width=100% height="40px" border="0" cellspacing="0" cellpadding="0" style="table-layout: fixed;">
		<colgroup>
			<col width="70%"/>
			<col width="30%"/>
		</colgroup>
		<tr class="headTr">
			<th>RSS<%=SystemEnv.getHtmlLabelName(229,userLanguage)%></th>
			<th><%=SystemEnv.getHtmlLabelName(1339,userLanguage)%></th>
		</tr>
	</table>
</div>
<div class="contentDiv" id="contentDiv">
	<table id="rssMoreTable" width=100% height=100% border="0" cellspacing="0" cellpadding="0" style="table-layout: fixed;">
		<colgroup>
			<col width="70%>
			<col width="30%">
		</colgroup>
	</table>
</div>
</BODY>
</HTML>
<%
if("2".equals(rssReadType)){
%>
<script type="text/javascript">
	
		var languageid=readCookie("languageidweaver");
	//	var objDiv=document.getElementById("divContent");
	//	objDiv.innerHTML="<img src=/images/loading2_wev8.gif><%=SystemEnv.getHtmlLabelName(19612,userLanguage)%>...";
		
	
</script>
<%
	String rssContent = "";
	boolean hasTitle=true;
	String linkmode="2";
	String strStyle = "";

	try {
		Class tempClass=null;
		Method tempMethod=null;
		Constructor ct=null;
		tempClass = Class.forName("weaver.homepage.RssUtil");	
		tempMethod = tempClass.getMethod("getRssElementList", new Class[]{String.class});
		ct = tempClass.getConstructor(null);
		Item[] rssElementList=(Item[])tempMethod.invoke(ct.newInstance(null), new Object[] {rssUrl});

		rssContent = "";
		
		for (int i = 0; i <rssElementList.length; i++) {
			Item itm = (Item) rssElementList[i];
			
			if(i%2==0) 
				strStyle="datadark";
			else  
				strStyle="datalight";
			rssContent+="<TR  class="+strStyle+">";	
			if(hasTitle){
				rssContent+="<TD >";
				if(linkmode=="1"){
					rssContent+="<a href="+itm.getLink()+"' target='_self' title="+itm.getTitle()+">"+itm.getTitle()+"</a>";
				}else {
					rssContent+="<a href=javascript:openFullWindowForXtable('"+itm.getLink()+"') title="+itm.getTitle()+">"+itm.getTitle()+"</a>";
				} 
				 rssContent+="</TD>";
			}
			
			rssContent+="<TD>"+hpu.getCurrentTime(itm.getPubDate(), "date")+"&nbsp;&nbsp;"+hpu.getCurrentTime(itm.getPubDate(), "time")+"</TD>";
							
			rssContent+="</TR>";
		}
		
		rssContent+="";				

	} catch (Exception e) {
           rssContent=e.toString();
	}
		%>
		<script type="text/javascript">
			$('#rssMoreTable').append("<%=rssContent%>");
		</script>
		<% 
 }%>
<SCRIPT LANGUAGE="JavaScript">
<!--
	

	function parsRss(objDivId,rssUrl){		
	    var objDiv=document.getElementById(objDivId);
		var languageid=readCookie("languageidweaver");
		
		var returnStr="";	
		var imgSymbol="";
		var hasTitle="true";
		var hasDate="true";
		var hasTime="true";
		var titleWidth="*";
		var dateWidth="90";
		var timeWidth="90";
		var rssTitleLength="40";
		var linkmode="2";
		var size="3";
		
		//objDiv.innerHTML="<img src=/images/loading2_wev8.gif>...";
		try{
			var XmlHttp;
			if (window.XMLHttpRequest) {
				XmlHttp = new XMLHttpRequest();
			}  
			else if (window.ActiveXObject) {
				XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");  
			}
		
			XmlHttp.open("GET",rssUrl, true);
			XmlHttp.onreadystatechange = function () { 
				//alert(rssRequest.readyState)
				switch (XmlHttp.readyState) {
				   case 3 : 					
						break;
				   case 4 : 
					   if (XmlHttp.status==200)  {

						 returnStr+= "	    <TABLE  width=\"100%\" class=\"listStyle\">";
					   
							var items=XmlHttp.responseXML;
							var titles=new Array(),pubDates=new Array(); dates=new Array(), times=new Array(), linkUrls=new Array(), descriptions=new Array()	
								
							var items_count=items.getElementsByTagName('item').length;
							//if(items_count>perpage) items_count=perpage;
							//alert(items_count)

							for(var i=0; i<items_count; i++) {
								titles[i]="";
								pubDates[i]="";
								linkUrls[i]="";
								descriptions[i]="";
								dates[i]="";
								times[i]="";

								if(items.getElementsByTagName('item')[i].getElementsByTagName('title').length==1)
									titles[i]=items.getElementsByTagName('item')[i].getElementsByTagName('title')[0].firstChild.nodeValue;


								if(items.getElementsByTagName('item')[i].getElementsByTagName('pubDate').length==1)
									pubDates[i]=items.getElementsByTagName('item')[i].getElementsByTagName('pubDate')[0].firstChild.nodeValue;

								if(items.getElementsByTagName('item')[i].getElementsByTagName('link').length==1)
									linkUrls[i]=items.getElementsByTagName('item')[i].getElementsByTagName('link')[0].firstChild.nodeValue;

								if(i%2==0) strStyle="datadark";
								else  strStyle="datalight";
								returnStr+="<TR height=18px class="+strStyle+">";	
								
								if(hasTitle=="true"){
									 returnStr+="<TD width='70%'>";
									  if(linkmode=="1"){
										returnStr+="<a href=\""+linkUrls[i]+"\" target=\"_self\" title=\""+titles[i]+"\">"+titles[i]+"</a>";
									  } else {
									  	returnStr+="<a href=\"javascript:openFullWindowForXtable('"+linkUrls[i]+"')\" title=\""+titles[i]+"\">"+titles[i]+"</a>";
									  } 
									
									 returnStr+="</TD>";
								} 
								if(pubDates[i]!=""){
									var d = new Date(pubDates[i]);
									if(d=='NaN'){
									dates[i]="";
									times[i]="";
									}else{
										dates[i]=d.getFullYear()+"-"+(d.getMonth() + 1) + "-"+d.getDate() ;

										if(d.getHours()<=9)	times[i]+="0"+d.getHours() + ":";
										else times[i]+= d.getHours() + ":";

										if(d.getMinutes()<=9)	times[i]+="0"+d.getMinutes() + ":";
										else times[i]+= d.getMinutes() + ":";

										if(d.getSeconds()<=9)	times[i]+="0"+d.getSeconds();
										else times[i]+= d.getSeconds() ;
									}
								} else {
									dates[i]="";
									times[i]="";
								}								
								returnStr+="<TD width='30%'>"+dates[i]+"&nbsp;&nbsp;"+times[i]+"</TD>";
								
								returnStr+="</TR>";
						
							}
						

							returnStr+="		</TABLE>";
							objDiv.innerHTML=returnStr;
					   } else {
						   objDiv.innerHTML=XmlHttp.responseText;
					   }
					   break;
				} 
			}	
			XmlHttp.setRequestHeader("Content-Type","text/xml")	
			XmlHttp.send(null);	
		} catch(e){    
			if(e.number==-2147024891){
				objDiv.innerHTML="<%=SystemEnv.getHtmlLabelName(127877,userLanguage)%>&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(<%=SystemEnv.getHtmlLabelName(127878,userLanguage)%>?)< /a>";
			}   else {
				objDiv.innerHTML=e.number+":"+e.description;
			}
		}
		
 	}
	

//-->

</SCRIPT>

<SCRIPT FOR=window EVENT=onload LANGUAGE="JavaScript"> 
 
  //window.status = "Page is loaded!";
	if("<%=rssReadType%>"=="1"){
		 parsRss("contentDiv","<%=rssUrl%>")   
	}
</SCRIPT>




