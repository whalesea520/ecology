
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageCominfo" scope="page" />
<%
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int templateId = Util.getIntValue(request.getParameter("templateId"));
	int extendtempletid = Util.getIntValue(request.getParameter("extendtempletid"));
	int subCompany_Id = subCompanyId;
	if(templateId==1){
		subCompanyId = 1;
	}

	String imagefilename = "/images/hdHRM_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(27714,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	int userid= user.getUID();
	String canCustom = pm.getConfig().getString("portal.custom");
	String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
	if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
		projectPath += "/";
	}
	
	List natInsThemeList = getNatInsThemeList(projectPath + "wui/theme/");
	if (natInsThemeList == null) {
		natInsThemeList = new ArrayList();	
	}
%>



<%!

private List getNatInsThemeList(String path) {
    List configList = null;
    if (path == null || "".equals(path)) {
        return null;
    }
    
    File parentFile = new File(path);
    
    if (!parentFile.exists() || !parentFile.isDirectory()) {
        return null;
    }
    configList = new ArrayList();
    File[] files = parentFile.listFiles();
    for (int i = 0; i < files.length; i++) {
        File item = files[i];
        if (item.getName().indexOf(".") != -1) {
        	continue;
        }
        if (item.isDirectory()) {
          List l1 = getNatInsSkinCfgList(path, item.getName());
          if(l1!=null)
        		configList.addAll(l1);
        }
    }
    
    return configList;
}

private List getNatInsSkinCfgList(String path, String themeName) {
	path += themeName + "/skins/";
	
    List configList = null;
    if (path == null || "".equals(path)) {
        return null;
    }
    
    File parentFile = new File(path);
    
    if (!parentFile.exists() || !parentFile.isDirectory()) {
        return null;
    }
    configList = new ArrayList();
    File[] files = parentFile.listFiles();
    for (int i = 0; i < files.length; i++) {
        File item = files[i];
        if (item.getName().indexOf(".") != -1) {
        	continue;
        }
        if (item.isDirectory()) {
        	Map skinConfigkv = getProperties(path + item.getName() + "/config.properties");
        	if (skinConfigkv != null) {
        		skinConfigkv.put("themeName", themeName);
        	}
        	configList.add(skinConfigkv);
        }
    }
    
    return configList;
}
/**
 * 读取properties配置文件
 * @param propertyPath 配置文件路径
 * @return 返回配置信息
 */
private Map getProperties(String propertyPath) {
	Map configkv = new HashMap();
	
	Properties config = new Properties();
	try {
		config.load(new FileInputStream(propertyPath));
	} catch (IOException e) {
		e.printStackTrace();
		return configkv;
	} 
	
	Enumeration enumeration = config.propertyNames();
	
	while (enumeration.hasMoreElements()) {
		String key = (String)enumeration.nextElement();
		String value = config.getProperty(key, "");
		configkv.put(key, value);
	}
	return configkv;
}
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<style>
</style>





<style type="text/css">
/* 皮肤Block */
.skinListBlock {
	width:100%;
}

/* 皮肤单项Block */
.skinItemBlock {
	width:130px;margin-bottom:10px;
}

/* 皮肤单项缩略图Block */
.skinItemThumbnailBlock {
	height:80px;width:130px;margin-top:5px;margin-bottom:0px;border:none;
}

/* 皮肤单项缩略图 */
.skinItemThumbnail {
	height:68px;width:118px;border:none;margin:6px;
}

/* 皮肤单项名称Block */
.skinItemNameBlock {
	width:100%;overflow:hidden;font-size:12px;margin-top:0px;color:#3399cc;margin-top:10px;
}

.skinItemThumbnailBg {
	background:url(/wui/theme/ecology7/page/images/skin/previewBorder_wev8.png) no-repeat;
}
.skinItemThumbnailSltBg {
	background:url(/wui/theme/ecology7/page/images/skin/previewSltBorder_wev8.png) no-repeat;
}

.skinDesc {
	width:100%;overflow:hidden;
}

.skinDescSetting {width:100%;}

</style>

<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"templateList.jsp";

$(document).ready(function () {
	$("input[name='lock']").bind("click", function () {
	//alert($(this).attr("checked"));
		if ($(this).attr("checked") == true) {
			
		}
	});

});

