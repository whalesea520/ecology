
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>
<%@page import="java.util.*" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
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
    int objId=Util.getIntValue(request.getParameter("objId"),-1);
    String objType=Util.null2String(request.getParameter("objType"));
    if(objType.equals("")){
	    objType="0";
    }
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
	int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowId+"subcompanyid")),-1);
	int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");    
    if(operateLevel > 0){
       
        int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
        int selectItemId=Util.getIntValue(request.getParameter("selectItemId"),-1);
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

		if(pathCategory.equals("")){
			String innerSecCategory = String.valueOf(secCategoryId);
			//String innerSubCategory = SecCategoryComInfo.getSubCategoryid(innerSecCategory);
			//String innerMainCategory = SubCategoryComInfo.getMainCategoryid(innerSubCategory);

			pathCategory = SecCategoryComInfo.getAllParentName(innerSecCategory,true);
		   //  pathCategory = "/" + MainCategoryComInfo.getMainCategoryname(innerMainCategory) + "/" + SubCategoryComInfo.getSubCategoryname(innerSubCategory) + "/" + SecCategoryComInfo.getSecCategoryname(innerSecCategory);     
		}

        if(docPropId<=0){
		    RecordSet.executeSql("select id from  Workflow_DocProp where workflowId="+workflowId+" and selectItemId="+selectItemId+" and secCategoryid="+secCategoryId+" and objId="+objId+" and objType="+objType);
		    if(RecordSet.next()){
			    docPropId=Util.getIntValue(RecordSet.getString("id"),0);
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

<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTableProp','cols':'2','cws':'40%,60%'}">
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
				
				int docPropDetailId=-1;
				int docPropFieldId=-1;
				int workflowFieldId=-1;
				
				int labelId = 0;
				String customName = null;
				int isCustom = 0;
				String docPropertyType=null;
				String docPropFieldName = null;
				//如果文档存放目录不为空则执行
			    if(secCategoryId >= 1){
				SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secCategoryId);
				StringBuffer sb=new StringBuffer();
				sb.append(" select a.id as docPropFieldId,a.labelId,a.customName,a.isCustom,a.type as docPropertyType,b.id as docPropDetailId,b.workflowFieldId ")
				  .append("   from DocSecCategoryDocProperty a left join (select * from Workflow_DocPropDetail where docPropId=").append(docPropId).append(")b on a.id=b.docPropFieldId ")
				  .append("  where a.secCategoryId =")
				  .append(secCategoryId)
				  .append("  order by a.viewindex asc ");
				RecordSet.executeSql(sb.toString());
				//System.out.println(sb.toString());
				while(RecordSet.next()){
					docPropDetailId = Util.getIntValue(RecordSet.getString("docPropDetailId"),-1);
					docPropFieldId = Util.getIntValue(RecordSet.getString("docPropFieldId"),-1);
					workflowFieldId = Util.getIntValue(RecordSet.getString("workflowFieldId"),-1);
				
					labelId = RecordSet.getInt("labelid");
					//customName = Util.null2String(RecordSet.getString("customname"));
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
			    		<INPUT TYPE="hidden" id="docPropDetailId_<%= i %>" NAME="docPropDetailId_<%= i %>" VALUE="<%= docPropDetailId %>">
						<INPUT TYPE="hidden" id="docPropFieldId_<%= i %>" NAME="docPropFieldId_<%= i %>" VALUE="<%= docPropFieldId %>">
			    		<%=docPropFieldName%>
			    	</wea:item>
					<wea:item>
			   			<SELECT class=inputstyle name="workflowFieldId_<%= i %>">
			            	<OPTION value=-1></OPTION>
							<option value=-3  <%if ("-3".equals(""+workflowFieldId)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
			
							<%
							for(int j = 0; j < formDictIDList.size(); j++){
							%>                   
							   <OPTION value=<%= (String)formDictIDList.get(j) %>  <% if(((String)formDictIDList.get(j)).equals(""+workflowFieldId)) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></OPTION>
							<%}%>                         
			        	</SELECT>
			    	</wea:item>
			<%
			    i++;
			}
				}
			%>
	</wea:group>
</wea:layout>
    <INPUT TYPE="hidden" id="docPropId" NAME="docPropId" VALUE="<%= docPropId %>">    
    <INPUT TYPE="hidden" id="workflowId" NAME="workflowId" VALUE="<%= workflowId %>">
    <INPUT TYPE="hidden" id="selectItemId" NAME="selectItemId" VALUE="<%= selectItemId %>">
    <INPUT TYPE="hidden" id="secCategoryId" NAME="secCategoryId" VALUE="<%= secCategoryId %>">
    <INPUT TYPE="hidden" id="objId" NAME="objId" VALUE="<%= objId %>">
    <INPUT TYPE="hidden" id="objType" NAME="objType" VALUE="<%= objType %>">
    <INPUT TYPE="hidden" id="ajax" NAME="ajax" VALUE="<%= ajax %>">
    <INPUT TYPE="hidden" id="rowNum" NAME="rowNum" VALUE="<%= i %>">           
<%
}
%>
