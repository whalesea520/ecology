
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@page import="java.io.File"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmOutInterface" class="weaver.hrm.outinterface.HrmOutInterface" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<jsp:useBean id="BaiduMapUtil" class="weaver.crm.customermap.BaiduMapUtil" scope="page"/>
<%@ page import="java.util.*" %>
<%
	String userid=""+user.getUID();
	String operation=Util.null2o(request.getParameter("operation"));
	if(operation.equals("markimportant")){//标记为重要
		String customerid=Util.null2o(request.getParameter("customerid"));
		String important=Util.null2o(request.getParameter("important"));
		CustomerService.markImportant(customerid,userid,important);
	}else if(operation.equals("markAsImportant")){ //标记为重要
		String customerid=Util.null2o(request.getParameter("customerid"));
		String important=Util.null2o(request.getParameter("important"));
		CustomerService.markAsImportant(customerid,userid,important);
	}else if("edit_customer_field".equals(operation)){//编辑客户字段
		
		Map fn = new HashMap();
		fn.put("name","名称");
		fn.put("city","城市");
		fn.put("county","区县（二级城市）");
		fn.put("district","区县");
		fn.put("address1","地址1");
		fn.put("zipcode","邮政编码");
		fn.put("phone","电话");
		fn.put("fax","传真");
		fn.put("email","邮箱");
		fn.put("website","网址");
		fn.put("type","类型");
		fn.put("status","状态");
		fn.put("rating","级别");
		fn.put("description","描述");
		fn.put("size_n","规模");
		fn.put("source","获得途径");
		fn.put("sector","行业");
		fn.put("manager","客户经理");
		fn.put("agent","中介机构");
		fn.put("crmcode","客户编号");
		fn.put("engname","简称（英文）");
		fn.put("address2","地址2");
		fn.put("address3","地址3");
		fn.put("country","国家");
		fn.put("province","省");
		fn.put("language","语言");
		fn.put("introduction","介绍");
		fn.put("evaluation","客户价值");
		fn.put("principalIds","客服负责人");
		fn.put("exploiterIds","开拓人员");
		fn.put("parentid","上级单位");
		fn.put("documentid","文档");
		fn.put("introductionDocid","背景资料");
		fn.put("seclevel","安全级别");
		fn.put("CreditAmount","信用额度");
		fn.put("CreditTime","信用期间");
		fn.put("bankName","开户银行");
		fn.put("accountName","帐户");
		fn.put("accounts","银行帐号");
		fn.put("othername","正式名称");
		
		char flag = 2; 
		String sql="";
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		
		String ProcPara = "";
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String fieldname = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
		//判断是否有客户编辑权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<2){
			return;
		}
		if(!fieldname.equals("status") && (CustomerInfoComInfo.getCustomerInfostatus(customerid).equals("7") || CustomerInfoComInfo.getCustomerInfostatus(customerid).equals("8") || CustomerInfoComInfo.getCustomerInfostatus(customerid).equals("10"))){
			return;
		}
		
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		
		String addvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
		String delvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
		
		if(fieldname.equals("manager")){
			try{//修改客户卡片客户经理时，同步修改 客户纬度 客户经理部门下面的人员，更新矩阵下面的人员
				HrmOutInterface.changeCustomManager(customerid,newvalue);
			}catch(Exception e){
				rs.writeLog(e);
			}
			rs.executeSql("update CRM_CustomerInfo set manager="+newvalue+" where id="+customerid);
			//通知变更前后的客户经理
			String operators = newvalue;
			/**
			String SWFAccepter=operators;
			String SWFTitle=SystemEnv.getHtmlLabelName(15159,user.getLanguage());
			SWFTitle += CustomerInfoComInfo.getCustomerInfoname(customerid);
			SWFTitle += "-"+user.getUsername();
			SWFTitle += "-"+TimeUtil.getCurrentDateString();
			String SWFRemark="";
			String SWFSubmiter = user.getUID()+"";
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(customerid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			*/
			rs.executeSql("delete from CRM_shareinfo where contents="+operators+" and sharetype=1 and relateditemid="+customerid);
			
			//修改客户经理重置客户共享
			CrmShareBase.setCRM_WPShare_newCRMManager(customerid);
			//添加新客户标记
			CustomerModifyLog.modify(customerid,oldvalue,newvalue);
			
		}if(fieldname.equals("exploiterIds")){//开拓人员
			if(!addvalue.equals("")){//添加人员
				List idList = Util.TokenizerString(addvalue, ",");
				for(int i=0;i<idList.size();i++){
					if(!"".equals(idList.get(i))){
						rs.executeSql("insert into CRM_CustomerExploiter (customerId,exploiterId) values ("+customerid+","+idList.get(i)+")");
					}
				}
			}
			if(!delvalue.equals("")){//删除人员
				rs.executeSql("delete from CRM_CustomerExploiter where exploiterId in (" + delvalue + ") and customerid="+customerid);
			}
		}if(fieldname.equals("principalIds")){//客服负责人
			if(!addvalue.equals("")){//添加人员
				List idList = Util.TokenizerString(addvalue, ",");
				for(int i=0;i<idList.size();i++){
					if(!"".equals(idList.get(i))){
						rs.executeSql("insert into CS_CustomerPrincipal (customerId,principalId) values ("+customerid+","+idList.get(i)+")");
					}
				}
			}
			if(!delvalue.equals("")){//删除人员
				rs.executeSql("delete from CS_CustomerPrincipal where principalId in (" + delvalue + ") and customerid="+customerid);
			}
		}if(fieldname.equals("othername")){//正式名称
			rs.executeSql("update CRM_OtherName set customername='"+newvalue+"' where customerid="+customerid);
		}else{
			
			
			if(fieldtype.equals("attachment")){
				rs.execute("select "+fieldname+" from CRM_CustomerInfo where id = "+customerid);
				rs.next();
				String att = rs.getString(1);
				if(att.equals(delvalue)){
					att = "";
				}else{
					att = (","+att+",").replace((","+delvalue+","), "");
					att = att.indexOf(",")==0?att.substring(1):att;
					att = att.lastIndexOf(",")==att.length()-1?att.substring(0,att.length()-1):att;
				}
				rs.execute("update CRM_CustomerInfo set "+fieldname+" = '"+att +"' where id = "+customerid);
				rs.execute("select filerealpath from ImageFile where imagefileid = "+delvalue);
				while(rs.next()){
					File file = new File(rs.getString("filerealpath"));
					if(file.exists()) file.delete();
				}
				rs.execute("delete from ImageFile where imagefileid = "+delvalue);
				
			}else if(fieldtype.equals("num")){
				sql = "update CRM_CustomerInfo set "+fieldname+"='"+newvalue+"' where id="+customerid;
			}else if(fieldtype.equals("str")){
				sql = "update CRM_CustomerInfo set "+fieldname+"='"+newvalue+"' where id="+customerid;
			}
			rs.executeSql(sql);
		}
		
		if(fieldname.equals("rating")){
			//通知客户经理的经理
			/**
			String operators = ResourceComInfo.getManagerID(CustomerInfoComInfo.getCustomerInfomanager(customerid));
			String SWFAccepter=operators;
			String SWFTitle=SystemEnv.getHtmlLabelName(15158,user.getLanguage());
			SWFTitle += CustomerInfoComInfo.getCustomerInfoname(customerid);
			SWFTitle += "-"+user.getUsername();
			SWFTitle += "-"+TimeUtil.getCurrentDateString();
			String SWFRemark="";
			String SWFSubmiter=user.getUID()+"";;
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(customerid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			*/
		}
		if(fieldname.equals("status")){
			//设置成功客户默认共享
			if(newvalue.equals("4") || oldvalue.equals("4") || newvalue.equals("5") || oldvalue.equals("5")
					|| newvalue.equals("6") || oldvalue.equals("6") || newvalue.equals("8") || oldvalue.equals("8")){
				CrmShareBase.resetStatusShare(customerid);
			}
		}
		if(fieldname.equals("type")){
			//调整为人脉时更新联系人的创建时间
			if(newvalue.equals("26")){
				String contacterid = "";
				String creater = "";
				String createdate = "";
				String createtime = "";
				int count = 0;
				rs.executeSql("select id,creater,createdate,createtime from CRM_CustomerContacter where (createdate='' or createdate is null) and customerid="+customerid);
				while(rs.next()){
					count++;
					if(count>20) break;//超过20个联系人将不进行处理
					contacterid = Util.null2String(rs.getString("id"));
					creater = "";createdate = "";createtime = "";
					rs2.executeSql("select t1.submiter,t1.submitdate,t1.submittime from CRM_Log t1,CRM_Modify t2"
							  +" where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
							  +" and t1.logtype='nc' and t1.customerid="+customerid+" and t2.type="+contacterid);
					if(rs2.next()){
						creater = Util.null2String(rs2.getString("submiter"));
						createdate = Util.null2String(rs2.getString("submitdate"));
						createtime = Util.null2String(rs2.getString("submittime"));
					}else{
						rs2.executeSql("select t1.submiter,t1.submitdate,t1.submittime from CRM_Log t1 where t1.customerid="+customerid+" and t1.logtype='n'");
						if(rs2.next()){
							creater = Util.null2String(rs2.getString("submiter"));
							createdate = Util.null2String(rs2.getString("submitdate"));
							createtime = Util.null2String(rs2.getString("submittime"));
						}
					}
					if(!createdate.equals("")){
						rs2.executeSql("update CRM_CustomerContacter set creater='"+creater+"',createdate='"+createdate+"',createtime='"+createtime+"' where id="+contacterid);
					}
				}
			}
		}
		
		//更新中介结构时，更改权限表 ----- 开始    20160701 dcm 
		if(fieldname.equals("agent")){
			if("".equals(newvalue)){
				rs.executeSql("delete from CRM_ShareInfo where deleted=0 and sharetype=9 and relateditemid='"+customerid+"'");
			}else{
				rs.executeSql("select * from CRM_ShareInfo where deleted=0 and contents='"+newvalue+"'and sharetype=9 and relateditemid='"+customerid+"'");//查询是否在权限表中存在
				if(!rs.next()){
					rs.executeSql("insert into CRM_ShareInfo (relateditemid,sharetype,sharelevel,crmid,contents,deleted) values ('"+customerid+"',9,1,0,'"+newvalue+"',0)");
				}
			}
		}
		
		//更新中介结构时，更改权限表 ----- 结束
		
		//重置缓存
		CustomerInfoComInfo.updateCustomerInfoCache(customerid);
		
		rs.execute("SELECT groupid FROM CRM_CustomerDefinField WHERE usetable = 'CRM_CustomerInfo' AND fieldname = '"+fieldname+"'");
		rs.next();
		if(rs.getInt("groupid") <= 4 && fn.containsKey(fieldname)){
			//记录日志
			ProcPara = customerid+flag+"1"+flag+"0"+flag+"0";
			ProcPara += flag+(String)fn.get(fieldname)+flag+currentdate+flag+currenttime+flag+oldvalue+flag+newvalue;
			ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
			rs.executeProc("CRM_Modify_Insert",ProcPara);
			ProcPara = customerid;
			ProcPara += flag+"m";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+currentdate;
			ProcPara += flag+currenttime;
			ProcPara += flag+(user.getUID()+"");
			ProcPara += flag+(user.getLogintype()+"");
			ProcPara += flag+request.getRemoteAddr();
			rs.executeProc("CRM_Log_Insert",ProcPara);
		}
			try{
		     rs.execute("select id,address1,address2,address3 from CRM_CustomerInfo where id = '"+customerid+"'");
	            String address1 = "";
	            String address2 = "";
	            String address3 = "";
	            String custmid = "";
	            while(rs.next()){
	                address1 = Util.null2String(rs.getString("address1"));
	                address2 = Util.null2String(rs.getString("address2"));
	                address3 = Util.null2String(rs.getString("address3"));
	                custmid = Util.null2String(rs.getString("id"));
	           }
	            String updateCoordinateSql = "UPDATE CRM_CustomerInfo SET ";
	            String adrsParmSql = "";
	            if(!"".equals(address1)){
	               //查询坐标
	               Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address1);
	               if(map.size()==2){
	                   String lng = map.get("lng");
	                   String lat = map.get("lat");
	                   
	                   adrsParmSql += ",lng1='"+lng+"'";
	                   adrsParmSql += ",lat1='"+lat+"'";
	               }
	            }
	            if(!"".equals(address2)){
	                //查询坐标
	                Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address2);
	                if(map.size()==2){
	                    String lng = map.get("lng");
	                    String lat = map.get("lat");
	                    
	                    adrsParmSql += ",lng2='"+lng+"'";
	                    adrsParmSql += ",lat2='"+lat+"'";
	                }
	            }
	            if(!"".equals(address3)){
	                //查询坐标
	                Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address3);
	                if(map.size()==2){
	                    String lng = map.get("lng");
	                    String lat = map.get("lat");
	                    
	                    adrsParmSql += ",lng3='"+lng+"'";
	                    adrsParmSql += ",lat3='"+lat+"'";
	                }
	            }
	            if(!"".equals(adrsParmSql)) rs.execute(updateCoordinateSql + adrsParmSql.substring(1) + " WHERE id="+custmid);
	        }catch(Exception e){}
	}	

%>