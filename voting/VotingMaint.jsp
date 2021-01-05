
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18599,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
if(!canmaint){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checksubmit()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

         RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<form name=frmmain action="VotingMaintOperation.jsp" method=post>
<input type=hidden name=method value="add">

<wea:layout type="4col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
				<span>
		             <brow:browser viewType="0" name="createrid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' _callback=""
						completeUrl="/data.jsp" linkUrl="" width="60%"
						browserSpanValue=""></brow:browser>
		        </span>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(2153,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
				<brow:browser viewType="0" name="approverid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' _callback=""
				completeUrl="/data.jsp" linkUrl="" width="60%"
				browserSpanValue=""></brow:browser>
		     </span>	
		</wea:item>
		
	</wea:group>
</wea:layout>


</form>
<br>
<table class=ListStyle>
<col width=40%><col width=40%>
 
  <tr class=header> 
    <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%> </td>
    <td><%=SystemEnv.getHtmlLabelName(2153,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  </tr> 
<%
boolean islight=true ;
RecordSet.executeSql("select * from votingmaintdetail");
    
while(RecordSet.next()){
	String id=RecordSet.getString("id");
	String createrid=RecordSet.getString("createrid");
    String approverid=RecordSet.getString("approverid");
%> 
  <TR <%if(islight){%> class=datalight <%} else {%>class=datadark <%}%>>
  <td><%=ResourceComInfo.getResourcename(createrid)%></td>
  <td><%=ResourceComInfo.getResourcename(approverid)%></td>
  <td><a href="VotingMaintOperation.jsp?method=delete&id=<%=id%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>
  </tr>
<%
    islight=!islight ;
}
%>
</table>

                  
 <script LANGUAGE="JavaScript">        
 
 function goback(){
  window.open('VotingList.jsp','mainFrame','') ;
}
 
 function checksubmit(){
 	if(check_form(frmmain,'createrid,approverid')){	
 		frmmain.submit();	
 	}
 }    
 
  </script> 
</BODY></HTML>