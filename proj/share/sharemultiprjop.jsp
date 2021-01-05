
<%@page import="weaver.cpt.util.CommonShareManager"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page"/>
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
	String jobtitleid = "0";
    
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


            for(int i=0; i<rownum; i++){
                String sharetype = request.getParameter("sharetype_"+i);
                if(sharetype != null){
                    String relatedshareid = Util.null2String(request.getParameter("relatedshareid_"+i));
                    String rolelevel = Util.null2String(request.getParameter("rolelevel_"+i));
                    String seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel_"+i)) , Util.getIntValue(request.getParameter("seclevelMax_"+i)))+"";
                	String seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel_"+i)) , Util.getIntValue(request.getParameter("seclevelMax_"+i)))+"";
                    String sharelevel = Util.null2String(request.getParameter("sharelevel_"+i));
                    String joblevel = Util.null2String(request.getParameter("joblevel_"+i));
            		String scopeid=Util.null2String(request.getParameter("scopeid_"+i));
            		if("".equals(scopeid))scopeid="0";
                    String poststr=crmid+"|"+sharelevel+"|"+sharetype+"|"+seclevel+"|"+rolelevel+"|"+relatedshareid+"|"+seclevelMax+"|"+joblevel+"|"+scopeid;
                    //System.out.println("poststr:"+poststr);
					if(CommonShareManager.shareIfExists("Prj_ShareInfo", poststr)){
						continue;
					}
                    if(sharetype.equals("1")) userid = relatedshareid ;
                    if(sharetype.equals("2")) departmentid = relatedshareid ;
                    if(sharetype.equals("3")) roleid = relatedshareid ;
                    if(sharetype.equals("4")) foralluser = "1" ;
                    if(sharetype.equals("5")) subcompanyid = relatedshareid ;
                    if(sharetype.equals("11")) jobtitleid = relatedshareid ;
                    synchronized(this){
                    	RecordSetTrans rst=new RecordSetTrans();
                    	rst.setAutoCommit(false);
                    	if(!"11".equals(sharetype)){
	                    	ProcPara = crmid;
	                    	ProcPara += flag+sharetype;
	                    	ProcPara += flag+seclevel;
	                    	ProcPara += flag+rolelevel;
	                    	ProcPara += flag+sharelevel;
	                    	ProcPara += flag+userid;
	                    	ProcPara += flag+departmentid;
	                    	ProcPara += flag+roleid;
	                    	ProcPara += flag+foralluser;
	                    	ProcPara += flag+subcompanyid;
	                    	
	                    	rst.executeProc("Prj_ShareInfo_Insert",ProcPara);
                    		rst.executeSql("select max(id) from Prj_ShareInfo ");
                    	}else{
                    		String tempsql = "INSERT INTO Prj_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,"+
							"foralluser,subcompanyid,jobtitleid,joblevel,scopeid) VALUES ("+crmid+","+sharetype+","+seclevel+","+rolelevel+
									","+sharelevel+","+userid+","+departmentid+","+roleid+","+foralluser+","+subcompanyid+
									","+jobtitleid+","+joblevel+",'"+scopeid+"')";
							rst.executeSql(tempsql);
                    	}
                    	try{
                    		String Remark="sharetype:"+sharetype+"seclevel:"+seclevel+"seclevelMax:"+seclevelMax+"rolelevel:"+rolelevel
                    				+"sharelevel:"+sharelevel+"userid:"+userid+"departmentid:"+departmentid+"subcompanyid:"+subcompanyid
                    				+"roleid:"+roleid+"foralluser:"+foralluser+"jobtitleid:"+jobtitleid+"joblevel:"+joblevel+"scopeid:"+scopeid;
                    		rst.next();
                    		int newid=Util.getIntValue( rst.getString(1),0);
                    		if(newid>0){
                    			rst.executeSql("update Prj_ShareInfo set seclevelMax='"+seclevelMax+"' where id="+newid);
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
                    		rst.executeProc("Prj_Log_Insert",ProcPara);
                    		rst.commit();
                    	}catch(Exception e){
                    		rst.rollback();
                    	}
                    	                   
                    }

                }
            }
        }
    }
     response.sendRedirect("sharemultiprjto.jsp?isclose=1");
%>
