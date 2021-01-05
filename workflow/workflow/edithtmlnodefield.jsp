<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="OthersMethod" class="weaver.workflow.exceldesign.OthersMethod" scope="page" />
<%
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
//把权限判断放到最上面，不影响下面的初始化对象、参数
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="WFNodeFieldMainManager2" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();
FormFieldMainManager.setIsHtmlMode(1);
%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<%
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int ajax = Util.getIntValue(request.getParameter("ajax"), 0);
int needprep = Util.getIntValue(request.getParameter("needprep"), 0);
int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
int design = Util.getIntValue(request.getParameter("design"), 0);
int isExcel = Util.getIntValue(request.getParameter("isExcel"),0);	//是否 新版表单设计器
int exceloutype = Util.getIntValue(request.getParameter("eloutype"));	//新版设计器 layouttype
String nodetype = "";
rs.execute("select nodetype from workflow_flownode where nodeid="+nodeid);
if(rs.next()){
	nodetype = ""+Util.getIntValue(rs.getString("nodetype"), 0);
}
int colsperrow = 1;
rs.execute("select colsperrow from workflow_flownodehtml where workflowid="+wfid+" and nodeid="+nodeid);
if(rs.next()){
	colsperrow = Util.getIntValue(rs.getString("colsperrow"), 1);
}
WFManager.setWfid(wfid);
WFManager.getWfInfo();
int formid = WFManager.getFormid();
String isbill = ""+Util.getIntValue(WFManager.getIsBill(), 0);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23689,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<HTML>
<HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<TITLE></TITLE>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isExcel == 0)
{
	if(ajax == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(23690,user.getLanguage())+",javascript:prepShowHtml("+formid+","+wfid+","+nodeid+","+isbill+",0,"+ajax+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	if(ajax == 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldbatchsave(),_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep;
	
	
	if(ajax == 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_self} " ;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelBatchSet("+nodeid+"),_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if (ajax == 1) {%>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:fieldbatchsave();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%}%>
<%
	//为了提交 不刷新页面
	if(isExcel != 0)
	{
%>
	<div style="display:none">
	<iframe src="" id="excelframe4submit" name="excelframe4submit"></iframe>
	</div>
<%
	}
%>
<form id="nodefieldhtml" name="nodefieldhtml" method="post" action="/workflow/workflow/wf_operation.jsp"  <%=isExcel==0?"target=\"_self\"":"target=\"excelframe4submit\"" %>>
<input type="hidden" id="ajax" name="ajax" value="<%=ajax%>">
<input type="hidden" id="src" name="src" value="nodefieldhtml">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="needprep" name="needprep" value="0">
<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>">
<input type="hidden" id="needcreatenew" name="needcreatenew" value="0">
<input type="hidden" id="nodetype" name="nodetype" value="<%=nodetype%>">
<input type="hidden" id="design" name="design" value="<%=design%>">
<input type="hidden" id="isExcel" name="isExcel" value="<%=isExcel %>" >
<input type="hidden" id="excelStyle" name="excelStyle" value="" >
<input type="hidden" id="excelIssys" name="excelIssys" value="" >
<input type="hidden" id="saveAttrFlag" name="saveAttrFlag" value="" >
<input type="hidden" id="exceloutype" name="exceloutype" value="<%=exceloutype %>" >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(23692,user.getLanguage())%>&nbsp;&nbsp;
			<%if(isExcel == 0){ %>
			<select id="colsperrow" name="colsperrow" style="width:50px">
				<option value="1" <%if(colsperrow==1){out.print(" selected ");}%>>1</option>
				<option value="2" <%if(colsperrow==2){out.print(" selected ");}%>>2</option>
				<option value="3" <%if(colsperrow==3){out.print(" selected ");}%>>3</option>
				<option value="4" <%if(colsperrow==4){out.print(" selected ");}%>>4</option>
			</select>		
			<%} %>
		</wea:item>
		<wea:item>
			<%if(isExcel != 0){%>
				<select id="colsperrow" name="colsperrow" style="width:50px">
					<option value="1" <%if(colsperrow==1){out.print(" selected ");}%>>1</option>
					<option value="2" <%if(colsperrow==2){out.print(" selected ");}%>>2</option>
					<option value="3" <%if(colsperrow==3){out.print(" selected ");}%>>3</option>
					<option value="4" <%if(colsperrow==4){out.print(" selected ");}%>>4</option>
				</select>	
			<%}else{%>	
			<%if(ajax == 1){%>
				<a href="javascript:prepShowHtml(<%=formid%>,<%=wfid%>,<%=nodeid%>,<%=isbill%>,0,<%=ajax%>)"><%=SystemEnv.getHtmlLabelName(23690,user.getLanguage())%></a>
			<%}}%>	
			
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<table class=ListStyle  style="width:100%;padding-left:5px;" cellspacing=1 id="tab_dtl_list-1">
				<colgroup>
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<col width="20%">
				</colgroup>
				<tr class=header>
					<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
					<td><input type="checkbox" name="title_viewall"  onClick="titleviewAll(this)" ><%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%></td>
					<td><input type="checkbox" name="title_editall"  onClick="titleeditAll(this)"><%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%></td>
					<td><input type="checkbox" name="title_manall"  onClick="titlemanAll(this)" ><%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%></td>
				</tr>
				<!--xwj for td1834 on 2005-05-18  begin -->
				<%
				int linecolor=0;
				String messageType = WFManager.getMessageType();
				//微信提醒START(QC:98106)
				String chatsType = WFManager.getChatsType();
				//微信提醒END(QC:98106)
				%>
				<!--xwj for td1834 on 2005-05-18  end -->

				<%
				//初始化workflow_nodeform缺失数据,解决workflow_nodeform导致初始化字段列表为空
				OthersMethod.initNodeFormDatas(nodeid, formid, Util.getIntValue(isbill));

				if(nodeid!=-1 && isbill.equals("0")){
					FormFieldMainManager.setFormid(formid);
					FormFieldMainManager.setNodeid(nodeid);
					FormFieldMainManager.selectFormFieldLableForHtml();
					int groupid=-1;
					String dtldisabled="";
					while(FormFieldMainManager.next()){
						int curid=FormFieldMainManager.getFieldid();
						if(curid==-1){
							boolean isEndNode = false;
							if(nodetype.equals("3")){
								 isEndNode = true;
							}
							String view="";
							String edit="";
							String man="";
							String orderid="";
							WFNodeFieldMainManager2.resetParameter();
							WFNodeFieldMainManager2.setNodeid(nodeid);
							WFNodeFieldMainManager2.setFieldid(-1);//"流程标题"字段在workflow_nodeform中的fieldid 定为 "-1"
							WFNodeFieldMainManager2.selectWfNodeField();
							orderid = WFNodeFieldMainManager2.getOrderid();
							if(WFNodeFieldMainManager2.getIsview().equals("")){
								view = " checked ";
								WFNodeFieldMainManager2.setIsview("1");
								orderid = "0.0";
							}else{
								if(WFNodeFieldMainManager2.getIsview().equals("1"))
								view=" checked";
								if(WFNodeFieldMainManager2.getIsedit().equals("1"))
								edit=" checked";
								if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
								man=" checked";
							}
							if(isEndNode){
								edit = "";
								man = "";
							}
					%>
					<tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
						<td><input type="checkbox" id="title_view0" name="title_view0" <%=view%> onClick="viewChecked(this,'title_edit0','title_man0')" <%="".equals(view)?("".equals(edit) ?"":"checked"): "" %> ></td>
						<td><input type="checkbox" id="title_edit0" name="title_edit0" <%=edit%> onClick="editChecked(this,'title_view0','title_man0')" <%if(isEndNode){%>disabled<%}%> ></td>
						<td><input type="checkbox" id="titleFillId" name="title_man0" <%=man%> onClick="manChecked(this,'title_view0','title_edit0')" <%if(isEndNode){%>disabled<%}%>  <%="".equals(man)?("".equals(edit) ?"":"checked"): "" %>></td>
						<td><input type="text" class="Inputstyle" name="title_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
					</tr>
					<%
							if(linecolor==0) {
								linecolor=1;
							}else{
								linecolor=0;
							}
							WFNodeFieldMainManager2.closeStatement();
							continue;
						}else if(curid==-2){
						
							boolean isEndNode = false;
							if(nodetype.equals("3")){
								isEndNode = true;
							}
							String view="";
							String edit="";
							String man="";
							String orderid="";
							WFNodeFieldMainManager2.resetParameter();
							WFNodeFieldMainManager2.setNodeid(nodeid);
							WFNodeFieldMainManager2.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
							WFNodeFieldMainManager2.selectWfNodeField();
							orderid = WFNodeFieldMainManager2.getOrderid();
							if(WFNodeFieldMainManager2.getIsview().equals("")){
								view = " checked ";
								WFNodeFieldMainManager2.setIsview("1");
								orderid = "1.0";
							}else{
							   if(WFNodeFieldMainManager2.getIsview().equals("1"))
								  view=" checked";
							   if(WFNodeFieldMainManager2.getIsedit().equals("1"))
								  edit=" checked";
							   if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
								  man=" checked";
							}
							if(isEndNode){
							   edit = "";
							   man = "";
							}
					%>
					<tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
						<td><input type="checkbox" id="level_view0" name="level_view0" <%=view%> onClick="viewChecked(this,'level_edit0','level_man0')" ></td>
						<td><input type="checkbox" id="level_edit0" name="level_edit0" <%=edit%> onClick="editChecked(this,'level_view0','level_man0')" <%if(isEndNode){%>disabled<%}%> ></td>
						<td><input type="checkbox" id="level_man0" name="level_man0" <%=man%> onClick="manChecked(this,'level_view0','level_edit0')" <%if(isEndNode){%>disabled<%}%>></td>
						<td><input type="text" class="Inputstyle" name="level_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				    </tr>
					<%
							if(linecolor==0) {
								linecolor=1;
							}
							else{
								linecolor=0;
							}
				
							WFNodeFieldMainManager2.closeStatement();
					
							continue;
						}else if(curid==-3){
							if(!messageType.equals("1")) continue;
							boolean isEndNode = false;
							if(nodetype.equals("3")){
							 isEndNode = true;
							}
							String view="";
							String edit="";
							String man="";
							String orderid="";
							WFNodeFieldMainManager2.resetParameter();
							WFNodeFieldMainManager2.setNodeid(nodeid);
							WFNodeFieldMainManager2.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
							WFNodeFieldMainManager2.selectWfNodeField();
							orderid = WFNodeFieldMainManager2.getOrderid();
							if(WFNodeFieldMainManager2.getIsview().equals("")){
								view = " checked ";
								WFNodeFieldMainManager2.setIsview("1");
								orderid = "2.0";
							}else{
							   if(WFNodeFieldMainManager2.getIsview().equals("1"))
								  view=" checked";
							   if(WFNodeFieldMainManager2.getIsedit().equals("1"))
								  edit=" checked";
							   if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
								  man=" checked";
							}
							if(isEndNode){
							   edit = "";
							   man = "";
							}
					%>
					<tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
						<td><input type="checkbox" id="ismessage_view0" name="ismessage_view0" <%=view%> onClick="viewChecked(this,'ismessage_edit0','ismessage_man0')"  ></td>
						<td><input type="checkbox" id="ismessage_edit0" name="ismessage_edit0" <%=edit%> onClick="editChecked(this,'ismessage_view0','ismessage_man0')" <%if(isEndNode){%>disabled<%}%> ></td>
						<td><input type="checkbox" id="ismessage_man0" name="ismessage_man0" <%=man%> onClick="manChecked(this,'ismessage_view0','ismessage_edit0')" <%if(isEndNode){%>disabled<%}%>></td>
						<td><input type="text" class="Inputstyle" name="ismessage_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				  	</tr>
					<%
							if(linecolor==0) {
								linecolor=1;
							}
							else{
								linecolor=0;
							}
							WFNodeFieldMainManager2.closeStatement();
						
							continue;
						//微信提醒START(QC:98106)
						}else if(curid==-5){
							if(!chatsType.equals("1")) continue;
							boolean isEndNode = false;
							if(nodetype.equals("3")){
							 isEndNode = true;
							}
							String view="";
							String edit="";
							String man="";
							String orderid="";
							WFNodeFieldMainManager2.resetParameter();
							WFNodeFieldMainManager2.setNodeid(nodeid);
							WFNodeFieldMainManager2.setFieldid(-5);//"是否微信提醒"字段在workflow_nodeform中的fieldid 定为 "-5"
							WFNodeFieldMainManager2.selectWfNodeField();
							orderid = WFNodeFieldMainManager2.getOrderid();
							if(WFNodeFieldMainManager2.getIsview().equals("")||WFNodeFieldMainManager2.getIsview().equals(" ")){ 
								view = " checked";
								WFNodeFieldMainManager2.setIsview("1");
								orderid = "2.0";
							}else{ 
							   if(WFNodeFieldMainManager2.getIsview().equals("1"))
								  view=" checked";
							   if(WFNodeFieldMainManager2.getIsedit().equals("1"))
								  edit=" checked";
							   if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
								  man=" checked";
							}
							if(isEndNode){
							   edit = "";
							   man = "";
							}
					%>
					 <tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></td>
							<td><input type="checkbox"  name="ischats_view0" <%=view%> onClick="if(this.checked==false){document.nodefieldhtml.ischats_edit0.checked=false;document.nodefieldhtml.ischats_man0.checked=false;}"  disabled ></td>
							<td><input type="checkbox" name="ischats_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.ischats_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.ischats_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
							<td><input type="checkbox" name="ischats_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.ischats_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.ischats_edit0.checked=(this.checked==true?true:false);}" disabled ></td>
							<td><input type="text" class="Inputstyle" name="ischats_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				  </tr>
				<%
							if(linecolor==0) {
								linecolor=1;
							}
							else{
								linecolor=0;
							}
							WFNodeFieldMainManager2.closeStatement();
						
							continue;
						//微信提醒END(QC:98106)
						}else if(curid==-4 ){
							boolean isEndNode = true;
							String view="";
							String edit="";
							String man="";
							String orderid="";
							WFNodeFieldMainManager2.resetParameter();
							WFNodeFieldMainManager2.setNodeid(nodeid);
							WFNodeFieldMainManager2.setFieldid(-4);//"签字意见"字段在workflow_nodeform中的fieldid 定为 "-4"
							WFNodeFieldMainManager2.selectWfNodeField();
							orderid = WFNodeFieldMainManager2.getOrderid();
							if(WFNodeFieldMainManager2.getIsview().equals("")
								|| WFNodeFieldMainManager2.getIsview().equals("null")){//update by liaodong  for qc43064 in 20130909
								view = "";//update by liaodong  for qc43064 in 20130909
								WFNodeFieldMainManager2.setIsview("0"); //update by liaodong  for qc43064 in 20130909
								if(!messageType.equals("1")){
								  orderid = "2.0";
								}else{
								  orderid = "3.0";
								}
								
							}else{
								if(WFNodeFieldMainManager2.getIsview().equals("1"))
									view=" checked";
								if(WFNodeFieldMainManager2.getIsedit().equals("1"))
									edit=" checked";
								if(WFNodeFieldMainManager2.getIsmandatory().equals("1"))
									man=" checked";
							}
							if(isEndNode){
							   edit = "";
							   man = "";
							}
					%>
					<tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
						<td><input type="checkbox" id="isremark_view0" name="isremark_view0" <%=view%> onClick="viewChecked(this,'isremark_edit0','isremark_man0')"  ></td>
						<td><input type="checkbox" id="isremark_edit0" name="isremark_edit0" <%=edit%> onClick="editChecked(this,'isremark_view0','isremark_man0')" disabled ></td>
						<td><input type="checkbox" id="isremark_man0" name="isremark_man0" <%=man%> onClick="manChecked(this,'isremark_view0','isremark_edit0')" disabled></td>
						<td><input type="text" class="Inputstyle" name="isremark_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				    </tr>
					<%
							if(linecolor==0) {
								linecolor=1;
							}
							else{
								linecolor=0;
							}
							WFNodeFieldMainManager2.closeStatement();
						
							continue;
						}
						String fieldname=FieldComInfo.getFieldname(""+curid);
						//if (fieldname.equals("manager")) continue;//字段为“manager”这个字段是程序后台所用，不必做必填之类的设置!
						String fieldhtmltype = FieldComInfo.getFieldhtmltype(""+curid);
						String curlable = FormFieldMainManager.getFieldLable();
						int curgroupid=FormFieldMainManager.getGroupid();
						//表单头group值为－1，会引起拼装checkbox语句的脚本错误，这里简单的处理为999
						if(curgroupid==-1) curgroupid=999;
						String isdetail = FormFieldMainManager.getIsdetail();
						WFNodeFieldMainManager.resetParameter();
						WFNodeFieldMainManager.setNodeid(nodeid);
						WFNodeFieldMainManager.setFieldid(curid);
						WFNodeFieldMainManager.selectWfNodeField();
						String view="";
						String edit="";
						String man="";
						String orderid = "";
						if(isdetail.equals("1") && curgroupid>groupid) {
							groupid=curgroupid;
				
							WFNodeDtlFieldManager.setNodeid(nodeid);
							WFNodeDtlFieldManager.setGroupid(curgroupid);
							WFNodeDtlFieldManager.selectWfNodeDtlField();
				
							String dtladd = WFNodeDtlFieldManager.getIsadd();
							if(dtladd.equals("1")) dtladd=" checked";
				
							String dtledit = WFNodeDtlFieldManager.getIsedit();
							if(dtledit.equals("1")) dtledit=" checked";
				
							String dtldelete = WFNodeDtlFieldManager.getIsdelete();
							if(dtldelete.equals("1")) dtldelete=" checked";
				
							String dtlhide = WFNodeDtlFieldManager.getIshide();
							if(dtlhide.equals("1")) dtlhide=" checked";
							
							String dtldefault = WFNodeDtlFieldManager.getIsdefault();
				        	if(dtldefault.equals("1")) dtldefault=" checked";
				        	
				            String dtlneed = WFNodeDtlFieldManager.getIsneed();
				        	if(dtlneed.equals("1")) dtlneed=" checked";
							
							String isopensapmul = WFNodeDtlFieldManager.getIsopensapmul();//zzl
				        	if(isopensapmul.equals("1")) isopensapmul=" checked";
				        	
				        	String dtlprintserial = WFNodeDtlFieldManager.getIsprintserial();
							if("1".equals(dtlprintserial))	dtlprintserial=" checked";
								
							String allowscroll = WFNodeDtlFieldManager.getAllowscroll();
							if("1".equals(allowscroll)) allowscroll = " checked";
							
				        	int defaultrow = WFNodeDtlFieldManager.getDefaultrows();
				        	if(defaultrow<1)defaultrow=1;
							if(!dtladd.equals(" checked") && !dtledit.equals(" checked")) 
								dtldisabled="disabled";
							else
								dtldisabled="";
						%>
						</table>
						<table class=ListStyle style="width:100%;padding-left:5px;" cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
							<colgroup>
								<col width="20%">
								<col width="80%">
							</colgroup>
							<tr class=header>
								<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid+1%></strong></td>
							</tr>	
							<tr class=DataLight>
								<!-- 允许新增明细 -->
								<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
								<td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
								<!--'<%=String.valueOf(groupid)%>'-->
							</tr>	
							<tr class=DataLight>
								<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
								<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
							</tr>	
							<tr class=DataLight>
								<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
								<td class=field>
									<input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>>
								</td>
							</tr>	
							<%
				            if(!nodetype.equals("3")){
				            %>
				            <tr class=DataLight>
				                <td><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></td>
				                <td class=field><input type="checkbox"  <%if(!dtladd.equals(" checked")){ %> disabled <%}%> name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>></td>
				            </tr>
				            <tr class=DataLight>
				                <td><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></td>
				                <td class=field>
				                	<input type="checkbox" name="dtl_def_<%=groupid%>" <%=dtladd.equals(" checked")?"":"disabled" %> onClick="changeInputState(this,'dtl_defrow<%=groupid%>')" <%=dtldefault%>>
				                	<input type="text" name="dtl_defrow<%=groupid%>" <%=dtladd.equals(" checked")&&dtldefault.equals(" checked")?"":"disabled" %> onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" <%=dtldefault%> value="<%=defaultrow%>" style="width:30px;">
				                </td>
				            </tr>				         				           	
				           	<tr class=DataLight>
				            	<!-- HTML模版下面的新增默认空明细 -->
				                <td><%=SystemEnv.getHtmlLabelName(31592,user.getLanguage())%></td>
				                <td class=field>
				                <!-- 根据 允许新增明细 是否选中(dtladd) 判断 显示还是隐藏 ypc 2012-08-31-->
				                <%if(dtladd.equals(" checked")){%>
				                <input type="checkbox" name="dtl_mul_<%=groupid%>" onClick="" <%=isopensapmul%>>
				                <%}else{%>
				                <input type="checkbox" disabled=false name="dtl_mul_<%=groupid%>" onClick="" <%=isopensapmul%>>
				                <%}%>
				                </td>
				            </tr>				            
				            <%} %>
							<tr class=DataLight>
								<td><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></td>
								<td class=field><input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>></td>
							</tr>
							<tr class=DataLight>
								<td><%=SystemEnv.getHtmlLabelName(81857,user.getLanguage())%></td>
								<td class=field><input type="checkbox" name="dtl_printserial_<%=groupid%>" <%=dtlprintserial%>></td>
							</tr>
							<tr class=DataLight>
								<td><%=SystemEnv.getHtmlLabelName(83507,user.getLanguage())%></td>
								<td class=field><input type="checkbox" name="allowscroll_<%=groupid%>" <%=allowscroll%>></td>
							</tr>
							</table>
							<table class=liststyle style="width:100%;padding-left:5px;" cellspacing=1 id="tab_dtl_list<%=groupid%>" name="tab_dtl_list<%=groupid%>">
								<colgroup>
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
								</colgroup>
								<tr class=header>
									<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
									<td><input type="checkbox" name="node_viewall_g<%=groupid%>"  onClick="nodeCkAll(this)" ><%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%></td>
									<td><input type="checkbox" name="node_editall_g<%=groupid%>"  onClick="nodeCkAll(this)" <%=dtldisabled%>><%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%></td>
									<td><input type="checkbox" name="node_manall_g<%=groupid%>"  onClick="nodeCkAll(this)" <%=dtldisabled%>><%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%></td>
									<td><%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%></td>
								</tr>
						<%}
				
							if(WFNodeFieldMainManager.getIsview().equals("1"))
								view=" checked";
							if(WFNodeFieldMainManager.getIsedit().equals("1"))
								edit=" checked";
							if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
								man=" checked";
							orderid = WFNodeFieldMainManager.getOrderid();
				%>
				 <tr class=DataLight>				
						<td><%=Util.toScreen(curlable,user.getLanguage())%></td>
						<td><input type="checkbox" name="node<%=curid%>_view_g<%=curgroupid%>" <%=view%> onClick="viewChecked(this,'node<%=curid%>_edit_g<%=curgroupid%>','node<%=curid%>_man_g<%=curgroupid%>')"></td>
						<%if(!"7".equals(fieldhtmltype)){%>
						<td><input type="checkbox" name="node<%=curid%>_edit_g<%=curgroupid%>" <%=edit%> <%=dtldisabled%> onClick="editChecked(this,'node<%=curid%>_view_g<%=curgroupid%>','node<%=curid%>_man_g<%=curgroupid%>')" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7")){%>disabled<%}%>></td>
						<td><input type="checkbox" name="node<%=curid%>_man_g<%=curgroupid%>"  <%=man%>  <%=dtldisabled%> onClick="manChecked(this,'node<%=curid%>_view_g<%=curgroupid%>','node<%=curid%>_edit_g<%=curgroupid%>')" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7") || fieldhtmltype.equals("9")){%>disabled<%}%>></td>
						<%}else{%>
						<td><input type="checkbox" name="node<%=curid%>_edit_g<%=curgroupid%>" disabled></td>
						<td><input type="checkbox" name="node<%=curid%>_man_g<%=curgroupid%>" disabled></td>
						<%}%>
						<td><input type="text" class="Inputstyle" name="node<%=curid%>_orderid_g<%=curgroupid%>" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				</tr>
				<%
						if(linecolor==0) linecolor=1;
						else linecolor=0;
					}
					FormFieldMainManager.closeStatement();
				}else if(nodeid!=-1 && isbill.equals("1")){
				//int linecolor=0; xwj for td1834 on 2005-05-18
				
					boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
					RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
					if(RecordSet.next()){
						String temptablename = Util.null2String(RecordSet.getString("tablename"));
						if(temptablename.equals("formtable_main_"+formid*(-1)) || temptablename.startsWith("uf_")) isNewForm = true;
					}
				
					boolean iscptbill = false;
					if(isbill.equals("1")&&(formid==7||formid==14||formid==15||formid==18||formid==19||formid==201))
						iscptbill = true;
				
					String sql = "";
					if(isNewForm == true){
						if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
							sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,nvl(t2.viewtype,0) as viewtype,nvl(t2.detailtable,'') as detailtable,t2.fromUser,nvl(t2.textheight,-1) as textheight,nvl(t2.dsporder,0) as dsporder,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,TO_NUMBER((select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),orderid,dsporder,textheight,fieldid desc ";
						}else{
							sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,isnull(t2.viewtype,0) as viewtype,isnull(t2.detailtable,'') as detailtable,t2.fromUser,isnull(t2.textheight,-1) as textheight,isnull(t2.dsporder,0) as dsporder ,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,convert(int, (select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),orderid,dsporder,textheight,fieldid desc ";
						}
					}else{
						if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
							sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,nvl(t2.viewtype,0) as viewtype,nvl(t2.detailtable,'') as detailtable,t2.fromUser,nvl(t2.textheight,-1) as textheight,nvl(t2.dsporder,0) as dsporder,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,detailtable,orderid,dsporder,textheight,fieldid desc ";
						}else{
							sql = "select * from (select distinct t1.fieldid,t1.orderid,t2.billid,t2.fieldname,t2.fieldlabel,t2.fielddbtype,t2.fieldhtmltype,t2.type,isnull(t2.viewtype,0) as viewtype,isnull(t2.detailtable,'') as detailtable,t2.fromUser,isnull(t2.textheight,-1) as textheight,isnull(t2.dsporder,0) as dsporder,t2.childfieldid,t2.imgheight,t2.imgwidth from workflow_nodeform t1 left join (select * from workflow_billfield where billid = "+formid+") t2 on t1.fieldid=t2.id where nodeid="+nodeid+") a order by viewtype,detailtable,orderid,dsporder,textheight,fieldid desc ";
						}
					}
					
					RecordSet.executeSql(sql);
					String predetailtable=null;
					int groupid=0;
					String dtldisabled="";
					while(RecordSet.next()){
						String fieldhtmltype = RecordSet.getString("fieldhtmltype");
						int curid=RecordSet.getInt("fieldid");
						int curlabel = RecordSet.getInt("fieldlabel");
						int viewtype = RecordSet.getInt("viewtype");
						String detailtable = Util.null2String(RecordSet.getString("detailtable"));
						String fieldname = Util.null2String(RecordSet.getString("fieldname"));
						
						if(curid==-1){
							
							boolean isEndNode = false;
						if(nodetype.equals("3")){
							 isEndNode = true;
						 }
						String view="";
						String edit="";
						String man="";
						String orderid="";
						WFNodeFieldMainManager.resetParameter();
						WFNodeFieldMainManager.setNodeid(nodeid);
						WFNodeFieldMainManager.setFieldid(-1);//"流程标题"字段在workflow_nodeform中的fieldid 定为 "-1"
						WFNodeFieldMainManager.selectWfNodeField();
						orderid = WFNodeFieldMainManager.getOrderid();
						if(WFNodeFieldMainManager.getIsview().equals("")){
							view = " checked ";
							WFNodeFieldMainManager.setIsview("1");
							orderid = "0.0";
						}else{
							if(WFNodeFieldMainManager.getIsview().equals("1"))
							view=" checked";
							if(WFNodeFieldMainManager.getIsedit().equals("1"))
							edit=" checked";
							if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
							man=" checked";
						}
						if(isEndNode){
							edit = "";
							man = "";
						}
					%>
					<tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
						<td><input type="checkbox" name="title_view0" <%=view%> onClick="viewChecked(this,'title_edit0','title_man0')" <%="".equals(view)?("".equals(edit) ?"":"checked"): "" %> ></td>
						<td><input type="checkbox"  name="title_edit0" <%=edit%> onClick="editChecked(this,'title_view0','title_man0')" <%if(isEndNode){%>disabled<%}%> ></td>
						<td><input type="checkbox" id="titleFillId" name="title_man0" <%=man%> onClick="manChecked(this,'title_view0','title_edit0')" <%if(isEndNode){%>disabled<%}%>  <%="".equals(man)?("".equals(edit) ?"":"checked"): "" %>></td>
						<td><input type="text" class="Inputstyle" name="title_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
					</tr>
				<%
						if(linecolor==0) {
							linecolor=1;
						}else{
							linecolor=0;
						}
						WFNodeFieldMainManager.closeStatement();
							
							continue;
						}else	if(curid==-2){
							
							boolean isEndNode = false;
						if(nodetype.equals("3")){
						 isEndNode = true;
						}
						String view="";
						String edit="";
						String man="";
						String orderid="";
						WFNodeFieldMainManager.resetParameter();
						WFNodeFieldMainManager.setNodeid(nodeid);
						WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
						WFNodeFieldMainManager.selectWfNodeField();
						orderid = WFNodeFieldMainManager.getOrderid();
						if(WFNodeFieldMainManager.getIsview().equals("")){
							view = " checked ";
							WFNodeFieldMainManager.setIsview("1");
							orderid = "1.0";
						}else{
						   if(WFNodeFieldMainManager.getIsview().equals("1"))
							  view=" checked";
						   if(WFNodeFieldMainManager.getIsedit().equals("1"))
							  edit=" checked";
						   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
							  man=" checked";
						}
						if(isEndNode){
						   edit = "";
						   man = "";
						}
					%>
					 <tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
							<td><input type="checkbox" name="level_view0" <%=view%> onClick="viewChecked(this,'level_edit0','level_man0')" ></td>
							<td><input type="checkbox" name="level_edit0" <%=edit%> onClick="editChecked(this,'level_view0','level_man0')" <%if(isEndNode){%>disabled<%}%> ></td>
							<td><input type="checkbox" name="level_man0" <%=man%> onClick="manChecked(this,'level_view0','level_edit0')" <%if(isEndNode){%>disabled<%}%>></td>
							<td><input type="text" class="Inputstyle" name="level_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				  </tr>
				<%
						if(linecolor==0) {
							linecolor=1;
						}
						else{
							linecolor=0;
						}
				
						WFNodeFieldMainManager.closeStatement();
						
						continue;
					}else	if(curid==-3){
						
						if(!messageType.equals("1")) continue;
						boolean isEndNode = false;
					 if(nodetype.equals("3")){
						 isEndNode = true;
					 }
					String view="";
					String edit="";
					String man="";
					String orderid="";
					WFNodeFieldMainManager.resetParameter();
					WFNodeFieldMainManager.setNodeid(nodeid);
					WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
					WFNodeFieldMainManager.selectWfNodeField();
					orderid = WFNodeFieldMainManager.getOrderid();
					if(WFNodeFieldMainManager.getIsview().equals("")){
						view = " checked ";
						WFNodeFieldMainManager.setIsview("1");
						orderid = "2.0";
					}else{
					   if(WFNodeFieldMainManager.getIsview().equals("1"))
						  view=" checked";
					   if(WFNodeFieldMainManager.getIsedit().equals("1"))
						  edit=" checked";
					   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
						  man=" checked";
					}
					if(isEndNode){
					   edit = "";
					   man = "";
					}
					%>
					 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataLight <%}%> >
						<td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
							<td><input type="checkbox" name="ismessage_view0" <%=view%> onClick="viewChecked(this,'ismessage_edit0','ismessage_man0')"  ></td>
							<td><input type="checkbox" name="ismessage_edit0" <%=edit%> onClick="editChecked(this,'ismessage_view0','ismessage_man0')" <%if(isEndNode){%>disabled<%}%> ></td>
							<td><input type="checkbox" name="ismessage_man0" <%=man%> onClick="manChecked(this,'ismessage_view0','ismessage_edit0')" <%if(isEndNode){%>disabled<%}%>></td>
							<td><input type="text" class="Inputstyle" name="ismessage_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				  </tr>
				 <%
					if(linecolor==0) {
						linecolor=1;
					}
					else{
						linecolor=0;
					}
					WFNodeFieldMainManager.closeStatement();
						
					continue;
					//微信提醒START(QC:98106)
					}else if(curid==-5){ 
						if(!chatsType.equals("1")) continue;
						boolean isEndNode = false;
					 if(nodetype.equals("3")){
						 isEndNode = true;
					 }
					String view="";
					String edit="";
					String man="";
					String orderid="";
					WFNodeFieldMainManager.resetParameter();
					WFNodeFieldMainManager.setNodeid(nodeid);
					WFNodeFieldMainManager.setFieldid(-5);//"是否微信提醒"字段在workflow_nodeform中的fieldid 定为 "-5"
					WFNodeFieldMainManager.selectWfNodeField();
					orderid = WFNodeFieldMainManager.getOrderid(); 
					if(WFNodeFieldMainManager.getIsview().equals("")||WFNodeFieldMainManager.getIsview().equals(" ")){ 
						view = " checked"; 
						WFNodeFieldMainManager.setIsview("1");
						orderid = "2.0";
					}else{ 
					   if(WFNodeFieldMainManager.getIsview().equals("1"))
						  view=" checked";
					   if(WFNodeFieldMainManager.getIsedit().equals("1"))
						  edit=" checked";
					   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
						  man=" checked";
					}
					if(isEndNode){
					   edit = "";
					   man = "";
					}
					%>
					 <tr class=DataLight>
						<td><%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></td>
							<td><input type="checkbox" name="ischats_view0" <%=view%>  onClick="if(this.checked==false){document.nodefieldhtml.ischats_edit0.checked=false;document.nodefieldhtml.ischats_man0.checked=false;}" disabled ></td>
							<td><input type="checkbox" name="ischats_edit0" <%=edit%> onClick="if(this.checked==true){document.nodefieldhtml.ischats_view0.checked=(this.checked==true?true:false);}else{document.nodefieldhtml.ischats_man0.checked=false;}" <%if(isEndNode){%>disabled<%}%> ></td>
							<td><input type="checkbox" name="ischats_man0" <%=man%> onClick="if(this.checked==true){document.nodefieldhtml.ischats_view0.checked=(this.checked==true?true:false);document.nodefieldhtml.ischats_edit0.checked=(this.checked==true?true:false);}"  disabled ></td>
							<td><input type="text" class="Inputstyle" name="ischats_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				  </tr>
				 <%
					if(linecolor==0) {
						linecolor=1;
					}
					else{
						linecolor=0;
					}
					WFNodeFieldMainManager.closeStatement();
						
					continue;
					//微信提醒END(QC:98106)
					}else if(curid==-4){
						boolean isEndNode = true;
					String view="";
					String edit="";
					String man="";
					String orderid="";
					WFNodeFieldMainManager.resetParameter();
					WFNodeFieldMainManager.setNodeid(nodeid);
					WFNodeFieldMainManager.setFieldid(-4);//"签字意见"字段在workflow_nodeform中的fieldid 定为 "-4"
					WFNodeFieldMainManager.selectWfNodeField();
					orderid = WFNodeFieldMainManager.getOrderid();
					if(WFNodeFieldMainManager.getIsview().equals("")
					  || WFNodeFieldMainManager.getIsview().equals("null")){//update by liaodong  for qc43064 in 20130909
						view = "";//update by liaodong  for qc43064 in 20130909
						WFNodeFieldMainManager.setIsview("0"); //update by liaodong  for qc43064 in 20130909
						if(!messageType.equals("1")){
						    orderid = "2.0";
						}else{
						    orderid = "3.0";
						}
						
					}else{
					   if(WFNodeFieldMainManager.getIsview().equals("1"))
						  view=" checked";
					   if(WFNodeFieldMainManager.getIsedit().equals("1"))
						  edit=" checked";
					   if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
						  man=" checked";
					}
					if(isEndNode){
					   edit = "";
					   man = "";
					}
					%>
					 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataLight <%}%> >
						<td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
							<td><input type="checkbox" id="isremark_view0" name="isremark_view0" <%=view%> onClick="viewChecked(this,'isremark_edit0','isremark_man0')"  ></td>
							<td><input type="checkbox" id="isremark_edit0" name="isremark_edit0" <%=edit%> onClick="editChecked(this,'isremark_view0','isremark_man0')" disabled ></td>
							<td><input type="checkbox" id="isremark_man0" name="isremark_man0" <%=man%> onClick="manChecked(this,'isremark_view0','isremark_edit0')" disabled></td>
							<td><input type="text" class="Inputstyle" name="isremark_orderid" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				  </tr>
				 <%
					if(linecolor==0) {
						linecolor=1;
					}
					else{
						linecolor=0;
					}
					WFNodeFieldMainManager.closeStatement();
						
					continue;
				}
					WFNodeFieldMainManager.resetParameter();
					WFNodeFieldMainManager.setNodeid(nodeid);
					WFNodeFieldMainManager.setFieldid(curid);
					WFNodeFieldMainManager.selectWfNodeField();  
					//String dtladd = WFNodeDtlFieldManager.getIsadd();
					
					String view="";
					String edit="";
					String man="";
					String orderid = "";
					if(viewtype==1 && !detailtable.equals(predetailtable)){
						groupid++;
						WFNodeDtlFieldManager.setNodeid(nodeid);
						WFNodeDtlFieldManager.setGroupid(groupid-1);
						WFNodeDtlFieldManager.selectWfNodeDtlField();
						String dtladd = WFNodeDtlFieldManager.getIsadd();
						//String add = WFNodeDtlFieldManager.getIsadd();
							if(dtladd.equals("1")) dtladd=" checked";
						String dtledit = WFNodeDtlFieldManager.getIsedit();
							if(dtledit.equals("1")) dtledit=" checked";
						String dtldelete = WFNodeDtlFieldManager.getIsdelete();
							if(dtldelete.equals("1")) dtldelete=" checked";
						String dtlhide = WFNodeDtlFieldManager.getIshide();
							if(dtlhide.equals("1")) dtlhide=" checked";
						String dtldefault = WFNodeDtlFieldManager.getIsdefault();
				        	if(dtldefault.equals("1")) dtldefault=" checked";
				        String isopensapmul = WFNodeDtlFieldManager.getIsopensapmul();//zzl
				        	if(isopensapmul.equals("1")) isopensapmul=" checked";
				        String dtlneed = WFNodeDtlFieldManager.getIsneed();
				        	if(dtlneed.equals("1")) dtlneed=" checked";
			        	String dtlprintserial = WFNodeDtlFieldManager.getIsprintserial();
							if("1".equals(dtlprintserial))	dtlprintserial=" checked";
						String allowscroll = WFNodeDtlFieldManager.getAllowscroll();
							if("1".equals(allowscroll))	allowscroll = " checked";
				        int defaultrow = WFNodeDtlFieldManager.getDefaultrows();
				        if(defaultrow<1)defaultrow=1;
						predetailtable=detailtable;
						if((formid==156 || formid==157 || formid==158 || isNewForm || iscptbill) && !dtladd.equals(" checked") && !dtledit.equals(" checked"))
							dtldisabled="disabled";
						else
							dtldisabled="";
						%>
						</table>
						
						<wea:layout type="2col" needImportDefaultJsAndCss="false">
						<%if(isNewForm){ %>
						<!-- 节点属性字段 - 普通模版 - 明细 start -->
							<wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+""+groupid%>'>
								<wea:item><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></wea:item>
								<wea:item> 
									<input type="checkbox" id="dt_add" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>>
								</wea:item>
								
								<wea:item><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></wea:item>
								<wea:item> 
									<input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></wea:item>
								<wea:item> 
									<input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>>
								</wea:item>
								<%
				            	if(!nodetype.equals("3")){
				            	%>
								<wea:item><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></wea:item>
								<wea:item> 
					                 <input type="checkbox" id="dt_ned" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%> <%=dtladd.equals(" checked")?"":"disabled" %>>
								</wea:item>
								
								<wea:item><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></wea:item>
								<wea:item>
					                 <input type="checkbox" id="dt_def"  name="dtl_def_<%=groupid%>" <%=dtladd.equals(" checked")?"":"disabled" %> onClick="changeInputState(this,'dtl_defrow<%=groupid%>')" <%=dtldefault%> >
					                 <input type="text" name="dtl_defrow<%=groupid%>" <%=dtladd.equals(" checked")&&dtldefault.equals(" checked")?"":"disabled" %> onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow%>" style="width:30px;">
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(31592,user.getLanguage())%></wea:item>
								<wea:item>
					                 <input type="checkbox" id="dt_mul" name="dtl_mul_<%=groupid%>" onClick="" <%=isopensapmul%> <%=dtladd.equals(" checked")?"":"disabled" %>>
								</wea:item>
								<%} %>
								<wea:item><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></wea:item>
								<wea:item>
									<input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(81857,user.getLanguage())%></wea:item>
								<wea:item>
									<input type="checkbox" name="dtl_printserial_<%=groupid%>" <%=dtlprintserial%>>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(83507,user.getLanguage())%></wea:item>
								<wea:item>
									<input type="checkbox" name="allowscroll_<%=groupid%>" <%=allowscroll%>>
								</wea:item>
							</wea:group>
								<%}else{%>
							<wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+""+groupid%>'>
								<% if(formid==7||formid==156 || formid==157 || formid==158 || iscptbill){%>	
								<wea:item><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></wea:item>
								<wea:item>
									<input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></wea:item>
								<wea:item>
									<input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></wea:item>
								<wea:item>
									<input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>>
								</wea:item>
								<%
				            if(!nodetype.equals("3"))
				            {
				            %>
								<wea:item><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></wea:item>
								<wea:item>
					                 <input type="checkbox" id="dt_ned" name="dtl_ned_<%=groupid%>" <%=dtladd.equals(" checked")?"":"disabled" %> onClick="" <%=dtlneed%>>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></wea:item>
								<wea:item>
					                <input type="checkbox" id="dt_def"  name="dtl_def_<%=groupid%>" <%=dtladd.equals(" checked")?"":"disabled" %> onClick="changeInputState(this,'dtl_defrow<%=groupid%>')" <%=dtldefault%>>
					                <input type="text" name="dtl_defrow<%=groupid%>" <%=dtladd.equals(" checked")&&dtldefault.equals(" checked")?"":"disabled" %> onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow %>" style="width:30px;">
								</wea:item>
								 <%} %>
				            <%} %>
							</wea:group>
							<%} %>
						</wea:layout>
							
							<table class=ListStyle style="width:100%;padding-left:5px;" cellspacing=1 id="tab_dtl_list<%=groupid%>" >
							<COLGROUP>
							<COL width="20%">
							<COL width="20%">
							<COL width="20%">
							<COL width="20%">
							<COL width="20%">
							<tr class=header>
								<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
								<td>
									<input type="checkbox" name="node_viewall_g<%=groupid%>"  onClick="nodeCkAll(this)">
									<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>
								</td>
								<td>
									<input type="checkbox" name="node_editall_g<%=groupid%>" <%=dtldisabled%>  onClick="nodeCkAll(this)" <%if(nodetype.equals("3")){%>disabled<%}%>>
									<%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%>
								</td>
								<td>
									<input type="checkbox" name="node_manall_g<%=groupid%>" <%=dtldisabled%>  onClick="nodeCkAll(this)" <%if(nodetype.equals("3")){%>disabled<%}%>>
									<%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%>
								</td>
							<td>
								<%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%>
							</td>
							</tr>
							
						<%
				
					}
					if(WFNodeFieldMainManager.getIsview().equals("1"))
						view=" checked";
					if(WFNodeFieldMainManager.getIsedit().equals("1"))
						edit=" checked";
					if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
						man=" checked";
					orderid = WFNodeFieldMainManager.getOrderid();
				%>
				 <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataLight <%}%> >
						<td><%=SystemEnv.getHtmlLabelName(curlabel,user.getLanguage())%></td>
						<td><input type="checkbox" name="node<%=curid%>_view_g<%=groupid%>" <%=view%> onClick="viewChecked(this,'node<%=curid%>_edit_g<%=groupid%>','node<%=curid%>_man_g<%=groupid%>')"></td>
						<%if(!fieldhtmltype.equals("7") && !fieldhtmltype.equals("9")){%>		
							<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" <%=edit%> <%=dtldisabled%> onClick="editChecked(this,'node<%=curid%>_view_g<%=groupid%>','node<%=curid%>_man_g<%=groupid%>')" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%> ></td>
							<td><input type="checkbox" name="node<%=curid%>_man_g<%=groupid%>"  <%=man%>  <%=dtldisabled%> onClick="manChecked(this,'node<%=curid%>_view_g<%=groupid%>','node<%=curid%>_edit_g<%=groupid%>')" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%>></td>
						<%}else{%>
							 <%if(fieldhtmltype.equals("9")){ %>
						       <td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" <%=edit%> <%=dtldisabled%> onClick="editChecked(this,'node<%=curid%>_view_g<%=groupid%>','node<%=curid%>_man_g<%=groupid%>')" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%> ></td>
						    <%}else{ %>
						       <td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></td>
						  <%} %>
						<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></td>
						<%}%>
						<td><input type="text" class="Inputstyle" name="node<%=curid%>_orderid_g<%=groupid%>" maxlength="6" onKeyPress="ItemFloat_KeyPress_ehnf(this)" onChange="checkFloat_ehnf(this)" value="<%=orderid%>" style="width:80%"></td>
				</tr>
				
				<%
					if(linecolor==0){
						linecolor=1;
					}else{
						linecolor=0;
					}
				}
		}
		%>
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</BODY>
</HTML>
<script type="text/javascript">
function nodeCkAll(obj){
	var ckbox = $(obj);
	var flag = ckbox.attr("checked");
	var ckboxval = ckbox.attr("name");
	if(ckboxval.indexOf("_view")>=0){
		if(flag){
			ckbox.closest("table").find("input[name*=_view]").attr("checked",true).next().addClass("jNiceChecked");
		}else{
			ckbox.closest("table").find(":checkbox").attr("checked",false).next().removeClass("jNiceChecked");
		}		
	}else if(ckboxval.indexOf("_edit")>=0){
		if(flag){
			ckbox.closest("table").find("input[name*=_view]").attr("checked",true).next().addClass("jNiceChecked");
			ckbox.closest("table").find("input[name*=_edit]").attr("checked",true).next().addClass("jNiceChecked");
		}else{
			ckbox.closest("table").find("input[name*=_edit]").attr("checked",false).next().removeClass("jNiceChecked");
			ckbox.closest("table").find("input[name*=_man]").attr("checked",false).next().removeClass("jNiceChecked");
		}	
	}else if(ckboxval.indexOf("_man")>=0){
		if(flag){
			ckbox.closest("table").find(":checkbox").attr("checked",true).next().addClass("jNiceChecked");			
		}else{
			ckbox.closest("table").find("input[name*=_man]").attr("checked",false).next().removeClass("jNiceChecked");
		}
	}	
}

