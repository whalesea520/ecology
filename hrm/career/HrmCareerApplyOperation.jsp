
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
FileUpload fu = new FileUpload(request);

String operation = Util.null2String(fu.getParameter("operation"));
char separator = Util.getSeparator() ;
int userid = user.getUID();
Calendar todaycal = Calendar.getInstance ();
String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String userpara = ""+userid+separator+today;
String sql = "";
String para = "";

String id = Util.fromScreen(fu.getParameter("id"),user.getLanguage());
String inviteid = Util.fromScreen(fu.getParameter("careerinvite"),user.getLanguage()) ;//招聘信息id

String lastname = Util.fromScreen(fu.getParameter("lastname"),user.getLanguage()) ;
String sex = Util.fromScreen(fu.getParameter("sex"),user.getLanguage()) ;
String jobtitle = Util.null2String(fu.getParameter("jobtitle"));//招聘岗位
int picture=Util.getIntValue(fu.uploadFiles("picture"),0);/*照片*/
String homepage = Util.fromScreen(fu.getParameter("homepage"),user.getLanguage()) ;
String email = Util.fromScreen(fu.getParameter("email"),user.getLanguage()) ;
String homeaddress = Util.fromScreen(fu.getParameter("homeaddress"),user.getLanguage()) ;	/*家庭地址*/
String homepostcode = Util.fromScreen(fu.getParameter("homepostcode"),user.getLanguage()) ;/*家庭邮编*/
String homephone = Util.fromScreen(fu.getParameter("homephone"),user.getLanguage()) ;	/*家庭电话*/

String category = Util.fromScreen(fu.getParameter("category"),user.getLanguage()) ;
String contactor = Util.fromScreen(fu.getParameter("contactor"),user.getLanguage()) ;/*联系人*/
String salarynow = Util.fromScreen(fu.getParameter("salarynow"),user.getLanguage()) ;/*当前年薪*/
//System.out.println("salarynowAAAAAA:"+salarynow);
String worktime = Util.fromScreen(fu.getParameter("worktime"),user.getLanguage()) ;/*工作年限*/
String salaryneed = Util.fromScreen(fu.getParameter("salaryneed"),user.getLanguage()) ;/*年薪低限*/
//System.out.println("salaryneedBBBBBB:"+salaryneed);
String currencyid = Util.fromScreen(fu.getParameter("currencyid"),user.getLanguage()) ;/*币种*/
String reason = Util.fromScreen(fu.getParameter("reason"),user.getLanguage()) ;/**/
String otherrequest = Util.fromScreen(fu.getParameter("otherrequest"),user.getLanguage()) ;/**/
String selfcomment = Util.fromScreen(fu.getParameter("selfcomment"),user.getLanguage()) ;/*自荐书*/

String birthday = Util.fromScreen(fu.getParameter("birthday"),user.getLanguage());
String folk = Util.fromScreen(fu.getParameter("folk"),user.getLanguage()) ;	 /*民族*/
String nativeplace = Util.fromScreen(fu.getParameter("nativeplace"),user.getLanguage()) ;	/*籍贯*/
String regresidentplace = Util.fromScreen(fu.getParameter("regresidentplace"),user.getLanguage()) ;	/*户口所在地*/
String maritalstatus = Util.fromScreen(fu.getParameter("maritalstatus"),user.getLanguage());
String policy = Util.fromScreen(fu.getParameter("policy"),user.getLanguage()) ; /*政治面貌*/
String bememberdate = Util.fromScreen(fu.getParameter("bememberdate"),user.getLanguage()) ;	/*入团日期*/
String bepartydate = Util.fromScreen(fu.getParameter("bepartydate"),user.getLanguage()) ;	/*入党日期*/
String islabourunion = Util.fromScreen(fu.getParameter("islabouunion"),user.getLanguage()) ;
String educationlevel = Util.fromScreen(fu.getParameter("educationlevel"),user.getLanguage()) ;/*学历*/
String degree = Util.fromScreen(fu.getParameter("degree"),user.getLanguage()) ; /*学位*/
String healthinfo = Util.fromScreen(fu.getParameter("healthinfo"),user.getLanguage()) ;/*健康状况*/
String height = Util.fromScreen(fu.getParameter("height"),user.getLanguage()) ;/*身高*/
String weight = Util.fromScreen(fu.getParameter("weight"),user.getLanguage()) ;
height = (height.equals("")?"0":height)   ;
weight = (weight.equals("")?"0":weight)   ;

String residentplace = Util.fromScreen(fu.getParameter("residentplace"),user.getLanguage()) ;	/*现居住地*/
String tempresidentnumber = Util.fromScreen(fu.getParameter("tempresidentnumber"),user.getLanguage()) ;
String certificatenum = Util.fromScreen(fu.getParameter("certificatenum"),user.getLanguage()) ;/*证件号码*/

