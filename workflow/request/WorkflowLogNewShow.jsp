<%@ page import="weaver.general.*,java.text.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
 <jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
 <jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
			jQuery(function(){
				jQuery("#topTitle").topMenuTitle({searchFn:searchItem});
	  		 	jQuery("#hoverBtnSpan").hoverBtn(); 		 	
			});
		   function searchItem(){
			  var value=jQuery("input[name='flowTitle']",parent.document).val();
			  jQuery("input[name='requestname']").val(value); 
			  $GetEle("frmmain").submit();
		}
 
 		function changeDate(obje,e){
　                var typevalue=obje.value;
         if(obje.value==6){
            $("#"+e).css("display","");  
         }else{
            $("#"+e).css("display", "none"); 
         }
        }

</script>
	</head>
	<%
 
String requestname=Util.null2String(request.getParameter("requestname"));
String workflowtypeid=Util.null2String(request.getParameter("workflowtypeid"));

int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int printtypes = Util.getIntValue(request.getParameter("printtypes"),0);
int typeid2 = Util.getIntValue(request.getParameter("typeid2"),0);
int workflowid2 = Util.getIntValue(request.getParameter("workflowid2"),0);
int multitype= Util.getIntValue(request.getParameter("multitype"),0);

String workflowid = Util.null2String(request.getParameter("workflowid"));
SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
String currentdatestr=df.format(new Date());
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
String urlType="9";
String doccreatedateselect="";
String createrid=Util.null2String(request.getParameter("createrid"));
int prindate=Util.getIntValue(request.getParameter("prindate"),0);
String prindatefrom=Util.null2String(request.getParameter("prindatefrom"));
String prindateto=Util.null2String(request.getParameter("prindateto"));
String searchtype=Util.null2String(request.getParameter("searchtype"));
String creatername=Util.null2String(request.getParameter("creatername"));//创建人名
String ownerdeptname=Util.null2String(request.getParameter("ownerdeptname"));//创建人部门


String ownerdepartmentid=Util.null2String(request.getParameter("ownerdepartmentid"));//创建人部门


String creatersubcompanyname=Util.null2String(request.getParameter("creatersubcompanyname"));//创建人分部


String creatersubcompanyid=Util.null2String(request.getParameter("creatersubcompanyid"));//创建人分部id
String p_nodename=Util.null2String(request.getParameter("p_nodename"));//创建人分部id
String wheresql=Util.null2String(request.getParameter("wheresql")); 
if (!Util.null2String(SearchClause.getWhereClause()).equals("")) {
    wheresql =SearchClause.getWhereClause();
 }

 

