<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
  WorkFlowBillUtil wf = new WorkFlowBillUtil();
  char separator = Util.getSeparator();
  String operation = Util.null2String(request.getParameter("operation"));  
  String sql = "";
  String para="";
//add workflowbill 
  if(operation.equalsIgnoreCase("addWorkflowbill")){
    String id_1 = Util.fromScreen(request.getParameter("id_1"),user.getLanguage());    
    int id = Util.getIntValue(id_1,0);                            
    String indexdesc_1 = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());         
    int namelabel = wf.getLabelIdbyLabelName(indexdesc_1);  
                          
    String maintable = Util.fromScreen(request.getParameter("maintable"),user.getLanguage());    
    String detailtable = Util.fromScreen(request.getParameter("detailtable"),user.getLanguage());    
    String newpage = Util.fromScreen(request.getParameter("newpageUrl"),user.getLanguage());    
    String viewpage = Util.fromScreen(request.getParameter("viewpageUrl"),user.getLanguage());    
    String editpage = Util.fromScreen(request.getParameter("editpageUrl"),user.getLanguage());
    String operationpage = Util.fromScreen(request.getParameter("operationpage"),user.getLanguage());
    String detailkeyfield = Util.fromScreen(request.getParameter("detailkeyfield"),user.getLanguage());    
    para=""+id+separator+namelabel+separator+maintable+separator+newpage+separator+editpage+separator+viewpage+separator+detailtable+separator+detailkeyfield + separator + operationpage;        
    rs.executeProc("WorkFlow_Bill_Insert",para);
    response.sendRedirect("ManageWorkflowbill.jsp");
    return ;	
  }
//search  
  if(operation.equalsIgnoreCase("search")){            
      String indexdesc = Util.fromScreen(request.getParameter("searchcon"),user.getLanguage());      
      para = indexdesc;
      out.println(para);
      rs.executeProc("WorkFlow_Bill_Search",para);
      int id = 0;      
      while(rs.next()){
        id = Util.getIntValue(rs.getString("id"),0);
      }
      response.sendRedirect("ViewWorkflowbill.jsp?id="+id+"&indexdesc="+indexdesc);
      return;
  }  
//delete  
  if(operation.equalsIgnoreCase("delete")){         
      int id = Util.getIntValue(request.getParameter("id"),0);
      para =""+id;         
      rs.executeProc("WorkFlow_Bill_Delete",para);
      para = ""+id;
      rs.executeProc("WorkFlow_BillField_DelByBill",para);
      response.sendRedirect("Manageworkflowbill.jsp");
      return;
   }
//edit workflowbill      
  if(operation.equalsIgnoreCase("editWorkflowbill")){
    String id_1 = Util.fromScreen(request.getParameter("id"),user.getLanguage());    
    int id = Util.getIntValue(id_1,0);
    //String indexdesc_1 = Util.fromScreen2(request.getParameter("indexdesc"),user.getLanguage());	    
    String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());	
    int namelabel = wf.getLabelIdbyLabelName(indexdesc);                    
    String maintable = Util.fromScreen(request.getParameter("maintable"),user.getLanguage());    
    String detailtable = Util.fromScreen(request.getParameter("detailtable"),user.getLanguage());    
    String newpage = Util.fromScreen(request.getParameter("newpageUrl"),user.getLanguage());    
    String viewpage = Util.fromScreen(request.getParameter("viewpageUrl"),user.getLanguage());    
    String editpage = Util.fromScreen(request.getParameter("editpageUrl"),user.getLanguage());
    String operationpage = Util.fromScreen(request.getParameter("operationpage"),user.getLanguage());
    String detailkeyfield = Util.fromScreen(request.getParameter("detailkeyfield"),user.getLanguage());        	    
    para = ""+id+separator+namelabel+separator+maintable+separator+newpage+separator+editpage+separator+viewpage+separator+detailtable+separator+detailkeyfield + separator + operationpage; 
    out.println(para);
    out.println(rs.executeProc("WorkFlow_Bill_Update",para));
    response.sendRedirect("ManageWorkflowbill.jsp");
    return;
  }
