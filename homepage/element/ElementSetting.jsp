
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsWhere" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hw" class="weaver.homepage.HomepageWhere" scope="page"/>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="hpewc" class="weaver.homepage.cominfo.HomepageElementWhereCominfo" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpbec" class="weaver.homepage.cominfo.HomepageBaseElementCominfo" scope="page"/>

<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/xloadtree/xtree4workflow_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4workflow_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>

<%@ include file="/page/maint/common/initNoCache.jsp"%>  
<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
	
	String eid=Util.null2String(request.getParameter("eid"));		
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	int userid=hpu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=hpu.getHpUserType(hpid,""+subCompanyId,user);

	String etitle=hpec.getTitle(eid);
	String eperpage="";
	String elinkmode="";
	String eshowfield="";
	String strsqlwhere=hpec.getStrsqlwhere(eid);
	String esharelevel="";


	String  strSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	
	rs.executeSql(strSql);
	if(rs.next()){
		eperpage=Util.null2String(rs.getString("perpage"));
		elinkmode=Util.null2String(rs.getString("linkmode"));
		eshowfield=Util.null2String(rs.getString("showfield"));
		esharelevel=Util.null2String(rs.getString("sharelevel"));  //1:为查看 2:为编辑
	}
	
	String isFixationRowHeight="";
	String background="";
	strSql="select isFixationRowHeight,background  from hpelement where id="+eid;	
	rs.executeSql(strSql);
	if(rs.next()){
		isFixationRowHeight=Util.null2String(rs.getString("isFixationRowHeight"));
		background=Util.null2String(rs.getString("background"));
	}	
%>
<input type="hidden" name="_esharelevel_<%=eid%>" value="<%=esharelevel%>">

