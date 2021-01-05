
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());  

if(operation.equals("add")||operation.equals("edit")){
int count = Util.getIntValue(request.getParameter("count"));
String checkstockno = Util.fromScreen(request.getParameter("checkstockno"),user.getLanguage());             //编号
String checkstockdesc = Util.fromScreen(request.getParameter("checkstockdesc"),user.getLanguage());         //描述
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());             //部门
String location = Util.fromScreen(request.getParameter("location"),user.getLanguage());                     //存放地点
String createdate = Util.fromScreen(request.getParameter("createdate"),user.getLanguage());                 //盘点日期
String checkerid = Util.fromScreen(request.getParameter("checkerid"),user.getLanguage());                   //盘点人

ArrayList capitalidarray = new ArrayList();
ArrayList capitalnumarray = new ArrayList();
ArrayList realnumarray = new ArrayList();
ArrayList currentpricearray = new ArrayList();
ArrayList remarkarray = new ArrayList();
ArrayList idarray = new ArrayList();

for(int i=0;i<count;i++){
    String tempstr = "capitalid_"+i;
    capitalidarray.add(Util.fromScreen(request.getParameter(tempstr),user.getLanguage()));
}


for(int i=0;i<count;i++){
    String tempstr = "capitalnum_"+i;
    capitalnumarray.add(Util.fromScreen(request.getParameter(tempstr),user.getLanguage()));
}


for(int i=0;i<count;i++){
    String tempstr = "realnum_"+i;
    realnumarray.add(Util.fromScreen(request.getParameter(tempstr),user.getLanguage()));
}


for(int i=0;i<count;i++){
    String tempstr = "currentprice_"+i;
    currentpricearray.add(Util.fromScreen(request.getParameter(tempstr),user.getLanguage()));
}


for(int i=0;i<count;i++){
    String tempstr = "remark_"+i;
    remarkarray.add(Util.fromScreen(request.getParameter(tempstr),user.getLanguage()));
}

for(int i=0;i<count;i++){
    String tempstr = "id_"+i;
    idarray.add(Util.fromScreen(request.getParameter(tempstr),user.getLanguage()));
}
//out.print("<br>"+capitalidarray);
//out.print("<br>"+capitalnumarray);
//out.print("<br>"+realnumarray);
//out.print("<br>"+currentpricearray);
//out.print("<br>"+remarkarray);

