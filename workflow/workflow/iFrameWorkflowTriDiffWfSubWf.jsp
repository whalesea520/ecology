
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />

<HTML>
    <HEAD>
    <%

int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),-1);
int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),-1);
String resourceName = Util.null2String(request.getParameter("resourceName"));
try{
resourceName = java.net.URLDecoder.decode(resourceName, "UTF-8");
}catch(Exception e){}
int superiorUnitId = Util.getIntValue(request.getParameter("superiorUnitId"),-1);
String receiveUnitName = Util.null2String(request.getParameter("receiveUnitName"));

		int mainWorkflowId=0;
		int fieldId=0;
        RecordSet.executeSql("select * from Workflow_TriDiffWfDiffField where id=" + triDiffWfDiffFieldId);
        if(RecordSet.next()){
			mainWorkflowId=Util.getIntValue(RecordSet.getString("mainWorkflowId"),0);
			fieldId=Util.getIntValue(RecordSet.getString("fieldId"),0);
		}
		String formId=WorkflowComInfo.getFormId(""+mainWorkflowId);
		String isBill=WorkflowComInfo.getIsBill(""+mainWorkflowId);
       //add by liaodong for qc61523 in 2013-11-12 start
		if("".equals(formId)|| "".equals(isBill)){
			RecordSet.executeSql("select formid,isbill from workflow_base where id=" + mainWorkflowId);
			  if(RecordSet.next()){
				  formId = RecordSet.getString("formid");
				  isBill = RecordSet.getString("isbill");
			  }
		}
		//end
		String fieldHtmlType="";
		int type=0;
		if("1".equals(isBill)){
			int fieldLabel=0;
			RecordSet.executeSql("select fieldLabel,fieldHtmlType,type from workflow_billfield where id=" + fieldId);
			if(RecordSet.next()){
				fieldHtmlType=Util.null2String(RecordSet.getString("fieldHtmlType"));
				type=Util.getIntValue(RecordSet.getString("type"),0);
			}
		}else{
			RecordSet.executeSql("select fieldLable from workflow_fieldlable where formId="+formId+" and fieldId="+fieldId+" and langurageId=" + user.getLanguage());
			fieldHtmlType=Util.null2String(FieldComInfo.getFieldhtmltype(""+fieldId));
			type=Util.getIntValue(FieldComInfo.getFieldType(""+fieldId),0);
		}

boolean useHrmResource=false;
boolean useDocReceiveUnit=false;

if(type==17||type==141||type==166){
	useHrmResource=true;
}else if(type==142){
	useDocReceiveUnit=true;
}

int triDiffWfSubWfId=0;
int subWorkflowId=0;
String subWorkflowName="";
int isRead=0;
int fieldValue=0;
String fieldValueName="";

Map triDiffWfSubWfIdMap=new HashMap();
Map subWorkflowIdMap=new HashMap();
Map isReadMap=new HashMap();

RecordSet.executeSql("select id,subWorkflowId,isRead,fieldValue from Workflow_TriDiffWfSubWf where triDiffWfDiffFieldId="+triDiffWfDiffFieldId+" and fieldValue>0");
while(RecordSet.next()){
	triDiffWfSubWfId=Util.getIntValue(RecordSet.getString("id"),0);
	subWorkflowId=Util.getIntValue(RecordSet.getString("subWorkflowId"),0);
	isRead=Util.getIntValue(RecordSet.getString("isRead"),0);
	fieldValue=Util.getIntValue(RecordSet.getString("fieldValue"),0);

    triDiffWfSubWfIdMap.put(""+fieldValue,""+triDiffWfSubWfId);
    subWorkflowIdMap.put(""+fieldValue,""+subWorkflowId);
    isReadMap.put(""+fieldValue,""+isRead);
}

boolean isOracle=RecordSet.getDBType().equals("oracle");

int perpage = 10;
RecordSet.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(RecordSet.next()){
	perpage     =Util.getIntValue(RecordSet.getString("dspperpage"),10); 
}

String sql = "";
String sqlAll ="";
String sqlwhere="";//TD35628

