<%@ page language="java" contentType="text/html; charset=GBK" %> 


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<%
String operation = Util.null2String(request.getParameter("operation"));
String inprepid = Util.null2String(request.getParameter("inprepid"));

if(operation.equals("edit")){

    int recordNum = Util.getIntValue(request.getParameter("recordNum"),0);

	int itemTypeId=0;
	String itemTypeName=null;
	String itemTypeDesc=null;
	double dspOrder=0;

    for(int i=0;i<recordNum;i++){

		itemTypeId=Util.getIntValue(request.getParameter("itemTypeId_"+i),0);
		itemTypeName = Util.null2String(request.getParameter("itemTypeName_"+i));
		if(itemTypeName.equals("")){
			continue;
		}
		itemTypeDesc = Util.null2String(request.getParameter("itemTypeDesc_"+i));
		dspOrder=Util.getDoubleValue(request.getParameter("dspOrder_"+i),0);

		if(itemTypeId<=0){
			char separator = Util.getSeparator() ;
			String para = inprepid + separator + itemTypeName+ separator + itemTypeDesc + separator + dspOrder ;
			RecordSet.executeProc("T_InputReportItemtype_Insert",para);
		}else{
			char separator = Util.getSeparator() ;
			String para = ""+itemTypeId + separator + itemTypeName + separator + itemTypeDesc + separator + dspOrder ;
			RecordSet.executeProc("T_InputReportItemtype_Update",para);
		}
	}
	
    String delids = Util.null2String(request.getParameter("delids"));

	if(!delids.equals("")){
		if(delids.startsWith(",")){
			delids=delids.substring(1);
		}
	    RecordSet.executeSql("delete from T_InputReportItemType  where itemTypeId in("+delids+")");
	}
    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
}
%>
