
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageCominfo" scope="page" />
<%
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int templateId = Util.getIntValue(request.getParameter("templateId"));
	int extendtempletid = Util.getIntValue(request.getParameter("extendtempletid"));


	//System.out.println("extendtempletid:"+extendtempletid);
	

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";   

	int userid= user.getUID();
	String canCustom = pm.getConfig().getString("portal.custom");
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
<input  name="method" id="method" type="hidden" value="edit"/>
<input name="templateId" id="templateId" type="hidden" value="<%=templateId%>"/>
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" name="extendtempletid" id="extendtempletid"  value="<%=extendtempletid%>"/>
<input type="hidden" name="fieldname" id="fieldname"/>


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
							if(extendtempletid==id) strChecked=" checked ";
							if (id == 3) {
								out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">"+SystemEnv.getHtmlLabelName(28112,user.getLanguage())+"</span>)&nbsp;&nbsp;");
								out.println("<input type='radio' onclick=\"chkExtendClick(this,'/systeminfo/template/templateEdit.jsp?id=" + templateId + "&subCompanyId=" + subCompanyId + "&commonTemplet=1')\" value=\"0\" name=\"extendtempletid\" style=\"width:18px\""  + ((extendtempletid==0) ? " checked " : "") + ">" + SystemEnv.getHtmlLabelName(20621,user.getLanguage()) + "(<span style=\"color:red;\">"+SystemEnv.getHtmlLabelName(31556,user.getLanguage())+"</span>)&nbsp;&nbsp;");
							} else {
								out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">"+SystemEnv.getHtmlLabelName(31556,user.getLanguage())+"</span>)&nbsp;&nbsp;");								
							}
						}


						

					%>




					</TD>
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>	

				<TR>
					<TD COLSPAN=2>
						<%
							
							String templateName="",templateTitle="",logo="",isOpen="";
							int extendHpWeb1Id=0;
							String defaultHp="";
							boolean saved=false;
							String sql = "SELECT * FROM SystemTemplate WHERE id="+templateId;
							rs.executeSql(sql);
							if(rs.next()){
								templateName = rs.getString("templateName");
								templateTitle = rs.getString("templateTitle");								
								isOpen = rs.getString("isOpen").equals("1") ? "1" : "0";
								defaultHp =  rs.getString("defaultHp");
								String tempextendtempletid = Util.null2String(rs.getString("extendtempletid"));	
								String tempextendtempletvalueid = Util.null2String(rs.getString("extendtempletvalueid"));	

								//System.out.println("tempextendtempletid:"+tempextendtempletid);
								//System.out.println("tempextendtempletvalueid:"+tempextendtempletvalueid);
								if("1".equals(tempextendtempletid)&&!"".equals(tempextendtempletvalueid)) saved=true;
							}

							
							String navimg="";
							String flash1="";;	
							String flash2="";
							String flash3="";
							String flash4="";
							String flash5="";
							String copyinfo="";
							String hiddenLMenu="";
							rsExtend.executeSql("select id,logo,hiddenLMenu,navimg,flash1,flash2,flash3,flash4,flash5,copyinfo from extendHpWeb1 where templateId="+templateId+" and subcompanyid="+subCompanyId);
							if(rsExtend.next()){
								extendHpWeb1Id=Util.getIntValue(rsExtend.getString("id"));
								logo=Util.null2String(rsExtend.getString("logo"));	
								navimg=Util.null2String(rsExtend.getString("navimg"));	
								flash1=Util.null2String(rsExtend.getString("flash1"));	
								flash2=Util.null2String(rsExtend.getString("flash2"));
								flash3=Util.null2String(rsExtend.getString("flash3"));
								flash4=Util.null2String(rsExtend.getString("flash4"));
								flash5=Util.null2String(rsExtend.getString("flash5"));
								copyinfo=Util.null2String(rsExtend.getString("copyinfo"));
								hiddenLMenu=Util.null2String(rsExtend.getString("hiddenLMenu"));
							}
							%>	
							<input type="hidden" name="extendHpWeb1Id"  value="<%=extendHpWeb1Id%>"/>
					
									<TABLE class=ViewForm>
									<COLGROUP>
									<COL width="30%">									
									<COL width="70%">
									<tr>
										<td><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
										<td class=Field>
										    <input type="hidden" id="oldTemplateName" value="<%=templateName%>">											
											<INPUT class=InputStyle maxLength=50 id="templateName" name="templateName" value="<%=templateName%>" onchange="checkinput('templateName','templateNameImage')">
											<SPAN id="templateNameImage"></SPAN>
										</td>
										</tr>
										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

										<td><%=SystemEnv.getHtmlLabelName(18795,user.getLanguage())%></td>
										<td class=Field>
											<INPUT class=InputStyle maxLength=50 id="templateTitle" name="templateTitle" value="<%=templateTitle%>">
										</td>
										</tr>
										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

										<td><%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%></td>
										<td class=Field>
											<input style="width:20px" type="checkbox" name="txtHiddenLMenu" value="1" <%if("1".equals(hiddenLMenu))out.println("checked");%>>
											<%=SystemEnv.getHtmlLabelName(21272,user.getLanguage())%>
										</td>
										</tr>
										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
										<td style=""><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></td>
										<td class=Field>
										<select id='defaultHp' name='defaultHp'>
											<option value='-1'>&nbsp;</option>
											<%
											pm.setTofirstRow();
											while(pm.next()){
												if("1".equals(pm.getIsUse())&&!"-1".equals(pm.getSubcompanyid())){
													if(defaultHp.equals(pm.getId())){
														out.println("<option value='"+pm.getId()+"' selected>"+pm.getInfoname()+"</option>");
													}else{
														out.println("<option value='"+pm.getId()+"'>"+pm.getInfoname()+"</option>");
													}
												}
											
											} 
											%>
										</select>
										</tr>
										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
										<td valign="top">Logo(180*75)</td>
										<td class=Field>										
											<%if(logo.equals("")){%>
												<img src="images/logo_wev8.jpg"/>
											<%}else{%>
												<img src="<%=logo%>">
												<br>
												<a href="javascript:ondelpic('logo')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
											<%}%>
											<br/>
											<input class="inputstyle" type="file" name="logo" value="">
										</td>
										</tr>

										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

										<tr>										
										<td valign="top"><%=SystemEnv.getHtmlLabelName(20623,user.getLanguage())%>(180*50)</td>
										<td class=Field>											
											<%if(navimg.equals("")){%>
												<img src="images/nav_wev8.jpg"/>
											<%}else{%>
												<img src="<%=navimg%>">
												<br>
												<a href="javascript:ondelpic('navimg')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
											<%}%>
											<br/>
											<input class="inputstyle" type="file" name="navimg" value="">
										</td>
										</tr>

										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>1(860*115)</td>
											<td class=Field>	
												<%if(flash1.equals("")){%>
													<img src="images/flash_wev8.jpg"/>
												<%}else{%>
													<img src="<%=flash1%>">
													<br>
													<a href="javascript:ondelpic('flash1')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input class="inputstyle" type="file" name="flash1" value="">
											</td>
										</tr>

									


										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>2(860*115)</td>
											<td class=Field>	
												<%if(flash2.equals("")){%>
												
												<%}else{%>
													<img src="<%=flash2%>">
													<br>
													<a href="javascript:ondelpic('flash2')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input class="inputstyle" type="file" name="flash2" value="">
											</td>
										</tr>


										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>3(860*115)</td>
											<td class=Field>	
												<%if(flash3.equals("")){%>
												
												<%}else{%>
													<img src="<%=flash3%>">
													<br>
													<a href="javascript:ondelpic('flash3')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input class="inputstyle" type="file" name="flash3" value="">
											</td>
										</tr>


										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>4(860*115)</td>
											<td class=Field>	
												<%if(flash4.equals("")){%>
												
												<%}else{%>
													<img src="<%=flash4%>">
													<br>
													<a href="javascript:ondelpic('flash4')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input class="inputstyle" type="file" name="flash4" value="">

											</td>
										</tr>


										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>5(860*115)</td>
											<td class=Field>	
												<%if(flash5.equals("")){%>
												
												<%}else{%>
													<img src="<%=flash5%>">
													<br>
													<a href="javascript:ondelpic('flash5')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
												<%}%>
												<br/>
												<input class="inputstyle" type="file" name="flash5" value="">
											</td>
										</tr>


										<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
										<tr>
											<td valign="top"><%=SystemEnv.getHtmlLabelName(20804,user.getLanguage())%></td>
											<td class=Field>												
												<textarea style="width:600px;height:300px" name="copyinfo"><%=copyinfo%></textarea>
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
	if(obj.checked){
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
		//document.getElementById("method").value = "saveas";
		//obj.disabled=true;
		//document.frmMain.submit();		
		
		if(document.getElementById("templateName").value==document.getElementById("oldTemplateName").value){
			var str="<%=SystemEnv.getHtmlLabelName(18971,user.getLanguage())%>";
			if(confirm(str)){
				document.getElementById("method").value = "saveas";
				obj.disabled=true;
				document.frmMain.submit();
				//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
			}
		}else{
			document.getElementById("method").value = "saveas";
			obj.disabled=true;
			document.frmMain.submit();
			//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		}
		
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