if(useHrmResource){

    if(subCompanyId>0){
		sqlwhere += " and subcompanyid1="+subCompanyId+" ";
    }

    if(departmentId>0){
		sqlwhere += " and departmentid="+departmentId+" ";
    }

    if(!resourceName.equals("")){
        if(resourceName.indexOf("_")>=0) resourceName = resourceName.replaceAll("_","\\\\_");
        if(resourceName.indexOf("%")>=0) resourceName = resourceName.replaceAll("%","\\\\%");
		sqlwhere+= "  and lastname like '%"+resourceName +"%' escape '\\' ";
    }

	if(isOracle){
		//sql =" (select * from (select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3) order by dsporder asc) where rownum<"+ (pagenum*perpage+1)+"    order by dsporder desc)s";
		sql =" (select * from (select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3) order by dspOrder asc,fieldValueName asc,fieldValue asc) where rownum<"+ (pagenum*perpage+1)+"    order by dspOrder desc,fieldValueName desc,fieldValue desc)s";
		sqlAll=" (select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3))s";
	}else{
		//sql = " (select top "+(pagenum*perpage+1)+" * from (select distinct top "+(pagenum*perpage+1)+" select id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) order by dsporder asc)as s order by dsporder desc) as t ";
		sql = " (select top "+(pagenum*perpage)+" * from (select distinct top "+(pagenum*perpage)+" id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) order by dspOrder asc,fieldValueName asc,fieldValue asc)as s order by dspOrder desc,fieldValueName desc,fieldValue desc) as t ";
		sqlAll=" (select  id as fieldValue,lastName as fieldValueName,dspOrder as dspOrder from HrmResource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) )as s  ";
	}
}else if(useDocReceiveUnit){
	sqlwhere=" and (canceled is null or canceled=0) ";//TD29443 lv 不显示封存收发文单位 TD35628
    if(superiorUnitId>0){
		sqlwhere += " and superiorUnitId="+superiorUnitId+" ";
    }

    if(!receiveUnitName.equals("")){
		sqlwhere+= "  and receiveUnitName like '%"+receiveUnitName +"%' ";
    }

	if(isOracle){
		//sql =" (select * from (select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere +"   order by dsporder asc) where rownum<"+ (pagenum*perpage+1)+"    order by dsporder desc)s";
		sql =" (select * from (select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere +"   order by dspOrder asc,fieldValueName asc,fieldValue asc) where rownum<"+ (pagenum*perpage+1)+"    order by dspOrder desc,fieldValueName desc,fieldValue desc)s";
		sqlAll="(select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere +")s";
	}else{
		//sql = " (select top "+(pagenum*perpage+1)+" * from (select distinct top "+(pagenum*perpage+1)+" select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere+"  order by dsporder asc)as s order by dsporder desc) as t ";
		sql = " (select top "+(pagenum*perpage)+" * from (select distinct top "+(pagenum*perpage)+" id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere+"  order by dspOrder asc,fieldValueName asc,fieldValue asc)as s order by dspOrder desc,fieldValueName desc,fieldValue desc) as t ";
		sqlAll=" (select id as fieldValue,receiveUnitName as fieldValueName,showOrder as dspOrder from DocReceiveUnit where 1=1 "+ sqlwhere+")as s";
	}
}

int RecordSetCountsAll = 0;
RecordSet.executeSql("Select count(fieldValue) RecordSetCounts from "+sqlAll);
if(RecordSet.next()){
	RecordSetCountsAll = RecordSet.getInt("RecordSetCounts");
}
boolean hasNextPage=false;
if(RecordSetCountsAll>pagenum*perpage){
	hasNextPage=true;
}

RecordSet.executeSql("Select count(fieldValue) RecordSetCounts from "+sql);

int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}


String sqltemp="";
//int topnum = (RecordSetCounts-(pagenum-1)*perpage-1);
int topnum = (RecordSetCounts-(pagenum-1)*perpage);
if(topnum<0){
	topnum = 0;
}
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+sql+") where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  order by dspOrder asc,fieldValueName asc,fieldValue asc";
}else{
	//sqltemp=" select top "+topnum+" * from ( select top "+(RecordSetCounts-(pagenum-1)*perpage+1)+" * from "+sql+") as m  order by dspOrder asc,fieldValueName asc,fieldValue asc";
	sqltemp=" select top "+topnum+" * from ( select top "+topnum+" * from "+sql+") as m  order by dspOrder asc,fieldValueName asc,fieldValue asc";
}

RecordSet.executeSql(sqltemp);      

%>
    </HEAD>
<BODY>

</BODY>
</HTML>

