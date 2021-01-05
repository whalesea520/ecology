<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
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
String rem="1"+jobtitlesingle.substring(1);
session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>

<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
	if(userightmenu_self == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<script>
		rightMenu.style.visibility='hidden';
	</script>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiSelect.jsp" method=post target="frame2">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="btnsearch_onclick()" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
			  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name="jobtitlemark" id="jobtitlemark" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name="jobtitlename" id="jobtitlename" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
     	<wea:item>
	      	<brow:browser viewType="0" name="departmentid" browserValue="" 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
	        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	        completeUrl="/data.jsp?type=4" browserSpanValue="">
	      	</brow:browser>
      </wea:item>
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="suibian1" id="suibian1" >
<input class=inputstyle type="hidden" name="jobtitles" >
</FORM>

<SCRIPT language="javascript">
var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(ex1){}
var jobtitles="";
var jobtitlesname="";

function btnsearch_onclick(){
	setJobStr() ;
	$("input[name=jobtitles]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
    $("input[name=tabid]").val(1);
	$GetEle("SearchForm").submit();
}
function reset_onclick(){
	_writeBackData('departmentid','1',{'id':'','name':''});
	$GetEle("jobtitlemark").value="";
	$GetEle("jobtitlename").value="";
}

function setJobStr(){
	
	var jobtitles1 ="";
	var jobtitlesname1="";
    try{
		for(var i=0;i<parent.frame2.resourceArray.length;i++){
			jobtitles1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;		
			jobtitlesname1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
		}
		jobtitles=jobtitles1;
		jobtitlesname=jobtitlesname1;
       }catch(err){}	
		
}

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

function btnclear_onclick(){
		var returnjson = {id:"",name:""};
		if(dialog){
			try{
	    	dialog.callback(returnjson);
	    }catch(e){}
	
			try{
		  	dialog.close(returnjson);
		 	}catch(e){}
		}else{
			window.parent.parent.returnValue = returnjson;
	    window.parent.parent.close();
		}
	}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}
	
function btncancel_onclick(){
	if(dialog){
	  	dialog.close();
	}else{
	   window.parent.parent.close();
	}
}
</SCRIPT>

</BODY>
</HTML>
