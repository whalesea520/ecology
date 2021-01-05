
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int isBill = Util.getIntValue(request.getParameter("isBill"),0);
int selectValue = Util.getIntValue(request.getParameter("selectValue"),-1);

String docPath = Util.null2String(request.getParameter("docPath"));
String docCategory = Util.null2String(request.getParameter("docCategory"));

int objId = Util.getIntValue(request.getParameter("objId"));
//objType:0 总部  1分部 2部门 3人员
String objType = Util.null2String(request.getParameter("objType"));

String syc = Util.null2String(request.getParameter("syc"));
String sql = "";

if(objType.equals("1")){

    RecordSet.executeSql("SELECT 1 FROM Workflow_SelectitemObj WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+objId+" AND objType='"+objType+"'");

	if(RecordSet.next()){
		RecordSet.executeSql("update Workflow_SelectitemObj set docPath='"+Util.toHtml100(docPath)+"',docCategory='"+Util.toHtml100(docCategory)+"' WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+objId+" AND objType='"+objType+"'");
	}else{
		RecordSet.executeSql("insert into Workflow_SelectitemObj(fieldId,isBill,selectValue,objId,objType,docPath,docCategory) values("+fieldId+","+isBill+","+selectValue+","+objId+",'"+objType+"','"+Util.toHtml100(docPath)+"','"+Util.toHtml100(docCategory)+"')");
	}

	if(syc.equals("y")){
		//同步下级分部
		String subCompanyIds = SubCompanyComInfo.getSubCompanyTreeStr(String.valueOf(objId));

		int tempObjId=0;
		String[] tmp = Util.TokenizerString2(subCompanyIds,",");
		for(int i=0;i<tmp.length;i++){
			tempObjId=Util.getIntValue(tmp[i],0);

            RecordSet.executeSql("SELECT 1 FROM Workflow_SelectitemObj WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+tempObjId+" AND objType='1'");

	        if(RecordSet.next()){
		        RecordSet.executeSql("update Workflow_SelectitemObj set docPath='"+Util.toHtml100(docPath)+"',docCategory='"+Util.toHtml100(docCategory)+"' WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+tempObjId+" AND objType='1'");
	        }else{
		        RecordSet.executeSql("insert into Workflow_SelectitemObj(fieldId,isBill,selectValue,objId,objType,docPath,docCategory) values("+fieldId+","+isBill+","+selectValue+","+tempObjId+",'1','"+Util.toHtml100(docPath)+"','"+Util.toHtml100(docCategory)+"')");
	        }
		}
	}
}else if(objType.equals("0")){
    RecordSet.executeSql("SELECT 1 FROM Workflow_SelectitemObj WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+objId+" AND objType='"+objType+"'");

	if(RecordSet.next()){
		RecordSet.executeSql("update Workflow_SelectitemObj set docPath='"+Util.toHtml100(docPath)+"',docCategory='"+Util.toHtml100(docCategory)+"' WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+objId+" AND objType='"+objType+"'");
	}else{
		RecordSet.executeSql("insert into Workflow_SelectitemObj(fieldId,isBill,selectValue,objId,objType,docPath,docCategory) values("+fieldId+","+isBill+","+selectValue+","+objId+",'"+objType+"','"+Util.toHtml100(docPath)+"','"+Util.toHtml100(docCategory)+"')");
	}

	if(syc.equals("y")){
		//同步下级分部
		String subCompanyIds = SubCompanyComInfo.getSubCompanyTreeStr(String.valueOf(objId));

		int tempObjId=0;
		String[] tmp = Util.TokenizerString2(subCompanyIds,",");
		for(int i=0;i<tmp.length;i++){
			tempObjId=Util.getIntValue(tmp[i],0);

            RecordSet.executeSql("SELECT 1 FROM Workflow_SelectitemObj WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+tempObjId+" AND objType='1'");

	        if(RecordSet.next()){
		        RecordSet.executeSql("update Workflow_SelectitemObj set docPath='"+Util.toHtml100(docPath)+"',docCategory='"+Util.toHtml100(docCategory)+"' WHERE fieldId="+fieldId+" and isBill="+isBill+" and selectValue="+selectValue+" and objId="+tempObjId+" AND objType='1'");
	        }else{
		        RecordSet.executeSql("insert into Workflow_SelectitemObj(fieldId,isBill,selectValue,objId,objType,docPath,docCategory) values("+fieldId+","+isBill+","+selectValue+","+tempObjId+",'1','"+Util.toHtml100(docPath)+"','"+Util.toHtml100(docCategory)+"')");
	        }
		}
	}
}

response.sendRedirect("SubcompanyDocCategoryBrowser.jsp?fieldId="+fieldId+"&isBill="+isBill+"&selectValue="+selectValue);
%>
