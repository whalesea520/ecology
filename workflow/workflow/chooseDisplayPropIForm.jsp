
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

    <%
        int fieldId = Util.getIntValue(request.getParameter("fieldId"),-1);
		int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
		User user = HrmUserVarify.getUser (request , response) ;
		String isIE = (String)session.getAttribute("browser_isie");
		if (isIE == null || "".equals(isIE)) {
			isIE = "true";
			session.setAttribute("browser_isie", "true");
		}
        String formID = WorkflowComInfo.getFormId(""+workflowId);
        String isbill = WorkflowComInfo.getIsBill(""+workflowId);
		if(!"1".equals(isbill)){
			RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
			if(RecordSet.next()){
				formID = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}
		
        Map docPropIdMap=new HashMap();
		String tempSelectItemId=null;
		String tempDocPropId=null;
		RecordSet.executeSql("SELECT id,selectItemId FROM Workflow_DocProp where workflowId="+workflowId);
		while(RecordSet.next()){
			tempSelectItemId=Util.null2String(RecordSet.getString("selectItemId"));
			tempDocPropId=Util.null2String(RecordSet.getString("id"));
			if(!(tempSelectItemId.trim().equals(""))){
				docPropIdMap.put(tempSelectItemId,tempDocPropId);
			}
		}
	%>
	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'20%,50%,30%'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("19360",user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%></wea:item>
			<%	
				RecordSet.executeSql("select ID,isAccordToSubCom, selectValue, selectName, docPath, docCategory from workflow_SelectItem where fieldid = " + fieldId + " and isBill = "+isbill+" and (cancel is null or cancel<>'1') order by listOrder asc ");
				 int i=0;
				 while(RecordSet.next()){
				 	String docCategory = Util.null2String(RecordSet.getString("docCategory"));
				 	String selectValue = RecordSet.getString("selectValue");
				 	String isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));
				 	String docPath = "";
				 	String innerMainCategory = "";
		            String innerSubCategory = "";            
		            String innerSecCategory = "";
				 	if(!docCategory.equals("")){
				 		List nameList = Util.TokenizerString(docCategory, ",");
            			try{
			            	innerMainCategory = (String)nameList.get(0);
			            	innerSubCategory = (String)nameList.get(1);            	
			                innerSecCategory = (String)nameList.get(2);
			                docPath = secCategoryComInfo.getAllParentName(innerSecCategory,true);
			                //docPath = "/" + mainCategoryComInfo.getMainCategoryname(innerMainCategory) + "/" + subCategoryComInfo.getSubCategoryname(innerSubCategory) + "/" + secCategoryComInfo.getSecCategoryname(innerSecCategory);
            			}catch(Exception e){
            				docPath = secCategoryComInfo.getAllParentName(docCategory,true);
            			}
				 	}
				 	int docPropId=Util.getIntValue((String)docPropIdMap.get(selectValue),-1);
				 	
			%>
					<wea:item>
						<%=Util.null2String(RecordSet.getString("selectName"))%>
					</wea:item>
					<wea:item>
						<%if("1".equals(isAccordToSubCom)){%>
							<A HREF="#"  onClick="onShowSubcompanyShowAttr(<%=workflowId%>,<%=formID%>,<%=isbill%>,<%=fieldId%>,<%=selectValue%>)"><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%></A>
						<%}else{ %>
							<%= docPath %>
						<%} %>
					</wea:item>
					<wea:item>
						<%if(!"1".equals(isAccordToSubCom) && !"".equals(docPath) && null != docPath && !"".equals(docCategory) && null != docCategory){ %>
							<a href="javascript:setPropMulti(<%=docPropId%>,<%=RecordSet.getString("id") %>,<%=RecordSet.getString("selectValue") %>,<%=innerSecCategory %>,'<%=docCategory %>',<%=i %>);"><%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%></a>
						<%} %>
						
					</wea:item>
			<%	 
					i++;	
				 }                    
		    %>
		</wea:group>
	</wea:layout>
	
