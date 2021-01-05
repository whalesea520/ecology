
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	
	if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

    int mouldId = Util.getIntValue(request.getParameter("mouldId"),-1); 
    
    String isDialog = Util.null2String(request.getParameter("isdialog"));

	int tempRecordId=0;
    double tempShowOrder=0;

  	int rowNum = Util.getIntValue(Util.null2String(request.getParameter("rowNum")));
	String[] labelOrders = request.getParameterValues("labelOrder_recordId"); 
	for(int i=0;i<rowNum && i<labelOrders.length;i++) {
		tempRecordId = Util.getIntValue(labelOrders[i],0);
		//tempRecordId = Util.getIntValue(request.getParameter("labelOrder"+i+"_recordId"),0);
		//tempShowOrder = Util.getDoubleValue(request.getParameter("labelOrder"+i+"_showOrder"),0);
		tempShowOrder = i*1.0;
		if(tempRecordId>0){
			RecordSet.executeSql("update MouldBookMark set showOrder="+tempShowOrder+" where id="+tempRecordId);
		}
	}
	
    //response.sendRedirect("DocMouldDspExt.jsp?id="+mouldId);
    if(isDialog.equals("1")){
    	response.sendRedirect("DocMouldLabelOrder.jsp?isclose=1&mouldId="+mouldId);
    }else{
    	response.sendRedirect("DocMouldLabelOrder.jsp?mouldId="+mouldId);	
    }

%>
