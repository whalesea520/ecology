
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
int userid=user.getUID();

int wfid = 0;
boolean flag = true;
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
String[] value;
String[] value1;
char separ = Util.getSeparator();
String Procpara = "";

	String monitorhrmid = "";
    String  actionKey = request.getParameter("actionKey");//added by xwj for td2903 20051020
    String  monitorhrmids = Util.null2String(request.getParameter("monitorhrmids"));
    String  typeids = Util.null2String(request.getParameter("typeids"));
    String jktype = Util.null2String(request.getParameter("jktype"));
    String jkvalue = "";
    String fwtype = "";
    String fwvalue = "";
    String jkfw1 = Util.null2String(request.getParameter("jkfw1"));
    String jkfw2 = Util.null2String(request.getParameter("jkfw2"));
    String subcompanyids = Util.null2String(request.getParameter("subcompanyids"));
    String departmentids = Util.null2String(request.getParameter("departmentids"));
    String hrmids_fw = Util.null2String(request.getParameter("hrmids_fw"));
    String hrmmanageids = Util.null2String(request.getParameter("hrmmanageids"));
    String hrmids = Util.null2String(request.getParameter("hrmids"));
    String roleids = Util.null2String(request.getParameter("roleids"));
    if("1".equals(jktype)){
    	jkvalue = hrmids;
    	fwtype = jkfw1;
    }
    if("2".equals(jktype)){
    	jkvalue = roleids;
    	fwtype = jkfw1;
    }
    if("3".equals(jktype)){
    	jkvalue = hrmmanageids;
    	fwtype = jkfw2;
    }
    if("4".equals(fwtype)){
    	fwvalue = subcompanyids;
    }
    if("7".equals(fwtype)){
    	fwvalue = departmentids;
    }
    if("10".equals(fwtype)){
    	fwvalue = hrmids_fw;
    }
    int infoid = Util.getIntValue(request.getParameter("infoid"),-1);
    int monitortypeid = Util.getIntValue(request.getParameter("monitortypeid"),0);
    int temptypeid = Util.getIntValue(request.getParameter("typeid"),0);
    int oldmonitorhrmid = Util.getIntValue(request.getParameter("oldmonitorhrmid"),0);
    int oldmonitortypeid = Util.getIntValue(request.getParameter("oldmonitortypeid"),0);
    int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
    int oldsubcompanyid = Util.getIntValue(request.getParameter("oldsubcompanyid"),0);
    int ischeckall = Util.getIntValue(request.getParameter("checkall"),0);
    int viewcheckall = Util.getIntValue(request.getParameter("viewcheckall"),0);
    int intervenorcheckall = Util.getIntValue(request.getParameter("intervenorcheckall"),0);
    String queryTypeid = Util.null2String(request.getParameter("queryTypeid"));
    int detachable = 0;
    if(manageDetachComInfo.isUseWfManageDetach())
    	detachable = 1;
   
    int delcheckall = Util.getIntValue(request.getParameter("delcheckall"),0);
    int fbcheckall = Util.getIntValue(request.getParameter("fbcheckall"),0);
    int focheckall = Util.getIntValue(request.getParameter("focheckall"),0);
    int socheckall = Util.getIntValue(request.getParameter("socheckall"),0);
    int isview=0;
    int isintervenor=0;
    int isdelete=0;
    int isfb=0;
    int isfo=0;
    int isso = 0;
    ArrayList isviewlist=new ArrayList();
    ArrayList isintervenorlist=new ArrayList();
    ArrayList isdellist=new ArrayList();
    ArrayList isfblist=new ArrayList();
    ArrayList isfolist=new ArrayList();
    ArrayList issolist = new ArrayList();
    
  //获取workflow_monitor_info的id
	 boolean newflag = false;
	 int monitortypeid_old = 0;
     if(infoid == -1)
    	 newflag = true;
     else{
    	 //查询更新前的monitortypeid
    	 rs.execute("select monitortype from workflow_monitor_info where id = " + infoid);
    	 if(rs.next())
    		 monitortypeid_old = Util.getIntValue(rs.getString(1),0);
     }
     if(newflag){
    	 if(rs.getDBType().equals("oracle")){
		     rs.execute("select monitor_infoid.nextval from dual");
			 rs.next();
			 infoid = rs.getInt(1);
    	 }else{
    		 rs.execute("select max(id) from workflow_monitor_info");
    		 if(rs.next())
    			 infoid = rs.getInt(1) + 1;
    		 else
    			 infoid = 1;
    	 }
     }
     
    if("add".equals(actionKey)){//added by xwj for td2903 20051020
    try{
	String typeid="-1";
	String typeidtemp="-1";
	String wfids="-1";
    if(ischeckall==0){
     for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("VW")==0){
                     isviewlist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("IW")==0){
                     isintervenorlist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("DW")==0){
                     isdellist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("BW")==0){
                     isfblist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("OW")==0){
                     isfolist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("SW")==0){
                     issolist.add(value1[i].substring(2));
                 }
             }
         }
         if(elementname.indexOf("t")==0)
		 { wfids+=","+elementname.substring(1,elementname.length());
		 String wname="w"+elementname.substring(1,elementname.length());
		 //没有展开的不编辑
		 
         String[] valuet=request.getParameterValues(wname);
		 //System.out.print("wname"+wname +":"+"valuet"+valuet);
		 if (valuet!=null)
			 {
		   typeid=typeid+","+elementname.substring(1,elementname.length());  
			 }
			 else
			 {
			typeidtemp=typeidtemp+","+elementname.substring(1,elementname.length()); 
			 }
		 }
		 
	  }
     if(!newflag){
    	 if(detachable == 0){
 	  		rs.executeSql("delete from workflow_monitor_detail where infoid = " + infoid + " and workflowid not in (select id from workflow_base where workflowtype in ("+typeidtemp+"))");
    	 }else{
    	     String hadRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowMonitor:All",0);
    		rs.execute("delete from workflow_monitor_detail where infoid = " + infoid + " and workflowid not in (select id from workflow_base where workflowtype in ("+typeidtemp+")) and workflowid in (select id from workflow_base where subcompanyid in ("+hadRightSub+"))");
    	 }
      }
	  // out.print("delete from workflow_monitor_bound where  monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where workflowtype in ("+typeid+") or workflowtype not in ("+wfids+"))");
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
			//out.print((String) En.nextElement()+"<br>");
            value=request.getParameterValues((String) En.nextElement());
             for(int i=0;i<value.length;i++){
              value[i]=Util.null2String(value[i]);
              if(value[i].indexOf("W")==0){
                 wfid = Integer.parseInt(value[i].substring(1,value[i].length()));
                 isview=(isviewlist.indexOf(""+wfid)==-1)?0:1;
                 isintervenor=(isintervenorlist.indexOf(""+wfid)==-1)?0:1;
                 isdelete=(isdellist.indexOf(""+wfid)==-1)?0:1;
                 isfb=(isfblist.indexOf(""+wfid)==-1)?0:1;
                 isfo=(isfolist.indexOf(""+wfid)==-1)?0:1;
                 isso=(issolist.indexOf(""+wfid)==-1)?0:1;
                 rs.executeSql("insert into workflow_monitor_detail(infoid,workflowid,operatordate,operatortime,isview,isintervenor,isdelete,isForceDrawBack,isForceOver,issooperator,operator,monitortype,subcompanyid) values ("+infoid+","+wfid+",'"+currentDate+"','"+currentTime+"',"+isview+",'"+isintervenor+"','"+isdelete+"','"+isfb+"','"+isfo+"','"+isso+"',"+userid+","+monitortypeid+","+subcompanyid+")");
               }
             }
           }
    }else{
       if(viewcheckall==0){
        	for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
			 String elementname=(String)En.nextElement();
		     value1=request.getParameterValues(elementname);
			 if(value1!=null){
	             for(int i=0;i<value1.length;i++){
	                 if(value1[i].indexOf("VW")==0){
	                     isviewlist.add(value1[i].substring(2));
	                 }
	             }
	         }
	  		}
        }
       
        if(intervenorcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("IW")==0){
                     isintervenorlist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(delcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("DW")==0){
                     isdellist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(fbcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("BW")==0){
                     isfblist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(focheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("OW")==0){
                     isfolist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(socheckall==0){
	        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
			 String elementname=(String)En.nextElement();
		     value1=request.getParameterValues(elementname);
			 if(value1!=null){
	             for(int i=0;i<value1.length;i++){
	                 if(value1[i].indexOf("SW")==0){
	                     issolist.add(value1[i].substring(2));
	                 }
	             }
	         }
		  }
        }
        if(!newflag){
        	if(detachable == 0){
        		rs.executeSql("delete from workflow_monitor_detail where infoid = " + infoid);
        	}else{
	            String hadRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowMonitor:All",0);
        		rs.executeSql("delete from workflow_monitor_detail where infoid = " + infoid + " and workflowid in (select id from workflow_base where subcompanyid in ( "+hadRightSub+"))");
        	}
        }
        if(detachable==1){
            String hadRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowMonitor:All",0);
        	if(rs.getDBType().equals("oracle"))
		  		rs.executeSql("select * from workflow_base where (isvalid='1' or isvalid='2') and nvl(subcompanyid,0) in ( "+hadRightSub+") order by id");
        	else
        		rs.executeSql("select * from workflow_base where (isvalid='1' or isvalid='2') and isnull(subcompanyid,0) in ( "+hadRightSub+") order by id");
        		
        }else
        	rs.executeSql("select * from workflow_base where (isvalid='1' or isvalid='2') order by id");
        while(rs.next()){
            wfid=Integer.parseInt(rs.getString("id"));
            if(viewcheckall==1) isview=1;
            else{
                isview=(isviewlist.indexOf(""+wfid)==-1)?0:1;
            }
            if(intervenorcheckall==1) isintervenor=1;
            else{
                isintervenor=(isintervenorlist.indexOf(""+wfid)==-1)?0:1;
            }
            if(delcheckall==1) isdelete=1;
            else{
                isdelete=(isdellist.indexOf(""+wfid)==-1)?0:1;
            }
            if(fbcheckall==1) isfb=1;
            else{
                isfb=(isfblist.indexOf(""+wfid)==-1)?0:1;
            }
            if(focheckall==1) isfo=1;
            else{
                isfo=(isfolist.indexOf(""+wfid)==-1)?0:1;
            }
            if(socheckall==1) isso=1;
            else{
                isso=(issolist.indexOf(""+wfid)==-1)?0:1;
            }
            rs.executeSql("insert into workflow_monitor_detail(infoid,workflowid,operatordate,operatortime,isview,isintervenor,isdelete,isForceDrawBack,isForceOver,issooperator,operator,monitortype,subcompanyid) values ("+infoid+","+wfid+",'"+currentDate+"','"+currentTime+"',"+isview+",'"+isintervenor+"','"+isdelete+"','"+isfb+"','"+isfo+"','"+isso+"',"+userid+","+monitortypeid+","+subcompanyid+")");
        }
    }
    
    if(newflag){
    	//保存监控信息
    	rs.execute("insert into workflow_monitor_info (id,monitortype,flowcount,operatordate,operatortime,operator,subcompanyid,jktype,jkvalue,fwtype,fwvalue) values ("+infoid+","+monitortypeid+",0,'"+currentDate+"','"+currentTime+"',"+userid+","+subcompanyid+",'"+jktype+"','"+jkvalue+"',"+fwtype+",'"+fwvalue+"')");
    }else{
    	//更新监控信息
    	if(detachable == 1){
    		rs.execute("update workflow_monitor_info set monitortype = "+monitortypeid+", operatordate = '" + currentDate + "',operatortime = '" + currentTime + "',subcompanyid = " + subcompanyid + ",flowcount = 0,jktype = '"+jktype+"',jkvalue = '"+jkvalue+"',fwtype = "+fwtype+",fwvalue = '"+fwvalue+"' where id = " + infoid);
    	}else{
    	    rs.execute("update workflow_monitor_info set monitortype = "+monitortypeid+", operatordate = '" + currentDate + "',operatortime = '" + currentTime + "',flowcount = 0,jktype = '"+jktype+"',jkvalue = '"+jkvalue+"',fwtype = "+fwtype+",fwvalue = '"+fwvalue+"' where id = " + infoid);
    	}
	    rs.execute("update workflow_monitor_detail set monitortype = "+monitortypeid+" where infoid = "+infoid);
    }
    rs.execute("select count(1) from workflow_monitor_detail where infoid = " + infoid);
    rs.next();
    rs.execute("update workflow_monitor_info  set flowcount = "+rs.getInt(1)+" where id = " + infoid);
    
   }
   catch(Exception e){
    flag = false;
	//out.print(e.toString());
   }
if(flag){
 response.sendRedirect("systemMonitorSet.jsp?isclose=1&typeid="+queryTypeid);
}
else{
response.sendRedirect("systemMonitorSet.jsp?isclose=1&typeid="+queryTypeid);
}

/* -------- xwj for td2903 20051020 begin ---------*/
}
else if("del".equals(actionKey)){
	
	rs.execute("delete from workflow_monitor_info where id = " + infoid );
	rs.execute("delete from workflow_monitor_detail where infoid = " + infoid );
    response.sendRedirect("systemMonitorStatic.jsp?typeid="+monitortypeid+"&subcompanyid="+subcompanyid);
}else if("deleteAll".equals(actionKey)){
	String infoids = Util.null2String(request.getParameter("infoids"));
	if(!"".equals(infoids)){
		if(infoids.startsWith(","))
			infoids = infoids.substring(1);
		if(infoids.endsWith(","))
			infoids = infoids.substring(0,infoids.length()-1);
		
		rs.execute("delete from workflow_monitor_info where id in ("+infoids+")" );
		rs.execute("delete from workflow_monitor_detail where infoid in ("+infoids+")" );
	}
    response.sendRedirect("systemMonitorStatic.jsp?typeid="+monitortypeid+"&subcompanyid="+subcompanyid);
}else if("delflow".equals(actionKey))
{
    int flowid = Util.getIntValue(request.getParameter("flowid"),0);
    response.sendRedirect("/system/systemmonitor/workflow/systemMonitorDetail.jsp?monitorhrmid="+monitorhrmid+"&subcompanyid="+subcompanyid+"&typeid="+temptypeid);
}
else if("upview".equals(actionKey)){
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isview = Util.getIntValue(request.getParameter("isview"),0);
 rs.executeSql("update workflow_monitor_detail set isview="+isview+" where infoid = " + infoid+" and workflowid="+flowid);
}else if("upintervenor".equals(actionKey)){
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isintervenor = Util.getIntValue(request.getParameter("isintervenor"),0);
 rs.executeSql("update workflow_monitor_detail set isintervenor='"+isintervenor+"' where infoid = " + infoid+" and workflowid="+flowid);
}else if("updel".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isdelete = Util.getIntValue(request.getParameter("isdelete"),0);
 rs.executeSql("update workflow_monitor_detail set isdelete='"+isdelete+"' where infoid = " + infoid+" and workflowid="+flowid);
}else if("upfb".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isfb = Util.getIntValue(request.getParameter("isForceDrawBack"),0);
 rs.executeSql("update workflow_monitor_detail set isForceDrawBack='"+isfb+"' where infoid = " + infoid+" and workflowid="+flowid);
}else if("upfo".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isfo = Util.getIntValue(request.getParameter("isForceOver"),0);
 rs.executeSql("update workflow_monitor_detail set isForceOver='"+isfo+"' where infoid = " + infoid+" and workflowid="+flowid);
}
else if("upso".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isso = Util.getIntValue(request.getParameter("issooperator"),0);
 rs.executeSql("update workflow_monitor_detail set issooperator='"+isso+"' where infoid = " + infoid+" and workflowid="+flowid);
}


else if("upallcontrol".equals(actionKey))
{
 //int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 String flowid1 = request.getParameter("flowid");
 flowid1 = flowid1.substring(0, flowid1.length()-1);
 flowid1 = flowid1.replaceAll("A", ",");
 
 rs.execute("delete from workflow_monitor_detail where infoid = " + infoid + " and workflowid in ("+flowid1+")");
 rs.execute("select count(1) from workflow_monitor_detail where infoid = " + infoid);
 rs.next();
 rs.execute("update workflow_monitor_info  set flowcount = "+rs.getInt(1)+" where id = " + infoid);

 response.sendRedirect("/system/systemmonitor/workflow/systemMonitorDetail.jsp?infoid="+infoid+"&typeid="+temptypeid+"&subcompanyid="+subcompanyid);
}
%>