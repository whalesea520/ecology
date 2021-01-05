
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%@ page import="weaver.sms.SmsCache" %>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid=user.getUID();
String username = user.getUsername();
int userLength = username.length()+Util.null2String(String.valueOf(userid)).length()+3;
String hrmid = Util.null2String(request.getParameter("hrmid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String customernumber = Util.null2String(request.getParameter("customernumber"));
String hasHead = Util.null2String(request.getParameter("hasHead"));


	if(!HrmUserVarify.checkUserRight("CreateSMS:View", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
    }

	if(!"1".equals(hasHead)){
		response.sendRedirect("/sms/SmsMessageEditTab.jsp?"+request.getQueryString());
		return;
	}
	
//String sql = "select mobile from HrmResource where id= "+userid;
//rs.executeSql(sql);
//rs.next();
//String sendnumber=Util.toScreen(rs.getString("mobile"),user.getLanguage());
//发送者的手机号码，即登陆该系统的用户的手机号码，自动显示在发送人的是手机号一栏，可以更改
String id_hrm="";
String recievenumber_hrm="";
String name_hrm="";
if(!"".equals(hrmid)){
	String sql_1 = "select id,lastname,mobile  from HrmResource where id in( "+hrmid+")";
	rs_2.executeSql(sql_1);
	String temp_mobile="";
	String temp_id="";
	String temp_name="";
	while(rs_2.next()){
		temp_mobile=Util.null2String(rs_2.getString("mobile"));
		if("".equals(temp_mobile)) continue;
		temp_id=Util.null2String(rs_2.getString("id"));
		temp_name=Util.null2String(rs_2.getString("lastname"));
		
	    id_hrm+="".equals(id_hrm)?temp_id:","+temp_id;
	    recievenumber_hrm+="".equals(recievenumber_hrm)?temp_mobile:","+temp_mobile;
	    name_hrm+="".equals(name_hrm)?temp_name:","+temp_name;
	}
}
//当从人力资源的卡片上进入此页面时，自动生成员工的姓名和手机号码

String id_crm = "" ;
String recievenumber_crm="" ;
String fullname_crm="" ;
if(!"".equals(crmid)){
	String sql_2 = "select id ,fullname,mobilephone from CRM_CustomerContacter where id in(" +crmid+")";
	rs_1.executeSql(sql_2);
	String temp_mobile="";
	String temp_id="";
	String temp_name="";
	while(rs_1.next()){
		temp_mobile=Util.null2String(rs_2.getString("mobilephone"));
		if("".equals(temp_mobile)) continue;
		temp_id=Util.null2String(rs_2.getString("id"));
		temp_name=Util.null2String(rs_2.getString("fullname"));
		
		id_crm+="".equals(id_crm)?temp_id:","+temp_id;
		recievenumber_crm+="".equals(recievenumber_crm)?temp_mobile:","+temp_mobile;
		fullname_crm+="".equals(fullname_crm)?temp_name:","+temp_name;
	}
}
//当从客户卡片上的进入此界面时，自动生成客户的手机和姓名

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16444,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2083,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit(this)"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(16444,user.getLanguage())%></span>
	</span>
</div>
<FORM id=weaver name=weaver action="SmsMessageOperation.jsp" method=post >
  <input type="hidden" name="method" value="send">
  <input type="hidden" name="userid" value="userid">
  <input type="hidden" id="isdialog" name="isdialog" value="<%=isDialog %>">
  <input type="hidden" name="currentdate" value="currentdate">
  <%if(isgoveproj==1){ %>
  <input type="hidden" id=recievenumber2 name="recievenumber2" value="">
  <%} %>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
			  <%if(isgoveproj==0){%>
			  <%=SystemEnv.getHtmlLabelName(32926,user.getLanguage())%>
			  <%}else{%>
			  <%=SystemEnv.getHtmlLabelName(32927,user.getLanguage())%>
			  <%}%>
			</wea:item>
			<wea:item>
            <textarea class=InputStyle  style="width:100%;display:none" name=recievenumber1 id=recievenumber1 rows="4"><%=recievenumber_hrm%></textarea>
			<brow:browser viewType="0" name="hrmids02" browserValue='<%=id_hrm%>'  browserDialogWidth="700"
			browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" %>'
			hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'    _callbackParams=""
			completeUrl="/data.jsp?type=smsHrm" linkUrl="javascript:openhrm($id$)" 
			browserSpanValue='<%=name_hrm%>'></brow:browser>
				
			</wea:item>
		  <%if(isgoveproj==0){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(32928,user.getLanguage())%></wea:item>
			<wea:item>
            <textarea class=InputStyle  style="width:100%;display:none" name=recievenumber2 id=recievenumber2 rows= "4"><%=recievenumber_crm%></textarea>
            <brow:browser viewType="0" name="crmids02" browserValue='<%=id_crm %>' browserDialogWidth="700"
			browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/sms/MutiCustomerBrowser_sms.jsp?resourceids="%>'
			hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' _callback="crmCallBk" _callbackParams=""
			completeUrl="/data.jsp?type=smsCrm" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
			browserSpanValue='<%=fullname_crm %>'></brow:browser>

			</wea:item>
		  <%}%>
			<wea:item><%=SystemEnv.getHtmlLabelName(18538,user.getLanguage())%></wea:item>
			<wea:item>
              <textarea class=InputStyle  style="width:80%" name=customernumber  rows= "2"><%=customernumber %></textarea>
			</wea:item>

			<wea:item><%=SystemEnv.getHtmlLabelName(18529,user.getLanguage())%></wea:item>
			<wea:item>
			              <FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%> <B><SPAN id="wordsCount" name="wordsCount">0</SPAN></B> <%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%></FONT><br>
			  <TEXTAREA class=InputStyle style="width:80%;word-break:break-all" name=message rows="5" onchange='checkinput("message","messageimage")' onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this)></TEXTAREA>
              <SPAN id=messageimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
			
			</wea:item>
			
			<%if("1".equals(SmsCache.getSmsSet().getShowReply())){ %>
			<wea:item>&nbsp;
			</wea:item>
			<wea:item>
			<%=SystemEnv.getHtmlLabelName(18539,user.getLanguage())%>：<br>
			&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%> ID+R+<%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%> （<%=SystemEnv.getHtmlLabelName(18548,user.getLanguage())%>）<BR>
			<%=SystemEnv.getHtmlLabelName(18541,user.getLanguage())%>：<BR>
			&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18542,user.getLanguage())%>： <%=SystemEnv.getHtmlLabelName(18544,user.getLanguage())%>(86)<br>
			&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18543,user.getLanguage())%>： 86R <%=SystemEnv.getHtmlLabelName(18545,user.getLanguage())%>
			</wea:item>
			<%} %>
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
		var canSend=1;
