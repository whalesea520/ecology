<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
int secCategoryId = Util.getIntValue(request.getParameter("secCategoryId"),-1);
int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
int workflowId=Util.getIntValue(request.getParameter("wfid"),-1);
RecordSet.executeSql("select * from workflow_base where id = " + workflowId);
	RecordSet.next();
String formID = WorkflowComInfo.getFormId(""+workflowId);
String isbill = WorkflowComInfo.getIsBill(""+workflowId);
  if("".equals(formID)){
    	formID = RecordSet.getString("formid");	
    }
    
    if("".equals(isbill)){
    	isbill = RecordSet.getString("isbill");	
    }
if(!"1".equals(isbill)){
	isbill="0";
}
     List formDictIDList = new ArrayList();
     List formDictLabelList = new ArrayList();
String SQL = null;
if("1".equals(isbill)){
	SQL = "select formField.id,fieldLable.labelName as fieldLable "
                  + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                  + "where fieldLable.indexId=formField.fieldLabel "
                  + "  and formField.billId= " + formID
                  + "  and formField.viewType=0 "
                  + "  and fieldLable.languageid =" + user.getLanguage()
                  + "  order by formField.dspOrder  asc ";
}else{			
	SQL = "select formDict.ID, fieldLable.fieldLable "
                  + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                  + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                  + "and formField.formid = " + formID
                  + "and fieldLable.langurageid = " + user.getLanguage()
                  + " order by formField.fieldorder";
}                      
     RecordSet.executeSql(SQL);
     
     while(RecordSet.next()){
         formDictIDList.add(RecordSet.getString("ID"));
         formDictLabelList.add(RecordSet.getString("fieldLable"));
     }  
     int i=0; 
%>
<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'30%,70%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21570,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></wea:item>
		<%
		   List docPropertyTypeExceptList=new ArrayList();
		   docPropertyTypeExceptList.add("6");  
		   docPropertyTypeExceptList.add("7"); 
		   docPropertyTypeExceptList.add("8");  
		   docPropertyTypeExceptList.add("10"); 
		docPropertyTypeExceptList.add("11"); 
		   docPropertyTypeExceptList.add("13"); 
		docPropertyTypeExceptList.add("14"); 
		docPropertyTypeExceptList.add("15"); 
 docPropertyTypeExceptList.add("16"); 
 docPropertyTypeExceptList.add("17"); 
docPropertyTypeExceptList.add("18"); 
docPropertyTypeExceptList.add("20"); 

		   docPropertyTypeExceptList.add("24");
			int docPropDetailId=-1;
			   int docPropFieldId=-1;
			int workflowFieldId=-1;
			
			int labelId = 0;
			String customName = null;
			int isCustom = 0;
			String docPropertyType=null;
			String docPropFieldName = null;
		
		    SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secCategoryId);
			StringBuffer sb=new StringBuffer();
			sb.append(" select a.id as docPropFieldId,a.labelId,a.customName,a.isCustom,a.type as docPropertyType,b.id as docPropDetailId,b.workflowFieldId ")
			  .append("   from DocSecCategoryDocProperty a left join (select * from WorkflowToDocPropDetail where docPropId=").append(docPropId).append(")b on a.id=b.docPropFieldId ")
			  .append("  where a.secCategoryId =").append(secCategoryId)
			  .append("  order by a.viewindex asc ");
		    RecordSet.executeSql(sb.toString());
			
		             while(RecordSet.next()&&secCategoryId>0){
		                 docPropDetailId = Util.getIntValue(RecordSet.getString("docPropDetailId"),-1);
		                 docPropFieldId = Util.getIntValue(RecordSet.getString("docPropFieldId"),-1);
		                 workflowFieldId = Util.getIntValue(RecordSet.getString("workflowFieldId"),-1);
		
		                 labelId = RecordSet.getInt("labelid");
		                 customName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(""+docPropFieldId,user.getLanguage()));
						
		                 isCustom = RecordSet.getInt("isCustom");
		                 if(isCustom==1){
		                 	docPropFieldName = customName;
		                 }else{
		                 	if(customName!=null&&!"".equals(customName)){
		                 		docPropFieldName = customName;
		                 	}else{
		                 		docPropFieldName = SystemEnv.getHtmlLabelName(labelId, user.getLanguage());
				}
			}
		    docPropertyType = Util.null2String(RecordSet.getString("docPropertyType"));
			if(docPropertyTypeExceptList.indexOf(docPropertyType)>=0){
				continue;
			}
		
		    %>
		    	<wea:item>
		    		<INPUT TYPE="hidden" NAME="docPropDetailId_<%= i %>" VALUE="<%= docPropDetailId %>">
			<INPUT TYPE="hidden" NAME="docPropFieldId_<%= i %>" VALUE="<%= docPropFieldId %>">
		    		<%=docPropFieldName%>
		    	</wea:item>
				<wea:item>
		    		<select class=inputstyle name="workflowFieldId_<%= i %>">
		            	<option value=-1></option>
						<option value=-3  <%if ("-3".equals(""+workflowFieldId)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>			
				<%
				for(int j = 0; j < formDictIDList.size(); j++){
				%>                   
		        <option value=<%= (String)formDictIDList.get(j) %>  <% if(((String)formDictIDList.get(j)).equals(""+workflowFieldId)) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></option>
				<%}%>                         
		        </select>
		    </wea:item>
		<%
		    i++;
		}
		%>
	</wea:group>
</wea:layout>   	
<INPUT TYPE="hidden" NAME="rowNum" id="rowNum" VALUE="<%=i %>">
