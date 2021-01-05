<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>
<%@page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%

    String ajax=Util.null2String(request.getParameter("ajax"));
	User user = HrmUserVarify.getUser (request , response) ;


    int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
    int docPropId_Trace=Util.getIntValue(request.getParameter("docPropId_Trace"),-1);
    String pathCategory = Util.null2String(request.getParameter("pathCategory"));
    int secCategoryId=Util.getIntValue(request.getParameter("secCategoryId"),-1);

        String formID = request.getParameter("formID");
		if(formID==null||formID.trim().equals("")){
			formID=WorkflowComInfo.getFormId(""+workflowId);
		}

        String isbill = WorkflowComInfo.getIsBill(""+workflowId);
		if(formID==null||formID.trim().equals("")||isbill==null||isbill.trim().equals("")){
			RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
			if(RecordSet.next()){
				formID = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}

		if(!"1".equals(isbill)){
			isbill="0";
		}

        if(docPropId_Trace<=0){
		    RecordSet.executeSql("select id from  TraceProp where workflowId="+workflowId);
		    if(RecordSet.next()){
			    docPropId_Trace=Util.getIntValue(RecordSet.getString("id"),0);
		    }
		}
        /*================ 下拉框信息 ================*/
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

	int i = 0;              
%>

<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTableProp_Trace','cols':'2','cws':'40%,60%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21570,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></wea:item>
				<%
				List docPropertyTypeExceptList=new ArrayList();//某些文档属性不能通过流程属性获得。
				docPropertyTypeExceptList.add("6");  //6 主目录
				docPropertyTypeExceptList.add("7");  //7 分目录
				docPropertyTypeExceptList.add("8");  //8 子目录
				docPropertyTypeExceptList.add("10"); //10 模版
				docPropertyTypeExceptList.add("11"); //11 语言
				docPropertyTypeExceptList.add("13"); //13 创建
				docPropertyTypeExceptList.add("14"); //14 修改
				docPropertyTypeExceptList.add("15"); //15 批准
				docPropertyTypeExceptList.add("16"); //16 失效
				docPropertyTypeExceptList.add("17"); //17 归档
				docPropertyTypeExceptList.add("18"); //18 作废
				docPropertyTypeExceptList.add("20"); //20 被引用列表
				docPropertyTypeExceptList.add("24"); //24 虚拟目录
				
				int docPropDetailId_Trace=-1;
				int docPropFieldId_Trace=-1;
				int workflowFieldId_Trace=-1;
				
				int labelId = 0;
				String customName = null;
				int isCustom = 0;
				String docPropertyType=null;
				String docPropFieldName = null;
				
				SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secCategoryId);
				StringBuffer sb=new StringBuffer();
				sb.append(" select a.id as docPropFieldId,a.labelId,a.customName,a.isCustom,a.type as docPropertyType,b.id as docPropDetailId,b.workflowFieldId ")
				  .append("   from DocSecCategoryDocProperty a left join (select * from TracePropDetail where docPropId=").append(docPropId_Trace).append(")b on a.id=b.docPropFieldId ")
				  .append("  where a.secCategoryId =")
				  .append(secCategoryId)
				  .append("  order by a.viewindex asc ");
				RecordSet.executeSql(sb.toString());
				//System.out.println(sb.toString());
				while(RecordSet.next()){
					docPropDetailId_Trace = Util.getIntValue(RecordSet.getString("docPropDetailId"),-1);
					docPropFieldId_Trace = Util.getIntValue(RecordSet.getString("docPropFieldId"),-1);
					workflowFieldId_Trace = Util.getIntValue(RecordSet.getString("workflowFieldId"),-1);
				
					labelId = RecordSet.getInt("labelid");
					//customName = Util.null2String(RecordSet.getString("customname"));
					customName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(""+docPropFieldId_Trace,user.getLanguage()));
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
			    		<INPUT TYPE="hidden" id="docPropDetailId_Trace_<%= i %>" NAME="docPropDetailId_Trace_<%= i %>" VALUE="<%= docPropDetailId_Trace %>">
						<INPUT TYPE="hidden" id="docPropFieldId_Trace_<%= i %>" NAME="docPropFieldId_Trace_<%= i %>" VALUE="<%= docPropFieldId_Trace %>">
			    		<%=docPropFieldName%>
			    	</wea:item>
					<wea:item>
			   			<SELECT class=inputstyle name="workflowFieldId_Trace_<%= i %>">
			            	<OPTION value=-1></OPTION>
							<option value=-3  <%if ("-3".equals(""+workflowFieldId_Trace)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
			
							<%
							for(int j = 0; j < formDictIDList.size(); j++){
							%>                   
							   <OPTION value=<%= (String)formDictIDList.get(j) %>  <% if(((String)formDictIDList.get(j)).equals(""+workflowFieldId_Trace)) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></OPTION>
							<%}%>                         
			        	</SELECT>
			    	</wea:item>
			<%
			    i++;
			}
			%>
	</wea:group>
</wea:layout>
    <INPUT TYPE="hidden" id="rowNum_Trace" NAME="rowNum_Trace" VALUE="<%= i %>">           

