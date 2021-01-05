<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
char separator = Util.getSeparator() ;
String para = "";
int userid = user.getUID(); 


Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String seclevel = Util.null2String(request.getParameter("seclevel"));//安区级别
//System.out.println("seclevel:"+seclevel);
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String layoutid = Util.fromScreen(request.getParameter("layoutid"),user.getLanguage());
String organizer = Util.fromScreen(request.getParameter("organizer"),user.getLanguage());
String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String enddate = Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String content = Util.fromScreen(request.getParameter("content"),user.getLanguage());
String aim = Util.fromScreen(request.getParameter("aim"),user.getLanguage());
String address = Util.fromScreen(request.getParameter("address"),user.getLanguage());
String resource = Util.fromScreen(request.getParameter("resource"),user.getLanguage());
String actor = Util.fromScreen(request.getParameter("actor"),user.getLanguage());
String budget = Util.fromScreen(request.getParameter("budget"),user.getLanguage());
String budgettype = Util.fromScreen(request.getParameter("budgettype"),user.getLanguage());
String openrange = Util.fromScreen(request.getParameter("openrange"),user.getLanguage());
String docs = Util.null2String(request.getParameter("docs"));
if(operation.equals("edit")){
/* td1971,should be ms jdbc driver's bug. xiaofeng
    para = name+separator+layoutid+separator+organizer+separator+startdate+separator+enddate+
            separator+content+separator+aim+separator+address+separator+resource+separator+
            actor+separator+budget+separator+budgettype+separator+openrange+separator+id;
    rs.executeProc("HrmTrainPlan_Update",para);
*/
if(budget.equals("") || Util.getDoubleValue(budget, 0.0) < 0)
budget="0.0";
  String sql=  "Update HrmTrainPlan set planname ='"+ name
 +"',layoutid ="+ layoutid
 +" ,planorganizer ='"+ organizer
 +"',planstartdate ='"+ startdate
 +"',planenddate ='"+ enddate
 +"',plancontent ='"+ content
 +"',planaim ='"+ aim
 +"',planaddress ='"+address
 +"',planresource ='"+ resource
 +"',planactor ='"+ actor
 +"',planbudget ="+  budget
 +",planbudgettype ='"+ budgettype
 +"',openrange ='"+ openrange
 +"',traindocs ='"+ docs
 +"' where id ="+id;
 //   System.out.println("sql="+sql);
 rs.executeSql(sql);

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("HrmTrainPlan_Update,"+para);
    SysMaintenanceLog.setOperateItem("82");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();

    response.sendRedirect("HrmTrainPlanEditDo.jsp?isclose=1&id="+id);
}

if(operation.equals("plandaysave")){
  rs.executeProc("TrainPlanDay_Delete",""+id);
  int rowindex = Util.getIntValue(request.getParameter("rowindex"),user.getLanguage());
  out.println(rowindex);
  for(int i = 0;i<rowindex;i++){
      String date = Util.fromScreen(request.getParameter("date_"+i),user.getLanguage());
      String daycontent = Util.fromScreen(request.getParameter("daycontent_"+i),user.getLanguage());
      String dayaim = Util.fromScreen(request.getParameter("dayaim_"+i),user.getLanguage());
       String starttime = Util.null2String(request.getParameter("starttime_"+i));
      String endtime = Util.null2String(request.getParameter("endtime_"+i));
      String info = date+daycontent+dayaim+starttime+endtime;
       if(!info.trim().equals("")){
          para = ""+id+separator+date+separator+daycontent+separator+dayaim;
          String insertsql="insert into HrmTrainPlanDay(planid,plandate,plandaycontent,plandayaim,starttime,endtime) values ("+
                  id+",'"+date+"','"+daycontent+"','"+dayaim+"','"+starttime+"','"+endtime+"')";
          rs.executeSql(insertsql);
      }    
  }
  response.sendRedirect("HrmTrainPlanDayEdit.jsp?isclose=1&id="+id);
  
}
if(operation.equals("add")){
    int flag = 0;
    String sql = "select typeoperator from HrmTrainType where id = (select typeid from HrmTrainLayout where id = "+layoutid+")";
    rs.executeSql(sql);
    rs.next();
    String operator = Util.null2String(rs.getString("typeoperator"));
    ArrayList al = Util.TokenizerString(operator,",");
    for(int i = 0;i<al.size();i++){
        String op = (String)al.get(i);
        if(op.equals(""+userid)){
            flag = 1;
            break;
        }
    }
    if(flag == 0){
        response.sendRedirect("HrmTrainPlanAdd.jsp?msg=1");
        return ;
    }
/* td1971,xiaofeng
    para = name+separator+layoutid+separator+organizer+separator+startdate+separator+enddate+
    separator+content+separator+aim+separator+address+separator+resource+separator+
    actor+separator+budget+separator+budgettype+separator+openrange+separator+userid+separator+nowdate;
    rs.executeProc("HrmTrainPlan_Insert",para);
*/
if(budget.equals("") || Util.getDoubleValue(budget, 0.0) < 0)
budget="0.0";
sql="insert into HrmTrainPlan (planname,layoutid ,planorganizer,planstartdate,planenddate,plancontent,planaim,planactor,createrid,createdate) values('"
+name+"',"
+ layoutid+",'"
+ organizer+"','"
+ startdate+"','"
+ enddate+"','"
+ content+"','"
+ aim+"','"
+ actor+"',"
+ userid+",'"
+ nowdate+"')";

//System.out.println("sql="+sql);
    rs.executeSql(sql);
    sql = "select max(id) from HrmTrainPlan";
    rs.executeSql(sql);
    rs.next();
    id = rs.getString(1);
    
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("HrmTrainPlan_insert,"+para);
    SysMaintenanceLog.setOperateItem("82");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
      
    response.sendRedirect("HrmTrainPlanAdd.jsp?isclose=1");
}
  
