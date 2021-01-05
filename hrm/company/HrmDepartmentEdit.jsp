
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
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
<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
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

 function filedel(obj,fileid, fieldname){
 	jQuery(obj).parent().parent().remove();
 	//删除附件
	jQuery.ajax({
	type:'post',
	url:'/hrm/resource/hrmuploaderOperate.jsp',
	data:{"cmd":"delete","fileId":fileid,"fieldname":fieldname,"scopeid":jQuery("#scopeid").val()},
	dataType:'text',
	success:function(fieldvalue){
	 	jQuery("#"+fieldname).val(fieldvalue);
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461, user.getLanguage())%>");
	},
	error:function(){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462, user.getLanguage())%>");
	}
	});
 }
</script>
</head>
<%
int departid = Util.getIntValue(request.getParameter("id"),1);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
rs.executeProc("HrmDepartment_SelectByID",""+departid);
String departmentmark="";
String departmentname="";
String subcompanyid1="";
String allsupdepid = "";
int supdepid = 0;
int showorder = 0;
String departmentcode = "";   
if(rs.next()){
	departmentmark = rs.getString(2);
	departmentname = rs.getString(3);
	supdepid = Util.getIntValue(rs.getString("supdepid"),0);
	allsupdepid = rs.getString("allsupdepid");
	subcompanyid1 = rs.getString("subcompanyid1");
	showorder = Util.getIntValue(rs.getString("showorder"),0);
	departmentcode = Util.toScreen(rs.getString("departmentcode"),user.getLanguage());
}
if(msgid>0){
    departmentmark=Util.null2String((String)session.getAttribute("departmentmark"));
    departmentname=Util.null2String((String)session.getAttribute("departmentname"));
	showorder= Util.getIntValue((String)session.getAttribute("showorder"));
	supdepid=Util.getIntValue((String)session.getAttribute("supdepid"));
	subcompanyid1=Util.null2String((String)session.getAttribute("subcompanyid"));

	session.removeAttribute("departmentmark");
	session.removeAttribute("departmentname");
	session.removeAttribute("showorder");
	session.removeAttribute("supdepid");
	session.removeAttribute("subcompanyid");
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int deplevel=0;
if("".equals(subcompanyid1)) subcompanyid1 = "0";
if(detachable==1){
    deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmDepartmentAdd:Add",Integer.parseInt(subcompanyid1));
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user))
        deplevel=2;
}
if(subcompanyid1.equals("0"))
subcompanyid1="";
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = departmentname+","+departmentmark;
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
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=frmmain action="DepartmentOperation.jsp" method=post>
   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=departid%>">
   <input type=hidden name=allsupdepid value="<%= allsupdepid%>">
   <!-- 
   <INPUT id=subcompanyid1 type=hidden name=subcompanyid1 value="<%=subcompanyid1%>">
    -->
	 <INPUT id=subcompanyid1old type=hidden name=subcompanyid1old value="<%=subcompanyid1%>">
	   <input class=inputstyle type=hidden id=scopeid  name=scopeid value="<%=5%>">
