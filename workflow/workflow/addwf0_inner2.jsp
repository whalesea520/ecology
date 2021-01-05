<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*,weaver.systeminfo.*" %>
<%@page import="weaver.systeminfo.menuconfig.MenuUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
  String isTemplate = Util.null2String(request.getParameter("isTemplate"));
	String wfname = Util.null2String(request.getParameter("wfname"));
	String type = Util.null2String(request.getParameter("type"));
	String templatename = Util.null2String(request.getParameter("templatename"));
	String templateid = Util.null2String(request.getParameter("templateid"));
    int detachable=Util.getIntValue(Util.null2String(request.getParameter("detachable")));
	int operatelevel=Util.getIntValue(Util.null2String(request.getParameter("operatelevel")));
	int subCompanyId2=Util.getIntValue(Util.null2String(request.getParameter("subCompanyId2")));
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")));
 	int helpdocid=Util.getIntValue(Util.null2String(request.getParameter("helpdocid")));
	int dsporder=Util.getIntValue(Util.null2String(request.getParameter("dsporder")));
	int typeid=Util.getIntValue(Util.null2String(request.getParameter("typeid")));
	String wfdes = Util.null2String(request.getParameter("wfdes"));

	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")));

	String isbill = Util.null2String(request.getParameter("isbill"));
	int isSaveas=Util.getIntValue(Util.null2String(request.getParameter("isSaveas")));

	String from=Util.null2String(request.getParameter("from"));
	String isvalid=Util.null2String(request.getParameter("isvalid"));
	String isvalidStr=Util.null2String(request.getParameter("isvalidStr"));

	boolean isHasRight="true".equals(Util.null2String(request.getParameter("isHasRight")));
	boolean haspermission="true".equals(Util.null2String(request.getParameter("haspermission")));
	boolean isnewform="true".equals(Util.null2String(request.getParameter("isnewform")));

%>

