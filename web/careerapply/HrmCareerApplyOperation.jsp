<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String sql = "";
String para = "";

String id = Util.fromScreen(request.getParameter("id"),7);
String inviteid = Util.fromScreen(request.getParameter("careerinvite"),7) ;//招聘信息id

String lastname = Util.fromScreen(request.getParameter("lastname"),7) ;
String sex = Util.fromScreen(request.getParameter("sex"),7) ;
String jobtitle = Util.null2String(request.getParameter("jobtitle"));//招聘岗位
String homepage = Util.fromScreen(request.getParameter("homepage"),7) ;
String email = Util.fromScreen(request.getParameter("email"),7) ;
String homeaddress = Util.fromScreen(request.getParameter("homeaddress"),7) ;	/*家庭地址*/
String homepostcode = Util.fromScreen(request.getParameter("homepostcode"),7) ;/*家庭邮编*/
String homephone = Util.fromScreen(request.getParameter("homephone"),7) ;	/*家庭电话*/

String category = Util.fromScreen(request.getParameter("category"),7) ;
String contactor = Util.fromScreen(request.getParameter("contactor"),7) ;/*联系人*/
String salarynow = Util.fromScreen(request.getParameter("salarynow"),7) ;/*当前年薪*/
String worktime = Util.fromScreen(request.getParameter("worktime"),7) ;/*工作年限*/
String salaryneed = Util.fromScreen(request.getParameter("salaryneed"),7) ;/*年薪低限*/				
String currencyid = Util.fromScreen(request.getParameter("currencyid"),7) ;/*币种*/
String reason = Util.fromScreen(request.getParameter("reason"),7) ;/**/
String otherrequest = Util.fromScreen(request.getParameter("otherrequest"),7) ;/**/
String selfcomment = Util.fromScreen(request.getParameter("selfcomment"),7) ;/*自荐书*/

String birthday = Util.fromScreen(request.getParameter("birthday"),7);
String folk = Util.fromScreen(request.getParameter("folk"),7) ;	 /*民族*/
String nativeplace = Util.fromScreen(request.getParameter("nativeplace"),7) ;	/*籍贯*/
String regresidentplace = Util.fromScreen(request.getParameter("regresidentplace"),7) ;	/*户口所在地*/
String maritalstatus = Util.fromScreen(request.getParameter("maritalstatus"),7);
String policy = Util.fromScreen(request.getParameter("policy"),7) ; /*政治面貌*/
String bememberdate = Util.fromScreen(request.getParameter("bememberdate"),7) ;	/*入团日期*/
String bepartydate = Util.fromScreen(request.getParameter("bepartydate"),7) ;	/*入党日期*/
String islabourunion = Util.fromScreen(request.getParameter("islabourunion"),7) ;
String educationlevel = Util.fromScreen(request.getParameter("educationlevel"),7) ;/*学历*/
String degree = Util.fromScreen(request.getParameter("degree"),7) ; /*学位*/
String healthinfo = Util.fromScreen(request.getParameter("healthinfo"),7) ;/*健康状况*/
String height = Util.fromScreen(request.getParameter("height"),7) ;/*身高*/
String weight = Util.fromScreen(request.getParameter("weight"),7) ;
String residentplace = Util.fromScreen(request.getParameter("residentplace"),7) ;	/*现居住地*/
String tempresidentnumber = Util.fromScreen(request.getParameter("tempresidentnumber"),7) ;
String certificatenum = Util.fromScreen(request.getParameter("certificatenum"),7) ;/*证件号码*/
  
    
if(operation.equals("add")){  
  para = id          + separator + lastname     + separator + sex       + separator+
         jobtitle    + separator + homepage     + separator + email     + separator+
         homeaddress + separator + homepostcode + separator + homephone + separator+ inviteid; 
  out.println(para); 
  out.println(rs.executeProc("HrmCareerApply_InsertBasic",para));
  para = id        + separator + category     + separator + contactor   + separator+
         salarynow + separator + worktime     + separator + salaryneed  + separator+
         currencyid+ separator + reason       + separator + otherrequest+ separator+selfcomment ;  
  rs.executeProc("HrmCareerApplyOtherIndo_In",para);
  response.sendRedirect("HrmCareerApplyAddTwo.jsp?id="+id);
  return;
}

