<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.expdoc.ExpUtil"%>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
%>
<%
ExpUtil eu=new ExpUtil();
ArrayList arrayRs=new ArrayList();
arrayRs=eu.getDatasourceNames();
String sysid = Util.null2String(request.getParameter("id"));
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
rs.executeSql("select * from exp_dbdetail where id="+sysid+"");
String name = "";
String resoure = "";
String maintable = "";
String detailtable = "";
if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	resoure = Util.toScreenToEdit(rs.getString("resoure"),user.getLanguage());
	maintable = Util.toScreenToEdit(rs.getString("maintable"),user.getLanguage());
	detailtable = Util.toScreenToEdit(rs.getString("detailtable"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125713 ,user.getLanguage());//归档数据库注册
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
boolean usedFlag = new weaver.expdoc.ExpUtil().getShowmethod(sysid+"+2").equals("true");
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
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("intergration:expsetting", user) && usedFlag){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
			if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
				canEdit = true;
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSave()"/>
			<%}
			if(HrmUserVarify.checkUserRight("intergration:expsetting", user) && usedFlag){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
			<%
			}
			%>
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
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="nameimage" required="true" value='<%=name%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="name" id="name" value="<%=name%>"  onchange='checkinput("name","nameimage")' onblur="checkname();">
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="resoureimage" value='<%=resoure%>'>
           <select id="resoure" style='width:120px!important;' name="resoure">
							<option></option>
							<%
							ArrayList pointArrayList = DataSourceXML.getPointArrayList();
							for(int i=0;i<pointArrayList.size();i++){
							    String pointid = (String)pointArrayList.get(i);
							    String isselected = "";
							    if(resoure.equals(pointid)){
							        isselected = "selected";
							    }
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
            <wea:required id="maintableimage" required="true" value='<%=maintable%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="maintable" id="maintable" value="<%=maintable%>" onchange='checkinput("maintable","maintableimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="detailtableimage" required="false" value='<%=detailtable%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="detailtable" id="detailtable" value="<%=detailtable%>" _noMultiLang='true'>
            </wea:required>
		</wea:item>		
	</wea:group>
</wea:layout>
<br>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=sysid%>">
 <input class=inputstyle type=hidden name=backto value="<%=backto%>">
 </form>
<script language=javascript>

function onSave(){
	
	var checkvalue = "name,maintable";
    if(check_form(frmMain,checkvalue)){
      document.frmMain.operation.value="edit";
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
function doAdd(){
	document.location.href="/integration/exp/ExpDBDetailAdd.jsp?typename=<%=backto%>";
}

function onDelete(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>", function (){
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}, function () {}, 320, 90);
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
