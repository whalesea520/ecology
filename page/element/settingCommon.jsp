
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>  
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsIn_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="ecc" class="weaver.admincenter.homepage.ElementCustomCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>

<%
	/*
	基本信息
	eib
	ebaseid	
	esharelevel
	strsqlwhere
	*/
%>
<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
	
	String eid=Util.null2String(request.getParameter("eid"));		
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

	int userid = 1;
	int usertype=0;
	userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	//协同区记录
	//if(Util.getIntValue(hpid) < 0)
	//{
	//	userid = user.getUID();
	//	usertype = Util.getIntValue(user.getLogintype());
	//}
	String etitle=hpec.getTitle(eid);
	String eperpage="";
	String elinkmode="";
	String eshowfield="";
	String strsqlwhere=hpec.getStrsqlwhere(eid);
	String esharelevel="";
	

	String  strSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	

	rs_common.executeSql(strSql);
	if(!rs_common.next()){
		int _sharelevel = 1;
		if(isSystemer){
				_sharelevel = 2;
		}
		String insertSql = "insert into hpElementSettingDetail (userid,usertype,eid,linkmode,perpage,showfield,sharelevel,hpid) select "+userid+", "+usertype+", "+eid+", linkmode,perpage,showfield,"+_sharelevel+","+hpid+" from hpElementSettingDetail where eid="+eid+" and userid=1";
		//System.out.println("sttingCommon.jsp:===> insertSql "+ insertSql);
		rs_common.executeSql(insertSql);
	
		rs_common.executeSql(strSql);
	}else{

		rs_common.beforFirst();
	}
	
	if(rs_common.next()){
		eperpage=Util.null2String(rs_common.getString("perpage"));
		elinkmode=Util.null2String(rs_common.getString("linkmode"));
		eshowfield=Util.null2String(rs_common.getString("showfield"));
		esharelevel=Util.null2String(rs_common.getString("sharelevel"));  //1:为查看 2:为编辑
	}
	if("FormModeCustomSearch".equals(ebaseid)&&!"2".equals(esharelevel)){
		List<String> list = pu.getUserMaintHpidListPublic(user.getUID());
		if(!list.contains(hpid)){
			out.println("<p>&nbsp;</p><p>&nbsp;</p>");
			return;	
		}
	}
	
	
	String isFixationRowHeight="";
	String background="";
	String isremind = "";
	strSql="select isFixationRowHeight,background,isremind  from hpelement where id="+eid;	
	rs_common.executeSql(strSql);
	if(rs_common.next()){
		isFixationRowHeight=Util.null2String(rs_common.getString("isFixationRowHeight"));
		background=Util.null2String(rs_common.getString("background"));
		isremind=Util.null2String(rs_common.getString("isremind"));
	}	
	
	//获取元素显示URL，用于元素独立显示
	String indieUrlStr = "";
	String isBaseElementSql = "select isbase from hpBaseElement where id = '"+ebaseid+"'";
	rs_common.executeSql(isBaseElementSql);
	if(rs_common.next()){
		if ("1".equals(rs_common.getString("isbase"))) {
			String contentUrl = ebc.getView(ebaseid);
			if("".equals(contentUrl)) {
				contentUrl = ecc.getView(ebaseid);
			}
			indieUrlStr = contentUrl+"?ebaseid="+ebaseid+"&eid="+eid+"&hpid="+hpid+"&subCompanyId="+subCompanyId+"&indie=true&needHead=true";
		}
	}
	if("-1".equals(eperpage)&&"favourite".equals(ebaseid)){
		eperpage="5";
	}
%>
<input type="hidden" name="_esharelevel_<%=eid%>" value="<%=esharelevel%>">	
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">

<%if(!ebc.getTitle(ebaseid).equals("-1")){%>
	<%if("2".equals(esharelevel)){%>
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19491,user.getLanguage())%></wea:item>
     	<wea:item>
      	 	<INPUT style="width:96%" TYPE="text" maxlength=50 alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50" name="_eTitel_<%=eid%>" id="_eTitel_<%=eid%>" value="<%=etitle%>" class="inputStyle" defautvalue="<%=etitle%>" onblur="checkMaxLength(this)">
      		<%if(!"".equals(indieUrlStr)){%>
      			<img style="cursor: pointer;" src="/images/homepage/menu/link_1_wev8.png" onclick="window.open('<%=indieUrlStr %>');" title="<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>" onmouseover="this.src='/images/homepage/menu/link_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/link_1_wev8.png'">
      		<%}%>
      	</wea:item>
	<%}%>
<%}%>

<%if(!ebc.getPerpage(ebaseid).equals("-1")){%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19493,user.getLanguage())%></wea:item>
   	<wea:item>
   	 	<INPUT TYPE="text"  id="_ePerpage_<%=eid%>" value="<%=eperpage%>" maxlength=3 class="inputStyle" style="width:96%" onkeypress="ItemCount_KeyPress()" onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="ime-mode:Disabled">
   	</wea:item>
<%}%> 
<%if(!ebc.getLinkMode(ebaseid).equals("-1")&&(ebc.getLinkMode(ebaseid).equals("1")||ebc.getLinkMode(ebaseid).equals("2"))){%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%></wea:item>
   	<wea:item>
    	<SELECT id="_eLinkmode_<%=eid%>" >
			<option value="1" <%if("1".equals(elinkmode)) out.println("selected");%>>
			<%=SystemEnv.getHtmlLabelName(19497,user.getLanguage())%></option><!--当前页-->
	
			<option value="2"  <%if("2".equals(elinkmode)) out.println("selected");%>>
			<%=SystemEnv.getHtmlLabelName(19498,user.getLanguage())%></option><!--弹出页-->
		</SELECT>
    </wea:item>
<%}%>