//add workflowbillfield         
  if(operation.equalsIgnoreCase("addworkflowbillfield")){                 
    int billid = Util.getIntValue(request.getParameter("id"),0);
    String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
    int id = Util.getIntValue(request.getParameter("fieldid"),0);
    String name = Util.fromScreen(request.getParameter("fieldname"),user.getLanguage());
    String fielddesc = Util.fromScreen(request.getParameter("fielddesc"),user.getLanguage());                
    int fieldlabel = wf.getLabelIdbyLabelName(fielddesc);                                
    String dbtype = Util.fromScreen(request.getParameter("fielddbtype"),user.getLanguage());               
    String htmltype = Util.fromScreen(request.getParameter("fieldhtmltype"),user.getLanguage());               
    int type = Util.getIntValue(request.getParameter("fieldtype"),0);
    int dsporder = Util.getIntValue(request.getParameter("fielddsporder"),0);
    int viewtype = Util.getIntValue(request.getParameter("fieldviewtype"),0);
    para = ""+billid+separator+name+separator+fieldlabel+separator+dbtype+separator+htmltype+separator+type+separator+dsporder+separator+viewtype;
    out.println(para);
    out.println(rs.executeProc("WorkFlow_BillField_Insert",para));
    //sql = "INSERT INTO [workflow_billfield] ( [billid], [fieldname], [fieldlabel], [fielddbtype],  [fieldhtmltype], [type], [dsporder], [viewtype]) VALUES ("+billid+",'"+name+"',"+fieldlabel+",'"+dbtype+"',"+htmltype+","+type+","+dsporder+","+viewtype+")";
    //out.println(sql);
    //out.println(rs.executeSql(sql));
    response.sendRedirect("ViewWorkflowbill.jsp?id="+billid+"&indexdesc="+indexdesc);
    return;
  }
//delete field             
  if(operation.equalsIgnoreCase("deletefield")){    
    int id = Util.getIntValue(request.getParameter("id"),0);
    int billid = 0;
    sql = "select billid from workflow_billfield where id = "+id;
    rs.executeSql(sql);
    while(rs.next()){
      billid = Util.getIntValue(rs.getString("billid"),0);
    }
    para = ""+id;
    rs.executeProc("WorkFlow_BillField_Delete",para);
    response.sendRedirect("ViewWorkflowbill.jsp?id="+billid);
    return;
  }
//edit workflowbillfield                 
  if(operation.equalsIgnoreCase("editWorkflowbillfield")){
    int id = Util.getIntValue(request.getParameter("id"),0);
    int billid = Util.getIntValue(request.getParameter("billid"),0);
    String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());	                
    String name = Util.fromScreen(request.getParameter("fieldname"),user.getLanguage());
    String fielddesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());                
    out.println(fielddesc);
    int label = wf.getLabelIdbyLabelName(fielddesc);                                	
    String dbtype = Util.fromScreen(request.getParameter("fielddbtype"),user.getLanguage());               
    String htmltype = Util.fromScreen(request.getParameter("fieldhtmltype"),user.getLanguage());               
    int type = Util.getIntValue(request.getParameter("fieldtype"),0);
    int dsporder = Util.getIntValue(request.getParameter("fielddsporder"),0);
    int viewtype = Util.getIntValue(request.getParameter("fieldviewtype"),0);
    para = ""+id+separator+billid+separator+name+separator+label+separator+dbtype+separator+htmltype+separator+type+separator+dsporder+separator+viewtype;
    out.println(para);
    rs.executeProc("WorkFlow_BillField_Update",para);
    response.sendRedirect("ViewWorkflowbill.jsp?id="+billid);
  }                     
%>
