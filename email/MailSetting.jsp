
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String fontsize = "";
String showmode = "";

String showTop = Util.null2String(request.getParameter("showTop"));

int mainId = 0, subId = 0, secId = 0, crmSecId = 0, layout = 3, perpage = 20, emlsavedays = 30 , defaulttype=1,autosavecontact=0;
String categoryPath = "", crmCategoryPath="";

rs.executeSql("SELECT * FROM SystemSet");
if(rs.next()) emlsavedays = rs.getInt("emlsavedays");

rs.executeSql("SELECT * FROM MailSetting WHERE userId="+user.getUID()+"");
if(rs.next()){
	mainId = rs.getInt("mainId");
	subId = rs.getInt("subId");
	secId = rs.getInt("secId");
	crmSecId = rs.getInt("crmSecId");
	layout = rs.getInt("layout");
	perpage = rs.getInt("perpage");
	emlsavedays = rs.getInt("emlsavedays");
	defaulttype = rs.getInt("defaulttype");
	autosavecontact = rs.getInt("autosavecontact");
	categoryPath = secId>0 ? CategoryUtil.getCategoryPath(secId) : "";
	crmCategoryPath = crmSecId>0 ? CategoryUtil.getCategoryPath(crmSecId) : "";
	fontsize = rs.getString("fontsize");
	showmode = rs.getString("showmode");
}

if(fontsize==null || "".equals(fontsize))fontsize = "12px";
if(showmode==null || "".equals(showmode))showmode = "0";

rs.execute("select * from MailConfigureInfo");
int innerMail = 1;
int outterMail = 1;
if(rs.next()){
	innerMail = Util.getIntValue(rs.getString("innerMail"),1);
	outterMail = Util.getIntValue(rs.getString("outterMail"),1);
}
%>
<HTML>
<HEAD>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript">

 function  formSubmit(){
     fMailSetting.submit();
 }
 
 
 function onSelectDocCategory(_categoryname,_secId,_mainId,_subId) {
	//window.parent.returnValue = Array(1, id, path, mainid, subid);
	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=<%=AclManager.OPERATION_CREATEDOC%>");
	if(typeof result!="undefined"){
		if(result.length==2){
			jQuery("#"+_categoryname).html("");
			jQuery("input[name="+_secId+"]").val("");
			jQuery("input[name="+_mainId+"]").val("");
			jQuery("input[name="+_subId+"]").val("");
		}else{
			jQuery("#"+_categoryname).html(result[2]);
			jQuery("input[name="+_secId+"]").val(result[1]);
			jQuery("input[name="+_mainId+"]").val(result[3]);
			jQuery("input[name="+_subId+"]").val(result[4]);
		}
	}
}
 
jQuery(function(){
	jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
}); 

function callBackSelectDoc(event,data,name,_callbackParams){
	jQuery("#docspan").find("a").attr("title",data.path);
	jQuery("#docspan").find("a").html(data.path);
	jQuery("#mainId").val(data.mainid);
	jQuery("#subId").val(data.subid);
	jQuery("#secId").val(data.id);
}


function callBackSelectCrm(event,data,name,_callbackParams){
	jQuery("#crmspan").find("a").attr("title",data.path);
	jQuery("#crmspan").find("a").html(data.path);
	jQuery("#crmMainId").val(data.mainid);
	jQuery("#crmSubId").val(data.subid);
	jQuery("#crmSecId").val(data.id);
}

function doselfontsize(obj) {
	var selvalue = jQuery(obj).val();
	jQuery('#modelfont').css('font-size',selvalue);
}