if(operation.equals("addtwo")){
  para = ""+id       + separator + birthday           + separator          + folk          + separator +
         nativeplace + separator + regresidentplace   + separator          + maritalstatus + separator +
         policy      + separator + bememberdate       + separator          + bepartydate   + separator +
         islabourunion+separator + educationlevel     + separator          + degree        + separator + 
         healthinfo  + separator + height             + separator          + weight        + separator + 
         residentplace+separator + tempresidentnumber + separator          + certificatenum;   
  rs.executeProc("HrmCareerApply_InsertPer",para);
  
  int rownum = Util.getIntValue(request.getParameter("rownum"),7) ;  
  for(int i = 0;i<rownum;i++){
    String member = Util.fromScreen(request.getParameter("member_"+i),7);
    String title = Util.fromScreen(request.getParameter("title_"+i),7);
    String company = Util.fromScreen(request.getParameter("company_"+i),7);
    String jobtitle_n = Util.fromScreen(request.getParameter("jobtitle_"+i),7);
    String address = Util.fromScreen(request.getParameter("address_"+i),7);
    String info = member+title+company+jobtitle_n+address;
    if(!(info.trim().equals(""))){
    para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle_n+separator+address;
    rs.executeProc("HrmFamilyInfo_Insert",para);  
    }
  }
  
  response.sendRedirect("HrmCareerApplyAddThree.jsp?id="+id);
  return;
}

if(operation.equals("addthree")||operation.equals("editwork")){
  sql = "delete from HrmEducationInfo where resourceid = "+id;
  rs.executeSql(sql);
  int edurownum = Util.getIntValue(request.getParameter("edurownum"),0);  
  for(int i = 0;i<edurownum;i++){
    String school = Util.fromScreen(request.getParameter("school_"+i),7) ; 
    String speciality = Util.fromScreen(request.getParameter("speciality_"+i),7) ; 
    String edustartdate = Util.fromScreen(request.getParameter("edustartdate_"+i),7) ; 
    String eduenddate = Util.fromScreen(request.getParameter("eduenddate_"+i),7) ; 
    String educationlevel_n = Util.fromScreen(request.getParameter("educationlevel_"+i),7) ; 
    String studydesc = Util.fromScreen(request.getParameter("studydesc_"+i),7) ; 
    
    String info = school+speciality+edustartdate+eduenddate+educationlevel_n+studydesc;
    if(!info.trim().equals("")){
    para = ""+id+separator+edustartdate+separator+eduenddate+separator+school+separator+speciality+
    	    separator+educationlevel_n+separator+studydesc;    	   
    rs.executeProc("HrmEducationInfo_Insert",para);      	 
    }
  }
  
  sql = "delete from HrmLanguageAbility where resourceid = "+id;
  rs.executeSql(sql);
  int lanrownum = Util.getIntValue(request.getParameter("lanrownum"),0);  
  for(int i = 0;i<lanrownum;i++){
    String language = Util.fromScreen(request.getParameter("language_"+i),7) ;     
    String level = Util.fromScreen(request.getParameter("level_"+i),7) ; 
    String memo = Util.fromScreen(request.getParameter("memo_"+i),7) ; 
	String info = language+memo;
	if(!info.trim().equals("")){
    para = ""+id+separator+language+separator+level+separator+memo;    
    rs.executeProc("HrmLanguageAbility_Insert",para);
	}
  }
  
  sql = "delete from HrmWorkResume where resourceid = "+id;
  rs.executeSql(sql);
  int workrownum = Util.getIntValue(request.getParameter("workrownum"),0);
  for(int i = 0;i<workrownum;i++){
    String company = Util.fromScreen(request.getParameter("company_"+i),7) ; 
    String workstartdate = Util.fromScreen(request.getParameter("workstartdate_"+i),7) ; 
    String workenddate = Util.fromScreen(request.getParameter("workenddate_"+i),7) ; 
    String jobtitle_n = Util.fromScreen(request.getParameter("jobtitle_"+i),7) ;        
    String workdesc = Util.fromScreen(request.getParameter("workdesc_"+i),7) ; 
    String leavereason = Util.fromScreen(request.getParameter("leavereason_"+i),7) ; 
    
    String info = company+workstartdate+workenddate+jobtitle_n+workdesc+leavereason;
    if(!info.trim().equals("")){
    para = ""+id+separator+workstartdate+separator+workenddate+separator+company+separator+jobtitle_n+
    	    separator+workdesc+separator+leavereason;    
    rs.executeProc("HrmWorkResume_Insert",para);      	 
    }
  }
  
  sql = "delete from HrmTrainBeforeWork where resourceid = "+id;
  rs.executeSql(sql);
  int trainrownum = Util.getIntValue(request.getParameter("trainrownum"),0);
  for(int i = 0;i<workrownum;i++){
    String trainname = Util.fromScreen(request.getParameter("trainname_"+i),7) ; 
    String trainstartdate = Util.fromScreen(request.getParameter("trainstartdate_"+i),7) ; 
    String trainenddate = Util.fromScreen(request.getParameter("trainenddate_"+i),7) ; 
    String trainresource = Util.fromScreen(request.getParameter("trainresource_"+i),7) ;        
    String trainmemo = Util.fromScreen(request.getParameter("trainmemo_"+i),7) ; 
    
    String info = trainname+trainstartdate+trainenddate+trainresource+trainmemo;
    if(!info.trim().equals("")){
    para = ""+id+separator+trainname+separator+trainresource+separator+trainstartdate+separator+trainenddate+
    	    separator+trainmemo;
    	   
    rs.executeProc("HrmTrainBeforeWork_Insert",para);      	 
    }
  }
  
  sql = "delete from HrmRewardBeforeWork where resourceid = "+id;
  rs.executeSql(sql);
  int rewardrownum = Util.getIntValue(request.getParameter("trainrownum"),0);
  for(int i = 0;i<workrownum;i++){
    String rewardname = Util.fromScreen(request.getParameter("rewardname_"+i),7) ;     
    String rewarddate = Util.fromScreen(request.getParameter("rewarddate_"+i),7) ;     
    String rewardmemo = Util.fromScreen(request.getParameter("rewardmemo_"+i),7) ; 
    String info = rewardname+rewarddate+rewardmemo;
    if(!info.trim().equals("")){
    para = ""+id+separator+rewardname+separator+rewarddate+separator+rewardmemo;
    	   
    rs.executeProc("HrmRewardBeforeWork_Insert",para);      	 
    }
  }
  
  sql = "delete from HrmCertification where resourceid = "+id;
  rs.executeSql(sql);
  int cerrownum = Util.getIntValue(request.getParameter("cerrownum"),0);  
  for(int i = 0;i<cerrownum;i++){
    String cername = Util.fromScreen(request.getParameter("cername_"+i),7) ; 
    String cerstartdate = Util.fromScreen(request.getParameter("cerstartdate_"+i),7) ; 
    String cerenddate = Util.fromScreen(request.getParameter("cerenddate_"+i),7) ; 
    String cerresource = Util.fromScreen(request.getParameter("cerresource_"+i),7) ;           
    
    String info = cername+cerstartdate+cerenddate+cerresource;
    if(!info.trim().equals("")){
    para = ""+id+separator+cerstartdate +separator+cerenddate +separator+cername+separator+cerresource;    	   
    
    rs.executeProc("HrmCertification_Insert",para);      	 
    }
  }  
 if(operation.equals("addthree")){
   response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+id); 
 }else{
   response.sendRedirect("HrmCareerApplyWorkView.jsp?id="+id); 
 }
 return;
}