String wherest="where 1=1 ";
if(printtypes==2){//批量打印
 
	if(workflowid2!=0){
		wherest+=" and  workflowid='"+workflowid2+"'";
	}
	if(!requestname.equals("")){
		wherest+=" and  requestname like '%"+requestname+"%'"; 
	} 
	if(!createrid.equals("")){
		wherest+=" and p_opteruid='"+createrid+"'";
	}

	if(!ownerdepartmentid.equals("")){
		wherest+=" and p_opteruid in(select id from hrmresource where    departmentid='"+ownerdepartmentid+"')";
	}
	if(!creatersubcompanyid.equals("")){
		wherest+=" and p_opteruid in(select id from hrmresource where    subcompanyid1='"+creatersubcompanyid+"' )";
	}
	if(prindate==6){
		if(!prindatefrom.equals("")){
			wherest+=" and p_date>='"+prindatefrom+" 00:00'";
		}
		if(!prindateto.equals("")){
			wherest+=" and p_date<='"+prindateto+" 23:59'";
		}
	}
	if(!p_nodename.equals("")){
		wherest+=" and p_nodename like '%"+p_nodename+"%'";
	}
}else{
	wherest="where requestid='"+requestid+"'";
	//本来做的是批量的显示所有，个人登陆就只能查看自己 现在被要求所有都查看全部
	//	wherest+=" and p_opteruid='"+user.getUID()+"'  ";
	if(!createrid.equals("")||!requestname.equals("")){
	    RecordSet.executeSql("select id from hrmresource where lastname='"+requestname+"'");
		if(RecordSet.next()){
			createrid=Util.null2String(RecordSet.getString("id"));
		}
		wherest+=" and p_opteruid='"+createrid+"'";
	}
	if(!ownerdepartmentid.equals("")){
		wherest+=" and p_opteruid in(select id from hrmresource where    departmentid='"+ownerdepartmentid+"')";
	}
	if(!creatersubcompanyid.equals("")){
	 	wherest+=" and p_opteruid in(select id from hrmresource where    subcompanyid1='"+creatersubcompanyid+"' )";
	}
	if(prindate==6){
		if(!prindatefrom.equals("")){
		  wherest+=" and p_date>='"+prindatefrom+" 00:00'";
		}
		if(!prindateto.equals("")){
		  wherest+=" and p_date<='"+prindateto+" 23:59'";
		}
	}
	if(!p_nodename.equals("")){
		  wherest+=" and p_nodename like '%"+p_nodename+"%'";
	}
}
DateUtil datestr=new DateUtil(); 
if(searchtype.equals("1")||prindate==1){//今天
	 wherest+=" and p_date>='"+df1.format(new Date())+" 00:00' and p_date<='"+df1.format(new Date())+" 23:59' ";
}if(searchtype.equals("2")||prindate==2){//本周
	 wherest+=" and p_date>='"+df1.format(datestr.getMonday())+" 00:00' and p_date<='"+df1.format(datestr.getSunday())+" 23:59' ";
}if(searchtype.equals("3")||prindate==3){//本月
	 wherest+=" and p_date>='"+df1.format(datestr.getFirstDayOfMonth())+" 00:00' and p_date<='"+df1.format(datestr.getLastDayOfMonth())+" 23:59' ";
}if(searchtype.equals("4")||prindate==4){//本季
	 wherest+=" and p_date>='"+df1.format(datestr.getFirstDayOfQuarter())+" 00:00' and p_date<='"+df1.format(datestr.getLastDayOfQuarter())+" 23:59' ";
}if(searchtype.equals("5")||prindate==5){//本年
	 wherest+=" and p_date>='"+datestr.getYearDateStart()+" 00:00' and p_date<='"+datestr.getYearDateEnd()+" 23:59' ";
}
 %>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id=frmmain name=frmmain method=post
			action="WorkflowLogNewShow.jsp" onsubmit="return formSubmit()">
			<input type="hidden" name="requestid" value="<%=requestid %>" />
			<input type="hidden" name="printtypes" value="<%=printtypes %>" />
			<input type="hidden" name="searchtype" value="<%=searchtype %>" />
			<input type="hidden" name="typeid2" value="<%=typeid2 %>" /> 
			<input type="hidden" name="wheresql" value="<%=xssUtil.put(wheresql) %>" />
			<input type="hidden" name="pageId" id="pageId"	value="<%= PageIdConst.getWFPageId(urlType) %>" />
			<%
			if(printtypes!=2){// 
			%>
			<table id="topTitle" cellpadding="0" cellspacing="0"
				style="width: 100%">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan">
						<input type="text" class="searchInput" value="<%=requestname%>"
							name="flowTitle" />
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
						<input type="hidden" name="requestname" />
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv">
				<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
					 
						<wea:item><%=SystemEnv.getHtmlLabelName(21529,user.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" value="<%=p_nodename %>" name="p_nodename"
								id="p_nodename">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="createrid"
								browserValue='<%= createrid+"" %>' browserOnClick=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" width="120px" isSingle="true" hasBrowser="true"
								isMustInput='1' completeUrl="/data.jsp"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid+""),user.getLanguage())%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(33826,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="ownerdepartmentid"
								browserValue='<%= ""+ownerdepartmentid %>' browserOnClick=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput='1' completeUrl="/data.jsp?type=4" width="120px"
								browserSpanValue='<%=!ownerdepartmentid.equals("0")?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(33827,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="creatersubcompanyid"
								browserValue='<%= ""+creatersubcompanyid %>' browserOnClick=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput='1' completeUrl="/data.jsp?type=164" width="120px"
								browserSpanValue='<%=!creatersubcompanyid.equals("0")?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(23199,user.getLanguage())%></wea:item>
						<wea:item>
							<select name=prindate id="prindate"
								onchange="changeDate(this,'recievedate');" class=inputstyle
								size=1 style="width: 150">
								<option value="0" <%if(prindate==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="1" <%if(prindate==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
								<option value="2" <%if(prindate==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
								<option value="3" <%if(prindate==3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
								<option value="4" <%if(prindate==4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
								<option value="5" <%if(prindate==5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
								<option value="6" <%if(prindate==6){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17908, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19467, user.getLanguage())%></option>
							</select>
							<span id="recievedate" style="display: <%if(prindate!=6){ %>none<%} %>">
								<button type="button" class="calendar" id="SelectDate"
									onclick="getDate(prindatefromspan,prindatefrom)"></button>&nbsp;
								<span id="prindatefromspan"><%=Util.null2String(request.getParameter("prindatefrom"))%></span>
								-&nbsp;&nbsp;
								<button type="button" class="calendar" id="SelectDate1"
									onclick="getDate(prindatetospan,prindateto)"></button>&nbsp; <span
								id="prindatetospan"><%=Util.null2String(request.getParameter("prindateto"))%></span>
							</span>
							<input type="hidden" name="prindatefrom"
								value="<%=Util.null2String(request.getParameter("prindatefrom"))%>">
							<input type="hidden" name="prindateto"
								value="<%=Util.null2String(request.getParameter("prindateto"))%>">
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input class="e8_btn_submit" type="submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>"
								class="e8_btn_submit" onclick="doSearch()" />
							<span class="e8_sep_line">|</span>
							<input type="button"
								value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"
								class="e8_btn_cancel" onclick="resetCondtion();" />
							<span class="e8_sep_line">|</span>
							<input class="e8_btn_cancel" type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>"
								class="e8_btn_cancel" id="cancel" />
						</wea:item>
					</wea:group>
				</wea:layout>
				<div id="formFieldDiv"></div>
			</div>
		</form>
		<%
			   String pageId = "5";
			    boolean hascreatetime=true;
			    String backfields = " workflowtype,requestname,id, p_nodeid,p_opteruid,p_date,p_addip,p_number,requestid  ";
			    String fromSql = " from Workflow_viewLog ";//xxxxx
			    String sqlWhere =wherest;
			    String orderby="p_date";
			     //out.println(backfields+fromSql+sqlWhere);
				//设置好搜索条件				
			    String tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\"  cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >"
					+ "	   <sql backfields=\"" + backfields + "\" sqlform=\"" + fromSql
					+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\"  sqlorderby=\"" + orderby + "\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"
					+ "			<head>";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(26876,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\"  />";	
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\" column=\"workflowtype\" orderkey=\"workflowtype\"   />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21529,user.getLanguage())+"\" column=\"p_nodeid\" orderkey=\"p_nodeid\" transmethod=\"weaver.general.DateUtil.getWFNodename\" otherpara=\""	+ user.getLanguage() + "\"/>";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"p_opteruid\"  orderkey=\"p_opteruid\"      transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\""+user.getLogintype()+"\"  />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23199,user.getLanguage())+"\" column=\"p_date\" orderkey=\"p_date\" />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33586,user.getLanguage())+"\" column=\"p_addip\" orderkey=\"p_addip\" />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22308,user.getLanguage())+"\" column=\"p_number\" orderkey=\"p_number\" transmethod=\"weaver.general.DateUtil.getWFPnumber\"  otherpara=\""	+ user.getLanguage() + "\" />";
		         tableString += "			</head>" + "</table>";
			  %>
		<wea:SplitPageTag tableString="<%=tableString %>"
			isShowTopInfo="false" mode="run" />
		<%}else{%>

		<table id="topTitle" cellpadding="0" cellspacing="0"
			style="width: 100%">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 500px !important">
					<input type="text" class="searchInput" value="<%=requestname%>"		name="flowTitle" />
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
					<wea:item> <%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></wea:item>
					<wea:item>
						<input type="text" value="<%=requestname %>" name="requestname"		id="requestname">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>

					<wea:item>
						<brow:browser id="workflowid2" name="workflowid2" viewType="0"
							hasBrowser="true" hasAdd="false"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
							isMustInput="1" isSingle="true" hasInput="true"
							completeUrl="/data.jsp?type=workflowBrowser" width='80%'
							browserValue='<%=""+workflowid2%>'
							browserSpanValue='<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowid2+""),user.getLanguage())%>' />

					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21529,user.getLanguage())%></wea:item>
					<wea:item>
						<input type="text" value='<%=p_nodename %>' name="p_nodename"
							id="p_nodename">
					</wea:item>


					<wea:item> <%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%> </wea:item>
					<wea:item>
						<brow:browser viewType="0" name="createrid"
							browserValue='<%= createrid+"" %>' browserOnClick=""
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" width="120px" isSingle="true" hasBrowser="true"
							isMustInput='1' completeUrl="/data.jsp"
							browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid+""),user.getLanguage())%>'>
						</brow:browser>
					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(33826,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="ownerdepartmentid"
							browserValue='<%= ""+ownerdepartmentid %>' browserOnClick=""
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
							completeUrl="/data.jsp?type=4" width="120px"
							browserSpanValue='<%=!ownerdepartmentid.equals("0")?Util.toScreen(DepartmentComInfo.getDepartmentname(ownerdepartmentid+""),user.getLanguage()):""%>'>
						</brow:browser>
					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(33827,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="creatersubcompanyid"
							browserValue='<%= ""+creatersubcompanyid %>' browserOnClick=""
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
							completeUrl="/data.jsp?type=164" width="120px"
							browserSpanValue='<%=!creatersubcompanyid.equals("0")?Util.toScreen(SubCompanyComInfo.getSubCompanyname(creatersubcompanyid+""),user.getLanguage()):""%>'>
						</brow:browser>
					</wea:item>


					<wea:item><%=SystemEnv.getHtmlLabelName(23199,user.getLanguage())%></wea:item>
					<wea:item>
						<select name=prindate id="prindate"
							onchange="changeDate(this,'recievedate');" class=inputstyle
							size=1 style="width: 150">
							<option value="0" <%if(prindate==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
							<option value="1" <%if(prindate==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
							<option value="2" <%if(prindate==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
							<option value="3" <%if(prindate==3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
							<option value="4" <%if(prindate==4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
							<option value="5" <%if(prindate==5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
							<option value="6" <%if(prindate==6){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17908, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19467, user.getLanguage())%></option>
						</select>
						<span id="recievedate" style="display: <%if(prindate!=6){ %>none<%} %>">
							<button type="button" class="calendar" id="SelectDate"
								onclick="getDate(prindatefromspan,prindatefrom)"></button>&nbsp;
							<span id="prindatefromspan"><%=Util.null2String(request.getParameter("prindatefrom"))%></span>
							-&nbsp;&nbsp;
							<button type="button" class="calendar" id="SelectDate1"
								onclick="getDate(prindatetospan,prindateto)"></button>&nbsp; <span
							id="prindatetospan"><%=Util.null2String(request.getParameter("prindateto"))%></span>
						</span>
						<input type="hidden" name="prindatefrom"
							value="<%=Util.null2String(request.getParameter("prindatefrom"))%>">
						<input type="hidden" name="prindateto"
							value="<%=Util.null2String(request.getParameter("prindateto"))%>">
					</wea:item>

				</wea:group>

				<wea:group context="">
					<wea:item type="toolbar">
						<input class="e8_btn_submit" type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"
							class="e8_btn_submit" onclick="doSearch()" />
						<span class="e8_sep_line">|</span>
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"
							class="e8_btn_cancel" onclick="resetCondtion();" />
						<span class="e8_sep_line">|</span>
						<input class="e8_btn_cancel" type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"
							class="e8_btn_cancel" id="cancel" />
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="formFieldDiv"></div>
		</div>
		</form>
		<%
			  
			
			   String pageId = "5";
			    boolean hascreatetime=true;
			    String backfields = " workflowtype,requestname,id, p_nodeid,p_opteruid,p_date,p_addip,p_number,requestid  ";
			    String fromSql = " from Workflow_viewLog ";//xxxxx
			    String sqlWhere =wherest;
			    String orderby="p_date";
			    
			    String wheresqlc=sqlWhere+ " and   exists (  SELECT 1 from workflow_requestbase a, workflow_currentoperator b   "+wheresql +" and Workflow_viewLog.requestid=a.requestid)";
			 //   out.println(backfields+fromSql+wheresqlc);
				//设置好搜索条件				
			    String tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\"  cssHandler=\"com.weaver.cssRenderHandler.request.CheckboxColorRender\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.getWFPageId(urlType),user.getUID()) + "\" >"
					+ "	   <sql backfields=\"" + backfields + "\" sqlform=\"" + fromSql
					+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(wheresqlc) + "\"  sqlorderby=\"" + orderby + "\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"
					+ "			<head>";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(26876,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\"  />";	
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\" column=\"workflowtype\" orderkey=\"workflowtype\"   />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21529,user.getLanguage())+"\" column=\"p_nodeid\" orderkey=\"p_nodeid\" transmethod=\"weaver.general.DateUtil.getWFNodename\" otherpara=\""	+ user.getLanguage() + "\"/>";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"p_opteruid\"  orderkey=\"p_opteruid\"      transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\""+user.getLogintype()+"\"  />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23199,user.getLanguage())+"\" column=\"p_date\" orderkey=\"p_date\" />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33586,user.getLanguage())+"\" column=\"p_addip\" orderkey=\"p_addip\" />";
				 tableString += " <col display=\""+hascreatetime+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22308,user.getLanguage())+"\" column=\"p_number\" orderkey=\"p_number\" transmethod=\"weaver.general.DateUtil.getWFPnumber\"  otherpara=\""	+ user.getLanguage() + "\" />";
		         tableString += "			</head>" + "</table>";
			  %>
		<wea:SplitPageTag tableString="<%=tableString %>"
			isShowTopInfo="false" mode="run" />

		<%} %>


		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle"
							onclick="closeCancle()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">
		function closeCancle(){
		  parent.parent.parent.getDialog(parent).closeByHand();
		}
 
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<br>
<br><br>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer"
			src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</BODY>
</HTML>
