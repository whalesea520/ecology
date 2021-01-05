<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.companyvirtual.ResourceVirtualComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="ResourceVirtualComInfo" class="weaver.hrm.companyvirtual.ResourceVirtualComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="resourceInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.conn.RecordSetTrans"%>
<%
	String operation = Util.null2String(request.getParameter("operation"));
	String id = Util.null2String(request.getParameter("id"));
	String lastname = Util.null2String(request.getParameter("lastname"));
	String managerid = Util.null2String(request.getParameter("managerid"));
	String sql = "";
	
	if(operation.equals("setVirtualManager")){
		sql = " update HrmResourceVirtual set managerid='"+managerid+"' where id = "+id;
		rs.executeSql(sql);
		
		String virtualtype = "";
		String resourceid = "";
		String oldmanagerid = "";
		String oldmanagerstr = "";
		
		rs.executeSql("select resourceid,subcompanyid, managerid, managerstr,virtualtype from HrmResourceVirtual where id=" + id);
		if(rs.next()){
			virtualtype = rs.getString("virtualtype");
			resourceid = rs.getString("resourceid");
			oldmanagerid = rs.getString("managerid");
			oldmanagerstr = rs.getString("managerstr");
	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
      if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
      if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
		}
	
		
		String tempmanagerid = managerid;
		if("".equals(managerid)){
			managerid = oldmanagerid;
		}

		sql = "" ;
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		String managerstr = "";
		try{
			if(!"".equals(tempmanagerid)){
				/*更新managerstr*/
				if(!resourceid.equals(tempmanagerid)){
					rs.executeSql("select managerstr from HrmResourceVirtual a where resourceid = "+managerid +" and virtualtype="+virtualtype);//限值纬度
			        while(rs.next()){
			          managerstr = rs.getString("managerstr");
			   	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
			          if(!managerstr.startsWith(","))managerstr=","+managerstr;
			          if(!managerstr.endsWith(","))managerstr=managerstr+",";
			          /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
				      managerstr =","+managerid+managerstr; 
				      managerstr =managerstr.endsWith(",")?managerstr:(managerstr+",");
			        }
				}
		    if(managerstr.length()==0)managerstr =","+managerid+",";
		   	rst.executeSql("UPDATE HrmResourceVirtual SET managerstr = '"+managerstr+ "'  WHERE id ="+id);
			}else
				managerstr=oldmanagerstr;
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

		/*调整直接下级和间接下级 managerstr字段 开始*/
		if(!"".equals(tempmanagerid)){
			String temOldmanagerstr=","+resourceid +oldmanagerstr;
			temOldmanagerstr=temOldmanagerstr.endsWith(",")?temOldmanagerstr:(temOldmanagerstr+",");
		
		      sql = "select resourceid,subcompanyid, managerid, managerstr,virtualtype from HrmResourceVirtual where managerstr like '%"+temOldmanagerstr+ "'";
		      rs.executeSql(sql);
		      while(rs.next()){
				String nowmanagerstr = Util.null2String(rs.getString("managerstr"));
		     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
	      if(!nowmanagerstr.startsWith(","))nowmanagerstr=","+nowmanagerstr;
	      if(!nowmanagerstr.endsWith(","))nowmanagerstr=nowmanagerstr+",";
	      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
				resourceid = rs.getString("resourceid");
				managerid = rs.getString("managerid");
				//指定上级为自身的情况，不更新自身上级
				if(managerid.equals(resourceid))
					continue;
				String nowmanagerstr2="";
				int index=nowmanagerstr.lastIndexOf(oldmanagerstr);
				if(index!=-1){
					if(!"".equals(managerstr)){
					   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?managerstr.substring(1):managerstr);
					}   
					else{
					   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?"":",");
					} 
					
				}
				rst=new RecordSetTrans();
				rst.setAutoCommit(false);
				try{
					rst.executeSql("UPDATE HrmResourceVirtual SET managerstr = '"+nowmanagerstr2+ "'  WHERE resourceid ="+resourceid+" and virtualtype="+virtualtype);//限值纬度
					rst.commit();
				}catch(Exception e){
					rst.rollback();
					e.printStackTrace();
				}
		      }
		}
		/*调整直接下级和间接下级 managerstr字段 结束*/
		
	  SysMaintenanceLog.resetParameter();
	  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	  SysMaintenanceLog.setRelatedName(lastname);
	  SysMaintenanceLog.setOperateType("2");
	  SysMaintenanceLog.setOperateDesc(sql);
	  SysMaintenanceLog.setOperateItem("415");
	  SysMaintenanceLog.setOperateUserid(user.getUID());
	  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	  SysMaintenanceLog.setSysLogInfo();
	  ResourceVirtualComInfo.removeResourceVirtualCache();//重新加载缓存
	 	response.sendRedirect("HrmResourceVirtualManagerSet.jsp?isclose=1&id="+id);
	}else if(operation.equals("setVirtualManagers")){
		String ids = Util.null2String(request.getParameter("ids"));
		String[] arrayids = ids.split(",");
		
		for(int i=0;arrayids!=null&&i<arrayids.length;i++){
			String tmpid = arrayids[i];
			sql = " update HrmResourceVirtual set managerid='"+managerid+"' where id = "+tmpid;//不能设置自己为自己的上级
			rs.executeSql(sql);
			
			String virtualtype = "";
			String resourceid = "";
			String oldmanagerid = "";
			String oldmanagerstr = "";
			
			rs.executeSql("select resourceid, managerid, managerstr,virtualtype from HrmResourceVirtual where id=" + tmpid);
			if(rs.next()){
				virtualtype = rs.getString("virtualtype");
				resourceid = rs.getString("resourceid");
				oldmanagerid = rs.getString("managerid");
				oldmanagerstr = rs.getString("managerstr");
		     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
	      if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
	      if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
	      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
			}
			
			String tempmanagerid = managerid;
			if("".equals(managerid)){
				managerid = oldmanagerid;
			}

			sql = "" ;
			RecordSetTrans rst=new RecordSetTrans();
			rst.setAutoCommit(false);
			String managerstr = "";
			try{
				if(!"".equals(tempmanagerid)){
					/*更新managerstr*/
					if(!resourceid.equals(tempmanagerid)){
						rs.executeSql("select managerstr from HrmResourceVirtual a where resourceid = "+managerid
							+" and exists(select * from hrmsubcompanyvirtual b where a.subcompanyid=b.id and b.companyid="+virtualtype+"  )");//限值纬度
				        while(rs.next()){
				          managerstr = rs.getString("managerstr");
				   	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
				          if(!managerstr.startsWith(","))managerstr=","+managerstr;
				          if(!managerstr.endsWith(","))managerstr=managerstr+",";
				          /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
					      managerstr =","+managerid+managerstr; 
					      managerstr =managerstr.endsWith(",")?managerstr:(managerstr+",");
				        }
					}
			    if(managerstr.length()==0)managerstr =","+managerid+",";
			   	rst.executeSql("UPDATE HrmResourceVirtual SET managerstr = '"+managerstr+ "'  WHERE id ="+tmpid);
				}else
					managerstr=oldmanagerstr;
				rst.commit();
			}catch(Exception e){
				rst.rollback();
				e.printStackTrace();
			}

			/*调整直接下级和间接下级 managerstr字段 开始*/
			if(!"".equals(tempmanagerid)){
				String temOldmanagerstr=","+resourceid +oldmanagerstr;
				temOldmanagerstr=temOldmanagerstr.endsWith(",")?temOldmanagerstr:(temOldmanagerstr+",");
			
			      sql = "select resourceid,subcompanyid, managerid, managerstr from HrmResourceVirtual where managerstr like '%"+temOldmanagerstr+ "'";
			      rs.executeSql(sql);
			      while(rs.next()){
					String nowmanagerstr = Util.null2String(rs.getString("managerstr"));
			     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
		      if(!nowmanagerstr.startsWith(","))nowmanagerstr=","+nowmanagerstr;
		      if(!nowmanagerstr.endsWith(","))nowmanagerstr=nowmanagerstr+",";
		      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
					resourceid = rs.getString("resourceid");
					managerid = rs.getString("managerid");
					//指定上级为自身的情况，不更新自身上级
					if(managerid.equals(resourceid))
						continue;
					String nowmanagerstr2="";
					int index=nowmanagerstr.lastIndexOf(oldmanagerstr);
					if(index!=-1){
						if(!"".equals(managerstr)){
						   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?managerstr.substring(1):managerstr);
						}   
						else{
						   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?"":",");
						} 
						
					}
					rst=new RecordSetTrans();
					rst.setAutoCommit(false);
					try{
						rst.executeSql("UPDATE HrmResourceVirtual SET managerstr = '"+nowmanagerstr2+ "'  WHERE resourceid ="+resourceid
								+" and exists(select * from hrmsubcompanyvirtual b where HrmResourceVirtual.subcompanyid=b.id and b.companyid="+virtualtype+"  )");//限值纬度
						rst.commit();
					}catch(Exception e){
						rst.rollback();
						e.printStackTrace();
					}
			      }
			}
			/*调整直接下级和间接下级 managerstr字段 结束*/
		  SysMaintenanceLog.resetParameter();
		  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		  SysMaintenanceLog.setRelatedName(lastname);
		  SysMaintenanceLog.setOperateType("2");
		  SysMaintenanceLog.setOperateDesc(sql);
		  SysMaintenanceLog.setOperateItem("415");
		  SysMaintenanceLog.setOperateUserid(user.getUID());
		  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		  SysMaintenanceLog.setSysLogInfo();
		}
		ResourceVirtualComInfo.removeResourceVirtualCache();//重新加载缓存
	 	response.sendRedirect("HrmResourceVirtualManagerSets.jsp?isclose=1&ids="+ids);
	}else if(operation.equals("setDepartmentVirtual")){
		String resourceids = Util.null2String(request.getParameter("resourceids"));
		String departmentid = Util.null2String(request.getParameter("departmentid"));
		String subcompanyid = DepartmentVirtualComInfo.getSubcompanyid1(departmentid);
		String virtualtype = SubCompanyVirtualComInfo.getCompanyid(subcompanyid);
		
		String[] resourceid = resourceids.split(",");
		for(int i=0;resourceid!=null&&i<resourceid.length;i++){
			sql = " SELECT count(*) FROM HrmResourceVirtualView where virtualtype = " + virtualtype
					+ " and id = "+resourceid[i];
			rs.executeSql(sql);
			if(rs.next()){
				//如果已存在 无需处理
				if(rs.getInt(1)>0)continue;
			}
			
			//写入
			int tmpid = 0;
			rs.executeSql("select max(id) from HrmResourceVirtual ");
			if(rs.next()){
				tmpid = rs.getInt(1)+1;
			}
			
			sql = " insert into HrmResourceVirtual (id,resourceid,subcompanyid,departmentid,virtualtype ) "+
				    " values ("+tmpid+","+resourceid[i]+","+subcompanyid+","+departmentid+","+virtualtype+")";	
			rs.executeSql(sql);
			
		  SysMaintenanceLog.resetParameter();
		  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		  SysMaintenanceLog.setRelatedName(resourceInfo.getResourcename(resourceid[i]));
		  SysMaintenanceLog.setOperateType("2");
		  SysMaintenanceLog.setOperateDesc(sql);
		  SysMaintenanceLog.setOperateItem("415");
		  SysMaintenanceLog.setOperateUserid(user.getUID());
		  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		  SysMaintenanceLog.setSysLogInfo();
		}
		ResourceVirtualComInfo.removeResourceVirtualCache();//重新加载缓存
	 	response.sendRedirect("HrmResourceVirtualDepartmentSet.jsp?isclose=1");
	}else if(operation.equals("delete")){
		sql = " SELECT b.lastname FROM HrmResourceVirtual a, hrmresource b WHERE a.resourceid = b.id AND a.id = "+id;
		rs.executeSql(sql);
		if(rs.next()){
			lastname = rs.getString("lastname");
		}
		ResourceVirtualComInfo.removeResourceVirtualCache();//重新加载缓存
		sql = " delete from HrmResourceVirtual where id = "+id;
		rs.executeSql(sql);
		
	  SysMaintenanceLog.resetParameter();
	  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	  SysMaintenanceLog.setRelatedName(lastname);
	  SysMaintenanceLog.setOperateType("3");
	  SysMaintenanceLog.setOperateDesc(sql);
	  SysMaintenanceLog.setOperateItem("415");
	  SysMaintenanceLog.setOperateUserid(user.getUID());
	  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	  SysMaintenanceLog.setSysLogInfo();
	}
%>