<%@page import="weaver.systeminfo.label.LabelComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/e8Common_wev8.js"></script>
<script type="text/javascript">
/*
function onBtnSearchClick(){
  document.frmMain.action="/system/ModuleManageDetach.jsp";
	jQuery("#frmMain").submit();
}
*/
</script>
</head>
<%
boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24326,user.getLanguage()) ;//管理设置
String needfav ="1";
String needhelp ="";

if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String qname = Util.null2String(request.getParameter("flowTitle"));

String detachable= "";
String hrmdetachable= "";
String wfdetachable= "";
String docdetachable= "";
String portaldetachable= "";
String cptdetachable= "";
String mtidetachable= "";
String wcdetachable= "";
String fmdetachable= "";
String mmdetachable= "";
String carsdetachable= "";

int dftsubcomid= 0;
int hrmdftsubcomid= 0;
int wfdftsubcomid= 0;
int docdftsubcomid= 0;
int portaldftsubcomid= 0;
int cptdftsubcomid= 0;
int mtidftsubcomid= 0;
int wcdftsubcomid= 0;
int fmdftsubcomid= 0;
int mmdftsubcomid= 0;
int carsdftsubcomid= 0;

RecordSet.executeProc("SystemSet_Select","");
if(RecordSet.next()){
	detachable= Util.null2String(RecordSet.getString("detachable"));
	hrmdetachable= Util.null2String(RecordSet.getString("hrmdetachable"));
	wfdetachable= Util.null2String(RecordSet.getString("wfdetachable"));
	docdetachable= Util.null2String(RecordSet.getString("docdetachable"));
	portaldetachable= Util.null2String(RecordSet.getString("portaldetachable"));
	cptdetachable= Util.null2String(RecordSet.getString("cptdetachable"));
	mtidetachable= Util.null2String(RecordSet.getString("mtidetachable"));
	wcdetachable= Util.null2String(RecordSet.getString("wcdetachable"));
	fmdetachable= Util.null2String(RecordSet.getString("fmdetachable"));
	mmdetachable= Util.null2String(RecordSet.getString("mmdetachable"));
	carsdetachable= Util.null2String(RecordSet.getString("carsdetachable"));
	
	dftsubcomid=Util.getIntValue(RecordSet.getString("dftsubcomid"),0);
	hrmdftsubcomid=Util.getIntValue(RecordSet.getString("hrmdftsubcomid"),0);
	wfdftsubcomid=Util.getIntValue(RecordSet.getString("wfdftsubcomid"),0);
	docdftsubcomid=Util.getIntValue(RecordSet.getString("docdftsubcomid"),0);
	portaldftsubcomid=Util.getIntValue(RecordSet.getString("portaldftsubcomid"),0);
	cptdftsubcomid=Util.getIntValue(RecordSet.getString("cptdftsubcomid"),0);
	mtidftsubcomid=Util.getIntValue(RecordSet.getString("mtidftsubcomid"),0);
	wcdftsubcomid=Util.getIntValue(RecordSet.getString("wcdftsubcomid"),0);
	fmdftsubcomid=Util.getIntValue(RecordSet.getString("fmdftsubcomid"),0);
	mmdftsubcomid=Util.getIntValue(RecordSet.getString("mmdftsubcomid"),0);
	carsdftsubcomid=Util.getIntValue(RecordSet.getString("carsdftsubcomid"),0);
}
//System.out.println(">>>>>>>>>>>>>>>>>>>>qname="+qname);
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" id="frmMain" name=frmMain method=post action="/system/SystemSetOperation.jsp">


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
	
		