<wea:layout type="2col">
	<%String context_1 = "<a name='basicA'>"+SystemEnv.getHtmlLabelName(1361,user.getLanguage())+"</a>"; %>
	<wea:group context='<%=context_1%>'>
		<wea:item>
			<%if(!isTemplate.equals("1")){%>
			<%=SystemEnv.getHtmlLabelName(81651,user.getLanguage())%>
			<%}else{%>
			<%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%>
			<%}%>
		</wea:item>
		<wea:item>
			<wea:required id="wfnamespan" required="true" value='<%=wfname %>'>
				<input class=Inputstyle type="text" name="wfname" size="40" onChange="checkinput('wfname','wfnamespan')" maxlength="200" value="<%=wfname%>">
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18167,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(type.equals("editwf")){%>
			<span><%=templatename%>
				<input type="hidden" id="templateid" name="templateid" value="<%=templateid+""%>" />
			</span>
			<%}else{%>
			<brow:browser name="templateid" viewType="0" hasBrowser="true" hasAdd="false"
						  browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=1" isMustInput="1" isSingle="true" hasInput="true"
						  completeUrl="/data.jsp?type=workflowBrowser&isTemplate=1"  width="320px" browserValue='<%=templateid+""%>' browserSpanValue='<%=templatename%>'/>
			<%}%>
		</wea:item>
		<%if(isSaveas!=1){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=typeid>
				<%
					RecordSet.executeSql("select id,typename from workflow_type order by dsporder asc,id asc");
					while(RecordSet.next()){
						String checktmp = "";
						if(typeid == Util.getIntValue(RecordSet.getString("id")))
							checktmp=" selected";
				%>
				<option value="<%=RecordSet.getString("id")%>" <%=checktmp%>><%=RecordSet.getString("typename")%></option>
				<%}%>
			</select>
		</wea:item>
		<%} %>
		<%if(detachable==1){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		<wea:item>
			<%

				if(operatelevel>0 && (!haspermission || isHasRight)){%>
			<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false"
						  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
						  completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="300px" browserValue='<%=String.valueOf(subCompanyId2)%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>'/>
			<%}else{%>
			<span id=subcompanyspan> <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>
                <%if(String.valueOf(subCompanyId2).equals("")){%>
                    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                <%}%>
            </span>
			<input class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subCompanyId2%>">
			<%} %>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) + SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<textarea rows="3" class=Inputstyle name="wfdes" cols="44" style="resize:none;"><%=wfdes%></textarea>
		</wea:item>

		<%
			if (!(isSaveas==1 && "1".equals(isTemplate))) {
				String prjwfformid=Util.null2String( request.getParameter("prjwfformid"));
		%>

		<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name=isbill style="float: left;" onchange="if(this.value==1&&jQuery('#isvalid').val()==2)window.top.Dialog.alert('系统表单不支持测试功能');onchangeisbill(this.value);">
				<option value=3 <%if(isbill.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(557, user.getLanguage())%></option>
				<option value=0 <%if(isbill.equals("0")||isnewform||("prjwf".equalsIgnoreCase(from)&&Util.getIntValue( prjwfformid,0)<0)){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
				<%if(wfid<=0){//只有新建流程时才有该选项
					boolean menu_infoid7_hasShareRight = false;
					//MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
					MenuUtil mu=new MenuUtil("top", 3, 1, user.getLanguage()) ;
					mu.setUser(user);
					RecordSet menuRs=mu.getMenuRs(10004);
					while(menuRs.next()){
						int infoid=menuRs.getInt("infoid");
						int needResourcetype=1;//menuRs.getInt("resourcetype");
						int needResourceid=1;//menuRs.getInt("resourceid");
						//if(!mu.hasShareRight(infoid,needResourceid,needResourcetype)){
						//continue;
						//}
						if(infoid==7){
							RecordSet rs_wf_fna_impLog = new RecordSet();
							rs_wf_fna_impLog.executeSql("select 1 from wf_fna_impLog where isInited = 1");
							if(rs_wf_fna_impLog.next()){
								menu_infoid7_hasShareRight = true;
							}
							break;
						}
					}
					if(menu_infoid7_hasShareRight){
						RecordSet RecordSet1=new RecordSet();
						RecordSet1.executeSql("select 1 from wf_fna_impLog where isInited = 1");
						if(RecordSet1.next()){
				%>
				<option value="4">
					<%=SystemEnv.getHtmlLabelNames("19516,19532",user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(128310,user.getLanguage())%><!-- 自定义表单-费用类流程 -->
				</option>
				<%		}
				}
				} %>
				<option value=1 <%if((isbill.equals("1")&&!isnewform)||("prjwf".equalsIgnoreCase(from)&&Util.getIntValue( prjwfformid,0)>0)){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
			</select>
			<span id="showFormSpan_fnaWfType" style="display: none;">
			    &nbsp;
				<span id="showFormSpan_fnaWfType1">
				    <select id="fnaWfType1" name="fnaWfType1" style="width: 200px;" onchange="fnaWfType1_onchange();">
				    	<option value="1"><%=SystemEnv.getHtmlLabelName(128313,user.getLanguage())%></option><!-- 差旅报销 -->
				    	<option value="2"><%=SystemEnv.getHtmlLabelName(128314,user.getLanguage())%></option><!-- 员工费用报销 -->
				    	<option value="3"><%=SystemEnv.getHtmlLabelName(128315,user.getLanguage())%></option><!-- 业务招待费报销 -->
				    	<option value="4"><%=SystemEnv.getHtmlLabelName(128316,user.getLanguage())%></option><!-- 个人、备用金借款申请 -->
				    	<option value="5"><%=SystemEnv.getHtmlLabelName(128317,user.getLanguage())%></option><!-- 个人、备用金还款申请 -->
				    	<option value="6"><%=SystemEnv.getHtmlLabelName(128318,user.getLanguage())%></option><!-- 对公费用报销 -->
				    	<option value="7"><%=SystemEnv.getHtmlLabelName(128319,user.getLanguage())%></option><!-- 费用分摊流程 -->
				    	<option value="8"><%=SystemEnv.getHtmlLabelName(128483,user.getLanguage())%></option><!-- 预算追加申请 -->
				    	<option value="9"><%=SystemEnv.getHtmlLabelName(128484,user.getLanguage())%></option><!-- 预算变更申请 -->
				    	<option value="10"><%=SystemEnv.getHtmlLabelName(128321,user.getLanguage())%></option><!-- 供应商预付款申请 -->
				    </select>
				</span>
				<span id="showFormSpan_fnaWfType2">
				    <select id="fnaWfType2" name="fnaWfType2" style="width: 200px;">
				    	<option value="0"><%=SystemEnv.getHtmlLabelName(128374,user.getLanguage())%></option><!-- 事前申请流程 -->
				    	<option value="1"><%=SystemEnv.getHtmlLabelName(128376,user.getLanguage())%></option><!-- 有事前申请-报销流程 -->
				    	<option value="2"><%=SystemEnv.getHtmlLabelName(128375,user.getLanguage())%></option><!-- 无事前申请-报销流程 -->
				    </select>
				</span>
		    </span>
			<%
				String bname = "";
				if("prjwf".equalsIgnoreCase(from)){
					if(Util.getIntValue(prjwfformid,0)!=0){
						formid=Util.getIntValue(prjwfformid);
						isbill="1";
					}
				}
				if(isbill.equals("1")) {
					RecordSet.executeSql("select * from workflow_bill where id="+formid);
					if(RecordSet.next()){
						int tmplable = RecordSet.getInt("namelabel");
						bname = SystemEnv.getHtmlLabelName(tmplable,user.getLanguage());
					}
				}else{
					bname=FormComInfo.getFormname(""+formid);
				}
			%>
			<span id="showFormSpan" <%if(!isbill.equals("0") && !isbill.equals("1")){%> style="display:none;" <%}%>>
			<brow:browser name="formid" viewType="0" hasBrowser="true" hasAdd="true"  addUrl="/workflow/form/addDefineForm.jsp?dialog=1&ajax=1&isformadd=1"
						  getBrowserUrlFn="onShowFormSelect" isMustInput="2" isSingle="true" hasInput="true"
						  getBrowserUrlFnParams="" _callback="formSelectCallback"
						  completeUrl="javascript:getformajaxurl()"  width="300px" browserValue='<%=String.valueOf(formid)%>' browserSpanValue='<%=bname%>' />
			</span>
		</wea:item>
		<%if(!isTemplate.equals("1")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(31485,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="isvalid" name="isvalid" <%=isvalidStr%>  onchange="if(this.value==2&&jQuery('select[name=isbill]').val()==1)window.top.Dialog.alert('系统表单不支持测试功能');">
				<%
					if(!isvalid.equals("3")) {
				%>
				<option value="0" <% if(!isvalid.equals("1")&&!isvalid.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
				<option value="1" <% if(isvalid.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
				<option value="2" <% if(isvalid.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%></option>
				<%
				} else {

				%>
				<option value="3" <% if(isvalid.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18500,user.getLanguage())%></option>
				<%}%>
			</select>
			<input type="hidden" id="oldisvalid" name="oldisvalid" value="<%=isvalid%>">
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="helpdocid" viewType="0" hasBrowser="true" hasAdd="false"
						  browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
						  completeUrl="/data.jsp?type=9"  linkUrl="/docs/docs/DocDsp.jsp" width="300px" browserValue='<%=String.valueOf(helpdocid)%>' browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(""+helpdocid),user.getLanguage())%>' />
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input class="InputStyle" onkeypress="ItemNum_KeyPress()" onblur="checknumber1(this)" style="width:80px!important;" maxLength="8" size="10" name="dsporder" value="<%=dsporder%>"/>
		</wea:item>

		<%
			}
		%>
	</wea:group>
</wea:layout>