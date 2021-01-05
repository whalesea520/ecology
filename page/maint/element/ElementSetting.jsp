
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.page.element.compatible.PageTableLayout"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsIn_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsOfs_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="wp" class="weaver.admincenter.homepage.WeaverPortal" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="ecc" class="weaver.admincenter.homepage.ElementCustomCominfo" scope="page"/>
<jsp:useBean id="wbec" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page" />
<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
	

	String type=Util.null2String(request.getParameter("type"));
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));
	String eid=Util.null2String(request.getParameter("eid"));		
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String randomValue = Util.null2String(request.getParameter("random"));
	
	String hpid = "";
	String isremind = "";
	String eperpage="5";
	String elinkmode="";
	String eshowfield="";
	String esharelevel="";
	String tempGroupName = "";
	rs.executeSql("select hpid,isremind from hpelement where id="+eid);
	if(rs.next()){
		hpid = rs.getString("hpid");
	}
	int userid = 1;
	int usertype=0;
	userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	//协同区记录
	if(Util.getIntValue(hpid) < 0)
	{
		isSystemer = true;
		//协同 userid  和 usertype 分别固定位 1  和 0 
	    userid = 1;
	    usertype = 0;
	}
	String  strSql="select perpage,linkmode,showfield,sharelevel,isremind from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;
	rs.executeSql(strSql);
	if(rs.next()){
		eperpage=Util.null2String(rs.getString("perpage"));
		elinkmode=Util.null2String(rs.getString("linkmode"));
		eshowfield=Util.null2String(rs.getString("showfield"));
		esharelevel=Util.null2String(rs.getString("sharelevel"));  //1:为查看 2:为编辑
	    isremind = rs.getString("isremind");
	}
	
%>