</script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="formSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailSettingOperation.jsp" id="fMailSetting" name="fMailSetting">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19847,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19947,user.getLanguage())%></wea:item>
		<wea:item>
		   <brow:browser viewType="0" name="secId" 
	         browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+AclManager.OPERATION_CREATEDOC %>'
	         browserValue='<%=secId+""%>' idKey="id" nameKey="path"
	         browserSpanValue = '<%=categoryPath%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput="1" 
	         completeUrl='<%="/data.jsp?type=categoryBrowser&operationcode="+AclManager.OPERATION_CREATEDOC  %>' width="50%" ></brow:browser>   
	            
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19948,user.getLanguage())%></wea:item>
		<wea:item>
		
			<brow:browser viewType="0" name="crmSecId" 
	         browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+AclManager.OPERATION_CREATEDOC %>'
	         browserValue='<%=crmSecId+""%>' idKey="id" nameKey="path"
	         browserSpanValue = '<%=crmCategoryPath%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput="1" 
	         completeUrl='<%="/data.jsp?type=categoryBrowser&operationcode="+AclManager.OPERATION_CREATEDOC  %>' width="50%" ></brow:browser> 
             
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19849,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" name="layout" value="1" <%if(layout==1){out.println("checked='checked'");}%> /><%=SystemEnv.getHtmlLabelName(19851,user.getLanguage())%>
			<input type="radio" name="layout" value="2" <%if(layout==2){out.println("checked='checked'");}%> 
			/><%=SystemEnv.getHtmlLabelName(20825,user.getLanguage())%>
			<input type="radio" name="layout" value="3" <%if(layout==3){out.println("checked='checked'");}%>  /><%=SystemEnv.getHtmlLabelName(19852,user.getLanguage())%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="perpage" class="inputstyle"  value="<%=perpage%>" style="width:10%"/>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21422,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21421,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" style="width:10%" size = 5 maxlength = 4 name="emlsavedays" class="inputstyle" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("emlsavedays")' value="<%=emlsavedays%>" /><%=(" "+SystemEnv.getHtmlLabelName(1925,user.getLanguage()))%>
		</wea:item>
	</wea:group>
	
	<%if(innerMail == 1 && outterMail  ==1){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(31137,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(31138,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" name="defaulttype" value="0" <%if(defaulttype==0){out.println("checked='checked'");}%> /><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%>
			<input type="radio" name="defaulttype" value="1" <%if(defaulttype==1){out.println("checked='checked'");}%> /><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%>
		</wea:item>
	</wea:group>
	<%} %>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(31272,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(31272 ,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="autosavecontact" value="0" <%if(autosavecontact==0){out.println("checked='checked'");}%> />
		</wea:item>
	</wea:group>
	
	<wea:group context="<%=SystemEnv.getHtmlLabelName(125541,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(84212,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;line-height: 50px">
				<SELECT  class=InputStyle name="fontsize" id="fontsize" onchange="doselfontsize(this)" style="width: 120px;" >
				  	  <option value="9px" <%if("9px".equals(fontsize))out.print("selected='selected'"); %>>9px</option>
					  <option value="10px" <%if("10px".equals(fontsize))out.print("selected='selected'"); %>>10px</option>
					  <option value="12px" <%if("12px".equals(fontsize))out.print("selected='selected'"); %>>12px</option>
					  <option value="14px" <%if("14px".equals(fontsize))out.print("selected='selected'"); %>>14px</option>
					  <option value="16px" <%if("16px".equals(fontsize))out.print("selected='selected'"); %>>16px</option>
					  <option value="18px" <%if("18px".equals(fontsize))out.print("selected='selected'"); %>>18px</option>
					  <option value="24px" <%if("24px".equals(fontsize))out.print("selected='selected'"); %>>24px</option>
					  <option value="32px" <%if("32px".equals(fontsize))out.print("selected='selected'"); %>>32px</option>
				</SELECT>
			</span>
			<span id="modelfont" style="line-height: 50px;margin-left: 10px;font-size: <%=fontsize %>"><%=SystemEnv.getHtmlLabelName(125544,user.getLanguage())%></span>
		</wea:item>
	</wea:group>
	
	<wea:group context="<%=SystemEnv.getHtmlLabelName(125542,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(125543,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;">
				<SELECT  class=InputStyle name="showmode" id="showmode"  style="width: 120px;" >
				  	  <option value="1" <%if("1".equals(showmode))out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(83126,user.getLanguage())%></option>
					  <option value="0" <%if("0".equals(showmode))out.print("selected='selected'"); %>><%=SystemEnv.getHtmlLabelName(83122,user.getLanguage())%></option>
				</SELECT>
			</span>
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>
</body>
</html>
