<%@page import="weaver.general.BaseBean"%>
<%@page import="com.sap.mw.jco.JCO.Exception"%>
<%@page import="weaver.docs.category.security.AclManager"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.systeminfo.systemright.RightComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.workflow.report.ReportShare"%>
<%@page import="weaver.systeminfo.systemright.CheckUserRight"%>
<%@page import="weaver.systeminfo.SysMaintenanceLog"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.cowork.CoworkShareManager"%> 

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.util.regex.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="deleteRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%
BaseBean bb = new BaseBean();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
	out.flush();
	return;
}else{
//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
	int userid=user.getUID();
	String sqlUid = "select count(*) cnt from HrmResourceManager where id="+userid;
	rs.executeSql(sqlUid);
	boolean haspermission = true;
	if(!rs.next() || rs.getInt("cnt") <= 0){
		//haspermission = false;
		//工作流验证此权限
		if (!HrmUserVarify.checkUserRight("HrmEffectManageEmpower:Edit", user)&&!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
			out.flush();
			return;
		}
	}

  	char flag=2;

    boolean isoracle = (rs.getDBType()).equals("oracle") ;
    boolean isdb2 = (rs.getDBType()).equals("db2") ;
    boolean issqlserver = (rs.getDBType()).equals("sqlserver") ;
    
	ResourceComInfo rci = new ResourceComInfo();
	SysMaintenanceLog sysMaintenanceLog = new SysMaintenanceLog();
	CheckUserRight checkUserRight = new CheckUserRight();
	ReportShare reportShare = new ReportShare();
	SubCompanyComInfo scci = new SubCompanyComInfo();
	RightComInfo rightComInfo = new RightComInfo();
	RolesComInfo rolesComInfo = new RolesComInfo();
	
	String operation = Util.null2String(request.getParameter("operation"));
	
	if(operation.equals("save")){//保存 修改有改变的行(包括新增行和编辑行) 
		String returnFlag = "";

		int roleIdType = Util.getIntValue(request.getParameter("roleIdType"));
		String roleIds = Util.null2String(request.getParameter("roleIds")).trim();
		String hrmIds = Util.null2String(request.getParameter("hrmIds")).trim();
		
		String workflowids = Util.null2String(request.getParameter("workflowids")).trim();
		String docids = Util.null2String(request.getParameter("docids")).trim();
		String portalids = Util.null2String(request.getParameter("portalids")).trim();
		String coworkids = Util.null2String(request.getParameter("coworkids")).trim();
		
		String permissiontype ="";
		String administrators = "";
		String sysAdminColStr = "";
		if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
			administrators = roleIds;
			sysAdminColStr = "roleid";
			permissiontype = "2";
		}else if(roleIdType == 2){//共享类型：5-人力资源
			administrators = hrmIds;
			sysAdminColStr = "userid";
			permissiontype = "5";
		}
		
		
		if(!"".equals(administrators) && Util.getIntValue(administrators) > 0){
			RecordSetTrans rst = null;
			try{
				rst = new RecordSetTrans();
				rst.setAutoCommit(false);
				
				String dirtype = "0";
				String operationcode = "1";
		        int rolelevel = 2;//角色级别 默认为2-总部级别、1-分部级别、0-部门级别
			    int seclevel = 10;//安全级别 默认为10
		
			    String delSQL="";
			    String[] diridArray = new String[]{};
			    
			    //工作流类型
		        diridArray = workflowids.split(",");
		        
		        delSQL="delete from wfAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype;
                rst.executeSql(delSQL);	
		        /*
			    if(workflowids!=null &&diridArray.length>0){
		          delSQL="delete from wfAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype+" and dirid in ("+workflowids+") ";
				  //bb.writeLog(delSQL);
				  rst.executeSql(delSQL);	
				}
				//System.out.println(">>>>>>>>工作流 delSQL="+delSQL+";workflowids="+workflowids); 
				*/
				
				boolean replaceworkflow = Boolean.parseBoolean(Util.null2String(request.getParameter("replaceworkflow")));
				if (replaceworkflow) {
		    		delSQL="delete from wfAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype+"  ";//and dirid = '"+dirid+"'
		        	rst.executeSql(delSQL);
				}
		        for(int i=0;i<diridArray.length;i++){
		        	int dirid = Util.getIntValue(diridArray[i]);
			        	if(dirid > 0){
			        		if (!replaceworkflow) {
			        			delSQL="delete from wfAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype+" and dirid = '"+dirid+"' ";
						        //bb.writeLog(delSQL);
						        rst.executeSql(delSQL);
			        		}
						if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
							String insertSQL = "insert into wfAccessControlList "+
											" (dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) "+
											" values "+
											" ("+dirid+", "+dirtype+", "+administrators+", "+rolelevel+", "+seclevel+", "+operationcode+", "+permissiontype+")";
							//bb.writeLog(insertSQL);
					        rst.executeSql(insertSQL);
						}else if(roleIdType == 2){//共享类型：5-人力资源
							String insertSQL = "insert into wfAccessControlList "+
											" (dirid, dirtype, userid, operationcode, permissiontype) "+
											" values "+
											" ("+dirid+", "+dirtype+", "+administrators+", "+operationcode+", "+permissiontype+")";
							//bb.writeLog(insertSQL);
					        rst.executeSql(insertSQL);
						}
		        	}
		        }

		        
		        if (haspermission) {

			        //知识目录
			        diridArray = docids.split(",");
			        /*
			        if(docids!=null &&diridArray.length>0){
			          delSQL="delete from DirAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype+" and dirid in ("+docids+") ";
					  //bb.writeLog(delSQL);
			          rst.executeSql(delSQL);
			        }
			        //System.out.println(">>>>>>>>知识目录 delSQL="+delSQL+";docids="+docids);
			        */
	            delSQL="delete from DirAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 2 and operationcode = 1 and permissiontype = "+permissiontype+" ";//and dirid = '"+dirid+"' 
			        //bb.writeLog(delSQL);
	                rst.executeSql(delSQL);	
	                
			        for(int i=0;i<diridArray.length;i++){
			        	int dirid = Util.getIntValue(diridArray[i]);
			        	if(dirid > 0){
			        	dirtype="2";
							if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
								String insertSQL = "insert into DirAccessControlList "+
												" (dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) "+
												" values "+
												" ("+dirid+", "+dirtype+", "+administrators+", "+rolelevel+", "+seclevel+", "+operationcode+", "+permissiontype+")";
								//bb.writeLog(insertSQL);
						        //rst.executeSql(insertSQL);
						        String callparam = Integer.toString(dirid)+Util.getSeparator()+dirtype+Util.getSeparator()+operationcode+Util.getSeparator()+administrators+Util.getSeparator()+rolelevel+Util.getSeparator()+seclevel;
								boolean f = rst.executeProc("Doc_DirAcl_Insert_Type2", callparam);
						        //bb.writeLog(f);
							}else if(roleIdType == 2){//共享类型：5-人力资源
								String insertSQL = "insert into DirAccessControlList "+
												" (dirid, dirtype, userid, operationcode, permissiontype) "+
												" values "+
												" ("+dirid+", "+dirtype+", "+administrators+", "+operationcode+", "+permissiontype+")";
								//bb.writeLog(insertSQL);
						        //rst.executeSql(insertSQL);
						        String callparam = Integer.toString(dirid)+Util.getSeparator()+dirtype+Util.getSeparator()+operationcode+Util.getSeparator()+administrators;
						        boolean f = rs.executeProc("Doc_DirAcl_Insert_Type5", callparam);
						        //bb.writeLog(f);
							}
			        	}
			        }
			        
			        //门户

			        diridArray = portalids.split(",");
			        /*
			        if(portalids!=null && diridArray.length>0){
			           delSQL="delete from ptAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype+" and dirid in ("+portalids+") ";
			           //bb.writeLog(delSQL);
			           rst.executeSql(delSQL);
			        }
			        //System.out.println(">>>>>>>>门户 delSQL="+delSQL+";portalids="+portalids);
			        */
	        		delSQL="delete from ptAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype+"  ";//and dirid = '"+dirid+"'
	            //bb.writeLog(delSQL);
	            rst.executeSql(delSQL);
	            dirtype = "0";
			        for(int i=0;i<diridArray.length;i++){
			        	int dirid = Util.getIntValue(diridArray[i]);
			        	if(dirid > 0){
							if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
								String insertSQL = "insert into ptAccessControlList "+
												" (dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) "+
												" values "+
												" ("+dirid+", "+dirtype+", "+administrators+", "+rolelevel+", "+seclevel+", "+operationcode+", "+permissiontype+")";
								//bb.writeLog(insertSQL);
						        rst.executeSql(insertSQL);
							}else if(roleIdType == 2){//共享类型：5-人力资源
								String insertSQL = "insert into ptAccessControlList "+
												" (dirid, dirtype, userid, seclevel ,operationcode, permissiontype) "+
												" values "+
												" ("+dirid+", "+dirtype+", "+administrators+", "+seclevel+","+operationcode+", "+permissiontype+")";
								//bb.writeLog(insertSQL);
						
						        rst.executeSql(insertSQL);
							}
			        	}
			        }		        
			        
			        //协作区
			        /*
			        delSQL="delete from cwAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype = "+permissiontype;
					//bb.writeLog(delSQL);
			        rst.executeSql(delSQL);
			        diridArray = coworkids.split(",");
			        for(int i=0;i<diridArray.length;i++){
			        	int dirid = Util.getIntValue(diridArray[i]);
			        	if(dirid > 0){
							if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
								String insertSQL = "insert into cwAccessControlList "+
												" (dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) "+
												" values "+
												" ("+dirid+", "+dirtype+", "+administrators+", "+rolelevel+", "+seclevel+", "+operationcode+", "+permissiontype+")";
								//bb.writeLog(insertSQL);
						        rst.executeSql(insertSQL);
							}else if(roleIdType == 2){//共享类型：5-人力资源
								String insertSQL = "insert into cwAccessControlList "+
												" (dirid, dirtype, userid, operationcode, permissiontype) "+
												" values "+
												" ("+dirid+", "+dirtype+", "+administrators+", "+operationcode+", "+permissiontype+")";
								//bb.writeLog(insertSQL);
						        rst.executeSql(insertSQL);
							}
			        	}
			        }
			        */
					String permissiontype4="";
					String administrators4="";
					String sysAdminColStr4="";
					if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
						administrators4 = "'"+roleIds+"'";
						sysAdminColStr4 = "sharevalue";
						permissiontype4 = "4";
					}else if(roleIdType == 2){//共享类型：5-人力资源
						administrators4 = "'"+hrmIds+"'";
						sysAdminColStr4 = "sharevalue";
						permissiontype4 = "1";
					}
			        diridArray = coworkids.split(",");
			        /*
			        if(coworkids!=null && diridArray.length>0){
			           delSQL="delete from cotype_sharemanager where "+sysAdminColStr4+" = "+administrators4+" and sharetype = "+permissiontype4+" and cotypeid in ("+coworkids+") ";
					   //bb.writeLog(delSQL);
					   rst.executeSql(delSQL);
			        }
			        //System.out.println(">>>>>>>>协作 delSQL="+delSQL+";coworkids="+coworkids);
			        */
	        		delSQL="delete from cotype_sharemanager where "+sysAdminColStr4+" = "+administrators4+" and sharetype = "+permissiontype4+"  ";//and cotypeid = '"+dirid+"'
			        //bb.writeLog(delSQL);
			        rst.executeSql(delSQL);
			        for(int i=0;i<diridArray.length;i++){
			        	int dirid = Util.getIntValue(diridArray[i]);
			        	if(dirid > 0){
							if(roleIdType == 1){//共享类型：2-角色＋安全级别＋级别
								String insertSQL = "insert into cotype_sharemanager "+
												" (cotypeid,sharetype,sharevalue,seclevel,rolelevel) "+
												" values "+
												" ("+dirid+", "+permissiontype4+", "+administrators4+", "+seclevel+", "+rolelevel+")";
							//bb.writeLog(insertSQL);
						        rst.executeSql(insertSQL);
							}else if(roleIdType == 2){//共享类型：5-人力资源
								String insertSQL = "insert into cotype_sharemanager "+
												" (cotypeid,sharetype,sharevalue,seclevel,rolelevel) "+
												" values "+
												" ("+dirid+", "+permissiontype4+", "+administrators4+", "+seclevel+", "+rolelevel+")";
								//bb.writeLog(insertSQL);
						        rst.executeSql(insertSQL);
							}
							
	                        String sql="select id  from cowork_items where typeid='"+dirid+"' ";
	                        rs.executeSql(sql);
	                        CoworkShareManager shareManager=new CoworkShareManager();
	                        while(rs.next()){
	     	                   String coworkid=rs.getString("id");
	     	                   shareManager.deleteCache("typemanager",coworkid); //删除协作缓存
	                        }						
							
			        	}
			        }	
		        }
		        	        
		        
		        
		        
	
				rst.commit();
				
			}catch(Exception ex1){
				try{
					returnFlag = ex1.getMessage();
					bb.writeLog(ex1);
					if(rst!=null){
						rst.rollback();
					}
				}catch(Exception ex2){
					bb.writeLog(ex2);
				}
			}
		}
		
		
		if("".equals(returnFlag)){
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
		}else{
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(returnFlag)+"}");//保存失败
		}
		out.flush();
		return;
		
	}else if(operation.equals("delete") || operation.equals("batchDelete")){//删除
		String batchDelIds = Util.null2String(request.getParameter("ids"));
		if(operation.equals("delete")){
			batchDelIds = Util.null2String(request.getParameter("id"));
		}
		String[] batchDelIdsArray = batchDelIds.split(",");
		
		String returnFlag = "";
		//System.out.println(">>>>>>>>删除 batchDelIds="+batchDelIds+";batchDelIds="+batchDelIds);
		for(int i=0;i<batchDelIdsArray.length;i++){
			String _delId = Util.null2String(batchDelIdsArray[i]).trim();
			String[] _delIdArray = _delId.split("_");
			if(!"".equals(_delId) && _delIdArray.length >= 2){
				
				String administrators = "'"+Util.getIntValue(_delIdArray[0])+"'";
				int permissiontype = Util.getIntValue(_delIdArray[1]);
				
				String sysAdminColStr = "";
				if(permissiontype == 2){//共享类型：2-角色＋安全级别＋级别
					sysAdminColStr = "roleid";
				}else if(permissiontype == 5){//共享类型：5-人力资源
					sysAdminColStr = "userid";
				}
				
				if(!"".equals(administrators) && !"".equals(sysAdminColStr)){
					RecordSetTrans rst = null;
					try{
						rst = new RecordSetTrans();
						rst.setAutoCommit(false);
						
						String dirtype = "0";
						String operationcode = "1";
				        int rolelevel = 2;//角色级别 默认为2-总部级别、1-分部级别、0-部门级别
					    int seclevel = 10;//安全级别 默认为10
				
					    String delSQL="";
					    String[] diridArray = new String[]{};
					    
					    //工作流类型
				        delSQL="delete from wfAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype in (2, 5)";
				        rst.executeSql(delSQL);

				        if (haspermission) {

					        //知识目录
					        delSQL="delete from DirAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 2 and operationcode = 1 and permissiontype in (2, 5)";
					        rst.executeSql(delSQL);
					        
					        //门户
					        delSQL="delete from ptAccessControlList where "+sysAdminColStr+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype in (2, 5)";
					        rst.executeSql(delSQL);
					        
					        //协作区
							String sysAdminColStr4 = "";
							int permissiontype4=-1;
							if(permissiontype == 2){//共享类型：2-角色＋安全级别＋级别
								sysAdminColStr4 = "sharevalue";
								permissiontype4=4;
							}else if(permissiontype == 5){//共享类型：5-人力资源
								sysAdminColStr4 = "sharevalue";
								permissiontype4=1;
							}
					      //delSQL="delete from cotype_sharemanager where "+sysAdminColStr4+" = "+administrators+" and dirtype = 0 and operationcode = 1 and permissiontype in (2, 5)";
					        delSQL="delete from cotype_sharemanager where "+sysAdminColStr4+" = "+administrators+" and sharetype = '"+permissiontype4+"' ";
					        //System.out.println(">>>>>>>>删除 协作delSQL="+delSQL);
					        rst.executeSql(delSQL);
				        }
				        
				        
			
						rst.commit();
						
					}catch(Exception ex1){
						try{
							returnFlag = ex1.getMessage();
							bb.writeLog(ex1);
							if(rst!=null){
								rst.rollback();
							}
						}catch(Exception ex2){
							bb.writeLog(ex2);
						}
					}
				}
			}
		}
		
		
		if("".equals(returnFlag)){
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
		}else{
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(returnFlag)+"}");//删除失败
		}
		out.flush();
		return;
		
	}else{
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"3")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
		
	}
}
%>