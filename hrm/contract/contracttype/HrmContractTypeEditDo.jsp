<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("id"));
String isreport = Util.null2String(request.getParameter("isreport"));
int subcompanyid = Util.getIntValue((request.getParameter("subcompanyid")));
%>
<%

//如果不是来自HrmTab页，增加页面跳转
if(!Util.null2String(request.getParameter("fromHrmDialogTab")).equals("1")){
	String url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmContractTypeEditDo&id="+id+"&isreport="+isreport;
	response.sendRedirect(url.toString()) ;
	return;
}
 %>
<html>
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
	function getContracttemplet(){//获取跳转合同模板页面
		var subcompanyidForContract = jQuery("input[name=subcompanyid]").val();
		if(!subcompanyidForContract){
			subcompanyidForContract = <%=subcompanyid%>;//若删除了部门id，则取初始化默认部门id
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());
String needfav ="1";
String needhelp ="";

String typename = Util.null2String(request.getParameter("typename"));
int saveurl = Util.getIntValue(request.getParameter("saveurl"),-1);
String templetid = Util.null2String(request.getParameter("contracttempletid"));
String ishirecontract = Util.null2String(request.getParameter("ishirecontract"));
String remindaheaddate = Util.null2String(request.getParameter("remindaheaddate"));
String remindman = Util.null2String(request.getParameter("remindman"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
ManageDetachComInfo comInfo = new ManageDetachComInfo();
Boolean isUseHrmManageDetach=comInfo.isUseDocManageDetach();
if(isUseHrmManageDetach){
	detachable=1;
}else{
	detachable=0;
}







String sql = "select * from HrmContractType where id = "+id;
rs.executeSql(sql);
while(rs.next()){
    if(typename.equals("")){
        typename  = Util.null2String(rs.getString("typename"));
    }      
    if(saveurl==-1){
        saveurl  = Util.getIntValue(rs.getString("saveurl"),-1);
    }      
    if(templetid.equals("")){
        templetid  = Util.null2String(rs.getString("contracttempletid"));
    }      
    if(ishirecontract.equals("")){
        ishirecontract  = Util.null2String(rs.getString("ishirecontract"));
    }      
    if(remindaheaddate.equals("")){
        remindaheaddate  = Util.null2String(rs.getString("remindaheaddate"));
    }      
    if(remindman.equals("")){
        remindman  = Util.null2String(rs.getString("remindman"));
    }
	subcompanyid = Util.getIntValue(rs.getString("subcompanyid"),-1);
	session.setAttribute("HrmContractTypeEditDo_",String.valueOf(subcompanyid));
}    

String path = "";
if (saveurl > 0) {
    path = CategoryUtil.getCategoryPath(saveurl);
}
%>
<%
	boolean canDelete = false;
	sql ="Select ID From HrmContract where ContractTypeID = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
		if(Util.null2String(RecordSet.getString("ID")).equals(""))
			canDelete = true;


%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmContractTypeEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
if(HrmUserVarify.checkUserRight("HrmContractTypeDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
*/
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contracttype/HrmContractTypeEdit.jsp?id="+id+",_self} " ;
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
<input class=inputStyle type=hidden name=operation>
<input class=inputStyle type=hidden name=id value="<%=id%>">
<%if(detachable !=1){%>
	<input class=inputStyle  type=hidden name=subcompanyid value="<%=subcompanyid %>">
<% }%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%> </wea:item>
    <wea:item>
       <input class=inputStyle  name="typename" value="<%=typename%>" onChange='checkinput("typename","typenamespan")' >
       <SPAN id="typenamespan">       
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
<%}%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></wea:item>  
    <wea:item>
<%
	sql = "select templetname from HrmContractTemplet where id = "+templetid;
  
  rs2.executeSql(sql);
  String templetname = "";
  while(rs2.next()){
    templetname = rs2.getString("templetname");
  } 
    %>
 		<brow:browser viewType="0" name="contracttempletid" browserValue='<%=templetid %>' 
     getBrowserUrlFn="getContracttemplet"
     hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
     completeUrl="/data.jsp?type=HrmContractType" width="240px"
     _callback="jsSetTemplatename"
     browserSpanValue='<%=templetname%>'
     ></brow:browser>  
     <script>
     function jsSetTemplatename(e,datas,name){
     	$('input[name=templatename]').val(datas.name);
     }
     </script>
		<INPUT type="hidden" name="templatename" value='<%=templetname%>'/>       
    </wea:item>   
    <wea:item><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></wea:item>
    <wea:item>
    	<!--
        <BUTTON type="button" class=Browser onClick="onSelectCategory(1)" name=selectCategory></BUTTON>
        <span id=srcpath name=srcpath><%=path%>
        	<%if(saveurl==-1||saveurl==-2){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle/>
					<%}%>
        </span>    
        <INPUT class=inputStyle type=hidden name=saveurl id="saveurl" value="<%=saveurl%>">
        -->
    <brow:browser viewType="0" name="saveurl" browserValue='<%=""+saveurl%>' 
     browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?selectedids="
     hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
     completeUrl="/data.jsp?type=categoryBrowser" width="200px"
     browserSpanValue='<%=path%>'>
    </brow:browser>
    </wea:item>  
    <wea:item><%=SystemEnv.getHtmlLabelName(15791,user.getLanguage())%> </wea:item>        
    <wea:item>
      <select class=inputStyle name=ishirecontract value="<%=ishirecontract%>">
        <option value="0" <%if(ishirecontract.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
        <option value="1" <%if(ishirecontract.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
      </select>      
    </wea:item>  
    <wea:item><%=SystemEnv.getHtmlLabelNames("20920,15792",user.getLanguage())%> </wea:item>    
    <wea:item><input class=inputstyle type=text name=remindaheaddate value='<%=remindaheaddate%>' onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("remindaheaddate")'> <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></wea:item> 
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
	if (result) {
	    if (wuiUtil.getJsonValueByIndex(result,0)> 0)  {
    	    if (whichcategory == 1) {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+result[1]
    	        jQuery("#saveurl").val(wuiUtil.getJsonValueByIndex(result,1));
    	        //document.contracttype.saveurl.value=wuiUtil.getJsonValueByIndex(result,1);
    	    } else {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+document.all("srcsecid").value
    	        jQuery("#saveurl").val($GetEle("srcsecid").value);
    	        //document.contracttype.saveurl.value=document.all("srcsecid").value;
    	    }    	 
    	}
    	else
    	{
    			jQuery("#saveurl").val("-2");
    	}
    	document.contracttype.action="HrmContractTypeEditDo.jsp";
    	document.contracttype.submit();
	}
}
  function dosave(){
  	if(document.contracttype.saveurl.value=="-1"||document.contracttype.saveurl.value==""||document.contracttype.saveurl.value=="-2"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return false;
	 }
   if(document.contracttype.contracttempletid.value == ""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15794,user.getLanguage())%>!!!");
   }else{
    if(check_form(document.contracttype,'typename,subcompanyid')){
    document.contracttype.operation.value = "edit";
    document.contracttype.submit();
   }
   }
  }
  function dodelete(){
	  <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.contracttype.operation.value = "delete";
      document.contracttype.submit();
    }
	<%}else{%>
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
  }
  function mainchange(){
    document.contracttype.action="HrmContractTypeEditDo.jsp";
    document.contracttype.submit();
  }
  function subchange(){
    document.contracttype.action="HrmContractTypeEditDo.jsp";
    document.contracttype.submit();
  }
  function submitData() {
 contracttype.submit();
}

</script>
</body>
</html>