function submitData() {
 if(check_form(frmMain,'name,description')){
	frmMain.submit();
 }
}
</script>
<script language=javascript>
function hrmCallBk(event,data,name,_callbackParams){
	if(data){
	    if(data.id!= ""){
	     $("#recievenumber1").val(data.mobile);
	     $("#"+name).val(data.id);
	    }else{
	       $("#"+name).text("");
	       $("#recievenumber1").val("");
	    }
   }
}

function crmCallBk(event,data,name,_callbackParams){
	if (data){
		if(data.id!="") {
			$("#recievenumber2").val(data.mobile);
			$("#"+name).val(data.id);
		}else{
			$("#recievenumber2").val("");
			$("#"+name).val("");
		}
	}
}

function trimComma(inStr){
	//dim(tmpArry,retStr);
	var retStr = "";
	tmpArry = inStr.split(",");
	for(var i=0;i<tmpArry.length;i++){
		if(tmpArry[i]!=""){
			retStr = retStr+","+tmpArry[i];
		}
	}
	if(retStr!=""){
		//trimComma = retStr.substr(1);
		return retStr.substr(1);
	}else{
		//trimComma = "";
		return "";
	}
}

function onShowMHrm(spanname,inputename){
  var tmpids = $G(inputename).value;
  var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiResourceMobilBrowser.jsp?resourceids="+tmpids);
  if(id1){
    if(id1.id!= ""){
     resourceids =id1.id;
     resourcename =id1.name;
     recievenumber1 =id1.name;
     
     retresourceids = "";
     retresourcename = "";
     retrecievenumber1 = ""

     sHtml = "";

     resourceids =resourceids.substr(1);
     resourcename =resourcename.substr(1);
     recievenumber1 =recievenumber1.substr(1);
     
     var ids=resourceids.split(",");
     var names=resourcename.split(",");
     for(var i=0;i<ids.length;i++){
        if(ids[i]!=""){
           var number=getNumber(names[i]);
           if(number!=""){
	           retresourceids =retresourceids+","+ids[i];
	           retresourcename = retresourcename+","+getName(names[i]);
	           retrecievenumber1 = retrecievenumber1+","+number;
	           sHtml = sHtml+"<a target='_blank' href=/hrm/resource/HrmResource.jsp?id="+ids[i]+">"+getName(names[i])+"</a>&nbsp;";
          }
        }   
     }
     $G(spanname).innerHTML = sHtml;
     $G("recievenumber1").value=trimComma(retrecievenumber1);
     $G(inputename).value= retresourceids;

    }else{
       $G(spanname).innerHTML ="";
       $G(inputename).value="";
       $G("recievenumber1").value="";
    }
   }
}




