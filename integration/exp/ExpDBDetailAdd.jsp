<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.expdoc.ExpUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
ExpUtil eu=new ExpUtil();
ArrayList arrayRs=new ArrayList();
arrayRs=eu.getDatasourceNames();
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM id=weaver name=frmMain action="ExpDBDetailOperation.jsp?isdialog=1" method=post enctype="multipart/form-data" >
<input class=inputstyle type=hidden name="backto" value="<%=backto%>">
<input class=inputstyle type="hidden" name=operation value="add">
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="nameimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="name" id="name"  onchange='checkinput("name","nameimage")' onblur="checkname();">
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="resoureimage" >
              
			<select id="resoure" style='width:120px!important;' name="resoure">
							<option></option>
							<%
							ArrayList pointArrayList = DataSourceXML.getPointArrayList();
							for(int i=0;i<pointArrayList.size();i++){
							    String pointid = (String)pointArrayList.get(i);
							    String isselected = "";
							%>
							<option value="<%=pointid%>" <%=isselected%>><%=pointid%></option>
							<%    
							}
							%>
			</select>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="maintableimage" required="true" >
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="maintable" id="maintable" onchange='checkinput("maintable","maintableimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="detailtableimage" required="false">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="detailtable" id="detailtable" _noMultiLang='true'>
            </wea:required>
		</wea:item>		
	</wea:group>
</wea:layout>
<br>
 </form>

<script language=javascript>
function submitData() {
	var checkvalue = "name,maintable";
    if(check_form(frmMain,checkvalue)){
      var datasourceid=$("#resoure").val();
      var outermaintable=$("#maintable").val();
      var outerdetailtable=$("#detailtable").val();
      jQuery.ajax({
        type: "POST",
         url: "/integration/exp/automaticCheckExpDBDetail.jsp",
        data: {datasourceid:datasourceid,outermaintable:outermaintable,outerdetailtable:outerdetailtable},
        cache:false,
        success: function(msg){
            if(jQuery.trim(msg)=="-1")
            {
            	 frmMain.submit();
            }
            else
            {
            	var errormsg = "";
            	if(jQuery.trim(msg)=="0")
            	{
            		errormsg = "<%=SystemEnv.getHtmlLabelName(125711,user.getLanguage())%>";//主表在对应的数据源里不存在！
            	}
            	else
            	{
            		errormsg = "<%=SystemEnv.getHtmlLabelName(125712,user.getLanguage())%>";//明细表在对应的数据源里不存在！
            	}
            	top.Dialog.alert(errormsg)//测试不通过，配置不正确，请检查配置!
            }
        }
    });

       
    }
}
function onBack(){
	parentWin.closeDialog();
}

//QC306479 流程归档集成-新建和编辑归档数据库页面，解决不允许名称内填入特殊符号的问题start
//检测字符中是否含有特殊字符
function isSpecialChar(str){
    var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
    return reg.test(str);
}
//检查名称的特殊字符
function checkname(){
    var value = jQuery("#name").val();
    value = $.trim(value);
    if(isSpecialChar(value)){//包含特殊字符
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
        jQuery("#name").val("");
        checkinput("name","nameimage");
        return false;
    }
    return true;
}
//QC306479 流程归档集成-新建和编辑归档数据库页面，解决不允许名称内填入特殊符号的问题end
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>