<%if("content".equals(type)){ %> 
    <form id="setting_form_<%=eid%>">
    <%
	String setUrl = "3".equals(wbec.getEtype(ebaseid))?ecc.getSettingUrl(ebaseid):ebc.getSetting(ebaseid);
	//System.out.println("=============="+setUrl);
	if(!"".equals(setUrl)&&setUrl.indexOf("/page/element/compatible/")==-1){
		String includePage = setUrl+"?ebaseid="+ebaseid+"&eid="+eid+"&hpid="+hpid+"&subCompanyId="+subCompanyId+"&randomValue="+randomValue;
	%>
		<jsp:include page="<%=includePage%>" flush="true" />
	<%	return;
	}else{
		//out.print(wp.getElementTabContent(request));
		//System.out.print(wp.getElementTabContent(request));
	}
	String etitle=hpec.getTitle(eid);
	String strsqlwhere=hpec.getStrsqlwhere(eid);
	strSql="select perpage,linkmode,showfield,sharelevel,isremind from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	

	rs_common.executeSql(strSql);
	if(!rs_common.next()){
		int _sharelevel = 1;
		if(isSystemer){
				_sharelevel = 2;
		}
		String insertSql = "insert into hpElementSettingDetail (userid,usertype,eid,linkmode,perpage,showfield,sharelevel,hpid) select "+userid+", "+usertype+", "+eid+", linkmode,perpage,showfield,"+_sharelevel+","+hpid+" from hpElementSettingDetail where eid="+eid+" and userid=1";
		//System.out.println("ElementSetting.jsp:===>insertSql"+insertSql);
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
		//提醒方式
		isremind=Util.null2String(rs_common.getString("isremind"));
	}
	
	String isFixationRowHeight="";
	String background="";
	strSql="select isFixationRowHeight,background,isremind  from hpelement where id="+eid;	
	rs_common.executeSql(strSql);
	if(rs_common.next()){
		isFixationRowHeight=Util.null2String(rs_common.getString("isFixationRowHeight"));
		background=Util.null2String(rs_common.getString("background"));
	}
		//String url=ebc.getSetting(ebaseid)+"?ebaseid="+ebaseid+"&eid="+eid+"&hpid="+hpid+"&subCompanyId="+subCompanyId+"&randomValue="+randomValue;
	
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
	PageTableLayout ptl = null;
	List fieldnamelist = null;
	List fieldlist = null;
	List fieldtypelist = null;
	if("2".equals(esharelevel)){
		String settingshowmethod=Util.null2String(ebc.getSettingMethod(ebaseid));	
		if(!"".equals(settingshowmethod)){
			Class tempClass = Class.forName("weaver.page.element.compatible.PageTableLayoutWhere");
			if(ebaseid.equals("7")||ebaseid.equals("8")||ebaseid.equals("1")||ebaseid.equals("29")||"reportForm".equals(ebaseid)){
				Method tempMethod = tempClass.getMethod(settingshowmethod, new Class[] { String.class, String.class, String.class, String.class,String.class,String.class  });
				Constructor ct = tempClass.getConstructor(null);
	
				ptl=(PageTableLayout)tempMethod.invoke(ct.newInstance(null), new Object[] {eid,ebaseid,strsqlwhere,""+user.getLanguage(),esharelevel,randomValue});
			}else{
				Method tempMethod = tempClass.getMethod(settingshowmethod, new Class[] { String.class, String.class, String.class, String.class,String.class});
				Constructor ct = tempClass.getConstructor(null);
	
				ptl=(PageTableLayout)tempMethod.invoke(ct.newInstance(null), new Object[] {eid,ebaseid,strsqlwhere,""+user.getLanguage(),esharelevel});
			}
			//out.println("\n"+strSettingWhere+"\n");
			//out.println("<TR valign='top'><TD colspan=2 class=line></TD></TR>\n");
			//System.out.println(ptl+"===");
			fieldnamelist = ptl.getFieldNameList();
			fieldlist = ptl.getFieldList();
			fieldtypelist = ptl.getFieldTypeList();
		}
	}
	%>
	<input type="hidden" name="_esharelevel_<%=eid%>" value="<%=esharelevel%>">
	<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
      <%if(!ebc.getTitle(ebaseid).equals("-1")){%>
		<%if("2".equals(esharelevel)){%>
      	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19491,user.getLanguage())%></wea:item>
     	<wea:item>
      	 	<INPUT TYPE="text" maxlength=50 alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>50" name="_eTitel_<%=eid%>" id="_eTitel_<%=eid%>" value="<%=etitle%>" class="inputStyle" defautvalue="<%=etitle%>" onblur="checkMaxLength(this)">
      		<%if(!"".equals(indieUrlStr)){%>
      			<img style="cursor: pointer;" src="/images/homepage/menu/link_1_wev8.png" onclick="window.open('<%=indieUrlStr %>');" title="<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>" onmouseover="this.src='/images/homepage/menu/link_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/link_1_wev8.png'">
      		<%}%>
      	</wea:item>
      	<%}
		} 
		if(!ebc.getPerpage(ebaseid).equals("-1")){%>
      	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19493,user.getLanguage())%></wea:item>
     	<wea:item>
      	 	<INPUT TYPE="text"  id="_ePerpage_<%=eid%>" name=_ePerpage_<%=eid%> value="<%=eperpage%>" maxlength=3 class="inputStyle" onkeypress="ItemCount_KeyPress()" onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="ime-mode:Disabled">
      	</wea:item>
      	<%}
		if(!ebc.getLinkMode(ebaseid).equals("-1")&&(ebc.getLinkMode(ebaseid).equals("1")||ebc.getLinkMode(ebaseid).equals("2"))){%>
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%></wea:item>
     	<wea:item>
      	 	<SELECT id="_eLinkmode_<%=eid%>" >
      	 	  <% if(Util.getIntValue(hpid) > 0){//协同无 当前页打开方式 %>
				<option value="1" <%if("1".equals(elinkmode)) out.println("selected");%>>
				<%=SystemEnv.getHtmlLabelName(19497,user.getLanguage())%></option><!--当前页-->
              <%} %>
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
					
					//统一待办异构系统集成参数
					int isUse = 0; // 0未启用, 1启用
					String showSysName = "0"; // 0不显示系统名称, 1显示系统简称, 2显示系统全称
					if ("8".equals(ebaseid)) { // 流程中心元素才会去查询异构系统集成参数
						rsOfs_common.executeSql("select IsUse,ShowSysName from ofs_setting");
						if(rsOfs_common.next()) {
							isUse = rsOfs_common.getInt("IsUse");
							showSysName = rsOfs_common.getString("ShowSysName");
						}
					}
					
					while(rs_common.next()){
						String fieldId=Util.null2String(rs_common.getString("id"));
						String isLimitLength=Util.null2String(rs_common.getString("isLimitLength"));
						int fieldname=Util.getIntValue(rs_common.getString("fieldname"));
						String fieldcolumn=Util.null2String(rs_common.getString("fieldcolumn"));
						String fieldwidth = Util.null2String(rs_common.getString("fieldwidth"));
						
						//统一待办异构系统开启且显示系统名称, 流程中心元素开启"系统名称"字段选项
						if ("8".equals(ebaseid) && "sysname".equals(fieldcolumn) && !(1 == isUse && !"0".equals(showSysName))) {
							continue;
						}
						
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
									out.println("<span id='_imgHeightDiv"+eid+"' style='display:"+display+";width:70px'>&nbsp;"+SystemEnv.getHtmlLabelName(207,user.getLanguage())+":<INPUT TYPE = text id='_imgHeight"+eid+"' name='_imgHeight"+eid+"' value='"+imgHeight+"' basefield="+fieldId+" class='inputStyle'  style='width:35px' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\" ></span>");
								}else{
									out.println("<span id='_imgHeightDiv"+eid+"' style='width:70px;display:none' >&nbsp;"+SystemEnv.getHtmlLabelName(207,user.getLanguage())+":<INPUT TYPE = text id='_imgHeight"+eid+"' name='_imgHeight"+eid+"' value='"+imgHeight+"' basefield="+fieldId+" class='inputStyle'  style='width:35px;' onkeypress=\"ItemCount_KeyPress()\" onpaste=\"return !clipboardData.getData('text').match(/\\D/)\" ondragenter=\"return false\" style=\"ime-mode:Disabled\" ></span>");
								}
								if("2".equals(esharelevel)){
									out.println("<INPUT style='' TYPE = checkbox name='_imgAutoAdjust"+eid+"' "+autoAdjustCheckStr+" onclick='if(event.srcElement.checked){document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"none\";document.getElementById(\"_imgHeight"+eid+"\").value=0}else{document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"\"}'>&nbsp;"+SystemEnv.getHtmlLabelName(22494,user.getLanguage())+"");
									
								}else{
									out.println("<INPUT style='display:"+display+"' TYPE = checkbox name='_imgAutoAdjust"+eid+"' "+autoAdjustCheckStr+" onclick='if(event.srcElement.checked){document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"none\";document.getElementById(\"_imgHeight"+eid+"\").value=0}else{document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"\"}'>");									
								}	
						}
						
						int wordLength=8;
						if("1".equals(isLimitLength)&false) {
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
      	<%} 
	if(ptl !=  null ){
		for(int i=0;i<fieldnamelist.size();i++){
			String fieldtype = (String)fieldtypelist.get(i);
			if("field".equals(fieldtype)){%>
				<wea:item>&nbsp;<%=fieldnamelist.get(i)%></wea:item>
				<%if("19".equals(ebaseid)){ %>
					<wea:item><%=fieldlist.get(i)%></wea:item>
				<%}else{ %>
				    <wea:item>&nbsp;<%=fieldlist.get(i)%></wea:item>
				<%} %>
				
			<%}else if("browser".equals(fieldtype)){%>
				<wea:item>&nbsp;<%=fieldnamelist.get(i)%></wea:item>
				<wea:item>&nbsp;</wea:item>
			<%}else if("table".equals(fieldtype)&& !("7".equals(ebaseid)|| "8".equals(ebaseid)||"1".equals(ebaseid)||"29".equals(ebaseid)||"reportForm".equals(ebaseid))){%>
				<wea:item>&nbsp;<%=fieldnamelist.get(i)%></wea:item>
				 <wea:item>&nbsp;<%=fieldlist.get(i)%></wea:item>
				 <%
			}
		}
	}
	String tempremind;
	if(isremind.indexOf("#")>-1){
		tempremind=isremind.substring(0,isremind.indexOf("#")-1);
	}else{
		tempremind=isremind;
	}
		//仅新闻中心，流程中心 ,文档中心添加 提醒类型
	if(ebaseid.equals("17") || ebaseid.equals("7") || ebaseid.equals("8")) {  %>
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></wea:item>
    	<wea:item>
    	    <span>
      	 	&nbsp;<input type="checkbox" id="isnew_<%=eid%>" name="isnew_<%=eid%>" value="isnew" <%=tempremind.indexOf("0")!=-1?"checked":"" %>/> <%=SystemEnv.getHtmlLabelName(82757,user.getLanguage())%>				
			<input type="checkbox" id="isbold_<%=eid%>" name="isbold_<%=eid%>" value="isbold" <%=tempremind.indexOf("1")!=-1?"checked":"" %>/> <%=SystemEnv.getHtmlLabelName(16198,user.getLanguage())%>
			<input type="checkbox" id="islean_<%=eid%>" name="islean_<%=eid%>" value="islean" <%=tempremind.indexOf("2")!=-1?"checked":"" %>/> <%=SystemEnv.getHtmlLabelName(16199,user.getLanguage())%>
			<input type="checkbox" id="isrgb_<%=eid%>" name="isrgb_<%=eid%>"  value="isrgb"   <%=tempremind.indexOf("3")!=-1?"checked":"" %>/> <%=SystemEnv.getHtmlLabelName(83739,user.getLanguage())%>
			<input class="color" id="newcolor_<%=eid%>" onchange="color_onchange('isrgb_<%=eid%>',this)" name="newcolor_<%=eid%>" value="<%=isremind.indexOf("#")==-1?"000000":isremind.substring(isremind.indexOf("#")+1) %>"/>
		</span>
     	</wea:item>
   <% }%>
   </wea:group>
	<%	
	if(ptl !=  null && ("7".equals(ebaseid)|| "8".equals(ebaseid)||"1".equals(ebaseid)||"29".equals(ebaseid)||"reportForm".equals(ebaseid))){
			%>
		<wea:group context='tempGroupTitleWillBeReName' attributes="{'class':\"e8_title e8_title_1\"}">
			<% 
			for(int i=0;i<fieldnamelist.size();i++){
				String fieldtype = (String)fieldtypelist.get(i);
				if("table".equals(fieldtype)){
				    tempGroupName = (String)fieldnamelist.get(i);%>
					<wea:item  attributes="{\"isTableList\":\"true\"}"><%=fieldlist.get(i)%></wea:item>
				<%}else if("toolBar".equals(fieldtype)){%>
					<wea:item type='groupHead'>&nbsp;<%=fieldlist.get(i)%>&nbsp;</wea:item>
				<%}
			}
			%>
		</wea:group>
<% 
	}