</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"...,javascript:saveAs(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(templateId!=1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="margin:0" name="frmMain" method="post" action="operation.jsp">
<input  name="method" type="hidden" value="edit"/>
<input name="templateId" type="hidden" value="<%=templateId%>"/>
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" name="extendtempletid"  value="<%=extendtempletid%>"/>
<input type="hidden" name="fieldname"/>

<%
String isOpenSoftAndSiteTempate=GCONST.getsystemThemeTemplate(); //是否启用软件模板和网站模板
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">

<TABLE class="Shadow">
	<tr>
		<td valign="top">
			<TABLE class=ViewForm>
				<COLGROUP>
				<COL width="30%">
				<COL width="70%">
				<TBODY>
				<TR style="display:<%=isOpenSoftAndSiteTempate.equals("0")?"none":""%>">
					<TD>
					<b><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></b>
					</TD>
					<TD class="tdExtend">
					<%   
						rsExtend.executeSql("select id,extendname,extendurl from extendHomepage order by extendname,id");
						while(rsExtend.next()){
							int id=Util.getIntValue(rsExtend.getString("id"));
							String extendname=Util.null2String(rsExtend.getString("extendname"));	
							String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
					
							if("/portal/plugin/homepage/webcustom".equals(extendurl)&&!"true".equals(canCustom)){
								continue;
							}
							String strChecked="";
							
							if(extendtempletid==id) {
								strChecked=" checked ";
							}
							
							
							if (id == 3) {
								out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompany_Id+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">"+SystemEnv.getHtmlLabelName(28112,user.getLanguage())+"</span>)&nbsp;&nbsp;");
								out.println("<input type='radio' onclick=\"chkExtendClick(this,'/systeminfo/template/templateEdit.jsp?id=" + templateId + "&subCompanyId=" + subCompany_Id + "&commonTemplet=1')\" value=\"0\" name=\"extendtempletid\" style=\"width:18px\""  + ((extendtempletid==0) ? " checked " : "") + ">" + SystemEnv.getHtmlLabelName(20621,user.getLanguage()) + "(<span style=\"color:red;\">"+SystemEnv.getHtmlLabelName(31556,user.getLanguage())+"</span>)&nbsp;&nbsp;");
							} else {
								out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompany_Id+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">"+SystemEnv.getHtmlLabelName(31556,user.getLanguage())+"</span>)&nbsp;&nbsp;");								
							}
						}
					%>
					</TD>
				</TR>
				<TR class=Spacing style="height:1px;display:<%=isOpenSoftAndSiteTempate.equals("0")?"none":""%>"><TD class=Line1 colSpan=2></TD></TR>	

				<TR>
					<TD COLSPAN=2 style="padding:0;margin:0;">
						<%
							
							String templateName="";
							String templateTitle="";
							String isOpen="";
							String defaultHp="";
							boolean saved=false;
							String sql = "SELECT * FROM SystemTemplate WHERE id=" + templateId;
							
							rs.executeSql(sql);
							if(rs.next()){
								templateName = rs.getString("templateName");
								templateTitle = rs.getString("templateTitle");								
								isOpen = rs.getString("isOpen").equals("1") ? "1" : "0";
								defaultHp =  rs.getString("defaultHp");
								String tempextendtempletid = Util.null2String(rs.getString("extendtempletid"));	
								String tempextendtempletvalueid = Util.null2String(rs.getString("extendtempletvalueid"));	

								if("1".equals(tempextendtempletid)&&!"".equals(tempextendtempletvalueid)) saved=true;
							}
							int extandHpThemeItemId = 0;
							int extandHpThemeId = 0;
							String theme = "";
							String skin = "";
							String logoTop = "";
							String logoBottom = "";
							int isopen = 0;
							int islock = 0;
							String lockProj = "";
							rsExtend.executeSql("select * from extandHpThemeItem where extandHpThemeId=(select max(id) from extandHpTheme where templateId=" + templateId + " and subcompanyid=" + subCompanyId + ")");
							
							Map tepDbThemekv = new HashMap();
							
							while(rsExtend.next()){
								extandHpThemeItemId = Util.getIntValue(rsExtend.getString("id"), 0);
								extandHpThemeId = Util.getIntValue(rsExtend.getString("extandHpThemeId"), 0);
								theme = Util.null2String(rsExtend.getString("theme"));
								skin = Util.null2String(rsExtend.getString("skin"));
								logoTop = Util.null2String(rsExtend.getString("logoTop"));
								logoBottom = Util.null2String(rsExtend.getString("logoBottom"));
								isopen = Util.getIntValue(rsExtend.getString("isopen"), 0);
								islock = Util.getIntValue(rsExtend.getString("islock"), 0);
								tepDbThemekv.put(theme + skin + "id", String.valueOf(extandHpThemeItemId));
								tepDbThemekv.put(theme + skin + "isopen", String.valueOf(isopen));
								tepDbThemekv.put(theme + skin + "islock", String.valueOf(islock));
							}
							%>	
							
							<input type="hidden" name="extandHpThemeId"  value="<%=extandHpThemeId%>"/>
							<input type="hidden" name="templateTitle"  value="<%=templateTitle%>"/>
							<table cellpadding="0" cellspacing="0" width="100%" style="padding:0;margin:0;">
								<tr>
									<td align="center" style="padding:0;margin:0;">
										<div class="skinListBlock" style="padding:0;margin:0;">
											<table cellpadding="0px" cellspacing="0px" width="100%" class=ViewForm style="padding:0;margin:0;">
												<tr>
													<td height="10" colspan="2"></td>
												</tr>
												<TR class=Title>
													<Td colSpan=2><%=SystemEnv.getHtmlLabelName(31557,user.getLanguage())%></Td>
												</TR>
												<TR class=Spacing  style="height:1px;">
													<TD class=Line1 colSpan=2></TD>
												</TR>
												<%
												String sbmtskvToStr = "";
												for (Iterator iterator=natInsThemeList.iterator(); iterator.hasNext();) {
													Map configkv = (Map)iterator.next();
													if (configkv == null) {
														continue;
													}
													String themeName = (String)configkv.get("themeName");
													String id = (String)configkv.get("id");
													String name = (String)configkv.get("name");
													String description = (String)configkv.get("description");
													String date = (String)configkv.get("date");
													String author = (String)configkv.get("author");
													int isOpening = Util.getIntValue((String)configkv.get("isOpening"), 0);
													String preview = (String)configkv.get("preview");
													String home = (String)configkv.get("home");
													
													String sbmts = themeName + "-" + id;
													if ("1".equals((String)tepDbThemekv.get(themeName + id + "islock"))) {
														lockProj = sbmts;
													} 
													sbmtskvToStr += "," + sbmts;
													
													boolean tmpIsOpen = "1".equals((String)tepDbThemekv.get(themeName + id + "isopen"));
												%>
												<tr align="left">
													<td width="130px" class="skinItemTdBorder" style="padding-right:5px;">
														<div class="skinItemBlock">
															<div class="skinItemThumbnailBlock skinItemThumbnailSltBg sltFlgClass" style="vertical-align: middle;">
																<img src="<%=preview %>" class="skinItemThumbnail" title="<%=themeName + "-" + name %>"/>
															</div>
														</div>
													</td>
													<td class="skinItemDescTdBorder Field" valign="top">
														<div class="skinItemNameBlock"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>：<%=themeName + "-" + name %></div>
														<div class="skinDesc" style="margin-top:5px;"><%=SystemEnv.getHtmlLabelName(31559,user.getLanguage())%>：<%=description %></div>
														<div class="skinDescSetting" style="margin-top:5px;">
															
															<!-- <a href="#" style="margin-right:5px;">预览</a>  -->
															<a href="themeSetting.jsp?theme=<%=themeName %>&skin=<%=id %>&extandHpThemeId=<%=extandHpThemeId %>&extandHpThemeItemId=<%=(String)tepDbThemekv.get(themeName + id + "id") %>&templateId=<%=templateId%>&subCompanyId=<%=subCompanyId%>&extendtempletid=<%=extendtempletid%>" style="margin-right:5px;">
															<%=SystemEnv.getHtmlLabelName(30747,user.getLanguage())%>
															</a>
															<input type="checkbox" name="<%=sbmts + "isopen"%>" value="1" <%=tmpIsOpen ? "checked" : ""  %>><%=SystemEnv.getHtmlLabelName(26472,user.getLanguage())%>
															<input type="radio" name="islock" value="<%=sbmts%>" <%="1".equals((String)tepDbThemekv.get(themeName + id + "islock")) ? "checked" : ""  %>  _chckedflg="<%=(String)tepDbThemekv.get(themeName + id + "islock")%>" <%=!tmpIsOpen ? "style=\"display:none;\"" : ""  %>><span <%=!tmpIsOpen ? "style=\"display:none;\"" : ""  %>><%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%></span>
														</div>
													</td>
												</tr>
												<TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
												<%
												}
												%>
												<input type="hidden" name="sbmtskvToStr"  value="<%=sbmtskvToStr.substring(1) %>"/>
												<input type="hidden" name="templateName"  value="<%=templateName %>"/>
												<input type="hidden" name="themeLock"  value="<%=lockProj %>"/>
												
											</table>
										</div>
									</td>
								</tr>
							</table>
					</TD>
				</TR>
     	</TABLE>

		</td>
	</tr>