function viewChecked(obj,editName,manName){
	var editobj = $("input[name='"+editName+"']");
	var manobj = $("input[name='"+manName+"']");
	var editdisa =	editobj.attr("disabled");
	var mandisa =	manobj.attr("disabled");
	if(!obj.checked){
		if(!editdisa){
			editobj.attr("checked",false);
			editobj.next().removeClass("jNiceChecked");
		}
		if(!mandisa){
			manobj.attr("checked",false);
			manobj.next().removeClass("jNiceChecked");
		}		
	}
}

function editChecked(obj,viewName,manName){
	var viewobj = $("input[name='"+viewName+"']");
	var manobj = $("input[name='"+manName+"']");
	var viewdisa =	viewobj.attr("disabled");
	var mandisa =	manobj.attr("disabled");
	if(obj.checked){
		if(!viewdisa){
			viewobj.attr("checked",true);
			viewobj.next().addClass("jNiceChecked");
		}
		if($(obj).attr("name") === "title_edit0")
		{
			manobj.attr("checked",true);
			manobj.next().addClass("jNiceChecked");
		}
	}else{
		if(!mandisa){
			manobj.attr("checked",false);
			manobj.next().removeClass("jNiceChecked");
		}		
	}
}

function manChecked(obj,viewName,editName){
	var viewobj = $("input[name='"+viewName+"']");
	var editobj = $("input[name='"+editName+"']");
	var viewdisa =	viewobj.attr("disabled");
	var editdisa =	editobj.attr("disabled");
	if(obj.checked){
		if(!viewdisa){
			viewobj.attr("checked",true);
			viewobj.next().addClass("jNiceChecked");
		}
		
		if(!editdisa){
			editobj.attr("checked",true);
			editobj.next().addClass("jNiceChecked");
		}
	}
}

