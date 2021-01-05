
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.Integer" %>
<%
	response.setHeader("Expires", "-1") ; // '将当前页面置为唯一活动的页面,必须关闭这个页面以后,其他的页面才能被激活
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<TITLE>Color</TITLE>
</HEAD>
<SCRIPT LANGUAGE="JavaScript">

function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function Cancel_onclick(){
   window.parent.parent.close();
}

function ColorTable_onclick(){
   var e = getEvent().srcElement ? getEvent().srcElement:getEvent().target;
   if (e.tagName == "TD"){
   	
      window.parent.parent.returnValue = Color.innerHTML;
      window.parent.parent.close();
   }
}

function ColorTable_onmouseover(){
   var el = getEvent().srcElement ? getEvent().srcElement:getEvent().target;
   if (el.tagName == "TD"){
   	
		var clr = "0000" + el.id;
		jQuery("#Info")[0].bgColor = clr.substr(clr.length-6);
		jQuery("#Color").html(clr.substr(clr.length-6));
        jQuery("#Text").html("#" + clr.substr(clr.length-6));
        el.borderColor = "black";
   }
}

function ColorTable_onmouseout(){
	var el = getEvent().srcElement ? getEvent().srcElement:getEvent().target;
    if (el.tagName == "TD"){
        el.borderColor = "white";
    }
}

function Clear_onclick(){
    window.parent.parent.returnValue = "";
      window.parent.parent.close();
}

jQuery(document).ready(function(){
	jQuery("#ColorTable").find("td").bind("click",ColorTable_onclick)
	jQuery("#ColorTable").find("td").bind("mouseover",ColorTable_onmouseover)
	jQuery("#ColorTable").find("td").bind("mouseout",ColorTable_onmouseout)
});
</SCRIPT>


<BODY>
<TABLE ID="ColorTable" STYLE="table-layout:fixed; cursor:pointer;" BORDER=3 BORDERCOLOR=white width="100%">
<% 
//Dim i, s, v
int iR=0; 
int iG=0; 
int iB=0;
int lColor=0;
String sColor="";
int iCol = 1;

int iBF=0;
int iBT=0;
int iBStep=0;

for(iG = 0;iG<= 2;iG++){
	if (iG == 1) { 
		for(iR=5;iR>=0;iR--){
		%>
		<tr>
		<%
			for(iB=0;iB<=5;iB++){
				String t1 = "00"+Integer.toHexString(iR*51);
				t1 = t1.substring(t1.length()-2,t1.length());
				String t2 =  "00"+Integer.toHexString((iG*2)*51);
				t2 = t2.substring(t2.length()-2,t2.length());
				String t3 =  "00"+Integer.toHexString(iB*51);
				t3 = t3.substring(t3.length()-2,t3.length());
				sColor=t1+t2+t3;
				%>
				<td bgcolor="#<%=sColor%>" id=<%=sColor%>><span style="font-size:8pt">&nbsp</span></td>
				<%
			}
			for(iB=5;iB>=0;iB--){
				String t1 = "00"+Integer.toHexString(iR*51);
				t1 = t1.substring(t1.length()-2,t1.length());
				String t2 =  "00"+Integer.toHexString(((iG*2)+1)*51);
				t2 = t2.substring(t2.length()-2,t2.length());
				String t3 =  "00"+Integer.toHexString(iB*51);
				t3 = t3.substring(t3.length()-2,t3.length());
				sColor=t1+t2+t3;
				%>
				<td bgcolor="#<%=sColor%>" id=<%=sColor%>><span style="font-size:8pt">&nbsp</span></td>
				<%
			}
		%>
		</tr>
		
		<%
		}
		%>
	<%	
	}
	else{
		for(iR=0;iR<=5;iR++){
		%>
		<tr>
		<%
			for(iB=0;iB<=5;iB++){
				String t1 = "00"+Integer.toHexString(iR*51);
				t1 = t1.substring(t1.length()-2,t1.length());
				String t2 =  "00"+Integer.toHexString((iG*2)*51);
				t2 = t2.substring(t2.length()-2,t2.length());
				String t3 =  "00"+Integer.toHexString(iB*51);
				t3 = t3.substring(t3.length()-2,t3.length());
				sColor=t1+t2+t3;
				%>
				<td bgcolor="#<%=sColor%>" id=<%=sColor%>><span style="font-size:8pt">&nbsp</span></td>
				<%
			}
			for(iB=5;iB>=0;iB--){
				String t1 = "00"+Integer.toHexString(iR*51);
				t1 = t1.substring(t1.length()-2,t1.length());
				String t2 =  "00"+Integer.toHexString(((iG*2)+1)*51);
				t2 = t2.substring(t2.length()-2,t2.length());
				String t3 =  "00"+Integer.toHexString(iB*51);
				t3 = t3.substring(t3.length()-2,t3.length());
				sColor=t1+t2+t3;
				%>
				<td bgcolor="#<%=sColor%>" id=<%=sColor%>><span style="font-size:8pt">&nbsp</span></td>
				<%
			}
		%>
		</tr>
		<%
		}
		%>
	<%
	}
}
%>
</TABLE>
<TABLE>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%>: </TD><TD id="Info" width=50px>&nbsp;&nbsp;&nbsp;&nbsp;</TD><TD id="Text"></TD>
</TR>
</TABLE>
<DIV CLASS=BtnBar>
<BUTTON CLASS=btn ID="Clear" type="button" onclick="Clear_onclick()"> <%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%> </BUTTON>
<BUTTON CLASS=btn ID="Cancel" type="button" onclick="Cancel_onclick()"> <%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%> </BUTTON><SPAN id=Color style="visibility: hidden"></SPAN>
</DIV>
</BODY>
</HTML>