<input type="hidden" name=operation  value="detachmanagement">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33174,user.getLanguage())%>' >
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=detachable name=detachable  value="1" tzCheckbox="true" <% if(detachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>  onClick="formCheckAll(false);">
   </wea:item>
   <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
	 	<brow:browser viewType="0" id="dftsubcomid" name="dftsubcomid" browserValue='<%=""+dftsubcomid%>'  
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
      browserSpanValue='<%=dftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+dftsubcomid):""%>'>
    </brow:browser>&nbsp;&nbsp;
    <input type="button" class="e8_btn_top" id="btn_dftsubcomid" value="<%=SystemEnv.getHtmlLabelName(33901,user.getLanguage()) %>" onclick="jsSynSubCompany()">
	 </wea:item>  
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("24326,68",user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}">
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" name=hrmdetachable id=hrmdetachable  value="1" tzCheckbox="true" <% if(hrmdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('hrmdetachable','hrmdftsubcomid','hrmsupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="hrmdftsubcomid" name="hrmdftsubcomid" browserValue='<%=""+hrmdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=hrmdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+hrmdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>
         
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=wfdetachable name=wfdetachable  value="1" tzCheckbox="true" <% if(wfdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('wfdetachable','wfdftsubcomid','wfsupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="wfdftsubcomid" name="wfdftsubcomid" browserValue='<%=""+wfdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=wfdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+wfdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>        
 
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(26268,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=docdetachable name=docdetachable  value="1" tzCheckbox="true" <% if(docdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('docdetachable','docdftsubcomid','docsupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="docdftsubcomid" name="docdftsubcomid" browserValue='<%=""+docdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=docdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+docdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>    

	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=portaldetachable name=portaldetachable value="1" tzCheckbox="true" <% if(portaldetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('portaldetachable','portaldftsubcomid','portalsupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="portaldftsubcomid" name="portaldftsubcomid" browserValue='<%=""+portaldftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=portaldftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+portaldftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>  

	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=cptdetachable name=cptdetachable value="1" tzCheckbox="true" <% if(cptdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('cptdetachable','cptdftsubcomid','cptsupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="cptdftsubcomid" name="cptdftsubcomid" browserValue='<%=""+cptdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=cptdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+cptdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>

	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=mtidetachable name=mtidetachable value="1" tzCheckbox="true" <% if(mtidetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('mtidetachable','mtidftsubcomid','mtisupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="mtidftsubcomid" name="mtidftsubcomid" browserValue='<%=""+mtidftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=mtidftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+mtidftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>
     
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id=wcdetachable name=wcdetachable value="1" tzCheckbox="true" <% if(wcdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('wcdetachable','wcdftsubcomid','wcsupsubcomspan');">
     </wea:item>  
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="wcdftsubcomid" name="wcdftsubcomid" browserValue='<%=""+wcdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=wcdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+wcdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>
     
     <wea:item>
	  <%=SystemEnv.getHtmlLabelName(30235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id="fmdetachable" name="fmdetachable" value="1" tzCheckbox="true" <% if(fmdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('fmdetachable','fmdftsubcomid','fmsupsubcomspan');">
     </wea:item>     
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="fmdftsubcomid" name="fmdftsubcomid" browserValue='<%=""+fmdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=fmdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+fmdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>    
     
     <wea:item>
	  <%=SystemEnv.getHtmlLabelName(81788,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id="mmdetachable" name="mmdetachable" value="1" tzCheckbox="true" <% if(mmdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('mmdetachable','mmdftsubcomid','mmsupsubcomspan');">
     </wea:item>     
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="mmdftsubcomid" name="mmdftsubcomid" browserValue='<%=""+mmdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=mmdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+mmdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item>      
     
     <wea:item>
	  <%=SystemEnv.getHtmlLabelName(920,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24326,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      <input type="checkbox" id="carsdetachable" name="carsdetachable" value="1" tzCheckbox="true" <% if(carsdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="formCheck('carsdetachable','carsdftsubcomid','carsdftsubcomspan');">
     </wea:item>     
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelName(18116,user.getLanguage())%>
	 </wea:item>
	 <wea:item>
      		<brow:browser viewType="0" id="carsdftsubcomid" name="carsdftsubcomid" browserValue='<%=""+carsdftsubcomid%>'  
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
             hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
             completeUrl="/data.jsp?show_virtual_org=-1&type=164"  width="220px"
             browserSpanValue='<%=carsdftsubcomid>0?SubComanyComInfo.getSubCompanyname(""+carsdftsubcomid):""%>'>
            </brow:browser> 
     </wea:item> 
  
	</wea:group>
</wea:layout>
  </FORM>
</BODY>

<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			//spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			spanobj.innerHTML = need ? "" : "";
			inputobj.value = "";
		}
	}
}

function onShowSubcompany(inputSpan,input) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" + $GetEle(input).value
			, $GetEle(inputSpan)
			, $GetEle(input)
			, true);
}

function formCheckAll(isInit) {
	if(!$G("detachable").checked) {
			jQuery("#innerContentdftsubcomiddiv").parent().parent().hide();
			jQuery("#btn_dftsubcomid").hide();
			
			if(!$G("hrmdetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("hrmdetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("hrmdetachable"),true);
			jQuery("#hrmdftsubcomid").val("");
			jQuery("#hrmdftsubcomidspan").html("");
			jQuery("#innerhrmdftsubcomiddiv").parent().parent().parent().hide();
  		}
  		if(!$G("wfdetachable").disabled){
  			changeCheckboxStatus4tzCheckBox($G("wfdetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("wfdetachable"),true);
			jQuery("#wfdftsubcomid").val("");
			jQuery("#wfdftsubcomidspan").html("");
			jQuery("#innerwfdftsubcomiddiv").parent().parent().parent().hide();
  		}
  		if(!$G("docdetachable").disabled){
  			changeCheckboxStatus4tzCheckBox($G("docdetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("docdetachable"),true);
			jQuery("#docdftsubcomid").val("");
			jQuery("#docdftsubcomidspan").html("");
			jQuery("#innerdocdftsubcomiddiv").parent().parent().parent().hide();
  		}
  		if(!$G("portaldetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("portaldetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("portaldetachable"),true);
			jQuery("#portaldftsubcomid").val("");
			jQuery("#portaldftsubcomidspan").html("");
			jQuery("#innerportaldftsubcomiddiv").parent().parent().parent().hide();
  		}
  		if(!$G("cptdetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("cptdetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("cptdetachable"),true);
			jQuery("#cptdftsubcomid").val("");
			jQuery("#cptdftsubcomidspan").html("");  
			jQuery("#innercptdftsubcomiddiv").parent().parent().parent().hide();
 		}
		if(!$G("mtidetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("mtidetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("mtidetachable"),true);
			jQuery("#mtidftsubcomid").val("");  
			jQuery("#mtidftsubcomidspan").html("");   
			jQuery("#innermtidftsubcomiddiv").parent().parent().parent().hide();
		}
		if(!$G("wcdetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("wcdetachable"),false);
			//disOrEnableCheckbox4tzCheckBox($G("wcdetachable"),true);
			jQuery("#wcdftsubcomid").val("");  
			jQuery("#wcdftsubcomidspan").html("");   
			jQuery("#innerwcdftsubcomiddiv").parent().parent().parent().hide();
		}
		
		if(!$G("fmdetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("fmdetachable"),false);
			jQuery("#fmdftsubcomid").val("");  
			jQuery("#fmdftsubcomidspan").html("");   
			jQuery("#innerfmdftsubcomiddiv").parent().parent().parent().hide();
		}
		if(!$G("mmdetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("mmdetachable"),false);
			jQuery("#mmdftsubcomid").val("");  
			jQuery("#mmdftsubcomidspan").html("");   
			jQuery("#innermmdftsubcomiddiv").parent().parent().parent().hide();
		}
		if(!$G("carsdetachable").disabled){
			changeCheckboxStatus4tzCheckBox($G("carsdetachable"),false);
			jQuery("#carsdftsubcomid").val("");  
			jQuery("#carsdftsubcomidspan").html("");   
			jQuery("#innercarsdftsubcomiddiv").parent().parent().parent().hide();
		}
	}else{
		if(!isInit){
			changeCheckboxStatus4tzCheckBox($G("hrmdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("wfdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("docdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("portaldetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("cptdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("mtidetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("wcdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("fmdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("mmdetachable"),true);
			changeCheckboxStatus4tzCheckBox($G("carsdetachable"),true);
		}
		
		jQuery("#innerContentdftsubcomiddiv").parent().parent().show();
		jQuery("#btn_dftsubcomid").show();
		//disOrEnableCheckbox4tzCheckBox($G("hrmdetachable"),false);
		jQuery("#innerhrmdftsubcomiddiv").parent().parent().parent().show();
		
		//disOrEnableCheckbox4tzCheckBox($G("wfdetachable"),false);
		jQuery("#innerwfdftsubcomiddiv").parent().parent().parent().show();
		
		//disOrEnableCheckbox4tzCheckBox($G("docdetachable"),false);
		jQuery("#innerdocdftsubcomiddiv").parent().parent().parent().show();
		
		//disOrEnableCheckbox4tzCheckBox($G("portaldetachable"),false);
		jQuery("#innerportaldftsubcomiddiv").parent().parent().parent().show();
		
		//disOrEnableCheckbox4tzCheckBox($G("cptdetachable"),false);
		jQuery("#innercptdftsubcomiddiv").parent().parent().parent().show();
		
		//disOrEnableCheckbox4tzCheckBox($G("mtidetachable"),false);
		jQuery("#innermtidftsubcomiddiv").parent().parent().parent().show();

		//disOrEnableCheckbox4tzCheckBox($G("wcdetachable"),false);
		jQuery("#innerwcdftsubcomiddiv").parent().parent().parent().show();		
		
		jQuery("#innerfmdftsubcomiddiv").parent().parent().parent().show();	
		jQuery("#innermmdftsubcomiddiv").parent().parent().parent().show();	
		jQuery("#innercarsdftsubcomiddiv").parent().parent().parent().show();		
	}
}

function formCheck(checkName,input,span) {
	if(!$G(checkName).checked) {
		if(!$G(checkName).disabled){
			changeCheckboxStatus4tzCheckBox($G(checkName),false);
			//jQuery("#"+input).val("");
			//jQuery("#"+input+"span").html("");
			jQuery("#inner"+input+"div").parent().parent().parent().hide();
		}
	}else{
		if(!$G("detachable").checked) {
			changeCheckboxStatus4tzCheckBox($G("detachable"),true);
			jQuery("#innerdftsubcomiddiv").parent().parent().parent().show();
			jQuery("#btn_dftsubcomid").show();
		}
		changeCheckboxStatus4tzCheckBox($G(checkName),true);
		jQuery("#inner"+input+"div").parent().parent().parent().show();
	}
}

formCheck("hrmdetachable","hrmdftsubcomid","");
formCheck("wfdetachable","wfdftsubcomid","");
formCheck("docdetachable","docdftsubcomid","");
formCheck("portaldetachable","portaldftsubcomid","");
formCheck("cptdetachable","cptdftsubcomid","");
formCheck("mtidetachable","mtidftsubcomid","");
formCheck("wcdetachable","wcdftsubcomid","");
formCheck("fmdetachable","fmdftsubcomid","");
formCheck("mmdetachable","mmdftsubcomid","");
formCheck("carsdetachable","carsdftsubcomid","");
formCheckAll(true);

function checkValue() {
     var returnStr=true;
     var returnStr1=true;
     var returnStr2=true;
     var returnStr3=true;
     var returnStr4=true;
     var returnStr5=true;
     var returnStr6=true;
     var returnStr7=true;
     var returnStr8=true;
     var returnStr9=true;
     var returnStr10=true;//移动建模
     if(!$G("detachable").disabled){
        if($G("detachable").checked==true){
           if($G("dftsubcomid").value=='0'|| $G("dftsubcomid").value=='' || $G("dftsubcomid").value=='undefind' || $G("dftsubcomid").value==null){
              returnStr=false;
           }else{
              returnStr=true;
           }
        }
     }  
     
     if(!$G("hrmdetachable").disabled){
        if($G("hrmdetachable").checked==true){
           if($G("hrmdftsubcomid").value=='0'|| $G("hrmdftsubcomid").value=='' || $G("hrmdftsubcomid").value=='undefind' || $G("hrmdftsubcomid").value==null){
               returnStr1=false;
           }else{
              returnStr1=true;
           }
        }
     }       
     if(!$G("wfdetachable").disabled){
        if($G("wfdetachable").checked==true){
           if($G("wfdftsubcomid").value=='0'||$G("wfdftsubcomid").value=='' || $G("wfdftsubcomid").value=='undefind' || $G("wfdftsubcomid").value==null){
               returnStr2=false;
           }else{
              returnStr2=true;
           }
        }
     }     
     if(!$G("docdetachable").disabled){
        if($G("docdetachable").checked==true){
           if($G("docdftsubcomid").value=='0'||$G("docdftsubcomid").value=='' || $G("docdftsubcomid").value=='undefind' || $G("docdftsubcomid").value==null){
               returnStr3=false;
           }else{
              returnStr3=true;
           }
        }
     }
     if(!$G("portaldetachable").disabled){
        if($G("portaldetachable").checked==true){
           if($G("portaldftsubcomid").value=='0'||$G("portaldftsubcomid").value=='' || $G("portaldftsubcomid").value=='undefind' || $G("portaldftsubcomid").value==null){
               returnStr4=false;
           }else{
              returnStr4=true;
           }
        }
     }
     if(!$G("cptdetachable").disabled){
        if($G("cptdetachable").checked==true){
           if($G("cptdftsubcomid").value=='0'||$G("cptdftsubcomid").value=='' || $G("cptdftsubcomid").value=='undefind' || $G("cptdftsubcomid").value==null){
               returnStr5=false;
           }else{
              returnStr5=true;
           }
        }
     }
     if(!$G("mtidetachable").disabled){
        if($G("mtidetachable").checked==true){
           if($G("mtidftsubcomid").value=='0'||$G("mtidftsubcomid").value=='' || $G("mtidftsubcomid").value=='undefind' || $G("mtidftsubcomid").value==null){
               returnStr6=false;
           }else{
              returnStr6=true;
           }
        }
     }   
     
     if(!$G("wcdetachable").disabled){
        if($G("wcdetachable").checked==true){
           if($G("wcdftsubcomid").value=='0'||$G("wcdftsubcomid").value=='' || $G("wcdftsubcomid").value=='undefind' || $G("wcdftsubcomid").value==null){
               returnStr7=false;
           }else{
              returnStr7=true;
           }
        }
     }      
     
     if(!$G("fmdetachable").disabled){
        if($G("fmdetachable").checked==true){
           if($G("fmdftsubcomid").value=='0'||$G("fmdftsubcomid").value=='' || $G("fmdftsubcomid").value=='undefind' || $G("fmdftsubcomid").value==null){
               returnStr8=false;
           }else{
              returnStr8=true;
           }
        }
     }      
     if(!$G("mmdetachable").disabled){
         if($G("mmdetachable").checked==true){
            if($G("mmdftsubcomid").value=='0'||$G("mmdftsubcomid").value=='' || $G("mmdftsubcomid").value=='undefind' || $G("mmdftsubcomid").value==null){
                returnStr10=false;
            }else{
               returnStr10=true;
            }
         }
      }      
     if(!$G("carsdetachable").disabled){
        if($G("carsdetachable").checked==true){
           if($G("carsdftsubcomid").value=='0'||$G("carsdftsubcomid").value=='' || $G("carsdftsubcomid").value=='undefind' || $G("carsdftsubcomid").value==null){
               returnStr9=false;
           }else{
              returnStr9=true;
           }
        }
     }
     
     //alert(returnStr1 +"--"+ returnStr2+"--"+returnStr3+"--"+returnStr4+"--"+ returnStr5+"--"+ returnStr6+"--"+ returnStr7);
     if(returnStr && returnStr1 && returnStr2&& returnStr3&& returnStr4&& returnStr5&& returnStr6&& returnStr7&& returnStr8&&returnStr9 && returnStr10){
        return true;
     }else{
        return false;
     }
}   

</script>

<script language="javascript">
function onSubmit(){
    if(checkValue()){  
        if($("#fmdetachable").attr("checked")){
            var url = "/formmode/setup/CheckModeSubcompany.jsp";
            var sub = $("#fmdftsubcomid").val();
            $.post(
               url,
               {flag:"init",subcompany:sub},
               function(data){
                  frmMain.submit();
            }),
            "json"       
        }else{
           frmMain.submit();
        }

    }else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33315",user.getLanguage()) %>");
    }
    
}

function changeDiv(){
    if ($GetEle("beforeDiv").style.display == "")
    	$GetEle("beforeDiv").style.display = 'none' ;
    else 
    	$GetEle("beforeDiv").style.display = ''	;
}

function jsSynSubCompany(){
	var dftsubcomid = jQuery("#dftsubcomid").val();
	if(dftsubcomid.length==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("30622",user.getLanguage()) %>");
		return;
	}
	var dftsubcomname = jQuery("#dftsubcomidspan").find("a").html();
	dftsubcomname = "<a href='#"+dftsubcomid+"' onclick='return false;' title='"+dftsubcomname+"'> "+dftsubcomname+"</a>";
  
  if($G("hrmdetachable").checked){	
		_writeBackData('hrmdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});
	}

  if($G("wfdetachable").checked){	
		_writeBackData('wfdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});
	}
	
	if($G("docdetachable").checked){	
		_writeBackData('docdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});
	}
	
	if($G("portaldetachable").checked){	
	_writeBackData('portaldftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
		hasInput:true,
		replace:true,
		isSingle:false,
		isedit:true
		});
	}
		
	if($G("cptdetachable").checked){			
		_writeBackData('cptdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});	
	}
	
	if($G("mtidetachable").checked){	
		_writeBackData('mtidftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});			
	}
	
	if($G("wcdetachable").checked){	
		_writeBackData('wcdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});	
	}
	
	if($G("fmdetachable").checked){	
		_writeBackData('fmdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});	
	}
	if($G("mmdetachable").checked){	
		_writeBackData('mmdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});	
	}
	if($G("carsdetachable").checked){	
		_writeBackData('carsdftsubcomid',1,{'id':dftsubcomid,'name':dftsubcomname},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});	
	}
}

jQuery(document).ready(function(){
	var hrmdetachable = '<%=hrmdetachable%>';
	var wfdetachable = '<%=wfdetachable%>';
	var docdetachable = '<%=docdetachable%>';
	var portaldetachable = '<%=portaldetachable%>';
	var cptdetachable = '<%=cptdetachable%>';
	var mtidetachable = '<%=mtidetachable%>';
	var wcdetachable  = '<%=wcdetachable%>';
	var fmdetachable  = '<%=fmdetachable%>';
	var mmdetachable  = '<%=mmdetachable%>';
	var carsdetachable  = '<%=carsdetachable%>';
	if(hrmdetachable !='1'){
		jQuery("#inner"+"hrmdftsubcomid"+"div").parent().parent().parent().hide();
	}
	
	if(wfdetachable !='1'){
		jQuery("#inner"+"wfdftsubcomid"+"div").parent().parent().parent().hide();
	}
	
	if(docdetachable !='1'){
		jQuery("#inner"+"docdftsubcomid"+"div").parent().parent().parent().hide();
	}
	
	if(portaldetachable !='1'){
		jQuery("#inner"+"portaldftsubcomid"+"div").parent().parent().parent().hide();
	}
	
	if(cptdetachable !='1'){
		jQuery("#inner"+"cptdftsubcomid"+"div").parent().parent().parent().hide();
	}
	
	if(mtidetachable !='1'){
		jQuery("#inner"+"mtidftsubcomid"+"div").parent().parent().parent().hide();
	}
	
	if(wcdetachable !='1'){
		jQuery("#inner"+"wcdftsubcomid"+"div").parent().parent().parent().hide();
	}
	if(fmdetachable !='1'){
		jQuery("#inner"+"fmdftsubcomid"+"div").parent().parent().parent().hide();
	}
	if(mmdetachable !='1'){
		jQuery("#inner"+"mmdftsubcomid"+"div").parent().parent().parent().hide();
	}
	if(carsdetachable !='1'){
		jQuery("#inner"+"carsdftsubcomid"+"div").parent().parent().parent().hide();
	}
	
})

</script>

</HTML>
