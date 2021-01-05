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
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
String id = request.getParameter("id");	
int userid = user.getUID();
TrainLayoutComInfo tl = new TrainLayoutComInfo();

/*Add by Huang Yu ,Check if trainLayout has been used by train plan*/
   boolean canDelete =true;
   if(!id.equals("")){
       String sqlstr ="Select count(ID) as Count FROM HrmTrainPlan WHERE layoutid = "+id;
       rs.executeSql(sqlstr);
       rs.next();
       if(rs.getInt("Count") > 0 ){
           canDelete = false;
       }
   }

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
     content = Util.toScreenToEdit(rs.getString("layoutcontent"),user.getLanguage());
     aim = Util.toScreenToEdit(rs.getString("layoutaim"),user.getLanguage());
     testdate = Util.null2String(rs.getString("layouttestdate"));
     assessor = Util.null2String(rs.getString("layoutassessor"));
  }
 
    
 boolean bl = tl.isAssessor(userid,id);
 
 String isclose = Util.null2String(request.getParameter("isclose"));
 String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	  <wea:item><input class=inputstyle type=text size=30 name="layoutname" value='<%=name%>' onchange='checkinput("layoutname","layoutnameimage")'>
	  	<SPAN id=layoutnameimage></SPAN>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></wea:item>
	  <wea:item>
      <brow:browser viewType="0" name="typeid" browserValue='<%=typeid%>'
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/traintype/TrainTypeBrowser.jsp?selectedids="
        hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2' _callback="jsGetTypeData"
        completeUrl="/data.jsp?type=HrmTrainType" width="120px" browserSpanValue='<%=TrainTypeComInfo.getTrainTypename(typeid)%>'>
      </brow:browser>         
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectlayoutstartdate onclick="getDate(layoutstartdatespan,layoutstartdate)"></BUTTON> 
      <SPAN id=layoutstartdatespan ><%=startdate%></SPAN> 
      <input class=inputstyle type="hidden" id="layoutstartdate" name="layoutstartdate" value="<%=startdate%>">            
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>          
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectlayoutenddate onclick="getDate(layoutenddatespan,layoutenddate)"></BUTTON> 
      <SPAN id=layoutenddatespan ><%=enddate%></SPAN> 
      <input class=inputstyle type="hidden" id="layoutenddate" name="layoutenddate" value="<%=enddate%>">            
    </wea:item>            
    <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
    <wea:item>
      <textarea class=inputstyle cols=50 rows=4 id=layoutcontent name=layoutcontent value="<%=content%>"><%=content%></textarea>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
    <wea:item>
      <textarea class=inputstyle cols=50 rows=4 id=layoutaim name=layoutaim value="<%=aim%>"><%=aim%></textarea>          
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </wea:item>
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectlayouttestdatedate onclick="getDate(layouttestdatespan,layouttestdate)"></BUTTON> 
      <SPAN id=layouttestdatespan ><%=testdate%></SPAN> 
      <input class=inputstyle type="hidden" id="layouttestdate" name="layouttestdate" value="<%=testdate%>">            
    </wea:item>                      
    <wea:item><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </wea:item>
    <wea:item>
     <brow:browser viewType="0" name="layoutassessor" browserValue='<%=assessor%>'
       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
       hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
       completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="240px" 
       browserSpanValue='<%=ResourceComInfo.getMulResourcename1(assessor)%>'>
     </brow:browser>
	  </wea:item>	   
	</wea:group>
</wea:layout>
 </form>
<%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TrainTypeBrowser.jsp")
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
    if(check_formM(document.frmMain,'layoutname,typeid,layoutassessor')&&checkDateRange(frmMain.layoutstartdate,frmMain.layoutenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")){
    document.frmMain.operation.value="edit";
    document.frmMain.submit();
    }
  }
   function check_formM(thiswins,items){
	thiswin = thiswins
	items = ","+items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="layoutassessor"){
		if(tmpvalue == 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}
  function dodelete(){
     <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.frmMain.operation.value = "delete";
      document.frmMain.submit();
    }
	<%}else{%>
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
  }
  function doassess(){    
     location="TrainLayoutAssess.jsp?id=<%=id%>";
  }  
  
  function jsGetTypeData(e, datas, name){
	var typeid = datas.id;
	
	jQuery.getJSON('/hrm/ajaxData.jsp',{'cmd':'traintype','typeid':typeid},function(data){ 
		jQuery("#layoutcontent").val(data.typecontent)
		jQuery("#layoutaim").val(data.typeaim)
  })
}
</script>
<%@include file="/hrm/include.jsp"%>
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
