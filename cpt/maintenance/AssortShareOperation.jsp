
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSetTrans"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String assortid = Util.null2String(request.getParameter("assortid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String seclevelMax =""+Util.getIntValue( Util.null2String(request.getParameter("seclevelMax")),100);
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;
String jobtitleid = "0";
String joblevel = "0";
String scopeid = "0";

if(sharetype.equals("1")){
	userid = relatedshareid ;
	seclevel="0";
}
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;
if(sharetype.equals("5")) subcompanyid = relatedshareid ;
if(sharetype.equals("11")) jobtitleid = relatedshareid ;

String name = "";

if(method.equals("delete"))
{
	RecordSet.executeSql("delete from CptAssortmentShare where id="+id);
	
    CptShare.SetAssortShare(assortid);
/**************************
	name = SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())+":"+assortname;

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("3");
	SysMaintenanceLog.setOperateDesc("CptCapitalShareInfo_Delete,"+id);
	SysMaintenanceLog.setSysLogInfo();

*/

    String forward=Util.null2String(request.getParameter("forward"));
    if(forward.equals("view")){
       //response.sendRedirect("/cpt/maintenance/CptAssortmentView.jsp?paraid="+assortid);
       return;
    }else{
	   //response.sendRedirect("/cpt/maintenance/CptAssortmentAddShare.jsp?assortmentid="+assortid);
	   return;
	}
	
}else if(method.equals("batchdelete")){
	if(id.startsWith(",")){
		id=id.substring(1);
	}
	if(id.endsWith(",")){
		id=id.substring(0,id.length()-1);
	}
	
	
	RecordSet.executeSql("delete from CptAssortmentShare where id in("+id+")");
    CptShare.SetAssortShare(assortid);
    
    return;
}


else if(method.equals("add"))
{
	synchronized(this){
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			//1 人力  2部门    5分部   11岗位  均改为多选
			if(sharetype.equals("1")){
				String[] tmpuserid = Util.TokenizerString2(userid,",");
				int userid1 = 0;
		        for(int i=0;tmpuserid!=null&&tmpuserid.length>0&&i<tmpuserid.length;i++){
		        	userid1 = Util.getIntValue(tmpuserid[i]);
		        	if(userid1>0) {
		        		ProcPara = assortid;
						ProcPara += flag+sharetype;
						ProcPara += flag+seclevel;
						ProcPara += flag+rolelevel;
						ProcPara += flag+sharelevel;
						ProcPara += flag+""+userid1+"";
						ProcPara += flag+departmentid;
						ProcPara += flag+roleid;
						ProcPara += flag+foralluser;
						ProcPara += flag+subcompanyid;
						rst.executeProc("CptAssortmentShare_Insert",ProcPara);
						rst.executeSql("select max(id) from CptAssortmentShare ");
						rst.next();
						int newid=Util.getIntValue( rst.getString(1),0);
						if(newid>0){
							rst.executeSql("update CptAssortmentShare set seclevelMax='"+seclevelMax+"' where id="+newid);
						}
		        	}
		        }
			}else if(sharetype.equals("2")){
				String tempStrs[] = Util.TokenizerString2(departmentid,",");
	            for(int k=0;k<tempStrs.length;k++){
	                int departmentid1 = Util.getIntValue(Util.null2o(tempStrs[k]));            
	                ProcPara = assortid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userid;
					ProcPara += flag+""+departmentid1+"";
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
					ProcPara += flag+subcompanyid;

					rst.executeProc("CptAssortmentShare_Insert",ProcPara);
					rst.executeSql("select max(id) from CptAssortmentShare ");
					rst.next();
					int newid=Util.getIntValue( rst.getString(1),0);
					if(newid>0){
						rst.executeSql("update CptAssortmentShare set seclevelMax='"+seclevelMax+"' where id="+newid);
					}
	            }
			}else if(sharetype.equals("5")){
				String tempStrs[] = Util.TokenizerString2(subcompanyid,",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid1 = Util.getIntValue(Util.null2o(tempStrs[k]));                  
                    ProcPara = assortid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userid;
					ProcPara += flag+departmentid;
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
					ProcPara += flag+""+subcompanyid1+"";

					rst.executeProc("CptAssortmentShare_Insert",ProcPara);
					rst.executeSql("select max(id) from CptAssortmentShare ");
					rst.next();
					int newid=Util.getIntValue( rst.getString(1),0);
					if(newid>0){
						rst.executeSql("update CptAssortmentShare set seclevelMax='"+seclevelMax+"' where id="+newid);
					}
                }
			}else if(sharetype.equals("11")){
				String tempStrs[] = Util.TokenizerString2(jobtitleid,",");
				joblevel = Util.null2String(request.getParameter("joblevel"));
				scopeid = Util.null2String(request.getParameter("scopeid"));
				if("".equals(scopeid))scopeid = "0";
                for(int k=0;k<tempStrs.length;k++){
                    int jobtitleid1 = Util.getIntValue(Util.null2o(tempStrs[k]));                  
					String tempsql = "INSERT INTO CptAssortmentShare (assortmentid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,"+
							"foralluser,subcompanyid,jobtitleid,joblevel,scopeid) VALUES ("+assortid+","+sharetype+","+seclevel+","+rolelevel+
									","+sharelevel+","+userid+","+departmentid+","+roleid+","+foralluser+","+subcompanyid+
									","+jobtitleid1+","+joblevel+",'"+scopeid+"')";
					rst.executeSql(tempsql);
                }
			}else{
				ProcPara = assortid;
				ProcPara += flag+sharetype;
				ProcPara += flag+seclevel;
				ProcPara += flag+rolelevel;
				ProcPara += flag+sharelevel;
				ProcPara += flag+userid;
				ProcPara += flag+departmentid;
				ProcPara += flag+roleid;
				ProcPara += flag+foralluser;
				ProcPara += flag+subcompanyid;
				rst.executeProc("CptAssortmentShare_Insert",ProcPara);
				rst.executeSql("select max(id) from CptAssortmentShare ");
				rst.next();
				int newid=Util.getIntValue( rst.getString(1),0);
				if(newid>0){
					rst.executeSql("update CptAssortmentShare set seclevelMax='"+seclevelMax+"' where id="+newid);
				}
			}
			
			rst.commit();
		}catch(Exception e){
			rst.rollback();
		}
	}	
		
	response.sendRedirect("/cpt/maintenance/AssortShareOperation.jsp?assortid="+assortid+"&method=submit");
	return;
}

else if(method.equals("submit"))
{
    CptShare.SetAssortShare(assortid);
    //response.sendRedirect("/cpt/maintenance/CptAssortmentView.jsp?paraid="+assortid);
	return;
}
%>
