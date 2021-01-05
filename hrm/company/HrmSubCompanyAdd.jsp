
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="org.json.JSONObject,ln.LN"%>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<jsp:useBean id="resourceManager" class="weaver.hrm.passwordprotection.manager.HrmResourceManager" scope="page" />

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/swfupload/default_wev8.css" type="text/css" rel="stylesheet"/>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script type="text/javascript" src="/js/hrm/hrmswfupload_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
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
String cmd = Util.null2String(request.getParameter("cmd"));
int id = Util.getIntValue(request.getParameter("id"),0);
int companyid = Util.getIntValue(request.getParameter("companyid"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

int supsubcomid= Util.getIntValue(request.getParameter("supsubcomid"),0);
if(supsubcomid ==0){
	supsubcomid = Util.getIntValue(request.getParameter("id"),0);
}
LN license = new LN();
boolean isVs = !("1".equals(Tools.vString(license.getConcurrentFlag())));
int cntMem = 0;
//String url=Util.null2String(request.getParameter("url"));
//int showorder=Util.getIntValue(request.getParameter("showorder"),0);
//String subcompanyname = Util.null2String(request.getParameter("subcompanyname"));
//String subcompanydesc = Util.null2String(request.getParameter("subcompanydesc"));
String url=Util.null2String((String)session.getAttribute("url"));
int showorder=Util.getIntValue((String)session.getAttribute("showorder"),0);
String subcompanyname=Util.null2String((String)session.getAttribute("subcompanyname"));
String subcompanydesc=Util.null2String((String)session.getAttribute("subcompanydesc"));
session.removeAttribute("url");
session.removeAttribute("showorder");
session.removeAttribute("subcompanyname");
session.removeAttribute("subcompanydesc");
%>
<BODY>
<%
if(msgid!=-1){
%>
<script type="text/javascript">
window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
</script>
<%}%>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<%
String needinputitems = "";
%>
<FORM id=frmmain name=frmmain action="SubCompanyOperation.jsp" method=post>
<input class=inputstyle type="hidden" name=companyid value="<%=companyid%>">
<input class=inputstyle type="hidden" name=operation value=addsubcompany>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<% 
	 HrmDeptFieldManager hfm = new HrmDeptFieldManager(4);
	 List lsGroup = hfm.getLsGroup();
	 for(int tmp=0;lsGroup!=null&&tmp<lsGroup.size();tmp++){
   	String groupid = (String)lsGroup.get(tmp);
  	List lsField = hfm.getLsField(groupid);
  	if(lsField.size()==0)continue;
  	if(hfm.getGroupCount(lsField)==0)continue;
  	String grouplabel = HrmGroupComInfo.getLabel(groupid);
   	%>
   	<wea:group context='<%=SystemEnv.getHtmlLabelName(Integer.parseInt(grouplabel),user.getLanguage())%>' >	
   	<%
  	for(int j=0;lsField!=null&&j<lsField.size();j++){
  		String fieldid = (String)lsField.get(j);
  		String isuse = HrmFieldComInfo.getIsused(fieldid);
  		if(!isuse.equals("1"))continue;
  		String fieldlabel = HrmFieldComInfo.getLabel(fieldid);
  		String fieldname = HrmFieldComInfo.getFieldname(fieldid);
  		String fieldValue = "";
  		if(fieldname.equals("subcompanyname") && subcompanyname.length()>0){
    		fieldValue =subcompanyname;
    	}
    	if(fieldname.equals("subcompanydesc") && subcompanydesc.length()>0){
    		fieldValue =subcompanydesc;
    	}
    	if(fieldname.equals("showorder") && showorder!=0){
    		fieldValue =""+showorder;
    	}
    	if(fieldname.equals("url") && url.length()>0){
    		fieldValue = ""+url;
    	}
  		if(fieldname.equals("supsubcomid")) fieldValue = ""+supsubcomid;
    	if(HrmFieldComInfo.getIsmand(fieldid).equals("1")){
    		if(needinputitems.length()>0)needinputitems+=",";
    		needinputitems+=fieldname;
    	}
		if("84".equals(fieldid)){
			if(user.getUID() != 1) continue;
		}
 			JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldid);
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
		<wea:item>
			<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
		</wea:item>
		<%} %>
	</wea:group>
	<%} %>
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
<script language=javascript>
var common = new MFCommon();
var isVs = "<%=isVs%>";
var isCheckSc = "<%=supsubcomid==0%>";
var cntMem = "<%=cntMem%>";
function submitData() {
 if(check_form(frmmain,'<%=needinputitems%>')){
	var limitUsers = $GetEle("limitUsers");
	if(isVs == "true" && limitUsers!=null && Number(limitUsers.value) != 0){
		var cNum = Number(limitUsers.value);
		if(cNum < Number(cntMem)){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81925,user.getLanguage())%>", function(){limitUsers.value = cntMem;});
			return false;
		}
		var result = eval(common.ajax("cmd=getSubcompanyLimitUsers&arg=<%=id%>"));
		var supid = "";
		var supNum = 0;
		var allNum = 0;
		var subNum = 0;
		if(result && result.length > 0){
			for(var i=0;i<result.length;i++){
				supid = result[i].supid;
				supNum = Number(result[i].supNum);
				allNum = Number(result[i].allNum);
				subNum = Number(result[i].subNum);
				break;
			}
		}
		if(cNum + subNum > allNum && isCheckSc == "false"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82442,user.getLanguage())%>");
			return false;
		}
	}
	if(isCheckSc == "true"){
		var result = common.ajax("cmd=getLnScCount&arg=mf");
		if(result == "false"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82488,user.getLanguage())%>");
			return false;
		}
	}
 //frmmain.submit();
    StartUploadAll();
    checkuploadcomplet();
 }
}
function showSpan(id, name){
	if(id !== "84") return;
	var span = $GetEle(name);
	if(span) {
		span.innerHTML = "<strong><%=SystemEnv.getHtmlLabelName(81923,user.getLanguage())+cntMem%></strong>";
		span.style.display = "";
	}
}
function hideSpan(id, name){
	if(id !== "84") return;
	var span = $GetEle(name);
	if(span) span.style.display = "none";
}
function onShowMeetingHrm(spanname,inputename){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
	    if(datas){
	        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
		         	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>");
					return;
			 }else if(datas.id){
				resourceids = datas.id;
				resourcename =datas.name;
				sHtml = "";
				resourceids=resourceids.substr(1);
				resourceids =resourceids.split(",");
				$GetEle(inputename).value= resourceids.indexOf(",")==0?resourceids.substr(1):resourceids;
				resourcename =resourcename.substr(1);
				resourcename =resourcename.split(",");
				for(var i=0;i<resourceids.length;i++){
					if(resourceids[i]&&resourcename[i]){
						//sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"  target=_blank>"+resourcename[i]+"</a>&nbsp"
						sHtml = sHtml+"<a href='javaScript:openhrm("+resourceids[i]+");' onclick='pointerXY(event);'>"+resourcename[i]+"</a>&nbsp"
					}
				}
				//$("#"+spanname).html(sHtml);
				//$($GetEle(spanname)).html(sHtml);
				jQuery("#"+spanname).html(sHtml);
	        }else{
				$GetEle(inputename).value="";
				//$($GetEle(spanname)).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				jQuery("#"+spanname).html("");
	        }
	    }
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