function changeInputState(obj,inputName){
	var inputobj=$("input[name='"+inputName+"']");
	if(obj.checked){
		inputobj.attr("disabled",false);
	}else{
		inputobj.attr("disabled",true);
	}
}

function titleviewAll(obj){
	if(obj.checked){
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});
	}else{
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
		
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
		
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
	}
}

function titleeditAll(obj){
	if(obj.checked){
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true).next().addClass("jNiceChecked");
			}
			if(ck.attr("name")=="title_edit0"){		//标题必填勾选
				var title_man = $("#tab_dtl_list-1 input[name='title_man0']");
				if(!title_man.attr("disabled"))
					title_man.attr("checked",true).next().addClass("jNiceChecked");
			}
		});
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true).next().addClass("jNiceChecked");
			}
		});		
	}else{		
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false).next().removeClass("jNiceChecked");
			}
			if(ck.attr("name")=="title_edit0"){		//取消标题必填勾选
				var title_man = $("#tab_dtl_list-1 input[name='title_man0']");
				if(!title_man.attr("disabled"))
					title_man.attr("checked",false).next().removeClass("jNiceChecked");
			}
		});
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false).next().removeClass("jNiceChecked");
			}
		});		
	}
	<% if(!nodetype.equals("0") && !nodetype.equals("3")){%>
	if(obj.checked){
		document.getElementById("titleFillId").checked=true;
		document.nodefieldform.level_man.checked=true;
	}else{
		document.getElementById("titleFillId").checked=false;
		document.nodefieldform.level_man.checked=false;
	}
	<%} %>	
}