%>
</wea:layout> 	
<script>
	<%
	if("7".equals(ebaseid)|| "8".equals(ebaseid)||"1".equals(ebaseid)||"29".equals(ebaseid)||"reportForm".equals(ebaseid)){
		String tableId = "tabSetting_";
	%>
		$(document).ready(function(){
			jQuery("tr.notMove").bind("mousedown", function() {
				return false;
			});
			$("#<%=tableId+eid%>").find("tr")
				.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
				.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
			setGroupNewName('<%=tempGroupName%>');
			registerDragEvent('<%=tableId%>','<%=eid%>');
		})
		function setGroupNewName(newGroupName){
			var obj = $('#setting_<%=eid%>').find('.LayoutTable').find('span.e8_grouptitle');
			for(var i=0;i<obj.length; i++){
				if($(obj[i]).text()=='tempGroupTitleWillBeReName'){
					$(obj[i]).text(newGroupName);
					break;
				}
			}
		}
	<%}%>
</script>
</form>

<%} else if("style".equals(type)){%>
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'  attributes="{'class':\"e8_title e8_title_1\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(22913,user.getLanguage())%><!--模板--></wea:item>
      <wea:item>
         <select name="eStyleid_<%=eid%>" id="eStyleid_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%> style="width:98%;">
		<%
			esc.setTofirstRow();						
			while(esc.next()){
				String styleid=esc.getId();
				String stylename=esc.getTitle();
				//System.out.println(styleid+":"+hpec.getStyleid(eid));
				if(styleid.equals(hpec.getStyleid(eid))){
					out.println("<option value='"+styleid+"' selected>"+stylename+"</option>");
				} else {
					//if(Util.getIntValue(hpid) < 0)
					//{
						//if(styleid.length() == 9 && styleid.substring(0,8).equals("synergys"))
						//{
							//out.println("<option value='"+styleid+"'>"+stylename+"</option>");
						//}
					//}else
					out.println("<option value='"+styleid+"'>"+stylename+"</option>");
				}
				
			}
		%>
		</select>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(19492,user.getLanguage())%><!--图标--></wea:item>
      <wea:item>
      	 <input name="eLogo_<%=eid%>" onchanage="setElementLogo('<%=eid%>',this.value)" id="eLogo_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getLogo(eid)%>">
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%><!--图标--></wea:item>
      <wea:item>
      	 <%
			int eHeight=Util.getIntValue(hpec.getHeight(eid),0);
		%>
		<input  name="eHeight_<%=eid%>" class="inputstyle" onchange="setElementHeight(<%=eid%>,this.value)" onkeypress="ItemCount_KeyPress()"  id="eHeight_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=eHeight%>"><br>
		0:<%=SystemEnv.getHtmlLabelName(22494,user.getLanguage())%><!--0:自适应高度-->
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%><!--图标--></wea:item>
      <wea:item>
         <span style="display: block;padding-top: 5px;">
	      	 <%=SystemEnv.getHtmlLabelName(23009,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%>:<input  onchange="setElementMarginTop('<%=eid%>',this.value)" name="eMarginTop_<%=eid%>" class="inputstyle" style='width:30px!important;' onkeypress="ItemCount_KeyPress()" id="eMarginTop_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginTop(eid)%>">
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%>:<input  onchange="setElementMarginBottom('<%=eid%>',this.value)" name="eMarginBottom_<%=eid%>" class="inputstyle" style='width:30px!important;' onkeypress="ItemCount_KeyPress()" id="eMarginBottom_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginBottom(eid)%>">
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%>:<input  onchange="setElementMarginLeft('<%=eid%>',this.value)" name="eMarginLeft_<%=eid%>" class="inputstyle" style='width:30px!important;' onkeypress="ItemCount_KeyPress()" id="eMarginLeft_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginLeft(eid)%>">
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%>:<input  onchange="setElementMarginRight('<%=eid%>',this.value)" name="eMarginRight_<%=eid%>" class="inputstyle" style='width:30px!important;' onkeypress="ItemCount_KeyPress()" id="eMarginRight_<%=eid%>" <%if(!"2".equals(esharelevel)) out.println("disabled");%>  type="text" value="<%=hpec.getMarginRight(eid)%>">
         </span>
      </wea:item>
	</wea:group>
</wea:layout>      	
<%} else if("share".equals(type)){
	//String shareUrl = "element"
	//response.sendRedirect("/page/element/ElementShare.jsp");
	if("2".equals(esharelevel)){
%>
	<iframe id="eShareIframe_<%=eid%>" name="eShareIframe_<%=eid%>" src="/page/element/ElementShare.jsp?esharelevel=<%=esharelevel %>&eid=<%=eid%>" width=100% height="350px" frameborder="0" marginheight="0" marginwidth="0"></iframe>
	<%}else{%>
	<iframe id="eShareIframe_<%=eid%>" name="eShareIframe_<%=eid%>" src="/page/element/noright.jsp" width=100% frameborder="0" marginheight="0" height="350px" marginwidth="0"></iframe>
	
	<%} %>
<%} %>
	<SCRIPT LANGUAGE="JavaScript">
		$("#eLogo_<%=eid%>").filetree();
  	</SCRIPT>
