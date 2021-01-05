<%@page import="weaver.prj.util.PrjCardUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%
//response.setHeader("cache-control", "no-cache");
//response.setHeader("pragma", "no-cache");
//response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

int _userid = Util.getIntValue(request.getParameter("userid"));

//User user = HrmUserVarify.getUser (request , response) ;
//if(user == null){
	UserManager userManager = new UserManager();
	User user = userManager.getUserByUserIdAndLoginType(_userid, "1");
//}
%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.crm.Maint.ContactWayComInfo"%>
<%@ page import="weaver.crm.sellchance.SellstatusComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	String currentdate = TimeUtil.getCurrentDateString();
	String currenttime = TimeUtil.getOnlyCurrentTimeString();
	
	//获取列表数据
	if("get_list_data".equals(operation)){

		


		HrmUserVarify hrmUserVarify = new HrmUserVarify();
		
		//rs.executeSql(" update proj_CardBaseInfo set planApprovalDate=null where planApprovalDate='' ");
		
		String orderby1 = " order by id desc";
		String orderby2 = " order by id asc";
		String orderby3 = " order by cbi.id desc";
		String CRM_LIST_SQL_orderBy1 = Util.null2String((String)request.getSession().getAttribute("CRM_LIST_SQL_orderBy1")).trim();
		if(CRM_LIST_SQL_orderBy1.length() > 0){
			String CRM_LIST_SQL_orderBy1_1 = "";
			if("asc".equalsIgnoreCase(CRM_LIST_SQL_orderBy1)){
				CRM_LIST_SQL_orderBy1_1 = "desc";
			}else{
				CRM_LIST_SQL_orderBy1_1 = "asc";
			}
			
			
			orderby1 = " order by  planApprovalDate  "+CRM_LIST_SQL_orderBy1+", id desc";	
			orderby2 = " order by  planApprovalDate  "+CRM_LIST_SQL_orderBy1_1+", id asc";
			orderby3 = " order by  cbi.planApprovalDate "+CRM_LIST_SQL_orderBy1+", cbi.id desc";
		}
		
		
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = (String)request.getSession().getAttribute("CRM_LIST_SQL");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select distinct top "+ iNextNum + querysql.replaceFirst("cbi.planApprovalDate", "case when ISNULL(planApprovalDate,'')='' then '9999-99-99' else planApprovalDate end as planApprovalDate") + orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//out.println(sql);
		rs.writeLog("tagtag prj_operation sql:"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		PrjCardUtil prjCardUtil = new PrjCardUtil();
		
		RecordSet _rs = new RecordSet();
		//_rs.executeProc("HrmResource_SelectByManagerID", user.getUID()+"");
		_rs.executeSql("select id from dbo.getchilds("+user.getUID()+")");
		boolean PRJ_ContractNodeDetailUpdate = hrmUserVarify.checkUserRight("PRJ:ContractNodeDetailUpdate",user);

		restr.append("{\"totalSize\":"+iTotal+",\"datas\":[");
		
		int _index = 0;
		while(rs.next()){
			_index++;
			index++;
			String prjId = Util.null2String(rs.getString("id"));
			String projName = Util.null2String(rs.getString("projName")).trim();
			int projManager = Util.getIntValue(rs.getString("projManager"), 0);
			String planApprovalDate = Util.null2String(rs.getString("planApprovalDate")).trim().replaceFirst("9999-99-99", "");
			
			
			String log_max_day = "";
			rs1.executeSql("select max(opdate+' '+optime) as log_max_day from proj_opreatorlog log where log.cbi_id="+prjId+" and log.opreator <> "+user.getUID()+" ");
			if(rs1.next()){
				log_max_day = Util.null2String(rs1.getString("log_max_day")).trim();
			}

			String pv_max_day = "";
			rs1.executeSql("select max(opdate+' '+optime) as pv_max_day from proj_visitInfo pv where pv.cbi_id="+prjId+" and pv.uid = "+user.getUID()+" ");
			if(rs1.next()){
				pv_max_day = Util.null2String(rs1.getString("pv_max_day")).trim();
			}
			
			//String isNewHTML = "<IMG id=\"_prjId_"+prjId+"_BDNew2_gif\" border=0 align=absMiddle src=\"/images/BDNew2.gif\">";
			String isNewHTML = "1";
			String isNew = "";
			
			if(pv_max_day.length() <= 0){
				isNew = isNewHTML;
			}else if(pv_max_day.length() > 0 && log_max_day.length() > 0 && (pv_max_day).compareToIgnoreCase(log_max_day) < 0){
				isNew = isNewHTML;
			}
			if(pv_max_day.length() > 0 && log_max_day.length() == 0){
				isNew = "";
			}
			
			String titleProjName = projName; //prjCardUtil.getPrjNameDiv(projName, prjId);
			boolean _att = prjCardUtil.isGuanZhu(prjId, user.getUID()+"");
			
			boolean showYuJing = false;
			
			//out.println("projManager="+projManager+";user.getUID()="+user.getUID());
			
			if(user.getUID() == projManager){
				showYuJing = true;
			}
	
			if(!showYuJing && projManager > 0){
				_rs.beforFirst();
				while(_rs.next()) {
					int _id = Util.getIntValue(_rs.getString("id"), 0);
					if(_id == projManager){
						showYuJing = true;
						break;
					}
				}
			}
			
			if(!showYuJing && projManager > 0){
			    if(PRJ_ContractNodeDetailUpdate){
					showYuJing = true;
			    }
			}
			
			//prjCardUtil.updatePrjLastPrjState(prjId);
			String zhuangTai =Util.null2String(rs.getString("lastPrjState")); //prjCardUtil.getZhuangTaiDiv(prjId);
			if(zhuangTai.indexOf("已验收") < 0 && zhuangTai.indexOf("已结案") < 0){
				if(zhuangTai.indexOf("验收") >= 0){
					zhuangTai = zhuangTai.replaceAll("验收", "已验收");
				}
				if(zhuangTai.indexOf("结案") >= 0){
					zhuangTai = zhuangTai.replaceAll("结案", "已结案");
				}
			}
			
			String yuJing = Util.null2String(rs.getString("warningName"));
			if(showYuJing && (zhuangTai.indexOf("正常") >= 0 || zhuangTai.indexOf("预警") >= 0)){
				if(yuJing.indexOf("延期") >= 0){/*预警状态*/
					yuJing = "<div id=\"divYuJing_"+prjId+"\" class=\"div_yujing0\" onclick=\"doYuJing("+prjId+");\" style=\"width:46px;float:left;\" _type=\"0\">预警</div>";
				}else{/*非预警状态*/
					yuJing = "<div id=\"divYuJing_"+prjId+"\" class=\"div_yujing1\" onclick=\"doYuJing("+prjId+");\" style=\"width:46px;float:left;\" _type=\"1\">正常</div>";
				}
			}else{
				if(yuJing.indexOf("延期") >= 0){/*预警状态*/
					yuJing = "<div class=\"div_yujing0\" style=\"cursor: default;width:46px;float:left;\">预警</div>";
				}else{/*非预警状态*/
					yuJing = "<div class=\"div_yujing1\" style=\"cursor: default;width:46px;float:left;\">正常</div>";
				}
			}
			if(zhuangTai.indexOf("正常") >= 0 || zhuangTai.indexOf("预警") >= 0){
				//如果状态是：正常和预警的话则显示正常和预警的按钮
			}else{
				yuJing = "<span style=width:46px;float:left;vertical-align:middle;display:block;'>"+zhuangTai+"</span>";
			}
			
			String kehuZhiwuDianhua = "";//prjCardUtil.getKehuZhiwuDianhua(prjId) ;
			
			String jieDuanName = prjCardUtil.getJieDuanName(prjId);
			if(jieDuanName.indexOf("验收中") < 0 && jieDuanName.indexOf("结案中") < 0 && jieDuanName.indexOf("维保中") < 0){
				if(jieDuanName.indexOf("验收") >= 0){
					jieDuanName = jieDuanName.replaceAll("验收", "验收中");
				}
				if(jieDuanName.indexOf("结案") >= 0){
					jieDuanName = jieDuanName.replaceAll("结案", "结案中");
				}
				if(jieDuanName.indexOf("维保") >= 0){
					jieDuanName = jieDuanName.replaceAll("维保", "维保中");
				}
			}
			
			int ribaoCnt =  rs.getInt("cnt");
			if(ribaoCnt < 0){
				ribaoCnt = 0;
			}
			
			if("延期".equals(yuJing) || (yuJing.indexOf("延期") >= 0 && yuJing.indexOf("<span") >= 0)){
				yuJing="<span style=width:46px;float:left;vertical-align:middle;display:block;background:#FF0000;'><font style=\"color: #FFF;\">延期</font></span>";
			}

			if(_index>1){
				restr.append(",");
			}
			restr.append("{\"prjId\":\""+prjId+"\", \"prjManager\":\""+ResourceComInfo.getLastname(""+projManager)+"\", \"prjManagerMobile\":\""+ResourceComInfo.getMobile(""+projManager)+"\", \"prjManagerEmail\":\""+ResourceComInfo.getEmail(""+projManager)+"\", \"pName\":\""+projName+"\", \"pMilestone\":\""+jieDuanName+"\", \"pPlanDate\":\""+planApprovalDate+"\", \"pReceivable\":\""+prjCardUtil.getBenyueyingshou(prjId)+"\", \"pReceived\":\""+prjCardUtil.getBenyueyishou(prjId)+"\", \"pDaily\":\""+ribaoCnt+"天\", \"pStatus\":\""+zhuangTai+"\", \"pIsNew\":\""+isNew+"\"}");
			

		}
	
		restr.append("]}");
	}
	
	//设置数量
	if("check_new".equals(operation)){}
	
	Map fn = new HashMap();
	
	
	//新建客户
	if("add_customer".equals(operation)){}
	
	char flag = 2; 
	String ProcPara = "";
	//编辑客户字段
	if("edit_customer_field".equals(operation)){}	
	
	//添加查看日志
	if("add_log_view".equals(operation)){}
	//读取日志明细
	if("get_log_count".equals(operation)){}
	if("get_log_list".equals(operation)){}
	out.print(restr.toString());
	out.flush();
	out.close();
%>