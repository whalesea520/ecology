
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>
<%@page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTwo" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String flowID = request.getParameter("flowID");
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(flowID), 0, user, WfRightManager.OPERATION_CREATEDIR);
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;
    String mouldId = Util.null2String(request.getParameter("mouldId"));

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
                										        
		String parameterMouldID = request.getParameter("mouldId");

		if(parameterMouldID==null||"".equals(parameterMouldID)){
			RecordSet.executeSql("select docMouldId from workflow_docshow where flowId="+flowID+" and fieldid!=-1 and selectItemId="+selectItemID+"  and exists (select 1 from DocSecCategoryMould where mouldType in(3,7) and secCategoryId=workflow_docshow.secCategoryId and mouldId=workflow_docshow.docMouldId)   order by isDefault desc ,fieldId asc");
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
		
        String editSQL = "SELECT docMouldID, modulId, fieldId,dateShowType FROM workflow_docshow WHERE flowId = " + flowID + " AND selectItemId = " + selectItemID;
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
     	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTable','cols':'3','cws':'35%,35%,30%'}">
     		<wea:group context="" attributes="{'groupDisplay':'none'}">
                 <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("25126,26364",user.getLanguage())%></wea:item>
                 <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></wea:item>
                 <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21271,user.getLanguage())%></wea:item>
             <%
			RecordSet.executeSql("SELECT ID, name FROM mouldBookMark WHERE mouldID = " + mouldId+" order by showOrder asc,id asc");
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
<input type="hidden" name="tempcount" id="tempcount" value="<%=i %>"/>
<%} %>
