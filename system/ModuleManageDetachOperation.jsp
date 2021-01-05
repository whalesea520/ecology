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

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.util.regex.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="deleteRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
	out.flush();
	return;
}else{
	//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
	/*int userid=user.getUID();
	String sqlUid = "select count(*) cnt from HrmResourceManager where id='"+userid+"' ";
	rs.executeSql(sqlUid);
	if(!rs.next() || rs.getInt("cnt") <= 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
	}*/
	
	if(!HrmUserVarify.checkUserRight("HrmModuleManageDetach:Edit", user)){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
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
	String operationtype = Util.null2String(request.getParameter("cmd"));
	String operateType = "1";
	if(operationtype.equals("edit"))operateType = "2";
	
	if(operation.equals("save")){//保存 修改有改变的行(包括新增行和编辑行) 
		String rolelevel="2";//功能权限级别
		String rightlevel="2";//机构权限级别
		
		
		String returnFlag = "";

		String roleId = Util.null2String(request.getParameter("roleId")).trim();
		
		int roleIdType = Util.getIntValue(request.getParameter("roleIdType"));
		String roleIds = Util.null2String(request.getParameter("roleIds")).trim();
		String hrmIds = Util.null2String(request.getParameter("hrmIds")).trim();
		String hrmSubcomids = Util.null2String(request.getParameter("subIds")).trim();
		String moduleRightHRM = Util.null2String(request.getParameter("chkHrm")).trim();
		String moduleRightWF = Util.null2String(request.getParameter("chkWf")).trim();
		String moduleRightDOC = Util.null2String(request.getParameter("chkDoc")).trim();
		String moduleRightPORTAL = Util.null2String(request.getParameter("chkPortal")).trim();
		String moduleRightCPT = Util.null2String(request.getParameter("chkCpt")).trim();
		String moduleRightMTI = Util.null2String(request.getParameter("chkMti")).trim();
		
		String administrators = roleIds;
		if(roleIdType == 2){
			administrators = hrmIds;
		}

	
		String new_OR_modify = roleId;//不为空表示是编辑，为空表示新添加。

			
			
			if(!"".equals(new_OR_modify)){//(编辑)角色名称、功能权限、机构权限、成员等内容新增。不为空表示是编辑，为空表示新添加。
			  /*********************(编辑)1、机构权限 -相关设置后修改角色设置-对应的机构权限功能       Start************************/
			  if(roleIdType==1 && administrators!=null&&!"".equals(administrators)){//类型-角色
			  	char flag1=Util.getSeparator();
			    List mroles = new ArrayList();
			    List hrmSubcomidList = new ArrayList();
          mroles=Util.TokenizerString(administrators,",");
          hrmSubcomidList=Util.TokenizerString(hrmSubcomids,",");
             
    		 if(mroles!=null && mroles.size()>0){
    			for(int j=0;j<mroles.size();j++){
	            //删除老数据
	            String roleid=(String)mroles.get(j);
	          if(hrmSubcomidList!=null && hrmSubcomidList.size()>0){
	            String roleLevel = request.getParameter("roleLevel");//此参数无实际意义  机构权限保存时值为null
	            //RecordSetTrans.executeProc("HrmRoleStrRight_Del",roleid); //此种连接方式执行有性能问题
	            rs1.executeProc("HrmRoleStrRight_Del",roleid);
              for(int m=0;m<hrmSubcomidList.size();m++){
	              String subid=(String)hrmSubcomidList.get(m);
	              String sellevel=rightlevel;//默认为2-完全控制
	              String sql1="select * from SysRoleSubcomRight where roleid='"+roleid+"' and subcompanyid='"+subid+"' ";
	              rs.executeSql(sql1);
	              int rscount=rs.getCounts();
	              if(rscount<=0){//说明该角色对应的机构已经存在 不做任何操作
	                String para2=roleid+flag1+subid+flag1+sellevel;
	                //重新插入数据
	                //RecordSetTrans.execute("HrmRoleStrRight_ins",para2);//此种连接方式执行有性能问题
	                rs1.execute("HrmRoleStrRight_ins",para2);
	             		String subcompname = scci.getSubCompanyname(subid);
	             		String LevelName ="";
                  if(sellevel.equals("2")){//默认为2-完全控制
                  	LevelName = SystemEnv.getHtmlLabelName(17874,user.getLanguage());
                  }else if (sellevel.equals("-1")){
                  	LevelName = SystemEnv.getHtmlLabelName(17875,user.getLanguage());
	               	}else if(sellevel.equals("0")){
		              	LevelName = SystemEnv.getHtmlLabelName(17873,user.getLanguage());
	               	}else if (sellevel.equals("1")){
		              	LevelName = SystemEnv.getHtmlLabelName(93,user.getLanguage());
	               	}
									sysMaintenanceLog.resetParameter();
									sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
									sysMaintenanceLog.setRelatedName(subcompname+":"+LevelName);
									sysMaintenanceLog.setOperateType(operateType);
									sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,"+para2);
									sysMaintenanceLog.setOperateItem("103");
									sysMaintenanceLog.setOperateUserid(user.getUID());
									sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
									sysMaintenanceLog.setSysLogInfo();
		
                 }
	              }
	              //checkUserRight.updateRoleRightdetail(roleid , roleid , roleLevel) ;
	              checkUserRight.removeRoleRightdetailCache();	
              } else {
            	  rs1.executeProc("HrmRoleStrRight_Del",roleid);
              }
	          }
    		  }  			     
    		  //编辑角色
    		  String rolesmark = "";
    		  rs.executeSql("select rolesmark from HrmRoles where id =  "+roleIds);
    		  if(rs.next()){
    		  	rolesmark=rs.getString("rolesmark");
    		  }
					sysMaintenanceLog.resetParameter();
					sysMaintenanceLog.setRelatedId(Util.getIntValue(roleIds));
					sysMaintenanceLog.setRelatedName(rolesmark);
					sysMaintenanceLog.setOperateType(operateType);
					sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,");
					sysMaintenanceLog.setOperateItem("167");
					sysMaintenanceLog.setOperateUserid(user.getUID());
					sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
					sysMaintenanceLog.setSysLogInfo();
			  }else if(roleIdType==2 && administrators!=null&&!"".equals(administrators)){//类型-人员
			  	char flag1=Util.getSeparator();
			     List hrmSubcomidList = new ArrayList();
           hrmSubcomidList=Util.TokenizerString(hrmSubcomids,",");
           //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)1、机构权限  角色id  new_OR_modify="+new_OR_modify);
    		 	 if(new_OR_modify!=null && !"".equals(new_OR_modify)){
           	if(hrmSubcomidList!=null && hrmSubcomidList.size()>0){
	            //删除老数据
	            String roleid=new_OR_modify;
	            String roleLevel = request.getParameter("roleLevel");//此参数无实际意义  机构权限保存时值为null
	            //RecordSetTrans.executeProc("HrmRoleStrRight_Del",roleid); //此种连接方式执行有性能问题
	            rs1.executeProc("HrmRoleStrRight_Del",roleid);
	            for(int m=0;m<hrmSubcomidList.size();m++){
	              String subid=(String)hrmSubcomidList.get(m);
	              String sellevel=rightlevel;//默认为2-完全控制
	              String sql1="select * from SysRoleSubcomRight where roleid='"+roleid+"' and subcompanyid='"+subid+"' ";
	              rs.executeSql(sql1);
	              int rscount=rs.getCounts();
	              if(rscount<=0){//说明该角色对应的机构已经存在 不做任何操作
	              	String para2=roleid+flag1+subid+flag1+sellevel;
	                //重新插入数据
	                //RecordSetTrans.execute("HrmRoleStrRight_ins",para2);//此种连接方式执行有性能问题
	                rs1.execute("HrmRoleStrRight_ins",para2);
	            		String subcompname = scci.getSubCompanyname(subid);
	            		String LevelName ="";
	            		if(sellevel.equals("2")){//默认为2-完全控制
	             			LevelName = SystemEnv.getHtmlLabelName(17874,user.getLanguage());
	            		}else if (sellevel.equals("-1")){
	             			LevelName = SystemEnv.getHtmlLabelName(17875,user.getLanguage());
									}else if(sellevel.equals("0")){
					        	LevelName = SystemEnv.getHtmlLabelName(17873,user.getLanguage());
					        }else if (sellevel.equals("1")){
					        	LevelName = SystemEnv.getHtmlLabelName(93,user.getLanguage());
					        }
									sysMaintenanceLog.resetParameter();
									sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
									sysMaintenanceLog.setRelatedName(subcompname+":"+LevelName);
									sysMaintenanceLog.setOperateType(operateType);
									sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,"+para2);
									sysMaintenanceLog.setOperateItem("103");
									sysMaintenanceLog.setOperateUserid(user.getUID());
									sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
									sysMaintenanceLog.setSysLogInfo();
		
								}
	             }
	              //checkUserRight.updateRoleRightdetail(roleid , roleid , roleLevel) ;
	              checkUserRight.removeRoleRightdetailCache();	  
	            } 
           	}   
    		 	 	//编辑人员
	 	   		  String lastname = "";
		   		  String sql = " select distinct bb.lastname name from hrmrolemembers aa "
	  					 + " join HrmResource bb on aa.resourceid = bb.id "
	   		       + " where aa.roleid = "+administrators;
	  				rs.executeSql(sql);
		  		  if(rs.next()){
		  		  	lastname=rs.getString("name");
		  		  }
						sysMaintenanceLog.resetParameter();
						sysMaintenanceLog.setRelatedId(Util.getIntValue(administrators));
						sysMaintenanceLog.setRelatedName(lastname);
						sysMaintenanceLog.setOperateType(operateType);
						sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,");
						sysMaintenanceLog.setOperateItem("167");
						sysMaintenanceLog.setOperateUserid(user.getUID());
						sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
						sysMaintenanceLog.setSysLogInfo();
			  }
			  /*********************(编辑)1、机构权限-相关设置后修改角色设置-对应的机构权限功能       End**************************/ 
			  
        /*********************(编辑)2、功能权限-相关设置后修改角色设置-对应的功能权限功能       Start************************/  	
        if(roleIdType==1 && administrators!=null&&!"".equals(administrators)){//类型-角色  
          char separator = Util.getSeparator();
          List rightidList2 = new ArrayList();
          List mroles = new ArrayList();
          mroles=Util.TokenizerString(administrators,",");
          if(mroles!=null && mroles.size()>0){
    			for(int j=0;j<mroles.size();j++){
    			     String roleid=(String)mroles.get(j);
	                 if("1".equals(moduleRightHRM)){
	                    rightidList2.add("22");
	                    rightidList2.add("25");
	                 }
	                 if("1".equals(moduleRightWF)){
	                    rightidList2.add("91");
	                    rightidList2.add("591");
	                 } 
	                 if("1".equals(moduleRightDOC)){//文档 还未开发分权功能
	                	  rightidList2.add("8");
	                	 	rightidList2.add("10");
	                    rightidList2.add("11");
	                    rightidList2.add("453");
	                 } 
	                 if("1".equals(moduleRightPORTAL)){//门户 还未开发分权功能
	                    rightidList2.add("599");
	                    rightidList2.add("645");
	                    rightidList2.add("659");
	                 } 
	                 if("1".equals(moduleRightCPT)){//资产
	                    rightidList2.add("439");
	                 } 
	                 if("1".equals(moduleRightMTI)){//会议
	                    rightidList2.add("200");
	                    rightidList2.add("350");
	                 }   

				  		//查询每个角色下拥有的权限(权限范围为：权限id=22,25,91,591,8,10,11,453,599,645,659,439,200,350)
						 List delrightidList = new ArrayList();
						 String sql3 = " select * from systemrightroles where roleid='"+roleid+"' and rightid in (22,25,91,591,8,10,11,453,599,645,659,439,200,350) ";
						 //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 sql3="+sql3);
						 deleteRs.executeSql(sql3);
						 while(deleteRs.next()){
						     String rightidTemp=deleteRs.getString("rightid");
						     if(rightidTemp!=null&&!"".equals(rightidTemp)){
						        delrightidList.add(rightidTemp);
						     }
						 }
						 if(delrightidList!=null && delrightidList.size()>0){
						    for(int m3=0; m3<delrightidList.size(); m3++){
						        String delrightid_tmp=(String)delrightidList.get(m3);
						        //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 rightid_tmp="+rightid_tmp);
						        String sql4="DELETE SystemRightRoles WHERE rightid = '"+delrightid_tmp+"' and roleid='"+roleid+"' ";
						        //deleteRs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
						        deleteRs.executeSql(sql4);
						    }
						 } 		 
             if(rightidList2!=null && rightidList2.size()>0){
				         for(int m2=0; m2<rightidList2.size(); m2++){
				                String rightid_tmp=(String)rightidList2.get(m2);
								String rightname_tmp=Util.toScreen(rightComInfo.getRightname(rightid_tmp,""+user.getLanguage()),user.getLanguage());

	                            //rs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
	                            
				                String para=rightid_tmp+separator+roleid+separator+rolelevel;
				                rs.execute("SystemRightRoles_Insert",para);
				                
				                sysMaintenanceLog.resetParameter();
				                sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
				                sysMaintenanceLog.setRelatedName(rolesComInfo.getRolesRemark(roleid)+":"+rightname_tmp);
				                sysMaintenanceLog.setOperateType(operateType);
				                sysMaintenanceLog.setOperateDesc("SystemRightRoles_Insert,"+para);
				                sysMaintenanceLog.setOperateItem("102");
				                sysMaintenanceLog.setOperateUserid(user.getUID());
				                sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				                sysMaintenanceLog.setSysLogInfo();
				                
				
				            
				        }   
	                //checkUserRight.updateRoleRightdetail(roleid , rightid_tmp , rolelevel) ;
	                checkUserRight.removeMemberRoleCache();
	                checkUserRight.removeRoleRightdetailCache();
	                 }    
    			}
    		 }	
			  }else if(roleIdType==2 && administrators!=null&&!"".equals(administrators)){//类型-人员
             char separator = Util.getSeparator();
             List rightidList4 = new ArrayList();
             //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)2、功能权限  角色id  new_OR_modify="+new_OR_modify);
             if(new_OR_modify!=null && !"".equals(new_OR_modify)){
    			     String roleid=new_OR_modify;
	                 if("1".equals(moduleRightHRM)){
	                    rightidList4.add("22");
	                    rightidList4.add("25");
	                 }
	                 if("1".equals(moduleRightWF)){
	                    rightidList4.add("91");
	                    rightidList4.add("591");
	                 } 
	                 if("1".equals(moduleRightDOC)){//文档 还未开发分权功能
	                	 	rightidList4.add("8");
	                	  rightidList4.add("10");
	                    rightidList4.add("11");
	                    rightidList4.add("453");
	                 } 
	                 if("1".equals(moduleRightPORTAL)){//门户 还未开发分权功能
	                    rightidList4.add("599");
	                    rightidList4.add("645");
	                    rightidList4.add("659");
	                 } 
	                 if("1".equals(moduleRightCPT)){//资产
	                    rightidList4.add("439");
	                 } 
	                 if("1".equals(moduleRightMTI)){//会议
	                    rightidList4.add("200");
	                    rightidList4.add("350");
	                 }   
	                 //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)2、功能权限   rightidList4.size()="+rightidList4.size());
	                 if(rightidList4!=null && rightidList4.size()>0){
	                 
				  		//查询每个角色下拥有的权限(权限范围为：权限id=22,25,91,591,8,10,11,453,599,645,659,439,200,350)
						 List delrightidList1 = new ArrayList();
						 String sql3 = " select * from systemrightroles where roleid='"+roleid+"' and rightid in (22,25,91,591,8,10,11,453,599,645,659,439,200,350) ";
						 //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 sql3="+sql3);
						 deleteRs.executeSql(sql3);
						 while(deleteRs.next()){
						     String rightidTemp=deleteRs.getString("rightid");
						     if(rightidTemp!=null&&!"".equals(rightidTemp)){
						        delrightidList1.add(rightidTemp);
						     }
						 }
						 //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)2、功能权限    delrightidList1.size()="+delrightidList1.size());
						 if(delrightidList1!=null && delrightidList1.size()>0){
						    for(int m5=0; m5<delrightidList1.size(); m5++){
						        String delrightid_tmp=(String)delrightidList1.get(m5);
						        //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 rightid_tmp="+rightid_tmp);
						        //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)2、功能权限   删除第"+m5+"个 delrightid_tmp="+delrightid_tmp);
						        String sql4=" DELETE SystemRightRoles WHERE rightid = '"+delrightid_tmp+"' and roleid='"+roleid+"' ";
						        //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)2、功能权限    sql4="+sql4);
						        //deleteRs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
						        deleteRs.executeSql(sql4);
						    }
						 }  		                 
	                 
				         for(int m4=0; m4<rightidList4.size(); m4++){
				                String rightid_tmp=(String)rightidList4.get(m4);
								String rightname_tmp=Util.toScreen(rightComInfo.getRightname(rightid_tmp,""+user.getLanguage()),user.getLanguage());
                                //System.out.println(">>>>>>>>>>>>>>>>>>类型-人员 (编辑)2、功能权限   第"+m4+"个 rightid_tmp="+rightid_tmp);
	                            //rs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
	                            

				                String para=rightid_tmp+separator+roleid+separator+rolelevel;
				                rs.execute("SystemRightRoles_Insert",para);
				                /*
				                SysMaintenanceLog.resetParameter();
				                SysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
				                SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleid)+":"+rightname_tmp);
				                SysMaintenanceLog.setOperateType(operateType);
				                SysMaintenanceLog.setOperateDesc("SystemRightRoles_Insert,"+para);
				                SysMaintenanceLog.setOperateItem("102");
				                SysMaintenanceLog.setOperateUserid(user.getUID());
				                SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				                SysMaintenanceLog.setSysLogInfo();
				                */
				                
				                
				            
				        }  
	                //checkUserRight.updateRoleRightdetail(roleid , rightid_tmp , rolelevel) ;
	                checkUserRight.removeMemberRoleCache();
	                checkUserRight.removeRoleRightdetailCache();
	                 }    
    		 }	  			  
			  
			  }             
         /*********************(编辑)2、功能权限-相关设置后修改角色设置-对应的功能权限功能        End**************************/		   			  
			  
			  

			}else{//(新增)角色名称、功能权限、机构权限、成员等内容新增
			  /*
	      String insertSQL = "insert into moduleManageDetach(manageType,administrators,Seclevel,hrmSubcomids,wfSubcomids,docSubcomids,portalSubcomids,cptSubcomids,mtiSubcomids,created_by,created_date,updated_by,updated_date,remark) " +
			"values('"+manageType+"','"+administrators+"',"+Seclevel+",'"+hrmSubcomids+"','"+wfSubcomids+"','"+docSubcomids+"','"+portalSubcomids+"','"+cptSubcomids+"','"+mtiSubcomids+"','"+created_by+"','"+created_date+"',"+updated_by+",'"+updated_date+"','')";  			
			  //System.out.println(">>>>>>>>>>>>>>>>>>insertSQL="+insertSQL);
			  RecordSetTrans.executeSql(insertSQL);
			  */
			  
			  
			  /*****(新增)1、角色名称-相关设置后修改角色设置-对应的角色名称功能(虚拟角色-角色ID以负数标识，新建角色表：hrmroles_module)  Start******/
			  if(roleIdType==2 && administrators!=null&&!"".equals(administrators)){//类型-人员
				/*
				if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		    		response.sendRedirect("/notice/noright.jsp");
		    		return;
				}
				*/

			  int minID=0;	
			  String minIDSQL="select Min(id) AS minid from hrmroles_module where 1=1 ";
			  rs4.executeSql(minIDSQL);
			  if(rs4.next()){
			     if(rs4.getString("minid")==null || "".equals(rs4.getString("minid"))){
			       minID=-1;
			     }else{
			       minID=rs4.getInt("minid");
			       minID=minID-1;
			     }
			  }
		      String insertSQL = "insert into hrmroles_module(id,rolesmark,rolesname,docid,isdefault,type,subcompanyid) " +
				"values("+minID+",'模块管理分权虚拟角色"+minID+"','模块管理分权虚拟角色"+minID+"',0,'','0','0')";  			
  			  //System.out.println(">>>>>>>>>>>>>>>>>>(新建)模块分权管理虚拟角色insertSQL="+insertSQL+";maxID="+minID);
  			  rs4.executeSql(insertSQL);	
			  
			  }else if(roleIdType==1 && administrators!=null&&!"".equals(administrators)){//类型-角色
			      //无需做任何操作：按照原来角色逻辑即可
			  
			  }
			   
			  /*****(新增)1、角色名称-相关设置后修改角色设置-对应的角色名称功能(虚拟角色-角色ID以负数标识，新建角色表：hrmroles_module)  End********/
			  
			  /*********************(新增)2、机构权限-相关设置后修改角色设置-对应的机构权限功能       Start************************/
			  if(roleIdType==1 && administrators!=null&&!"".equals(administrators)){//类型-角色
			     char flag1=Util.getSeparator();
			     List mroles = new ArrayList();
			     List hrmSubcomidList = new ArrayList();
             mroles=Util.TokenizerString(administrators,",");
             hrmSubcomidList=Util.TokenizerString(hrmSubcomids,",");
             //System.out.println(">>>>>>>>>>>>>>>>>>(类型-角色  新建角色机构权限)hrmSubcomids="+hrmSubcomids+";hrmSubcomidList.size()="+hrmSubcomidList.size());
    		 if(mroles!=null && mroles.size()>0){
    			for(int j=0;j<mroles.size();j++){
                   if(hrmSubcomidList!=null && hrmSubcomidList.size()>0){
                      //删除老数据
                      String roleid=(String)mroles.get(j);
                      String roleLevel = request.getParameter("roleLevel");//此参数五实际意义  机构权限保存时值为null
                      //RecordSetTrans.executeProc("HrmRoleStrRight_Del",roleid);//此种连接方式执行有性能问题
                      //rs2.executeProc("HrmRoleStrRight_Del",roleid);
                      for(int m=0;m<hrmSubcomidList.size();m++){
                           
                           String subid=(String)hrmSubcomidList.get(m);
                           String sellevel="2";//默认为2-完全控制
                           String sql1="select * from SysRoleSubcomRight where roleid='"+roleid+"' and subcompanyid='"+subid+"' ";
                           rs.executeSql(sql1);
                           int rscount=rs.getCounts();
                           if(rscount<=0){//说明该角色对应的机构已经存在 不做任何操作
	                           String para2=roleid+flag1+subid+flag1+sellevel;
	                           //重新插入数据
	                           //RecordSetTrans.execute("HrmRoleStrRight_ins",para2);//此种连接方式执行有性能问题
	                           rs2.execute("HrmRoleStrRight_ins",para2);
			                   String subcompname = scci.getSubCompanyname(subid);
			                   String LevelName ="";
			                   if(sellevel.equals("2")){//默认为2-完全控制
				                   LevelName = SystemEnv.getHtmlLabelName(17874,user.getLanguage());
			                   }else if (sellevel.equals("-1")){
				                   LevelName = SystemEnv.getHtmlLabelName(17875,user.getLanguage());
				               }else if(sellevel.equals("0")){
					              LevelName = SystemEnv.getHtmlLabelName(17873,user.getLanguage());
				               }else if (sellevel.equals("1")){
					              LevelName = SystemEnv.getHtmlLabelName(93,user.getLanguage());
				               }
				               sysMaintenanceLog.resetParameter();
				               sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
				               sysMaintenanceLog.setRelatedName(subcompname+":"+LevelName);
				               sysMaintenanceLog.setOperateType(operateType);
				               sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,"+para2);
				               sysMaintenanceLog.setOperateItem("103");
				               sysMaintenanceLog.setOperateUserid(user.getUID());
				               sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				               sysMaintenanceLog.setSysLogInfo();
		
                           }
                      }
                      //checkUserRight.updateRoleRightdetail(roleid , roleid , roleLevel) ;
                      checkUserRight.removeRoleRightdetailCache();	    
                   } 
    			}
    		  }  			     
    		  
	   		  String rolesmark = "";
	  		  rs.executeSql("select rolesmark from HrmRoles where id =  "+roleIds);
	  		  if(rs.next()){
	  		  	rolesmark=rs.getString("rolesmark");
	  		  }
					sysMaintenanceLog.resetParameter();
					sysMaintenanceLog.setRelatedId(Util.getIntValue(roleIds));
					sysMaintenanceLog.setRelatedName(rolesmark);
					sysMaintenanceLog.setOperateType(operateType);
					sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,");
					sysMaintenanceLog.setOperateItem("167");
					sysMaintenanceLog.setOperateUserid(user.getUID());
					sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
					sysMaintenanceLog.setSysLogInfo();
			  }else if(roleIdType==2 && administrators!=null&&!"".equals(administrators)){//类型-人员
			 
			  int minID=0;	
			  String minIDSQL="select Min(id) AS minid from hrmroles_module where 1=1 ";
			  rs4.executeSql(minIDSQL);
			  if(rs4.next()){
			     if(rs4.getString("minid")==null || "".equals(rs4.getString("minid"))){
			       minID=-1;
			     }else{
			       minID=rs4.getInt("minid");
			     }
			  }
			  String roleid_1=minID+"";			  
			  
			     char flag1=Util.getSeparator();
			     List mroles = new ArrayList();
			     List hrmSubcomidList = new ArrayList();
             mroles=Util.TokenizerString(administrators,",");
             hrmSubcomidList=Util.TokenizerString(hrmSubcomids,",");
             //System.out.println(">>>>>>>>>>>>>>>>>>(类型-人员  新建角色机构权限)hrmSubcomids="+hrmSubcomids+";hrmSubcomidList.size()="+hrmSubcomidList.size());
    		 if(mroles!=null && mroles.size()>0){
    			for(int j=0;j<mroles.size();j++){
                   if(hrmSubcomidList!=null && hrmSubcomidList.size()>0){
                      //删除老数据
                      String roleid=(String)mroles.get(j);
                      String roleLevel = request.getParameter("roleLevel");//此参数五实际意义  机构权限保存时值为null
                      //RecordSetTrans.executeProc("HrmRoleStrRight_Del",roleid);//此种连接方式执行有性能问题
                      //rs2.executeProc("HrmRoleStrRight_Del",roleid);
                      for(int m=0;m<hrmSubcomidList.size();m++){
                           
                           String subid=(String)hrmSubcomidList.get(m);
                           String sellevel="2";//默认为2-完全控制
                           String sql1="select * from SysRoleSubcomRight where roleid='"+roleid_1+"' and subcompanyid='"+subid+"' ";
                           rs.executeSql(sql1);
                           int rscount=rs.getCounts();
                           if(rscount<=0){//说明该角色对应的机构已经存在 不做任何操作
	                           String para2=roleid_1+flag1+subid+flag1+sellevel;
	                           //重新插入数据
	                           //RecordSetTrans.execute("HrmRoleStrRight_ins",para2);//此种连接方式执行有性能问题
	                           rs2.execute("HrmRoleStrRight_ins",para2);
			                   String subcompname = scci.getSubCompanyname(subid);
			                   String LevelName ="";
			                   if(sellevel.equals("2")){//默认为2-完全控制
				                   LevelName = SystemEnv.getHtmlLabelName(17874,user.getLanguage());
			                   }else if (sellevel.equals("-1")){
				                   LevelName = SystemEnv.getHtmlLabelName(17875,user.getLanguage());
				               }else if(sellevel.equals("0")){
					              LevelName = SystemEnv.getHtmlLabelName(17873,user.getLanguage());
				               }else if (sellevel.equals("1")){
					              LevelName = SystemEnv.getHtmlLabelName(93,user.getLanguage());
				               }
				               sysMaintenanceLog.resetParameter();
				               sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid_1));
				               sysMaintenanceLog.setRelatedName(subcompname+":"+LevelName);
				               sysMaintenanceLog.setOperateType(operateType);
				               sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,"+para2);
				               sysMaintenanceLog.setOperateItem("103");
				               sysMaintenanceLog.setOperateUserid(user.getUID());
				               sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				               sysMaintenanceLog.setSysLogInfo();
                   
                           }
                      }
                      //checkUserRight.updateRoleRightdetail(roleid_1 , roleid_1 , roleLevel) ;
                      checkUserRight.removeRoleRightdetailCache();	        
                   } 
    			}
    		  }    			  
	   		  String lastname = "";
	   		  String sql = " select lastname from HrmResource where id = "+hrmIds;
	  		  rs.executeSql(sql);
	  		  if(rs.next()){
	  		  	lastname=rs.getString("lastname");
	  		  }
					sysMaintenanceLog.resetParameter();
					sysMaintenanceLog.setRelatedId(Util.getIntValue(administrators));
					sysMaintenanceLog.setRelatedName(lastname);
					sysMaintenanceLog.setOperateType(operateType);
					sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,");
					sysMaintenanceLog.setOperateItem("167");
					sysMaintenanceLog.setOperateUserid(user.getUID());
					sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
					sysMaintenanceLog.setSysLogInfo();
			  }
			  /*********************(新增)2、机构权限-相关设置后修改角色设置-对应的机构权限功能       End**************************/  			  
			  
         /*********************(新增)3、功能权限-相关设置后修改角色设置-对应的功能权限功能       Start************************/  	
          if(roleIdType==1 && administrators!=null&&!"".equals(administrators)){//类型-角色  
             char separator = Util.getSeparator();
             List rightidList6 = new ArrayList();
             List mroles = new ArrayList();
             mroles=Util.TokenizerString(administrators,",");
             if(mroles!=null && mroles.size()>0){
    			for(int j=0;j<mroles.size();j++){
    			     String roleid=(String)mroles.get(j);
	                 if("1".equals(moduleRightHRM)){
	                    rightidList6.add("22");
	                    rightidList6.add("25");
	                 }
	                 if("1".equals(moduleRightWF)){
	                    rightidList6.add("91");
	                    rightidList6.add("591");
	                 } 
	                 if("1".equals(moduleRightDOC)){//文档 还未开发分权功能
	                	 	rightidList6.add("8");
	                	  rightidList6.add("10");
	                    rightidList6.add("11");
	                    rightidList6.add("453");
	                 } 
	                 if("1".equals(moduleRightPORTAL)){//门户 还未开发分权功能
	                    rightidList6.add("599");
	                    rightidList6.add("645");
	                    rightidList6.add("659");
	                 } 
	                 if("1".equals(moduleRightCPT)){//资产
	                    rightidList6.add("439");
	                 } 
	                 if("1".equals(moduleRightMTI)){//会议
	                    rightidList6.add("200");
	                    rightidList6.add("350");
	                 }   
	                 if(rightidList6!=null && rightidList6.size()>0){
				         for(int m6=0; m6<rightidList6.size(); m6++){
				                String rightid_tmp=(String)rightidList6.get(m6);
								String rightname_tmp=Util.toScreen(rightComInfo.getRightname(rightid_tmp,""+user.getLanguage()),user.getLanguage());

	                            //rs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
	                            
				                String para=rightid_tmp+separator+roleid+separator+rolelevel;
				                rs.execute("SystemRightRoles_Insert",para);
				
				                sysMaintenanceLog.resetParameter();
				                sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
				                sysMaintenanceLog.setRelatedName(rolesComInfo.getRolesRemark(roleid)+":"+rightname_tmp);
				                sysMaintenanceLog.setOperateType(operateType);
				                sysMaintenanceLog.setOperateDesc("SystemRightRoles_Insert,"+para);
				                sysMaintenanceLog.setOperateItem("102");
				                sysMaintenanceLog.setOperateUserid(user.getUID());
				                sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				                sysMaintenanceLog.setSysLogInfo();
				
				            
				        }      
	                //checkUserRight.updateRoleRightdetail(roleid , rightid_tmp , rolelevel) ;
	                checkUserRight.removeMemberRoleCache();
	                checkUserRight.removeRoleRightdetailCache();
	                 }    
    			}
    		 }	
			  }else if(roleIdType==2 && administrators!=null&&!"".equals(administrators)){//类型-人员
			  
			  int minID=0;	
			  String minIDSQL="select Min(id) AS minid from hrmroles_module where 1=1 ";
			  rs4.executeSql(minIDSQL);
			  if(rs4.next()){
			     if(rs4.getString("minid")==null || "".equals(rs4.getString("minid"))){
			       minID=-1;
			     }else{
			       minID=rs4.getInt("minid");
			     }
			  } 			  
	
              char separator = Util.getSeparator();
              List rightidList7 = new ArrayList();
    	      String roleid_1=minID+"";
    	      //System.out.println(">>>>>>>>>>>>>>>>>>(类型-人员  新建角色权限)roleid_1="+roleid_1);
    		  if(roleid_1!=null &&!"".equals(roleid_1)){
	                 if("1".equals(moduleRightHRM)){
	                    rightidList7.add("22");
	                    rightidList7.add("25");
	                 }
	                 if("1".equals(moduleRightWF)){
	                    rightidList7.add("91");
	                    rightidList7.add("591");
	                 } 
	                 if("1".equals(moduleRightDOC)){//文档 还未开发分权功能
	                	 	rightidList7.add("8");
	                	  rightidList7.add("10");
	                    rightidList7.add("11");
	                    rightidList7.add("453");
	                 } 
	                 if("1".equals(moduleRightPORTAL)){//门户 还未开发分权功能
                      rightidList7.add("599");
	                    rightidList7.add("645");
	                    rightidList7.add("659");
	                 } 
	                 if("1".equals(moduleRightCPT)){//资产
	                    rightidList7.add("439");
	                 } 
	                 if("1".equals(moduleRightMTI)){//门户
	                    rightidList7.add("200");
	                    rightidList7.add("350");
	                 }   
	                 //System.out.println(">>>>>>>>>>>>>>>>>>(类型-人员  新建角色权限)rightidList7.size()="+rightidList7.size());
	                 if(rightidList7!=null && rightidList7.size()>0){
				         for(int m7=0; m7<rightidList7.size(); m7++){
				                String rightid_tmp=(String)rightidList7.get(m7);
								String rightname_tmp=Util.toScreen(rightComInfo.getRightname(rightid_tmp,""+user.getLanguage()),user.getLanguage());

	                            //rs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
	                            
				                String para=rightid_tmp+separator+roleid_1+separator+rolelevel;
				                rs.execute("SystemRightRoles_Insert",para);
				                
				                /*
				                SysMaintenanceLog.resetParameter();
				                SysMaintenanceLog.setRelatedId(Util.getIntValue(roleid_1));
				                SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleid_1)+":"+rightname_tmp);
				                SysMaintenanceLog.setOperateType(operateType);
				                SysMaintenanceLog.setOperateDesc("SystemRightRoles_Insert,"+para);
				                SysMaintenanceLog.setOperateItem("102");
				                SysMaintenanceLog.setOperateUserid(user.getUID());
				                SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				                SysMaintenanceLog.setSysLogInfo();
				                */
				
				                
				                
				            
				        }  
	                //checkUserRight.updateRoleRightdetail(roleid_1 , rightid_tmp , rolelevel) ;
	                checkUserRight.removeMemberRoleCache();
	                checkUserRight.removeRoleRightdetailCache();
	                 }         			     
    		  }
    			    
 			  
			  
			  }             
         /*********************(新增)3、功能权限-相关设置后修改角色设置-对应的功能权限功能        End**************************/
         
         
         /*********************(新增)4、成员-相关设置后修改角色设置-对应的成员功能       Start************************/ 
			  if(roleIdType==2 && administrators!=null&&!"".equals(administrators)){//类型-人员
				int minID=0;	
				String minIDSQL="select Min(id) AS minid from hrmroles_module where 1=1 ";
				rs4.executeSql(minIDSQL);
				if(rs4.next()){
				    if(rs4.getString("minid")==null || "".equals(rs4.getString("minid"))){
				      minID=-1;
				    }else{
				      minID=rs4.getInt("minid");
				    }
				} 
				String roleid_1=minID+"";
				
				ArrayList resourceids = new ArrayList() ;
				resourceids=Util.TokenizerString(administrators,","); 
				//System.out.println(">>>>>>>>>>>>>>>>>>(类型-人员  新建角色成员)administrators="+administrators);
				if(resourceids!=null && resourceids.size()>0){
					for (int k=0; k<resourceids.size(); k++){
					  String level="2";
					  String employeeID=(String)resourceids.get(k);
					  String cmd=employeeID+flag+roleid_1+flag+level;
					  String resourcename = rci.getLastname(employeeID);
					  RecordSetTrans rst=new RecordSetTrans();
					  rst.setAutoCommit(false);
					  try{
					 	if(isoracle) rst.executeProc("HrmRoleMembers_Tri_In", cmd);
					 	if(isdb2) rst.executeProc("HrmRoleMembers_Tri_In", cmd);
					 	rst.executeProc("HrmRoleMembers_Insert",cmd);
					  
					 	//System.out.println(cmd+flag+"0"+flag+"0");
					 	rst.executeProc("HrmRoleMembersShare",cmd+flag+"0"+flag+"0");
					 	rst.commit();
					  }catch(Exception e){
					 	rst.rollback();
					 	e.printStackTrace();
					  }
					
						sysMaintenanceLog.resetParameter();
						sysMaintenanceLog.setRelatedId(Util.getIntValue(roleid_1));
						sysMaintenanceLog.setRelatedName(roleid_1+":"+resourcename);
						sysMaintenanceLog.setOperateType(operateType);
						sysMaintenanceLog.setOperateDesc("hrmroles_insertMember,"+cmd);
						sysMaintenanceLog.setOperateItem("32");
						sysMaintenanceLog.setOperateUserid(user.getUID());
						sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
						sysMaintenanceLog.setSysLogInfo();
						
						
					 }
			    //checkUserRight.updateMemberRole(employeeID , roleid_1 , level) ;
			    //reportShare.setReportShareByHrm(employeeID);
			    checkUserRight.removeMemberRoleCache();
			    checkUserRight.removeRoleRightdetailCache();
				}
			  }
			               
         /*********************(新增)4、成员-相关设置后修改角色设置-对应的成员功能       End**************************/ 	  			  

			  
			  
			  
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
		//System.out.println(">>>>>>>>删除 operation="+operation+";batchDelIds="+batchDelIds+";id="+Util.null2String(request.getParameter("id")));
		for(int i=0;i<batchDelIdsArray.length;i++){
			int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
			String relatedName = "";
			//System.out.println(">>>>>>>>删除 _delId="+_delId+";batchDelIdsArray.length="+batchDelIdsArray.length);
			//if(_delId > 0){
		  		/*********************(删除)1、机构权限 -相关设置后修改角色设置-对应的结构权限功能       Start************************/
		  		//System.out.println(">>>>>>>>>>>>>>>>>>删除  manageTypeFlag="+manageTypeFlag);
		  		if(_delId > 0){//类型-角色
	    		  rs.executeSql("select rolesmark from HrmRoles where id =  "+_delId);
	    		  if(rs.next()){
	    		  	relatedName=rs.getString("rolesmark");
	    		  }
		  			rs.executeProc("HrmRoleStrRight_Del",_delId+"");
		  		}else if(_delId < 0){//类型-人员
    		 	 	//编辑人员
		   		  String sql = " select distinct bb.lastname name from hrmrolemembers aa "
	  					 + " join HrmResource bb on aa.resourceid = bb.id "
	   		       + " where aa.roleid = "+_delId;
	  				rs.executeSql(sql);
		  		  if(rs.next()){
		  		  	relatedName=rs.getString("name");
		  		  }
		  			rs.executeProc("HrmRoleStrRight_Del",_delId+"");
		  		}
		  		/*********************(删除)1、机构权限 -相关设置后修改角色设置-对应的结构权限功能       End**************************/


         		
		  		/*********************(删除)2、功能权限-相关设置后修改角色设置-对应的功能权限功能       Start************************/
		  		if(_delId > 0){//类型-角色
			  		//查询每个角色下拥有的权限(权限范围为：权限id=22,25,91,591,8,10,11,453,599,645,659,439,200,350)
					 List rightidList1 = new ArrayList();
					 String sql3 = " select * from systemrightroles where roleid='"+_delId+"' and rightid in (22,25,91,591,8,10,11,453,599,645,659,439,200,350) ";
					 //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 sql3="+sql3);
					 rs.executeSql(sql3);
					 while(rs.next()){
					     String rightidTemp=rs.getString("rightid");
					     if(rightidTemp!=null&&!"".equals(rightidTemp)){
					        rightidList1.add(rightidTemp);
					     }
					 }
					 if(rightidList1!=null && rightidList1.size()>0){
					    for(int m1=0; m1<rightidList1.size(); m1++){
					        String rightid_tmp=(String)rightidList1.get(m1);
					        //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 rightid_tmp="+rightid_tmp);
					        String sql4="DELETE SystemRightRoles WHERE rightid = '"+rightid_tmp+"' and roleid='"+_delId+"' ";
					        //deleteRs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
					        rs.executeSql(sql4);
					    }
					 }  
		  		}else if(_delId < 0){//类型-人员
			  		//查询每个角色下拥有的权限(权限范围为：权限id=22,25,91,591,8,10,11,453,599,645,659,439,200,350)
					 List rightidList1 = new ArrayList();
					 String sql3 = " select * from systemrightroles where roleid='"+_delId+"' and rightid in (22,25,91,591,8,10,11,453,599,645,659,439,200,350) ";
					 //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 sql3="+sql3);
					 rs.executeSql(sql3);
					 while(rs.next()){
					     String rightidTemp=rs.getString("rightid");
					     if(rightidTemp!=null&&!"".equals(rightidTemp)){
					        rightidList1.add(rightidTemp);
					     }
					 }
					 if(rightidList1!=null && rightidList1.size()>0){
					    for(int m1=0; m1<rightidList1.size(); m1++){
					        String rightid_tmp=(String)rightidList1.get(m1);
					        //System.out.println(">>>>>>>>>>>>>>>>>>删除功能权限 rightid_tmp="+rightid_tmp);
					        String sql4="DELETE SystemRightRoles WHERE rightid = '"+rightid_tmp+"' and roleid='"+_delId+"' ";
					        //deleteRs.execute("SystemRightRoles_Delete",rightid_tmp);//不能使用此存储过程来删除  DELETE SystemRightRoles WHERE (id = id_1);
					        rs.executeSql(sql4);
					    }
					 }    		
		  		}  		
		  		/*********************(删除)2、功能权限-相关设置后修改角色设置-对应的功能权限功能       End**************************/ 

		  		
		  		/*********************(删除)3、成员-相关设置后修改角色设置-对应的成员功能       Start************************/
		  		if(_delId < 0){//类型-人员
				  	//根据角色id(负数)查询 角色成员表中的id,成员id	
				  	List idList = new ArrayList();
				  	List memberList = new ArrayList();
				  	String sql11="select * from hrmrolemembers  where  roleid ='"+_delId+"'";
				  	rs.executeSql(sql11);
				  	while(rs.next()){
				  	    String idTemp=rs.getString("id");
				  	    idList.add(idTemp);
				  	    String  memberTemp=rs.getString("resourceid");
				  	    memberList.add(memberTemp);
				  	}
				  	
				  	if(idList!=null &&idList.size()>0){
				       for(int m8=0;m8<idList.size();m8++){
				       	String id=(String)idList.get(m8);
					    String employeeID=(String)memberList.get(m8);
					    String resourcename = rci.getResourcename(employeeID);
				
					    String cmd=employeeID+flag+_delId ;
					
						RecordSetTrans rst1=new RecordSetTrans();
						rst1.setAutoCommit(false);
						try{
							if(isoracle) rst1.execute("HrmRoleMembers_Tri_De",cmd);
							if(isdb2) rst1.execute("HrmRoleMembers_Tri_De",cmd);
							rst1.execute("HrmRoleMembers_Delete",id);
							String level=Util.null2String(request.getParameter("level"));
							String level2=Util.null2String(request.getParameter("rolelevel2"));
							//System.out.println(employeeID+flag+roleID+flag+"0"+flag+level2+flag+"2");
							rst1.executeProc("HrmRoleMembersShare",employeeID+flag+_delId+flag+"0"+flag+level2+flag+"2");
							rst1.commit();
						}catch(Exception e){
							rst1.rollback();
							e.printStackTrace();
						}
					
						sysMaintenanceLog.resetParameter();
						sysMaintenanceLog.setRelatedId(_delId);
						sysMaintenanceLog.setRelatedName(_delId+":"+resourcename);
						sysMaintenanceLog.setOperateType("3");
						sysMaintenanceLog.setOperateDesc("HrmRoleMembers_Delete,"+id);
						sysMaintenanceLog.setOperateItem("32");
						sysMaintenanceLog.setOperateUserid(user.getUID());
						sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
						sysMaintenanceLog.setSysLogInfo();
						//RecordSetDB.executeProc("URole_workflow_createlist",""+roleID);  	  
					  	}
								//checkUserRight.deleteMemberRole(employeeID , _delId+"") ;
						    //reportShare.setReportShareByHrm(employeeID);
						    checkUserRight.removeMemberRoleCache();
						    checkUserRight.removeRoleRightdetailCache();
				       }		         
		  		}
		  		/*********************(删除)3、成员-相关设置后修改角色设置-对应的成员功能       End**************************/ 
		  		
		        /*********************(删除)4、角色名称-相关设置后修改角色设置-对应的角色名称功能       Start************************/  
		  		if(_delId < 0){//类型-人员
				  	String sql12="delete hrmroles_module where  id ='"+_delId+"'";
				  	rs.executeSql(sql12);
				 }        	
		        /*********************(删除)4、角色名称-相关设置后修改角色设置-对应的角色名称功能       End**************************/ 	
		  		
			//}
			
			  	 //删除设置  	 
	         sysMaintenanceLog.resetParameter();
	         sysMaintenanceLog.setRelatedId(_delId);
	         sysMaintenanceLog.setRelatedName(relatedName);
	         sysMaintenanceLog.setOperateType("3");
	         sysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,");
	         sysMaintenanceLog.setOperateItem("167");
	         sysMaintenanceLog.setOperateUserid(user.getUID());
	         sysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	         sysMaintenanceLog.setSysLogInfo();
		}

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
		out.flush();
		return;
		
	}else{
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"3")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
		
	}
}
%>