function titlemanAll(obj){
	if(obj.checked){
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});		
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});				
	}else{		
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
	}
}


</script>
<script language="javascript">
<%if(ajax == 0){%>
function prepShowHtml(formid,wfid,nodeid,isbill,layouttype,ajax){
	openFullWindowHaveBar("/workflow/html/index.jsp?formid="+formid+"&wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype="+layouttype+"&ajax="+ajax)
}
function ItemFloat_KeyPress_ehnf(obj){
	if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==46)){
		window.event.keyCode=0;
	}
}
function submitData(){
	//是否初始化显示模板-zzl
	if(confirm("<%=SystemEnv.getHtmlLabelName(23708, user.getLanguage())%>")){
		nodefieldhtml.needcreatenew.value = "1";
	}else{
		nodefieldhtml.needcreatenew.value = "0";
	}
	nodefieldhtml.needprep.value = "2";
	nodefieldhtml.submit();
}
function checkFloat_ehnf(obj){
	var valuenow = obj.value;
	var index = valuenow.indexOf(".");
	var valuechange = valuenow;
	if(index > -1){
		if(index == 0){
			valuechange = "0"+valuenow;
			index = 1;
		}
		valuenow = valuechange.substring(0, index+1);
		valuechange = valuechange.substring(index+1, valuechange.length);
		if(valuechange.length > 2){
			valuechange = valuechange.substring(0, 2);
		}
		index = valuechange.indexOf(".");
		if(index > -1){
			valuechange = valuechange.substring(0, index);
		}
		valuenow = valuenow + valuechange;
		index = valuenow.indexOf(".");
		if(index>-1 && index==valuenow.length-1){
			if(valuenow.length>=6){
				valuenow = valuenow.substring(0, index);
			}else{
				valuenow = valuenow + "0";
			}
		}
		obj.value = valuenow;
	}
}

function onChangeViewAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	//alert(tab_id);
	var tab_name = document.getElementById(tab_id);
	//alert(tab_name);
	var row = tab_name.rows.length;
	//alert(row);
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows(i);
		//alert(tmpTr);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd1 = tmpTr.cells(1);
		if(tmpTd1 == undefined){
			continue;
		}
		//var tmpName = tmpTd1.childNodes[0].name;
		//alert(tmpName);
		if(tmpTd1.childNodes[0].disabled == false){
			tmpTd1.childNodes[0].checked = opt;
		}

		if(opt == false){
			var tmpTd2 = tmpTr.cells(2);
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}

			var tmpTd3 = tmpTr.cells(3);
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeEditAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows(i);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd2 = tmpTr.cells(2);
		if(tmpTd2 == undefined){
			continue;
		}
		if(tmpTd2.childNodes[0].disabled == false){
			tmpTd2.childNodes[0].checked = opt;
		}
		if(opt == false){
			var tmpTd3 = tmpTr.cells(3);
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
				}
		}else{
			var tmpTd1 = tmpTr.cells(1);
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeManAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows(i);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd3 = tmpTr.cells(3);
		if(tmpTd3 == undefined){
			continue;
		}
		if(tmpTd3.childNodes[0].disabled == false){
			tmpTd3.childNodes[0].checked = opt;
		}
		if(opt == true){
			var tmpTd1 = tmpTr.cells(1);
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
			var tmpTd2 = tmpTr.cells(2);
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}
		}
	}
}
<%}else{%>
function ItemFloat_KeyPress_ehnf(obj){
	if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==46)){
		window.event.keyCode=0;
	}
}