<SCRIPT language="javascript">
    deleteTable();
    addTable();

    function deleteTable(){
        var oTable=window.parent.document.all("chooseSubWorkflow");

        var len = oTable.rows.length * 1;

        var i = 0;
        
        for(i = len - 1; i >= 1; i--) 
        {
            oTable.deleteRow(i);
        }
    }
    
    function addTable()
    {
        var oTable=window.parent.document.all('chooseSubWorkflow');
<% 
int rowNum=0;	
while(RecordSet.next()){
 	fieldValue=Util.getIntValue(RecordSet.getString("fieldValue"),0);
	fieldValueName=Util.null2String(RecordSet.getString("fieldValueName"));

	triDiffWfSubWfId=Util.getIntValue((String)triDiffWfSubWfIdMap.get(""+fieldValue),0);
	subWorkflowId=Util.getIntValue((String)subWorkflowIdMap.get(""+fieldValue),0);
	isRead=Util.getIntValue((String)isReadMap.get(""+fieldValue),0);

	subWorkflowName=WorkflowComInfo.getWorkflowname(""+subWorkflowId);
        
%>
            var oRow = oTable.insertRow();
            var oRowIndex = oRow.rowIndex;

            if (0 == oRowIndex % 2)
            {
                oRow.className = "dataLight";
            }
            else
            {
                oRow.className = "dataDark";
            }
    
            //可区分字段值
            oCell = oRow.insertCell();
            oDiv = window.parent.document.createElement("div");        
            oDiv.innerHTML="<%=fieldValueName%><INPUT type=hidden name=triDiffWfSubWfId_<%=rowNum%>  id=\"triDiffWfSubWfId_<%=rowNum%>\" value=\"<%=triDiffWfSubWfId%>\"><INPUT type=hidden name=fieldValue_<%=rowNum%>  id=\"fieldValue_<%=rowNum%>\" value=\"<%=fieldValue%>\">";                    
            oCell.appendChild(oDiv);
            
            //子流程
            oCell = oRow.insertCell();
            oDiv = window.parent.document.createElement("div");        
            oDiv.innerHTML="<BUTTON class=Browser  onClick=\"onShowWorkFlowNeededValidSingle('subWorkflowId_<%=rowNum%>','subWorkflowNameSpan_<%=rowNum%>',0)\" name=showSubWorkflow></BUTTON><span id=subWorkflowNameSpan_<%=rowNum%> name=subWorkflowNameSpan_<%=rowNum%>><%=subWorkflowName%></span><INPUT type=hidden name=subWorkflowId_<%=rowNum%>  id=\"subWorkflowId_<%=rowNum%>\" value=\"<%=subWorkflowId%>\">";                    
            oCell.appendChild(oDiv);

            //查看子流程意见
            oCell = oRow.insertCell();
            oDiv = window.parent.document.createElement("div");        
            oDiv.innerHTML="<SELECT class=InputStyle  name=isRead_<%=rowNum%>  ><option value=\"0\" <%if(isRead==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option> <option value=\"1\" <%if(isRead==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option></SELECT>";                    
            oCell.appendChild(oDiv);
			
            //子流程字段设置
            oCell = oRow.insertCell();
            oDiv = window.parent.document.createElement("div");
			oDiv.innerHTML="										    <A HREF=\"#\" onClick=\"triDiffWfSubWfFieldConfig(tab0002,<%=triDiffWfDiffFieldId%>, <%=triDiffWfSubWfId%>, <%=fieldValue%>, document.all('subWorkflowId_<%=rowNum%>').value, document.all('isRead_<%=rowNum%>').value, <%=mainWorkflowId%>)\"><%=SystemEnv.getHtmlLabelName(21585,user.getLanguage())%></A>";                    

            oCell.appendChild(oDiv);
<%
    rowNum++;
}
%>

	if(document.getElementById("rowNumTriDiffWfSubWf")!=null){
		document.getElementById("rowNumTriDiffWfSubWf").value=<%=rowNum%>;
	}

        oRow = oTable.insertRow();
        oCell = oRow.insertCell();
		oCell.height=10;
        oDiv = window.parent.document.createElement("div");        
        oDiv.innerHTML="";                    
        oCell.appendChild(oDiv);
		oCell = oRow.insertCell();
		oCell = oRow.insertCell();
		oCell = oRow.insertCell();
<%if(hasNextPage || (!hasNextPage && pagenum>1)){%>
        oRow = oTable.insertRow();
		var spaceCell = 2 ;
<%	if(pagenum>1){%>
        oCell = oRow.insertCell();
        oDiv = window.parent.document.createElement("div");        
        oDiv.innerHTML="<A HREF=\"#\" onClick=\"prePageTriDiffWfSubWf()\">【<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>】</A>";
        oCell.appendChild(oDiv);
<%	}else{%>
		spaceCell++;
<%	}%>
<%	if(hasNextPage){%>
        oCell = oRow.insertCell();
        oDiv = window.parent.document.createElement("div");        
        oDiv.innerHTML="<A HREF=\"#\" onClick=\"nextPageTriDiffWfSubWf()\">【<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>】</A>";
        oCell.appendChild(oDiv);
<%	}else{%>
		spaceCell++;
<%	}%>
		for(var i=0;i<spaceCell;i++){
			oCell = oRow.insertCell();
		}
<%}%>
    }
                
</SCRIPT>
