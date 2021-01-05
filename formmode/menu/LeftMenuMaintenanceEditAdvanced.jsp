
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.category.security.AclManager,
                 weaver.docs.category.CategoryTree,
                 weaver.docs.category.CommonCategory" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
//左侧菜单维护-自定义菜单
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int infoId = Util.getIntValue(request.getParameter("id"),0);
int sync = Util.getIntValue(request.getParameter("sync"),0);

int userid=0;
userid=user.getUID();

if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
LeftMenuInfoHandler infoHandler = new  LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);

if(info==null){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String selectArr = "";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;//保存
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteMenu(this),_self} " ;//删除
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_self} " ;//返回
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmmain method=post action="LeftMenuMaintenanceOperation.jsp">
	<input name="method" type="hidden" value="editadvanced"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="infoId" type="hidden" value="<%=infoId%>"/>
	<input name="parentId" type="hidden" value="<%=info.getParentId()%>"/>
	<input name="sync" type="hidden" value="<%=sync%>"/>
	
	<%-- 图标 --%>
	<INPUT name="customIconUrl" type="hidden" value="<%=info.getIconUrl()%>">
	
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
			<COL width="20%">
			<COL width="80%">
			
			<TBODY>
			
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH><!-- 基本信息 -->
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>

                <%-- 菜单名称 --%>
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customMenuName" value="<%=info.getCustomName() %>" onchange="checkinput('customMenuName','Nameimage')">
				  	<SPAN id=Nameimage></SPAN>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				
				<%-- 图标 
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19063,user.getLanguage())%></td>
				  <td class=Field>
					<INPUT class=InputStyle maxLength=200 style="width:80%" name="customIconUrl" value="<%=info.getIconUrl() %>"  onchange="checkinput('customIconUrl','iconUrlImage')">
					<SPAN id=iconUrlImage></SPAN>
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
				--%>

				<%-- 排序 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
				  <td class=Field>
					<INPUT class=InputStyle maxLength=50  name="customMenuViewIndex" value="<%=info.getDefaultIndex() %>">
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
		

				<%-- 模块 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></td>
				  <td class=Field>
					<input type="radio" name="customModule" value="1" onClick="onChangeModule(this);" <%if(info.getFromModule()==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><!-- 文档 -->
					<input type="radio" name="customModule" value="2" onClick="onChangeModule(this);" <%if(info.getFromModule()==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><!-- 流程 -->
					<input type="radio" name="customModule" value="3" onClick="onChangeModule(this);" <%if(info.getFromModule()==3){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><!-- 客户 -->
					<input type="radio" name="customModule" value="4" onClick="onChangeModule(this);" <%if(info.getFromModule()==4){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><!-- 项目 -->
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>

				<%-- 菜单类型 --%>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></td>
				  <td class=Field>
				  	<select name="customType_1" style="display:block" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==1&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%></option><!-- 新建文档 -->
				  		<option value="2" <%if(info.getFromModule()==1&&info.getMenuType()==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1212,user.getLanguage())%></option><!-- 我的文档 -->
				  		<option value="3" <%if(info.getFromModule()==1&&info.getMenuType()==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16397,user.getLanguage())%></option><!-- 最新文档 -->
				  		<option value="4" <%if(info.getFromModule()==1&&info.getMenuType()==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></option><!-- 文档目录 -->
				  	</select>	
				  	<select name="customType_2" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==2&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></option><!-- 新建流程 -->
				  		<option value="2" <%if(info.getFromModule()==2&&info.getMenuType()==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></option><!-- 待办事宜 -->
				  		<option value="3" <%if(info.getFromModule()==2&&info.getMenuType()==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17991,user.getLanguage())%></option><!-- 已办事宜 -->
				  		<option value="4" <%if(info.getFromModule()==2&&info.getMenuType()==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></option><!-- 办结事宜 -->
				  		<option value="5" <%if(info.getFromModule()==2&&info.getMenuType()==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1210,user.getLanguage())%></option><!-- 我的请求 -->
				  	</select>
				  	<select name="customType_3" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==3&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%></option><!-- 新建客户 -->
				  	</select>
				  	<select name="customType_4" style="display:none" onChange="onChangeModuleType(this);">
				  		<option value="1" <%if(info.getFromModule()==4&&info.getMenuType()==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%></option><!-- 新建项目 -->
				  		<option value="2" <%if(info.getFromModule()==4&&info.getMenuType()==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16408,user.getLanguage())%></option><!-- 项目执行 -->
				  		<option value="3" <%if(info.getFromModule()==4&&info.getMenuType()==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16409,user.getLanguage())%></option><!-- 审批项目 -->
				  		<option value="4" <%if(info.getFromModule()==4&&info.getMenuType()==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16410,user.getLanguage())%></option><!-- 审批任务 -->
				  		<option value="5" <%if(info.getFromModule()==4&&info.getMenuType()==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16411,user.getLanguage())%></option><!-- 当前任务 -->
				  		<option value="6" <%if(info.getFromModule()==4&&info.getMenuType()==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16412,user.getLanguage())%></option><!-- 超期任务 -->
				  	</select>
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>

			</TBODY>
		</TABLE>

		<%-- 文档 新建文档 文档目录 --%>
	    <TABLE class=ViewForm id="customSetting_1" style="display:block">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></TH><!-- 文档目录 -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				<TR><TD colSpan=2>

				<table class=ViewForm>
				  <%
				  if(info.getFromModule()==1&&info.getMenuType()==1) selectArr = info.getSelectedContent() + "|";
				  else selectArr = "" + "|";
				  
				  RecordSet.executeSql(" select id as categoryid,0 as categorytype,-1 as superdirid,-1 as superdirtype,categoryname,categoryorder from DocMainCategory "
						  + " UNION "
						  + " select id as categoryid,1 as categorytype,maincategoryid as superdirid,0 as superdirtype,categoryname,0 as categoryorder from DocSubCategory "
						  + " UNION "
						  + " select id as categoryid,2 as categorytype,subcategoryid as superdirid,1 as superdirtype,categoryname,0 as categoryorder from DocSecCategory "
				  );
				  CategoryTree tree = new CategoryTree();
				  while (RecordSet.next()) {
				      CommonCategory category = new CommonCategory();
				      category.id = RecordSet.getInt("categoryid");
				      category.type = RecordSet.getInt("categorytype");
				      category.superiorid = RecordSet.getInt("superdirid");
				      category.superiortype = RecordSet.getInt("superdirtype");
				      category.name = RecordSet.getString("categoryname");
				      tree.allCategories.add(category);
				      if (category.type == AclManager.CATEGORYTYPE_MAIN) {
				    	  tree.mainCategories.add(category);
				      }
				  }
				  tree.rebuildCategoryRelation();
			  
			      ArrayList mainids=new ArrayList();
			      ArrayList subids=new ArrayList();
			      ArrayList secids=new ArrayList();
			
			      Vector alldirs = tree.allCategories;
			      for (int i=0;i<alldirs.size();i++) {
			          CommonCategory temp = (CommonCategory)alldirs.get(i);
			          if (temp.type == AclManager.CATEGORYTYPE_MAIN) {
			              mainids.add(Integer.toString(temp.id));
			          } else if (temp.type == AclManager.CATEGORYTYPE_SEC) {
			              secids.add(Integer.toString(temp.id));
			              if (subids.indexOf(Integer.toString(temp.superiorid)) == -1) {
			                  subids.add(Integer.toString(temp.superiorid));
			              }
			          }
			      }
			
				  int maincate = mainids.size();
				  int rownum = maincate/2;
				  if((maincate-rownum*2)!=0)
				  	  rownum=rownum+1;
				  %>
				  <tr class=field>
				    <td width="50%" align=left valign=top>
				    <%
				 	int needtd=rownum;
				 	for(int i=0;i<mainids.size();i++){
				 		String mainid = (String)mainids.get(i);
				 		String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
				 		needtd--;
				 	%>
				 	<table class=ViewForm>
						<tr class=field>
						  <td colspan=2 align=left>
						  <% if(selectArr.indexOf("M"+mainid+"|")==-1){%>
						  <input type="checkbox" name="docdir_ND_m<%=mainid%>" value="docdir_ND_M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_ND_m<%=mainid%>" value="docdir_ND_M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
						  <%}%>
						  <b><%=mainname%></b> </td></tr>
				 	<%
						for(int j=0;j<subids.size();j++){
							String subid = (String)subids.get(j);
							String subname=SubCategoryComInfo.getSubCategoryname(subid);
						 	String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
						 	if(!curmainid.equals(mainid)) continue;
					%>
						<tr class="field">
						  <td width="20%"></td>
						  <td>
						  <% if(selectArr.indexOf("S"+subid+"|")==-1){%>
						  <input type="checkbox" name="docdir_ND_s<%=mainid%>" value="docdir_ND_S<%=subid%>" onclick="checkSub('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_ND_s<%=mainid%>" value="docdir_ND_S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
						  <%}%>
						  <%=subname%></td></tr>
					<%
						}
					%>
					</table>
					<%
						if(needtd==0){
							needtd=maincate/2;
					%>
						</td><td align=left valign=top>
					<%
						}
					}
					%>
				  </tr>
				</table>				  	
				<script>
				function checkMain(id) {
					var mainchecked=eval("document.frmmain.docdir_ND_m"+id).checked ;
					var ary = eval("document.frmmain.docdir_ND_s"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkSub(id) {
					var ary = eval("document.frmmain.docdir_ND_s"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.docdir_ND_m"+id).checked=true;
					else eval("document.frmmain.docdir_ND_m"+id).checked=false;
				}				  	
				</script>				  	
				  	
				  </TD>
				</TR>
			</TBODY>
		</TABLE>
		
		<%-- 文档 我的文档 默认显示方式 --%>
	    <TABLE class=ViewForm id="customSetting_2" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19056,user.getLanguage())%></td><!-- 默认显示方式 -->
				  <td class=Field>
				  
					<input type="radio" name="displayUsage_2" value="0" <%if(info.getFromModule()==1&&info.getMenuType()==2&&info.getDisplayUsage()!=1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><!-- 列表 -->
					<input type="radio" name="displayUsage_2" value="1" <%if(info.getFromModule()==1&&info.getMenuType()==2&&info.getDisplayUsage()==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19064,user.getLanguage())%><!-- 缩略图 -->
				  
				  </td>
				</tr>
				
				<TR><TD class=Line colSpan=2></TD></TR>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></TH><!-- 文档目录 -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				<TR><TD colSpan=2>

				<table class=ViewForm>
				  <%
				  if(info.getFromModule()==1&&info.getMenuType()==2) selectArr = info.getSelectedContent() + "|";
				  else selectArr = "" + "|";
				  
				  maincate = mainids.size();
				  rownum = maincate/2;
				  if((maincate-rownum*2)!=0)
				  	  rownum=rownum+1;
				  %>
				  <tr class=field>
				    <td width="50%" align=left valign=top>
				    <%
				 	needtd=rownum;
				 	for(int i=0;i<mainids.size();i++){
				 		String mainid = (String)mainids.get(i);
				 		String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
				 		needtd--;
				 	%>
				 	<table class=ViewForm>
						<tr class=field>
						  <td colspan=2 align=left>
						  <% if(selectArr.indexOf("M"+mainid+"|")==-1){%>
						  <input type="checkbox" name="docdir_MD_m<%=mainid%>" value="docdir_MD_M<%=mainid%>" onclick="checkMain2('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_MD_m<%=mainid%>" value="docdir_MD_M<%=mainid%>" onclick="checkMain2('<%=mainid%>')" checked>
						  <%}%>
						  <b><%=mainname%></b> </td></tr>
				 	<%
						for(int j=0;j<subids.size();j++){
							String subid = (String)subids.get(j);
							String subname=SubCategoryComInfo.getSubCategoryname(subid);
						 	String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
						 	if(!curmainid.equals(mainid)) continue;
					%>
						<tr class="field">
						  <td width="20%"></td>
						  <td>
						  <% if(selectArr.indexOf("S"+subid+"|")==-1){%>
						  <input type="checkbox" name="docdir_MD_s<%=mainid%>" value="docdir_MD_S<%=subid%>" onclick="checkSub2('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_MD_s<%=mainid%>" value="docdir_MD_S<%=subid%>" onclick="checkSub2('<%=mainid%>')" checked>
						  <%}%>
						  <%=subname%></td></tr>
					<%
						}
					%>
					</table>
					<%
						if(needtd==0){
							needtd=maincate/2;
					%>
						</td><td align=left valign=top>
					<%
						}
					}
					%>
				  </tr>
				</table>				  	
				<script>
				function checkMain2(id) {
					var mainchecked=eval("document.frmmain.docdir_MD_m"+id).checked ;
					var ary = eval("document.frmmain.docdir_MD_s"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkSub2(id) {
					var ary = eval("document.frmmain.docdir_MD_s"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.docdir_MD_m"+id).checked=true;
					else eval("document.frmmain.docdir_MD_m"+id).checked=false;
				}				  	
				</script>				  	
				  	
				  </TD>
				</TR>
				
				
			</TBODY>
		</TABLE>

		<%-- 文档 最新文档 默认显示方式 --%>
	    <TABLE class=ViewForm id="customSetting_3" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19056,user.getLanguage())%></td>
				  <td class=Field>
				  
					<input type="radio" name="displayUsage_3" value="0" <%if(info.getFromModule()==1&&info.getMenuType()==3&&info.getDisplayUsage()!=1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><!-- 列表 -->
					<input type="radio" name="displayUsage_3" value="1" <%if(info.getFromModule()==1&&info.getMenuType()==3&&info.getDisplayUsage()==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19064,user.getLanguage())%><!-- 缩略图 -->
				  
				  </td>
				</tr>
				
				
				<TR><TD class=Line colSpan=2></TD></TR>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></TH><!-- 文档目录 -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				<TR><TD colSpan=2>

				<table class=ViewForm>
				  <%
				  if(info.getFromModule()==1&&info.getMenuType()==3) selectArr = info.getSelectedContent() + "|";
				  else selectArr = "" + "|";
				  
				  maincate = mainids.size();
				  rownum = maincate/2;
				  if((maincate-rownum*2)!=0)
				  	  rownum=rownum+1;
				  %>
				  <tr class=field>
				    <td width="50%" align=left valign=top>
				    <%
				 	needtd=rownum;
				 	for(int i=0;i<mainids.size();i++){
				 		String mainid = (String)mainids.get(i);
				 		String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
				 		needtd--;
				 	%>
				 	<table class=ViewForm>
						<tr class=field>
						  <td colspan=2 align=left>
						  <% if(selectArr.indexOf("M"+mainid+"|")==-1){%>
						  <input type="checkbox" name="docdir_NESTD_m<%=mainid%>" value="docdir_NESTD_M<%=mainid%>" onclick="checkMain3('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_NESTD_m<%=mainid%>" value="docdir_NESTD_M<%=mainid%>" onclick="checkMain3('<%=mainid%>')" checked>
						  <%}%>
						  <b><%=mainname%></b> </td></tr>
				 	<%
						for(int j=0;j<subids.size();j++){
							String subid = (String)subids.get(j);
							String subname=SubCategoryComInfo.getSubCategoryname(subid);
						 	String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
						 	if(!curmainid.equals(mainid)) continue;
					%>
						<tr class="field">
						  <td width="20%"></td>
						  <td>
						  <% if(selectArr.indexOf("S"+subid+"|")==-1){%>
						  <input type="checkbox" name="docdir_NESTD_s<%=mainid%>" value="docdir_NESTD_S<%=subid%>" onclick="checkSub3('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_NESTD_s<%=mainid%>" value="docdir_NESTD_S<%=subid%>" onclick="checkSub3('<%=mainid%>')" checked>
						  <%}%>
						  <%=subname%></td></tr>
					<%
						}
					%>
					</table>
					<%
						if(needtd==0){
							needtd=maincate/2;
					%>
						</td><td align=left valign=top>
					<%
						}
					}
					%>
				  </tr>
				</table>				  	
				<script>
				function checkMain3(id) {
					var mainchecked=eval("document.frmmain.docdir_NESTD_m"+id).checked ;
					var ary = eval("document.frmmain.docdir_NESTD_s"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkSub3(id) {
					var ary = eval("document.frmmain.docdir_NESTD_s"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.docdir_NESTD_m"+id).checked=true;
					else eval("document.frmmain.docdir_NESTD_m"+id).checked=false;
				}				  	
				</script>				  	
				  	
				  </TD>
				</TR>


			</TBODY>
		</TABLE>

		<%-- 文档 文档目录 默认显示方式 --%>
	    <TABLE class=ViewForm id="customSetting_4" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19056,user.getLanguage())%></td><!-- 默认显示方式 -->
				  <td class=Field>
				  
					<input type="radio" name="displayUsage_4" value="0" <%if(info.getFromModule()==1&&info.getMenuType()==3&&info.getDisplayUsage()!=1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><!-- 列表 -->
					<input type="radio" name="displayUsage_4" value="1" <%if(info.getFromModule()==1&&info.getMenuType()==4&&info.getDisplayUsage()==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19064,user.getLanguage())%><!-- 缩略图 -->
				  
				  </td>
				</tr>
				
				
				<TR><TD class=Line colSpan=2></TD></TR>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></TH><!-- 文档目录 -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				<TR><TD colSpan=2>

				<table class=ViewForm>
				  <%
				  if(info.getFromModule()==1&&info.getMenuType()==4) selectArr = info.getSelectedContent() + "|";
				  else selectArr = "" + "|";
				  
				  maincate = mainids.size();
				  rownum = maincate/2;
				  if((maincate-rownum*2)!=0)
				  	  rownum=rownum+1;
				  %>
				  <tr class=field>
				    <td width="50%" align=left valign=top>
				    <%
				 	needtd=rownum;
				 	for(int i=0;i<mainids.size();i++){
				 		String mainid = (String)mainids.get(i);
				 		String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
				 		needtd--;
				 	%>
				 	<table class=ViewForm>
						<tr class=field>
						  <td colspan=2 align=left>
						  <% if(selectArr.indexOf("M"+mainid+"|")==-1){%>
						  <input type="checkbox" name="docdir_DC_m<%=mainid%>" value="docdir_DC_M<%=mainid%>" onclick="checkMain4('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_DC_m<%=mainid%>" value="docdir_DC_M<%=mainid%>" onclick="checkMain4('<%=mainid%>')" checked>
						  <%}%>
						  <b><%=mainname%></b> </td></tr>
				 	<%
						for(int j=0;j<subids.size();j++){
							String subid = (String)subids.get(j);
							String subname=SubCategoryComInfo.getSubCategoryname(subid);
						 	String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
						 	if(!curmainid.equals(mainid)) continue;
					%>
						<tr class="field">
						  <td width="20%"></td>
						  <td>
						  <% if(selectArr.indexOf("S"+subid+"|")==-1){%>
						  <input type="checkbox" name="docdir_DC_s<%=mainid%>" value="docdir_DC_S<%=subid%>" onclick="checkSub4('<%=mainid%>')">
						  <%} else {%>
						  <input type="checkbox" name="docdir_DC_s<%=mainid%>" value="docdir_DC_S<%=subid%>" onclick="checkSub4('<%=mainid%>')" checked>
						  <%}%>
						  <%=subname%></td></tr>
					<%
						}
					%>
					</table>
					<%
						if(needtd==0){
							needtd=maincate/2;
					%>
						</td><td align=left valign=top>
					<%
						}
					}
					%>
				  </tr>
				</table>				  	
				<script>
				function checkMain4(id) {
					var mainchecked=eval("document.frmmain.docdir_DC_m"+id).checked ;
					var ary = eval("document.frmmain.docdir_DC_s"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkSub4(id) {
					var ary = eval("document.frmmain.docdir_DC_s"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.docdir_DC_m"+id).checked=true;
					else eval("document.frmmain.docdir_DC_m"+id).checked=false;
				}				  	
				</script>				  	
				  	
				  </TD>
				</TR>


			</TBODY>
		</TABLE>
		
		<%-- 流程 新建流程 工作流 --%>
	    <TABLE class=ViewForm id="customSetting_5" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH><!-- 工作流(TODO) -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				<TR><TD>
				
				
				<table class="ViewForm" width="100%">
				   <tr class=field>
				        <td width="50%" align=left valign=top>
				<%
				if(info.getFromModule()==2&&info.getMenuType()==1) selectArr = info.getSelectedContent() + "|";
				else selectArr = "" + "|";
				
				ArrayList NewWorkflowTypes = new ArrayList();
				
				String sql = "select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1'";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
				}
				
				ArrayList NewWorkflows = new ArrayList();
				  sql = "select * from ShareInnerWfCreate";
				  RecordSet.executeSql(sql);
				  while(RecordSet.next()){
				    NewWorkflows.add(RecordSet.getString("workflowid"));
				  }
				
				int wftypetotal=NewWorkflowTypes.size();
				int wftotal=WorkflowComInfo.getWorkflowNum();
				rownum = wftypetotal/2;
				if((wftypetotal-rownum*2)!=0)
					rownum=rownum+1;
				
					int i=0;
				 	needtd=rownum;
				 	while(WorkTypeComInfo.next()){	
				 		String wftypename=WorkTypeComInfo.getWorkTypename();
				 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
				 		if(NewWorkflowTypes.indexOf(wftypeid)==-1) continue;            
					 	//if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
				 		needtd--;
				 	%>
				 	<table class="ViewForm">
						<tr>
						  <td>
				 	<%
				 	int isfirst = 1;
					while(WorkflowComInfo.next()){
						String wfname=WorkflowComInfo.getWorkflowname();
					 	String wfid = WorkflowComInfo.getWorkflowid();
					 	String curtypeid = WorkflowComInfo.getWorkflowtype();
				        int isagent=0;
				        String agentname="";
					 	if(!curtypeid.equals(wftypeid)) continue;
					 	//check right
					 	//if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					 	i++;
					 	
					 	if(isfirst ==1){
					 		isfirst = 0;
					%>
						<ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%>
						<% if(selectArr.indexOf("T"+wftypeid+"|")==-1){%>
						<input type="checkbox" name="workflow_NF_t<%=wftypeid%>" value="workflow_NF_T<%=wftypeid%>" onclick="checkType('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_NF_t<%=wftypeid%>" value="workflow_NF_T<%=wftypeid%>" onclick="checkType('<%=wftypeid%>')" checked>
						<%}%></b>
					
					<%	} %>
						<ul><li><%=Util.toScreen(wfname,user.getLanguage())%><%=agentname%>
						<% if(selectArr.indexOf("W"+wfid+"|")==-1){%>
						<input type="checkbox" name="workflow_NF_w<%=wftypeid%>" value="workflow_NF_W<%=wfid%>" onclick="checkWorkflow('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_NF_w<%=wftypeid%>" value="workflow_NF_W<%=wfid%>" onclick="checkWorkflow('<%=wftypeid%>')" checked>
						<%}%></ul></li>
					<%
						}
						WorkflowComInfo.setTofirstRow();
					%>
						</ul></li></td></tr>
					</table>
					<%
						if(needtd==0){
							needtd=wftypetotal/2;
					%>
					</td><td width="50%" align=left valign=top>
					<%
						}
					}
					%>		
					</td>
				  </tr>
				</table>
				<script>
				function checkType(id) {
					var mainchecked=eval("document.frmmain.workflow_NF_t"+id).checked ;
					var ary = eval("document.frmmain.workflow_NF_w"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkWorkflow(id) {
					var ary = eval("document.frmmain.workflow_NF_w"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.workflow_NF_t"+id).checked=true;
					else eval("document.frmmain.workflow_NF_t"+id).checked=false;
				}				  	
				</script>				  	
				
				
				
				</TD></TR>
				
			</TBODY>
		</TABLE>
				
				


		<%-- 流程 待办事宜 工作流 --%>
	    <TABLE class=ViewForm id="customSetting_6" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH><!-- 工作流(TODO) -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				
				<TR><TD colSpan=2>
				

				<table class="ViewForm" width="100%">
				   <tr class=field>
				        <td width="50%" align=left valign=top>
				<%
				if(info.getFromModule()==2&&info.getMenuType()==2) selectArr = info.getSelectedContent() + "|";
				else selectArr = "" + "|";
				
				wftypetotal=NewWorkflowTypes.size();
				wftotal=WorkflowComInfo.getWorkflowNum();
				rownum = wftypetotal/2;
				if((wftypetotal-rownum*2)!=0)
					rownum=rownum+1;
				
					i=0;
				 	needtd=rownum;
				 	while(WorkTypeComInfo.next()){	
				 		String wftypename=WorkTypeComInfo.getWorkTypename();
				 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
				 		if(NewWorkflowTypes.indexOf(wftypeid)==-1) continue;            
					 	//if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
				 		needtd--;
				 	%>
				 	<table class="ViewForm">
						<tr>
						  <td>
				 	<%
				 	int isfirst = 1;
					while(WorkflowComInfo.next()){
						String wfname=WorkflowComInfo.getWorkflowname();
					 	String wfid = WorkflowComInfo.getWorkflowid();
					 	String curtypeid = WorkflowComInfo.getWorkflowtype();
				        int isagent=0;
				        String agentname="";
					 	if(!curtypeid.equals(wftypeid)) continue;
					 	//check right
					 	//if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					 	i++;
					 	
					 	if(isfirst ==1){
					 		isfirst = 0;
					%>
						<ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%>
						<% if(selectArr.indexOf("T"+wftypeid+"|")==-1){%>
						<input type="checkbox" name="workflow_PM_t<%=wftypeid%>" value="workflow_PM_T<%=wftypeid%>" onclick="checkType2('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_PM_t<%=wftypeid%>" value="workflow_PM_T<%=wftypeid%>" onclick="checkType2('<%=wftypeid%>')" checked>
						<%}%></b>
					
					<%	} %>
						<ul><li><%=Util.toScreen(wfname,user.getLanguage())%><%=agentname%>
						<% if(selectArr.indexOf("W"+wfid+"|")==-1){%>
						<input type="checkbox" name="workflow_PM_w<%=wftypeid%>" value="workflow_PM_W<%=wfid%>" onclick="checkWorkflow2('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_PM_w<%=wftypeid%>" value="workflow_PM_W<%=wfid%>" onclick="checkWorkflow2('<%=wftypeid%>')" checked>
						<%}%></ul></li>
					<%
						}
						WorkflowComInfo.setTofirstRow();
					%>
						</ul></li></td></tr>
					</table>
					<%
						if(needtd==0){
							needtd=wftypetotal/2;
					%>
					</td><td width="50%" align=left valign=top>
					<%
						}
					}
					%>		
					</td>
				  </tr>
				</table>
				<script>
				function checkType2(id) {
					var mainchecked=eval("document.frmmain.workflow_PM_t"+id).checked ;
					var ary = eval("document.frmmain.workflow_PM_w"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkWorkflow2(id) {
					var ary = eval("document.frmmain.workflow_PM_w"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.workflow_PM_t"+id).checked=true;
					else eval("document.frmmain.workflow_PM_t"+id).checked=false;
				}				  	
				</script>				  	
				
				
				
				</TD></TR>
				
			</TBODY>
		</TABLE>



		<%-- 流程 已办事宜 工作流 --%>
	    <TABLE class=ViewForm id="customSetting_7" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH><!-- 工作流(TODO) -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				
				<TR><TD colSpan=2>
				

				<table class="ViewForm" width="100%">
				   <tr class=field>
				        <td width="50%" align=left valign=top>
				<%
				if(info.getFromModule()==2&&info.getMenuType()==3) selectArr = info.getSelectedContent() + "|";
				else selectArr = "" + "|";
				
				wftypetotal=NewWorkflowTypes.size();
				wftotal=WorkflowComInfo.getWorkflowNum();
				rownum = wftypetotal/2;
				if((wftypetotal-rownum*2)!=0)
					rownum=rownum+1;
				
					i=0;
				 	needtd=rownum;
				 	while(WorkTypeComInfo.next()){	
				 		String wftypename=WorkTypeComInfo.getWorkTypename();
				 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
				 		if(NewWorkflowTypes.indexOf(wftypeid)==-1) continue;            
					 	//if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
				 		needtd--;
				 	%>
				 	<table class="ViewForm">
						<tr>
						  <td>
				 	<%
				 	int isfirst = 1;
					while(WorkflowComInfo.next()){
						String wfname=WorkflowComInfo.getWorkflowname();
					 	String wfid = WorkflowComInfo.getWorkflowid();
					 	String curtypeid = WorkflowComInfo.getWorkflowtype();
				        int isagent=0;
				        String agentname="";
					 	if(!curtypeid.equals(wftypeid)) continue;
					 	//check right
					 	//if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					 	i++;
					 	
					 	if(isfirst ==1){
					 		isfirst = 0;
					%>
						<ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%>
						<% if(selectArr.indexOf("T"+wftypeid+"|")==-1){%>
						<input type="checkbox" name="workflow_HM_t<%=wftypeid%>" value="workflow_HM_T<%=wftypeid%>" onclick="checkType3('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_HM_t<%=wftypeid%>" value="workflow_HM_T<%=wftypeid%>" onclick="checkType3('<%=wftypeid%>')" checked>
						<%}%></b>
					
					<%	} %>
						<ul><li><%=Util.toScreen(wfname,user.getLanguage())%><%=agentname%>
						<% if(selectArr.indexOf("W"+wfid+"|")==-1){%>
						<input type="checkbox" name="workflow_HM_w<%=wftypeid%>" value="workflow_HM_W<%=wfid%>" onclick="checkWorkflow3('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_HM_w<%=wftypeid%>" value="workflow_HM_W<%=wfid%>" onclick="checkWorkflow3('<%=wftypeid%>')" checked>
						<%}%></ul></li>
					<%
						}
						WorkflowComInfo.setTofirstRow();
					%>
						</ul></li></td></tr>
					</table>
					<%
						if(needtd==0){
							needtd=wftypetotal/2;
					%>
					</td><td width="50%" align=left valign=top>
					<%
						}
					}
					%>		
					</td>
				  </tr>
				</table>
				<script>
				function checkType3(id) {
					var mainchecked=eval("document.frmmain.workflow_HM_t"+id).checked ;
					var ary = eval("document.frmmain.workflow_HM_w"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkWorkflow3(id) {
					var ary = eval("document.frmmain.workflow_HM_w"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.workflow_HM_t"+id).checked=true;
					else eval("document.frmmain.workflow_HM_t"+id).checked=false;
				}				  	
				</script>				  	
				
				
				
				</TD></TR>
				
			</TBODY>
		</TABLE>



		<%-- 流程 办结事宜 工作流 --%>
	    <TABLE class=ViewForm id="customSetting_8" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH><!-- 工作流(TODO) -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				
				<TR><TD colSpan=2>
				

				<table class="ViewForm" width="100%">
				   <tr class=field>
				        <td width="50%" align=left valign=top>
				<%
				if(info.getFromModule()==2&&info.getMenuType()==4) selectArr = info.getSelectedContent() + "|";
				else selectArr = "" + "|";
				
				wftypetotal=NewWorkflowTypes.size();
				wftotal=WorkflowComInfo.getWorkflowNum();
				rownum = wftypetotal/2;
				if((wftypetotal-rownum*2)!=0)
					rownum=rownum+1;
				
					i=0;
				 	needtd=rownum;
				 	while(WorkTypeComInfo.next()){	
				 		String wftypename=WorkTypeComInfo.getWorkTypename();
				 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
				 		if(NewWorkflowTypes.indexOf(wftypeid)==-1) continue;            
					 	//if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
				 		needtd--;
				 	%>
				 	<table class="ViewForm">
						<tr>
						  <td>
				 	<%
				 	int isfirst = 1;
					while(WorkflowComInfo.next()){
						String wfname=WorkflowComInfo.getWorkflowname();
					 	String wfid = WorkflowComInfo.getWorkflowid();
					 	String curtypeid = WorkflowComInfo.getWorkflowtype();
				        int isagent=0;
				        String agentname="";
					 	if(!curtypeid.equals(wftypeid)) continue;
					 	//check right
					 	//if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					 	i++;
					 	
					 	if(isfirst ==1){
					 		isfirst = 0;
					%>
						<ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%>
						<% if(selectArr.indexOf("T"+wftypeid+"|")==-1){%>
						<input type="checkbox" name="workflow_CM_t<%=wftypeid%>" value="workflow_CM_T<%=wftypeid%>" onclick="checkType4('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_CM_t<%=wftypeid%>" value="workflow_CM_T<%=wftypeid%>" onclick="checkType4('<%=wftypeid%>')" checked>
						<%}%></b>
					
					<%	} %>
						<ul><li><%=Util.toScreen(wfname,user.getLanguage())%><%=agentname%>
						<% if(selectArr.indexOf("W"+wfid+"|")==-1){%>
						<input type="checkbox" name="workflow_CM_w<%=wftypeid%>" value="workflow_CM_W<%=wfid%>" onclick="checkWorkflow4('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_CM_w<%=wftypeid%>" value="workflow_CM_W<%=wfid%>" onclick="checkWorkflow4('<%=wftypeid%>')" checked>
						<%}%></ul></li>
					<%
						}
						WorkflowComInfo.setTofirstRow();
					%>
						</ul></li></td></tr>
					</table>
					<%
						if(needtd==0){
							needtd=wftypetotal/2;
					%>
					</td><td width="50%" align=left valign=top>
					<%
						}
					}
					%>		
					</td>
				  </tr>
				</table>
				<script>
				function checkType4(id) {
					var mainchecked=eval("document.frmmain.workflow_CM_t"+id).checked ;
					var ary = eval("document.frmmain.workflow_CM_w"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkWorkflow4(id) {
					var ary = eval("document.frmmain.workflow_CM_w"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.workflow_CM_t"+id).checked=true;
					else eval("document.frmmain.workflow_CM_t"+id).checked=false;
				}				  	
				</script>				  	
				
				
				
				</TD></TR>
				
			</TBODY>
		</TABLE>




		<%-- 流程 我的请求 工作流 --%>
	    <TABLE class=ViewForm id="customSetting_9" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH><!-- 工作流(TODO) -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				
				<TR><TD colSpan=2>
				

				<table class="ViewForm" width="100%">
				   <tr class=field>
				        <td width="50%" align=left valign=top>
				<%
				if(info.getFromModule()==2&&info.getMenuType()==5) selectArr = info.getSelectedContent() + "|";
				else selectArr = "" + "|";
				
				wftypetotal=NewWorkflowTypes.size();
				wftotal=WorkflowComInfo.getWorkflowNum();
				rownum = wftypetotal/2;
				if((wftypetotal-rownum*2)!=0)
					rownum=rownum+1;
				
					i=0;
				 	needtd=rownum;
				 	while(WorkTypeComInfo.next()){	
				 		String wftypename=WorkTypeComInfo.getWorkTypename();
				 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
				 		if(NewWorkflowTypes.indexOf(wftypeid)==-1) continue;            
					 	//if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
				 		needtd--;
				 	%>
				 	<table class="ViewForm">
						<tr>
						  <td>
				 	<%
				 	int isfirst = 1;
					while(WorkflowComInfo.next()){
						String wfname=WorkflowComInfo.getWorkflowname();
					 	String wfid = WorkflowComInfo.getWorkflowid();
					 	String curtypeid = WorkflowComInfo.getWorkflowtype();
				        int isagent=0;
				        String agentname="";
					 	if(!curtypeid.equals(wftypeid)) continue;
					 	//check right
					 	//if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					 	i++;
					 	
					 	if(isfirst ==1){
					 		isfirst = 0;
					%>
						<ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%>
						<% if(selectArr.indexOf("T"+wftypeid+"|")==-1){%>
						<input type="checkbox" name="workflow_MR_t<%=wftypeid%>" value="workflow_MR_T<%=wftypeid%>" onclick="checkType5('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_MR_t<%=wftypeid%>" value="workflow_MR_T<%=wftypeid%>" onclick="checkType5('<%=wftypeid%>')" checked>
						<%}%></b>
					
					<%	} %>
						<ul><li><%=Util.toScreen(wfname,user.getLanguage())%><%=agentname%>
						<% if(selectArr.indexOf("W"+wfid+"|")==-1){%>
						<input type="checkbox" name="workflow_MR_w<%=wftypeid%>" value="workflow_MR_W<%=wfid%>" onclick="checkWorkflow5('<%=wftypeid%>')">
						<%} else {%>
						<input type="checkbox" name="workflow_MR_w<%=wftypeid%>" value="workflow_MR_W<%=wfid%>" onclick="checkWorkflow5('<%=wftypeid%>')" checked>
						<%}%></ul></li>
					<%
						}
						WorkflowComInfo.setTofirstRow();
					%>
						</ul></li></td></tr>
					</table>
					<%
						if(needtd==0){
							needtd=wftypetotal/2;
					%>
					</td><td width="50%" align=left valign=top>
					<%
						}
					}
					%>		
					</td>
				  </tr>
				</table>
				<script>
				function checkType5(id) {
					var mainchecked=eval("document.frmmain.workflow_MR_t"+id).checked ;
					var ary = eval("document.frmmain.workflow_MR_w"+id);
					if(ary.length==null) ary.checked= mainchecked ;
					else
					for(var i=0; i<ary.length; i++) {
						ary[i].checked= mainchecked ;
					}
				}
				
				function checkWorkflow5(id) {
					var ary = eval("document.frmmain.workflow_MR_w"+id);
					var mainchecked = false;
					if(ary.length==null) mainchecked = ary.checked;
					else
						for(var i=0; i<ary.length; i++) {
							if(ary[i].checked){
								mainchecked = true;
								break;
							}
						}
					if(mainchecked) eval("document.frmmain.workflow_MR_t"+id).checked=true;
					else eval("document.frmmain.workflow_MR_t"+id).checked=false;
				}				  	
				</script>				  	
				
				
				
				</TD></TR>
				
			</TBODY>
		</TABLE>


		<%-- 项目 新建客户      --%>
	    <TABLE class=ViewForm id="customSetting_10" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
				<!--
                <TR class=Title>
				  <TH colSpan=2><%//=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				-->
				<TR><TD colSpan=2>
				</TD></TR>
				
			</TBODY>
		</TABLE>
				
				
				
		<%-- 项目 新建项目 项目类型 --%>
	    <TABLE class=ViewForm id="customSetting_11" style="display:none">
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TH><!-- 项目类型 -->
				</TR>
				<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
				<TR><TD>
								
				<%
					if(info.getFromModule()==4&&info.getMenuType()==1) selectArr = info.getSelectedContent() + "|";
					else selectArr = "" + "|";
					
					ArrayList projectColList = new ArrayList();
					
					int firstColNum = 0;
				    int totalProjectType = ProjectTypeComInfo.getProjectTypeNum();
				    if (totalProjectType%2==0)   firstColNum = totalProjectType/2;
				    else firstColNum = totalProjectType/2+1;
				      
				    i=0;
				    while(ProjectTypeComInfo.next()){
				        String projectTypeId = ProjectTypeComInfo.getProjectTypeid();       
				        projectColList.add(projectTypeId);
				        i++;
				    }
				%>
				
				
                    <TABLE width="100%">
                    <colgroup>
                    <col width="45%">
                    <col width="10%">
                    <col width="45%">
                    <TR>
	                    <TD valign="top">
	                        <TABLE  width="100%" valign="top">
		                    <%
		                    for (int j=0;j<projectColList.size();j++){
		                    	String projectId = (String)projectColList.get(j);
		                    %>
								<% if(j==projectColList.size()/2){ %>
	                                </TABLE>
	                            </TD>
	                            <TD></TD>
	                            <TD valign="top">
	                                <TABLE width="100%" valign="top">
		                        <% } %>
	                        	<TR><TD>
		                        <b><ul><li>
                                   	<%=ProjectTypeComInfo.getProjectTypename(projectId)%>
                               		<input type="checkbox" name="project_p<%=projectId%>" value="project_P<%=projectId%>" <% if(selectArr.indexOf("P"+projectId+"|") != -1) out.print("checked"); %>>
                               	</li></ul></b>
                               	</TD></TR>
                            <% } %>
                            </TABLE>
                        </TD>
                    </TR>
                    </TABLE>				
			
				
				
				
				</TD></TR>
				
			</TBODY>
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

<script LANGUAGE="JavaScript">
var menuModule = eval("frmmain.customModule");
for(var i=0;menuModule!=null&&i<menuModule.length;i++){
	if(menuModule[i].value=="<%=info.getFromModule()%>"){
		onChangeModule(menuModule[i]);
		break;
	}
}
var menuModuleType = eval("frmmain.customType_<%=info.getFromModule()%>");
onChangeModuleType(menuModuleType);

function checkSubmit(obj){
	<% if(infoId == 0) { %>
	if(check_form(frmmain,'customMenuCName')){
		frmmain.submit();
	}
	<% } else { %>
	if(check_form(frmmain,'customMenuName,customMenuLink')){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		frmmain.submit();
	}
	<% } %>
	obj.disabled=true;
}

function onBack(obj){
	location.href="LeftMenuMaintenanceList.jsp?resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onChangeModule(obj){
	for(var i=1;i<=4;i++){
		var typeObj = eval("frmmain.customType_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var currTypeObj = eval("frmmain.customType_"+obj.value);
	if(currTypeObj!=null){
		currTypeObj.style.display = "block";
		onChangeModuleType(currTypeObj);
	}
}

function onChangeModuleType(obj){
	var splitname = obj.name;
	var typeObj = null;
	for(var i=1;i<=11;i++){
		typeObj = document.getElementById("customSetting_"+i);
		if(typeObj!=null) typeObj.style.display = "none";
	}
	var splitstrarray = obj.name.split("_");
	var currselect = 0;
	
	if(splitstrarray[1]=="1"&&obj.value=="1"){//新建文档
		currselect = 1;
	} else if(splitstrarray[1]=="1"&&obj.value=="2"){//我的文档
		currselect = 2;
	} else if(splitstrarray[1]=="1"&&obj.value=="3"){//最新文档
		currselect = 3;
	} else if(splitstrarray[1]=="1"&&obj.value=="4"){//文档目录
		currselect = 4;
	} else if(splitstrarray[1]=="2"&&obj.value=="1"){//新建流程
		currselect = 5;
	} else if(splitstrarray[1]=="2"&&obj.value=="2"){//待办事宜
		currselect = 6;
	} else if(splitstrarray[1]=="2"&&obj.value=="3"){//已办事宜
		currselect = 7;
	} else if(splitstrarray[1]=="2"&&obj.value=="4"){//办结事宜
		currselect = 8;
	} else if(splitstrarray[1]=="2"&&obj.value=="5"){//我的请求
		currselect = 9;
	} else if(splitstrarray[1]=="3"&&obj.value=="1"){//新建客户
		currselect = 10;
	} else if(splitstrarray[1]=="4"&&obj.value=="1"){//新建项目
		currselect = 11;
	} else if(splitstrarray[1]=="4"&&obj.value=="2"){//项目执行

	} else if(splitstrarray[1]=="4"&&obj.value=="3"){//审批项目

	} else if(splitstrarray[1]=="4"&&obj.value=="4"){//审批任务

	} else if(splitstrarray[1]=="4"&&obj.value=="5"){//当前任务

	} else if(splitstrarray[1]=="4"&&obj.value=="6"){//超期任务

	}
	if(currselect>0){
		typeObj = document.getElementById("customSetting_"+currselect);
		if(typeObj!=null) typeObj.style.display = "block";
	}
}
function deleteMenu(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>?")){//您确定删除此记录吗？
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "LeftMenuMaintenanceOperation.jsp?method=del&infoId=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
		obj.disabled=true;
	}
}

</script>

</html>

