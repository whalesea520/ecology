
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


	

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";   

	int userid= user.getUID();
	String canCustom = pm.getConfig().getString("portal.custom");
	
	//皮肤目录加载
    List skins = getChildFolder(this.getServletConfig().getServletContext().getRealPath("/") + "wui/skins");
    
    if (skins == null) {
        skins = new ArrayList();
    }
%>
<%!
public List getChildFolder(String path) {
    List folderNames = null;
    
    if (path == null || "".equals(path)) {
        return null;
    }
    
    File parentFile = new File(path);
    
    if (!parentFile.exists() || !parentFile.isDirectory()) {
        return null;
    }
    folderNames = new ArrayList();
    File[] files = parentFile.listFiles();
    for (int i = 0; i < files.length; i++) {
        File item = files[i];
        if (item.isDirectory()) {
            folderNames.add(item.getName());
        }
    }
    
    return folderNames;
}
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<style>
input{width:340px} 
</style>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:preview(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


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

<FORM style="margin:0" name="frmMain" method="post" enctype="multipart/form-data" action="operation.jsp">
<input  name="method" type="hidden" value="edit"/>
<input name="templateId" type="hidden" value="<%=templateId%>"/>
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" name="extendtempletid"  value="<%=extendtempletid%>"/>
<input type="hidden" name="fieldname"/>



<!--detection the system font start -->
<DIV style="LEFT: 0px; POSITION: absolute; TOP: 0px"><OBJECT ID="dlgHelper" CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH="0px" HEIGHT="0px"></OBJECT></DIV>
<script language="javascript" type="text/javascript">

function fontDetecion(what) {
  	var fontName = what.value;
  	if(!isExistOTF(fontName)) {
  		if(confirm(fontName + "<%=SystemEnv.getHtmlLabelName(84205,user.getLanguage())%>")){
  			alert("<%=SystemEnv.getHtmlLabelName(84206,user.getLanguage())%>");
  		}
  	}
}

//detection the system font
var sysfonts = '';

window.onload = function() {
	var sysFontsArray = new Array();
	sysFontsArray = getSystemFonts('dlgHelper');
	for(var i=0; i<sysFontsArray.length; i++) {
		sysfonts += sysFontsArray[i];
		sysfonts += ';'
	}
};

function isExistOTF(fontName) {
	if (fontName == undefined 
		    || fontName == null 
			|| fontName.trim() == '') {
		return false;
	}
	
	if (sysfonts.indexOf(fontName) != -1) {
		return true;
	}
	return false;
};

/**
 * getting to the system font list
 *
 * @param dlgHelperId The id of components of the system font.
 * @return fonts list
 */
function getSystemFonts(dlgHelperId) {
    var a = document.all(dlgHelperId).fonts.count;
    var fArray = new Array();
    for (var i = 1; i <= document.all(dlgHelperId).fonts.count; i++) {
        fArray[i] = document.all(dlgHelperId).fonts(i)
    }
    return fArray
}


String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g, "");
}
</script>