if(operation.equals("delete")){ 
    para = ""+id;
    name = TrainPlanComInfo.getTrainPlanname(id);
    rs.executeProc("HrmTrainPlan_Delete",para);

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("HrmTrainPlan_Update,"+para);
    SysMaintenanceLog.setOperateItem("82");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();

    response.sendRedirect("HrmTrainPlan.jsp");
}
  
if(operation.equals("addrange")){
	String employeeID = "";
	ArrayList resourceids = new ArrayList() ;
    String sharetype = Util.fromScreen(request.getParameter("sharetype"),user.getLanguage());
    String relatedshareid = Util.fromScreen(request.getParameter("relatedshareid"),user.getLanguage());
    String planid = Util.fromScreen(request.getParameter("planid"),user.getLanguage());
	if(!sharetype.equals("0")){
		int SSS= 0;
		String tmpresourceid = relatedshareid ;
	    List resources=Util.TokenizerString(tmpresourceid,",");
	    for(int i=0;i<resources.size();i++){
	      resourceids.add(resources.get(i));
		  employeeID=(String)resourceids.get(i);
		  para = planid + separator+sharetype+separator+employeeID+separator+SSS;
		  rs.executeProc("HrmTrainPlanRange_Insert",para);
	    }
	}else{
		if(!seclevel.equals("")){
		
		//System.out.println("sharetype--notnull--");
        para = planid + separator+sharetype+separator+relatedshareid+separator+seclevel;
		rs.executeProc("HrmTrainPlanRange_Insert",para);				
        
	}else{
		//System.out.println("sharetype--null--");
	int	seclevelusid = 0;
	    para = planid + separator+sharetype+separator+relatedshareid+separator+seclevelusid;
			rs.executeProc("HrmTrainPlanRange_Insert",para);			
	}
	}
    
    
    response.sendRedirect("HrmTrainPlanRange.jsp?planid="+planid);
}
  
if(operation.equals("deleterange")){
    String planid = Util.fromScreen(request.getParameter("planid"),user.getLanguage());
    para = ""+id;
    rs.executeProc("HrmTrainPlanRange_Delete",para);
    response.sendRedirect("HrmTrainPlanRange.jsp?planid="+planid);
}
  
if(operation.equals("info")){
     String planname = TrainPlanComInfo.getTrainPlanname(id);    
     String accepter="";
     String title="";
     String remark="";
     String submiter="";
     String subject="";      
     
     subject= SystemEnv.getHtmlLabelName(16164,user.getLanguage()) ;
     subject+=":"+planname;     
     accepter = TrainPlanComInfo.getInfoMan(id);
     if( !accepter.equals("") ) {
         if( accepter.lastIndexOf(",") == accepter.length()-1) 
             accepter = accepter.substring(0,accepter.length()-1) ;
         title =  SystemEnv.getHtmlLabelName(16164,user.getLanguage()) ;
         title += ":System Remind ";
         title += "-"+ResourceComInfo.getResourcename(""+user.getUID());
         title += "-"+nowdate;     
         remark="<a href=/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a>";     
         submiter = ""+user.getUID();
         SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
     }
     response.sendRedirect("HrmTrainPlan.jsp");
}
%>