</TABLE>

</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</FORM>

</body>
</html>
<script language="javascript">
function chkExtendClick(obj,url){
	if(obj.checked){
		window.location=url;	
	}
}


function checkSubmit(obj){
	//if(check_form(frmMain,"templateName")){
		obj.disabled=true;
		if(document.getElementById("templateId").value==1){
			document.getElementById("subCompanyId").value = "1";
		}else{
			document.getElementById("subCompanyId").value = "<%=subCompany_Id%>";
		}
		document.frmMain.submit();	
	//}
}

function saveAs(obj){
	if(check_form(frmMain,"templateName")){
		document.getElementById("method").value = "saveas";
		obj.disabled=true;
		document.getElementById("subCompanyId").value = "<%=subCompany_Id%>";
		document.frmMain.submit();		
		/*
		if(document.getElementById("templateName").value==document.getElementById("oldTemplateName").value){
			var str="<%=SystemEnv.getHtmlLabelName(18971,user.getLanguage())%>";
			if(confirm(str)){
				document.getElementById("operationType").value = "saveas";
				document.frmMain.submit();
				window.frames["rightMenuIframe"].event.srcElement.disabled = true;
			}
		}else{
			document.getElementById("operationType").value = "saveas";
			document.frmMain.submit();
			window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		}
		*/
	}
}

