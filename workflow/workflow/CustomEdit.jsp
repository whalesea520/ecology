<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />


<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />		
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
	</HEAD>
<%
	//String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
	//String needfav ="1";
	//String needhelp ="";
	String isclose = Util.null2String(request.getParameter("isclose"));
	String otype = Util.null2String(request.getParameter("otype"));
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.execute("select a.*,b.typename from workflow_custom a left join workflow_customQuerytype b on a.Querytypeid=b.id where a.id="+id);
	RecordSet.next();

	String formID = Util.null2String(RecordSet.getString("formID"));	
	String isBill = Util.null2String(RecordSet.getString("isBill"));
    String Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
    Customname = Customname.replaceAll("\"", "&quot;");
	String Querytypeid = Util.null2String(RecordSet.getString("Querytypeid"));
	Querytypeid = (Util.getIntValue(Querytypeid,0)<=0)?"":Querytypeid;
    String Querytypename = Util.null2String(RecordSet.getString("typename"));
	String workflowids = Util.null2String(RecordSet.getString("workflowids"));
    String Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
    Customdesc = Customdesc.replaceAll("\"", "&quot;");
    String subcompanyid=Util.null2String(RecordSet.getString("subcompanyid"));
    subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

	List reportWFList = new ArrayList();
	if(!"".equals(workflowids) && null != workflowids)
	{
		reportWFList = Util.TokenizerString(workflowids, ",");
	}
	String formName="";
	if("0".equals(isBill))
	{
	    formName = formComInfo.getFormname(formID);	    
	}
	else if("1".equals(isBill))
	{
	    formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
	}
	int operatelevel=Util.getIntValue(request.getParameter("operatelevel"),0);
	
	if(detachable==1)
	{
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowCustomManage:All", Util.getIntValue(subcompanyid,0));
	}
	if(!isclose.equals("1") && operatelevel < 0){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	
%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
			if(operatelevel>0)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				//if(operatelevel>1)
				//{
				//	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
				//	RCMenuHeight += RCMenuHeightStep;
				//}
			}
		%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">	
			<%if(operatelevel > 0){ %>
			<input id="btnSave" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()" />
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver name=frmMain action="CustomOperation.jsp" method=post>
<input type="hidden" name="otype" value="<%=otype%>" />
<%
    String outputWorkFlowName = "";
	for(int i = 0; i < reportWFList.size(); i++){
    	outputWorkFlowName += workflowComInfo.getWorkflowname((String)reportWFList.get(i))+",";
	}
    if(outputWorkFlowName.equals("")){
        outputWorkFlowName="<font color=red>"+SystemEnv.getHtmlLabelName(23801,user.getLanguage())+"</font>";
    }else{
        outputWorkFlowName=outputWorkFlowName.substring(0,outputWorkFlowName.length()-1);
    }
    int dbordercount = 0 ;
%>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="" required="true" value='<%=Customname%>'>
	    		<input type=text class=Inputstyle size=30 name="Customname" onchange='checkinput("Customname","Customnameimage")' value="<%=Customname%>">
	    	</wea:required>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></wea:item>
	    <wea:item>
  		<%if(operatelevel>0){ %>
  			<brow:browser name="Querytypeid" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/QueryTypeBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=queryTypeBrowser"  
 					linkUrl ="/workflow/workflow/CustomQueryTypeEdit.jsp" width="250px" browserValue='<%=Querytypeid%>' browserSpanValue='<%=Querytypename %>'/>
        <%}else{ %>
        	<span><%=Querytypename %></span>
        <%} %>	    
	    </wea:item>
	    <% if(detachable==1){ %>
	    <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
	    <wea:item>
	    <%if(operatelevel>0){ %>
			<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
							completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="250px" browserValue='<%=subcompanyid%>' browserSpanValue='<%="".equals(subcompanyid)?"":SubComanyComInfo.getSubCompanyname(subcompanyid) %>'/> 
		<%}else{ %>
			<span id=subcompanyspan>
		<% if(subcompanyid.equals("")){ %>
			<img src="/images/BacoError_wev8.gif" align=absMiddle>
		<%}else{
			out.print(SubComanyComInfo.getSubCompanyname(subcompanyid)); 
		}%>
			</span>
		<%} %>
	    </wea:item>
	    <%} %>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
	    <wea:item>
  			<%= formName %>
        	<input type=hidden name=formID id=formID value=<%=formID%>>
        	<input type=hidden name=isBill id=isBill value=<%=isBill%>>	    
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></wea:item>
	    <wea:item>
		<%if(operatelevel>0){ %>
			<brow:browser name="workflowids" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="onShowWorkFlow" getBrowserUrlFnParams="" isMustInput="1" isSingle="false" hasInput="true"
		       			completeUrl="javascript:getWfUrl();"  width="250px" browserValue='<%=workflowids%>' browserSpanValue='<%= outputWorkFlowName%>'/>                                     
		<%}else{ %>
			<%= outputWorkFlowName%>
		<%} %>	    
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
	    <wea:item><%if(operatelevel>0){ %><textarea rows="4" cols="80" name="Customdesc" class=Inputstyle style="resize:none;margin-bottom: 2px;margin-top: 2px;"><%=Customdesc%></textarea><%}else{ %><%=Customdesc%><%} %></wea:item>
    </wea:group>
<%--    <wea:group context='<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%>'>--%>
<%--    	<wea:item attributes="{'isTableList':'true'}">--%>
<%--		<TABLE class=ListStyle cellspacing=1  >--%>
<%--			<COLGROUP> --%>
<%--				<COL width="20%"> --%>
<%--				<COL width="20%"> --%>
<%--				<COL width="10%">--%>
<%--                <COL width="20%">--%>
<%--				<COL width="10%">--%>
<%--				<COL width="20%">--%>
<%--			</COLGROUP>--%>
<%--		  	<TBODY> 																		--%>
<%--		  	<TR class=header> --%>
<%--			    <TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>--%>
<%--			    <TD><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></TD>--%>
<%--                <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>--%>
<%--			    <TD><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></TD>--%>
<%--                <TD><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>--%>
<%--				<TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>--%>
<%--		  	</TR>--%>
<%--			<%--%>
<%--				String theid = "";--%>
<%--				String fieldname = "";--%>
<%--				String dsporder = "";--%>
<%--				String ifquery = "";--%>
<%--				String ifshow = "";--%>
<%--                String queryorder="";--%>
<%--				int i=0;--%>
<%--				--%>
<%--				RecordSet.executeSql("select * from Workflow_CustomDspField where customid = " + id + "  and fieldid>-10 and fieldid<0 order by showorder ");--%>
<%--				while(RecordSet.next()){--%>
<%--					theid = Util.null2String(RecordSet.getString("id")) ;--%>
<%--					if("-1".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(1334,user.getLanguage());--%>
<%--					}else if("-2".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(15534,user.getLanguage());--%>
<%--					}else if("-9".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(16354,user.getLanguage());--%>
<%--					}else if("-8".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(1335,user.getLanguage());--%>
<%--					}else if("-7".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(17994,user.getLanguage());--%>
<%--					}else if("-6".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(18564,user.getLanguage());--%>
<%--					}else if("-5".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(259,user.getLanguage());--%>
<%--					}else if("-4".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(882,user.getLanguage());--%>
<%--					}else if("-3".equals(RecordSet.getString("fieldid"))){--%>
<%--						fieldname = SystemEnv.getHtmlLabelName(722,user.getLanguage());--%>
<%--					}--%>
<%--									--%>
<%--					dsporder = Util.null2String(RecordSet.getString("showorder")) ;--%>
<%--					ifquery = Util.null2String(RecordSet.getString("ifquery")) ;--%>
<%--					ifshow = Util.null2String(RecordSet.getString("ifshow")) ;--%>
<%--					queryorder = Util.null2String(RecordSet.getString("queryorder")) ;--%>
<%--			--%>
<%--					if(i==0){--%>
<%--						i=1;--%>
<%--			%>--%>
<%--			<TR class=DataLight> 			    --%>
<%--			<%}else{--%>
<%--				i=0;--%>
<%--			%>--%>
<%--			<TR class=DataDark> --%>
<%--			<%}%>--%>
<%--			    <TD><%=fieldname%></TD>--%>
<%--				<TD ><%if(ifshow.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>--%>
<%--                <TD><%=dsporder%></TD>--%>
<%--			    <TD ><%if(ifquery.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>--%>
<%--			    <TD><%=queryorder%></TD>--%>
<%--			    <TD><%if(operatelevel>0){ %><a href="#" onclick="javascript:ondeletefield('CustomOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete_wev8.gif"></a><%} %></TD>--%>
<%--			</TR>--%>
<%--			<%}%>			--%>
<%--			<%			--%>
<%--				if("0".equals(isBill)){												--%>
<%--					RecordSet.execute("SELECT reportDspField.ID, fieldLable.fieldLable, reportDspField.showorder,reportDspField.ifshow, reportDspField.ifquery,reportDspField.queryorder  FROM Workflow_Custom report, WorkFlow_CustomDspField reportDspField, WorkFlow_FieldLable fieldLable WHERE report.ID = reportDspField.customid AND report.formID = fieldLable.formID AND reportDspField.fieldID = fieldLable.fieldID AND report.ID = " + id + " AND fieldLable.langurageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder ,reportDspField.id");--%>
<%--				}else if("1".equals(isBill)){												--%>
<%--					RecordSet.execute("SELECT reportDspField.ID, htmlLabelInfo.labelName, reportDspField.showorder,reportDspField.ifshow, reportDspField.ifquery,reportDspField.queryorder FROM WorkFlow_CustomDspField reportDspField, workflow_billfield billField, Workflow_Custom report, HtmlLabelInfo htmlLabelInfo WHERE report.ID = reportDspField.customid AND reportDspField.fieldID= billField.ID AND billField.fieldLabel = htmlLabelInfo.indexID AND report.ID = " + id + " AND htmlLabelInfo.languageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder,reportDspField.id");--%>
<%--				}--%>
<%--				--%>
<%--				while(RecordSet.next()){--%>
<%--					theid = Util.null2String(RecordSet.getString("ID")) ;--%>
<%--					fieldname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;--%>
<%--					dsporder = Util.null2String(RecordSet.getString("showorder")) ;--%>
<%--					ifquery = Util.null2String(RecordSet.getString("ifquery")) ;--%>
<%--					ifshow = Util.null2String(RecordSet.getString("ifshow")) ;--%>
<%--					queryorder = Util.null2String(RecordSet.getString("queryorder")) ;				--%>
<%--				--%>
<%--					if(i==0){--%>
<%--						i=1;--%>
<%--			%>--%>
<%--			<TR class=DataLight> --%>
<%--			<%}else{--%>
<%--				i=0;--%>
<%--			%>--%>
<%--			<TR class=DataDark> --%>
<%--			<%}%>--%>
<%--				<TD><%=fieldname%></TD>--%>
<%--			    <TD ><%if(ifshow.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>--%>
<%--                <TD><%=dsporder%></TD>--%>
<%--				<TD ><%if(ifquery.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>--%>
<%--			    <TD><%=queryorder%></TD>--%>
<%--			    <TD><a href="#" onclick="javascript:ondeletefield('CustomOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete_wev8.gif"></a></TD>--%>
<%--			</TR>--%>
<%--			<%}%>--%>
<%--			</TBODY>--%>
<%--		</TABLE>    		--%>
<%--    	</wea:item>--%>
<%--    </wea:group>--%>
</wea:layout>		
<input type="hidden" name=operation value=customedit>
<input type="hidden" name=id value=<%=id%>>
</FORM>						
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
	if("<%=isclose%>"==1){
		var dialog = parent.parent.getDialog(parent);
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location="/workflow/workflow/CustomQuerySet.jsp?otype=<%=otype%>";
		dialog.closeByHand();	
	}

	function onShowQuerytype(inputName,spanName){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/QueryTypeBrowser.jsp");
		if (datas){
			if (datas.id!=""){
				$(inputName).val(datas.id);
				$(spanName).html(datas.name);			
			}else{
				$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				$(inputName).val( "");
			}
		}
	}
	function onShowSubcompany(inputName,spanName){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1");
		if (datas){
			if (datas.id!=""){
				$(inputName).val(datas.id);
				$(spanName).html(datas.name);			
			}else{
				$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				$(inputName).val( "");
			}
		}
	}
	function onDelete(){
			if(isdel()) {
	            enableAllmenu();
	            document.frmMain.action="CustomOperation.jsp";
				document.frmMain.operation.value="customdelete";
				document.frmMain.submit();
			}
	}
	function ondeletefield(src){
	    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	        enableAllmenu();
	        document.frmMain.action=src;
			document.frmMain.submit();
	    }
	}

	function onShowSubcompany(){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids="+weaver.subcompanyid.value)
		var issame = false
		if (data){
			if (data.id!="0"){
				if (data.id == weaver.subcompanyid.value){
					issame = true
				}
				subcompanyspan.innerHTML = data.name
				weaver.subcompanyid.value=data.id
			}else{
				subcompanyspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
				weaver.subcompanyid.value=""
			}
		}
	}
	function WorkFlowBeforeShow(opts,e){
		isBill = document.all("isBill").value
		formID = document.all("formID").value
		workflowids = document.all("workflowids").value
		opts._url=opts._url+"?value="+isBill+"_"+formID+"_"+workflowids;
		}
	function submitData()
	{
		var checkfields = "";
		<%if(detachable==1){%>
	        checkfields = 'Customname,Querytypeid,formID,subcompanyid';
	    <%}else{%>
	    	checkfields = 'Customname,Querytypeid,formID';
	    <%}%>
		if (check_form(frmMain,checkfields)){
	        enableAllmenu();
			frmMain.submit();
	    }
	}

	function onShowWorkFlow(){
		var isBill = $G("isBill").value
		var formID = $G("formID").value
		var workflowids = $G("workflowids").value
		var url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp?value=" + isBill + "_" + formID + "_" + workflowids;
		return url;
	}
	
	function getWfUrl(){
	var isBill = $("#isBill").val();
	var formID = $("#formID").val();
	var url = "/data.jsp?type=reportform&formid="+formID+"&isbill="+isBill;
	return url;
}
</script>
</BODY></HTML>
