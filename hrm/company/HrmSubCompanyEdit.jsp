
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="org.json.JSONObject,ln.LN"%>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<jsp:useBean id="resourceManager" class="weaver.hrm.passwordprotection.manager.HrmResourceManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET/>
<link href="/js/swfupload/default_wev8.css" type="text/css" rel="stylesheet"/>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
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

int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+id);
String subcompanydesc = SubCompanyComInfo.getSubCompanydesc(""+id);
int companyid = Util.getIntValue(SubCompanyComInfo.getCompanyid(""+id),0);
String companyname = CompanyComInfo.getCompanyname(""+companyid);

String supsubcomid=SubCompanyComInfo.getSupsubcomid(""+id);
String url=SubCompanyComInfo.getUrl(""+id);
String showorder=SubCompanyComInfo.getShoworder(""+id);
if(msgid>0){
    supsubcomid=Util.null2String(request.getParameter("supsubcomid"));
	url=Util.null2String((String)session.getAttribute("url"));
	showorder=Util.null2String((String)session.getAttribute("showorder"));
	subcompanyname=Util.null2String((String)session.getAttribute("subcompanyname"));
	subcompanydesc=Util.null2String((String)session.getAttribute("subcompanydesc"));
	session.removeAttribute("url");
	session.removeAttribute("showorder");
	session.removeAttribute("subcompanyname");
	session.removeAttribute("subcompanydesc");

}
LN license = new LN();
license.CkHrmnum();
boolean isVs = !("1".equals(Tools.vString(license.getConcurrentFlag())));
int cntMem = resourceManager.count(0, id);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+companyname+"-"+subcompanyname;
String needfav ="1";
String needhelp ="";

String canceled = "";
String subcompanycode = "";
rs.executeSql("select canceled,subcompanycode from HrmSubCompany where id="+id);
if(rs.next()){
 canceled = rs.getString("canceled");
 subcompanycode = Util.null2String(rs.getString("subcompanycode"));
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);//是否分级管理
boolean isdftsubcom = false;//是否默认分部
int sublevel=0;
if(detachable==1){
	sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyEdit:Edit",id);
    rs.executeProc("SystemSet_Select","");
    while(rs.next()){
	    int dftsubcomid = rs.getInt("dftsubcomid");
	    if(dftsubcomid==id)isdftsubcom = true;
    }
}else{
    if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user))
        sublevel=2;
	if(id==1)isdftsubcom = true;	
}
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_parent} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
if(sublevel>1 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_parent} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	  	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}else{
     if(sublevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
	 }
}*/

if(sublevel>0 && false){//屏蔽掉分部编辑页面的分部日志
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=11 and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=11 and relatedid="+id+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmmain name=frmmain action="SubCompanyOperation.jsp" method=post>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=companyid value="<%=companyid%>">
 <input class=inputstyle type=hidden name=id value="<%=id%>">
<%
if(msgid!=-1){
%>
<script type="text/javascript">
window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
</script>
<%}
String needinputitems = "";
%>
<wea:layout type="2col">
	<% 
	 HrmDeptFieldManager hfm = new HrmDeptFieldManager(4);
	 hfm.getCustomData(id);
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
    	if(fieldname.equals("subcompanyname") && subcompanyname.length()>0){
    		fieldValue =subcompanyname;
    	}
    	if(fieldname.equals("subcompanydesc") && subcompanydesc.length()>0){
    		fieldValue =subcompanydesc;
    	}
    	if(fieldname.equals("showorder") && showorder.length()>0){
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
			fieldValue = fieldValue.equals("0") ? "" : fieldValue;
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
<script type="text/javascript">
var common = new MFCommon();
var isVs = "<%=isVs%>";
var cntMem = "<%=cntMem%>";
function onSave(){
  if(jQuery("input[name=supsubcomid]").val()==<%=id%>){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22214,user.getLanguage())%>");
     return false;
  }		
	if(check_form(document.frmmain,'<%=needinputitems%>')){
		var limitUsers = $GetEle("limitUsers");
		if(isVs == "true" && limitUsers!=null && Number(limitUsers.value) != 0){
			var cNum = Number(limitUsers.value);
			if(cNum < Number(cntMem)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81925,user.getLanguage())%>", function(){limitUsers.value = cntMem;});
				return false;
			}
			var result = eval(common.ajax("cmd=getSubcompanyLimitUsers&arg=<%=id%>"));
			var supid = "";
			var num = 0;
			var lNum = 0;
			var selfNum = 0;
			var supNum = 0;
			var allNum = 0;
			var subNum = 0;
			if(result && result.length > 0){
				for(var i=0;i<result.length;i++){
					supid = result[i].supid;
					num = Number(result[i].num);
					lNum = Number(result[i].lNum);
					selfNum = Number(result[i].selfNum);
					supNum = Number(result[i].supNum);
					allNum = Number(result[i].allNum);
					subNum = Number(result[i].subNum);
					break;
				}
			}
			if(supNum == 0){
				if(num - selfNum + cNum > lNum){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81924,user.getLanguage())%>");
					return false;
				}
			} else {
				if(cNum + allNum > supNum){
					if(supid == "0"){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81924,user.getLanguage())%>");
					} else {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82442,user.getLanguage())%>");
					}
					return false;
				}
			}
			if(cNum < subNum){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82446,user.getLanguage())%>");
				return false;
			}
		}
	var hasChecked = true;
	jQuery("img").each(function(){
		if(jQuery(this).attr("src")=="/images/BacoError_wev8.gif"){
			hasChecked = false;
			return false;
		}
	});
	if(!hasChecked){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
		return false;
	}
	
	 	document.frmmain.operation.value="editsubcompany";
		//document.frmmain.submit();
		//附件上传
    StartUploadAll();
    checkuploadcomplet();
	}
}
function onDelete(){
	if(<%=isdftsubcom%>){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(89,user.getLanguage())%>");
	}else{
		invoke(<%=id%>);
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
function check(o){
     if(o)
     	window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(88,user.getLanguage())%>");
     else{
       if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmmain.operation.value="deletesubcompany";
			document.frmmain.submit();
           }
     }
     return o;
 }
function invoke(id){

     Validator.subCompanyIsUsed(id,check) ;
 }
function encode(str){
    return escape(str);
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	            }else{
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22253, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
  }
}

 function doISCanceled(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	            } else {
	               window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24298, user.getLanguage())%>");
	               return;
	            }
            }catch(e){
                return false;
            }
        }
     }
   }
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
