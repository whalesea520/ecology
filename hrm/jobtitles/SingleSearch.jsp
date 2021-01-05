<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

int uid=user.getUID();
String jobtitlesingle=(String)session.getAttribute("jobtitlesingle");
        if(jobtitlesingle==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
          //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
        jobtitlesingle=cks[i].getValue();
        break;
        }
        }
        }

String rem="1";
if(jobtitlesingle!=null)
   rem="1"+(jobtitlesingle.length()>0 ? jobtitlesingle.substring(1) : jobtitlesingle);
session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
String fromPage= Util.null2String(request.getParameter("fromPage")); //来自于那个页面的请求
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.parent.getParentWindow(parent.parent);
		dialog = parent.parent.parent.getDialog(parent.parent);
	}
	catch(e){}
</script>

</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.frame2.btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:parent.frame2.btnclear_onclick();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<button type="button" class=btnSearch accessKey=S style="display:none" id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<button type="button" class=btnReset accessKey=T style="display:none" type=reset ><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<button type="button" class=btnok accessKey=1 style="display:none" onclick="window.parent.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<button type="button" class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>
<%}%>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=jobtitlemark ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=jobtitlename ></wea:item>
		<%if(!fromPage.equals("add")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<brow:browser viewType="0" name="departmentid" browserValue="" 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp"
       hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
       completeUrl="/data.jsp?type=4">
       </brow:browser>
 <!-- 	   <INPUT class="wuiBrowser" id=departmentid type=hidden name=departmentid _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"> -->
	  </wea:item>	
		<%}%>
	</wea:group>
</wea:layout>

<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="suibian1" id="suibian1" >
	<!--########//Search Table End########-->
	</FORM>

<SCRIPT type="text/javascript">
function btnclear_onclick(){
  var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{
		window.parent.parent.returnValue = returnjson;
  	window.parent.parent.close();
	}
}
function btnsub_onclick(){
   $G("tabid").value = 1;
   $G("suibian1").value = 1;
   document.SearchForm.submit();
}
</SCRIPT>

</BODY>
</HTML>