<!--detection the system font end -->

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

				<TR>
					<TD>
					<b><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></b>
					</TD>
					<TD class="tdExtend">
						<input type='radio' onclick="chkExtendClick(this,'/systeminfo/template/templateEdit.jsp?id=<%=templateId%>&subCompanyId=<%=subCompanyId%>&commonTemplet=1')" value="0" name="extendtempletid" style="width:18px" <%if(extendtempletid==0) out.println(" checked ");%>>
						<%=SystemEnv.getHtmlLabelName(20621,user.getLanguage())%>&nbsp;&nbsp;
					<%   
						
						rsExtend.executeSql("select id,extendname,extendurl from extendHomepage order by id");
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
							out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"&nbsp;&nbsp;");
						}
					%>




					</TD>
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>	

				<TR>
					<TD COLSPAN=2>
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
							
							int extendHpSoft2Id = 0;
							String logo="";
							//background images
							String bgimg="";;	
							
							String ostimg = "";
							String osdimg = "";
							String istimg = "";
							String iscimg1 = "";
							String iscimg2 = "";
							String isdimg = "";
							
							String fontFamily = "";
							String fontSize = "";
							String skin = "";

							rsExtend.executeSql("select id,logo,bgimg,ostimg, osdimg, istimg, iscimg1, iscimg2, isdimg, fontfamily,fontsize,skin from extendHpSoft2 where templateId="+templateId+" and subcompanyid="+subCompanyId);
							
							if(rsExtend.next()){
								extendHpSoft2Id = Util.getIntValue(rsExtend.getString("id"));
								
								logo = Util.null2String(rsExtend.getString("logo"));	
								bgimg = Util.null2String(rsExtend.getString("bgimg"));
								ostimg = Util.null2String(rsExtend.getString("ostimg"));
								osdimg = Util.null2String(rsExtend.getString("osdimg"));
								istimg = Util.null2String(rsExtend.getString("istimg"));
								iscimg1 = Util.null2String(rsExtend.getString("iscimg1"));
								iscimg2 = Util.null2String(rsExtend.getString("iscimg2"));
								isdimg = Util.null2String(rsExtend.getString("isdimg"));
								fontFamily = Util.null2String(rsExtend.getString("fontfamily"));
								fontSize = Util.null2String(rsExtend.getString("fontsize"));
								skin = Util.null2String(rsExtend.getString("skin"));
								
							}

							%>	
							<input type="hidden" name="extendHpSoft2Id"  value="<%=extendHpSoft2Id%>"/>
					
									<TABLE class=ViewForm>
									<COLGROUP>
									<COL width="30%">									
									<COL width="70%">
									<tr>
										<td><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
										<td class=Field>											
											<INPUT class=InputStyle maxLength=50 id="templateName" name="templateName" value="<%=templateName%>" onchange="checkinput('templateName','templateNameImage')">
											<SPAN id="templateNameImage"></SPAN>
										</td>
										</tr>
										<TR><TD class=Line colSpan=2></TD></TR>

										<td><%=SystemEnv.getHtmlLabelName(18795,user.getLanguage())%></td>
										<td class=Field>
											<INPUT class=InputStyle maxLength=50 id="templateTitle" name="templateTitle" value="<%=templateTitle%>">
										</td>
										</tr>
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
										<td valign="top"><%=SystemEnv.getHtmlLabelName(84207,user.getLanguage())%>(2000*70)</td>
										<td class=Field>										
											<%if(logo.equals("")){%>
												<img src="images/head-bg_wev8.png"/>
											<%}else{%>
												<img src="<%=logo%>">
												<br>
												<a href="javascript:ondelpic('logo')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
											<%}%>
											<br/>
											<input type="file" name="logo" value="">
										</td>
										</tr>

										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(2000*1)</td>
											<td class=Field>	
												<%if(bgimg.equals("")){%>
													<img src="images/body-bg_wev8.png"/>
												<%}else{%>
													<img src="<%=bgimg %>">
													<br>
													<a href="javascript:ondelpic('bgimg')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="bgimg" value="">
											</td>
										</tr>
										
										
										
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(84208,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(31276,user.getLanguage())%>)(200*10)</td>
											<td class=Field>	
												<%if(ostimg.equals("")){%>
													<img src="images/left-area-top_wev8.png"/>
												<%}else{%>
													<img src="<%=ostimg %>">
													<br>
													<a href="javascript:ondelpic('ostimg')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="ostimg" value="">
											</td>
										</tr>
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(84208,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>)(200*1)</td>
											<td class=Field>	
												<%if(osdimg.equals("")){%>
													<img src="images/left-area-bg_wev8.png"/>
												<%}else{%>
													<img src="<%=osdimg %>">
													<br>
													<a href="javascript:ondelpic('osdimg')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="osdimg" value="">
											</td>
										</tr>
										
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(84209,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(31276,user.getLanguage())%>)(180*6)</td>
											<td class=Field>	
												<%if(istimg.equals("")){%>
													<img src="images/left-menu-bottom_wev8.png"/>
												<%}else{%>
													<img src="<%=istimg %>">
													<br>
													<a href="javascript:ondelpic('istimg')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="istimg" value="">
											</td>
										</tr>
										
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(84209,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(22987,user.getLanguage())%>)1(180*1)</td>
											<td class=Field>	
												<%if(iscimg1.equals("")){%>
													<img src="images/left-menu-bottom_wev8.png"/>
												<%}else{%>
													<img src="<%=iscimg1 %>">
													<br>
													<a href="javascript:ondelpic('iscimg1')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="iscimg1" value="">
											</td>
										</tr>
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(84209,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(22987,user.getLanguage())%>)2(180*1)</td>
											<td class=Field>	
												<%if(iscimg2.equals("")){%>
													<img src="images/left-menu-bottom_wev8.png"/>
												<%}else{%>
													<img src="<%=iscimg2 %>">
													<br>
													<a href="javascript:ondelpic('iscimg2')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="iscimg2" value="">
											</td>
										</tr>
										
										<TR><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(84209,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>)(180*6)</td>
											<td class=Field>	
												<%if(isdimg.equals("")){%>
													<img src="images/left-menu-bottom_wev8.png"/>
												<%}else{%>
													<img src="<%=isdimg %>">
													<br>
													<a href="javascript:ondelpic('isdimg')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input type="file" name="isdimg" value="">
											</td>
										</tr>
										
										
										

									    <TR><TD class=Line colSpan=2></TD></TR>

										<tr>
										    <td valign="top"><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%></td>
										    <td class=Field>
												<select name="fontFamily" value="<%=fontFamily %>" size="1" onchange="fontDetecion(this)">
								                	<option value="微软雅黑" <%="微软雅黑".equals(fontFamily) ? " selected" : "" %> ><%=SystemEnv.getHtmlLabelName(84210,user.getLanguage())%></option>
													<option value="宋体"    <%="宋体".equals(fontFamily) ? " selected" : "" %>><%=SystemEnv.getHtmlLabelName(16190,user.getLanguage())%></option>
													<option value="方正" <%="方正".equals(fontFamily) ? " selected" : "" %>><%=SystemEnv.getHtmlLabelName(84211,user.getLanguage())%></option>
								     			</select>
										  	</td>
										</tr>

										<TR><TD class=Line colSpan=2></TD></TR>
										
										<tr>
										  <td valign="top"><%=SystemEnv.getHtmlLabelName(84212,user.getLanguage())%></td>
										  <td class=Field>
										      <input type="text" name="fontSize"  value="<%="".equals(fontSize) ? "10" : fontSize %>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("scan")' style="width:120px">（PX）
										  </td>
										</tr>
							
										<TR>
											<TD class=Line colspan=2></TD>
										</TR>
									
										<tr>
										  <td valign="top"><%=SystemEnv.getHtmlLabelName(84213,user.getLanguage())%></td>
										  <td class=Field>
										      <select name="skin" size="1">
										      <%
										      for(int i=0; i<skins.size(); i++) {
                                                  String skinName = (String)skins.get(i);
                                              %>
                                                  <option value="<%=skinName %>" <%=skinName.trim().equals(skin.trim()) ? " selected " : "" %>><%=skinName %></option>
                                              <% 
                                              }
                                              %>
							     		      </select>
										  </td>
										</tr>
									</TABLE>

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
	if(!obj.checked){
		window.location=url;	
	}
}


function checkSubmit(obj){
	if(check_form(frmMain,"templateName")){
		obj.disabled=true;
		document.frmMain.submit();	
	}
}

function saveAs(obj){
	if(check_form(frmMain,"templateName")){
		document.getElementById("method").value = "saveas";
		obj.disabled=true;
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
		openFullWindowForXtable("index.jsp?from=preview&userSubcompanyId=<%=subCompanyId%>&templateId=<%=templateId%>&extendtempletid=<%=extendtempletid%>")
}
function ondelpic(fieldname){	
	document.getElementById("method").value = "delpic";
	document.getElementById("fieldname").value = fieldname;
	document.frmMain.submit();	
}

</script>
