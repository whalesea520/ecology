
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
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
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
String departmentmark=Util.null2String((String)session.getAttribute("departmentmark"));
String departmentname=Util.null2String((String)session.getAttribute("departmentname"));
int showorder= Util.getIntValue((String)session.getAttribute("showorder"),0);
int supdepid=Util.getIntValue((String)session.getAttribute("supdepid"),0);
String subcompanyid=Util.null2String((String)session.getAttribute("subcompanyid"));

session.removeAttribute("departmentmark");
session.removeAttribute("departmentname");
session.removeAttribute("showorder");
session.removeAttribute("supdepid");
session.removeAttribute("subcompanyid");

if(supdepid==0){
	 supdepid = Util.getIntValue(request.getParameter("supdepid"),0);
}
if("".equals(subcompanyid) || subcompanyid ==null){
	subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
}
/*Added by Charoes Huang ,For bug 517*/
String[] strObj = null ;
String errorMsg ="";
if("1".equals(Util.null2String(request.getParameter("message")))){
	try{	
		strObj = (String[])request.getSession().getAttribute("Department.level.error");
		if(strObj != null){
			errorMsg = SystemEnv.getHtmlLabelName(17428,user.getLanguage());
		}
	}catch(Exception e){}
}else{
	request.getSession().removeAttribute("Department.level.error");
}

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_TOP} " ;
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
<FORM id=frmmain name=frmmain action="DepartmentOperation.jsp" method=post>
   <input class=inputstyle type=hidden name=operation value="add">
   <INPUT id=subcompanyid1old type=hidden name=subcompanyid1old value="<%=subcompanyid%>">
 <%
if(msgid!=-1){
%>
<script type="text/javascript">
window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
</script>
<%}
 String needinputitems = "";
 if(!"".equals(errorMsg)){
		/*部门不能超过10级*/
		%>
		<script type="text/javascript">
window.top.Dialog.alert('<%=errorMsg%>');
</script>
   <%}%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<% 
	 HrmDeptFieldManager hfm = new HrmDeptFieldManager(5);
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
  		String fieldname = HrmFieldComInfo.getFieldname(fieldid);
  		if(!isuse.equals("1"))continue;
 			if(fieldname.equals("showid"))continue;
  		String fieldlabel = HrmFieldComInfo.getLabel(fieldid);
  		String fieldValue = "";
  	 //保存失败情况 记录修改时的情形
    	if(fieldname.equals("departmentmark") && departmentmark.length()>0){
    		fieldValue =departmentmark;
    	}
    	if(fieldname.equals("departmentname") && departmentname.length()>0){
    		fieldValue =departmentmark;
    	}
    	if(fieldname.equals("showorder") && showorder!=0){
    		fieldValue =""+showorder;
    	}
    	if(fieldname.equals("supdepid") && supdepid!=0){
    		fieldValue = ""+supdepid;
    	}
    	if(fieldname.equals("subcompanyid1") && subcompanyid.length()>0){
    		fieldValue =subcompanyid;
    	}
    	
    	if(HrmFieldComInfo.getIsmand(fieldid).equals("1")){
    		if(needinputitems.length()>0)needinputitems+=",";
    		needinputitems+=fieldname;
    	}
 			JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldid);
		  if(fieldname.equals("supdepid")){
			  String isMust = needinputitems.contains("supdepid")?"2":"1";
 				%>
 	 			<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
 				<wea:item>
 				  <brow:browser viewType="0" name="supdepid" browserValue='<%=""+supdepid %>' 
				 	getBrowserUrlFn="onShowDepartment"
		      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMust%>'
		      completeUrl="javascript:getDepartmentCompleteUrl()" width="165px"
		      browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+supdepid) %>'>
		      </brow:browser>	
 				</wea:item>
 	 		<%	
 			}else{
 			%>
		<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
		<wea:item>
			<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
		</wea:item>
		<%}}%>
	</wea:group>
	<%} %>
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
if(check_form(frmmain,'<%=needinputitems%>')){
 //frmmain.submit();
  StartUploadAll();
  checkuploadcomplet();
}
}

function changeValue(e,datas,name){
	jQuery("#subcompanyid1old").val(jQuery("#subcompanyid1").val());
}

function onShowDepartment(){
	var url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?allselect=all&notCompany=1&rightStr=HrmDepartmentAdd:Add&isedit=1&subcompanyid="+jQuery("input[name=subcompanyid1]").val()+"&selectedids="+jQuery("input[name=supdepid]").val();
	return url;		
}

function getDepartmentCompleteUrl(){
	var url= "/data.jsp?type=4";
			url+="&sqlwhere= subcompanyid1="+jQuery("input[name=subcompanyid1]").val();
	return url;		
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
