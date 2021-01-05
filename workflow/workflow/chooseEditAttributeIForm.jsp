
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
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("28052",user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33338",user.getLanguage())%></wea:item>
			<%	
				RecordSet.executeSql("select ID, selectValue, selectName, docPath, docCategory,isAccordToSubCom from workflow_SelectItem where fieldid = " + fieldId + " and isBill = "+isbill+" and (cancel is null or cancel<>'1') order by listOrder asc ");
				 int i=0;
				 while(RecordSet.next()){
				 	String docCategory = Util.null2String(RecordSet.getString("docCategory"));
					String isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));
				 	String secCategory = "-1";
				 	if(!docCategory.equals("")){
				 		try{
				 			secCategory = docCategory.split(",")[2];
				 		}catch(Exception e){}
				 	}
				 	
				 	String sql = "select 1 from workflow_mould where mouldType=4 and workflowid = "+workflowId;
					rs.executeSql(sql);
					if(!rs.next()){
						//将该子目录关联的文档插入到中间表中
						rs.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory);
						if(rs.next()){
							rs.beforFirst();
							while(rs.next()){
								//rs.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+rs.getString("ID")+",4,1,"+secCategory+")");
							}
						}else{
							rs.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
							while(rs.next()){
								//rs.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+rs.getString("ID")+",4,1,"+secCategory+")");
							}
						}
					}
					sql = "SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and mouldType=0 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory;
					rs.executeSql(sql);
					if(rs.next()){
						rs.beforFirst();
					}else{
						rs.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and mouldType=4 and seccategory="+secCategory+" and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
					}
					String mouldIds = "";
					String mouldNames = "";
					while(rs.next()){
						if(mouldIds.equals("")){
							mouldIds = Util.null2String(rs.getString("id"));
							mouldNames = Util.null2String(rs.getString("mouldName"));
						}else{
							mouldIds = mouldIds+","+ Util.null2String(rs.getString("id"));
							mouldNames = mouldNames+","+Util.null2String(rs.getString("mouldName"));
						}
					}
					String completeUrl="/data.jsp?type=-99996&mouldType=3&isWorkflowDoc=1"; 
					String browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/mould/DocMouldMutiBrowser.jsp?mouldType=3&isWorkflowDoc=1&selectids=";
					String addUrl = "/docs/tabs/DocCommonTab.jsp?_fromURL=24&isdialog=1&isWorkflowDoc=1";	
			%>
					<wea:item>
						<%=Util.null2String(RecordSet.getString("selectName"))%>
						<input type="hidden" id="seccategory_<%=i %>" name="seccategory_<%=i %>" value="<%=secCategory %>"/>
					</wea:item>
					<wea:item>
					<%if("1".equals(isAccordToSubCom)){%>
					<%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>
						<%}else{
						%>
						<span>
							<brow:browser viewType="0" index='<%=""+i %>' name="multimouldids" browserValue='<%=mouldIds %>' 
				                browserUrl='<%=browserUrl %>'
				                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
				                language='<%=""+user.getLanguage() %>'
				                hasAdd='<%=isIE %>' addUrl='<%=addUrl %>'
								dialogWidth="1100px" 
								dialogHeight="1000px" 
				                completeUrl='<%=completeUrl %>'  temptitle='<%= SystemEnv.getHtmlLabelName(28052,user.getLanguage())%>'
				                browserSpanValue='<%=mouldNames %>' width="80%">
				        </brow:browser>
						</span>
							<%
						
						}%>
					</wea:item>
					<wea:item>
					<%if("1".equals(isAccordToSubCom)){%>
							
						<%}else{
						%>
						<a href="javascript:setMouldBookMarkEditMulti(1,<%=Util.null2String(RecordSet.getString("selectValue"))%>,<%=secCategory %>,<%=i %>);"><%=SystemEnv.getHtmlLabelNames("33338",user.getLanguage())%></a>
						<%
						
						}%>
					</wea:item>
			<%	 
					i++;	
				 }                    
		    %>
		</wea:group>
	</wea:layout>
	