if(operation.equals("editper")){
  para = ""+id       + separator + birthday           + separator          + folk          + separator +
         nativeplace + separator + regresidentplace   + separator          + maritalstatus + separator +
         policy      + separator + bememberdate       + separator          + bepartydate   + separator +
         islabourunion+separator + educationlevel     + separator          + degree        + separator + 
         healthinfo  + separator + height             + separator          + weight        + separator + 
         residentplace+separator + tempresidentnumber + separator          + certificatenum;   
  rs.executeProc("HrmCareerApply_InsertPer",para);
  
  sql = "delete from HrmFamilyInfo where resourceid ="+id;
  rs.executeSql(sql);
  int rownum = Util.getIntValue(request.getParameter("rownum"),7) ;  
  for(int i = 0;i<rownum;i++){
    String member = Util.fromScreen(request.getParameter("member_"+i),7);
    String title = Util.fromScreen(request.getParameter("title_"+i),7);
    String company = Util.fromScreen(request.getParameter("company_"+i),7);
    String jobtitle_n = Util.fromScreen(request.getParameter("jobtitle_"+i),7);
    String address = Util.fromScreen(request.getParameter("address_"+i),7);
    String info = member+title+company+jobtitle_n+address;
    if(!(info.trim().equals(""))){
    para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle_n+separator+address;
    rs.executeProc("HrmFamilyInfo_Insert",para);  
    }
  }
  
  response.sendRedirect("HrmCareerApplyPerView.jsp?id="+id);
  return;
}

%>