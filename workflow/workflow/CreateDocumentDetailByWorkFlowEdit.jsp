<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTwo" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19331,user.getLanguage()) + SystemEnv.getHtmlLabelName(19342,user.getLanguage());
    String needfav = "";
    String needhelp = "";
    String type = Util.null2String(request.getParameter("type"));
    String isclose = Util.null2String(request.getParameter("isclose"));
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/addwf_wev8.js"></script> 
        <script type="text/javascript">
        	var dialog = null;
			try{
				dialog = parent.parent.getDialog(parent);
			}catch(e){} 
			if("<%=isclose%>"=="1"){
				dialog.close();
			}
        </script>
    </HEAD>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="saveCreateDocumentDetail(this);" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveCreateDocumentDetail(this),_self}";
    RCMenuHeight += RCMenuHeightStep;      
    
   // RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelCreateDocumentDetail(this),_self}";
    //RCMenuHeight += RCMenuHeightStep;  
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	String flowID = request.getParameter("flowID");
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(flowID), 0, user, WfRightManager.OPERATION_CREATEDIR);
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;
    String mouldId = Util.null2String(request.getParameter("mouldId"));
    String seccategoryid = Util.null2String(request.getParameter("secCategoryID"));
    String secName = Util.null2String(secCategoryComInfo.getAllParentName(seccategoryid,true));

    if(1 == detachable)
    {  
        if(null == request.getParameter("subCompanyID"))
        {
            subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
        }
        else
        {
            subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
        }
        if(-1 == subCompanyID)
        {
            subCompanyID = user.getUserSubCompany1();
        }
        
        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));
        
        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }
    else
    {
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
        {
            operateLevel=2;
        }
    }
    
    if(operateLevel<=0 && haspermission){
    	operateLevel = 2;
    }     

    if(operateLevel > 0)
    {
        String selectItemID = request.getParameter("selectItemID");
        String pathCategory = request.getParameter("pathCategory");
        String secCategoryID = request.getParameter("secCategoryID");        
        String formID = request.getParameter("formID");
		String fromdefMould = Util.null2String(request.getParameter("fromdefMould")); 
                										        
		String parameterMouldID = request.getParameter("mouldID");

		if(!fromdefMould.equals("1")&&(parameterMouldID==null||"".equals(parameterMouldID))){
			
			RecordSet.executeSql("select docMouldId from workflow_docshowedit where flowId="+flowID+" and fieldid!=-1 and selectItemId="+selectItemID+"  and exists (select 1 from DocSecCategoryMould where mouldType in(4,8) and secCategoryId=workflow_docshowedit.secCategoryId and mouldId=workflow_docshowedit.docMouldId)   order by isDefault desc ,fieldId asc");
			if(RecordSet.next()){
				parameterMouldID = Util.null2String(RecordSet.getString("docMouldId"));
			}
		}

		

        String isbill = WorkflowComInfo.getIsBill(""+flowID);
		if(isbill==null||isbill.trim().equals("")){
			RecordSet.executeSql("select isbill from workflow_base where id="+flowID);
			if(RecordSet.next()){
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}
		if(!"1".equals(isbill)){
			isbill="0";
		}		
        /*================ 编辑信息 ================*/
        Map docMouldBookMarkMap = new Hashtable();
        Map docMouldDateShowTypeMap = new HashMap();
        String docMouldIDEdit = "-1";
        int tempFieldId=-1;
		String tempFieldHtmlType="";
		int tempType=-1;
		
        String editSQL = "SELECT docMouldID, modulId, fieldId,dateShowType FROM workflow_docshowedit WHERE flowId = " + flowID + " AND selectItemId = " + selectItemID;
        if(!"".equals(parameterMouldID) && null != parameterMouldID)
        //如果通过选择模版进入，则需要加上参数以确定 选择的模版 是否已经被设置过
        {
        	editSQL += " AND docMouldID = " + parameterMouldID;
        }
        RecordSet.executeSql(editSQL);

        while(RecordSet.next())
        {
        	docMouldIDEdit = String.valueOf(RecordSet.getInt("docMouldID"));

            //docMouldBookMarkMap.put(RecordSet.getString("modulId"), RecordSet.getString("fieldId"));
			tempFieldId=Util.getIntValue(RecordSet.getString("fieldId"),-1);
            //docMouldBookMarkMap.put(RecordSet.getString("modulId"), tempFieldId+"_"+FieldComInfo.getFieldhtmltype(""+tempFieldId)+"_"+FieldComInfo.getFieldType(""+tempFieldId));
			if(tempFieldId==-3){
				docMouldBookMarkMap.put(RecordSet.getString("modulId"), "-3_-1_-1");
			}else{
				if("1".equals(isbill)){
			        RecordSetTwo.executeSql("select fieldLabel,fieldHtmlType,type from workflow_billfield where id=" + tempFieldId);
			        if(RecordSetTwo.next()){
				        tempFieldHtmlType=Util.null2String(RecordSetTwo.getString("fieldHtmlType"));
				        tempType=Util.getIntValue(RecordSetTwo.getString("type"),0);
					    docMouldBookMarkMap.put(RecordSet.getString("modulId"), tempFieldId+"_"+tempFieldHtmlType+"_"+tempType);
			        }
				}else{
					docMouldBookMarkMap.put(RecordSet.getString("modulId"), tempFieldId+"_"+FieldComInfo.getFieldhtmltype(""+tempFieldId)+"_"+FieldComInfo.getFieldType(""+tempFieldId));
				}
			}
            docMouldDateShowTypeMap.put(RecordSet.getString("modulId"), Util.null2String(RecordSet.getString("dateShowType")));
        }

              
        /*================ 下拉框信息 ================*/
        List formDictIDList = new ArrayList();
        List formDictLabelList = new ArrayList();
		String SQL = null;
		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable,formField.fieldHtmlType,formField.type "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formID
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage()
                    + "  order by formField.dspOrder  asc ";
		}else{		
			SQL = "select formDict.ID, fieldLable.fieldLable,formDict.fieldHtmlType,formDict.type "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "  and formField.formid = " + formID
                    + "  and fieldLable.langurageid = " + user.getLanguage()
                    + " order by formField.fieldorder";
		}                    
        RecordSet.executeSql(SQL);
        
        while(RecordSet.next())
        {
            //formDictIDList.add(RecordSet.getString("ID"));
			tempFieldId=Util.getIntValue(RecordSet.getString("ID"),-1);
			tempFieldHtmlType=Util.null2String(RecordSet.getString("fieldHtmlType"));
	    	tempType=Util.getIntValue(RecordSet.getString("type"),0);
			//formDictIDList.add(tempFieldId+"_"+FieldComInfo.getFieldhtmltype(""+tempFieldId)+"_"+FieldComInfo.getFieldType(""+tempFieldId));
			formDictIDList.add(tempFieldId+"_"+tempFieldHtmlType+"_"+tempType);
            formDictLabelList.add(RecordSet.getString("fieldLable"));
        }   
        
	int i = 0;  
	String docMouldID = "-1";
	String docMouldName = "";		
	String finalDocMouldID = "-1";  //在“文档数据设置”需要显示的文档模版ID		           
%>	
<FORM name="createDocumentDetailByWorkFlow" method="post" action="CreateDocumentDetailByWorkFlowEditOperation.jsp" >
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19853,user.getLanguage())%>'>
		<%if(!type.equals("0")){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(19368,user.getLanguage())%></wea:item>
			<wea:item><%= secName %></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(28052,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=inputstyle id="docMouldID" name="docMouldID" onchange="changeBookMark(this.value)">
					<option value="-1"></option>
				<%
					RecordSet.executeSql("select * from DocMouldFile where id in ( " + mouldId+")");
					while(RecordSet.next()){
				    	docMouldID = RecordSet.getString("ID");										            
				    	docMouldName = RecordSet.getString("mouldName");
				  %>
					<option value="<%= docMouldID %>" <% if(!"".equals(parameterMouldID) && null != parameterMouldID) { if(docMouldID.equals(parameterMouldID)) { finalDocMouldID = parameterMouldID; %> selected <% }} else if (!"-1".equals(docMouldIDEdit)) { if(docMouldID.equals(docMouldIDEdit)) { finalDocMouldID = docMouldIDEdit; %> selected <% }} %>><%= docMouldName %></option>
				<%
				    }			    
				%>
				</select>		
			</wea:item>
		<%}else{ 
			RecordSet.executeSql("SELECT mouldName FROM DocMouldFile WHERE id = " + mouldId);
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(28052,user.getLanguage())%></wea:item>
			<wea:item>
				<%= RecordSet.next()?Util.null2String(RecordSet.getString("mouldName")):"" %>
				<INPUT TYPE="hidden" id="docMouldID" NAME="docMouldID" VALUE="<%= mouldId %>">
			</wea:item>
		<%} %>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33338,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<%if(type.equals("0")){ %>
	        	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTable','cols':'3','cws':'35%,35%,30%'}">
	        		<wea:group context="" attributes="{'groupDisplay':'none'}">
	                    <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("28052,26364",user.getLanguage())%></wea:item>
	                    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></wea:item>
	                    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21271,user.getLanguage())%></wea:item>
	                <%
	                	if(!type.equals("0")){
							RecordSet.executeSql("SELECT ID, name FROM mouldBookMarkEdit WHERE mouldID = " + finalDocMouldID+" order by showOrder asc,id asc");
						}else{
							RecordSet.executeSql("SELECT ID, name FROM mouldBookMarkEdit WHERE mouldID = " + mouldId+" order by showOrder asc,id asc");
						}
						
						while(RecordSet.next()){
	                    	String bookMarkID = RecordSet.getString("ID");
	                %>
	                	<wea:item><input type="hidden" name="bookMarkID<%= i %>" value='<%= bookMarkID %>'><%=RecordSet.getString("name")%></wea:item>
	                    <wea:item>
	                    	<select class=inputstyle name="documentConfig<%= i %>" id="documentConfig_<%=i%>" onChange='changeDateShowType(this)'>
	                        	<option value=-1_-1_-1></option>
								<option value=-3_-1_-1  <%if ("-3_-1_-1".equals((String)(docMouldBookMarkMap.get(bookMarkID)))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
	                		<%
	                		for(int j = 0; j < formDictIDList.size(); j++){
	                		%>                   
	                        	<option value=<%= (String)formDictIDList.get(j) %>  <% if(((String)formDictIDList.get(j)).equals((String)(docMouldBookMarkMap.get(bookMarkID)))) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></option>
	               			<%}%>                         
	                        </select>
	                      </wea:item>
	                      <wea:item>
							<%
							String divStyle="display:none";
							if((Util.null2String((String)(docMouldBookMarkMap.get(bookMarkID)))).endsWith("_3_2")){
								divStyle="display:''";
							}
							String tempDateShowType=Util.null2String((String)(docMouldDateShowTypeMap.get(bookMarkID)));
							%>
								<div id='divDateShowType_<%=i%>' style="<%=divStyle%>">
	                            	<SELECT class=inputstyle name="dateShowType<%=i%>">
	                                	<OPTION value=0></OPTION>
									    <OPTION value=1 <%if(tempDateShowType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21263,user.getLanguage())%></OPTION>
									    <OPTION value=2 <%if(tempDateShowType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21264,user.getLanguage())%></OPTION>
	                                </SELECT>
								<div>
	                        </wea:item>
	                    <%
	                    	i++;
	                    }
	                    %>
				</wea:group>
				</wea:layout> 
			<%}else{ %>
				<div id="mouldBookMark"></div>
			<%} %> 			
		</wea:item>
	</wea:group>
</wea:layout>    
<INPUT TYPE="hidden" NAME="flowID" VALUE="<%= flowID %>">
<INPUT TYPE="hidden" NAME="selectItemID" VALUE="<%= selectItemID %>">
<INPUT TYPE="hidden" NAME="count" id="count" VALUE="<%= i %>">
<INPUT TYPE="hidden" NAME="formID" VALUE="<%= formID %>">
<INPUT TYPE="hidden" NAME="isbill" VALUE="<%= isbill %>">
<INPUT TYPE="hidden" NAME="secCategoryID" VALUE="<%= secCategoryID %>">
<INPUT TYPE="hidden" NAME="isdialog" VALUE="<%= type.equals("")?"":"1" %>">
            
</FORM>
<script type="text/javascript">

jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});
function saveCreateDocumentDetail(obj)
{
	createDocumentDetailByWorkFlow.submit();	
	obj.disabled=true;
}

function changeBookMark(value){
	jQuery.ajax({
		url:"/workflow/workflow/chooseEditBookMarkForm.jsp?selectItemID=<%=selectItemID%>&formID=<%=formID%>&flowID=<%=flowID%>&mouldId="+value,
		type:"post",
		dataType:"html",
		success:function(data){
			jQuery("#mouldBookMark").html(data);
			initLayoutForCss();
			jQuery("#count").val(jQuery("#oTable").find("tbody tr[class!='Spacing']").length);
			beautySelect();
		}
	});
}

function cancelCreateDocumentDetail(obj)
{
	window.location = "/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=<%=flowID%>&formid=<%=formID%>&isbill=<%=isbill%>";
}
</script>
<%
    }
    else
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			if(jQuery("#docMouldID").val()!=-1){
				changeBookMark(jQuery("#docMouldID").val());
			}
		});
	</script>
</BODY>
</HTML>
