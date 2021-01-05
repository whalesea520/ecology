
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.email.WeavermailUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<!--<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>-->
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
    char flag=Util.getSeparator();
    String ProcPara = "";

    String customerids = Util.null2String(request.getParameter("customerids"));
    int rownum = Util.getIntValue(request.getParameter("rownum"),0);

    String userid = "0" ;
    String departmentid = "0" ;
    String roleid = "0" ;
    String foralluser = "0" ;
    String subcompanyid = "0" ;

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
    String CurrentUser = ""+user.getUID();
    String ClientIP = request.getRemoteAddr();
    String SubmiterType = ""+user.getLogintype();


    StringTokenizer stk = new StringTokenizer(customerids,",");
    while(stk.hasMoreTokens()){
        String crmid = stk.nextToken();
        if(!crmid.trim().equals("")){

            /*
            RecordSet.executeProc("CRM_ShareInfo_SbyRelateditemid",crmid);
            while(RecordSet.next()){
                RecordSet2.executeProc("CRM_ShareInfo_Delete",RecordSet.getString("id"));

                ProcPara = crmid;
                ProcPara += flag+"ds";
                ProcPara += flag+"0";
                ProcPara += flag+RecordSet.getString("id");
                ProcPara += flag+CurrentDate;
                ProcPara += flag+CurrentTime;
                ProcPara += flag+CurrentUser;
                ProcPara += flag+SubmiterType;
                ProcPara += flag+ClientIP;
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                //CrmViewer.setCrmShareByCrm(""+crmid);
            }
            */

            for(int i=0; i<rownum; i++){
                String sharetype = request.getParameter("sharetype_"+i);
                if(sharetype != null){
                    String relatedshareid = Util.null2String(request.getParameter("shareid_"+i));
                    String rolelevel = Util.null2String(request.getParameter("rolelevel_"+i));
                    String seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel_"+i)) , Util.getIntValue(request.getParameter("seclevelMax_"+i)))+"";
                	String seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel_"+i)) , Util.getIntValue(request.getParameter("seclevelMax_"+i)))+"";

                	String jobdep = Util.null2String(request.getParameter("jobtitledepartment_"+i));
                	String jobsub = Util.null2String(request.getParameter("jobtitlesubcompany_"+i));
                	String joblevel = Util.null2String(request.getParameter("jobtitlelevel_"+i));
                	String scopeid ="";
                	
                    String sharelevel = Util.null2String(request.getParameter("sharelevel_"+i));
					

                    if(sharetype.equals("1")) userid = relatedshareid ;
                    if(sharetype.equals("2")) departmentid = relatedshareid ;
                    if(sharetype.equals("3")) roleid = relatedshareid ;
                    if(sharetype.equals("4")) foralluser = "1" ;
                    if(sharetype.equals("5")) subcompanyid = relatedshareid ;
                    
                    
                    ProcPara = crmid;
                    ProcPara += flag+sharetype;
                    ProcPara += flag+seclevel;
                    ProcPara += flag+seclevelMax;
                    ProcPara += flag+rolelevel;
                    ProcPara += flag+sharelevel;
                    ProcPara += flag+userid;
                    ProcPara += flag+departmentid;
                    ProcPara += flag+roleid;
                    ProcPara += flag+foralluser;
                    String tempcontents="";
                    if(sharetype.equals("1")) tempcontents = userid ;
                    if(sharetype.equals("2")) tempcontents = departmentid ;
                    if(sharetype.equals("3")) tempcontents = roleid ;
                    if(sharetype.equals("4")) tempcontents = "1" ;
                    if(sharetype.equals("5")) tempcontents = subcompanyid ;
                    if(sharetype.equals("6")) {
                    	tempcontents = relatedshareid ;	
                    	if(joblevel.equals("1"))scopeid = jobdep;
                    	if(joblevel.equals("2"))scopeid = jobsub;
                    	scopeid = ","+WeavermailUtil.trim(scopeid)+",";
                    }
                    ProcPara += flag+tempcontents;

                  	if(isShared(crmid,sharetype,seclevel,seclevelMax,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,tempcontents,relatedshareid,joblevel,scopeid)) continue;    //如果共享重复跳过
                    int sid = -1;
                    RecordSet.executeProc("CRM_ShareInfo_Insert",ProcPara);
                    if(sharetype.equals("6")) {
	                	RecordSet.execute("select max(id) from CRM_ShareInfo where relateditemid = "+crmid+" and userid = "+userid);
	                	
	                	if(RecordSet.next())
	                		sid = RecordSet.getInt(1);
	                	RecordSet.execute("update CRM_ShareInfo set jobtitleid='"+tempcontents+"', joblevel="+joblevel+", scopeid='"+scopeid+"' where id = "+sid);
                    }
                	
                    
                    //当前客户的客户联系共享给新的共享对象
                    RecordSet.executeSql("select max(id)  shareobjid from CRM_ShareInfo where relateditemid="+crmid+"  and contents="+tempcontents);
                    RecordSet.next();
                    String shareobjid = RecordSet.getString("shareobjid");
                    RecordSet.execute("update CRM_ShareInfo set subcompanyid="+subcompanyid+" where id="+shareobjid);
                    
                    if(sharetype.equals("3")){
                	    String crm_manager = "";
                	    RecordSet.executeSql("select manager from crm_customerinfo where id="+crmid);
                	    if(RecordSet.next()) crm_manager = RecordSet.getString("manager");
                	    int crm_manager_dept = Util.getIntValue(ResourceComInfo.getDepartmentID(crm_manager),-1);//部门id
                	    int crm_manager_com = Util.getIntValue(ResourceComInfo.getSubCompanyID(crm_manager),-1);//分部id
                	    if(rolelevel.equals("0"))
                	        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_dept+" where relateditemid="+crmid+" and id="+shareobjid);
                	    else if(rolelevel.equals("1"))
                	        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_com+" where relateditemid="+crmid+" and id="+shareobjid);
                	}
                    CrmShareBase.setCRM_WPShare_newCRMShare(crmid,shareobjid);
					
                    String Remark="sharetype:"+sharetype+"seclevel:"+seclevel+"rolelevel:"+rolelevel+"sharelevel:"+sharelevel+"userid:"+userid+"departmentid:"+departmentid+"subcompanyid:"+subcompanyid+"roleid:"+roleid+"foralluser:"+foralluser;
                	String content = "";
                    if(sharetype.equals("6")) {
	                	RecordSet.execute("select contents from CRM_ShareInfo where id = "+sid);
	                	if(RecordSet.next()){
	                		 content = RecordSet.getString("contents");
	                	}
	                	
	                	RecordSet.execute("update CRM_ShareInfo set jobtitleid='"+content+"',scopeid='"+scopeid+"' where id = "+sid);
                    }
                   
                    ProcPara = crmid;
                    ProcPara += flag+"ns";
                    ProcPara += flag+"0";
                    ProcPara += flag+Remark;
                    ProcPara += flag+CurrentDate;
                    ProcPara += flag+CurrentTime;
                    ProcPara += flag+CurrentUser;
                    ProcPara += flag+SubmiterType;
                    ProcPara += flag+ClientIP;
                    RecordSet.executeProc("CRM_Log_Insert",ProcPara);
					
                    /*
                    CrmViewer.setCrmShareByCrm(""+crmid);
                    */

                }
            }
        }
    }
     response.sendRedirect("ShareMutiCustomerList.jsp?isstart=1");
