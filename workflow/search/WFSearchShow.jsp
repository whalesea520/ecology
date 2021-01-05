
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="weaver.workflow.request.todo.RequestUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowSearchCustom" class="weaver.workflow.search.WorkflowSearchCustom" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />

<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%
String isfrom = Util.null2String(request.getParameter("isfrom"));//是否来自自定义查询

boolean isopenos = RequestUtil.isOpenOtherSystemToDo();
String showsystem = requestutil.getOfsSetting().getShowsysname();

String fastsearch = Util.null2String(request.getParameter("fastsearch"));


String fromhp = Util.null2String((String)session.getAttribute("fromhp"));//来自门户
String isall = Util.null2String((String)session.getAttribute("isall"));//来自门户所有流程


//System.out.println("fromhp = "+fromhp);
String customid = Util.null2String(request.getParameter("customid"));
String workflowid = Util.null2String(request.getParameter("workflowid"));//类型流程id
int _borrowRequestid = Util.getIntValue(request.getParameter("_borrowRequestid"),-1);
int _borrowDetailRecordId = Util.getIntValue(request.getParameter("_borrowDetailRecordId"),-1);
boolean _isFromShowRelatedProcess = Util.getIntValue(request.getParameter("_isFromShowRelatedProcess"),-1)==1;//是否来自于借款流程查看相关还款流程按钮的查询


boolean LoanRepaymentAnalysisInnerDetaile = Util.getIntValue(request.getParameter("LoanRepaymentAnalysisInnerDetaile"),0)==1;//是否来自借款报表页面




