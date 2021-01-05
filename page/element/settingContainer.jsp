
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>  
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />

<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
	
	String eid=Util.null2String(request.getParameter("eid"));		
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

	String type=Util.null2String(request.getParameter("type"));
	
	String esharelevel="";

	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	String randomValue = Util.null2String(request.getParameter("random"));
	String  strSql="select  sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	
	//System.out.println(strSql);
	rs_common.executeSql(strSql);
	if(rs_common.next()){	
		esharelevel=Util.null2String(rs_common.getString("sharelevel"));  //1:为查看 2:为编辑
	}
%>
<%if("content".equals(type)){%>
	<%
		String url=ebc.getSetting(ebaseid)+"?ebaseid="+ebaseid+"&eid="+eid+"&hpid="+hpid+"&subCompanyId="+subCompanyId+"&randomValue="+randomValue;
	%>
	
	 <jsp:include page="<%=url%>" flush="true" />
<%} else if("style".equals(type)){%>	
	<table class="viewform" width="100%">
		<colgroup>
			<col width="40%"/>
			<col width="60%"/>
		</colgroup>		
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(22913,user.getLanguage())%><!--模板--></td>
			
			
			<td class="field">
				<select name="eStyleid_<%=eid%>" id="eStyleid_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%> style="width:98%">
				<%
					esc.setTofirstRow();						
					while(esc.next()){
						String styleid=esc.getId();
						String stylename=esc.getTitle();
						//System.out.println(styleid+":"+hpec.getStyleid(eid));
						if(styleid.equals(hpec.getStyleid(eid))){
							out.println("<option value='"+styleid+"' selected>"+stylename+"</option>");
						} else {
							out.println("<option value='"+styleid+"'>"+stylename+"</option>");
						}
						
					}
				%>
				</select>
			</td>		
		</tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(19492,user.getLanguage())%></td>
			<td class="field"><input name="eLogo_<%=eid%>" onchanage="setElementLogo('<%=eid%>',this.value)" id="eLogo_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%> type="text" value="<%=hpec.getLogo(eid)%>">

			</td>		
		</tr>	
		<tr><td colspan="2" class="line"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%><!--高度--></td>
			<td class="field">
				<%
					int eHeight=Util.getIntValue(hpec.getHeight(eid),0);
				%>
				<input  name="eHeight_<%=eid%>" class="inputstyle" onchange="setElementHeight(<%=eid%>,this.value)" onkeypress="ItemCount_KeyPress()"  style='width:98%' id="eHeight_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=eHeight%>"><br>
				0:<%=SystemEnv.getHtmlLabelName(22494,user.getLanguage())%><!--0:自适应高度-->
			</td>		
		</tr>	
		<tr><td colspan="2" class="line"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%><!--间距--></td>
			<td class="field">
				<%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%>:<input  onchange="setElementMarginTop('<%=eid%>',this.value)" name="eMarginTop_<%=eid%>" class="inputstyle" style='width:20px' onkeypress="ItemCount_KeyPress()" id="eMarginTop_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginTop(eid)%>">
				<%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%>:<input  onchange="setElementMarginBottom('<%=eid%>',this.value)" name="eMarginBottom_<%=eid%>" class="inputstyle" style='width:20px' onkeypress="ItemCount_KeyPress()" id="eMarginBottom_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginBottom(eid)%>">
				<%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%>:<input  onchange="setElementMarginLeft('<%=eid%>',this.value)" name="eMarginLeft_<%=eid%>" class="inputstyle" style='width:20px' onkeypress="ItemCount_KeyPress()" id="eMarginLeft_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginLeft(eid)%>">
				<%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%>:<input  onchange="setElementMarginRight('<%=eid%>',this.value)" name="eMarginRight_<%=eid%>" class="inputstyle" style='width:20px' onkeypress="ItemCount_KeyPress()" id="eMarginRight_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginRight(eid)%>">
			</td>		
		</tr>	
		<tr><td colspan="2" class="line"></td></tr>
		
	</table>
<%} else if("share".equals(type)){
	//String shareUrl = "element"
	//response.sendRedirect("/page/element/ElementShare.jsp");
	if("2".equals(esharelevel)){
%>
	<iframe id="eShareIframe_<%=eid%>" name="eShareIframe_<%=eid%>" src="/page/element/ElementShare.jsp?esharelevel=<%=esharelevel %>&eid=<%=eid%>" width=100% frameborder="0" marginheight="0" marginwidth="0"></iframe>
	<%}else{%>
	<iframe id="eShareIframe_<%=eid%>" name="eShareIframe_<%=eid%>" src="/page/element/noright.jsp" width=100% frameborder="0" marginheight="0" marginwidth="0"></iframe>
	
	<%} %>
<%} %>
	<SCRIPT LANGUAGE="JavaScript">
		$("#eLogo_<%=eid%>").filetree();
  	</SCRIPT>
	