if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("CptCapitalCheckStockAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    
  	//主表
	String para = "";
    para = checkstockno;
    para+= separator+checkstockdesc;
    para+= separator+departmentid;
    para+= separator+location;
    para+= separator+checkerid;
    para+= separator+createdate;
    para+= separator+"0";

	RecordSet.executeProc("CptCheckStock_Insert",para);
    String tempid="";

	//详细表
    if(RecordSet.next()){
		tempid = RecordSet.getString(1);
	}

    for(int i=0;i<count;i++){
        int tempcapitalnum = Util.getIntValue((String)(capitalnumarray.get(i)));
        int temprealnum    = Util.getIntValue((String)(realnumarray.get(i)));
        int tempsurplusnum =0;
        float tempsurplusprice = 0;
        float tempcurrentprice = Util.getFloatValue((String)(currentpricearray.get(i)));
        String tempstateid ="";

        if(tempcapitalnum>temprealnum){
            tempstateid = "-2";
            tempsurplusnum=tempcapitalnum-temprealnum;
            tempsurplusprice = tempsurplusnum*tempcurrentprice;
        }
        else if(tempcapitalnum<temprealnum){
            tempstateid = "-1";
            tempsurplusnum=temprealnum-tempcapitalnum;
            tempsurplusprice = tempsurplusnum*tempcurrentprice;
        }

        tempsurplusprice = (float)(((int)(tempsurplusprice*100))/100.00);//保留2位小数

        //新增细目
        para = "";
        para = tempid;
        para+= separator+(String)(capitalidarray.get(i));
        para+= separator+(String)(capitalnumarray.get(i));
        para+= separator+(String)(realnumarray.get(i));
        para+= separator+(String)(currentpricearray.get(i));
        para+= separator+(String)(remarkarray.get(i));

    	RecordSet.executeProc("CptCheckStockList_Insert",para);
        
        //对于非单独核算的资产,如果有盈亏,记入资产表和流转表
        String sptcount = CapitalComInfo.getSptcount((String)(capitalidarray.get(i)));

        if(!sptcount.equals("1")&&(tempcapitalnum!=temprealnum)){
            
            //修改资产表非单独核算资产的数量并将盈亏信息记入流转表
            para ="";
            para = (String)(capitalidarray.get(i));
            para+= separator+currentdate;
            para+= separator+departmentid;
            para+= separator+checkerid;
            para+= separator+""+tempsurplusnum;
            para+= separator+"";
            para+= separator+tempid;
            para+= separator+"";
            para+= separator+""+tempsurplusprice;
            para+= separator+tempstateid;
            para+= separator+(String)(remarkarray.get(i));
            para+= separator+""+temprealnum;

            RecordSet.executeProc("CptUseLogCheckStock_Insert",para);
        }

   }

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(tempid));
      SysMaintenanceLog.setRelatedName(checkstockno);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("CptCheckStock_Insert,"+para);
      SysMaintenanceLog.setOperateItem("200");
      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalCheckStockAdd:Add"));
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

 	response.sendRedirect("CptCapitalCheckStock.jsp");
 }
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("CptCapitalCheckStockEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

    int checkstockid = Util.getIntValue(request.getParameter("checkstockid"));

	String para = "";
    para += checkstockid; 
    para += separator + checkstockno;
    para += separator + checkstockdesc;
	
    RecordSet.executeProc("CptCheckStock_Update",para);
    
    
    for(int i=0;i<count;i++){
        int tempcapitalnum = Util.getIntValue((String)(capitalnumarray.get(i)));
        int temprealnum    = Util.getIntValue((String)(realnumarray.get(i)));
        int tempsurplusnum =0;
        float tempsurplusprice = 0;
        float tempcurrentprice = Util.getFloatValue((String)(currentpricearray.get(i)));
        String tempstateid ="";

        if(tempcapitalnum>temprealnum){
            tempstateid = "-2";
            tempsurplusnum=tempcapitalnum-temprealnum;
            tempsurplusprice = tempsurplusnum*tempcurrentprice;
        }
        else if(tempcapitalnum<temprealnum){
            tempstateid = "-1";
            tempsurplusnum=temprealnum-tempcapitalnum;
            tempsurplusprice = tempsurplusnum*tempcurrentprice;
        }

        tempsurplusprice = (float)(((int)(tempsurplusprice*100))/100.00);//保留2位小数

        para = "";
        para = (String)(idarray.get(i));
        para += separator + (String)(realnumarray.get(i));
        para += separator + (String)(remarkarray.get(i));

	    RecordSet.executeProc("CptCheckStockList_Update",para);

         //对于非单独核算的资产,如果有盈亏,记入资产表和流转表
        String sptcount = CapitalComInfo.getSptcount((String)(capitalidarray.get(i)));

        if(!sptcount.equals("1")&&(tempcapitalnum!=temprealnum)){
            
            //修改资产表非单独核算资产的数量并将盈亏信息记入流转表
            para ="";
            para = (String)(capitalidarray.get(i));
            para+= separator+""+checkstockid;
            para+= separator+tempstateid;
            para+= separator+""+tempsurplusnum;
            para+= separator+""+tempsurplusprice;
            para+= separator+""+temprealnum;
            para+= separator+(String)(remarkarray.get(i));

            RecordSet.executeProc("CptUseLogCheckStock_Update",para);
        }
    }//end for
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(checkstockid);
      SysMaintenanceLog.setRelatedName(checkstockno);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CptCheckStock_Update,"+para);
      SysMaintenanceLog.setOperateItem("200");
      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalCheckStockEdit:Edit"));
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

      response.sendRedirect("CptCapitalCheckStock.jsp");
 }//end of edit
 }//end of add&edit
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("CptCapitalCheckStockEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

    int checkstockid = Util.getIntValue(request.getParameter("checkstockid"));
	String para = ""+checkstockid;
	RecordSet.executeProc("CptCheckStock_Delete",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(checkstockid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CptCheckStock_Delete,"+para);
      SysMaintenanceLog.setOperateItem("200");
      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalCheckStockEdit:Delete"));
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

 	response.sendRedirect("CptCapitalCheckStock.jsp");
 }
  else if(operation.equals("approve")){
 	if(!HrmUserVarify.checkUserRight("CptCapitalCheckStock:Approve", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    
    String approverid = ""+user.getUID();

    int checkstockid = Util.getIntValue(request.getParameter("checkstockid"));
	String para = ""+checkstockid;
    para +=separator+approverid;
    para +=separator+currentdate;

	RecordSet.executeProc("CptCheckStock_Approve",para);

    SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(checkstockid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("7");
      SysMaintenanceLog.setOperateDesc("CptCheckStock_Approve,"+para);
      SysMaintenanceLog.setOperateItem("200");
      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalCheckStock:Approve"));
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	
 	response.sendRedirect("CptCapitalCheckStock.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">