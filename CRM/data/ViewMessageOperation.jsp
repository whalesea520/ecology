
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
    request.setCharacterEncoding("UTF-8") ;
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	String userid = user.getUID()+"";
	//添加取消提醒
	if("do_remind".equals(operation)){
		String operatetype=Util.null2String(request.getParameter("operatetype"));//1为客户 2为商机 3为联系人
		String objid=Util.null2String(request.getParameter("objid"));
		//权限判断
		if(!checkRight(objid,userid,Util.getIntValue(operatetype,1),1)) return;
		
		String settype=Util.null2String(request.getParameter("settype"));//1为添加 0为取消
		if(!objid.equals("")){
			if(settype.equals("1")){
				rs.executeSql("insert into CRM_Common_Remind (operator,objid,operatetype,operatedate,operatetime) values("+userid+","+objid+","+operatetype+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')");
				if(operatetype.equals("2")){//商机日志
					rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
							+" values("+objid+",5,"+user.getUID()+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','','','')");
				}else if(operatetype.equals("1")){//客户日志
					char flag = 2; 
					String ProcPara = "";
					ProcPara = objid;
					ProcPara += flag+"r";
					ProcPara += flag+"";
					ProcPara += flag+"";
					ProcPara += flag+TimeUtil.getCurrentDateString();
					ProcPara += flag+TimeUtil.getOnlyCurrentTimeString();
					ProcPara += flag+(user.getUID()+"");
					ProcPara += flag+(user.getLogintype()+"");
					ProcPara += flag+request.getRemoteAddr();
					rs.executeProc("CRM_Log_Insert",ProcPara);
				}
			}else{
				rs.executeSql("delete from CRM_Common_Remind where objid="+objid+" and operatetype="+operatetype);
			}
		}
	}
	//添加取消关注
	else if("do_attention".equals(operation)){
		String operatetype=Util.null2String(request.getParameter("operatetype"));//1为客户 2为商机 3为联系人
		String objid=Util.null2String(request.getParameter("objid"));
		//权限判断
		if(!checkRight(objid,userid,Util.getIntValue(operatetype,1),1)) return;
		
		String settype=Util.null2String(request.getParameter("settype"));//1为添加 否则为取消
		if(!objid.equals("")){
			rs.executeSql("delete from CRM_Common_Attention where operator="+userid+" and objid="+objid+" and operatetype="+operatetype);
			if(settype.equals("1")){
				rs.executeSql("insert into CRM_Common_Attention (operator,objid,operatetype,operatedate,operatetime) values("+userid+","+objid+","+operatetype+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')");
			}
			
			if(operatetype.equals("2")){//商机日志
				String logtype = "6";
				if(settype.equals("0")) logtype = "7";
				rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
						+" values("+objid+","+logtype+","+user.getUID()+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','','','')");
			}
		}
	}
	//添加联系记录
	else if("add".equals(operation)){
		
		String para = "";
		String customerid =  Util.null2String(request.getParameter("customerid"));  //日程Id
		char flag=Util.getSeparator() ;
		String ContactInfo = Util.fromScreen(request.getParameter("ContactInfo"), user.getLanguage());  //相关交流
		String relateddoc = Util.null2String(request.getParameter("relateddoc"));
		String creater =user.getLogintype().equals("1")?""+user.getUID():""+(-1 * user.getUID());
		String types ="CC"; 
		String currentdate=TimeUtil.getCurrentDateString();
		String currenttime=TimeUtil.getOnlyCurrentTimeString();
		
		para = customerid;
		para += flag+"";
		para += flag+ContactInfo;
		para += flag+creater;
		para += flag+currentdate ;
		para += flag+currenttime ;
		para += flag+types ;
		para += flag+relateddoc ;
		para += flag+"" ;
		para += flag+"" ;
		para += flag+"" ;
		para += flag+"" ;
			
		
		
		rs.executeProc("ExchangeInfo_Insert",para);
		
	}else if("get_list_contact".equals(operation)){//获取联系记录列表数据
		
		String showtype = Util.fromScreen3(request.getParameter("showtype"),user.getLanguage());//1:客户 2:商机 3:联系人
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		
		String customerid =Util.null2String(request.getParameter("customerid"));
		String userType = user.getLogintype();
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		char flag0=2;
		String types="CC";
		
		rs.executeProc("ExchangeInfo_SelectBID",customerid+flag0+types);
		
		//查询预警时删除临时表
		String description = "";
		while(rs.next()){
	%>
				<tr>
					<td class="data fbdata1 fbdata2">
						<div class="feedbackshow">
							<div class="feedbackinfo" >
								<%if(Util.getIntValue(rs.getString("creater"))>0){%>
									<a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(rs.getString("creater")),user.getLanguage())%></a>
								<%}else{%>
									<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=rs.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+rs.getString("creater").substring(1))%></a>
								<%}%>
								<%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.toHtml(rs.getString("remark"))%></div>
								<div class="relatetitle"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>:<%=cmutil.getDocName(Util.null2String(rs.getString("docids"))) %></div>
							</div>
						</div>
					</td>
				</tr>
	<%
		} 
	}
	//保存预警关键词
	else if(operation.equals("save_key")){
		String keyname = URLDecoder.decode(Util.null2String(request.getParameter("keyname")),"utf-8");
		String keytype = Util.null2String(request.getParameter("keytype"));
		String hrmid = "0";
		if(keytype.equals("0")) hrmid = user.getUID()+"";
		if(!keyname.equals("")){
			boolean res = rs.executeSql("insert into CRM_WarnConfig (keytype,userid,keyname) values("+keytype+","+hrmid+",'"+keyname+"')");
			if(res){
				rs.executeSql("select max(id) from CRM_WarnConfig");
				if(rs.next()){
					String addid = Util.null2String(rs.getString(1));
				
%>
	<div class="tagitem" style="<%if(keytype.equals("0")){ %>color: #F2F2F2;<%}else{ %>color:#fff;<%} %>" title="<%=keyname %>"><%=keyname %><div class="tagdel" onclick="doDelTag(<%=addid %>,this)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></div></div>
<%		
				} 
			}
		}
	}
	//删除预警关键词
	else if(operation.equals("del_key")){
		String keyid = Util.null2String(request.getParameter("keyid"));
		if(!keyid.equals("")){
			rs.executeSql("delete from CRM_WarnConfig where id = "+keyid);
		}
	}

	out.print(restr.toString());
	out.close();
%>
<%!
private boolean checkRight(String objid,String userid,int type,int level) throws Exception{
	CrmShareBase crmShareBase = new CrmShareBase();
	RecordSet rs = new RecordSet();
	String customerid = "";
	if(type==1){
		customerid = objid;
	}else if(type==2){
		if(!"".equals(objid)){
			rs.executeSql("select t.customerid from CRM_SellChance t where t.id="+objid);
			if(rs.next()) customerid = Util.null2String(rs.getString(1));
		}
	}else{
		if(!"".equals(objid)){
			rs.executeSql("select t.customerid from CRM_CustomerContacter t where t.id="+objid);
			if(rs.next()) customerid = Util.null2String(rs.getString(1)); 
		}
	}
	
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			return false;
		}
		int sharelevel = crmShareBase.getRightLevelForCRM(userid,customerid);
		if(level==1){
			//判断是否有查看该客户商机权限
			if(sharelevel<1){
				return false;
			}
		}else{
			//判断是否有编辑该客户商机权限
			if(sharelevel<2){
				return false;
			}
			if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
				return false;
			}
		}
		return true;
	}
	return false;
}
%>