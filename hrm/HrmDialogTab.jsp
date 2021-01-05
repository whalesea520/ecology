
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 weaver.hrm.common.*,
				 weaver.login.VerifyLogin,
                 weaver.general.GCONST" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.common.StringUtil"%>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));//来源
	String cmd = Util.null2String(kv.get("cmd"));
	String id = Util.null2String(kv.get("id"));
	String method = Util.null2String(kv.get("method"));
	String showpage = Util.null2String(kv.get("showpage"), "1");
	String _type = null;
	ShowTab tab = new ShowTab(rs,user);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String mouldid = "resource";
%>
<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

		<script type="text/javascript">
		function refreshTab(){
			jQuery('.flowMenusTd',parent.document).toggle();
			jQuery('.leftTypeSearch',parent.document).toggle();
		} 
		</script>
		<!-- 人力资源弹出框tab页 -->
		<%
			String title = Util.null2String(request.getParameter("title"));
			boolean titleflag = false;
			String url = "";
			if(_fromURL.equals("NetworkSegmentStrategyAdd")){
				//安全设置--网段策略新增
				title = "21384";
				url = "/hrm/tools/NetworkSegmentStrategyAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("NetworkSegmentStrategyEdit")){
				//安全设置--网段策略编辑
				title = "21384";
				url = "/hrm/tools/NetworkSegmentStrategyEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmSpecialityAdd")){
				//专业设置--新增
				title = "803";
				url = "/hrm/speciality/HrmSpecialityAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmSpecialityEdit")){
				//专业设置--编辑
				title = "803";
				url = "/hrm/speciality/HrmSpecialityEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmUseDemandAdd")){
				//用工需求--新增
				title = "6131";
				String status = Util.null2String(request.getParameter("status"));
				url = "/hrm/career/usedemand/HrmUseDemandAdd.jsp?isdialog=1&_status="+status;
			}else if(_fromURL.equals("HrmUseDemandEdit")){
				//用工需求--编辑
				title = "6131";
				String status = Util.null2String(request.getParameter("status"));
				url = "/hrm/career/usedemand/HrmUseDemandEdit.jsp?isdialog=1&id="+id+"&_status="+status;
			}else if(_fromURL.equals("HrmCareerPlanAdd")){
				//招聘计划--新增
				title = "6132";
				String status = Util.null2String(request.getParameter("status"));
				url = "/hrm/career/careerplan/HrmCareerPlanAdd.jsp?isdialog=1&_status="+status;
			}else if(_fromURL.equals("HrmCareerPlanEdit")){
				//招聘计划--编辑
				title = "6132";
				String status = Util.null2String(request.getParameter("status"));
				if(method.equals("finish")){
					url = "/hrm/career/careerplan/HrmCareerPlanFinish.jsp?isdialog=1&id="+id+"&_status="+status;
				}else{
					url = "/hrm/career/careerplan/HrmCareerPlanEdit.jsp?isdialog=1&id="+id+"&_status="+status;
				}
			}else if(_fromURL.equals("SystemRightGroupAdd")){
				//权限管理中心--权限设置--新增
				title = "16526";
				url = "/systeminfo/systemright/SystemRightGroupAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("SystemRightGroupEdit")){
				//权限管理中心--权限设置--编辑
				title = "16526";
				url = "/systeminfo/systemright/SystemRightGroupEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmBankAdd")){
				//薪酬管理--工资银行--新增
				title = "15812";
				url = "/hrm/finance/bank/HrmBankAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmBankEdit")){
				//薪酬管理--工资银行--编辑
				title = "15812";
				url = "/hrm/finance/bank/HrmBankEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("inviteInfo")){
				//招聘信息
				String planid = Util.null2String(kv.get("planid"));
				if(method.equals("showapplyinfo")){
					title = "1863,33292";
					url = "/hrm/career/applyinfo/list.jsp?cmd="+cmd+"&planid="+planid+"&isdialog=1&inviteid="+id;
				}else if(method.equals("show")){
					title = "366";
					url = "/pweb/careerapply/HrmCareerApplyViewDetail.jsp?isdialog=1&paraid="+id;
				}else{
					title = "366";
					url = "/hrm/career/inviteinfo/content.jsp?method="+method+"&cmd="+cmd+"&planid="+planid+"&isdialog=1&id="+id;
				}
			}else if(_fromURL.equals("applyInfo")){
				//招聘管理-应聘库
				String planid = Util.null2String(kv.get("planid"));
				if(method.equals("print")){
					title = "257";
					url = "/hrm/career/HrmCareerApplyPrint.jsp?isdialog=1&applyid="+id;
				}else if(method.equals("interview")){
					title = "6103";
					url = "/hrm/career/HrmInterviewPlan.jsp?isdialog=1&planid="+planid+"&id="+id;
				}else if(method.equals("HrmInterviewResult")){
					String _result = Util.null2String(kv.get("result"));
					if(_result.equals("0")){
						title = "15690";
					}else if(_result.equals("1")){
						title = "15376";
					}else if(_result.equals("2")){
						title = "15689";
					}
					url = "/hrm/career/HrmInterviewResult.jsp?isdialog=1&showpage=1&result="+_result+"&planid="+planid+"&id="+id;
				}else if(method.equals("interviewAssess")){
					title = "6102";
					url = "/hrm/career/HrmInterviewAssess.jsp?isdialog=1&id="+id;
				}else if(method.equals("hire")){
					title = "1853";
					url = "/hrm/career/HrmCareerApplyToResource.jsp?isdialog=1&planid="+planid+"&id="+id;
				}else if(method.equals("share")){
					title = "119";
					if(showpage.length()==0) showpage = "1";
					url = "/hrm/career/HrmShare.jsp?isdialog=1&showpage="+showpage+"&applyid="+id;
				}else if(method.equals("email")){
					title = "15691";
					url = "/sendmail/HrmMailMerge.jsp?isdialog=1&applyid="+id;
				}else {
					title = "773";
					url = "/hrm/career/applyinfo/content.jsp?method="+method+"&cmd="+cmd+"&isdialog=1&applyid="+id;
				}
			}else if(_fromURL.equals("hrmCheckItem")){
				//奖惩考核-考核项目
				title = "6117";
				if(method.equals("add")){
					url = "/hrm/check/HrmCheckItemAdd.jsp?isdialog=1&id="+id;
				}else if(method.equals("edit")){
					url = "/hrm/check/HrmCheckItemEdit.jsp?isdialog=1&id="+id;
				}
			}else if(_fromURL.equals("HrmAwardAdd")){
				//奖惩考核-奖惩管理新增
				title = "6100";
				url = "/hrm/award/HrmAwardAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmAwardEdit")){
				//奖惩考核-奖惩管理编辑
				title = "6100";
				if(cmd.equals("showdetail")) title = "81800,2121";
				url = "/hrm/award/HrmAwardEdit.jsp?isdialog=1&id="+id+"&cmd="+cmd;
			}else if(_fromURL.equals("HrmAwardTypeAdd")){
				//奖惩考核-奖惩种类新增
				title = "6099";
				url = "/hrm/award/HrmAwardTypeAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmAwardTypeEdit")){
				//奖惩考核-奖惩种类编辑
				title = "6099";
				url = "/hrm/award/HrmAwardTypeEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("hrmCheckInfo")){
				String checkid = Util.null2String(kv.get("checkid"));
				String paramId = method.equals("HrmCheckResourceInfo") ? checkid : id;
				rs.executeSql("select checkname from HrmCheckList where id = "+paramId);
				rs.next() ;
				title = rs.getString("checkname");
				titleflag = true;
				if(method.equals("HrmCheckResourceInfo")){
					//奖惩考核-考核实施--考核明细
					//title += " : "+ResourceComInfo.getResourcename(id);
					url = "/hrm/actualize/HrmCheckResourceInfo.jsp?isdialog=1&resource="+id+"&checkid="+checkid;
				}else{
					//奖惩考核-考核实施--考核情况
					url = "/hrm/actualize/HrmCheckBasicInfo.jsp?isdialog=1&id="+id;
				}
			}else if(_fromURL.equals("systemRightGroup")){
				//中端--权限监控--权限设置
				if(method.equals("add")){
					title = "492";
					url = "/systeminfo/systemright/SystemRightGroupAdd.jsp?isdialog=1";
				}else if(method.equals("edit")){
					rs.execute("SystemRightGroup_sbygroupid",id);
					rs.next() ;
					title = rs.getString(2);
					titleflag = true;
					if(showpage.equals("1")){
						url = "/systeminfo/systemright/SystemRightGroupEdit.jsp?isdialog=1&id="+id;
					}else if(showpage.equals("2")){
						url = "/systeminfo/systemright/SystemRightAuthority.jsp?isdialog=1&id="+id;
					}
				}else if(method.equals("showAuth")){
					rs.executeSql("select a.rightname,b.detachable from SystemRightsLanguage a left join  SystemRights b on a.id = b.id where a.id = "+id+" and a.languageid = "+String.valueOf(user.getLanguage()));
					rs.next() ;
					title = Util.null2String(rs.getString("rightname"));
					titleflag = true;
					String coulddetach = Util.null2String(rs.getString("detachable"));
					String groupID = Util.null2String(request.getParameter("groupID"));
					url = "/systeminfo/systemright/SystemRightRoles.jsp?isdialog=1&id="+id+"&detachable="+detachable+"&coulddetach="+coulddetach+"&groupID="+groupID;
				}else if(method.equals("SystemRightRolesAdd") || method.equals("SystemRightRolesEdit")){
					String groupID = Util.null2String(request.getParameter("groupID"));
					String rightid = Util.null2String(request.getParameter("rightid"));
					rs.executeSql("select a.rightname,b.detachable from SystemRightsLanguage a left join  SystemRights b on a.id = b.id where a.id = "+(method.equals("SystemRightRolesAdd")?id:rightid)+" and a.languageid = "+String.valueOf(user.getLanguage()));
					rs.next();
					title = Util.null2String(rs.getString("rightname"));
					titleflag = true;
					url = "/systeminfo/systemright/"+method+".jsp?isdialog=1&id="+id+"&groupID="+groupID;
				}
			}else if(_fromURL.equals("orgChartSet")){
				mouldid = "resource";
				url = "/org/OrgChartSet.jsp?fromid="+cmd;
				title = "33508";
			}else if(_fromURL.equals("authSubordinate") //权限转移-下属
						|| _fromURL.equals("authRole") //权限转移/复制-角色
						|| _fromURL.equals("authCoOrganiser") //权限转移-协办人
						|| _fromURL.equals("authDepartmentCusFields") //权限转移/复制-部门自定义字段
						|| _fromURL.equals("authSubcompanyCusFields") //权限转移/复制-分部自定义字段
						|| _fromURL.equals("authPost") //权限转移/复制-岗位
						|| _fromURL.equals("authGroup") //权限转移/复制-群组
						|| _fromURL.equals("authSubDepartment") //权限转移-下级部门
						|| _fromURL.equals("authResource") //权限转移-人力资源
						|| _fromURL.equals("authSubCompany") //权限转移-下级分部
						|| _fromURL.equals("authDepartment") //权限转移/复制-部门
						|| _fromURL.equals("authJobtitleResource") //权限转移-岗位人力资源
					){
				String isHidden = Util.null2String(request.getParameter("isHidden"));
				String _HRM_FLAG = Util.null2String(request.getParameter("_HRM_FLAG"));
				String fromid=Util.null2String(request.getParameter("fromid"));
				String toid=Util.null2String(request.getParameter("toid"));
				_type = Util.null2String(request.getParameter("type"));
				String idStr=Util.null2String(request.getParameter("idStr"));
				String isAll = Util.null2String(request.getParameter("isAll"));
				String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
				mouldid = "resource";
				if(_fromURL.equals("authSubordinate")){
					url = "/hrm/transfer/HrmSubordinate.jsp";
					title = "442";
				} else if(_fromURL.equals("authRole")){
					url = "/hrm/transfer/HrmRole.jsp";
					title = "122";
				} else if(_fromURL.equals("authCoOrganiser")){
					url = "/hrm/transfer/HrmCoOrganiser.jsp";
					title = "22671";
				} else if(_fromURL.equals("authDepartmentCusFields")){
					url = "/hrm/transfer/HrmDepartmentCusFields.jsp";
					title = "33646";
				} else if(_fromURL.equals("authSubcompanyCusFields")){
					url = "/hrm/transfer/HrmSubcompanyCusFields.jsp";
					title = "33645";
				} else if(_fromURL.equals("authPost")){
					url = "/hrm/transfer/HrmPost.jsp";
					title = "6086";
				} else if(_fromURL.equals("authGroup")){
					url = "/hrm/transfer/HrmGroup.jsp";
					title = "24002";
				} else if(_fromURL.equals("authSubDepartment")){
					url = "/hrm/transfer/HrmSubDepartment.jsp";
					title = "17587";
				} else if(_fromURL.equals("authResource")){
					url = "/hrm/transfer/HrmResource.jsp";
					title = "179";
				} else if(_fromURL.equals("authSubCompany")){
					url = "/hrm/transfer/HrmSubCompany.jsp";
					title = "17898";
				} else if(_fromURL.equals("authDepartment")){
					url = "/hrm/transfer/HrmDepartment.jsp";
					title = "124";
				} else if(_fromURL.equals("authJobtitleResource")){
					url = "/hrm/transfer/HrmJobtitleResource.jsp";
					title = "179";
				}
				url += "?isdialog=1&fromid="+fromid+"&toid="+toid+"&type="+_type+"&idStr="+idStr+"&isAll="+isAll+"&jsonSql="+Tools.getURLEncode(Tools.getURLEncode(jsonSql))+"&isHidden="+isHidden+"&_HRM_FLAG="+_HRM_FLAG;
				if(_fromURL.equals("authResource")){
					url += "&T202IdStr="+Tools.vString(request.getParameter("T202IdStr"))+"&T202All="+Tools.vString(request.getParameter("T202All"));
				}else if(_fromURL.equals("authPost")){
					url += "&C301IdStr="+Tools.vString(request.getParameter("C301IdStr"))+"&C301All="+Tools.vString(request.getParameter("C301All"));
				}
			} else if ("authHandledMatters".equals(_fromURL) //权限转移/复制-已办事宜
						|| "authPendingMatters".equals(_fromURL) //权限转移-待办事宜
						|| "authMonitoring".equals(_fromURL) //权限转移/复制-可监控流程
						|| "authNodeGroup".equals(_fromURL) //权限转移-节点操作组
						|| "authCreateWorkflow".equals(_fromURL) //权限复制-流程创建权限
					) {
				String fromid=Util.null2String(request.getParameter("fromid"));
				String toid=Util.null2String(request.getParameter("toid"));
				_type = Util.null2String(request.getParameter("type"));
				String idStr=Util.null2String(request.getParameter("idStr"));
				String isAll = Util.null2String(request.getParameter("isAll"));
				String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
				String isHidden = Util.null2String(request.getParameter("isHidden"));
				mouldid = "workflow";
				if ("authHandledMatters".equals(_fromURL)) {
					url = "/hrm/transfer/WorkflowHandledMatters.jsp?";
					title = "17991";
				} else if ("authPendingMatters".equals(_fromURL)) {
					url = "/hrm/transfer/WorkflowPendingMatters.jsp?";
					title = "1207";
				} else if ("authMonitoring".equals(_fromURL)) {
					url = "/hrm/transfer/WorkflowMonitoring.jsp?";
					title = "34097";
				} else if ("authNodeGroup".equals(_fromURL)) {
					String gdtype=Util.null2String(request.getParameter("gdtype"));
					url = "/hrm/transfer/WorkflowNodeGroup.jsp?gdtype="+gdtype+"&";
					title = "33569,33417,15072";
				} else if ("authCreateWorkflow".equals(_fromURL)) {
					String gdtype=Util.null2String(request.getParameter("gdtype"));
					url = "/hrm/transfer/WorkflowCreate.jsp?gdtype="+gdtype+"&";
					title = "18499";
				}
				url += "isdialog=1&fromid="+fromid+"&toid="+toid+"&type="+_type+"&idStr="+idStr+"&isAll="+isAll+"&jsonSql="+Tools.getURLEncode(Tools.getURLEncode(jsonSql))+"&isHidden="+isHidden;
			}
			
			else if(_fromURL.startsWith("authPrj") || _fromURL.startsWith("authCpt") ){//项目,资产相关权限转移,复制
				String onlyQuery = Util.null2String(request.getParameter("isHidden"));
				String fromid=Util.null2String(request.getParameter("fromid"));
				String toid=Util.null2String(request.getParameter("toid"));
				_type = Util.null2String(request.getParameter("type"));
				String idStr=Util.null2String(request.getParameter("idStr"));
				String isAll = Util.null2String(request.getParameter("isAll"));
				String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
				mouldid = _fromURL.startsWith("authPrj")?"proj":"assest";
				if(_type.startsWith("T111")||_type.startsWith("T112")||_type.startsWith("C111")||_type.startsWith("C112")||_type.startsWith("C221")||_type.startsWith("C321")||_type.startsWith("C411")||_type.startsWith("C511")){//项目
					url = "/hrm/transfer/HrmPrjShift.jsp";
					title = "101";
				}else if(_type.startsWith("T113")){//项目任务
					url = "/hrm/transfer/HrmPrjTskShift.jsp";
					title = "1332";
				}else if(_type.startsWith("T171")){//资产
					url = "/hrm/transfer/HrmCptShift.jsp";
					title = "535";
				}
				url += "?isdialog=1&fromid="+fromid+"&toid="+toid+"&type="+_type+"&idStr="+idStr+"&isAll="+isAll+"&jsonSql="+Tools.getURLEncode(Tools.getURLEncode(jsonSql))+"&onlyQuery="+onlyQuery;
			}
			
			
			else if(_fromURL.equals("hrmRightTransfer")){
				//中端--权限监控--权限转移
				String fromid=Util.null2String(request.getParameter("fromid"));
				String toid=Util.null2String(request.getParameter("toid"));
				_type = Util.null2String(request.getParameter("type"));
				
				String crmallnum=Util.null2String(request.getParameter("crmallnum"));
				String projectallnum=Util.null2String(request.getParameter("projectallnum"));
				String resourceallnum=Util.null2String(request.getParameter("resourceallnum"));
				String docallnum=Util.null2String(request.getParameter("docallnum"));
				String eventAllNum=Util.null2String(request.getParameter("eventAllNum"));
				String coworkAllNum=Util.null2String(request.getParameter("coworkAllNum"));
				String pendingEventAllNum=Util.null2String(request.getParameter("pendingEventAllNum"));

				String crmidstr=Util.null2String(request.getParameter("crmidstr"));
				String projectidstr=Util.null2String(request.getParameter("projectidstr"));
				String resourceidstr=Util.null2String(request.getParameter("resourceidstr"));
				String docidstr=Util.null2String(request.getParameter("docidstr"));
				String eventIDStr=Util.null2String(request.getParameter("eventIDStr"));
				String coworkIDStr=Util.null2String(request.getParameter("coworkIDStr"));
				String pendingEventIDStr=Util.null2String(request.getParameter("pendingEventIDStr"));

				String crmall=Util.null2String(request.getParameter("crmall"));
				String projectall=Util.null2String(request.getParameter("projectall"));
				String resourceall=Util.null2String(request.getParameter("resourceall"));
				String docall=Util.null2String(request.getParameter("docall"));
				String eventAll=Util.null2String(request.getParameter("eventAll"));
				String coworkAll=Util.null2String(request.getParameter("coworkAll"));
				String pendingEventAll=Util.null2String(request.getParameter("pendingEventAll"));

				String crmallFlag=Util.null2String(request.getParameter("crmallFlag"));
				String projectallFlag=Util.null2String(request.getParameter("projectallFlag"));
				String resourceallFlag=Util.null2String(request.getParameter("resourceallFlag"));
				String docallFlag=Util.null2String(request.getParameter("docallFlag"));
				String eventAllFlag=Util.null2String(request.getParameter("eventAllFlag"));
				String coworkAllFlag=Util.null2String(request.getParameter("coworkAllFlag"));
				String pendingEventAllFlag=Util.null2String(request.getParameter("pendingEventAllFlag"));
				
				String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
				if(_type.equals("1")){
					title = "21313";
					mouldid = "customer";
				}else if(_type.equals("2")){
					title = "25106";
					mouldid = "proj";
				}else if(_type.equals("3")){
					title = "179";
					mouldid = "resource";
				}else if(_type.equals("4")){
					title = "58";
					mouldid = "doc";
				}else if(_type.equals("5")){
					title = "17991";
					mouldid = "workflow";
				}else if(_type.equals("6")){
					title = "17855";
					mouldid = "collaboration";
				/* 2014-7-31 start */
				}else if("7".equals(_type)) {
					title = "1207";
					mouldid = "workflow";
				}
				/* 2014-7-31 end */
				url = "/hrm/transfer/HrmRightTransferDetail.jsp?isdialog=1&fromid="+fromid+"&toid="+toid+"&type="+_type+
				"&jsonSql="+Tools.getURLEncode(Tools.getURLEncode(jsonSql))+
				"&crmallnum="+crmallnum+"&projectallnum="+projectallnum+"&resourceallnum="+resourceallnum+"&docallnum="+docallnum+"&eventAllNum="+eventAllNum+"&coworkAllNum="+coworkAllNum+"&pendingEventAllNum="+pendingEventAllNum+
				"&crmidstr="+crmidstr+"&projectidstr="+projectidstr+"&resourceidstr="+resourceidstr+"&docidstr="+docidstr+"&eventIDStr="+eventIDStr+"&coworkIDStr="+coworkIDStr+"&pendingEventIDStr="+pendingEventIDStr+
				"&crmall="+crmall+"&projectall="+projectall+"&resourceall="+resourceall+"&docall="+docall+"&eventAll="+eventAll+"&coworkAll="+coworkAll+"&eventAll="+eventAll+
				"&crmallFlag="+crmallFlag+"&projectallFlag="+projectallFlag+"&resourceallFlag="+resourceallFlag+"&docallFlag="+docallFlag+"&eventAllFlag="+eventAllFlag+"&coworkAllFlag="+coworkAllFlag+"&pendingEventAllFlag="+pendingEventAllFlag;
			}else if(_fromURL.equals("hrmRoles")){
				//中端--权限监控--角色设置
				if(method.equals("HrmRolesAdd")){
					title = "122";
				}else{
					rs.execute("hrmroles_selectSingle",id);
					rs.next() ;
					title = StringEscapeUtils.unescapeHtml(rs.getString(1));
					titleflag = true;
				}
				url = "/hrm/roles/"+method+".jsp?isdialog=1&id="+id;
				if(showpage.equals("1")){
					url = "/hrm/roles/HrmRolesEdit.jsp?isdialog=1&id="+id;
				}else if(showpage.equals("2")){
					url = "/hrm/roles/HrmRolesFucRightSet.jsp?isdialog=1&id="+id;
				}else if(showpage.equals("3")){
					url = "/hrm/roles/HrmRolesMembers.jsp?isdialog=1&id="+id;
				}else if(showpage.equals("4")){
					url = "/hrm/roles/HrmRolesStrRightSet.jsp?isdialog=1&id="+id;
				}
				if(method.equals("HrmRolesAdd")){
					String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
					url = "/hrm/roles/"+method+".jsp?subCompanyId="+subCompanyId+"&isdialog=1&id="+id;
				}
			}else if(_fromURL.equals("hrmRolesAuth")){
				//中端--权限监控--角色设置--功能权限
				title = "17864";
				if(method.equals("HrmRoleRightEdit")){
					String rightid = Util.null2String(request.getParameter("rightid"));
					title = RightComInfo.getRightname(rightid,String.valueOf(user.getLanguage()));
					titleflag = true;
					String _id = "";
					String _roleLevel = "";
					rs.executeSql("select id,rolelevel from systemrightroles where roleid = "+id+" and rightid = "+rightid);
					if(rs.next()){
						_id = Util.null2String(rs.getString("id"));
						_roleLevel = Util.null2String(rs.getString("rolelevel"));
					}
					url = "/hrm/roles/"+method+".jsp?isdialog=1&id="+_id+"&roleId="+id+"&rightId="+rightid+"&roleLevel="+_roleLevel+"&detachable="+detachable;
				}else{
					url = "/hrm/roles/"+method+".jsp?isdialog=1&id="+id+"&detachable="+detachable;
				}
			}else if(_fromURL.equals("hrmRolesMem")){
				//中端--权限监控--角色设置--成员列表
				title = "431,320";
				if(method.equals("HrmRolesMembersEdit")){
					rs.execute("HrmRoleMembers_SelectByID",id);
					if(rs.next()){
						title = ResourceComInfo.getResourcename(Util.null2String(rs.getString("resourceid")));
						titleflag = true;
					}
					url = "/hrm/roles/"+method+".jsp?isdialog=1&id="+id;
				}else{
					url = "/hrm/roles/"+method+".jsp?isdialog=1&roleID="+id;
				}
			}else if(_fromURL.equals("hrmCountries")){
				//中端--设置中心--基础设置--国家设置
				title = "377";
				mouldid = "setting";
				if(method.equals("HrmCountriesEdit")){
					title = CountryComInfo.getCountryname(String.valueOf(id));
					titleflag = true;
				}
				url = "/hrm/country/"+method+".jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("hrmProvince")){
				//中端--设置中心--基础设置--省份设置
				title = "800";
				mouldid = "setting";
				if(method.equals("HrmProvinceEdit")){
					title = ProvinceComInfo.getProvincename(String.valueOf(id));
					titleflag = true;
				}
				String countryid = Util.null2String(request.getParameter("countryid"));
				url = "/hrm/province/"+method+".jsp?isdialog=1&countryid="+countryid+"&id="+id;
			}else if(_fromURL.equals("hrmCity")){
				//中端--设置中心--基础设置--城市设置
				title = "493";
				mouldid = "setting";
				if(method.equals("HrmCityEdit")){
					title = CityComInfo.getCityname(String.valueOf(id));
					titleflag = true;
				}
				String provinceid = Util.null2String(request.getParameter("provinceid"));
				url = "/hrm/city/"+method+".jsp?isdialog=1&provinceid="+provinceid+"&id="+id;
			}else if(_fromURL.equals("hrmAreaCountries")){
				//中端--设置中心--行政区域--国家设置
				title = "377";
				mouldid = "resource";
				if(method.equals("HrmCountriesEdit")){
					title = CountryComInfo.getCountryname(String.valueOf(id));
					titleflag = true;
				}
				url = "/hrm/area/"+method+".jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("hrmAreaProvince")){
				//中端--设置中心--行政区域--省份设置
				title = "800";
				mouldid = "resource";
				if(method.equals("HrmProvinceEdit")){
					title = ProvinceComInfo.getProvincename(String.valueOf(id));
					titleflag = true;
				}
				String countryid = Util.null2String(request.getParameter("countryid"));
				url = "/hrm/area/"+method+".jsp?isdialog=1&countryid="+countryid+"&id="+id;
			}else if(_fromURL.equals("hrmAreaCity")){
				//中端--设置中心--行政区域--城市设置
				title = "493";
				mouldid = "resource";
				if(method.equals("HrmCityEdit")){
					title = CityComInfo.getCityname(String.valueOf(id));
					titleflag = true;
				}
				String provinceid = Util.null2String(request.getParameter("provinceid"));
				url = "/hrm/area/"+method+".jsp?isdialog=1&provinceid="+provinceid+"&id="+id;
			}else if(_fromURL.equals("hrmAreaCityTwo")){
				//中端--设置中心--行政区域--区县设置
				title = "25223";
				mouldid = "resource";
				if(method.equals("HrmCityEditTwo")){
					title = CitytwoComInfo.getCityname(String.valueOf(id));
					titleflag = true;
				}
				String cityid = Util.null2String(request.getParameter("cityid"));
				url = "/hrm/area/"+method+".jsp?isdialog=1&cityid="+cityid+"&id="+id;
			}else if(_fromURL.equals("fnaCurrencies")){
				//中端--设置中心--基础设置--币种设置
				title = "406";
				mouldid = "setting";
				if(method.equals("FnaCurrenciesEdit") || method.equals("FnaCurrenciesView")){
					rs.executeProc("FnaCurrency_SelectByID",id);
					rs.next();
					title = Util.toScreen(rs.getString("currencyname"),user.getLanguage());
					titleflag = true;
				}else if(method.equals("FnaCurrencyExchangeAdd")){
					title = "588,17463";
				}else if(method.equals("FnaCurrencyExchangeEdit")){
					rs.executeProc("FnaCurrencyExchange_SelectByID",id);
					rs.next();
					title = Util.null2String(rs.getString("fnayear"))+" - "+Util.null2String(rs.getString("periodsid"));
					titleflag = true;
				}
				url = "/fna/maintenance/"+method+".jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("lgcAssetUnit")){
				//中端--设置中心--基础设置--单位设置
				title = "1329";
				mouldid = "setting";
				if(method.equals("LgcAssetUnitEdit")){
					rs.executeProc("LgcAssetUnit_SelectByID",String.valueOf(id));
					rs.next();
					title = Util.null2String(rs.getString("unitname"));
					titleflag = true;
				}
				url = "/lgc/maintenance/"+method+".jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("hrmGroup")){
				//前端--个性化设置--人力资源自定义组
				title = "81554";
			
			
			
				String _appendUrl = "";
				if(method.equals("GroupShare")){
					_appendUrl += "&creatorid = "+Util.null2String(request.getParameter("creatorid"));
					_appendUrl += "&name = "+Util.null2String(request.getParameter("name"));
				}else if(method.equals("HrmGroupSuggestList")){
					_appendUrl+="&status="+Util.null2String(request.getParameter("status"));
				}else if(method.equals("HrmGroupSuggest")){
					title = "81554";
				}else if(method.equals("HrmGroupAdd")){
					_appendUrl+="&type="+Util.null2String(request.getParameter("type"));
				}else if(method.equals("HrmGroupBaseAdd")){
					title = "81554";
					_appendUrl+="&type="+Util.null2String(request.getParameter("type"))+"&istree="+Util.null2String(request.getParameter("istree"));
				}else if(method.equals("HrmGroupMember")){
					title = "81554";
				}
				url = "/hrm/group/"+method+".jsp?cmd="+cmd+"&isdialog=1&groupid="+id+_appendUrl;
			}else if(_fromURL.equals("HrmGroupMemberAdd")){
				title = "126254";
				String groupid = Util.null2String(request.getParameter("groupid"));
				url = "/hrm/group/HrmGroupMemberAdd.jsp?isdialog=1&groupid="+groupid;
			}else if(_fromURL.equals("HrmGroupMemberEdit")){
				title = "126254";
				url = "/hrm/group/HrmGroupMemberEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmGroupShareAdd")){
				title = "19910";
				String groupid = Util.null2String(request.getParameter("groupid"));
				url = "/hrm/group/HrmGroupShareAdd.jsp?isdialog=1&groupid="+groupid;
			}else if(_fromURL.equals("HrmGroupShareEdit")){
				title = "19910";
				url = "/hrm/group/HrmGroupShareEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmGroupShare")){
				title = "81554";
				String creatorid = "";
				String name = "";
				rs.executeSql("select creatorid, name from hrmgroup where id = "+id);
				if(rs.next()){
					creatorid = Util.null2String(request.getParameter("creatorid"));
					name = Util.null2String(request.getParameter("name")); 
				}
				
				String _appendUrl = "&creatorid = "+creatorid;
							 _appendUrl += "&name = "+name;
				
				url = "/hrm/group/HrmGroupShare.jsp?cmd="+cmd+"&isdialog=1&groupid="+id+_appendUrl;
			}else if(_fromURL.equals("GroupShareAdd")){
				title = "19910";
				String groupid = Util.null2String(request.getParameter("groupid"));
				url = "/hrm/group/GroupShareAdd.jsp?isdialog=1&groupid="+groupid;
			}else if(_fromURL.equals("GroupShareEdit")){
				title = "19910";
				url = "/hrm/group/GroupShareEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("GroupShare")){
				String creatorid = "";
				String name = "";
				rs.executeSql("select creatorid, name from hrmgroup where id = "+id);
				if(rs.next()){
					creatorid = Util.null2String(request.getParameter("creatorid"));
					name = Util.null2String(request.getParameter("name")); 
				}
				
				String _appendUrl = "&creatorid = "+creatorid;
							 _appendUrl += "&name = "+name;
				
				url = "/hrm/group/GroupShare.jsp?cmd="+cmd+"&isdialog=1&groupid="+id+_appendUrl;
			}else if(_fromURL.equals("hrmReport")){//前端--报表--人事报表
				if(cmd.equals("schedulediff")){//考勤相关报表
					String fromDate = Util.null2String(request.getParameter("fromDate"));
					String toDate = Util.null2String(request.getParameter("toDate"));
					String validDate = Util.null2String(request.getParameter("validDate"));
					String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
					String departmentId = Util.null2String(request.getParameter("departmentId"));
					String resourceId = Util.null2String(request.getParameter("resourceId"));
					String status = Util.null2String(request.getParameter("status"));
					String isRule = Util.null2String(request.getParameter("isRule"));
					String ruleid = Util.null2String(request.getParameter("ruleid"));
					if(method.equals("HrmScheduleDiffSignInDetail")){//签到明细表
						title = "20241,27904";
					}else if(method.equals("HrmScheduleDiffSignOutDetail")){//签退明细表
						title = "20242,27904";
					}else if(method.equals("HrmScheduleDiffBeLateDetail")){//迟到明细表
						title = "20088,27904";
					}else if(method.equals("HrmScheduleDiffLeaveEarlyDetail")){//早退明细表
						title = "20089,27904";
					}else if(method.equals("HrmScheduleDiffAbsentFromWorkDetail")){//旷工明细表
						title = "20090,27904";
					}else if(method.equals("HrmScheduleDiffNoSignDetail")){//漏签明细表
						title = "20091,27904";
					}else if(method.equals("HrmScheduleDiffLeaveDetail")){//请假明细表
						title = "20092,27904";
					}else if(method.equals("HrmScheduleDiffEvectionDetail")){//出差明细表
						title = "20093,27904";
					}else if(method.equals("HrmScheduleDiffOutDetail")){//公出明细表
						title = "20094,27904";
					}else if(method.equals("HrmScheduleOvertimeWorkDetail")){//加班明细表
						title = "33501,27904";
					}else if(method.equals("HrmScheduleDiffOtherDetail")){//其他明细表
						title = "18015,17463,27904";
					}
					url = "/hrm/report/schedulediff/"+method+".jsp?isdialog=1&fromDate="+fromDate+"&toDate="+toDate+"&validDate="+validDate+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&resourceId="+resourceId+"&status="+status+"&isRule="+isRule+"&ruleid="+ruleid;
				}else if(cmd.equals("hrmContract")){
					if(method.equals("HrmRpContractType")){//合同类别统计
						title = "15942";
					}else if(method.equals("HrmRpContractTime")){//合同时间统计
						title = "15943";
					}else if(method.equals("HrmContractReport")){//合同报表
						title = "15939";
					}else if(method.equals("HrmRpContractDetail")){//具体信息
						title = "15729";
					}
					url = "/hrm/report/contract/"+method+".jsp?isdialog=1&showpage=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1"));
				} else if(cmd.equals("HrmScheduleDiffMonthAttDateDetail")){
					String curDate = Util.null2String(request.getParameter("curDate"));
					String resourceId = Util.null2String(request.getParameter("resourceId"));
					String status = Util.null2String(request.getParameter("status"));
					title = "15880,17463";
					url = "/hrm/report/schedulediff/HrmScheduleDiffMonthAttDateDetail.jsp?isdialog=1&curDate="+curDate+"&resourceId="+resourceId+"&status="+status;
				}
			}else if(_fromURL.equals("HrmLocationAdd")){
				//中端--基本设置--办公地点新增
				title = "378";
				url = "/hrm/location/HrmLocationAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmWorkflowAdd")){
				title = "15880,30045";
				mouldid = "workflow";
				url = "/hrm/resource/HrmWorkflowAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmLocationEdit")){
				//中端--基本设置--办公地点编辑
				title = "378";
				url = "/hrm/location/HrmLocationEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmJobGroupsAdd")){
				//中端--基本设置--职务类别新增
				title = "805";
				url = "/hrm/jobgroups/HrmJobGroupsAdd.jsp?isdialog=1&cmd="+cmd;
			}else if(_fromURL.equals("HrmJobGroupsEdit")){
				//中端--基本设置--职务类别编辑
				title = "805";
				url = "/hrm/jobgroups/HrmJobGroupsEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmJobActivitiesAdd")){
				//中端--基本设置--职务设置新增
				String jobgroupid = request.getParameter("jobgroupid");
				title = "1915";
				url = "/hrm/jobactivities/HrmJobActivitiesAdd.jsp?isdialog=1&jobgroupid="+jobgroupid;
			}else if(_fromURL.equals("HrmJobActivitiesEdit")){
				//中端--基本设置--职务设置编辑
				title = "1915";
				url = "/hrm/jobactivities/HrmJobActivitiesEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmJobTitlesAdd")){
				//中端--基本设置--岗位设置新增
				title = "6086";
				String jobactivite = request.getParameter("jobactivite");
				url = "/hrm/jobtitles/HrmJobTitlesAdd.jsp?isdialog=1&jobactivite="+jobactivite;
			}else if(_fromURL.equals("HrmJobTitlesEdit")){
				//中端--基本设置--岗位设置编辑
				title = "6086";
				url = "/hrm/jobtitles/HrmJobTitlesEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmJobTitlesEditNotShowBtn")){
				//中端--基本设置--岗位设置编辑
				title = "6086";
				url = "/hrm/jobtitles/HrmJobTitlesEdit.jsp?isdialog=0&id="+id;
			}else if(_fromURL.equals("HrmJobCallAdd")){
				//中端--基本设置--职称设置新增
				title = "806";
				url = "/hrm/jobcall/HrmJobCallAdd.jsp?isdialog=1";




			}else if(_fromURL.equals("HrmJobCallEdit")){
				//中端--基本设置--职称设置编辑
				title = "806";
				url = "/hrm/jobcall/HrmJobCallEdit.jsp?isdialog=1&id="+id;




			}else if(_fromURL.equals("HrmEduLevelAdd")){
				//中端--基本设置--学历设置新增
				title = "818";
				url = "/hrm/educationlevel/HrmEduLevelAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmEduLevelEdit")){
				//中端--基本设置--学历设置编辑
				title = "818";
				url = "/hrm/educationlevel/HrmEduLevelEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmUseKindAdd")){
				//中端--基本设置--用工性质设置新增
				title = "804";
				url = "/hrm/usekind/HrmUseKindAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmUseKindEdit")){
				//中端--基本设置--用工性质编辑
				title = "804";
				url = "/hrm/usekind/HrmUseKindEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmValidateAdd")){
				//中端--自定义设置--自定义显示栏目新增
				title = "32744";
				url = "/hrm/tools/HrmValidateAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmValidateEdit")){
				//中端--自定义设置--自定义显示栏目新增
				title = "32744";
				url = "/hrm/tools/HrmValidateAdd.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("AddHrmCustomTreeField")){
				//中端--自定义设置--显示栏目新增
				title = "81817";
				String parentid = Util.null2String(request.getParameter("parentid"));
				url = "/hrm/resource/AddHrmCustomTreeField.jsp?isdialog=1&parentid="+parentid;
			}else if(_fromURL.equals("EditHrmCustomTreeField")){
				//中端--自定义设置--显示栏目新增
				title = "81817";
				url = "/hrm/resource/EditHrmCustomTreeField.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmCompanyEdit")){
				//中端--组织结构--编辑总部
				title = "140";
				url = "/hrm/company/HrmCompanyEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmSubCompanyAdd")){
				//中端--组织结构--增加分部
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				if(method.equals("addSiblingSubCompany")){
					//增加同级分部
					title = "17897";
					url = "/hrm/company/HrmSubCompanyAdd.jsp?cmd=addSiblingSubCompany&isdialog=1&id="+subcompanyid;
				}else if(method.equals("addChildSubCompany")){
					//增加下级分部
					String supsubcomid = Util.null2String(request.getParameter("supsubcomid"));
					title="17898";
					url = "/hrm/company/HrmSubCompanyAdd.jsp?cmd=addChildSubCompany&isdialog=1&id="+subcompanyid+"&supsubcomid="+supsubcomid;
				}else{
					//增加分部
					title = "141";
					url = "/hrm/company/HrmSubCompanyAdd.jsp?isdialog=1";
				}
			}else if(_fromURL.equals("HrmSubCompanyEdit")){
				//中端--组织结构--编辑分部
				title = "141";
				url = "/hrm/company/HrmSubCompanyEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmDepartmentAdd")){
				//中端--组织结构--增加部门
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				String supdepid2 = Util.null2String(request.getParameter("supdepid"));
				if(method.equals("addSiblingDepartment")){
					//增加同级部门
					title = "17899";
					url = "/hrm/company/HrmDepartmentAdd.jsp?cmd=addSiblingDepartment&isdialog=1&subcompanyid="+subcompanyid+"&supdepid="+supdepid2;
				}else if(method.equals("addChildDepartment")){
					//增加下级部门
					title="17587";
					String supdepid = Util.null2String(request.getParameter("supdepid"));
					url = "/hrm/company/HrmDepartmentAdd.jsp?cmd=addChildDepartment&isdialog=1&subcompanyid="+subcompanyid+"&supdepid="+supdepid;
				}else{
					//增加部门
					title = "124";
					url = "/hrm/company/HrmDepartmentAdd.jsp?isdialog=1&subcompanyid="+subcompanyid;
				}
			}else if(_fromURL.equals("HrmDepartmentEdit")){
				//中端--组织结构--编辑部门
				title = "124";
				url = "/hrm/company/HrmDepartmentEdit.jsp?cmd=editDepartment&isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmResourceSearchMould")){
				//前端--查询人员--存为模板
				title = "33144";
				url = "/hrm/search/mouldname.jsp";
			}else if(_fromURL.equals("HrmConstRpSubSearch")){
				//前端--人事报表-统计子表--存为模板
				title = "33144";
				url = "/hrm/report/resource/SaveTemplate.jsp?method=HrmConstRpSubSearch";
			}else if(_fromURL.equals("HrmContractTypeAdd")){
				//中端--合同管理--合同种类新增
				title = "6158";
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				url = "/hrm/contract/contracttype/HrmContractTypeAdd.jsp?isdialog=1&subcompanyid="+subcompanyid;
			}else if(_fromURL.equals("HrmContractTypeEditDo")){
				//中端--合同管理--合同种类编辑
				title = "6158";
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				String isreport = Util.null2String(request.getParameter("isreport"));
				String isdialog = "1";
				if(isreport.equals("1")){
					isdialog = "0";
				}
				url = "/hrm/contract/contracttype/HrmContractTypeEditDo.jsp?isdialog="+isdialog+"&id="+id+"&subcompanyid="+subcompanyid;
			}else if(_fromURL.equals("HrmContractAdd")){
				//中端--合同管理--合同管理新增
				title = "614";		
				String departmentid = Util.null2String(request.getParameter("departmentid"));
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				url = "/hrm/contract/contract/HrmContractAdd.jsp?isdialog=1&subcompanyid="+subcompanyid+"&departmentid="+departmentid;
			}else if(_fromURL.equals("HrmContractEdit")){
				//中端--合同管理--合同管理编辑
				title = "614";			
				String departmentid = Util.null2String(request.getParameter("departmentid"));
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				url = "/hrm/contract/contract/HrmContractEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid;
			}else if(_fromURL.equals("CompensationTargetSetEdit")){
				//中端--工资福利--薪酬指标维护
				title = "19454";
				String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
				url = "/hrm/finance/compensation/CompensationTargetSetEdit.jsp?isdialog=1&id="+id+"&subCompanyId="+subCompanyId;
			}else if(_fromURL.equals("CompensationTargetMaintEdit")){
				//中端--工资福利--薪酬指标数据维护
				title = "19454";
				String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
				String departmentid = Util.null2String(request.getParameter("departmentid"));
				String CompensationYear = Util.null2String(request.getParameter("CompensationYear"));
				String CompensationMonth = Util.null2String(request.getParameter("CompensationMonth"));
				String isedit =Util.null2String(request.getParameter("isedit"),"1");
				url = "/hrm/finance/compensation/CompensationTargetMaintEdit.jsp?isdialog=1&isedit="+isedit+"&id="+id+"&subCompanyId="+subCompanyId+"&departmentid="+departmentid+"&CompensationYear="+CompensationYear+"&CompensationMonth="+CompensationMonth;
			}else if(_fromURL.equals("HrmSalaryItemAdd")){
				//中端--工资福利--工资项设置
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				title = "33397";				
				url = "/hrm/finance/salary/HrmSalaryItemAdd.jsp?isdialog=1&subcompanyid="+subcompanyid;
			}else if(_fromURL.equals("HrmSalaryItemEdit")){
				//中端--工资福利--工资项设置
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				title = "33397";				
				url = "/hrm/finance/salary/HrmSalaryItemEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid;
			}else if(_fromURL.equals("HrmTrainAdd")){
				//中端--培训管理--培训活动新增
				title = "6136";				
				url = "/hrm/train/train/HrmTrainAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmTrainEditDo")){
				//中端--培训管理--培训活动编辑
				title = "6136";				
				String isdialog = Util.null2String(request.getParameter("isdialog"));
				if(isdialog.length()==0)isdialog="1";
				url = "/hrm/train/train/HrmTrainEditDo.jsp?isdialog="+isdialog+"&id="+id;
			}else if(_fromURL.equals("HrmTrainEdit")){
				//中端--培训管理--培训活动编辑
				title = "6136";				
				String isdialog = Util.null2String(request.getParameter("isdialog"));
				if(isdialog.length()==0)isdialog="1";
				url = "/hrm/train/train/HrmTrainEditDo.jsp?isdialog="+isdialog+"&id="+id;
			}else if(_fromURL.equals("HrmTrainResourceAdd")){
				//中端--培训管理--培训资源新增
				title = "15879";				
				url = "/hrm/train/trainresource/HrmTrainResourceAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmTrainResourcetEditDo")){
				//中端--培训管理--培训资源编辑
				title = "15879";				
				url = "/hrm/train/trainresource/HrmTrainResourcetEditDo.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmTrainDayAdd")){
				//中端--培训管理--培训日程新增
				String trainid = request.getParameter("trainid");
				title = "16150";				
				url = "/hrm/train/train/HrmTrainDayAdd.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainDayActorList")){
				//中端--培训管理--培训日程参加情况
				String trainid = request.getParameter("trainid");
				title = "16150";				
				url = "/hrm/train/train/HrmTrainDayActorList.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainDayEdit")){
				//中端--培训管理--培训日程编辑
				String trainid = request.getParameter("trainid");
				title = "16150";				
				url = "/hrm/train/train/HrmTrainDayEdit.jsp?isdialog=1&trainid="+trainid+"&id="+id;
			}else if(_fromURL.equals("HrmTrainTestAdd")){
				//中端--培训管理--培训考核新增
				String trainid = request.getParameter("trainid");
				title = "16143";				
				url = "/hrm/train/train/HrmTrainTestAdd.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainTestEdit")){
				//中端--培训管理--培训考核编辑
				String trainid = request.getParameter("trainid");
				title = "16143";				
				url = "/hrm/train/train/HrmTrainTestEdit.jsp?isdialog=1&id="+id+"&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainAssessAdd")){
				//中端--培训管理--培训考评新增
				String trainid = request.getParameter("trainid");
				title = "16144";				
				url = "/hrm/train/train/HrmTrainAssessAdd.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainAssessEdit")){
				//中端--培训管理--培训考评编辑
				String trainid = request.getParameter("trainid");
				title = "16144";				
				url = "/hrm/train/train/HrmTrainAssessEdit.jsp?isdialog=1&id="+id+"&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainLayoutAdd")){
				//中端--培训管理--培训规划新增
				title = "6128";				
				url = "/hrm/train/trainlayout/HrmTrainLayoutAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmTrainLayoutEditDo")){
				//中端--培训管理--培训规划编辑
				title = "6128";				
				url = "/hrm/train/trainlayout/HrmTrainLayoutEditDo.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmArrangeShiftSetAdd")){
				//中端--培训管理--新建排班范围
				title = "32766";				
				url = "/hrm/schedule/HrmArrangeShiftSetAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmArrangeShiftSetEdit")){
				//中端--培训管理--编辑排班范围
				title = "32766";				
				url = "/hrm/schedule/HrmArrangeShiftSetEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmArrangeShiftProcess")){
				//中端--排班维护--批量排班
				title = "32767";		
				String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
				String departmentid = Util.null2String(request.getParameter("departmentid"));
				String fromdate = Util.null2String(request.getParameter("fromdate"));
				String enddate = Util.null2String(request.getParameter("enddate"));
				url = "/hrm/schedule/HrmArrangeShiftProcess.jsp?isdialog=1&subcompanyid="+subcompanyid1
						+"&departmentid="+departmentid+"&fromdate="+fromdate+"&enddate="+enddate;
			}else if(_fromURL.equals("GetUserIcon")){
				//前端--修改头像
				title = "33471";
				url = "/messager/GetUserIcon.jsp?requestFrom=homepage&isManager="+request.getParameter("isManager")+"&userId="+request.getParameter("userId")+"&subcompanyid="+request.getParameter("subcompanyid")+"&loginid="+Tools.getURLDecode(request.getParameter("loginid"));
			}
			else if(_fromURL.equals("sysadminAdd")){
				//中端--权限管理员设置
				title = "1507";	
				url = "/systeminfo/sysadmin/addSysadmin.jsp?isdialog=1";
			}
			else if(_fromURL.equals("sysadminEdit")){
				//中端--权限管理员设置
				title = "1507";	
				url = "/systeminfo/sysadmin/sysadminEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmDefaultScheduleAdd")){
				//中端--考勤管理--一般考勤时间新增
				title = "16254";
				url = "/hrm/schedule/HrmDefaultScheduleAdd.jsp?isdialog=1&subcompanyid="+Util.null2String(request.getParameter("subcompanyid"));
			}else if(_fromURL.equals("HrmDefaultScheduleEdit")){
				//中端--考勤管理--一般考勤时间编辑
				title = "16254";
				url = "/hrm/schedule/HrmDefaultSchedule.jsp?isdialog=1&id="+id+"&subcompanyid="+Util.null2String(request.getParameter("subcompanyid"));
			}else if(_fromURL.equals("PSLPeriodAdd")){
				//中端--考勤管理--带薪病假有效期设置新增
				title = "131559";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				String leavetype = Util.null2String(kv.get("leavetype"));
				url = "/hrm/schedule/PSLPeriodAdd.jsp?isdialog=1&subcompanyid="+subcompanyid+"&leavetype="+leavetype;
			}else if(_fromURL.equals("PSLPeriodEdit")){
				//中端--考勤管理--带薪病假有效期设置编辑
				title = "131559";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				String leavetype = Util.null2String(kv.get("leavetype"));
				url = "/hrm/schedule/PSLPeriodEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid+"&leavetype="+leavetype;
			}else if(_fromURL.equals("PSLBatchAdd")){
				//中端--考勤管理--带薪病假批量处理设置
				title = "131560";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				String leavetype = Util.null2String(kv.get("leavetype"));
				url = "/hrm/schedule/PSLBatchAdd.jsp?isdialog=1&subcompanyid="+subcompanyid+"&leavetype="+leavetype;
			}else if(_fromURL.equals("PSLBatchEdit")){
				//中端--考勤管理--带薪病假批量处理设置
				title = "131560";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				String leavetype = Util.null2String(kv.get("leavetype"));
				url = "/hrm/schedule/PSLBatchEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid+"&leavetype="+leavetype;
			}else if(_fromURL.equals("HrmScheduleDiffAdd")){
				//中端--考勤管理--自定义考勤--考勤种类新增
				title = "6139";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				url = "/hrm/schedule/HrmScheduleDiffAdd.jsp?isdialog=1&subcompanyid="+subcompanyid;
			}else if(_fromURL.equals("showHrmAttProcSet")){
				//考勤管理--考勤流程设置
				title = "15880,18015";
				url = "/hrm/attendance/hrmAttProcSet/content.jsp?isdialog=1&subcompanyid="+Util.null2String(kv.get("subcompanyid"))+"&id="+id;
			}else if(_fromURL.equals("HrmDefaultScheduleTab")){
				title = "16254,68";
				String HrmDefaultScheduleUrl = Util.getIntValue(id,-1)<0?"/hrm/schedule/HrmDefaultScheduleAdd.jsp?isdialog=1":"/hrm/schedule/HrmDefaultSchedule.jsp?isdialog=1&id="+id;
				String HrmOnlineKqUrl = "/hrm/schedule/HrmScheduleOnlineKqSystemSet.jsp?isdialog=1&id="+id;	
				url = HrmDefaultScheduleUrl;
				if(showpage.equals("2")){
					url = HrmOnlineKqUrl;
				}			
			}else if(_fromURL.equals("HrmScheduleDiffEdit")){
				//中端--考勤管理--自定义考勤--考勤种类编辑
				title = "6139";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				url = "/hrm/schedule/HrmScheduleDiffEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid;
			}else if(_fromURL.equals("HrmScheduleMonth")){
				String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
				String departmentid=Util.null2String(request.getParameter("departmentid"));
				if(method.equals("HrmScheduleMonthAdd")){
					title = "82,19397";
				}else if(method.equals("HrmScheduleMonthEdit")){
					title = "93,19397";
				}
				url = "/hrm/schedule/"+method+".jsp?id="+id+"&isdialog=1&subcompanyid="+subcompanyid+"&departmentid="+departmentid;
			}else if(_fromURL.equals("HrmArrangeShiftAdd")){
				//中端--考勤管理-排班种类新增
				title = "16255";
				url = "/hrm/schedule/HrmArrangeShiftAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmArrangeShift")){
				//中端--考勤管理--排班种类编辑
				title = "16255";
				url = "/hrm/schedule/HrmArrangeShift.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("AnnualPeriodAdd")){
				//中端--考勤管理-年假有效期设置新增
				title = "21598";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				url = "/hrm/schedule/AnnualPeriodAdd.jsp?isdialog=1&subcompanyid="+subcompanyid;;
			}else if(_fromURL.equals("AnnualPeriodEdit")){
				//中端--考勤管理--年假有效期设置编辑
				title = "21598";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				url = "/hrm/schedule/AnnualPeriodEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid;;
			}else if(_fromURL.equals("AnnualBatchAdd")){
				//中端--考勤管理-年假批量处理规则新增
				title = "21599";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				url = "/hrm/schedule/AnnualBatchAdd.jsp?isdialog=1&subcompanyid="+subcompanyid;;
			}else if(_fromURL.equals("AnnualBatchEdit")){
				//中端--考勤管理--年假批量处理规则编辑
				title = "21599";
				String subcompanyid = Util.null2String(kv.get("subcompanyid"));
				url = "/hrm/schedule/AnnualBatchEdit.jsp?isdialog=1&id="+id+"&subcompanyid="+subcompanyid;;
			}else if(_fromURL.equals("HrmCheckKindAdd")){
				//中端--考核种类--新增
				title = "6118";
				url = "/hrm/check/HrmCheckKindAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmCheckKindEdit")){
				//中端--考核种类--编辑
				title = "6118";
				url = "/hrm/check/HrmCheckKindEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmRpRedeployTime")){
				//报表--变动相关--	调动时间统计报表
				title = "15992";
				url = "/hrm/report/redeploy/HrmRpRedeployTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRedeployReport")){
				//报表--变动相关--	调动报表
				title = "15989";
				url = "/hrm/report/redeploy/HrmRedeployReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpRedeployDetail")){
				//报表--变动相关--	调动具体信息报表
				String departmentid = Util.null2String(kv.get("departmentid"));
				String joblevelfrom = Util.null2String(kv.get("joblevelfrom"));
				String joblevelto = Util.null2String(kv.get("joblevelto"));
				String fromdateselect = Util.null2String(kv.get("fromdateselect"));
				String fromdate = Util.null2String(kv.get("fromdate"));
				String enddate = Util.null2String(kv.get("enddate"));
				String newjoblevelfrom = Util.null2String(kv.get("newjoblevelfrom"));
				String newjoblevelto = Util.null2String(kv.get("newjoblevelto"));
				String newsubcompanyid = Util.null2String(kv.get("newsubcompanyid"));
				title = "15729";
				url = "/hrm/report/redeploy/HrmRpRedeployDetail.jsp?isdialog=1&newdepartment="+departmentid
				+"&joblevelfrom="+joblevelfrom+"&joblevelto="+joblevelto+"&fromdateselect="+fromdateselect
				+"&fromdate="+fromdate+"&enddate="+enddate+"&newjoblevelfrom="+newjoblevelfrom+"&newjoblevelto="+newjoblevelto
				+"&newsubcompanyid="+newsubcompanyid;
			}else if(_fromURL.equals("HrmRpResourceAddTime")){
				//报表--变动相关--	新增时间报表
				title = "16020";
				url = "/hrm/report/resourceadd/HrmRpResourceAddTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpResourceAddReport")){
				//报表--变动相关--	新增具体信息报表
				title = "16022";
				url = "/hrm/report/resourceadd/HrmRpResourceAddReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpResourceAddDetail")){
				//报表--变动相关--	新增人员具体信息报表
				String fromdateselect = Util.null2String(kv.get("fromdateselect"));
				String fromdate = Util.null2String(kv.get("fromdate"));
				String enddate = Util.null2String(kv.get("enddate"));
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				url = "/hrm/report/resourceadd/HrmRpResourceAddDetail.jsp?isdialog=1&olddepartment="+olddepartment
					+"&fromdateselect="+fromdateselect+"&fromdate="+fromdate+"&enddate="+enddate;
			}else if(_fromURL.equals("HrmRpHireTime")){
				//报表--变动相关--	转正时间统计报表
				title = "15984";
				url = "/hrm/report/hire/HrmRpHireTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmHireReport")){
				//报表--变动相关--	转正报表
				title = "15981";
				url = "/hrm/report/hire/HrmHireReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpHireDetail")){
				//报表--变动相关--	转正具体信息报表
				String fromdateselect = Util.null2String(kv.get("fromdateselect"));
				String fromdate = Util.null2String(kv.get("fromdate"));
				String enddate = Util.null2String(kv.get("enddate"));
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				url = "/hrm/report/hire/HrmRpHireDetail.jsp?isdialog=1&olddepartment="+olddepartment
					+"&fromdateselect="+fromdateselect+"&fromdate="+fromdate+"&enddate="+enddate;
			}else if(_fromURL.equals("HrmRpExtendTime")){
				//报表--变动相关--	续签时间报表
				title = "15954";
				url = "/hrm/report/extend/HrmRpExtendTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmExtendReport")){
				//报表--变动相关--	续签报表
				title = "15962";
				url = "/hrm/report/extend/HrmExtendReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpExtendDetail")){
				//报表--变动相关--	续签具体信息报表
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				String fromdateselect=Util.null2String(request.getParameter("fromdateselect"));
				String fromdate=Util.null2String(request.getParameter("fromdate"));
				String enddate=Util.null2String(request.getParameter("enddate"));
				String fromdatetoselect=Util.null2String(request.getParameter("fromdatetoselect"));
				String fromdateto=Util.null2String(request.getParameter("fromdateto"));
				String enddateto=Util.null2String(request.getParameter("enddateto"));
				url = "/hrm/report/extend/HrmRpExtendDetail.jsp?isdialog=1&olddepartment="+olddepartment
						+"&fromdateselect="+fromdateselect+"&fromdate="+fromdate+"&enddate="+enddate
						+"&fromtodateselect="+fromdatetoselect+"&fromtodate="+fromdateto+"&endtodate="+enddateto;
			}else if(_fromURL.equals("HrmRpRehireTime")){
				//报表--变动相关--	返聘时间报表
				title = "16004";
				url = "/hrm/report/rehire/HrmRpRehireTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRehireReport")){
				//报表--变动相关--	返聘报表
				title = "16002";
				url = "/hrm/report/rehire/HrmRehireReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpRehireDetail")){
				//报表--变动相关--	返聘具体信息报表
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				String fromdateselect=Util.null2String(request.getParameter("fromdateselect"));
				String fromdate=Util.null2String(request.getParameter("fromdate"));
				String enddate=Util.null2String(request.getParameter("enddate"));
				String fromdatetoselect=Util.null2String(request.getParameter("fromdatetoselect"));
				String fromdateto=Util.null2String(request.getParameter("fromdateto"));
				String enddateto=Util.null2String(request.getParameter("enddateto"));
				url = "/hrm/report/rehire/HrmRpRehireDetail.jsp?isdialog=1&olddepartment="+olddepartment
				+"&fromdateselect="+fromdateselect+"&fromdate="+fromdate+"&enddate="+enddate
				+"&fromtodateselect="+fromdatetoselect+"&fromtodate="+fromdateto+"&endtodate="+enddateto;
			}else if(_fromURL.equals("HrmRpRetireTime")){
				//报表--变动相关--	退休时间报表
				title = "16028";
				url = "/hrm/report/retire/HrmRpRetireTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRetireReport")){
				//报表--变动相关--	退休报表
				title = "16025";
				url = "/hrm/report/retire/HrmRetireReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpRetireDetail")){
				//报表--变动相关--	退休具体信息报表
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				String fromdateselect=Util.null2String(request.getParameter("fromdateselect"));
				String fromdate=Util.null2String(request.getParameter("fromdate"));
				String enddate=Util.null2String(request.getParameter("enddate"));
				url = "/hrm/report/retire/HrmRpRetireDetail.jsp?isdialog=1&olddepartment="+olddepartment
						+"&fromdateselect="+fromdateselect+"&fromdate="+fromdate+"&enddate="+enddate;
			}else if(_fromURL.equals("HrmRpDismissTime")){
				//报表--变动相关--	离职时间报表
				title = "15958";
				url = "/hrm/report/dismiss/HrmRpDismissTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmDismissReport")){
				//报表--变动相关--	离职报表
				title = "15955";
				url = "/hrm/report/dismiss/HrmDismissReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpDismissDetail")){
				//报表--变动相关--	离职具体报表
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				String isall=Util.null2String(request.getParameter("isall"));
				String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
				url = "/hrm/report/dismiss/HrmRpDismissDetail.jsp?isdialog=1&olddepartment="
						+olddepartment+"&isall="+isall+"&fromdateselect="+fromdateselect;;
			}else if(_fromURL.equals("HrmRpFireTime")){
				//报表--变动相关--	解聘时间报表
				title = "15975";
				url = "/hrm/report/fire/HrmRpFireTime.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmFireReport")){
				//报表--变动相关--	解聘报表
				title = "15972";
				url = "/hrm/report/fire/HrmFireReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpFireDetail")){
				//报表--变动相关--	解聘具体信息报表
				title = "15729";
				String olddepartment=Util.null2String(request.getParameter("olddepartment"));
				String fromdateselect=Util.null2String(request.getParameter("fromdateselect"));
				String fromdate=Util.null2String(request.getParameter("fromdate"));
				String enddate=Util.null2String(request.getParameter("enddate"));
				url = "/hrm/report/fire/HrmRpFireDetail.jsp?isdialog=1&olddepartment="+olddepartment
				+"&fromdateselect="+fromdateselect+"&fromdate="+fromdate+"&enddate="+enddate;
			}else if(_fromURL.equals("HrmOrgGroupAdd")){
				//中端--群组设置--新建群组
				title = "24002";
				url = "/hrm/orggroup/HrmOrgGroupAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmOrgGroupEdit")){
				//中端--群组设置--编辑群组
				title = "24002";
				url = "/hrm/orggroup/HrmOrgGroupEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmOrgGroupRelatedAdd")){
				//中端--群组设置--增加关联设置
				title = "24662";
				String orgGroupId = request.getParameter("orgGroupId");
				url = "/hrm/orggroup/HrmOrgGroupRelatedAdd.jsp?isdialog=1&id="+id+"&orgGroupId="+orgGroupId;
			}else if(_fromURL.equals("EditHrmCustomFieldSelect")){
				//中端--自定义设置--选择框--选项维护
				title = "32714";
				String item_id = request.getParameter("item_id");
				String alloption = StringUtil.getURLEncode(Util.null2String(request.getParameter("alloption")));
				url = "/hrm/resource/EditHrmCustomFieldSelect.jsp?id="+id+"&item_id="+item_id+"&alloption="+alloption;
			}else if(_fromURL.equals("BirthdayAdminSetting")){
				title = "";
				url = "/hrm/setting/BirthdayAdminSetting.jsp?isdialog=1";
			}else if(_fromURL.equals("ScheduleApplicationRuleSetting")){
				title = "15880,579,68";
				url = "/hrm/schedule/ScheduleApplicationRuleSetting.jsp?isdialog=1";
			}else if(_fromURL.equals("SignatureAdd")){
				//中端--签章管理--新增
				title = "131267";
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				String operatelevel = Util.null2String(request.getParameter("operatelevel"));
				String rolelevel = Util.null2String(request.getParameter("rolelevel"));
				url = "/docs/docs/SignatureAdd.jsp?isdialog=1&subcompanyid="+subcompanyid+"&operatelevel="+operatelevel+"&rolelevel="+rolelevel;
			}else if(_fromURL.equals("SignatureEdit")){
				//中端--签章管理--新增
				title = "131267";
				String markId = Util.null2String(request.getParameter("markId"));
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				String operatelevel = Util.null2String(request.getParameter("operatelevel"));
				String rolelevel = Util.null2String(request.getParameter("rolelevel"));
				url = "/docs/docs/SignatureEdit.jsp?isdialog=1&markId="+markId+"&subcompanyid="+subcompanyid+"&operatelevel="+operatelevel+"&rolelevel="+rolelevel;
			}else if(_fromURL.equals("HrmTrainTypeAdd")){
				//中端--培训管理--培训种类--新增
				title = "6130";
				url = "/hrm/train/traintype/HrmTrainTypeAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmTrainTypeEditDo")){
				//中端--培训管理--培训种类--编辑
				title = "6130";
				url = "/hrm/train/traintype/HrmTrainTypeEditDo.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmTrainPlanAdd")){
				//中端--培训管理--培训安排--新增
				title = "6156";
				url = "/hrm/train/trainplan/HrmTrainPlanAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmTrainPlanEditDo")){
				//中端--培训管理--培训安排--编辑
				title = "6156";
				url = "/hrm/train/trainplan/HrmTrainPlanEditDo.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmDepartmentRoles")){
				//中端--组织结构--角色
				title = "122";
				url = "/hrm/company/HrmDepartmentRoles.jsp?id="+id;
			}else if(_fromURL.equals("TrainPlanRangeAdd")){
				//中端--培训管理--公开范围--新增
				title = "6104";
				String planid = Util.null2String(request.getParameter("planid"));
				url = "/hrm/train/trainplan/HrmTrainPlanRangeAdd.jsp?isdialog=1&planid="+planid;
			}else if(_fromURL.equals("TrainPlanRangeEdit")){
				//中端--培训管理--公开范围--编辑
				title = "6104";
				url = "/hrm/train/trainplan/HrmTrainPlanRangeEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmTrainPlanRange")){
				//中端--培训管理--公开范围
				title = "6104";
				url = "/hrm/train/trainplan/HrmTrainPlanRange.jsp?isdialog=1&planid="+id;
			}else if(_fromURL.equals("HrmCareerApplyReport")){
				//报表--招聘管理--应聘人员
				title = "33822";
				url = "/hrm/report/careerapply/HrmCareerApplyReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpCareerApplySearch")){
				//报表--招聘管理--应聘人员
				title = "33823";
				url = "/hrm/report/careerapply/HrmRpCareerApplySearch.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmUseDemandReport")){
				//报表--招聘管理--用工需求
				title = "33820";
				url = "/hrm/report/usedemand/HrmUseDemandReport.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmRpUseDemandDetail")){
				//报表--招聘管理--用工需求
				title = "33821";
				String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
				String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
				String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
				String fromdatetoselect = Util.null2String(request.getParameter("fromdatetoselect"));
				String fromdateto=Util.fromScreen(request.getParameter("fromdateto"),user.getLanguage());
				String enddateto=Util.fromScreen(request.getParameter("enddateto"),user.getLanguage());
				url = "/hrm/report/usedemand/HrmRpUseDemandDetail.jsp?isdialog=1&fromdateselect="+fromdateselect+"&fromdatetoselect="+fromdatetoselect+"&fromdate="+fromdate+"&enddate="+enddate+"&fromdateto="+fromdateto+"&enddateto="+enddateto;
			}
			else if(_fromURL.equals("HrmTrainActorAdd")){
				title = "33841";
				String trainid = Util.null2String(request.getParameter("trainid"));
				url = "/hrm/train/train/HrmTrainActorAdd.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainTest")){
				title = "16143";
				String trainid = Util.null2String(request.getParameter("trainid"));
				url = "/hrm/train/train/HrmTrainTest.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainAssess")){
				title = "16144";
				String trainid = Util.null2String(request.getParameter("trainid"));
				url = "/hrm/train/train/HrmTrainAssess.jsp?isdialog=1&trainid="+trainid;
			}else if(_fromURL.equals("HrmTrainFinish")){
				title = "405,678";
				String trainid = Util.null2String(request.getParameter("trainid"));
				url = "/hrm/train/train/HrmTrainFinish.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmTrainFinishView")){
				title = "6135";
				String trainid = Util.null2String(request.getParameter("trainid"));
				url = "/hrm/train/train/HrmTrainFinishView.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmResourceTrainRecordEdit")){
				title = "2121";
				String paraid = Util.null2String(request.getParameter("paraid"));
				url = "/hrm/resource/HrmResourceTrainRecordEdit.jsp?isdialog=1&paraid="+id;
			}else if(_fromURL.equals("TrainLayoutAssess")){
				title = "6102";
				url = "/hrm/train/trainlayout/TrainLayoutAssess.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("TrainLayoutAssessAdd")){
				title = "6102";
				url = "/hrm/train/trainlayout/TrainLayoutAssessAdd.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmResourceTrainRecordBasic")){
				title = "24987";
				url = "/hrm/resource/HrmResourceTrainRecordBasic.jsp?isdialog=1&paraid="+id;
			}else if(_fromURL.equals("HrmCompanyAddVirtual")){
				//中端--虚拟组织结构--增加组织维度
				title = "34069";
				url = "/hrm/companyvirtual/HrmCompanyAdd.jsp?isdialog=1";
			}else if(_fromURL.equals("HrmCompanyEditVirtual")){
				//中端--虚拟组织结构--编辑组织维度
				title = "34069";
				url = "/hrm/companyvirtual/HrmCompanyEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmSubCompanyAddVirtual")){
				//中端--虚拟组织结构--增加分部
				String virtualtype = Util.null2String(request.getParameter("virtualtype"));
				String companyid = Util.null2String(request.getParameter("companyid"));
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				if(method.equals("addSiblingSubCompany")){
					//增加同级分部
					title = "17897";
					url = "/hrm/companyvirtual/HrmSubCompanyAdd.jsp?cmd=addSiblingSubCompany&isdialog=1&subcompanyid="+subcompanyid+"&virtualtype="+virtualtype;
				}else if(method.equals("addChildSubCompany")){
					//增加下级分部
					String supsubcomid = Util.null2String(request.getParameter("supsubcomid"));
					title="17898";
					url = "/hrm/companyvirtual/HrmSubCompanyAdd.jsp?cmd=addChildSubCompany&isdialog=1&subcompanyid="+subcompanyid+"&virtualtype="+virtualtype;
				}else{
					//增加分部
					title = "141";
					url = "/hrm/companyvirtual/HrmSubCompanyAdd.jsp?isdialog=1&companyid="+companyid+"&virtualtype="+virtualtype;
				}
			}else if(_fromURL.equals("HrmSubCompanyEditVirtual")){
				//中端--虚拟组织结构--编辑分部
				title = "141";
				String virtualtype = Util.null2String(request.getParameter("virtualtype"));
				url = "/hrm/companyvirtual/HrmSubCompanyEdit.jsp?isdialog=1&id="+id+"&virtualtype="+virtualtype;
			}else if(_fromURL.equals("HrmDepartmentAddVirtual")){
				//中端--组织结构--增加部门
				String virtualtype = Util.null2String(request.getParameter("virtualtype"));
				String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
				if(method.equals("addSiblingDepartment")){
					//增加同级部门
					title = "17899";
					url = "/hrm/companyvirtual/HrmDepartmentAdd.jsp?cmd=addSiblingDepartment&isdialog=1&id="+id+"&virtualtype="+virtualtype;
				}else if(method.equals("addChildDepartment")){
					//增加下级部门
					title="17587";
					String supdepid = Util.null2String(request.getParameter("supdepid"));
					url = "/hrm/companyvirtual/HrmDepartmentAdd.jsp?cmd=addChildDepartment&isdialog=1&id="+id+"&virtualtype="+virtualtype;
					
				}else{
					//增加部门
					title = "124";
					url = "/hrm/companyvirtual/HrmDepartmentAdd.jsp?isdialog=1&subcompanyid="+subcompanyid+"&virtualtype="+virtualtype;
				}
			}else if(_fromURL.equals("HrmDepartmentEditVirtual")){
				//中端--组织结构--编辑部门
				title = "124";
				String virtualtype = Util.null2String(request.getParameter("virtualtype"));
				url = "/hrm/companyvirtual/HrmDepartmentEdit.jsp?cmd=editDepartment&isdialog=1&id="+id+"&virtualtype="+virtualtype;
			}else if(_fromURL.equals("HrmResourceVirtualManagerSet")){
				//中端--虚拟组织结构--设置上级
				title = "596";
				String departmentid = Util.null2String(request.getParameter("departmentid"));
				url = "/hrm/companyvirtual/HrmResourceVirtualManagerSet.jsp?isdialog=1&id="+id+"&departmentid="+departmentid;
			}else if(_fromURL.equals("HrmResourceVirtualManagerSets")){
				//中端--虚拟组织结构--设置上级(批量)
				title = "596";
				String ids = Util.null2String(request.getParameter("ids"));
				String departmentid = Util.null2String(request.getParameter("departmentid"));
				url = "/hrm/companyvirtual/HrmResourceVirtualManagerSets.jsp?isdialog=1&ids="+ids+"&departmentid="+departmentid;
			}else if(_fromURL.equals("setDepartmentVirtual")){
				title = "34101";
				String resourceids = Util.null2String(request.getParameter("resourceids"));
				url = "/hrm/companyvirtual/HrmResourceVirtualDepartmentSet.jsp?isdialog=1&resourceids="+resourceids;
			}else if(_fromURL.equals("LdapUserList")){
				mouldid = "customer";
				//合并AD域人员
				if(method.equals("LdapUserMerge")){
					title = "34288";
					url = "/hrm/resource/LdapUserMerge.jsp?isdialog=1&id="+id;
				}
			} else if(_fromURL.equals("LdapDesignate")) {
				if(method.equals("designate")) {
					//title = "19438";
					url = "/ldap/DesignateDepartment.jsp?isdialog=1&id="+id;
				}
			}else if(_fromURL.equals("hrmCityTwo")){
				//中端--设置中心--基础设置--城市设置
				title = "25223";
				mouldid = "setting";
				if(method.equals("HrmCityEditTwo")){
					title = CitytwoComInfo.getCityname(String.valueOf(id));
					titleflag = true;
				}
				String cityid = Util.null2String(request.getParameter("cityid"));
				url = "/hrm/city/"+method+".jsp?isdialog=1&cityid="+cityid+"&id="+id;
			} else if("verifyPswd".equals(_fromURL)){
				String checked = Util.null2String(request.getParameter("checked"));
				String isShow = Util.null2String(request.getParameter("isShow"));
				title = "81605";
				url = "/hrm/password/verifyPswd.jsp?checked="+checked+"&isShow="+isShow;
			} else if("questionSetStep".equals(_fromURL)){
				title = "81605";
				url = "/hrm/password/questionSetStep.jsp";
			} else if("sysadminSet".equals(_fromURL)){
				title = "32496";
				url = "/hrm/resource/HrmSysAdminSet.jsp?id="+id;
			} else if(_fromURL.equals("HrmCheckMark")){
				//前端--奖惩考核--我的考核
				title="6106";
				url = "/hrm/actualize/HrmCheckMark.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmJobTitlesTempletAdd")){
				//中端--基本设置--岗位设置新增
				title = "6086";
				String jobactivite = request.getParameter("jobactivite");
				url = "/hrm/jobtitlestemplet/HrmJobTitlesTempletAdd.jsp?isdialog=1&jobactivite="+jobactivite;
			}else if(_fromURL.equals("HrmJobTitlesTempletEdit")){
				//中端--基本设置--岗位设置编辑
				title = "6086";
				url = "/hrm/jobtitlestemplet/HrmJobTitlesTempletEdit.jsp?isdialog=1&id="+id;
			}else if(_fromURL.equals("HrmImport")){
        //中端设置--人员导入
        title = "17887";
        url = "/hrm/resource/HrmImport.jsp?isdialog=1";
      }else if(_fromURL.equals("HrmResourceImport")){
				//中端--组织权限中心--基础数据导入
				title = request.getParameter("title");
				String importtype=request.getParameter("importtype");
				url = "/hrm/import/HrmBasicDataImport.jsp?isdialog=1&importtype="+importtype+"&title="+title;
				
			}else if(_fromURL.equals("HrmBasicDataImportLog")){
				//中端--组织权限中心--基础数据导入日志动态显示
				title = "125679";
				String importtype=request.getParameter("importtype");
				url = "/hrm/import/HrmBasicDataImportLog.jsp?isdialog=1&importtype="+importtype;
			}else if(_fromURL.equals("HrmGroupMemberDataImport")){
				//中端--组织权限中心--基础数据导入日志动态显示
				title = "431";
				String importtype=request.getParameter("importtype");
				String groupid=request.getParameter("groupid");
				url = "/hrm/import/HrmGroupMemberDataImport.jsp?isdialog=1&importtype="+importtype+"&groupid="+groupid;
			}else if(_fromURL.equals("HrmBasicDataImportHistoryLog")){
				//中端--组织权限中心--基础数据导入日志
				title = "24644";
				String importtype=request.getParameter("importtype");
				url = "/hrm/import/HrmBasicDataImportHistoryLog.jsp?isdialog=1&importtype="+importtype;
			}else if(_fromURL.equals("HrmGroupMemberDataImportLog")){
				title = "431";
				String importtype=request.getParameter("importtype");
				String groupid=request.getParameter("groupid");
				url = "/hrm/import/HrmGroupMemberDataImportLog.jsp?isdialog=1&importtype="+importtype+"&groupid="+groupid;
			}else if(_fromURL.equals("HrmResourceSysBelongtoEdit")){
				//中端--账户中心--人员系统信息批量设置
				title = "125525";
				String importtype=request.getParameter("importtype");
				String ids=request.getParameter("ids");
				url = "/hrm/resource/HrmResourceSysBelongtoEdit.jsp?isdialog=1&ids="+ids;
			}else if(_fromURL.equals("outresourceAssignSet")){
				title = "126086";
				String customids=request.getParameter("customids");
				url = "/hrm/outinterface/outresourceAssignSet.jsp?isdialog=1&customids="+customids;
			}
		%>
		<script type="text/javascript">
			jQuery(function(){
				jQuery('.e8_box').Tabs({
					getLine:1,
					iframe:"tabcontentframe",
					mouldID:"<%=MouldIDConst.getID(mouldid)%>",
					staticOnLoad:true,
					objName:"<%=title.length()>0?(titleflag?title:SystemEnv.getHtmlLabelNames(title,user.getLanguage())):"" %>"
				});
				<%if(titleflag && _fromURL.equals("hrmRoles")){%>
					$('#objName').text("<%=title%>") ;
				<%}%>
			});
		</script>
	</head>
	<BODY scroll="no">
		<div class="e8_box demo2">
			<div class="e8_boxhead">
				<div class="div_e8_xtree" id="div_e8_xtree"></div>
				<div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div>
						<ul class="tab_menu">
						<%
							if(_fromURL.equals("HrmCareerPlanEdit")){
								if(!method.equals("finish")){
									tab.add(new TabLi("/hrm/career/careerplan/HrmCareerPlanEdit.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),true));
									tab.add(new TabLi("/hrm/career/careerplan/HrmCareerStep.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(15745,user.getLanguage())));
									tab.add(new TabLi("/hrm/career/inviteinfo/list.jsp?isdialog=1&cmd=notchangeplan&planid="+id,SystemEnv.getHtmlLabelName(366,user.getLanguage())));
									tab.add(new TabLi("/hrm/career/careerplan/HrmCareerApplyInfo.jsp?isdialog=1&planid="+id,SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())));
									//tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?isdialog=1&planid="+id,SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())));
									out.println(tab.show());
								}
							}else if(_fromURL.equals("inviteInfo") && !method.equals("showapplyinfo")){
								String planid = Util.null2String(kv.get("planid"));
								tab.add(new TabLi("/hrm/career/inviteinfo/content.jsp?method="+method+"&planid="+planid+"&cmd="+cmd+"&isdialog=1&id="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),true));
								if(method.equals("show")||method.equals("edit")){
									tab.add(new TabLi("/hrm/career/inviteinfo/InviteSchedule.jsp?method="+method+"&planid="+planid+"&isdialog=1&inviteid="+id,SystemEnv.getHtmlLabelName(15720,user.getLanguage())));
								}
								if(method.equals("edit")){
									tab.add(new TabLi("/hrm/career/applyinfo/list.jsp?isdialog=1&planid="+planid+"&inviteid="+id,SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())));
								}
								if(!method.equals("show")){
									out.println(tab.show());
								}
							}else if(_fromURL.equals("applyInfo") && method.equals("edit")){
								tab.add(new TabLi("/hrm/career/applyinfo/content.jsp?method="+method+"&isdialog=1&applyid="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),true));
								tab.add(new TabLi("/hrm/career/applyinfo/myinfo.jsp?method="+method+"&isdialog=1&applyid="+id,SystemEnv.getHtmlLabelName(15687,user.getLanguage())));
								tab.add(new TabLi("/hrm/career/applyinfo/workinfo.jsp?method="+method+"&isdialog=1&applyid="+id,SystemEnv.getHtmlLabelName(15688,user.getLanguage())));
								out.println(tab.show());
							}else if(_fromURL.equals("applyInfo") && method.equals("HrmInterviewResult")){
								String planid = Util.null2String(kv.get("planid"));
								String result = Util.null2String(kv.get("result"));
								tab.add(new TabLi("/hrm/career/HrmInterviewResult.jsp?showpage=1&isdialog=1&result="+result+"&planid="+planid+"&id="+id,SystemEnv.getHtmlLabelName(15729,user.getLanguage()),true));
								tab.add(new TabLi("/hrm/career/HrmInterviewResult.jsp?showpage=2&isdialog=1&result="+result+"&planid="+planid+"&id="+id,SystemEnv.getHtmlLabelName(15738,user.getLanguage())));
								tab.add(new TabLi("/hrm/career/HrmInterviewResult1.jsp?showpage=2&isdialog=1&result="+result+"&planid="+planid+"&id="+id,SystemEnv.getHtmlLabelName(15920,user.getLanguage())));
								out.println(tab.show());
							}else if(_fromURL.equals("applyInfo") && method.equals("share")){
								tab.add(new TabLi("/hrm/career/HrmShare.jsp?isdialog=1&showpage=1&applyid="+id,SystemEnv.getHtmlLabelNames("87,119",user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/hrm/career/HrmShare.jsp?isdialog=1&showpage=2&applyid="+id,SystemEnv.getHtmlLabelNames("119,25433",user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}else if(_fromURL.equals("systemRightGroup") && method.equals("edit")){
								tab.add(new TabLi("/systeminfo/systemright/SystemRightGroupEdit.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("492,33361",user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/systeminfo/systemright/SystemRightAuthority.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}else if(_fromURL.equals("hrmRoles") && method.equals("HrmRolesEdit")){
								String nShow = Tools.vString(kv.get("nShow"));
								if(!nShow.equals("true")){
									tab.add(new TabLi("/hrm/roles/HrmRolesEdit.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(33401,user.getLanguage()),showpage.equals("1")));
									tab.add(new TabLi("/hrm/roles/HrmRolesFucRightSet.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(17864,user.getLanguage()),showpage.equals("2")));
									if(detachable == 1){
										tab.add(new TabLi("/hrm/roles/HrmRolesStrRightSet.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(17865,user.getLanguage()),showpage.equals("4")));
									}
									tab.add(new TabLi("/hrm/roles/HrmRolesMembers.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("431,320",user.getLanguage()),showpage.equals("3")));
									out.println(tab.show());
								}
							}else if(_fromURL.equals("fnaCurrencies") && (method.equals("FnaCurrenciesEdit") || method.equals("FnaCurrenciesView"))){
								tab.add(new TabLi("/fna/maintenance/FnaCurrenciesEdit.jsp?isdialog=1&showpage=1&id="+id,SystemEnv.getHtmlLabelName(1361,user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/fna/maintenance/FnaCurrenciesView.jsp?isdialog=1&showpage=2&id="+id,SystemEnv.getHtmlLabelNames("588,17463",user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}else if(_fromURL.equals("hrmReport") && cmd.equals("hrmContract") && method.equals("HrmContractReport")){
								url = "/hrm/report/contract/"+method+".jsp?isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1"));
								tab.add(new TabLi("/hrm/report/contract/"+method+".jsp?showpage=1&isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1")),(SystemEnv.getHtmlLabelName(124,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(277,user.getLanguage())),showpage.equals("1")));
								tab.add(new TabLi("/hrm/report/contract/"+method+".jsp?showpage=2&isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1")),(SystemEnv.getHtmlLabelName(716,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(277,user.getLanguage())),showpage.equals("2")));
								tab.add(new TabLi("/hrm/report/contract/"+method+".jsp?showpage=3&isdialog=1&subcompanyid1="+Util.null2String(request.getParameter("subcompanyid1")),(SystemEnv.getHtmlLabelName(124,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(716,user.getLanguage())),showpage.equals("3")));
								out.println(tab.show());
							}else if(_fromURL.equals("showHrmAttProcSet")){
								tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/content.jsp?isdialog=1&subcompanyid="+Util.null2String(kv.get("subcompanyid"))+"&id="+id,SystemEnv.getHtmlLabelName(82826,user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/wfFields.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelNames("15880,82827",user.getLanguage()),showpage.equals("2")));
								if(Tools.parseToInt(kv.get("field006")) == 0) tab.add(new TabLi("/hrm/attendance/hrmAttProcSet/wfSet.jsp?isdialog=1&id="+id,SystemEnv.getHtmlLabelName(33085,user.getLanguage()),showpage.equals("3")));
								out.println(tab.show());
							}else if(_fromURL.equals("HrmDefaultScheduleTab")){
								String HrmDefaultScheduleUrl = Util.getIntValue(id,-1)<0?"/hrm/schedule/HrmDefaultScheduleAdd.jsp?isdialog=1":"/hrm/schedule/HrmDefaultSchedule.jsp?isdialog=1";
								String HrmOnlineKqUrl = "/hrm/schedule/HrmScheduleOnlineKqSystemSet.jsp?isdialog=1";
								tab.add(new TabLi(HrmDefaultScheduleUrl+"&subcompanyid="+Util.null2String(kv.get("subcompanyid"))+"&id="+id,SystemEnv.getHtmlLabelName(16254,user.getLanguage()),showpage.equals("1")));
								tab.add(new TabLi(HrmOnlineKqUrl+"&id="+id+"&subcompanyid="+Util.null2String(kv.get("subcompanyid")),SystemEnv.getHtmlLabelName(34169,user.getLanguage()),showpage.equals("2")));
								out.println(tab.show());
							}
						%>
						<%if(_fromURL.equals("HrmTrainEdit")){
							//基本信息			培训日程			培训考核			培训考评
							String trainid = request.getParameter("trainid");
						%>
		        <li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainEditDo.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainSchedule.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage()) %></a>
						</li>
						<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainTest.jsp?isdialog=1&trainid=<%=id %>"><%=SystemEnv.getHtmlLabelName(16143,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainAssess.jsp?isdialog=1&trainid=<%=id %>"><%=SystemEnv.getHtmlLabelName(16144,user.getLanguage()) %></a>
						</li>
		        <%}else if(_fromURL.equals("HrmTrainDayAdd")){
		    			String trainid = request.getParameter("trainid");
		        %>
		        <li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayAdd.jsp?isdialog=1&trainid=<%=trainid %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayActorList.jsp?isdialog=1&id=<%=trainid %>"><%=SystemEnv.getHtmlLabelName(33430,user.getLanguage()) %></a>
						</li>
		        <%} else if(_fromURL.equals("HrmTrainDayEdit")){
		    			String trainid = request.getParameter("trainid");
		        %>
		    		<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayEdit.jsp?isdialog=1&trainid=<%=trainid %>&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/train/HrmTrainDayActorList.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(33430,user.getLanguage()) %></a>
						</li>
    				<%} else if ("authHandledMatters".equals(_fromURL)) {%>
    					<li id="tab_1" class="current">
							<a href="<%=url%>&eventSearchType=1" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
							</a>
						</li>
						<li id="tab_2">
							<a href="<%=url%>&eventSearchType=2" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%>
							</a>
						</li>
						<li id="tab_3">
							<a href="<%=url%>&eventSearchType=3" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%>
							</a>
						</li>
    				<%}else if(_fromURL.equals("HrmTrainPlanEditDo")){
    				%>
		    		<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/train/trainplan/HrmTrainPlanEditDo.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/train/trainplan/HrmTrainPlanDayEdit.jsp?isdialog=1&id=<%=id %>"><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage()) %></a>
						</li>
					  <li>
							<a target="tabcontentframe" href="/hrm/train/trainplan/HrmTrainPlanRange.jsp?isdialog=1&planid=<%=id %>"><%=SystemEnv.getHtmlLabelName(6104,user.getLanguage()) %></a>
						</li>
		    	 <%}else if(_fromURL.equals("HrmResourceTrainRecordBasic")){
    				%>
		    		<li class="current" onMouseOver="javascript:showSecTabMenu('.e8_box','tabcontentframe');">
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceTrainRecordBasic.jsp?isdialog=1&paraid=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
		       	<li>
							<a target="tabcontentframe" href="/hrm/resource/HrmResourceTrainRecordDay.jsp?isdialog=1&paraid=<%=id %>"><%=SystemEnv.getHtmlLabelName(33430,user.getLanguage()) %></a>
						</li>
						<%}else if(_fromURL.equals("hrmGroup")){
		      		if(cmd.equals("edit")){
		    		 		int type = 0;
		    		 		rs.executeSql("select type from hrmgroup where id ="+id);
		    		 		if(rs.next()){
		    		 			type = rs.getInt("type");
		    		 		}
		    		 	%>
	    				<li class="<%=showpage.equals("1")?"current":"" %>" onMouseOver="<%=showpage.equals("1")?"javascript:showSecTabMenu('.e8_box','tabcontentframe');":"" %>">
							<a target="tabcontentframe" href="/hrm/group/HrmGroupBaseAdd.jsp?isdialog=1&showpage=1&groupid=<%=id %>"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
							</li>
			    		<li class="<%=showpage.equals("2")?"current":"" %>" onMouseOver="<%=showpage.equals("1")?"javascript:showSecTabMenu('.e8_box','tabcontentframe');":"" %>">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupMember.jsp?isdialog=1&showpage=2&groupid=<%=id %>"><%=SystemEnv.getHtmlLabelName(431,user.getLanguage()) %></a>
							</li>
							<%if(type==1){ %>
			       	<li class="<%=showpage.equals("3")?"current":"" %>" onMouseOver="<%=showpage.equals("1")?"javascript:showSecTabMenu('.e8_box','tabcontentframe');":"" %>">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupShare.jsp?isdialog=1&showpage=3&groupid=<%=id %>"><%=SystemEnv.getHtmlLabelName(19910,user.getLanguage()) %></a>
							</li>
							<%} %>
				 <%}else if(_fromURL.equals("hrmGroup")&&method.equals("HrmGroupSuggestList")){
		      		//中端--常用组变更提醒
		      		String status = Util.null2String(request.getParameter("status"),"0");
			      	%>
			      	<li class="<%=status.equals("0")?"current":"" %>" onMouseOver="javascript:showSecTabMenu();">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupSuggestList.jsp?status=0&isdialog=1"><%=SystemEnv.getHtmlLabelName(16349,user.getLanguage()) %></a>
							</li>
						  <li class="<%=status.equals("1")?"current":"" %>">
								<a target="tabcontentframe" href="/hrm/group/HrmGroupSuggestList.jsp?status=1&isdialog=1"><%=SystemEnv.getHtmlLabelName(1454,user.getLanguage()) %></a>
							</li>
			     <%}%>
			    	<%}%>
						</ul>
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<%
       		if(url.endsWith(".jsp")){
       			url +="?fromHrmDialogTab=1";
       		}else{
       			url +="&fromHrmDialogTab=1";
       		}
					%>
					<iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>

