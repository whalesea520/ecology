<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%

if(!HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int subcompanyid= Util.getIntValue(request.getParameter("subcompanyid"));
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
	function getContracttemplet(){ 
		var subcompanyidForContract = jQuery("input[name=subcompanyid]").val();
		if(!subcompanyidForContract){
			subcompanyidForContract = <%=subcompanyid%>;
		}
		return "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/contract/contracttemplet/HrmConTempletBrowser.jsp?selectedids=&subcompanyid="+subcompanyidForContract;
	}
</script>
</head>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());

String typename=Util.null2String(request.getParameter("typename"));
String contracttempletid=Util.null2String(request.getParameter("contracttempletid"));
int ishirecontract=Util.getIntValue(request.getParameter("ishirecontract"),0);
String remindman=Util.null2String(request.getParameter("remindman"));
String remindaheaddate=Util.null2String(request.getParameter("remindaheaddate"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
ManageDetachComInfo comInfo = new ManageDetachComInfo();
Boolean isUseHrmManageDetach=comInfo.isUseDocManageDetach();
if(isUseHrmManageDetach){
	detachable=1;
}else{
	detachable=0;
}
String usertype = user.getLogintype();
String mainid=Util.null2String(request.getParameter("mainid"));
String subid=Util.null2String(request.getParameter("subid"));
int saveurl = Util.getIntValue(request.getParameter("saveurl"), -1);
String path = "";
if (saveurl != -1) {
    path = CategoryUtil.getCategoryPath(saveurl);
}



String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contracttype/HrmContractType.jsp?subcompanyid1="+subcompanyid+",_self} " ;
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
<FORM id=contracttype name=contracttype action="HrmConTypeOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation>
<%if(detachable !=1){%>
	<input  type=hidden name=subcompanyid value="<%=subcompanyid %>">
<% }%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%>'>  
    <wea:item><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputStyle name="typename" value="<%=typename%>" onChange="checkinput('typename','typenamespan')" >
       <SPAN id="typenamespan">
	   <%if(typename.equals("")){%>
       <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
	   <%}%>
       </SPAN>
    </wea:item>
<%if(detachable==1){%>
        <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
        <wea:item>
        <brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid==-1?"":subcompanyid+"" %>' 
	       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmContractTypeAdd:Add"
	       hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
	       completeUrl="/data.jsp?type=164" width="200px"
	       browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>'>
	      </brow:browser>
        </wea:item>
<% }%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></wea:item>  
    <wea:item>
   
 		<brow:browser viewType="0" name="contracttempletid" browserValue='<%=contracttempletid %>' 
      getBrowserUrlFn="getContracttemplet"
     hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
     completeUrl="/data.jsp?type=HrmContractType" width="240px"
     _callback="jsSetTemplatename"
     browserSpanValue='<%=Util.null2String(request.getParameter("templatename")) %>'
     ></brow:browser>  
     <script>
     function jsSetTemplatename(e,datas,name){
     	$('input[name=templatename]').val(datas.name);
     }
     </script>
		<INPUT type="hidden" name="templatename" value='<%=Util.null2String(request.getParameter("templatename")) %>'/>
    </wea:item>   
    <wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
    <wea:item>
    <!--
    <BUTTON type=button class=Browser onClick="onSelectCategory(1)" name=selectCategory></BUTTON>
        <span id=srcpath name=srcpath><%=path%>
		<%if(saveurl==-1){%>
		<IMG src="/images/BacoError_wev8.gif" align=absMiddle/>
		<%}%>
		</span>
		<INPUT class=inputstyle type=hidden name=saveurl value="<%=saveurl%>">
		-->
		<brow:browser viewType="0" name="saveurl" browserValue="" 
     browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
     hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
     completeUrl="/data.jsp?type=categoryBrowser" width="200px"
     browserSpanValue="">
    </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15791,user.getLanguage())%> </wea:item>    
    <wea:item>
      <select class=inputstyle name=ishirecontract value="<%=ishirecontract%>">
        <option value="0" <%if(ishirecontract == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
        <option value="1" <%if(ishirecontract == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
      </select>
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelNames("20920,15792",user.getLanguage())%> </wea:item>    
    <wea:item><input class=inputstyle type=text size=3 maxlength=3 name=remindaheaddate value='<%=remindaheaddate%>' onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("remindaheaddate")'> <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(15793,user.getLanguage())%> </wea:item>    
    <wea:item>
  		<brow:browser viewType="0" name="remindman" browserValue='<%=remindman %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
       hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
       completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="240px"
       browserSpanValue='<%=ResourceComInfo.getMulResourcename(remindman)%>'>
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
<script language=javascript>
    function onSelectCategory(whichcategory) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
	
	if (result != null) {
	    if (result.tag > 0)  {
    	    if (whichcategory == 1) {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+result[1]
    	        document.contracttype.saveurl.value=result.id;
    	    } else {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+document.all("srcsecid").value
    	        document.contracttype.saveurl.value=document.all("srcsecid").value;
    	    }
			
    	}else{
			document.contracttype.saveurl.value=-1;
		}
    	document.contracttype.action="HrmContractTypeAdd.jsp?isdialog=1";
    	document.contracttype.submit();
	}
}

  function dosave(){
	if(<%=detachable%> == 1){
	   if(document.contracttype.subcompanyid.value == ""){
	   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>!!!");
	   		return false;
	   }
  	}

   if(document.contracttype.contracttempletid.value == ""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124783,user.getLanguage())%>!!!");
   }else{
	 if(document.contracttype.saveurl.value=="-1"||document.contracttype.saveurl.value==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return false;
	 }
     if(check_form(document.contracttype,'typename,subcompanyid1')){
		document.contracttype.operation.value = "add";
		document.contracttype.submit();
	}
  }
  }
  function mainchange(){
    document.contracttype.action="HrmContractTypeAdd.jsp?isdialog=1";
    document.contracttype.submit();
  }
  function subchange(){
    document.contracttype.action="HrmContractTypeAdd.jsp?isdialog=1";
    document.contracttype.submit();
  }
</script>
</body>
</html>

