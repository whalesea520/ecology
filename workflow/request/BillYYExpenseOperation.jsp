
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
String src = Util.null2String(request.getParameter("src"));
String iscreate = Util.null2String(request.getParameter("iscreate"));
int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
int isremark = Util.getIntValue(request.getParameter("isremark"),-1);
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int isbill = Util.getIntValue(request.getParameter("isbill"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String nodetype = Util.null2String(request.getParameter("nodetype"));
String requestname = Util.fromScreen(request.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(request.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(request.getParameter("remark"));
String crmids = "" ;
String projectids = "" ;

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}


RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(request) ;
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;
RequestManager.setUser(user) ;


boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
    char flag=Util.getSeparator() ;
    double feesumcount = 0 ;
    double realfeesumcount = 0 ;
    int accessorycount = 0 ;

    if( !iscreate.equals("1") ) RecordSet.executeSql("delete from Bill_YYExpenseDetail where id ="+billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }

    ArrayList fieldids=new ArrayList();             //字段队列
    ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
    ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
    }

    ArrayList fieldNames = new ArrayList();
    ArrayList fieldValues = new ArrayList();
    for(int i=0; i<fieldnames.size();i++){
        if((fieldviewtypes.get(i)+"").equals("1")){
            //System.out.println("fieldName = " + fieldnames.get(i));
            fieldNames.add(fieldnames.get(i));
        }
    }




    int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
    for(int i=0;i<rowsum;i++) {

        boolean caninsert = false ;

        Object fieldid = null;
        String fieldname = "";
        String fieldvalue = "";

        for(int j=0 ; j<fieldNames.size(); j++){
            fieldname = fieldNames.get(j)+"";
            fieldid = fieldids.get(fieldnames.indexOf(fieldname)) ;
            fieldvalue = Util.null2String(request.getParameter("field"+fieldid+"_"+i));
            //System.out.println("fieldvalue("+"field"+fieldid+"_"+i+") = " + fieldvalue);
            if(!fieldvalue.trim().equals("")){
                fieldValues.add(j,fieldvalue);
                caninsert=true;
            }else{
                if(fieldname.equals("expenseType")){
                    fieldvalue = "0";
                }else if(fieldname.equals("moneyType")){
                    fieldvalue = "0";
                }else if(fieldname.equals("peymentWay")){
                    fieldvalue = "0";
                }else if(fieldname.equals("paymentBank")){
                    fieldvalue = "0";
                }else if(fieldname.equals("paymentAccount")){
                    fieldvalue = "0";
                }else if(fieldname.equals("cashFlow")){
                    fieldvalue = "0";
                }else if(fieldname.equals("expenseMoney")){
                    fieldvalue = "0";
                }else if(fieldname.equals("accessoryNumber")){
                    fieldvalue = "0";
                }
                fieldValues.add(j,fieldvalue);
            }
        }


        if(!caninsert){
            continue;
        }


        String para = ""+billid+flag;
        for(int j=0 ; j<fieldNames.size(); j++){
            fieldvalue = fieldValues.get(j)+"";
            para += ""+fieldvalue + flag;
        }
        para = para.substring(0,para.length()-1);
        //System.out.println("SQL:"+para);
        RecordSet.executeProc("Bill_YYExpenseDetail_Insert",para);
    }
    String colcalnames = Util.null2String(request.getParameter("colcalnames"));
    String colcalname = "";
    if(colcalnames!=null&&colcalnames.length()>0){
        if(colcalnames.lastIndexOf(",")!=-1){
            colcalname = colcalnames.substring(0,colcalnames.lastIndexOf(","));
        }else{
            colcalname = colcalnames;
        }
    }
    //System.out.println("colcalname = " + colcalname);
    String colcalid = fieldids.get(fieldnames.indexOf(colcalname))+"";
    String colcalvalue = Util.null2String(request.getParameter("sumvalue"+colcalid));
    String sql = "update Bill_YYExpense set allSumMoney="+colcalvalue+" where id="+billid;
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);

}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;
//如果下个节点的类型是归档，那么转入数据导出页面
String nextNodeType = RequestManager.getNextNodetype();
    if("3".equals(nextNodeType)){
        //response.sendRedirect("/workflow/request/BillExport.jsp?export=YYExpense&requestid="+requestid+"&formid="+formid+"&billid="+billid);
		out.print("<script>wfforward('/workflow/request/BillExport.jsp?export=YYExpense&requestid="+requestid+"&formid="+formid+"&billid="+billid+"');</script>");
    }
	//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");


%>