function checkFloat_ehnf(obj){
	var valuenow = obj.value;
	var index = valuenow.indexOf(".");
	var valuechange = valuenow;
	if(index > -1){
		if(index == 0){
			valuechange = "0"+valuenow;
			index = 1;
		}
		valuenow = valuechange.substring(0, index+1);
		valuechange = valuechange.substring(index+1, valuechange.length);
		if(valuechange.length > 2){
			valuechange = valuechange.substring(0, 2);
		}
		index = valuechange.indexOf(".");
		if(index > -1){
			valuechange = valuechange.substring(0, index);
		}
		valuenow = valuenow + valuechange;
		index = valuenow.indexOf(".");
		if(index>-1 && index==valuenow.length-1){
			if(valuenow.length>=6){
				valuenow = valuenow.substring(0, index);
			}else{
				valuenow = valuenow + "0";
			}
		}
		obj.value = valuenow;
	}
}

function prepShowHtml(formid,wfid,nodeid,isbill,layouttype,ajax){
	if(confirm("<%=SystemEnv.getHtmlLabelName(23708, user.getLanguage())%>")){
		nodefieldhtml.needcreatenew.value = "1";
	}else{
		nodefieldhtml.needcreatenew.value = "0";
	}
    nodefieldhtml.needprep.value = "1";
	nodefieldhtml.submit();
	//上面那句判断是提示要不要先保存的。下面这句是跳转页面的。完全可以不保存仍旧跳转
	//callFunction(formid,wfid,nodeid,isbill,layouttype,ajax);
}

