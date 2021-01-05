<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));  //共享对象
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0);
int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 255);
String sharelevel = Util.null2String(request.getParameter("sharelevel")); //共享级别 1：查看 2：编辑
String planType= Util.null2String(request.getParameter("planType")); //共享日程类型
String companyVirtual= Util.null2String(request.getParameter("companyVirtual")); //维度
String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
 
String CurrentUserid=""+user.getUID();
 
if(method.equals("delete"))
{	
	RecordSet.execute("delete from WorkPlanCreateShareSet where SUSERID="+CurrentUserid+" and id in ("+id+")");
}
else if(method.equals("add"))
{
    if(!"".equals(relatedshareid)){
    	String[] relatedshareids=relatedshareid.split(",");
    	for(String temp_id:relatedshareids){
    		if("".equals(temp_id)) continue;
    		
    		if(sharetype.equals("1")){ userid = temp_id ;}
    		else if(sharetype.equals("2")){ subcompanyid = temp_id; }
    		else if(sharetype.equals("3")){ departmentid = temp_id ;}
    		else if(sharetype.equals("4")){ roleid = temp_id ;}
    		
    		StringBuffer sb=new StringBuffer();
    		sb.append("insert into WorkPlanCreateShareSet(planid,SHARETYPE,SECLEVEL,seclevelMax,ROLELEVEL,SHARELEVEL,USERID,SUBCOMPANYID,DEPARTMENTID,ROLEID,SUSERID) ");
    		sb.append("values ("+planType+","+sharetype+","+seclevel+","+seclevelMax+","+rolelevel+","+sharelevel +","+userid+","+subcompanyid+","+departmentid+","+roleid+","+CurrentUserid+")");
    		RecordSet.execute(sb.toString());
    	}
    }else{
    	//所有人和所有上级和接收人
    	if("5".equals(sharetype)||"6".equals(sharetype)){
    		StringBuffer sb=new StringBuffer();
    		sb.append("insert into WorkPlanCreateShareSet(planid,SHARETYPE,SECLEVEL,seclevelMax,ROLELEVEL,SHARELEVEL,USERID,SUBCOMPANYID,DEPARTMENTID,ROLEID,SUSERID,companyVirtual) ");
    		sb.append("values ("+planType+","+sharetype+","+seclevel+","+seclevelMax+","+rolelevel+","+sharelevel +","+userid+","+subcompanyid+","+departmentid+","+roleid+","+CurrentUserid+",'"+companyVirtual+"')");
    		RecordSet.execute(sb.toString());
    	}else if("8".equals(sharetype)){
    		String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid")),",");
            int joblevel = Util.getIntValue(request.getParameter("joblevel"), 0); 
            String joblevelvalue ="";
            if(joblevel==1){
            	joblevelvalue=Util.null2String(request.getParameter("sublevelids"));
            }else if(joblevel==2){
            	joblevelvalue=Util.null2String(request.getParameter("deplevelids"));
            }
            if(jobid.length>0){
                for(String jid : jobid){
                	StringBuffer sb=new StringBuffer();
            		sb.append("insert into WorkPlanCreateShareSet(planid,SHARETYPE,SECLEVEL,seclevelMax,ROLELEVEL,SHARELEVEL,USERID,SUBCOMPANYID,DEPARTMENTID,ROLEID,SUSERID,jobtitleid,joblevel,joblevelvalue) ");
            		sb.append("values ("+planType+","+sharetype+","+seclevel+","+seclevelMax+","+rolelevel+","+sharelevel +","+userid+","+subcompanyid+","+departmentid+","+roleid+","+CurrentUserid+",'"+jid+"','"+joblevel+"','"+joblevelvalue+"')");
                	RecordSet.execute(sb.toString());
                }
            }
        }else if("9".equals(sharetype)){
        	StringBuffer sb=new StringBuffer();
    		sb.append("insert into WorkPlanCreateShareSet(planid,SHARETYPE,ROLELEVEL,SHARELEVEL,USERID,SUBCOMPANYID,DEPARTMENTID,ROLEID,SUSERID) ");
    		sb.append("values ("+planType+","+sharetype+","+rolelevel+","+sharelevel +","+userid+","+subcompanyid+","+departmentid+","+roleid+","+CurrentUserid+")");
    		RecordSet.execute(sb.toString());
        }
    }
}
%>
	<script type="text/javascript">
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	</script>
