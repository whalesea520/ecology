<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmDateCheck" class="weaver.hrm.tools.HrmDateCheck" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%
        String operation = Util.null2String(request.getParameter("operation"));  
        char separator = Util.getSeparator() ;  
        String para = "" ;

    if(operation.equalsIgnoreCase("AddCheckKindinfo")){ 
        String id = Util.null2String(request.getParameter("id"));
        String kindname = Util.fromScreen(request.getParameter("kindname"),user.getLanguage()) ; /*考核种类名称*/ 
        String checkcycle = Util.fromScreen(request.getParameter("checkcycle"),user.getLanguage()) ;/*周期*/
        String checkexpecd = Util.fromScreen(request.getParameter("checkexpecd"),user.getLanguage()) ;/*考核期*/  
        String checkstartdate = Util.fromScreen(request.getParameter("checkstartdate"),user.getLanguage()) ;/*考核开始日期*/
        
        
        para = kindname + separator + checkcycle + separator + checkexpecd + separator + checkstartdate ;
        rs.executeProc("HrmCheckKind_Insert",para);
        
        int trainrownum = Util.getIntValue(request.getParameter("trainrownum"),0);


        String sql="select max(id) from HrmCheckKind ";
        rs.executeSql(sql) ;
        rs.next();
        String checktypeid = rs.getString(1);
        
            for(int i = 0;i<trainrownum;i++){
            String jobid = Util.fromScreen(request.getParameter("jobid_"+i),user.getLanguage()) ; /*岗位ID*/
            String deptid = "";//Util.fromScreen(request.getParameter("deptid_"+i),user.getLanguage()) ; /*部门ID*/
            String subcid = "";//Util.fromScreen(request.getParameter("subcid_"+i),user.getLanguage()) ; /*机构ID*/
            String info = checktypeid + jobid;
                if(!checktypeid.equals("")&&!jobid.equals("") && !jobid.equals("0")){
                	rs.executeSql("select a.jobdepartmentid,b.subcompanyid1 from HrmJobTitles a left join HrmDepartment b on a.jobdepartmentid = b.id left join HrmSubCompany c on b.subcompanyid1 = c.id where a.id = "+jobid);
	            	rs.next();
                	deptid = String.valueOf(Util.getIntValue(rs.getString("jobdepartmentid"),0));
                	subcid = String.valueOf(Util.getIntValue(rs.getString("subcompanyid1"),0));
                    para =checktypeid + separator + jobid + separator + deptid + separator + subcid ;
                    rs.executeProc("HrmCheckPost_Insert",para);      	 
                }
            }

        int cerrownum = Util.getIntValue(request.getParameter("cerrownum"),0);
            for(int i = 0;i<cerrownum;i++){
            String checkitemid = Util.fromScreen(request.getParameter("checkitemid_"+i),user.getLanguage()) ; /*考核项ID*/
            String checkitemproportion = Util.fromScreen(request.getParameter("checkitemproportion_"+i),user.getLanguage()) ; /*考核项权重*/
            String info = checktypeid + checkitemid + checkitemproportion ;
                if(!checkitemid.equals("") && !checkitemid.equals("0") && !checkitemproportion.equals("") && !checkitemproportion.equals("0")){
                    para =checktypeid + separator + checkitemid + separator + checkitemproportion ;    	   
                    rs.executeProc("HrmCheckKindItem_Insert",para);

                }
            }

        int rewardrownum = Util.getIntValue(request.getParameter("rewardrownum"),0);
        String typeid ="";
        //String tt="";

            for(int i = 0;i<rewardrownum;i++){
            typeid =  Util.fromScreen(request.getParameter("typeid_"+i),user.getLanguage()) ; /*类型*/
            
            String resourceid = Util.fromScreen(request.getParameter("resourceid_"+i),user.getLanguage()) ;/*员工ID*/ 
            String checkproportion = Util.fromScreen(request.getParameter("checkproportion_"+i),user.getLanguage()) ;/*考核权重*/
            String info = checktypeid + typeid + resourceid + checkproportion;

                if((!typeid.equals("7") && !checkproportion.equals("") && !checkproportion.equals("0")) || (typeid.equals("7") && !resourceid.equals("") && !resourceid.equals("0") &&  !checkproportion.equals("") && !checkproportion.equals("0"))){
                    para =checktypeid + separator + typeid + separator + resourceid + separator + checkproportion;    
                    rs.executeProc("HrmCheckActor_Insert",para);                    
                    //tt += ","+typeid;
                 }
                
            }
         
        //tt =tt.substring(1);
        //HrmDateCheck.setTypeid(tt);

		SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(checktypeid));
        SysMaintenanceLog.setRelatedName(kindname);
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("HrmCheckKind_Insert,"+para);
        SysMaintenanceLog.setOperateItem("97");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
     
        response.sendRedirect("/hrm/check/HrmCheckKindAdd.jsp?isclose=1");
        return;
    }


    if(operation.equalsIgnoreCase("EditCheckKindinfo")){ 
        if(!HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
        String sql = "" ; 
        String id = Util.null2String(request.getParameter("id"));
        String kindname = Util.fromScreen(request.getParameter("kindname"),user.getLanguage()) ;  
        String checkcycle = Util.fromScreen(request.getParameter("checkcycle"),user.getLanguage()) ;  
        String checkexpecd = Util.fromScreen(request.getParameter("checkexpecd"),user.getLanguage()) ;
        String checkstartdate = Util.fromScreen(request.getParameter("checkstartdate"),user.getLanguage()) ;  
                        

        para =id + separator + kindname + separator + checkcycle + separator + checkexpecd + separator + checkstartdate;
        rs.executeProc("HrmCheckKind_Update",para);

        /*岗位*/
        
  

        int trainrownum = Util.getIntValue(request.getParameter("trainrownum"),0); 
        sql = "delete from HrmCheckPost where checktypeid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<trainrownum;i++){
                
            String jobid = Util.fromScreen(request.getParameter("jobid_"+i),user.getLanguage()) ; 
            String deptid = "";//Util.fromScreen(request.getParameter("deptid_"+i),user.getLanguage()) ; /*部门ID*/
            String subcid = "";//Util.fromScreen(request.getParameter("subcid_"+i),user.getLanguage()) ; /*机构ID*/
             if(!jobid.equals("") && !jobid.equals("0")){
            	rs.executeSql("select a.jobdepartmentid,b.subcompanyid1 from HrmJobTitles a left join HrmDepartment b on a.jobdepartmentid = b.id left join HrmSubCompany c on b.subcompanyid1 = c.id where a.id = "+jobid);
            	rs.next();
               	deptid = String.valueOf(Util.getIntValue(rs.getString("jobdepartmentid"),0));
               	subcid = String.valueOf(Util.getIntValue(rs.getString("subcompanyid1"),0));
               	para =id + separator + jobid + separator + deptid + separator + subcid ;
                rs.executeProc("HrmCheckPost_Insert",para);
            }
        }

        /*考核种类项目*/

        int cerrownum = Util.getIntValue(request.getParameter("cerrownum"),0);
        sql = "delete from HrmCheckKindItem where checktypeid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<cerrownum;i++){
            String checkitemid = Util.fromScreen(request.getParameter("checkitemid_"+i),user.getLanguage()) ; 
            String checkitemproportion = Util.fromScreen(request.getParameter("checkitemproportion_"+i),user.getLanguage()) ; 
            String info = checkitemid + checkitemproportion;
            if(!checkitemid.equals("") && !checkitemid.equals("0") && !checkitemproportion.equals("") && !checkitemproportion.equals("0") ){
                para = id + separator + checkitemid + separator + checkitemproportion ;
                rs.executeProc("HrmCheckKindItem_Insert",para);      	 
            }
        }

        /*考核参与人*/

        int rewardrownum = Util.getIntValue(request.getParameter("rewardrownum"),0);
        sql = "delete from HrmCheckActor where checktypeid = "+id;
        rs.executeSql(sql);

        for(int i = 0;i<rewardrownum;i++){
            String typeid = Util.fromScreen(request.getParameter("typeid_"+i),user.getLanguage()) ;     
            String resourceid = Util.fromScreen(request.getParameter("resourceid_"+i),user.getLanguage()) ;
            String checkproportion = Util.fromScreen(request.getParameter("checkproportion_"+i),user.getLanguage()) ;
            if((!typeid.equals("7") && !checkproportion.equals("") && !checkproportion.equals("0")) || (typeid.equals("7") && !resourceid.equals("") && !resourceid.equals("0") &&  !checkproportion.equals("") && !checkproportion.equals("0")) ){
               
                para =id + separator + typeid + separator + resourceid + separator + checkproportion;
                rs.executeProc("HrmCheckActor_Insert",para);  
                
            }
        }
		SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(kindname);
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("HrmCheckKind_Update,"+para);
        SysMaintenanceLog.setOperateItem("97");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();


        response.sendRedirect("/hrm/check/HrmCheckKindEdit.jsp?isclose=1&id="+id); 
        return;
    }
	

	if(operation.equalsIgnoreCase("DeleteCheckKindinfo")){ 
		if(!HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
		}
        String sql = "" ; 
		String kindname = Util.fromScreen(request.getParameter("kindname"),user.getLanguage()) ;  
        String id = Util.null2String(request.getParameter("id"));
        rs.executeSql("select kindname from HrmCheckKind where id = "+id);
		if(rs.next()){
			kindname = Util.null2String(rs.getString("kindname"));
		}

		/*考核种类*/    
        sql = "delete from HrmCheckKind where id = "+id;
        rs.executeSql(sql);
		SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(kindname);
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc(sql);
        SysMaintenanceLog.setOperateItem("97");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();

        
		
        /*岗位*/    
        sql = "delete from HrmCheckPost where checktypeid = "+id;
        rs.executeSql(sql);

		/*考核种类项目*/
		sql = "delete from HrmCheckKindItem where checktypeid = "+id;
        rs.executeSql(sql);

		/*考核参与人*/
		sql = "delete from HrmCheckActor where checktypeid = "+id;
        rs.executeSql(sql);
		response.sendRedirect("/hrm/check/HrmCheckKind.jsp"); 
        return;
		
    }
	


    if(operation.equalsIgnoreCase("AddCheck")){ 
        String id = Util.null2String(request.getParameter("id"));
        int cerrownum = Util.getIntValue(request.getParameter("cerrownum"),0);
        for(int i = 0;i<cerrownum;i++){
        String resourceid = Util.fromScreen(request.getParameter("resourceid_"+i),user.getLanguage()) ; 
        String itemid = Util.fromScreen(request.getParameter("itemid_"+i),user.getLanguage()) ;
        String result = Util.fromScreen(request.getParameter("result_"+i),user.getLanguage()) ;
        String sql="select max(id) from HrmCheckKind ";
        rs.executeSql(sql) ;
        rs.next();
        String checktypeid = rs.getString(1);
        String info = resourceid + checktypeid + itemid + result ;
            if(!info.trim().equals("")){
                para =resourceid + separator+ checktypeid + separator + itemid + separator + result ;    	   
                rs.executeProc("HrmCheckGrade_Insert",para);

            }
        }

        response.sendRedirect("/hrm/check/HrmCheck.jsp"); 
        return;

    }

if(operation.equalsIgnoreCase("EditCheck")){ 
            String id = Util.null2String(request.getParameter("id"));
            int cerrownum = Util.getIntValue(request.getParameter("cerrownum"),0);
            for(int i = 0;i<cerrownum;i++){
                String resourceid = Util.fromScreen(request.getParameter("resourceid_"+i),user.getLanguage()) ; 
                String itemid = Util.fromScreen(request.getParameter("itemid_"+i),user.getLanguage()) ;
                String result = Util.fromScreen(request.getParameter("result_"+i),user.getLanguage()) ;
                String sql="select max(id) from HrmCheckKind ";
                rs.executeSql(sql) ;
                rs.next();
                String checktypeid = rs.getString(1);
                String info = resourceid + checktypeid + itemid + result ;
                if(!info.trim().equals("")){
                    para =resourceid + separator+ checktypeid + separator + itemid + separator + result ;    	   
                    rs.executeProc("HrmCheckGrade_Update",para);

                }
            }

            response.sendRedirect("/hrm/check/HrmCheck.jsp"); 
            return;
    }
%>