%>
<%!
	private boolean isShared(String crmid,String sharetype,String seclevel,String seclevelMax,String rolelevel,String sharelevel,String userid,String departmentid,String roleid,String foralluser,String tempcontents,String jobtitleid,String joblevel,String scopeid) {
	  	RecordSet reSet =new RecordSet();
		String seclevelwhere = " and seclevel = "+seclevel;
		String useridwhere = " and userid = "+userid;
		String roleidwhere = " and roleid = "+roleid;
		String foralluserwhere = " and foralluser = "+foralluser;
		String rolelevelwhere = " and rolelevel = "+rolelevel;
		if(seclevel == null || "".equals(seclevel))
			seclevelwhere = " and seclevel is null ";
		if(userid == null || "".equals(userid))
			useridwhere = " and userid is null ";
		if(roleid == null || "".equals(roleid))
			roleidwhere = " and roleid is null ";
		if(foralluser == null || "".equals(foralluser))
			foralluserwhere = " and foralluser is null ";
		if(rolelevel == null || "".equals(rolelevel))
			rolelevelwhere = " and rolelevel is null ";
		
		
		String jobtitleidwhere = " and jobtitleid = '"+jobtitleid+"'";
		if(jobtitleid == null || "".equals(jobtitleid))
			jobtitleidwhere = " and jobtitleid is null ";
		String joblevelwhere = " and joblevel = "+joblevel;
		if(joblevel == null || "".equals(joblevel))
			joblevelwhere = " and joblevel is null ";
		String scopeidwhere = " and scopeid = "+scopeid;
		if(scopeid == null || "".equals(scopeid))
			scopeidwhere = " and scopeid is null ";
		
		String selsql = "select id from CRM_ShareInfo where relateditemid = "+crmid+" and contents = "+tempcontents+" and sharetype = "+sharetype+
			seclevelwhere+" and seclevelMax = "+seclevelMax+" and sharelevel = "+sharelevel + useridwhere + roleidwhere + foralluserwhere +rolelevelwhere+jobtitleidwhere+joblevelwhere+scopeidwhere;
		reSet.execute(selsql);
		if(reSet.next()) {
			return true;
		}	
		return false;
	}

%>