<%
if(msgid!=-1){
%>
<script type="text/javascript">
window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
</script>
<%}%>
	<%
		String message = Util.null2String(request.getParameter("message"));
		if("1".equals(message)){
	%>
	<script type="text/javascript">
window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(17428,user.getLanguage())%>');
</script>
	<%}
		 String needinputitems = "";
	%>
	<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
		<% 
	 HrmDeptFieldManager hfm = new HrmDeptFieldManager(5);
	 hfm.getCustomData(departid);
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
  		String fieldname = HrmFieldComInfo.getFieldname(fieldid);
  		String fieldlabel = HrmFieldComInfo.getLabel(fieldid);
  		String fieldValue = hfm.getData(fieldname);
  		
    	//保存失败情况 记录修改时的情形
    	if(fieldname.equals("departmentmark") && departmentmark.length()>0){
    		fieldValue =departmentmark;
    	}
    	if(fieldname.equals("departmentname") && departmentname.length()>0){
    		fieldValue =departmentname;
    	}
    	if(fieldname.equals("showorder") && showorder!=0){
    		fieldValue =""+showorder;
    	}
    	if(fieldname.equals("supdepid") && supdepid!=0){
    		fieldValue = ""+supdepid;
    	}
    	if(fieldname.equals("subcompanyid1") && subcompanyid1.length()>0){
    		fieldValue =subcompanyid1;
    	}
    	
    	if(HrmFieldComInfo.getIsmand(fieldid).equals("1")){
    		if(needinputitems.length()>0)needinputitems+=",";
    		needinputitems+=fieldname;
    	}
 			JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldid);
 			if(fieldname.equals("showid")){
 				%>
 			<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
			<wea:item><%=departid%></wea:item>
 				<%
 				continue;
 			}else if(fieldname.equals("supdepid")){
				String isMust = needinputitems.contains("supdepid")?"2":"1";
 				%>
 	 			<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
 				<wea:item>
 				  <brow:browser viewType="0" name="supdepid" browserValue='<%= fieldValue %>' 
				 	getBrowserUrlFn="onShowDepartment"
		      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMust%>'
		      completeUrl="javascript:getDepartmentCompleteUrl()" width="165px"
		      browserSpanValue='<%=DepartmentComInfo.getDepartmentname(fieldValue)%>'>
		      </brow:browser>	
 				</wea:item>
 	 		<%	
 			}else{
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
		<wea:item>
			<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
		</wea:item>
		<%} }%>
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
 function onSave(){
   if(jQuery("input[name=supdepid]").val()==<%=departid%>){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15773,user.getLanguage())%>");
   }else{
   	var hasChecked = true;
	jQuery("img").each(function(){
		if(jQuery(this).attr("src")=="/images/BacoError_wev8.gif"){
			hasChecked = false;
			return false;
		}
	});
	if(!hasChecked){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");;
		return false;
	}
	
 	if(check_form(document.frmmain,'<%=needinputitems%>')){
 		document.frmmain.operation.value="edit";
		//document.frmmain.submit();
		//附件上传
    StartUploadAll();
    checkuploadcomplet();
	}
 }
 }
 function onDelete(){
     invoke(<%=departid%>);

}
function check(o){
     if(o)
     window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83471,user.getLanguage())%>') ;
     else{
       if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmmain.operation.value="delete";
			document.frmmain.submit();
           }
     }
     return o;
 }
function invoke(id){

     Validator.departmentIsUsed(id,check) ;
 }
function encode(str){
    return escape(str);
}

function changeValue(){
	jQuery("#subcompanyid1old").val(jQuery("#subcompanyid1").val());
}

function onShowDepartment(){
	var url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?deptlevel=10&notCompany=1&excludeid=<%=departid%>&rightStr=HrmDepartmentEdit:Edit&isedit=1&subcompanyid="+jQuery("input[name=subcompanyid1old]").val()+"&selectedids="+jQuery("input[name=supdepid]").val();
	return url;		
}

function getDepartmentCompleteUrl(){
	var url= "/data.jsp?type=4";
			url+="&sqlwhere= subcompanyid1="+jQuery("input[name=subcompanyid1]").val();
	return url;		
}

function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmSubCompanyEdit:Edit&isedit=1&selectedids="+jQuery("input[name=subcompanyid1]").val());
	issame = false;
	if (data!=null){
		if (data.id!= ""){
			if (data.id == jQuery("input[name=subcompanyid1]").val()){
				issame = true;
			}
			jQuery("#subcompanyspan").html(data.name);
			jQuery("input[name=subcompanyid1]").val(data.id);
		}else{
			jQuery("#subcompanyspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=subcompanyid1]").val("");
		}
	}
	if (jQuery("input[name=subcompanyid1old]").val() != jQuery("input[name=subcompanyid1]").val()){
		jQuery("#departmentspan").html("");
		jQuery("input[name=departmentid]").val("");
	}

	jQuery("input[name=subcompanyid1old]").val(jQuery("input[name=subcompanyid1]").val());
}

function jsSubCompanyChange(e,datas,name){
jQuery("input[name=subcompanyid1old]").val(datas.id);
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
</BODY></HTML>
