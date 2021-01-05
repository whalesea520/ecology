<%@page import="weaver.cpt.util.CommonShareManager"%>
<%@page import="weaver.proj.Maint.ProjectTask"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />
<%
	String userid = Util.null2String(request.getParameter("userid"));
	String usertype = Util.null2String(request.getParameter("usertype"));
	//String parentid = Util.null2String(request.getParameter("parentid"));
	String levelid = Util.null2String(request.getParameter("levelid"));
	JSONObject jsonObj = new JSONObject();

	if(levelid.equals("")){
		out.print("");
		return;
	}
	String[] tmpIds = levelid.split(",");
	for(int i=0;i<tmpIds.length;i++){
		String lid = tmpIds[i];
		//待办事宜
		if(lid.equals("13")){
			rs.executeSql("select count(distinct a.requestid) allcount from workflow_currentoperator a where "+
								"userid="+userid+" and isremark in ('0','1','5','7','8','9') and usertype="+usertype+" and islasttimes=1"+
								"and exists (select 1 from workflow_requestbase c where c.requestid=a.requestid "+
								"and (c.deleted<>1 or c.deleted is null or c.deleted='')) and viewtype='0'");
			//待办事宜不需要这些数字
			if(rs.next()){
				//jsonObj.put("num_"+lid,rs.getString("allcount"));
			}else{
				//jsonObj.put("num_"+lid,0);
			}
		}
		
		//客户模块--》我的客户
		if(lid.equals("25")){
			int count = CustomerStatusCount.getNewCustomerNumber(userid);
			jsonObj.put("num_"+lid,count);
		}
		
		//客户模块--》客户联系
		if(lid.equals("26")){
			int count = CustomerStatusCount.getContactNumber(userid);
			jsonObj.put("num_"+lid,count);
		}
		
		//客户模块--》销售机会
		if(lid.equals("27")){
			int count = CustomerStatusCount.getSellChanceNumber(userid);
			jsonObj.put("num_"+lid,count);
		}
		
		//客户模块--》合同管理
		if(lid.equals("28")){
			int count = CustomerStatusCount.getContractNumber("expire",userid)+
				CustomerStatusCount.getContractNumber("pay",userid)+
				CustomerStatusCount.getContractNumber("delivery",userid);
			jsonObj.put("num_"+lid,count);
		}
		
		if("38".equals(lid)){//项目>审批任务
			String sqlWhere = " where t1.prjid=t2.id and t1.isdelete =0 and t1.status  <>"+ProjectTask.APPROVED +"  ";
			if("2".equals( PrjSettingsComInfo.getTsk_approval_type())){
				if("oracle".equalsIgnoreCase(rs.getDBType())){
					sqlWhere+=" and ( exists(select 1 from Prj_TaskProcess t3 where t3.id=t1.parentid and ','||t3.hrmid||',' like '%,"+userid+",%' ) or ( t2.manager='"+userid+"' and t1.level_n=1) ) ";
				}else{
					sqlWhere+=" and ( exists(select 1 from Prj_TaskProcess t3 where t3.id=t1.parentid and ','+convert(varchar, t3.hrmid)+',' like '%,"+userid+",%' ) or ( t2.manager='"+userid+"' and t1.level_n=1) ) ";
				}
			}else{
				sqlWhere+=" and t2.manager='"+userid+"' ";
			}
			String fromSql  = " Prj_TaskProcess t1,Prj_ProjectInfo t2 ";
			rs.executeSql("select  count(t1.id) from "+fromSql+" "+sqlWhere);
			int count=0;
			if(rs.next()&&(count=rs.getInt(1))>0){
				jsonObj.put("num_"+lid,count);
			}else{
				jsonObj.put("num_"+lid,"");
			}
		}
		
		if("594".equals(lid)){//资产>入库验收
			String sqlWhere = " where d.cptstockinid=m.id and m.ischecked = 0 and m.checkerid in(" +new CommonShareManager().getContainsSubuserids(""+ userid)+")  ";
			String fromSql  = " CptStockInMain m ,CptStockInDetail d ";
			rs.executeSql("select  count(distinct m.id) from "+fromSql+" "+sqlWhere);
			int count=0;
			if(rs.next()&&(count=rs.getInt(1))>0){
				jsonObj.put("num_"+lid,count);
			}else{
				jsonObj.put("num_"+lid,"");
			}
		}
		
	}

	out.print(jsonObj.toString());
%>