<TABLE bgcolor=#FFFFFF class=viewForm  valign='top'>		
  <%if(!hpbec.getTitle(ebaseid).equals("-1")){%>
  <%if("2".equals(esharelevel)){%>
		<TR valign='top'>
			<TD width="20%">&nbsp;<%=SystemEnv.getHtmlLabelName(19491,user.getLanguage())%></TD><!--元素标题-->
			<TD width="80%" class=field>
				<INPUT style="width:98%" TYPE="text" id="_eTitel_<%=eid%>" value="<%=etitle%>" class="inputStyle">
			</TD>
		</TR>
		<TR valign='top'><TD colspan=2 class=line></TD></TR>
	<%}%>
  <%}%>
  <%if(!hpbec.getPerpage(ebaseid).equals("-1")){%>
    <TR valign='top'>
		<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(19493,user.getLanguage())%></TD><!--显示条数-->
		<TD  class=field><INPUT TYPE="text"  id="_ePerpage_<%=eid%>" value="<%=eperpage%>"  class="inputStyle" style="width:98%"></TD>
	</TR>
    <TR valign='top'><TD colspan=2 class=line></TD></TR>
   <%}%>
  <%
  if(!hpbec.getLinkmode(ebaseid).equals("-1")&&(hpbec.getLinkmode(ebaseid).equals("1")||hpbec.getLinkmode(ebaseid).equals("2"))){%>
    <TR valign='top'>
		<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%></TD><!--链接方式-->
		<TD  class=field>
			<SELECT id="_eLinkmode_<%=eid%>" >
				<option value="1" <%if("1".equals(elinkmode)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19497,user.getLanguage())%></option><!--当前页-->

				<option value="2"  <%if("2".equals(elinkmode)) out.println("selected");%>>
				<%=SystemEnv.getHtmlLabelName(19498,user.getLanguage())%></option><!--弹出页-->
			</SELECT>
		</TD>
	</TR>	
	<TR valign='top'><TD colspan=2 class=line></TD></TR>	
    <%}%>
    <%if(ebaseid.equals("8")&&"2".equals(esharelevel)){//流程中有具有固定行高与设置背景图的功能%> 
    <TR valign='top'>
		<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(21657,user.getLanguage())%></TD><!--显示模式--> 
		<TD  class=field>
		<SELECT id="_eShowMoulde_<%=eid%>" >
			<option value="0" <%if("0".equals(isFixationRowHeight)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21675,user.getLanguage())%></option><!--隐藏没有内容的区域-->

			<option value="1"  <%if("1".equals(isFixationRowHeight)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(21676,user.getLanguage())%></option><!--显示没有内容的区域-->
		</SELECT>
		</TD>
	</TR>
    <TR valign='top'><TD colspan=2 class=line></TD></TR>
    
    <TR valign='top'>
		<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%></TD><!--背景图片-->
		<TD  class=field>		
		<button type="button" class=Browser onClick="onSelectBgImg(_eBackground_<%=eid%>,_eBackground_<%=eid%>_span,'<%=eid%>')"></button>		
		<input type="hidden" name="_eBackground_<%=eid%>"   id="_eBackground_<%=eid%>" value="<%=background%>">
		<span   name="_eBackground_<%=eid%>_span"   id="_eBackground_<%=eid%>_span">
		
			<%if(!"".equals(background)){%>
				<a href="/weaver/weaver.file.FileDownload?fileid=<%=background%>" target="_blank"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a>
			<%}%>
			
		
		</span>
		</TD>
	</TR>
    <TR valign='top'><TD colspan=2 class=line></TD></TR>
   <%}%>

	<%
		rs1.executeSql("select count(*) from hpFieldElement where elementid="+ebaseid);
		rs1.next();
		if(rs1.getInt(1)>0){
		
	%>
			<TR valign='top'>
				<TD>&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></TD><!--显示字段-->
				<TD  class=field>
					<%
					    ArrayList selectedFieldList=Util.TokenizerString(eshowfield,",");
						rs.executeSql("select * from hpFieldElement where elementid="+ebaseid+" order by ordernum");
						while(rs.next()){
							String fieldId=Util.null2String(rs.getString("id"));
							String isLimitLength=Util.null2String(rs.getString("isLimitLength"));
							int fieldname=Util.getIntValue(rs.getString("fieldname"));
							String fieldcolumn=Util.null2String(rs.getString("fieldcolumn"));
							String fieldwidth = Util.null2String(rs.getString("fieldwidth"));
							
							String strChecked="";
							if(selectedFieldList.contains(fieldId)) strChecked=" checked ";
							out.println("<INPUT TYPE=checkbox NAME='_chkField_"+eid+"' value="+fieldId+" "+strChecked+">");
							out.println(SystemEnv.getHtmlLabelName(fieldname,user.getLanguage()));
							
					
							if("2".equals(esharelevel)){
								if(fieldcolumn.toLowerCase().equals("img")){
									String imgSize ="";
									String imgWidth ="";
									String imgHeight ="";
									
									boolean autoAdjust = false;
									String autoAdjustCheckStr = "";
									rs1.executeSql("select imgsize from hpFieldLength where eid="+eid+" and efieldid="+fieldId+" and userid="+userid+" and usertype="+usertype);
									if(rs1.next()) imgSize=Util.null2String(rs1.getString("imgsize"));
									if(!imgSize.equals("")){
										ArrayList sizeAry = Util.TokenizerString(imgSize,"*");
										imgWidth = (String)sizeAry.get(0);
										imgHeight = (String)sizeAry.get(1);
										if(imgHeight.equals("0")||imgHeight.equals("")){
											autoAdjust = true;
											autoAdjustCheckStr = "checked";
										}
									}else {
										imgWidth = "120";
										imgHeight = "108";
									}
									
									out.println("&nbsp;"+SystemEnv.getHtmlLabelName(203,user.getLanguage())+":<INPUT TYPE = text name='_imgWidth"+eid+"' value='"+imgWidth+"' basefield="+fieldId+" class='inputStyle'  style='width:35px' onkeypress='var   k=event.keyCode;   return   k>=48&&k<=57'>");
									if(!autoAdjust){
										out.println("<span id='_imgHeightDiv"+eid+"' style='width:70px'>&nbsp;"+SystemEnv.getHtmlLabelName(207,user.getLanguage())+":<INPUT TYPE = text name='_imgHeight"+eid+"' value='"+imgHeight+"' basefield="+fieldId+" class='inputStyle'  style='width:35px' onkeypress='var   k=event.keyCode;   return   k>=48&&k<=57' ></span>");
									}else{
										out.println("<span id='_imgHeightDiv"+eid+"' style='width:70px;display:none' >&nbsp;"+SystemEnv.getHtmlLabelName(207,user.getLanguage())+":<INPUT TYPE = text name='_imgHeight"+eid+"' value='"+imgHeight+"' basefield="+fieldId+" class='inputStyle'  style='width:35px;' onkeypress='var   k=event.keyCode;   return   k>=48&&k<=57' ></span>");
									}
									
									out.println("&nbsp<INPUT TYPE = checkbox name='_imgAutoAdjust"+eid+"' "+autoAdjustCheckStr+" onclick='if(event.srcElement.checked){document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"none\";document.getElementById(\"_imgHeight"+eid+"\").value=0}else{document.getElementById(\"_imgHeightDiv"+eid+"\").style.display=\"\"}'>"+SystemEnv.getHtmlLabelName(22494,user.getLanguage()));
								}
							}
							int wordLength=8;
							if("1".equals(isLimitLength)) {
								rs1.executeSql("select charnum from hpFieldLength where eid="+eid+" and efieldid="+fieldId+" and userid="+userid+" and usertype="+usertype);
								if(rs1.next()) wordLength=Util.getIntValue(rs1.getString("charnum"));

								out.println("&nbsp;"+SystemEnv.getHtmlLabelName(19524,user.getLanguage())+":<input name=_wordcount_"+eid+" basefield="+fieldId+" type='text' style='width:24px' class=inputstyle title="+SystemEnv.getHtmlLabelName(19524,user.getLanguage())+" value='"+wordLength+"'>&nbsp;");
							}
							out.println("<br>");
						}
					%>
				
				</TD>
			</TR>	
			<TR valign='top'><TD colspan=2 class=line></TD></TR>

	<%
	}
	%>	
  <%
	if("2".equals(esharelevel)){
		//得where语句
		//rsWhere.executeSql("select * from hpWhereElement where elementid="+ebaseid);
		String settingshowmethod=Util.null2String(hpewc.geSettingshowmethod(ebaseid));
		if (!"".equals(settingshowmethod)){			
			if(!"".equals(settingshowmethod)){
				Class tempClass = Class.forName("weaver.homepage.HomepageWhere");
				Method tempMethod = tempClass.getMethod(settingshowmethod, new Class[] { String.class, String.class, String.class, String.class,String.class });
				Constructor ct = tempClass.getConstructor(null);

				String strSettingWhere=(String)tempMethod.invoke(ct.newInstance(null), new Object[] {eid,ebaseid,strsqlwhere,""+user.getLanguage(),esharelevel});
				out.println("\n"+strSettingWhere+"\n");
				out.println("<TR valign='top'><TD colspan=2 class=line></TD></TR>\n");
			}

		}
	}
	%>


	<TR valign='top'>
		<TD></TD>
		<TD>
		   <A HREF="javascript:onUseSetting('<%=eid%>','<%=ebaseid%>')"><%=SystemEnv.getHtmlLabelName(19565,user.getLanguage())%></A> 
		   &nbsp;&nbsp;&nbsp;
		   <A HREF="javascript:onNoUseSetting('<%=eid%>')"><%=SystemEnv.getHtmlLabelName(19566,user.getLanguage())%></A>
			
	</TR>	
	<TR valign='top'><TD colspan=2 class=line></TD></TR>
</TABLE>