function callFunction(formid,wfid,nodeid,isbill,layouttype,ajax){
	var needprep = "1";
	var modeid = "0";
	try{
		needprep = nodefieldhtml.needprep.value;
		modeid = nodefieldhtml.modeid.value;
	}catch(e){}
	if(needprep == "0"){
		showHtmlLayoutFck(formid,wfid,nodeid,isbill,layouttype,ajax,modeid);
	}else{
		window.setTimeout(function(){callFunction(formid,wfid,nodeid,isbill,layouttype,ajax);},1000);
	}
}

function showHtmlLayoutFck(formid,wfid,nodeid,isbill,layouttype,ajax,modeid){
	openFullWindowHaveBar("/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype="+layouttype+"&ajax="+ajax+"&modeid="+modeid)
}

function fieldbatchsave(){
	if(<%=isExcel%> == 0)	//新版表单设计器不需要提示，本身就是需要创建新模板的
	{
		if(confirm("<%=SystemEnv.getHtmlLabelName(23708, user.getLanguage())%>")){
			nodefieldhtml.needcreatenew.value = "1";
		}else{
			nodefieldhtml.needcreatenew.value = "0";
		}
	}
	nodefieldhtml.submit();
}

function cancelBatchSet(tmpnodeid){
	window.location="/workflow/workflow/addwfnodefield.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+tmpnodeid;
}
<%} %>
</script>
<%if(needprep == 1){%>
	<SCRIPT LANGUAGE="javascript">
		showHtmlLayoutFck("<%=formid%>","<%=wfid%>","<%=nodeid%>","<%=isbill%>","0","1");
	</SCRIPT>
<%}%>
<SCRIPT LANGUAGE="javascript">
//允许新增/编辑 明细 点击事件
function checkChange(groupid) {
    var isenable=0;
    var isen=0; 
    if(jQuery("[name=dtl_add_"+groupid+"]").attr("checked"))
    	isen=1;
	if(jQuery("[name=dtl_edit_"+groupid+"]").attr("checked"))
    	isenable=1;
    if(isen==1){
   		jQuery("[name=dtl_ned_"+groupid+"]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   		jQuery("[name=dtl_def_"+groupid+"]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   		jQuery("[name=dtl_defrow"+groupid+"]").attr("disabled",false);
   		jQuery("[name=dtl_mul_"+groupid+"]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
	}else{
    	jQuery("[name=dtl_ned_"+groupid+"]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
   		jQuery("[name=dtl_def_"+groupid+"]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
   		jQuery("[name=dtl_defrow"+groupid+"]").attr("disabled",true);
   		jQuery("[name=dtl_mul_"+groupid+"]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
    }
    if(isenable==1||isen==1){
    	jQuery("[name*=edit_g"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name*=edit_g"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    	jQuery("[name*=man_g"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name*=man_g"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    	jQuery("[name=node_editall_g"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name=node_editall_g"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    	jQuery("[name=node_manall_g"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name=node_manall_g"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    }else{
    	jQuery("[name*=edit_g"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name*=edit_g"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    	jQuery("[name*=man_g"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name*=man_g"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    	jQuery("[name=node_editall_g"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name=node_editall_g"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    	jQuery("[name=node_manall_g"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name=node_manall_g"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    }
}
//验证整数的正确性
function checkcount2(obj){
	var value = obj.value;
	if(value != ""){
		var reg = /^-?\d+$/;
		if (!reg.test(value)){
			obj.value = "1";
		}
		if(parseInt(obj.value)<1){
			obj.value = "1";
		}
	}
}
</SCRIPT>
