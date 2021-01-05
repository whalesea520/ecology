
<%@page import="weaver.conn.RecordSetTrans"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>

<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String typeid = Util.null2String(request.getParameter("typeid"));

String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String seclevelMax =""+Util.getIntValue( Util.null2String(request.getParameter("seclevelMax")),100);
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

String isRestruct = Util.null2String(request.getParameter("norepeatedname"));

String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

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

if(method.equals("delete"))
{

	RecordSet.executeProc("Prj_T_ShareInfo_Delete",id);
}else if(method.equals("batchdelete"))
{
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr= Util.TokenizerString2(ids, ",");
	for(int i=0;i<arr.length;i++){
		String id1 = ""+Util.getIntValue( arr[i]);
		RecordSet.executeProc("Prj_T_ShareInfo_Delete",id1);
	}		
}else if(method.equals("add")){ 
       
        String sqlString = "select Max(id) id from Prj_T_ShareInfo where relateditemid="+typeid+"";
		RecordSet.executeSql(sqlString);
		int maxid =0;	
		if(RecordSet.next()){		
             maxid =  Util.getIntValue(RecordSet.getString(1),0);
		}
		
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
		        		ProcPara = typeid;
						ProcPara += flag+sharetype;
						ProcPara += flag+seclevel;
						ProcPara += flag+rolelevel;
						ProcPara += flag+sharelevel;
						ProcPara += flag+""+userid1+"";
						ProcPara += flag+departmentid;
						ProcPara += flag+roleid;
						ProcPara += flag+foralluser;
						ProcPara += flag+subcompanyid;
						rst.executeProc("Prj_T_ShareInfo_Insert",ProcPara);
						rst.executeSql("select max(id) from Prj_T_ShareInfo ");
						rst.next();
						int newid=Util.getIntValue( rst.getString(1),0);
						if(newid>0){
							rst.executeSql("update Prj_T_ShareInfo set seclevelMax='"+seclevelMax+"' where id="+newid);
						}
		        	}
		        }
			}else if(sharetype.equals("2")){
				String tempStrs[] = Util.TokenizerString2(departmentid,",");
	            for(int k=0;k<tempStrs.length;k++){
	                int departmentid1 = Util.getIntValue(Util.null2o(tempStrs[k]));            
	                ProcPara = typeid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userid;
					ProcPara += flag+""+departmentid1+"";
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
					ProcPara += flag+subcompanyid;

					rst.executeProc("Prj_T_ShareInfo_Insert",ProcPara);
					rst.executeSql("select max(id) from Prj_T_ShareInfo ");
					rst.next();
					int newid=Util.getIntValue( rst.getString(1),0);
					if(newid>0){
						rst.executeSql("update Prj_T_ShareInfo set seclevelMax='"+seclevelMax+"' where id="+newid);
					}
	            }
			}else if(sharetype.equals("5")){
				String tempStrs[] = Util.TokenizerString2(subcompanyid,",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid1 = Util.getIntValue(Util.null2o(tempStrs[k]));                  
                    ProcPara = typeid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userid;
					ProcPara += flag+departmentid;
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
					ProcPara += flag+""+subcompanyid1+"";

					rst.executeProc("Prj_T_ShareInfo_Insert",ProcPara);
					rst.executeSql("select max(id) from Prj_T_ShareInfo ");
					rst.next();
					int newid=Util.getIntValue( rst.getString(1),0);
					if(newid>0){
						rst.executeSql("update Prj_T_ShareInfo set seclevelMax='"+seclevelMax+"' where id="+newid);
					}
                }
			}else if(sharetype.equals("11")){
				String tempStrs[] = Util.TokenizerString2(jobtitleid,",");
				joblevel = Util.null2String(request.getParameter("joblevel"));
				scopeid = Util.null2String(request.getParameter("scopeid"));
				
				if("".equals(scopeid))scopeid = "0";
                for(int k=0;k<tempStrs.length;k++){
                    int jobtitleid1 = Util.getIntValue(Util.null2o(tempStrs[k]));                  
					String tempsql = "INSERT INTO Prj_T_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,"+
							"foralluser,subcompanyid,jobtitleid,joblevel,scopeid) VALUES ("+typeid+","+sharetype+","+seclevel+","+rolelevel+
									","+sharelevel+","+userid+","+departmentid+","+roleid+","+foralluser+","+subcompanyid+
									","+jobtitleid1+","+joblevel+",'"+scopeid+"')";
					rst.executeSql(tempsql);
                }
			}else{
				ProcPara = typeid;
				ProcPara += flag+sharetype;
				ProcPara += flag+seclevel;
				ProcPara += flag+rolelevel;
				ProcPara += flag+sharelevel;
				ProcPara += flag+userid;
				ProcPara += flag+departmentid;
				ProcPara += flag+roleid;
				ProcPara += flag+foralluser;
				ProcPara += flag+subcompanyid;
				rst.executeProc("Prj_T_ShareInfo_Insert",ProcPara);
				rst.executeSql("select max(id) from Prj_T_ShareInfo ");
				rst.next();
				int newid=Util.getIntValue( rst.getString(1),0);
				if(newid>0){
					rst.executeSql("update Prj_T_ShareInfo set seclevelMax='"+seclevelMax+"' where id="+newid);
				}
			}		
			rst.commit();
		}catch(Exception e){
			rst.rollback();
		}	
	}		
	if(isRestruct.equals("1")){
	
		//找到之前创建过的项目,将共享权限重构
		String sql1 = "select id from prj_projectinfo where prjtype="+typeid+"";
		RecordSet.executeSql(sql1);
		if(maxid != 0){		
			while(RecordSet.next()){
	 			String idtemp = RecordSet.getString("id"); 
	 			
	 			RecordSet1.executeProc("Prj_ShareInfo_Restruct",typeid+flag+idtemp+flag+maxid);
			}
		}else{//项目类型没有设置共享,但已经建立了项目数据的时候再添加项目共享
		  while(RecordSet.next()){
	 		String idtemp = RecordSet.getString("id"); 
	 		
	 		RecordSet1.executeProc("Prj_ShareInfo_Update",typeid+flag+idtemp);
		  }	
		}
	}	
}
%>