function del(obj){
	if(<%=isOpen%>=="1"){
		alert("<%=SystemEnv.getHtmlLabelName(18970,user.getLanguage())%>");
		return false;
	}else{
		if(isdel()){
			document.getElementById("method").value = "delete";
			obj.disabled=true;
			document.frmMain.submit();		
		}
	}
}

function preview(){
	if(<%=!saved%>)
		alert("<%=SystemEnv.getHtmlLabelName(20822,user.getLanguage())%>")
	else
		openFullWindowForXtable("index.jsp?from=preview&userSubcompanyId=<%=subCompany_Id%>&templateId=<%=templateId%>&extendtempletid=<%=extendtempletid%>")
}
function ondelpic(fieldname){	
	document.getElementById("method").value = "delpic";
	document.getElementById("fieldname").value = fieldname;
	document.frmMain.submit();	
}
var islockChecked = false;
$(document).ready(function () {
	$("input[name='islock']").bind("click", function () {
		if ($(this).attr("_chckedflg") == 1) {
			$(this).attr("_chckedflg", 0);
			$(this).attr("checked", false);
			$("input[name='themeLock']").val("");
		} else {
			$(this).attr("_chckedflg", 1);
			$(this).attr("checked", true);
			$("input[name='themeLock']").val($(this).val());
		}
	});
	
	$("input[type='checkbox']").bind("click", function () {
		if ($(this).attr("checked") == true) {
			$(this).next().show();
			$(this).next().next().show();
			$("input[name='themeLock']").val("");
		} else {
			$(this).next().attr("checked", false);
			$(this).next().next().hide();
			$(this).next().hide();
		}
	});
});
</script>
