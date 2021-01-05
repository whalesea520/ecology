<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

String confirmid = Util.null2String(request.getParameter("confirmid"));
String thetable = Util.null2String(request.getParameter("thetable"));
String inputid = Util.null2String(request.getParameter("inputid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String thedate = Util.null2String(request.getParameter("thedate"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String inprepname=Util.null2String(request.getParameter("inprepname"));
String dspdate=Util.null2String(request.getParameter("dspdate"));
int totalvalue = Util.getIntValue(request.getParameter("totalvalue"),0) ;


if(operation.equals("edit")){

    Hashtable ht = new Hashtable() ;

    Enumeration eu = request.getParameterNames() ;
    while(eu.hasMoreElements() ) {
        String keyname = (String)eu.nextElement() ;
        String keyvalue = Util.null2String(request.getParameter(keyname)) ;

        double keyvaluedouble = Util.getDoubleValue(keyvalue , 0) ;
        ht.put(keyname , ""+keyvaluedouble) ;
    }

    ArrayList itemfieldnames = new ArrayList() ;
    RecordSet.executeProc("T_IRItem_SelectByInprepid",inprepid);
    while(RecordSet.next()) {
        String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
        itemfieldnames.add(itemfieldname) ;
    }

    for ( int i=0 ; i< totalvalue ; i++ ) {

        String sql = "" ; 
        String theinputid = request.getParameter("inputid_"+i) ;
        
        RecordSet.executeProc("T_IRItem_SelectByInprepid",inprepid);


        while (RecordSet.next()) {
            String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
            String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
            String itemgongsi = Util.null2String(RecordSet.getString("itemgongsi")) ;
            String inputablefact = Util.null2String(RecordSet.getString("inputablefact")) ; // 实际是否可输入
            String inputablebudg = Util.null2String(RecordSet.getString("inputablebudg")) ; // 预算是否可输入
            String inputablefore = Util.null2String(RecordSet.getString("inputablefore")) ; // 预测是否可输入
            String inputable = inputablefact ;
            if(inprepbudget.equals("1")) inputable = inputablebudg ;
            else if(inprepbudget.equals("2")) inputable = inputablefore ;
            
            if(sql.equals("")) {
                sql = " update " + thetable + " set "+ itemfieldname +" = " ;
            }
            else {
                sql += ","+itemfieldname+"=" ;
            }

            String itemvalue = "" ;
            
            if(itemfieldtype.equals("2")) itemvalue = "" + Util.getIntValue(request.getParameter(itemfieldname+"_"+i),0);
            else if(itemfieldtype.equals("3") || (itemfieldtype.equals("5") && inputable.equals("1")) ) itemvalue = "" + Util.getDoubleValue(request.getParameter(itemfieldname+"_"+i),0);
            else if(itemfieldtype.equals("5") && !inputable.equals("1") ) {
                for( int k = 0 ; k< itemfieldnames.size() ; k++ ) {
                    itemgongsi = Util.StringReplace( itemgongsi , (String)itemfieldnames.get(k) , "#####&&&") ;
                    itemgongsi = Util.StringReplace( itemgongsi , "#####&&&", (String)itemfieldnames.get(k)+"_" + i ) ;
                }
                String thesql = Util.fillValuesToString(itemgongsi, ht) ;
                rs2.executeSql(" select " + thesql +" as result ") ;
                if(rs2.next())
                    itemvalue = ""+Util.getDoubleValue(rs2.getString(1),0) ;
                else 
                    itemvalue = "0" ;
            }
            else itemvalue = Util.null2String(request.getParameter(itemfieldname+"_"+i));

            if(itemfieldtype.equals("2") || itemfieldtype.equals("3") || itemfieldtype.equals("5") ) {
                sql += itemvalue ;
            }
            else  {
                sql += "'" + Util.fromScreen2(itemvalue,user.getLanguage()) + "'" ;
            }
        }

        sql += " where inputid = " + theinputid ;
        RecordSet.executeSql(sql);
    }
    
    if(confirmid.equals("0"))
        response.sendRedirect("ReportConfirmMtiDetail.jsp?thetable="+thetable+"&thedate="+thedate+"&inprepid="+inprepid+"&crmid="+crmid+"&inprepbudget="+inprepbudget);
    else 
        response.sendRedirect("ReportConfirmMtiDetail.jsp?confirmid="+confirmid);  

}

else if(operation.equals("confirm")){

    String sql = " update " + thetable + " set inputstatus='1' where reportdate = '" + thedate +"' and crmid =" + crmid ;
    RecordSet.executeSql(sql);
    RecordSet.executeProc("T_InputReportConfirm_Delete", confirmid );
    response.sendRedirect("ReportConfirm.jsp");
}

else if(operation.equals("check")){
    
    String sql = " update " + thetable + " set inputstatus='2' where reportdate = '" + thedate + "' ";

    RecordSet.executeSql(sql);

    response.sendRedirect("ReportDetailStatus.jsp?inprepid="+inprepid);
}
else if(operation.equals("reject")){
    String sql ="select requestid from "+thetable+"_main where reportdate = '" + thedate +"' and crmid =" + crmid ;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		ArrayList requestids=new ArrayList();
		requestids.add(RecordSet.getString(1));
		WfForceDrawBack.ForceDrawBackToCreater(requestids,request,response,user.getUID(),(user.getLogintype().equals("1")) ? 0 : 1);
	}
    sql = " update " + thetable + " set inputstatus='9' where reportdate = '" + thedate +"' and crmid =" + crmid ;
    RecordSet.executeSql(sql);
	sql = " update " + thetable + "_main set inputstatus='9' where reportdate = '" + thedate +"' and crmid =" + crmid ;
    RecordSet.executeSql(sql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(inprepid));
	SysMaintenanceLog.setRelatedName(inprepname+":"+CustomerInfoComInfo.getCustomerInfoname(crmid)+" "+dspdate);
	SysMaintenanceLog.setOperateType("9");
	SysMaintenanceLog.setOperateDesc("");
	SysMaintenanceLog.setOperateItem("98");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
    response.sendRedirect("ReportDetailStatus.jsp?inprepid="+inprepid);
}
%>