<%
	rs_common.executeSql("select count(*) from hpFieldElement where elementid='"+ebaseid+"'");
	rs_common.next();
	if(rs_common.getInt(1)>0){
	
%>
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></wea:item>
     	<wea:item>
				<%
					ArrayList selectedFieldList=Util.TokenizerString(eshowfield,",");
					rs_common.executeSql("select * from hpFieldElement where elementid='"+ebaseid+"' order by ordernum");
					
					while(rs_common.next()){
						String fieldId=Util.null2String(rs_common.getString("id"));
						String isLimitLength=Util.null2String(rs_common.getString("isLimitLength"));
						int fieldname=Util.getIntValue(rs_common.getString("fieldname"));
						String fieldcolumn=Util.null2String(rs_common.getString("fieldcolumn"));
						String fieldwidth = Util.null2String(rs_common.getString("fieldwidth"));
						
						String strChecked="";
						if(selectedFieldList.contains(fieldId)) strChecked=" checked ";
						out.println("&nbsp;<INPUT TYPE=checkbox NAME='_chkField_"+eid+"' value="+fieldId+" "+strChecked+">");
						out.println(SystemEnv.getHtmlLabelName(fieldname,user.getLanguage()));
						
						String display="none";
						if("2".equals(esharelevel)){
							display="";
						}
							if(fieldcolumn.toLowerCase().equals("img")){
								String imgSize ="";
								String imgWidth ="";
								String imgHeight ="";
								
								boolean autoAdjust = false;
								String autoAdjustCheckStr = "";
								rsIn_common.executeSql("select imgsize from hpFieldLength where eid="+eid+" and efieldid="+fieldId+" and userid="+userid+" and usertype="+usertype);
								if(rsIn_common.next()) imgSize=Util.null2String(rsIn_common.getString("imgsize"));
								if(!imgSize.equals("")){
									ArrayList sizeAry = Util.TokenizerString(imgSize,"*");
									imgWidth = (String)sizeAry.get(0);
									if(sizeAry.size()>1){
										imgHeight = (String)sizeAry.get(1);
									}
									if(imgHeight.equals("0")||imgHeight.equals("")){
										autoAdjust = true;
										autoAdjustCheckStr = "checked";
									}
								}else {
									imgWidth = "120";
									imgHeight = "108";
								}
								if("2".equals(esharelevel)){
									out.println("&nbsp;"+SystemEnv.getHtmlLabelName(203,user.getLanguage())+":<INPUT TYPE = text name='_imgWidth"+eid+"' value='"+imgWidth+"' basefield="+fieldId+" class='inputStyle'  style='display:"+display+";width:35px' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\">");
								}else{
									out.println("&nbsp;<INPUT TYPE = text name='_imgWidth"+eid+"' value='"+imgWidth+"' basefield="+fieldId+" class='inputStyle'  style='display:"+display+";width:35px' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\">");
								}
								if(!autoAdjust){
									out.println("<span id='_imgHeightDiv"+eid+"' style='display:"+display+";width:70px'>&nbsp;"+SystemEnv.getHtmlLabelName(207,user.getLanguage())+":<INPUT TYPE = text name='_imgHeight"+eid+"' value='"+imgHeight+"' basefield="+fieldId+" class='inputStyle'  style='width:35px' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\" ></span>");
								}else{
									out.println("<span id='_imgHeightDiv"+eid+"' style='width:70px;display:none' >&nbsp;"+SystemEnv.getHtmlLabelName(207,user.getLanguage())+":<INPUT TYPE = text name='_imgHeight"+eid+"' value='"+imgHeight+"' basefield="+fieldId+" class='inputStyle'  style='width:35px;' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\" ></span>");
								}
								if("2".equals(esharelevel)){
									out.println("<INPUT style='' TYPE = checkbox name='_imgAutoAdjust"+eid+"' "+autoAdjustCheckStr+" onclick='if(event.srcElement.checked){document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"none\";document.getElementById(\"_imgHeight"+eid+"\").value=0}else{document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"\"}'>&nbsp;"+SystemEnv.getHtmlLabelName(22494,user.getLanguage())+"");
									
								}else{
									out.println("<INPUT style='display:"+display+"' TYPE = checkbox name='_imgAutoAdjust"+eid+"' "+autoAdjustCheckStr+" onclick='if(event.srcElement.checked){document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"none\";document.getElementById(\"_imgHeight"+eid+"\").value=0}else{document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"\"}'>");									
								}	
						}
						
						int wordLength=8;
						//取消字段标题长度设置
						if("1".equals(isLimitLength)&&false) {
							rsIn_common.executeSql("select charnum from hpFieldLength where eid="+eid+" and efieldid="+fieldId+" and userid="+userid+" and usertype="+usertype);
							if(rsIn_common.next()) wordLength=Util.getIntValue(rsIn_common.getString("charnum"));
							if("2".equals(esharelevel)){
								out.println("&nbsp;"+SystemEnv.getHtmlLabelName(19524,user.getLanguage())+":<input name=_wordcount_"+eid+" basefield="+fieldId+" type='text' style='width:24px' class=inputstyle title="+SystemEnv.getHtmlLabelName(19524,user.getLanguage())+" value='"+wordLength+"' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\" >&nbsp;");
							}else{
								out.println("&nbsp;<input name=_wordcount_"+eid+" basefield="+fieldId+" type='text' style='width:24px' class=inputstyle title="+SystemEnv.getHtmlLabelName(19524,user.getLanguage())+" value='"+wordLength+"' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\">&nbsp;");
							}
						}
						out.println("<br>");
					}
				%>
		</wea:item>
<%
}	
	
%>	
	</wea:group>
</wea:layout>