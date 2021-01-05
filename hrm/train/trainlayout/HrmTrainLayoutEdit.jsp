<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%
Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                 	
String id = request.getParameter("id");	
int userid = user.getUID();
TrainLayoutComInfo tl = new TrainLayoutComInfo();

  String name = "";
  String typeid = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";
  String testdate = "";
  String assessor = "";
int errormsg = 1;
  String sql = "select * from HrmTrainLayout where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
     errormsg = 0;
     name = Util.null2String(rs.getString("layoutname"));
     typeid = Util.null2String(rs.getString("typeid"));
     startdate = Util.null2String(rs.getString("layoutstartdate"));
     enddate = Util.null2String(rs.getString("layoutenddate"));
     content = Util.null2String(rs.getString("layoutcontent"));
     aim = Util.null2String(rs.getString("layoutaim"));
     testdate = Util.null2String(rs.getString("layouttestdate"));
     assessor = Util.null2String(rs.getString("layoutassessor"));
  }    
 boolean bl = tl.isAssessor(userid,id);
 /*
  //Commented by Charoes Huang On May 30 For Bug 277,all user has right to view train layout
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)&&!bl){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
*/
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)&&today.equals(testdate)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16149,user.getLanguage())+",javascript:doinfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//if(bl || HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(6102,user.getLanguage())+",javascript:doassess(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//}
if(HrmUserVarify.checkUserRight("HrmTrainLayout:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+67+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayout.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<%if(errormsg == 1){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16157,user.getLanguage())%>
</div>
<%}%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	  <wea:item><%=name%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></wea:item>
	  <wea:item><%=TrainTypeComInfo.getTrainTypename(typeid)%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
	  <wea:item><%=startdate%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>          
	  <wea:item><%=enddate%></wea:item>            
	  <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
	  <wea:item><%=content%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
	  <wea:item><%=aim%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </wea:item>
	  <wea:item><%=testdate%></SPAN></wea:item>                      
	  <wea:item><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </wea:item>
	  <wea:item><%=ResourceComInfo.getMulResourcename(assessor)%>	</wea:item>	   
	</wea:group>
</wea:layout>
 </form>
<%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="dosave();">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
				</wea:item>
			</wea:group>
		</wea:layout>		
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub

sub onShowType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TraintypeBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	typeidspan.innerHtml = id(1)
	frmMain.typeid.value=id(0)
	else
	typeidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.typeid.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
  function dosave(){
    location="HrmTrainLayoutEditDo.jsp?id=<%=id%>";
  }
  function doinfo(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
      document.frmMain.operation.value="info";
      document.frmMain.submit();
    }
  }
  function doassess(){    
     location="TrainLayoutAssess.jsp?id=<%=id%>";
  }  
</script>
 
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
