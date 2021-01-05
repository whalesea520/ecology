<%@ page import="weaver.general.Util,weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%!
   /**
    * Added By Charoes Huang On May 20 ,2004
    * @param resourceid
    * @param comInfo
    * @return  the resource name string with hyper link
    */
   private String getRecourceLinkStr(String resourceid,ResourceComInfo comInfo){
       String linkStr ="";
       String[] resources =Util.TokenizerString2(resourceid,",");
       for(int i=0;i<resources.length;i++){
           linkStr += "<A href=\"/hrm/resource/HrmResource.jsp?id="+resources[i]+"\">"+comInfo.getResourcename(resources[i])+"</A>&nbsp;";
       }
       return linkStr;
   }
%>

<% if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>



<HTML><HEAD>
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}

function doSetValue(event,data,name){
	var result = eval(ajaxSubmit(encodeURI(encodeURI("/js/hrm/getdata.jsp?cmd=getHrmAward&id="+data.id))));
	if(result && result.length>0){
		for(var i=0;i<result.length;i++){
			document.hrmaward.rpexplain.value = result[i].description;
			document.hrmaward.rptransact.value = result[i].transact;
		}
	}
}
</script>
</HEAD>
<%
String rptitle = Util.null2String(request.getParameter("rptitle")); /*奖惩标题*/
String resourceid =    Util.null2String(request.getParameter("resourceid"));/*员工id*/
String rptypeid = Util.null2String(request.getParameter("rptypeid"));  /*奖惩种类*/
String rpdate = Util.null2String(request.getParameter("rpdate")) ;       /*奖惩日期*/	
String rpexplain = Util.null2String(request.getParameter("rpexplain")) ;	/*说明*/
String rptransact = "" ; 

if( ! rptypeid.equals("") ) {
    String sql="select transact from HrmAwardType where id="+rptypeid ;
    rs.executeSql(sql) ;
    if( rs.next() ) rptransact =  rs.getString("transact") ;/*相关处理*/
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6100,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=hrmaward id=hrmaward action="HrmAwardOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation value="add">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6100,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(15665,user.getLanguage())%></wea:item>
    <wea:item> 
      <INPUT class=InputStyle maxLength=30 style="WIDTH: 90%" name="rptitle" onchange='checkinput("rptitle","rptitlespan")' value="<%=rptitle%>">
      <SPAN id=rptitlespan><% if(rptitle.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
      </SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></wea:item>
    <wea:item> 
  		<brow:browser viewType="0"  name="resourceid" browserValue='<%=resourceid %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
       completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
       browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) %>'>
       </brow:browser>
    </wea:item>    
  <wea:item><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></wea:item>
  <wea:item> 
       <brow:browser viewType="0" id="rptypeid" name="rptypeid" browserValue='<%=rptypeid %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
       completeUrl="/data.jsp?type=HrmAwardType"width="120px"
       _callback="doSetValue"
       browserSpanValue='<%=Util.toScreen(AwardComInfo.getAwardName(rptypeid),user.getLanguage())%>'>
       </brow:browser>
 	</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></wea:item>
    <wea:item>
          <button class=Calendar type="button" id=selectbememberdate onClick="getHrmDate(rpdatespan, rpdate)"></button> 
          <input class=inputstyle type="hidden" name="rpdate" id="rpdate"  value="<%=rpdate%>">
          <span id=rpdatespan>
          <%=rpdate%>
          <% if(rpdate.equals("")) {%> <img src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
          </span> 
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(15667,user.getLanguage())%></wea:item>
    <wea:item> 
          <textarea class=InputStyle style="WIDTH: 90%" name=rpexplain rows=6 ><%=rpexplain%></textarea>
        </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></wea:item>
    <wea:item> 
          <textarea class=InputStyle style="WIDTH: 90%" name=rptransact rows=6 ><%=Util.StringReplace(rptransact,"<br>","\n")%></textarea>
     </wea:item>
	</wea:group>
</wea:layout>
 </FORM>
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
<script language=javascript>
function submitData() {
if(check_form(hrmaward,'rptitle,rptypeid,resourceid,rpdate')){
 hrmaward.submit();
}
}

function goPunishManagerBack(){
  
document.location.href="/hrm/award/HrmAward.jsp";

}

function onShowResource(inputname,spanname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+jQuery("input[name=resourceid]").val());
	if (data!=null){
		if (data.id!= ""){
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					//update by liaodong for qc57566 in 20131011 start
					 //sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+ids[i]+"'>"+names[i]+"</a>&nbsp;";
					 sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp;";
			       //end
				}
			}
			jQuery(inputname).val(data.id.substring(1,data.id.length));
			jQuery(spanname).html(sHtml);
		}else{
			jQuery(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery(inputname).val("0");
		}
	}
}

function onShowAwardTypeID(spanname, inputname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp");
	if (data!=null){
		if (data.id!= ""){
			jQuery(spanname).html(data.name);
			jQuery(inputname).val(data.id);
			document.hrmaward.action="HrmAwardAdd.jsp";
			document.hrmaward.submit();
		}else{
			jQuery(spanname).html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery(inputname).val("");
		}
	}
}
</script>
<!--
<script language=vbs>
  sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+hrmaward.resourceid.value)
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

sub onShowAwardTypeID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    document.hrmaward.action="HrmAwardAdd.jsp"
    document.hrmaward.submit()
	else
	spanname.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub
</script>
-->
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