%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/datetime_wev8.js"></script>
		<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			jQuery(function(){
				jQuery("#topTitle").topMenuTitle({searchFn:searchItem});
	  		 	jQuery("#hoverBtnSpan").hoverBtn(); 	
			});


			function doSearch(){
				if (check_form(frmmain,'')){
					$("input[name$=_value]").each(function (i, e) {
						thisval = $(this).val();
						if (thisval != undefined && thisval != "") {
							var ename = $(this).attr("name");
							var eid = ename.replace("con", "").replace("_value", "");

							var targetelement = $("#con" + eid + "_name");
							var temphtml = "";
							//alert($("#" + ename + "span").children().length);
							$("#" + ename + "span a").each(function () {
								temphtml += " " + $(this).text();
							});
							var checkspan = /^<.*$/;
							if(checkspan.test(temphtml)){
								temphtml=temphtml.replace(/<[^>]+>/g,"");
							}
							targetelement.val(temphtml);
						}
					});

					$("input").each(function (i, e) {
						var thisval = $(this).val();
						if (thisval != undefined && thisval != "") {
							var ename = $(this).attr("name");
							var targetelement = $("#" + ename + "_name");

							if(!targetelement) return;
							var temphtml = "";
							$("#" + ename + "span a") && $("#" + ename + "span a").each(function () {
								temphtml += " " + $(this).text();
							});
							var checkspan = /^<.*$/;
							if(checkspan.test(temphtml)){
								temphtml=temphtml.replace(/<[^>]+>/g,"");
							}

							targetelement.val(temphtml);
						}
					});

					$('#weaver').submit();
				}
			}

			jQuery(document).ready(function(){

				//如果指定了自定义查询编号，则加载自定义查询条件








				<%
				if(!"customSearch".equals(isfrom)){
				%>
				var customQueryId = <%=request.getParameter("customid")%>;
				if(customQueryId){
					loadCustomSearch(null, customQueryId);
				}
				<%
				}else{
				%>
					loadCustomSearch("<%=workflowid%>","<%=customid%>");
				<%
				}
				%>
				
				//给select类型的控件赋值








				<%
					String[] selectes = new String[]{
						"typeid","requestlevel","creatertype","createdateselect","recievedateselect",
						"wfstatu","archivestyle","isdeleted","nodetype"
					};

					for(int i = 0; i < selectes.length; i++){
						String selectName = selectes[i];
						if (request.getParameter(selectName) != null) {	
				%>
					$("select[name=<%=selectName%>]").val(<%="'" + request.getParameter(selectName) + "'"%>); 
						<%}%> 
					$("select[name=<%=selectName%>]").removeAttr('notBeauty');
					beautySelect('select[name=<%=selectName%>]');
				<%
					}
				%>
				
				if (parent && parent.showTree) {
					parent.showTree();
				}
			});

			/* 加载用户自定义的查询条件 */
			function loadCustomSearch(workFlowId, cutomQueryId){
				
				if(!workFlowId && !cutomQueryId){
					jQuery('#customQueryDiv').html('');
					return;
				}
				
				if(workFlowId == "<%=workflowid%>"){
					loadCustomSearchForReset(workFlowId,"<%=customid%>");
					return;
				}
				<%
					/*
					* 获取从上一个页面传入的自定义查询条件，将自定义查询条件转换为JSON格式的字符串。








					* 将JSON数据post给WFCustomSearchGenereate.jsp页面，生成自定义查询条件即为赋好值的页面。








					* 以此实现查询的条件的保存，不需要用户再次输入。








					*/
					String[] checkcons = request.getParameterValues("check_con");

					String customJsonString = "{";
					String checkboxes = "'";
					if(checkcons != null){
					  	for(int i = 0; i < checkcons.length; i++){
							String id         = ""+checkcons[i];
							String tmpvalue   = ""+Util.null2String(request.getParameter("con"+id+"_value"));
							String tmpvalue1  = ""+Util.null2String(request.getParameter("con"+id+"_value1"));
							String tmpname    = ""+Util.null2String(request.getParameter("con"+id+"_name"));

							if(!tmpvalue.equals("")){
								customJsonString  += "con"+id+"_value" + ":'" + tmpvalue + "',";	
							} 
							if(!tmpvalue1.equals("")){
								customJsonString  += "con"+id+"_value1" + ":'" + tmpvalue1 + "',";	
							} 
							if(!tmpname.equals("")){
								customJsonString  += "con"+id+"_name" + ":'" + tmpname + "',";	
							} 

							if(!tmpvalue.equals("")){
								checkboxes += (id + ",");
							}
						}
					}

					if(customJsonString.length() > 1){
						customJsonString = customJsonString.substring(0, customJsonString.length() - 1);	
					} 
					customJsonString += "}";

					if(checkboxes.length() > 1){
						checkboxes = checkboxes.substring(0, checkboxes.length() - 1);
					}
					checkboxes += "'"; 

					String nameValueString = "'";
					Enumeration elementNames = (Enumeration) request.getParameterNames();   
				    while(elementNames.hasMoreElements())     {   
				    	String elementName = (String)elementNames.nextElement(); 

				    	if(elementName.startsWith("con") 
				    		&& elementName.endsWith("_value")
				    		&& request.getParameter(elementName) != null 
				    		&& !request.getParameter(elementName).trim().equals("")
				    	){
			    			nameValueString += (elementName + ":" + Util.null2String(request.getParameter(elementName)) + ",");	
				    	}  
				    } 
					
					if(nameValueString.length() > 1){
						nameValueString = nameValueString.substring(0, nameValueString.length() - 1);
					}
					nameValueString += "'";

				%>

				var parameter = <%=customJsonString%>;
				parameter['issimple'] = true;
				parameter['workflowid'] = workFlowId;
				parameter['customid'] = cutomQueryId;
				parameter['checkboxes'] = <%=checkboxes%>;
				parameter['allValues'] = <%=nameValueString%>;

				jQuery.post(
					'/workflow/search/WFCustomSearchGenerate.jsp',
					parameter,
					function(data){
						jQuery('#customQueryDiv').html(data);

						jQuery('#customQueryDiv').find('select').each(function(i,v){
							beautySelect(jQuery(v));
						});

						jQuery('#cutomQuerySelect').change(function(e){
							loadCustomSearch(null, jQuery(this).val());
						});

						jQuery('#cutomQuerySelect').click(function(e){
							if (e && e.stopPropagation)  
				            	e.stopPropagation()  
				       		else 
				            	window.event.cancelBubble=true 	
						});
					}
				);
			}
		</script>
	</head>


	<body>
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%

		WfAdvanceSearchUtil wfd = new WfAdvanceSearchUtil(request,RecordSet);
		
		
		
		String offical = Util.null2String(request.getParameter("offical"));
		int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
		//获取从WFSearchs.jsp传过来的参数
		String viewtype = Util.null2String(request.getParameter("viewtype"));//0：未读  -1：反馈








		String isremark = Util.null2String(request.getParameter("isremark"));//5:超时
		//获取从WFSearche.jsp传过来的参数
		String typeid = Util.null2String(request.getParameter("typeid"));//流程类型id
		
		
		//主要用于 显示定制列以及 表格 每页展示记录数选择
		String pageIdStr = "8";
		if(offical.equals("1"))pageIdStr = "13";

		//add by bpf 2013-11-07
		String nodetype = Util.null2String(request.getParameter("nodetype"));//节点类型
		String creatertype = Util.null2String(request.getParameter("creatertype"));//创建人类型








		String createrid = Util.null2String(request.getParameter("createrid"));//创建人id
		String createrid2 = Util.null2String(request.getParameter("createrid2"));//创建人id
		String requestlevel = Util.null2String(request.getParameter("requestlevel"));//紧急程度







		String workcode = Util.null2String(request.getParameter("workcode"));//编号
		String requestname = "";
		requestname = Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
		if (!"".equals(SearchClause.getRequestName())) {
			requestname = SearchClause.getRequestName();
			SearchClause.setRequestName("");
		}
		requestname = requestname.trim();//标题
		String creatername = Util.null2String(request.getParameter("creatername"));//创建人名
		String ownerdeptname = Util.null2String(request.getParameter("ownerdeptname"));//创建人部门








		String ownerdepartmentid = Util.null2String(request.getParameter("ownerdepartmentid"));//创建人部门








		String creatersubcompanyname = Util.null2String(request.getParameter("creatersubcompanyname"));//创建人分部








		String creatersubcompanyid = Util.null2String(request.getParameter("creatersubcompanyid"));//创建人分部id
		String unophrmid = Util.null2String(request.getParameter("unophrmid"));//未操作者id
		String unophrmname = Util.null2String(request.getParameter("unophrmname"));//未操作者








		String docinputname = Util.null2String(request.getParameter("docinputname"));//相关文档名








		String docids = Util.null2String(request.getParameter("docids"));//相关文档id
		String crmnameinput = Util.null2String(request.getParameter("crmnameinput"));//相关客户名








		String crmids = Util.null2String(request.getParameter("crmids"));//相关客户id
		String pronameinput = Util.null2String(request.getParameter("pronameinput"));//相关项目名








		String proids = Util.null2String(request.getParameter("proids"));//相关项目id
		String hrmidsinput = Util.null2String(request.getParameter("hrmidsinput"));//人力资源
		String hrmcreaterid = Util.null2String(request.getParameter("hrmcreaterid"));//人力资源
		String requestnamed = Util.null2String(request.getParameter("requestnamed"));//快速搜索









		int date2during = Util.getIntValue(Util.null2String(request.getParameter("date2during")), 0);
		int viewType = Util.getIntValue(Util.null2String(request.getParameter("viewType")), 0);
		int isdeleted= Util.getIntValue(request.getParameter("isdeleted"),0);//流程状态








		int wfstatu = Util.getIntValue(request.getParameter("wfstatu"),0);//处理状态


		



		int archivestyle = Util.getIntValue(request.getParameter("archivestyle"),0);//归档状态








		int recievedateselect = Util.getIntValue(request.getParameter("recievedateselect"),0);//接受日期

		String branchid = "";
		String cdepartmentid = "";
		try {
			branchid = Util.null2String((String) session.getAttribute("branchid"));
		} catch (Exception e) {
			branchid = "";
		}
		int olddate2during = 0;
		BaseBean baseBean = new BaseBean();
		String date2durings = "";
		String hrmids=hrmcreaterid;
		try {
			date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
		} catch (Exception e) {
		}
		String[] date2duringTokens = Util.TokenizerString2(date2durings, ",");
		if (date2duringTokens.length > 0) {
			olddate2during = Util.getIntValue(date2duringTokens[0], 0);
		}

		String cdepartmentidspan = "";
		ArrayList cdepartmentidArr = Util.TokenizerString(cdepartmentid, ",");
		for (int i = 0; i < cdepartmentidArr.size(); i++) {
			String tempcdepartmentid = (String) cdepartmentidArr.get(i);
			if (cdepartmentidspan.equals(""))
				cdepartmentidspan += DepartmentComInfo.getDepartmentname(tempcdepartmentid);
			else
				cdepartmentidspan += "," + DepartmentComInfo.getDepartmentname(tempcdepartmentid);
		}

		String newsql = "";
		String newsqlos = "";
		//WFSearchs.jsp页面条件
		if(!viewtype.equals("")){//未读 or 反馈
			newsql += " and t2.viewtype='" + viewtype + "'";
			newsqlos += " and viewtype="+viewtype ;
		}
		if(!typeid.equals("") && !typeid.equals("0")){//类别
			newsql += " and t2.workflowtype='" + typeid + "'";
            newsqlos += " and sysid="+typeid ;
		}
		if (!workflowid.equals("") && !workflowid.equals("0")){
			if(workflowid.indexOf("-")!=-1){
                newsql += " and t1.workflowid in(" + workflowid + ")";
            }else {
                newsql += " and t1.workflowid in(" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";
            }
            newsqlos += " and workflowid="+workflowid ;
		}
			
		if (date2during > 0 && date2during < 37){
			newsql += WorkflowComInfo.getDateDuringSql(date2during);
			newsqlos += WorkflowComInfo.getDateDuringSql(date2during);
		}
		
		String dbNames = new RecordSet().getDBType();
		boolean isoracle = "oracle".equals(dbNames.toLowerCase());
		if(!requestname.equals("")){
			
			if((requestname.indexOf(" ")==-1&&requestname.indexOf("+")==-1)||(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")!=-1)){
				if(isoracle){
					newsql+=" and instr(t1.requestnamenew, '"+requestname+"') > 0 ";
					newsqlos += " and instr(requestname, '"+requestname+"') > 0 ";
				}else{
					newsql+=" and t1.requestnamenew like '%"+requestname+"%'";
					newsqlos += " and requestname like '%"+requestname+"%'";
				}
			}else if(requestname.indexOf(" ")!=-1&&requestname.indexOf("+")==-1){
				String orArray[]=Util.TokenizerString2(requestname," ");
				if(orArray.length>0){
					newsql+=" and ( ";
					newsqlos += " and ( ";
				}
				for(int i=0;i<orArray.length;i++){
					if(isoracle){
						newsql+=" and instr(t1.requestnamenew, '"+orArray[i]+"') > 0 ";
					}else{
						newsql+=" t1.requestnamenew like '%"+orArray[i]+"%'";
					}
					newsqlos += " requestname like '%"+orArray[i]+"%'";
					if(i+1<orArray.length){
						newsql+=" or ";
						newsqlos +=" or ";
					}
				}
				if(orArray.length>0){
					newsql+=" ) ";
					newsqlos += " ) ";
				}
			}else if(requestname.indexOf(" ")==-1&&requestname.indexOf("+")!=-1){
				String andArray[]=Util.TokenizerString2(requestname,"+");
				for(int i=0;i<andArray.length;i++){
					if(isoracle){
						newsql+=" and instr(t1.requestnamenew, '"+andArray[i]+"') > 0 ";
					}else{
						newsql+=" and t1.requestnamenew like '%"+andArray[i]+"%'";
					}
					newsqlos += " and requestname like '%"+andArray[i]+"%'";
				}
			}
		}

		if(!requestnamed.equals("")){
			if(isoracle){
				newsql+=" and instr(t1.requestnamenew, '"+requestnamed+"') > 0 ";
			}else{
				newsql+=" and t1.requestnamenew like '%"+requestnamed+"%'";
			}
			newsqlos += " and requestname like '%"+requestname+"%'";
		}
		
		if (!"".equals(workcode)){
			//newsql += " and t1.creatertype= '0' and t1.creater in(select id from hrmresource where workcode like '%" + workcode + "%')";
			newsql += " AND t1.requestmark LIKE '%"+workcode+"%' ";
			newsqlos += " and 1=2 ";
		}
			
		if (!requestlevel.equals("")) {
			newsql += " and t1.requestlevel=" + requestlevel;
			newsqlos += " and 1=2 ";
		}
		//创建人条件
		newsql += wfd.handleCreaterCondition("t1.creater");
		if (!createrid.equals("")) {
            newsqlos += "  and creatorid = " + createrid + "";
        }
		//创建人部门








		if(!ownerdepartmentid.equals("")){
			//newsql += " and t1.creatertype= '0' " + wfd.handleDepCondition("t1.creater");
			newsql += " and t1.creatertype= '0' " + wfd.makeDepCondition(ownerdepartmentid, "t1.creater");
			newsqlos += "  " + wfd.handleDepCondition("creatorid");
		}
		//创建人分部








		if(!creatersubcompanyid.equals("")){
			newsql += " and t1.creatertype= '0' " + wfd.handleSubComCondition("t1.creater");
			newsqlos += "  " + wfd.handleSubComCondition("creatorid");
		}
		//创建日期
		if("1".equals(fastsearch)){
			String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
			String createdateto = Util.null2String(request.getParameter("createdateto"));
			
			if (!createdatefrom.equals("")) {
				newsql += "  and t1.createdate >='" + createdatefrom + "'";
				newsqlos += "  and createdate >='" + createdatefrom + "'";
			}
			if (!createdateto.equals("")) {
				newsql += "  and t1.createdate <='" + createdateto + "'";
				newsqlos += "  and createdate <='" + createdateto + "'";
			}
		}else{
			newsql += wfd.handCreateDateCondition("t1.createdate");
			newsqlos += wfd.handCreateDateCondition("createdate");
		}
		//接受日期
		newsql += wfd.handRecieveDateCondition("t2.receivedate");
		newsqlos += wfd.handRecieveDateCondition("receivedate");
		//流程状态








		if(isdeleted==0){
			isdeleted=1;
		}else if(isdeleted==1){
			isdeleted=0;
		}
		if(isdeleted!=1){
			if (isdeleted == 0) {				
				newsql +=" and t1.workflowid in (select id from workflow_base where isvalid not in ('1', '2', '3'))";
				newsqlos += " and workflowid in (select workflowid from ofs_workflow where cancel!=0) ";
			} else if (isdeleted == 2) {	
				newsql +=" and t1.workflowid in (select id from workflow_base where isvalid<>'2')";
			}
		}else{
            newsqlos += " and workflowid in (select workflowid from ofs_workflow where cancel=0) ";
        }
		//处理状态








		//BaseBean bb = new BaseBean();
		if(wfstatu!=0){
			if(wfstatu==1){
				newsql +=" AND t2.isremark in( '0','1','5','8','9','7')";
				newsqlos += " and isremark in ('0') " ;
			}else{
				newsql +=" AND t2.isremark in('2','4')";
				newsqlos += " and isremark in ('2','4') " ;
			}
		}
		//归档处理
		if(archivestyle!=0){
			if (archivestyle == 1) {
				newsql +=" and t2.iscomplete<>1";//未归档
				newsqlos +=" and iscomplete<>1";				
			} else {
				newsql +=" and t2.iscomplete=1";//归档
				newsqlos +=" and iscomplete=1";
			}
		}
		//节点类型
		if (!nodetype.equals("")){
			newsql += " and t1.currentnodetype='" + nodetype + "'";
			 newsqlos += " and 1=5 " ;
		}
		//未操作人
		newsql +=wfd.handleUnOpCondition("t2.REQUESTID");
		if(!unophrmid.equals("")){
            newsqlos += " and requestid in (select requestid from ofs_todo_data where userid="+unophrmid+" and isremark='0' )" ;
        }
		//相关文档docinputname
		newsql +=wfd.handleDocCondition("t1.docids");
		//相关人力资源
		newsql +=wfd.handleHrmCondition("t1.hrmids");
		//相关客户
		newsql +=wfd.handleCrmCondition("t1.crmids");
		//相关项目
		newsql +=wfd.handleProsCondition("t1.prjids");
		if(!docids.equals("")||!hrmcreaterid.equals("")||!crmids.equals("")||!proids.equals("")){//相关客户等不查询
            newsqlos += " and 1=2 ";
        }

		String CurrentUser = Util.null2String((String) session.getAttribute("RequestViewResource"));
		String userID = String.valueOf(user.getUID());
		int userid=user.getUID();
		String belongtoshow = "";				
								RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
								if(RecordSet.next()){
									belongtoshow = RecordSet.getString("belongtoshow");
								}
		String userIDAll = String.valueOf(user.getUID());
		
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}

		//add by jhyun for batch submit
		String logintype = "" + user.getLogintype();
		int usertype = 0;
		if (logintype.equals("2"))
			usertype = 1;
		if (CurrentUser.equals("")) {
			CurrentUser = "" + user.getUID();
		}
		boolean superior = false; //是否为被查看者上级或者本身

	
		if (userID.equals(CurrentUser)) {
			superior = true;
		} else {
			RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND managerStr LIKE '%" + userID + "%'");

			if (RecordSet.next()) {
				superior = true;
			}
		}

		int isovertime = 0;

		//获取流程共享信息
		String currentid = "";
		
		currentid = wfShareAuthorization.getCurrentoperatorIDByUser(user);
		String sqlwhere = "";
		String sqlwhereos = "";
		//是否有共享的流程
		if("1".equals(belongtoshow)){
		if(!"".equals(currentid) && !"1".equals(fromhp)){
			sqlwhere = " where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid AND t2.islasttimes=1 ";
			sqlwhere += " and (( t2.userid in (" + userIDAll + " ) and t2.usertype=" + usertype;
		}else{
			if("1".equals(fromhp) && "1".equals(isall)){
				sqlwhere = " where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid AND t2.islasttimes=1 ";
			}else{
				sqlwhere = " where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid in (" + userIDAll + " ) and t2.usertype=" + usertype + " AND t2.islasttimes=1 ";
			}
		}
		
		if (RecordSet.getDBType().equals("oracle")) {
			 sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in (" + userIDAll + "))) ";
		} else {
			 sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater in (" + userIDAll + "))) ";
		}
		}else{
		if(!"".equals(currentid) && !"1".equals(fromhp)){
			sqlwhere = " where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid AND t2.islasttimes=1 ";
			sqlwhere += " and (( t2.userid in (" + CurrentUser + " ) and t2.usertype=" + usertype;
		}else{
			if("1".equals(fromhp) && "1".equals(isall)){
				sqlwhere = " where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid AND t2.islasttimes=1 ";
			}else{
				sqlwhere = " where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and t1.requestid = t2.requestid and t2.userid in (" + CurrentUser + " ) and t2.usertype=" + usertype + " AND t2.islasttimes=1 ";
			}
		}
		
		if (RecordSet.getDBType().equals("oracle")) {
			 sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater in (" + CurrentUser + "))) ";
		} else {
			 sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater in (" + CurrentUser + "))) ";
		}
		}
		sqlwhereos += " and userid in ("+CurrentUser+") and islasttimes=1 ";
		//是否有共享的流程
		String wfid =  Util.getSubINClause(currentid,"t2.id", "IN");
		if(!"".equals(currentid) && !"1".equals(fromhp)){
			sqlwhere += " ) or ("+wfid+")) ";
		}

		//来自于借款流程查看相关还款流程按钮的查询




		if(_isFromShowRelatedProcess){
			if("".equals(sqlwhere)){
				sqlwhere += " where ";
			}else{
				sqlwhere += " and ";
			}
			if(_borrowDetailRecordId > 0 && _borrowRequestid > 0){
				sqlwhere += " exists ( \n"+
						" select 1 \n" +
						" from FnaBorrowInfo fbi \n" +
						" where fbi.borrowDirection = -1  \n" +
						" and fbi.borrowRequestIdDtlId = "+_borrowDetailRecordId+" and fbi.borrowRequestId = "+_borrowRequestid+" \n" +
						" and fbi.requestid = t1.requestid \n"+
						" ) \n";
			}else{
				sqlwhere += " 1=2 ";
			}
		}
		
		sqlwhere += " " + newsql;
		sqlwhereos += " "  + newsqlos ;
		session.setAttribute("fromhp","");
		session.setAttribute("isall","");
		String orderby = "t2.receivedate,t2.receivetime";
		//update by fanggsh 20060711 for TD4532 begin
		boolean hasSubWorkflow = false;

		if (workflowid != null && !workflowid.equals("") && workflowid.indexOf(",") == -1) {
			RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId=" + workflowid);
			if (RecordSet.next()) {
				hasSubWorkflow = true;
			}

			RecordSet.executeSql("select id from Workflow_TriDiffWfDiffField where mainWorkflowId=" + workflowid);
			if (RecordSet.next()) {
				hasSubWorkflow = true;
			}
		}
		
		// RCMenu += "{" + SystemEnv.getHtmlLabelName(364, user.getLanguage()) + ",WFSearch.jsp?offical="+offical+"&date2during=" + olddate2during + ",_self}";
		// RCMenuHeight += RCMenuHeightStep;
		//批量提交 自定义查询

		if("customSearch".equals(isfrom)){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(17598, user.getLanguage()) + ",javascript:OnMultiSubmitNew(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		
		if(!"1".equals(fastsearch) && !"customSearch".equals(isfrom) ){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(18037, user.getLanguage()) + ",javascript:addWFShare(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		
		if(!_isFromShowRelatedProcess){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:rightMenuSearch(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/wfSearchResult_wev8.js"></script>
		<table id="topTitle" cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
					<% if(!"1".equals(fastsearch) && !"customSearch".equals(isfrom)){%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(18037, user.getLanguage())%>" class="e8_btn_top middle" onclick="addWFShare()" />
					<%} %>
					<% if("customSearch".equals(isfrom)){%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(17598, user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="OnMultiSubmitNew(this)">
					<%} %>
					<input type="text" class="searchInput" value="<%=requestname%>" name="flowTitle"/>
				<%if(!"1".equals(fastsearch)){ %>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
				<%} %>
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<%
	String actionurl ="";
if(!"customSearch".equals(isfrom)){
	actionurl = "WFCustomSearchMiddleHandler.jsp?offical="+offical+"&officalType="+officalType;
}else{
	actionurl = "WFCustomSearchMiddleHandler.jsp?offical="+offical+"&officalType="+officalType+"&isfrom="+isfrom+"&workflowid="+workflowid;
}
%>
		<form id="weaver" name="frmmain" method="post" action="<%=actionurl%>">
			<%
			if(!"customSearch".equals(isfrom)){
			%>
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_CUSTOM_SEARCH%>"/>
			<%}%>
				
			<div id="advancedSearchDiv" style="display:none;">
				<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
				    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
				    	<wea:item>
					    	 <input type="text" style='width:80%;' name="requestname" value="<%=requestname%>" />
							 <input type="hidden" name="pageId" id="pageId" value=""/>
				    	</wea:item>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></wea:item>
				    	<wea:item><input type="text" style='width:80%;' name="workcode" value='<%=workcode%>' ></wea:item>
				    	<%
						if(!"customSearch".equals(isfrom)){
						%>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
				    	<% String wfbytypeBrowserURL = "/workflow/workflow/WFTypeBrowserContenter.jsp?showos=1";%>
				    	<wea:item>
					    	 <span>
					    		<brow:browser viewType="0" name="typeid"
								browserValue='<%=typeid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp?showos=1"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser&showos=1"
								browserDialogWidth="600px"
								browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(typeid)%>'></brow:browser>
					    	</span> 
				    	</wea:item>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>
				    	<wea:item>
				    		<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid%>' onPropertyChange="loadCustomSearch($('#workflowid').val())" browserOnClick="" browserUrl='<%=wfbytypeBrowserURL %>' hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('workflowBrowser')" width="80%" browserSpanValue='<%=request.getParameter("workflowid_name")%>'> </brow:browser> 
					    	 <input type="hidden" id="workflowid_name" name="workflowid_name" value="<%=request.getParameter("workflowid_name")%>"/>
				    	</wea:item>
				    	<%}%>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
				    	<wea:item>
				    		<select class="inputstyle" name="requestlevel" size=1 notBeauty=true>
								<option value="" ></option>
								<option value="0" ><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
								<option value="1" ><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
								<option value="2" ><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>
							</select>
				    	</wea:item>
				    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
				    	<wea:item >
					        <span style='float:left'>
								<select class=inputstyle name=creatertype  style='height:25px;' onchange="changeType(this.value,'createridse1span','createridse2span');" notBeauty=true>
									<%if (!user.getLogintype().equals("2")) {%>
										<option value="0"><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%></option>
									<%}%>
										<option value="1"><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></option>
								</select>								
							</span>
							<span id="createridse1span" <%if ("1".equals(creatertype)) {%>style="display:none;"<%}%>>
								<brow:browser viewType="0" name="createrid" browserValue='<%=createrid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=ResourceComInfo.getResourcename(createrid)%>'> 
							   </brow:browser> 
							</span>
							<span id="createridse2span" <%if (!"1".equals(creatertype)) {%>style="display:none;"<%}%>>
								<brow:browser viewType="0" name="createrid2" browserValue='<%=createrid2%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="135px;float:left" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=7"  browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname(createrid2)%>'> 
								</brow:browser>
							</span>
				    	</wea:item>
				    	
				    </wea:group>
				     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  >
				    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
				    	<wea:item>
				    		 <brow:browser viewType="0" name="ownerdepartmentid" browserValue='<%=ownerdepartmentid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" nameSplitFlag="," browserSpanValue='<%=Util.null2String(request.getParameter("ownerdepartmentid_name")).replace(" ", ",") %>'> </brow:browser>
				    		 <input type="hidden" id="ownerdepartmentid_name" name="ownerdepartmentid_name" value="<%=request.getParameter("ownerdepartmentid_name")%>"/>
				    	</wea:item>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
				    	<wea:item>
				    		<brow:browser viewType="0" name="creatersubcompanyid" browserValue='<%=creatersubcompanyid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=request.getParameter("creatersubcompanyid_name")%>'> </brow:browser> 
				    		<input type="hidden" id="creatersubcompanyid_name" name="creatersubcompanyid_name" value="<%=request.getParameter("creatersubcompanyid_name")%>"/>
				    	</wea:item>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
				    	<wea:item  attributes="{\"colspan\":\"3\"}">
				    		<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
								<input class=wuiDateSel type="hidden" name="createdatefrom" value="<%=Util.null2String(request.getParameter("createdatefrom"))%>">
								<input class=wuiDateSel type="hidden" name="createdateto" value="<%=Util.null2String(request.getParameter("createdateto"))%>">
							</span>
				    	</wea:item>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></wea:item>
				    	<wea:item  attributes="{\"colspan\":\"3\"}">
				    		<span class="wuiDateSpan" selectId="recievedateselect" selectValue="">
								<input class=wuiDateSel type="hidden" name="recievedatefrom" value="<%=Util.null2String(request.getParameter("recievedatefrom"))%>">
								<input class=wuiDateSel type="hidden" name="recievedateto" value="<%=Util.null2String(request.getParameter("recievedateto"))%>">
							</span>
				    	</wea:item>
				    	<wea:item><%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
				    	<wea:item>
				            <select class=inputstyle size=1 name="wfstatu" notBeauty=true>
								<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="1" ><%=SystemEnv.getHtmlLabelName(16658, user.getLanguage())%></option>
								<option value="2" ><%=SystemEnv.getHtmlLabelName(24627, user.getLanguage())%></option>
							</select>
				    	</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
						<wea:item>
					        <select class=inputstyle size=1 name="archivestyle" notBeauty=true>
								<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
								<option value="1" ><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
								<option value="2" ><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
						<wea:item>
					        <select class=inputstyle  size=1 name=isdeleted notBeauty=true>
								<option value="0" ><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
								<option value="1" ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
								<option value="2" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						    </select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
						<wea:item>
					        <select class=inputstyle size=1 name=nodetype notBeauty=true>
								<option value="">&nbsp;</option>
								<option value="0" ><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></option>
								<option value="1" ><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></option>
								<option value="2" ><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%></option>
								<option value="3" ><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
						<wea:item>
					        <brow:browser viewType="0" name="unophrmid" browserValue='<%=unophrmid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=request.getParameter("unophrmid_name")%>'> </brow:browser>
					        <input type="hidden" id="unophrmid_name" name="unophrmid_name" value="<%=request.getParameter("unophrmid_name")%>"/>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
						<wea:item>
				          	<brow:browser viewType="0" name="docids" browserValue='<%=docids%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('9')" width="80%" browserSpanValue='<%=request.getParameter("docids_name")%>'> </brow:browser>
				          	<input type="hidden" id="docids_name" name="docids_name" value="<%=request.getParameter("docids_name")%>"/>
						</wea:item>
						<%if(!offical.equals("1")){ %>
							<wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
							<wea:item>
						         <brow:browser viewType="0" name="hrmcreaterid" browserValue='<%=hrmcreaterid%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=request.getParameter("hrmcreaterid_name")%>'> </brow:browser>
						         <input type="hidden" id="hrmcreaterid_name" name="hrmcreaterid_name" value="<%=request.getParameter("hrmcreaterid_name")%>"/>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
							<wea:item>
						         <brow:browser viewType="0" name="crmids" browserValue='<%=crmids%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('18')" width="80%" browserSpanValue='<%=request.getParameter("crmids_name")%>'> </brow:browser>
						         <input type="hidden" id="crmids_name" name="crmids_name" value="<%=request.getParameter("crmids_name")%>"/>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
							<wea:item>
					        	<brow:browser viewType="0" name="proids" browserValue='<%=proids%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('135')" width="80%" browserSpanValue='<%=request.getParameter("proids_name")%>'> </brow:browser>
					        	<input type="hidden" id="proids_name" name="proids_name" value="<%=request.getParameter("proids_name")%>"/>
							</wea:item>
						<%} %>
				    </wea:group>

				    <wea:group context="">
				    	<wea:item type="toolbar">
				    	<%if(!_isFromShowRelatedProcess){ %>
				    		<input class="e8_btn_submit" type="submit" name="submit_1" onClick="doSearch()" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>"/>
				    		<span class="e8_sep_line">|</span>
				    	<%} %>
							<input class="e8_btn_cancel" type="button" name="reset" onclick="onReset()" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage()) %>"/>
							<span class="e8_sep_line">|</span>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				    	</wea:item>
				    </wea:group>

				</wea:layout>
				<div id="customQueryDiv"></div>
			</div>
			
		</form>
		<div>
			<%
				String tableString = "";

				String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid,'' as currentnodename,t2.receivedate,t2.receivetime,t2.viewtype,t2.isremark,t2.userid,t2.nodeid,t2.agentorbyagentid,t2.agenttype,t2.isprocessed, 0 as systype,t2.workflowtype";
				String fromSql = " from workflow_requestbase t1,workflow_currentoperator t2 ";//xxxxx
				String sqlWhere = sqlwhere;
				if (sqlWhere.indexOf("in (select id from workflow_base where isvalid") < 0) {
					sqlWhere += " and t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3') )";
				}
				//String para2 = "column:requestid+column:workflowid+column:viewtype+" + isovertime + "+" + user.getLanguage() + "+column:nodeid+column:isremark+" + userID
						//+ "+column:agentorbyagentid+column:agenttype+column:isprocessed";
				String para2 = "column:requestid+column:workflowid+column:viewtype+" + isovertime + "+" + user.getLanguage() + "+column:nodeid+column:isremark+" + user.getUID() +			"+column:agentorbyagentid+column:agenttype+column:isprocessed+"+ currentid +"+column:userid+column:workflowtype+column:creater";


				String para4 = user.getLanguage() + "+" + user.getUID()+ "+column:userid";
				if (!docids.equals("")) {
					fromSql = fromSql + ",workflow_form t4 ";
					sqlWhere = sqlWhere + " and t1.requestid=t4.requestid ";
				}
				if("1".equals(belongtoshow)){
								if (!superior) {
									sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid in ("
											+ userIDAll + ") and workFlowCurrentOperator.usertype = " + usertype + ") ";
								}
				}else{
					if (!superior) {
									sqlWhere += " AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid in ("
											+ user.getUID() + ") and workFlowCurrentOperator.usertype = " + usertype + ") ";
								}
				
				}

				if (!branchid.equals("")) {
					sqlWhere += " AND t1.creater in (select id from hrmresource where subcompanyid1=" + branchid + ")  ";
				}
				
				if(offical.equals("1")){//发文/收文/签报
					if(officalType==1){
						sqlWhere+=(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
					}else if(officalType==2){
						sqlWhere+=(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
					}
				}

				//判断session中是否存在附加条件








				String __whereClause = SearchClause.getWhereClause();
				if(__whereClause != null && !__whereClause.trim().equals("")){
					if(__whereClause.trim().startsWith("and")){
						sqlWhere += __whereClause;
						//bb.writeLog("1148 __whereClause="+__whereClause);
					}else{
						if(LoanRepaymentAnalysisInnerDetaile){
							__whereClause = " (t1.deleted=0 or t1.deleted is null)   and (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark =-2))  and t2.islasttimes=1 ";
						}
						sqlWhere += (" and " + __whereClause);
						//bb.writeLog("1154 __whereClause="+__whereClause);
					}
				}
				String __whereClauseOs = SearchClause.getWhereclauseOs();
				if(__whereClauseOs != null && !__whereClauseOs.trim().equals("")){
					if(__whereClauseOs.trim().startsWith("and")){
						sqlwhereos += __whereClauseOs;
					}else{
						sqlwhereos += (" and " + __whereClauseOs);
					}
				}
				//判断session中是否存在附加排序








				String __orderClause = SearchClause.getOrderClause();
				if(__orderClause != null && !__orderClause.trim().equals("")){
					orderby =  __orderClause;
				}

				//判断是否是从WFCustomSearchMiddleHandler转发过来的请求








				String[] _fieldLabelArray = null;
				String[] _fieldNameArray = null;
				List<String> fieldids = null;
				List<String> fieldhtmltypes = null;
				List<String> fieldtypes = null;
				List<String> fielddbtypes = null;
				String isNeed = (String) request.getAttribute("CustomSearch_IsNeed");

				if(isNeed != null){
					String _tableName = (String)request.getAttribute("CustomSearch_TableName");
					String _tableNameAlias = (String)request.getAttribute("CustomSearch_TableNameAlias");
					fieldids = (List<String>) request.getAttribute("CUSTOMSEARCH_FIELDIDS");
					fieldhtmltypes = (List<String>) request.getAttribute("CUSTOMSEARCH_FIELDHTMLTYPES");
					fieldtypes = (List<String>) request.getAttribute("CUSTOMSEARCH_FIELDTYPES");
					fielddbtypes = (List<String>) request.getAttribute("CUSTOMSEARCH_FIELDDBTYPES");
					if(_tableName != null && !_tableName.trim().equals("")){
						fromSql += ("," + _tableName + " " +_tableNameAlias + " ");
					}

					String _fieldNameList = (String)request.getAttribute("CustomSearch_FieldNameList");
					if(_fieldNameList != null && !_fieldNameList.trim().isEmpty()){
						backfields += ("," + _fieldNameList);
						_fieldNameArray = _fieldNameList.split(",");
					} else {
						_fieldNameArray = new String[]{};
					}

					String _requestIdList = (String)request.getAttribute("CustomSearch_RequestIdList");
					if(_requestIdList != null && !_requestIdList.trim().equals("")){
						sqlWhere += (" and t1.requestid = " + _tableNameAlias + ".requestid");
						sqlWhere += (" and t1.requestId in " + _requestIdList);
					}

					String _fieldLabelList = (String)request.getAttribute("CustomSearch_FieldLabelList");
					//System.out.println("_fieldNameList = "+_fieldNameList);
					//System.out.println("_fieldLabelList = "+_fieldLabelList);
					if (_fieldLabelList != null && !_fieldLabelList.trim().isEmpty()) {						
						_fieldLabelArray = _fieldLabelList.split(",");
					} else {
						_fieldLabelArray = new String[]{};
					}
				}
				if(isNeed != null || "customSearch".equals(isfrom)){
					isopenos = false ;
				}
				//add by bpf on 2013-11-14
				//String countSql="select count(1) as wfCount "+fromSql+sqlWhere ;
				//System.err.println("debug-sql:select " + backfields + fromSql + sqlWhere);
				//RecordSet.executeSql(countSql);
				//String wfCount = "0";
		        //while(RecordSet.next()){
		        	//wfCount = RecordSet.getString("wfCount");
		        //}
		        //System.out.println("fromSql + sqlWhere = "+fromSql+sqlWhere);
		        //System.out.println("20150810sqlWhere = "+sqlWhere);
		        String tabletype__ = "checkbox";
		        if("1".equals(fastsearch)){
		        	tabletype__ = "none";
		        }
		        //String _sql = "select "+backfields+" "+fromSql+" "+sqlWhere+" order by "+orderby;
		    	//out.println(_sql);
		        //out.println(sqlWhere);
				tableString = " <table instanceid=\""+PageIdConst.getWFPageId(pageIdStr)+"\" tabletype=\""+tabletype__+"\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.WF_CUSTOM_SEARCH,user.getUID()) + "\" >"; 
				if("customSearch".equals(isfrom)){
				    tableString+= " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:workflowid+column:isremark+column:requestid+column:nodeid+column:userid\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox\"  />";
				}else{
				    tableString+= " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:workflowid+column:requestid+column:userid+"+userID+"\" showmethod=\"weaver.workflow.request.WFShareTransMethod.getWFSearchCheckbox\"  />";
				}
				
				if(isopenos){//开启统一待办
                    String backfields0 = " requestid, createdate, createtime,creater, creatertype, workflowid, requestname, status,requestlevel,currentnodeid,currentnodename,receivedate,receivetime,viewtype,isremark,userid,nodeid,agentorbyagentid,agenttype,isprocessed, systype,workflowtype";
                    String backfieldsos = " requestid, createdate, createtime,creatorid as creater, 0 as creatertype, workflowid, requestname, '' as status, -1 as requestlevel, -1 as currentnodeid, nodename as currentnodename,receivedate,receivetime,viewtype,isremark,userid,0 as nodeid, -1 as agentorbyagentid,'0' as agenttype,'0' as isprocessed,1 as systype,sysid as workflowtype";
                    fromSql = " from (select "+backfields0+" from (select "+backfields+" "+fromSql+""+sqlWhere+" union (select "+backfieldsos+" from ofs_todo_data where 1=1 "+sqlwhereos+") ) t1 ) t2 ";
                    orderby = " receivedate,receivetime ";
                    tableString+= "	   <sql backfields=\"" + backfields0 + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql)	+ "\" sqlwhere=\"\"  sqlorderby=\"" + orderby + "\"  sqlprimarykey=\"t2.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />" ;
                }else {
	                
                    tableString += "	   <sql backfields=\"" + backfields + "\" sqlform=\"" + fromSql + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\"  sqlorderby=\"" + orderby + "\"  sqlprimarykey=\"t2.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />";
                }
                tableString+= "			<head>";
                if(isopenos){
                    String showname = requestutil.getOfsSetting().getShowsysname();
                    if(!showname.equals("0")){
                        tableString += "<col width=\"8%\" text=\"" + SystemEnv.getHtmlLabelName(22677, user.getLanguage())
                            + "\" column=\"workflowtype\"  orderkey=\"workflowtype\" transmethod=\"weaver.workflow.request.todo.RequestUtil.getSysname\" otherpara=\""+showname+"\" />";
                    }
                }
				
				tableString += "<col width=\"10%\" text=\""+ SystemEnv.getHtmlLabelName(722, user.getLanguage())
							+ "\" column=\"createdate\" orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
				tableString += "<col width=\"8%\" text=\"" + SystemEnv.getHtmlLabelName(882, user.getLanguage())
							+ "\" column=\"creater\" orderkey=\"creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
				tableString += "<col width=\"10%\" text=\"" + SystemEnv.getHtmlLabelName(259, user.getLanguage())
							+ "\" column=\"workflowid\" orderkey=\"t2.workflowid\" otherpara=\"column:workflowtype\" transmethod=\"weaver.workflow.request.todo.RequestUtil.getWorkflowName\" />";
				tableString += "<col width=\"8%\" text=\"" + SystemEnv.getHtmlLabelName(15534, user.getLanguage())
							+ "\" column=\"requestlevel\"  orderkey=\"requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""
							+ user.getLanguage() + "\"/>";
						
					if(!userIDAll.equals(String.valueOf(user.getUID())) && "1".equals(belongtoshow)){
												 
				tableString += "<col width=\"20%\" text=\""
							+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
							+ "\" column=\"requestname\" orderkey=\"requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfShareLinkWithTitle2\"  otherpara=\""
							+ para2 + "\" pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfShareLinkWithTitle\"/>";
							
							}else{
				tableString += "<col width=\"20%\" text=\""
							+ SystemEnv.getHtmlLabelName(1334, user.getLanguage())
							+ "\" column=\"requestname\" orderkey=\"requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfShareLinkWithTitle\"  otherpara=\""
							+ para2 + "\" pkey=\"requestname+weaver.general.WorkFlowTransMethod.getWfShareLinkWithTitle\"/>";			
							}
				tableString += "<col width=\"8%\" text=\"" +  SystemEnv.getHtmlLabelName(18564, user.getLanguage())
							+ "\" column=\"currentnodeid\" otherpara=\"column:requestid+column:currentnodename\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\" />";
				tableString += "<col width=\"10%\" text=\""
							+ SystemEnv.getHtmlLabelName(17994, user.getLanguage())
							+ "\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
				tableString += "<col width=\"10%\" text=\"" + SystemEnv.getHtmlLabelName(1335, user.getLanguage()) + "\" column=\"status\" orderkey=\"status\" />";
				if(offical.equals("1")){
					tableString += "<col width=\"10%\" text=\""
							+ SystemEnv.getHtmlLabelName(1265, user.getLanguage())
							+ "\" column=\"requestid\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getContentNewLinkWithTitle\"  otherpara=\""
							+ para2 + "\"  />";
				}
				tableString += "<col width=\"10%\" text=\"" + SystemEnv.getHtmlLabelName(16354, user.getLanguage()) + "\" column=\"requestid\"  otherpara=\"" + para4
							+ "\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
				tableString += "<col width=\"10%\" display=\""+hasSubWorkflow+"\" text=\""
							+ SystemEnv.getHtmlLabelName(19363, user.getLanguage())
							+ "\" column=\"requestid\" orderkey=\"t2.requestid\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_self\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFLink\"  otherpara=\""
							+ user.getLanguage() + "\"/>";

				/*自定义查询定义的需要展示的列*/
				if(isNeed != null && "customSearch".equals(isfrom)){
					for(int i = 0; i < _fieldNameArray.length; i++){
						String _fieldName = _fieldNameArray[i];
						String _fieldLabel = _fieldLabelArray[i];
						String _otherPara = fieldids.get(i) + "+" + fieldhtmltypes.get(i) + "+" + fieldtypes.get(i) + "+" + fielddbtypes.get(i) + "+" + user.getLanguage();
						int indexOfName = _fieldName.indexOf(".");
						if (indexOfName >= 0) {
							//column不支持表名加列名形式
							_fieldName = _fieldName.substring(indexOfName + 1);
						}
						//column不支持AS形式
						if(_fieldName.indexOf(" as ") >= 0){
						    _fieldName = _fieldName.substring(_fieldName.indexOf(" as ") + 4);
						}
                        if(_fieldName.indexOf(" AS ") >= 0){
                            _fieldName = _fieldName.substring(_fieldName.indexOf(" AS ") + 4);
                        }
						tableString += "<col width='15%' name='"+_fieldName+"' text='"+_fieldLabel+"' column='"+_fieldName+"' transmethod=\"weaver.workflow.search.WorkflowSearchUtil.getFieldValueShowStringFromTable\" otherpara=\""+_otherPara+"\" />";
					}
					
				}
				
				tableString += "</head>" + "</table>";
			%>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
		</div>
		
	</body>
	<% if(isNeed != null && "customSearch".equals(isfrom) && _fieldNameArray.length >0){%>
		<style type="text/css">
			#_xTable table.ListStyle{
				table-layout:auto!important;
			}
			#_xTable div.table{
				overflow:auto;
			}
			body{
				overflow-y:scroll;
				overflow-x:hidden;
			}
		</style>
		<script type="text/javascript">
			var table_01 = jQuery("#_xTable div.table");
			table_01.width(jQuery(window).width());
			function afterDoWhenLoaded(){
				if(jQuery.browser.msie){
					table_01.height(table_01.children("table.ListStyle").outerHeight()+20);		
				}
				
				parent.window.__optkeys = "";
				var curPrimarykeys = _table.primarykeylist;
				if (prePageNumber == _table.nowPage) {
					if (!!prePrimarykeys && prePrimarykeys.length > 0 && !!curPrimarykeys && curPrimarykeys.length > 0) {
						var optkeys = "";	
						for (var _i=0; _i<prePrimarykeys.length; _i++) {
							if (curPrimarykeys.indexOf(prePrimarykeys[_i]) == -1) {
								optkeys += "," + prePrimarykeys[_i];
							}
						}
						if (optkeys.length > 1) {
							optkeys = optkeys.substr(1);
							parent.window.__optkeys = optkeys;
						}
					}
				} else {
					prePageNumber = _table.nowPage;
				}
				prePrimarykeys = curPrimarykeys;
				if (!!!p) return;
			}
		</script>
	<%} %>
	<script type="text/javascript">
			function rightMenuSearch(){
				if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
					doSearch();
				}else{
					try{
						jQuery("span#searchblockspan",parent.document).find("img:first").click();
					}catch(e){
						doSearch();
					}
				}
			}
	
			function changeType(type,span1,span2){
				if(type=="1"){
					jQuery("#"+span1).css("display","none");
					jQuery("#"+span2).css("display","");		
				}else{
					jQuery("#"+span2).css("display","none");
					jQuery("#"+span1).css("display","");
				}
			}
			var diag_vote;
			function addWFShare(){
				var ids="";
				
				$("input[name='chkInTableTag']").each(function(){
					if($(this).attr("checked"))			
						ids = ids +$(this).attr("checkboxId")+",";
				});
				if(ids=="") {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84560,user.getLanguage())%>") ;
				}else{
					if(window.top.Dialog){
						diag_vote = new window.top.Dialog();
					} else {
						diag_vote = new Dialog();
					}
					diag_vote.currentWindow = window;
					diag_vote.Width = 850;
					diag_vote.Height = 550;
					diag_vote.Modal = true;
					diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(18037, user.getLanguage())%>";
					diag_vote.URL = "/workflow/request/AddWorkflowBatchShared.jsp?ids="+ids;
					diag_vote.show();
				}
			}
            
			function submitData()
			{
				if (check_form(frmmain,''))
					document.frmmain.submit();
			}

			function submitClear()
			{
				btnclear_onclick();
			}
			function enablemenuall()
			{
				for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
						{
						window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
				}
				//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
			}
			function changelevel(obj,tmpindex){
			    if(obj.value!=""){
			 		document.frmmain.check_con[tmpindex*1].checked = true;
			    }else{
			        document.frmmain.check_con[tmpindex*1].checked = false;
			    }
			}
			function changelevel1(obj1,obj,tmpindex){
			    if(obj.value!=""||obj1.value!=""){
			 		document.frmmain.check_con[tmpindex*1].checked = true;
			    }else{
			        document.frmmain.check_con[tmpindex*1].checked = false;
			    }
			}
			function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex){
				var oncleaingFun = function(){
					  $(spanname).innerHTML = '';
					  $(inputname).value = '';
			          if($(inputname).value==""&&$(inputname1).value==""){
			              document.frmmain.check_con[tmpindex*1].checked = false;
			          }
					}
					var language=readCookie("languageidweaver");
					if(language==8)
						languageStr ="en";
					else if(language==9)
						languageStr ="zh-tw";
					else
						languageStr ="zh-cn";
					if(window.console){
					   //console.log("language "+language+" languageStr="+languageStr);
					}
					WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;document.frmmain.check_con[tmpindex*1].checked = true;},oncleared:oncleaingFun});
			}
			function onSearchWFQTTime(spanname,inputname,inputname1,tmpindex){
			    var dads  = document.all.meizzDateLayer2.style;
			    setLastSelectTime(inputname);
				var th = spanname;
				var ttop  = spanname.offsetTop;
				var thei  = spanname.clientHeight;
				var tleft = spanname.offsetLeft;
				var ttyp  = spanname.type;
				while (spanname = spanname.offsetParent){
					ttop += spanname.offsetTop;
					tleft += spanname.offsetLeft;
				}
				dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
				dads.left = tleft;
				outObject = th;
				outValue = inputname;
				outButton = (arguments.length == 1) ? null : th;
				dads.zIndex = jQuery('#advancedSearchOuterDiv').css('z-index')+1;
				dads.display = '';
				bShow = true;
			    CustomQuery=1;
			    outValue1 = inputname1;
			    outValue2=tmpindex;
			}
			function uescape(url){
			    return escape(url);
			}

			function disModalDialog(url, spanobj, inputobj, need, curl) {
				var id = window.showModalDialog(url, "",
						"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
				if (id != null) {
					if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
						if (curl != undefined && curl != null && curl != "") {
							spanobj.innerHTML = "<A href='" + curl
									+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
									+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
						} else {
							spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
						}
						inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
					} else {
						spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
						inputobj.value = "";
					}
				}
			}

			function onShowBrowser(id,url,tmpindex) {
				var url = url + "?selectedids=" + $G("con" + id + "_value").value;
				disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
				$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;

				if ($G("con" + id + "_value").value == ""){
				    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
				} else {
				    document.frmmain.check_con[tmpindex*1].checked = true
				    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
				}
			}

			function onShowBrowser1(id,url,type1) {
				//var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
				if (type1 == 1) {
					id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
					$G("con" + id + "_valuespan").innerHTML = id1;
					$G("con" + id + "_value").value=id1
				} else if (type1 == 1) {
					id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
					$G("con"+id+"_value1span").innerHTML = id1;
					$G("con"+id+"_value1").value=id1;
				}
			}

			function onShowBrowser2(id, url, type1, tmpindex) {
				var tmpids = "";
				var id1 = null;
				if (type1 == 8) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?projectids=" + tmpids);
				} else if (type1 == 9) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?documentids=" + tmpids);
				} else if (type1 == 1) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
				} else if (type1 == 4) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?selectedids=" + tmpids
							+ "&resourceids=" + tmpids);
				} else if (type1 == 16) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
				} else if (type1 == 7) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
				} else if (type1 == 142) {
					tmpids = $G("con" + id + "_value").value;
					id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
				}
				//id1 = window.showModalDialog(url)
				if (id1 != null) {
					resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
						resourceids = resourceids.replace(',','');
						resourcename = resourcename.replace(',','');

						$G("con" + id + "_valuespan").innerHTML = resourcename;
						jQuery("input[name=con" + id + "_value]").val(resourceids);
						jQuery("input[name=con" + id + "_name]").val(resourcename);
					} else {
						$G("con" + id + "_valuespan").innerHTML = "";
						$G("con" + id + "_value").value = "";
						$G("con" + id + "_name").value = "";
					}
				}
				if ($G("con" + id + "_value").value == "") {

					document.getElementsByName("check_con")[tmpindex * 1].checked = false;
				} else {
					document.getElementsByName("check_con")[tmpindex * 1].checked = true;
				}
			}

			function onShowWorkFlowSerach(inputname, spanname) {

				retValue = window
						.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put(" where isvalid='1' ")%>");
				temp = $G(inputname).value;
				if(retValue != null) {
					if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
						$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
						$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
						
						if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
							$G("frmmain").action = "WFCustomSearchBySimple.jsp";
							$G("frmmain").submit();
							enablemenuall();
						}
					} else {
						$G(inputname).value = "";
						$G(spanname).innerHTML = "";
						$G("frmmain").action = "WFSearch.jsp";
						$G("frmmain").submit();

					}
				}
			}

			function disModalDialogRtnM(url, inputname, spanname) {
				var id = window.showModalDialog(url);
				if (id != null) {
					if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
						var ids = wuiUtil.getJsonValueByIndex(id, 0);
						var names = wuiUtil.getJsonValueByIndex(id, 1);
						
						if (ids.indexOf(",") == 0) {
							ids = ids.substr(1);
							names = names.substr(1);
						}
						$G(inputname).value = ids;
						var sHtml = "";
						
						var ridArray = ids.split(",");
						var rNameArray = names.split(",");
						
						for ( var i = 0; i < ridArray.length; i++) {
							var curid = ridArray[i];
							var curname = rNameArray[i];
							if (i != ridArray.length - 1) sHtml += curname + "，"; 
							else sHtml += curname;
						}
						
						$G(spanname).innerHTML = sHtml;
					} else {
						$G(inputname).value = "";
						$G(spanname).innerHTML = "";
					}
				}
			}

			function getajaxurl(typeId){
				var url = "";
				if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
				   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
					url = "/data.jsp?type=" + typeId;			
				} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
					url = "/data.jsp";
				} else {
					url = "/data.jsp?showos=1&type=" + typeId;
				}
				url = "/data.jsp?showos=1&type=" + typeId;	
				//alert(typeId + "," + url);
			    return url;
			}

			function showallreceived(requestid,returntdid){
			    jQuery.post(
			    	'WorkflowUnoperatorPersons.jsp', 
			    	{
			    		'requestid' : requestid,
			    		'returntdid' : returntdid
			    	}, 
			    	function(data, textStatus, xhr) {
			      		 $GetEle(returntdid).innerHTML = data;
			             $GetEle(returntdid).parentElement.title = data.replace(/[\r\n]/gm, "");
			    	}
			    );
			}

			function setSelectBoxValue(selector, value) {
				if (value == null) {
					value = jQuery(selector).find('option').first().val();
				}
				if(jQuery(selector).attr("id") == "cutomQuerySelect"){
					return;
				}
				jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
			}

			function cleanBrowserValue(name) {
				_writeBackData(name, 1, {id:'',name:''});
			}

			function onReset() {
				//browser
				jQuery('#weaver .e8_os input[type="hidden"]').each(function() {
					cleanBrowserValue(jQuery(this).attr('name'));
				});
				//input
				jQuery('#weaver input:text').val('');
				//select
				jQuery('#weaver select').each(function() {
					setSelectBoxValue(this);
				});
				<%
				if("customSearch".equals(isfrom)){
				%>				
				loadCustomSearchForReset("<%=workflowid%>","<%=customid%>")
				<%}else{%>
				loadCustomSearchForReset(null,null)
				<%}%>
			}
			
			function onResetForCustom() {
				//browser
				jQuery('#weaver .e8_os input[type="hidden"]').each(function() {
					cleanBrowserValueForCustom(jQuery(this).attr('name'));
				});
				//input
				jQuery('#weaver input:text').val('');
				//select
				jQuery('#weaver select').each(function() {
					setSelectBoxValue(this);
				});
			}
			
			function cleanBrowserValueForCustom(name) {
				if(name=="workflowid"){
					var wfid = "<%=workflowid%>";
					var wfname = "<%=WorkflowComInfo.getWorkflowname(workflowid)%>";
					_writeBackData(name, 1, {id:wfid,name:wfname},{hasInput:true,isSingle:true});
				}else{
					_writeBackData(name, 1, {id:'',name:''});
				}
			}
			
			function getFlowWindowUrl(){
				return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=<%=typeid%>";
			}
			
			function loadCustomSearchForReset(workFlowId, cutomQueryId){
				if(!workFlowId && !cutomQueryId){
					jQuery('#customQueryDiv').html('');
					return;
				}

				jQuery.post(
					'/workflow/search/WFCustomSearchGenerate.jsp',
					{
						'issimple' : true,
						'workflowid' : workFlowId,
						'customid' : cutomQueryId
					},
					function(data){
						jQuery('#customQueryDiv').html(data);

						jQuery('#customQueryDiv').find('select').each(function(i,v){
							beautySelect(jQuery(v));
						});

						jQuery('#cutomQuerySelect').change(function(e){
							loadCustomSearchForReset(null, jQuery(this).val());
						});

						jQuery('#cutomQuerySelect').click(function(e){
							if (e && e.stopPropagation)  
				            	e.stopPropagation()  
				       		else 
				            	window.event.cancelBubble=true 	
						});
					}
				);
			}
			
			function OnMultiSubmitNew(obj){
				var _reqIds = _xtable_CheckedCheckboxId();
			    if(_reqIds!=""){
					return OnMultiSubmitNew1(obj);
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			    }
			}
			
				
			function __displayloaddingblock() {
				try {
					var pTop= parent.document.body.offsetHeight/2+parent.document.body.scrollTop - 50 + jQuery(".e8_boxhead", parent.document).height()/2 ;
	     			var pLeft= parent.document.body.offsetWidth/2 - (65);
	     			
					//var __top = (jQuery(document.body).height())/2 - 40;
					//var __left = (jQuery(document.body).width() - parseInt(157))/2
					jQuery("#submitloaddingdiv", parent.document).css({"top":pTop, "left":pLeft, "display":"inline-block;"});
					jQuery("#submitloaddingdiv", parent.document).show();
					jQuery("#submitloaddingdiv_out", parent.document).show();
				} catch (e) {}
			}
			function OnMultiSubmitNew1(obj){
		
				<%
				int multisubmitnotinputsign = 0;
				RecordSet.executeSql("select multisubmitnotinputsign from workflow_RequestUserDefault where userId = "+ user.getUID());
				if(RecordSet.next()){
					multisubmitnotinputsign = Util.getIntValue(Util.null2String(RecordSet.getString("multisubmitnotinputsign")), 0);
				}
				if (multisubmitnotinputsign == 0) {
				%>
			
			    if(_xtable_CheckedCheckboxId()!=""){
					//$GetEle("multiSubIds").value = _xtable_CheckedCheckboxId();
				    //$GetEle("frmmain").submit();
					//obj.disabled=true;
					//批量提交签字意见
					var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					var url = "/workflow/search/WFSuperviseSignature.jsp?fromtype=1";
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(26039,user.getLanguage())%>";
					dialog.Width = 450;
					dialog.Height = 227;
					dialog.Drag = true;
					dialog.URL = url;
					dialog.callbackfun = function (paramobj, remark) {
						OnMultiSubmitNew2(obj, remark);
					}
					dialog.show();
				}else{
			        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			    }
			    <%} else {%>
			    	OnMultiSubmitNew2(obj);
			    <%}%>
			}
			
			function OnMultiSubmitNew2(obj, remark){
			    if(_xtable_CheckedCheckboxId()!=""){
					//$GetEle("multiSubIds").value = _xtable_CheckedCheckboxId();
				    //$GetEle("frmmain").submit();
					//obj.disabled=true;
					__displayloaddingblock();
					
					<%
						String wftype=Util.null2String(request.getParameter("wftype"));
						int flowAll=Util.getIntValue(Util.null2String(request.getParameter("flowAll")), 0);
						int flowNew=Util.getIntValue(Util.null2String(request.getParameter("flowNew")), 0);
						workflowid = Util.null2String(request.getParameter("workflowid"));
					%>
					var multsuburl = "/workflow/request/RequestListOperation.jsp?multiSubIds=" + _xtable_CheckedCheckboxId() + "&workflowid=<%=workflowid%>&method=all&wftype=<%=wftype%>&flowAll=<%=flowAll%>&flowNew=<%=flowNew%>&viewcondition=0&pagefromtype=1";
					
					jQuery.ajax({
						type: "post",
						cache: false,
						url: multsuburl,
						data:{'remark' : remark},
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(){
						},
					    error:function (XMLHttpRequest, textStatus, errorThrown) {
					    	__hidloaddingblock();
					    } , 
					    success : function (data, textStatus) {
					    	_xtable_CleanCheckedCheckbox();
					    	__hidloaddingblock();
					    	_table.reLoad();
					    	
					    }
					});
				}else{
			        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			    }
			}
			
			
			function __hidloaddingblock() {
				try {
					jQuery("#submitloaddingdiv", parent.document).hide();
					jQuery("#submitloaddingdiv_out", parent.document).hide();
				} catch (e) {}
			}
			
	</script>
</html>
