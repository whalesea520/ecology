<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%

if(!HrmUserVarify.checkUserRight("CptCapital:MoveIn", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String capitalid = request.getParameter("capitalid");

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=weaver name=frmain method=post onSubmit="onSubmit()">
<DIV class=HdrProps></DIV>
  <BUTTON type="button" class=btnSave accessKey=S onclick="onSubmit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(1376,user.getLanguage())%></BUTTON> <BUTTON type="button" class=btn accessKey=B onclick='window.history.back(-1)'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></BUTTON> 
  <TABLE class=form>
    <COLGROUP> <COL width="15%"> <COL width="85%"> <TBODY> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
      <td class=Field> 
        <input class=saveHistory 
            maxlength=10 size=10 name="capitalnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum");checkinput("capitalnum","capitalnumimage")'>
        <span id=capitalnumimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span> 
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1410,user.getLanguage())%></td>
      <td class=Field><button type="button" class=Calendar id=selectmoveindate onClick="getmoveinDate()"></button> 
        <span id=moveindatespan ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span> 
        <input type="hidden" name="moveindate">
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
      <td class=Field><button type="button" class=Browser id=SelectUseRequest onClick="onShowUseRequest()"></button> 
        <span 
            id=userequestspan></span> 
        <input class=saveHistory id=userequest type=hidden name=userequest>
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
      <td class=Field colspan=2> 
        <textarea class="saveHistory"  style="width:100%" name=remark rows="6"></textarea>
      </td>
    </tr>
    <input type="hidden" name=capitalid value=<%=capitalid%>>
    </TBODY> 
  </TABLE>
 </form>
 <script language=vbs>
sub onShowUseRequest()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	userequestspan.innerHtml = id(1)
	frmain.userequest.value=id(0)
	else 
	userequestspan.innerHtml = ""
	frmain.userequest.value=""
	end if
	end if
end sub

</script>
 <script language="javascript">
 function onSubmit(){
 	if(check_form(document.frmain,'capitalnum,moveindate')){
		if(document.frmain.capitalnum.value<=0){
			alert("<%=SystemEnv.getHtmlLabelName(15303,user.getLanguage())%>");
            return;
		}
		document.frmain.action="CapitalMoveInOperation.jsp"
		document.frmain.submit();
	}
 }
 </script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