function onShowMCrm(spanname,inputename){
		var tmpids =$G(inputename).value;
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiCustomerBrowser_sms.jsp?resourceids="+tmpids);
			if (id1){
				if(id1.id!="") {
					resourceids =wuiUtil.getJsonValueByIndex(id1,0);
					resourcename =wuiUtil.getJsonValueByIndex(id1,1);
                    recievenumber2 =wuiUtil.getJsonValueByIndex(id1,2);
                    
                    retresourceids = "";
                    retresourcename = "";
                    retrecievenumber2 = "";

					sHtml = ""

					resourceids =resourceids.substr(1).split(",");
					resourcename =resourcename.substr(1).split(",");
                    recievenumber2 =recievenumber2.substr(1).split(",");

                    for(var i=0;i<resourceids.length;i++){
                        if(resourceids[i]!=""&&recievenumber2[i]!=""){
                        
                            retresourceids =retresourceids+","+resourceids[i];
                            retresourcename = retresourcename+","+resourcename[i];
                            retrecievenumber2 = retrecievenumber2+","+recievenumber2[i];
                            
                            sHtml = sHtml+"<a target='_blank' href=/CRM/data/ViewContacter.jsp?ContacterID="+resourceids[i]+">"+resourcename[i]+"</a>&nbsp;";
                        }
                    }
                    retrecievenumber2=retrecievenumber2.length>0?retrecievenumber2.substr(1):retrecievenumber2;
                    retresourceids=retresourceids.length>0?retresourceids.substr(1):retresourceids;
                    
					$G(spanname).innerHTML = sHtml;
					$G("recievenumber2").value=retrecievenumber2;
                    $G(inputename).value= retresourceids;
				}else{
					$G(spanname).innerHTML = "";
					$G("recievenumber2").value="";
                    $G(inputename).value="";
				}
		 }
}


function onKeyPressLength(objectname)
{
    objectvalue=document.all(objectname).value;
    if (objectvalue.length>=50)
    {
    window.event.keyCode=0;
    }
}


function checkMobileNumber(number1){
    var i;
    numberAry = number1.split(",");
    for(i=0; i<numberAry.length; i++){
        //alert(number1);
        //alert("i:"+i);
        //alert(numberAry[i]);
        var tempStr = numberAry[i].toString();
        if(tempStr==""){
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(22305,user.getLanguage())%>");
            return false;
        }
        if(!checkInteger(tempStr)){
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(22305,user.getLanguage())%>");
            return false;
        }
        //if(tempStr.length!=11){
          //  alert("号码长度必须是11位");
           // return false;
        //}
    }
    return true;
}

function checkInteger(integer){
    var i;
    for( i=0; i<integer.length; i++){
        //alert(integer.charAt(i).charCodeAt(0));
        var number = parseInt(integer.charAt(i).charCodeAt(0));
        if(!(number>=48&&number<=57)){
            return false;
        }
    }
    return true;
}


function onCheckForm1(objectname0,objectname1,objectname2,objectname3)
{
  if(!($G(objectname0).value=="")){
           if (($G(objectname1).value=="")&&($G(objectname2).value=="")&&($G(objectname3).value=="")){
               DialogAlert ("<%=SystemEnv.getHtmlLabelName(18963,user.getLanguage())%>") ;
               return false;
           }else if($G(objectname3).value!=""){

                if(checkMobileNumber($G(objectname3).value)){
                    return true;
                }else{
                    return false;
                }

           }else{
               return true;
           }
  }

  else {
      DialogAlert ("<%=SystemEnv.getHtmlLabelName(18962,user.getLanguage())%>");
      return false;
  }
}

function DialogAlert(msg){
	if(window.top){
		window.top.Dialog.alert (msg);
	}else{
		Dialog.alert (msg);
	}
}
</script>
<script language="javascript">
function printStatistic(o)
{
	setTimeout(function()
	{
		var inputLength = o.value.length;
		jQuery("#wordsCount").html(inputLength);
	}
	,1)
}


function doSubmit(obj)
{
	if (canSend==1&&onCheckForm1("message","hrmids02","recievenumber2","customernumber")){
        //document.all("recievenumber2").value=document.all("recievenumber2").value;
        canSend=0;
		obj.disabled=true;
		document.weaver.submit();
    }
}

function checklength(){
    if(jQuery("input[name=message]").val()!=""){
        //alert(getLength(document.all("message").value));
        if(jQuery("input[name=message]").val().length>60){
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(18964,user.getLanguage())%>");
            return false;
        }
    }
    return true;
}

function cutString(str,goLen){
    var len = 0;
    var temStr = str;
    for(var i=0; i<temStr.length; i++){
        if(temStr.charCodeAt(i)>256){
            len++;
            len++;
        }else{
            len++;
        }
        if(i>goLen){
            return temStr.subString(0,i);
        }
    }
    return temStr;
}

function getLength(str){
    var len = 0;
    var temStr = str;
    for(var i=0; i<temStr.length; i++){
        if(temStr.charCodeAt(i)>256){
            len++;
            len++;
        }else{
            len++;
        }
    }
    return len;
}

function getName(str){
    re=new RegExp("<.*>","g")
    str1= str.replace(re,"")
    return str1
}
function getNumber(str){
    if(str.indexOf("<")<0)
    return ""
    re=new RegExp(".*<","g")
    str1=str.replace(re,"")
    re=new RegExp(">","g")
    str2=str1.replace(re,"")
    return str2
}

function preDo(){
	//tabSelectChg();
	if(jQuery("#isdialog").val()=="1")return;
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
}

</script>
</BODY>
</HTML>
