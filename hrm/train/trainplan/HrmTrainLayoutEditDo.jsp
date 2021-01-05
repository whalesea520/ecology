<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<html>
<%
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
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

  String sql = "select * from HrmTrainLayout where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
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
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6101,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 name="layoutname" value="<%=name%>" onchange='checkinput("layoutname","layoutnameimage")'>
          <SPAN id=layoutnameimage></SPAN>
          </td>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></TD>
          <TD class=Field>
            <BUTTON class=Browser onClick="onShowType()">
	    </BUTTON> 
	    <span class=inputstyle id=typeidspan><%=TrainTypeComInfo.getTrainTypename(typeid)%>
	    </span> 
	    <INPUT class=inputstyle id=typeid type=hidden name=typeid value="<%=typeid%>">           
          </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayoutstartdate onclick="getDate(layoutstartdatespan,layoutstartdate)"></BUTTON> 
            <SPAN id=layoutstartdatespan ><%=startdate%></SPAN> 
            <input class=inputstyle type="hidden" id="layoutstartdate" name="layoutstartdate" value="<%=startdate%>">            
          </td>
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>          
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayoutenddate onclick="getDate(layoutenddatespan,layoutenddate)"></BUTTON> 
            <SPAN id=layoutenddatespan ><%=enddate%></SPAN> 
            <input class=inputstyle type="hidden" id="layoutenddate" name="layoutenddate" value="<%=enddate%>">            
          </td>            
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 name=layoutcontent value="<%=content%>"><%=content%></textarea>
          </td>
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <textarea class=inputstyle cols=50 name=layoutaim value="<%=aim%>"><%=aim%></textarea>            
          </td>
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayouttestdatedate onclick="getDate(layouttestdatespan,layouttestdate)"></BUTTON> 
            <SPAN id=layouttestdatespan ><%=testdate%></SPAN> 
            <input class=inputstyle type="hidden" id="layouttestdate" name="layouttestdate" value="<%=testdate%>">            
          </td>                      
        </tr>          
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </td>
          <td class=Field>
	      <BUTTON class=Browser onClick="onShowResource(layoutassessor,layoutassessorspan)">
	      </BUTTON> 
	      <span class=inputstyle id=layoutassessorspan><%=ResourceComInfo.getMulResourcename(assessor)%>
	      </span> 
	      <INPUT class=inputstyle id=layoutassessor type=hidden name=layoutassessor value="<%=assessor%>">
	  </td>	   
        </tr>  
  <TR><TD class=Line colSpan=2></TD></TR> 
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
 </TBODY></TABLE>
 </form>
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
    if(check_form(document.frmMain,'layoutname')){
    document.frmMain.operation.value="edit";
    document.frmMain.submit();
    }
  }
  function dodelete(){
    if(confirm("Are you sure to delete?")){
      document.frmMain.operation.value="delete";
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