String  subCompanyId=Util.null2String(request.getParameter("subCompanyId"));/*分部ID*/
String  departmentid  = "";
if(subCompanyId.equals("")){
	departmentid=JobTitlesComInfo.getDepartmentid(jobtitle);
	subCompanyId = DepartmentComInfo.getSubcompanyid1(departmentid);
}

/*Add By Charoes Huang For Bug 260.
 *将数字类型的空字符串转换为0
*/
/*
salarynow = String.valueOf(Util.getFloatValue(salarynow,0) );
float salarynow1 = Util.getFloatValue(salarynow,0);*/
worktime = String.valueOf(Util.getIntValue(worktime,0));
/*
salaryneed = String.valueOf(Util.getFloatValue(salaryneed,0));
float salaryneed1 = Util.getFloatValue(salaryneed,0);
*/
if(operation.equals("add")){

  rs.executeProc("HrmResourceMaxId_Get","");
  rs.next();
  int ID = rs.getInt(1);
  id = ""+rs.getInt(1);
  para = id          + separator + lastname     + separator + sex       + separator+
         jobtitle    + separator + homepage     + separator + email     + separator+
         homeaddress + separator + homepostcode + separator + homephone + separator+
		 inviteid    + separator + picture		+ separator + subCompanyId;

  rs.executeProc("HrmCareerApply_InsertBasic",para);
  rs.executeProc("HrmCareerApply_CreateInfo",""+id+separator+userpara+separator+userpara);

  para = id        + separator + category     + separator + contactor   + separator+
         salarynow + separator + worktime     + separator + salaryneed  + separator+
         currencyid+ separator + reason       + separator + otherrequest+ separator+selfcomment ;
  rs.executeProc("HrmCareerApplyOtherIndo_In",para);

  try{
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(ID);
      SysMaintenanceLog.setRelatedName(lastname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmCareerApply_InsertBasic,");
      SysMaintenanceLog.setOperateItem("59");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	}catch(Exception e){

	}
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
  rs.executeProc("HrmCareerApply_ModInfo",""+id+separator+userpara);

  int rownum = Util.getIntValue(fu.getParameter("rownum"),user.getLanguage()) ;
  for(int i = 0;i<rownum;i++){
    String member = Util.fromScreen(fu.getParameter("member_"+i),user.getLanguage());
    String title = Util.fromScreen(fu.getParameter("title_"+i),user.getLanguage());
    String company = Util.fromScreen(fu.getParameter("company_"+i),user.getLanguage());
    String jobtitle_n = Util.fromScreen(fu.getParameter("jobtitle_"+i),user.getLanguage());
    String address = Util.fromScreen(fu.getParameter("address_"+i),user.getLanguage());
    String info = member+title+company+jobtitle_n+address;
    if(!(info.trim().equals(""))){
    para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle_n+separator+address;
    rs.executeProc("HrmFamilyInfo_Insert",para);
    }
  }
        //处理自定义字段 add by yshxu
	CustomFieldTreeManager.editCustomData("CareerCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
	CustomFieldTreeManager.editMutiCustomData("CareerCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
  
  response.sendRedirect("HrmCareerApplyAddThree.jsp?id="+id);
  return;
}

if(operation.equals("addthree")||operation.equals("editwork")){
  rs.executeProc("HrmCareerApply_ModInfo",""+id+separator+userpara);
  sql = "delete from HrmEducationInfo where resourceid = "+id;
  rs.executeSql(sql);
  int edurownum = Util.getIntValue(fu.getParameter("edurownum"),0);
  for(int i = 0;i<edurownum;i++){
    String school = Util.fromScreen(fu.getParameter("school_"+i),user.getLanguage()) ;
    String speciality = Util.fromScreen(fu.getParameter("speciality_"+i),user.getLanguage()) ;
    String edustartdate = Util.fromScreen(fu.getParameter("edustartdate_"+i),user.getLanguage()) ;
    String eduenddate = Util.fromScreen(fu.getParameter("eduenddate_"+i),user.getLanguage()) ;
    String educationlevel_n = Util.fromScreen(fu.getParameter("educationlevel_"+i),user.getLanguage()) ;
    String studydesc = Util.fromScreen(fu.getParameter("studydesc_"+i),user.getLanguage()) ;

    String info = school+speciality+edustartdate+eduenddate+educationlevel_n+studydesc;
    if(!info.trim().equals("")){
    para = ""+id+separator+edustartdate+separator+eduenddate+separator+school+separator+speciality+
    	    separator+educationlevel_n+separator+studydesc;
    rs.executeProc("HrmEducationInfo_Insert",para);
    }
  }

  sql = "delete from HrmLanguageAbility where resourceid = "+id;
  rs.executeSql(sql);
  int lanrownum = Util.getIntValue(fu.getParameter("lanrownum"),0);
  for(int i = 0;i<lanrownum;i++){
    String language = Util.fromScreen(fu.getParameter("language_"+i),user.getLanguage()) ;
    String level = Util.fromScreen(fu.getParameter("level_"+i),user.getLanguage()) ;
    String memo = Util.fromScreen(fu.getParameter("memo_"+i),user.getLanguage()) ;
	String info = language+memo;
	if(!info.trim().equals("")){
    para = ""+id+separator+language+separator+level+separator+memo;
    rs.executeProc("HrmLanguageAbility_Insert",para);
	}
  }

  sql = "delete from HrmWorkResume where resourceid = "+id;
  rs.executeSql(sql);
  int workrownum = Util.getIntValue(fu.getParameter("workrownum"),0);
  for(int i = 0;i<workrownum;i++){
    String company = Util.fromScreen(fu.getParameter("company_"+i),user.getLanguage()) ;
    String workstartdate = Util.fromScreen(fu.getParameter("workstartdate_"+i),user.getLanguage()) ;
    String workenddate = Util.fromScreen(fu.getParameter("workenddate_"+i),user.getLanguage()) ;
    String jobtitle_n = Util.fromScreen(fu.getParameter("jobtitle_"+i),user.getLanguage()) ;
    String workdesc = Util.fromScreen(fu.getParameter("workdesc_"+i),user.getLanguage()) ;
    String leavereason = Util.fromScreen(fu.getParameter("leavereason_"+i),user.getLanguage()) ;

    String info = company+workstartdate+workenddate+jobtitle_n+workdesc+leavereason;
    if(!info.trim().equals("")){
    para = ""+id+separator+workstartdate+separator+workenddate+separator+company+separator+jobtitle_n+
    	    separator+workdesc+separator+leavereason;
    rs.executeProc("HrmWorkResume_Insert",para);
    }
  }

  sql = "delete from HrmTrainBeforeWork where resourceid = "+id;
  rs.executeSql(sql);
  int trainrownum = Util.getIntValue(fu.getParameter("trainrownum"),0);
  for(int i = 0;i<workrownum;i++){
    String trainname = Util.fromScreen(fu.getParameter("trainname_"+i),user.getLanguage()) ;
    String trainstartdate = Util.fromScreen(fu.getParameter("trainstartdate_"+i),user.getLanguage()) ;
    String trainenddate = Util.fromScreen(fu.getParameter("trainenddate_"+i),user.getLanguage()) ;
    String trainresource = Util.fromScreen(fu.getParameter("trainresource_"+i),user.getLanguage()) ;
    String trainmemo = Util.fromScreen(fu.getParameter("trainmemo_"+i),user.getLanguage()) ;

    String info = trainname+trainstartdate+trainenddate+trainresource+trainmemo;
    if(!info.trim().equals("")){
    para = ""+id+separator+trainname+separator+trainresource+separator+trainstartdate+separator+trainenddate+
    	    separator+trainmemo;

    rs.executeProc("HrmTrainBeforeWork_Insert",para);
    }
  }

  sql = "delete from HrmRewardBeforeWork where resourceid = "+id;
  rs.executeSql(sql);
  int rewardrownum = Util.getIntValue(fu.getParameter("trainrownum"),0);
  for(int i = 0;i<workrownum;i++){
    String rewardname = Util.fromScreen(fu.getParameter("rewardname_"+i),user.getLanguage()) ;
    String rewarddate = Util.fromScreen(fu.getParameter("rewarddate_"+i),user.getLanguage()) ;
    String rewardmemo = Util.fromScreen(fu.getParameter("rewardmemo_"+i),user.getLanguage()) ;
    String info = rewardname+rewarddate+rewardmemo;
    if(!info.trim().equals("")){
    para = ""+id+separator+rewardname+separator+rewarddate+separator+rewardmemo;

    rs.executeProc("HrmRewardBeforeWork_Insert",para);
    }
  }

  sql = "delete from HrmCertification where resourceid = "+id;
  rs.executeSql(sql);
  int cerrownum = Util.getIntValue(fu.getParameter("cerrownum"),0);
  for(int i = 0;i<cerrownum;i++){
    String cername = Util.fromScreen(fu.getParameter("cername_"+i),user.getLanguage()) ;
    String cerstartdate = Util.fromScreen(fu.getParameter("cerstartdate_"+i),user.getLanguage()) ;
    String cerenddate = Util.fromScreen(fu.getParameter("cerenddate_"+i),user.getLanguage()) ;
    String cerresource = Util.fromScreen(fu.getParameter("cerresource_"+i),user.getLanguage()) ;

    String info = cername+cerstartdate+cerenddate+cerresource;
    if(!info.trim().equals("")){
    para = ""+id+separator+cerstartdate +separator+cerenddate +separator+cername+separator+cerresource;

    rs.executeProc("HrmCertification_Insert",para);
    }
  }
  
        //处理自定义字段 add by yshxu
	CustomFieldTreeManager.editCustomData("CareerCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
	CustomFieldTreeManager.editMutiCustomData("CareerCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
	
 if(operation.equals("addthree")){
   response.sendRedirect("/hrm/career/HrmCareerApplyEdit.jsp?applyid="+id);
 }else{
   response.sendRedirect("/hrm/career/HrmCareerApplyWorkView.jsp?id="+id);
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
  
  rs.executeProc("HrmCareerApply_ModInfo",""+id+separator+userpara);
  sql = "delete from HrmFamilyInfo where resourceid ="+id;
  rs.executeSql(sql);
  int rownum = Util.getIntValue(fu.getParameter("rownum"),user.getLanguage()) ;
  for(int i = 0;i<rownum;i++){
    String member = Util.fromScreen(fu.getParameter("member_"+i),user.getLanguage());
    String title = Util.fromScreen(fu.getParameter("title_"+i),user.getLanguage());
    String company = Util.fromScreen(fu.getParameter("company_"+i),user.getLanguage());
    String jobtitle_n = Util.fromScreen(fu.getParameter("jobtitle_"+i),user.getLanguage());
    String address = Util.fromScreen(fu.getParameter("address_"+i),user.getLanguage());
    String info = member+title+company+jobtitle_n+address;
    if(!(info.trim().equals(""))){
    para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle_n+separator+address;
    rs.executeProc("HrmFamilyInfo_Insert",para);
    }
  }
  
        //处理自定义字段 add by yshxu
	CustomFieldTreeManager.editCustomData("CareerCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
	CustomFieldTreeManager.editMutiCustomData("CareerCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
  
  response.sendRedirect("HrmCareerApplyPerView.jsp?id="+id);
  return;
}

if(operation.equals("saveApply") ){
	int pictureold= Util.getIntValue(fu.getParameter("pictureold"),0);
	if(picture<1){
		picture=pictureold;
	}
   int applyid = Util.getIntValue(fu.getParameter("applyid"),0);
   if(applyid!=0){
        para = applyid+""  + separator + lastname     + separator + sex       + separator+
            jobtitle    + separator + homepage     + separator + email     + separator+
            homeaddress + separator + homepostcode + separator + homephone + separator+
            inviteid    + separator + picture;
        rs.executeProc("HrmCareerApply_UpdateBasic",para);


        para = applyid+"" + separator + category     + separator + contactor   + separator+
            salarynow + separator + worktime     + separator + salaryneed  + separator+
            currencyid+ separator + reason       + separator + otherrequest+ separator+selfcomment ;
        rs.executeSql("Select Count(ID) as Count From HrmCareerApplyOtherInfo WHERE applyid ="+applyid);
        rs.next();
        if(rs.getInt("Count")>0 )
            rs.executeProc("HrmCareerApplyOtherInfo_Upd",para);
			
        else
            rs.executeProc("HrmCareerApplyOtherIndo_In",para);
		//System.out.println("HrmCareerApplyOtherInfo_Upd:"+salaryneed);

       try{
          SysMaintenanceLog.resetParameter();
          SysMaintenanceLog.setRelatedId(applyid);
          SysMaintenanceLog.setRelatedName(lastname);
          SysMaintenanceLog.setOperateType("2");
          SysMaintenanceLog.setOperateDesc("HrmCareerApply_UpdateBasic,");
          SysMaintenanceLog.setOperateItem("59");
          SysMaintenanceLog.setOperateUserid(user.getUID());
          SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
          SysMaintenanceLog.setSysLogInfo();
        }catch(Exception e){

        }

       response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+applyid);
   }
   else
    response.sendRedirect("/notice/noright.jsp") ;
}
if(operation.equals("delpic")){
	int applyid = Util.getIntValue(fu.getParameter("applyid"),0);
	String pictureold= Util.null2String(fu.getParameter("pictureold"));
	rs.executeSql("update HrmCareerApply set picture=0 where id="+applyid);
  rs.executeSql("delete from ImageFile where imagefileid="+pictureold);
	response.sendRedirect("HrmCareerApplyEditDo.jsp?applyid="+applyid);
	return ;
}
%>