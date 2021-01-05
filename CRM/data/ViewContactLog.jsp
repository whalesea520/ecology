
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.WorkPlanShareUtil"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CommonTransUtil" class="weaver.task.CommonTransUtil" scope="page" />
<%@ include file="/CRM/data/uploader.jsp" %>
<%

boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

String from=Util.null2String(request.getParameter("from"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	String contacterid = Util.null2String(request.getParameter("contacterid"));
	String firstname = "";
	String customerid =Util.null2String(request.getParameter("CustomerID"));
	String hidetitle = Util.null2String(request.getParameter("hidetitle"));
	String chanceid = Util.null2String(request.getParameter("chanceid"));
	if(!chanceid.equals("")){
		rs.execute("select customerid from CRM_SellChance where id = '"+chanceid+"'");
		rs.next();
		customerid = rs.getString(1);
	}
	
	String crmIds = Util.null2String(request.getParameter("crmIds"));
	String fromType= Util.null2String(request.getParameter("fromType"));//sellchance 表示为商机管理传递过来的
	String userid = user.getUID()+"";
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	boolean isattention = false;
	//rs.executeSql("select t.customerid,t.firstname from CRM_CustomerContacter t  where t.id="+contacterid);
	
	boolean canedit = false;
	if(!customerid.equals("") && crmIds.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户联系人权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户联系人权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs.getInt("status")==7 || rs.getInt("status")==8){
			canedit = false;
		}
	}
	String orderway = Util.null2String(request.getParameter("orderway"),"0");
	String datatype = Util.null2String(request.getParameter("datatype"),"1");
%>
<LINK href="/CRM/css/Contact_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base1_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<script type="text/javascript" src="/CRM/js/customerUtil_wev8.js"></script>

<body>

<%if(!isfromtab){%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(6082,user.getLanguage())%>"/>
</jsp:include>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	
	<tr><td class="rightSearchSpan" style="text-align:right;">
		<span style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="ContacterRemind(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(84369,user.getLanguage())%>"/>
		</span>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td></tr>
</table>

<style>
.feedbackrelate{
	white-space:normal;
	word-break;break-all;
	border-top:0px;
}
.feedbackshow{
	border:0px;
	border-bottom: 1px solid #f2f2f2;
}
.head35 {
  width: 35px;
  height: 35px;
  -webkit-border-radius: 30px;
  -moz-border-radius: 30px;
  border-radius: 30px;
  cursor: pointer;
  margin-right: 10px;
  margin-top: 3px;
}
.norecord{border:1px solid #f2f2f2;}
</style>

<div id="rightinfo" style="background:#fff;">
	<div id="fbmain" style="display:<%=from.equals("default")||from.equals("rdeploy")?"none":""%>">
		<table style="width: 100%;height: auto;margin-top:5px;margin-bottom:5px;overflow: hidden;" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="*" valign="top" align="center" style="padding-left:10px;padding-right:10px;">
				<textarea id="ContactInfo" _init="0" onpropertychange="resizeTextarea(this)"  oninput="resizeTextarea(this)" class="textareaNormal" style="width:100%;margin-top:0px;height:20px;overflow: auto;"><%=SystemEnv.getHtmlLabelName(84370,user.getLanguage())%></textarea>
			</td>
		</tr>
		<tr>
			<td width="*" valign="top" align="center">
				<div id="operationdiv" style="overflow: hidden;padding-left:8px;overflow: hidden;height: 0px;">
					
					<wea:layout type="1col">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item>
									<div style="margin-left: 0px;float: left;">
										<button type="button" onclick="doFeedback()" id="btnSubmit" class="submitButton"><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></button>
										<%if(!from.equals("rdViewCrm")){%>
										<button type="button" onclick="addCustomerPlan()" id="planSubmit" class="grayBtn"><%=SystemEnv.getHtmlLabelName(84371,user.getLanguage())%></button>
										<%}%>
									</div>
									<%if(!from.equals("rdViewCrm")){%>
									<div style="margin-left:5px;float: left;">
										<select id="contacterid" name="contacterid" style="width:60px;">
											<option value="">-<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>-</option>
											<%
											List contacterList=CustomerService.getContacterList(customerid);
											for(int i=0;i<contacterList.size();i++){
												Map contacter=(Map)contacterList.get(i);
												String tempcontacterid=(String)contacter.get("contacterid");
												String fullname=(String)contacter.get("firstname");
											%>
											<option value="<%=tempcontacterid%>"><%=fullname%></option>
											<%}%>
										</select>
									</div>
									<div style="margin-left:5px;float: left;">
										<%if(!chanceid.equals("")){
											RecordSet.executeSql("select customerid , subject from CRM_SellChance where id="+chanceid);
											RecordSet.next();
										%>
											<input type="hidden" name="sellchanceid" id="sellchanceid" value="<%= chanceid%>">
										<%}else{ %>
											<select id="sellchanceid" name="sellchanceid" style="width:50px;">
												<option value="">-<%=SystemEnv.getHtmlLabelName(32922,user.getLanguage())%>-</option>
												<%
												List sellChanceList=CustomerService.getSellChanceList(customerid,userid);
												for(int i=0;i<sellChanceList.size();i++){
													Map contacter=(Map)sellChanceList.get(i);
													String tempsellchanceid=(String)contacter.get("sellchanceid");
													String subject=(String)contacter.get("subject");
												%>
												<option value="<%=tempsellchanceid%>" if() ><%=subject%></option>
												<%}%>
											</select>
										<%} %>
									</div>
									<%}%>
									<div id="submitload" style="float:left;margin-top: 6px;margin-bottom: 0px;margin-left: 20px;display: none;"><img src='/CRM/images/loading2_wev8.gif' align=absMiddle /></div>
									<%if(!from.equals("rdViewCrm")){%>
									<div onclick="" id="fbrelatebtn" _status="0" style="background:url('/cowork/images/blue/down_wev8.png') no-repeat right center;padding-right:8px;cursor: pointer;vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(83273,user.getLanguage())%></div>
									<%}%>
								</wea:item>
							</wea:group>
					</wea:layout>
				</div>
				<div id="extendtable" style="padding-left:8px;display:none;overflow:auto">
					<wea:layout type="2col">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								
								<wea:item attributes="{'customAttrs':'align=left'}"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
								<wea:item attributes="{'customAttrs':'align=left'}">
									<brow:browser viewType="0" name="_docids" browserValue="" browserOnClick="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" hasInput="true" 
									isSingle="false" hasBrowser = "true" isMustInput='1' 
									width="90%" browserSpanValue="" completeUrl="/data.jsp?type=9"> </brow:browser>
								</wea:item>
								
								<wea:item attributes="{'customAttrs':'align=left'}"><%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%></wea:item>
								<wea:item attributes="{'customAttrs':'align=left'}">
									<brow:browser viewType="0" name="_wfids" browserValue="" browserOnClick="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp" hasInput="true" 
									isSingle="false" hasBrowser = "true" isMustInput='1' 
									width="90%" browserSpanValue="" completeUrl="/data.jsp?type=152"> </brow:browser>
								</wea:item>
								
								<wea:item attributes="{'customAttrs':'align=left'}"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
								<wea:item attributes="{'customAttrs':'align=left'}">
									<brow:browser viewType="0" name="_projectids" browserValue="" browserOnClick="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids=" hasInput="true" isSingle="false" 
									hasBrowser = "true" isMustInput='1' 
									width="90%" browserSpanValue="" completeUrl="/data.jsp?type=8"> </brow:browser>
								</wea:item>
								<wea:item attributes="{'customAttrs':'align=left'}"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
								<wea:item attributes="{'customAttrs':'align=left'}">
									<div name="uploadDiv" id="uploadDiv" fieldName="relatedfile"  maxsize="100"  uploadLimit="10"></div>
								</wea:item>
								
							</wea:group>	
					</wea:layout>
				</div>
			</td>
		</tr>
		</table>
  	</div>
	<div id="maininfo" style="padding-right:5px;<%=from.equals("rdViewCrm")?"overflow:hidden;":""%>" class="scroll1" >
		  <div style="padding:5px;padding-bottom:0px;padding-left:0px;display:<%=from.equals("default")||from.equals("rdeploy")||from.equals("rdViewCrm")?"none":""%>">
		  		<input type="hidden" id="datatype" value="<%=datatype %>">
		  		<div style="float:right;" class="orderway" _val="<%=orderway%>">
		  			<div id="sequence"  _val="1" title="<%=SystemEnv.getHtmlLabelName(84042,user.getLanguage())%>" onclick="changOrderway(this)" style="width:26px;height:26px;background:url('/CRM/images/icon_sequence<%=orderway.equals("1")?"_h":""%>_wev8.png');float:right;margin-left:5px;cursor:pointer;"></div>
		  			<div id="reverse"   _val="0" title="<%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%>" onclick="changOrderway(this)" style="width:26px;height:26px;background:url('/CRM/images/icon_reverse<%=orderway.equals("0")?"_h":""%>_wev8.png');float:right;cursor:pointer;"></div>
		  			<div style="clear:both;"></div>
		  		</div>
		  		<div style="clear:both;"></div>
		  </div>
		  <%
		  
		  	String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的客户，all全部客户，attention关注客户
			String resourceid=Util.null2String(request.getParameter("resourceid"),""+userid);    //被查看人id
			String viewtype=Util.null2String(request.getParameter("viewtype"),"0");              //查看类型 0仅本人，1包含下属，2仅下属
			String sector=Util.null2String(request.getParameter("sector")); //行业
			String status=Util.null2String(request.getParameter("status")); //状态
			String name =URLDecoder.decode( Util.null2String(request.getParameter("name"))); //名称
		  
		  	String keyword = Util.null2String(request.getParameter("keyword")); 
		  	String manager = Util.null2String(request.getParameter("manager"));  
		  	String datetype = Util.null2String(request.getParameter("datetype"));
		  	String fromdate = Util.null2String(request.getParameter("fromdate")); 
		  	String enddate = Util.null2String(request.getParameter("enddate")); 
		    String tableString = "";
			int perpage=10;                                 
			String backfields = " id, createdate , createtime, resourceid, description, name, status, urgentLevel, createrid, createrType, taskid, crmid, requestid, docid,contacterid,sellchanceid ,relateddoc , projectid ";
			String sqlFrom  = " WorkPlan ";
			String sqlWhere = " crmid='"+customerid+"' and type_n=3 ";
			if(!chanceid.equals("")){
				sqlWhere += " and sellchanceid='"+chanceid+"' ";
			}
			
			String orderby = "";
			
			//获取我的客户默认联系记录
			if(from.equals("default")||from.equals("rdeploy")){
				
				String leftjointable = CrmShareBase.getTempTable(""+userid);
				String sqlstr="select id as cutomerid,manager,relateditemid from CRM_CustomerInfo t1 "+(rs.getDBType().equals("oracle")?" left join ":" inner merge join ")+leftjointable+" t2 on t1.id = t2.relateditemid "; 
				
				String searchstr="";
				if(!fromType.equals("sellchance")){
					if(labelid.equals("my")){  //我的客户
						if(viewtype.equals("0")){ //仅本人客户
							searchstr+=" and t2.manager="+resourceid;
						}else if(viewtype.equals("1")){ //包含下属
							String subResourceid=Util.null2s(CustomerService.getSubResourceid(resourceid),"0"); //所有下属
							searchstr+=" and t2.manager in("+resourceid+","+subResourceid+")";
						}else if(viewtype.equals("2")){ //仅下属
						    String subResourceid=Util.null2s(CustomerService.getSubResourceid(resourceid),"0"); //所有下属
							searchstr+=" and t2.manager in("+subResourceid+")";
						}
						sqlstr+=" where t1.deleted = 0 ";
					}else if(labelid.equals("attention")){ //关注客户
						sqlstr+=" left join (select customerid from CRM_Attention where resourceid="+resourceid+") t3 on t1.id=t3.customerid ";
						sqlstr+=" where t1.deleted = 0  and t1.id = t2.relateditemid and t1.id=t3.customerid";
					}else if(labelid.equals("new")){       //新客户
						sqlstr+=" left join CRM_ViewLog2 t5 on t1.id=t5.customerid ";
						sqlstr+=" where t1.deleted = 0  and t1.id = t2.relateditemid and t1.id=t5.customerid and t1.manager="+userid;
					}else if(!labelid.equals("all")){
						sqlstr+=" left join (select customerid from CRM_Customer_label where labelid="+labelid+") t4 on t1.id=t4.customerid";
						sqlstr+=" where t1.deleted = 0  and t1.id = t2.relateditemid and t1.id=t4.customerid ";
					}else{
						sqlstr+=" where t1.deleted = 0  and t1.id = t2.relateditemid  ";
					}
					if(!"".equals(status)){
						sqlstr+=" and t1.status="+status;
					}
					if(!"".equals(sector)){
						sqlstr+=" and t1.sector="+sector;
					}
				}
				String datestr="";
				String currentdate=TimeUtil.getCurrentDateString();
				if(datatype.equals("1"))
					datestr=TimeUtil.dateAdd(currentdate,-30);
				else if(datatype.equals("2"))
					datestr=TimeUtil.dateAdd(currentdate,-90);	
				else if(datatype.equals("3"))
					datestr=TimeUtil.dateAdd(currentdate,-180);
				else if(datatype.equals("4"))
					datestr=TimeUtil.dateAdd(currentdate,-365);
				if(!crmIds.equals("")){
					if(crmIds.indexOf(",")==-1){
						sqlstr +=" and t1.id in ("+crmIds+",-999)";
					}else
						sqlstr +=" and t1.id in ("+crmIds+")";
				}
				else if(fromType.equals("sellchance")&&crmIds.equals("")) {
				    sqlstr +=" and t1.id in (-999,-998)";
				}
				if(!"".equals(datestr)&&"".equals(fromdate)&&"".equals(enddate))
					searchstr+=" and createdate>='"+datestr+"'";
					
				sqlFrom  = " (select "+backfields+" from WorkPlan where type_n = '3') t1,("+sqlstr+") t2 ";
				sqlWhere=" t1.crmid=CAST(t2.relateditemid as varchar(10)) "+searchstr;
				if(fromType.equals("sellchance")){
					sqlWhere +=" and t1.sellchanceid is not null";
				}
			}
			
			if(!"".equals(keyword)){
				sqlWhere+=" and description like '%"+keyword+"%'";
			}
			if(!"".equals(manager)){
				sqlWhere+=" and resourceid = '"+manager+"'";
			}
			if(!"".equals(datetype) && !"6".equals(datetype)){
				sqlWhere += " and createdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
				sqlWhere += " and createdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
			}
			if(!"".equals(fromdate)){
				sqlWhere+=" and createdate >= '"+fromdate+"'";
			}
			if(!"".equals(enddate)){
				sqlWhere+=" and createdate <= '"+enddate+"'";
			}
			SplitPageParaBean sppb = new SplitPageParaBean();
			SplitPageUtil spu = new SplitPageUtil();
			
			sppb.setBackFields(backfields);
			sppb.setSqlFrom(sqlFrom);
			sppb.setSqlWhere(sqlWhere);
			sppb.setPrimaryKey("id");
			sppb.setSqlOrderBy("id");
			sppb.setSortWay(orderway.equals("0")?sppb.DESC:sppb.ASC);
			spu.setSpp(sppb);
			int pagesize=20;
			int pageindex = Util.getIntValue(request.getParameter("pageindex"),1);
			int recordCount = spu.getRecordCount();
			rs = spu.getCurrentPageRsNew(pageindex,pagesize);
			int totalpage = recordCount / pagesize;
			if(recordCount - totalpage * pagesize > 0) totalpage = totalpage + 1;
			
			String htmlStr="";
			while(rs.next()){
				
				String createrid=rs.getString("resourceid");
				createrid = createrid.replace(",","");
				String createdate=rs.getString("createdate");
				String createtime=rs.getString("createtime");
				String description=rs.getString("description");
				String crmid=rs.getString("crmid");
				String docid=rs.getString("docid");
				String requestid=rs.getString("requestid");
				String projectid=rs.getString("projectid");
				String sellchanceid=rs.getString("sellchanceid");
				String tempcontacterid=rs.getString("contacterid");
				String fileid = rs.getString("relateddoc");
				String info= "";
				if(!"".equals(fileid)){
					rst.execute("select imagefileid ,imagefilename from ImageFile  where imagefileid in ("+fileid+")");
					StringBuffer sb = new StringBuffer();
					while (rst.next()) {
						
						sb.append("<a href='/weaver/weaver.file.FileDownload?fileid=" + rst.getString("imagefileid") + "&download=1&crmid="+crmid+"&crmtype=1' >"+
								rst.getString("imagefilename")+"</a>&nbsp;&nbsp;&nbsp;&nbsp;");
					}
					if(rst.getCounts()>1){
						sb.append("<a href='/weaver/weaver.file.FileDownload?fieldids=" + fileid+ ",&download=1&onlydownloadfj=1&labelid=156&crmid="+crmid+"&crmtype=1' >"+
								SystemEnv.getHtmlLabelName(32407,user.getLanguage())+"</a>");
					}
					info = sb.toString();
				}
				
				String contacterstr=CustomerService.getContacterName(tempcontacterid);
				
				String projectInfo = "";
				if(!projectid.equals("")&&!projectid.equals("0")){
					List list = Util.TokenizerString(projectid,",");
					for(int i=0; i < list.size() ; i++){ 
						projectInfo += "<a href='/proj/data/ViewProject.jsp?isrequest=1&ProjID='"+list.get(i)+"' target='_blank'>"+ProjectInfoComInfo.getProjectInfoname(list.get(i).toString())+"</a> ";
					}
				}
				if(description.indexOf("<br>")==-1) { 
					description = Util.forHtml(description);
				}
				String createrType = rs.getString("createrType");
				String createrHtml = "	<div><a href='/hrm/resource/HrmResource.jsp?id="+createrid+"' target='_blank'>"+ResourceComInfo.getResourcename(createrid)+"</a>";
				if("2".equals(createrType))
					createrHtml = "	<div><a href='/CRM/data/ViewCustomer.jsp?CustomerID="+createrid+"' target='_blank'>"+CustomerInfoComInfo.getCustomerInfoname(createrid)+"</a>";
				htmlStr+="<div class='feedbackshow'>"+
					   "<div class='feedbackinfo' >"+
					   		"<div class='left'><img src='"+ResourceComInfo.getMessagerUrls(createrid)+"' class='head35'></div>"+
							"<div class='left' style='max-width:90%;word-break:break-all;'>"+
					   		createrHtml+
							" 	"+createdate+" "+createtime+"</div>"+
							"	<div class='feedbackrelate'>"+
								   "<div>"+description+"</div>"+
								   // ((!crmid.equals("")&&!crmid.equals("0"))?("<div class='relatetitle'>相关客户："+CommonTransUtil.getCustomer(crmid)+"</div>"):"")+
								   ((!docid.equals("")&&!docid.equals("0"))?("<div class='relatetitle'>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+":"+CommonTransUtil.getDocName(docid)+"</div>"):"")+
								   ((!requestid.equals("")&&!requestid.equals("0"))?("<div class='relatetitle'>"+SystemEnv.getHtmlLabelName(22105,user.getLanguage())+":"+CommonTransUtil.getRequestName(requestid)+"</div>"):"")+
								   ((!projectid.equals("")&&!projectid.equals("0"))?("<div class='relatetitle'>"+SystemEnv.getHtmlLabelName(782,user.getLanguage())+":"+projectInfo+"</div>"):"")+
								   ((!sellchanceid.equals("")&&!sellchanceid.equals("0"))?("<div class='relatetitle'>"+SystemEnv.getHtmlLabelName(84372,user.getLanguage())+":"+CustomerService.getSellChanceName(sellchanceid)+"</div>"):"")+
								   ((!tempcontacterid.equals("")&&!tempcontacterid.equals("0")&&!tempcontacterid.equals(""))?("<div class='relatetitle'>"+SystemEnv.getHtmlLabelName(84373,user.getLanguage())+":"+contacterstr+"</div>"):"")+
								   ((!fileid.equals("")&&!fileid.equals("0"))?("<div class='relatetitle'>"+SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":"+info+"</div>"):"")+
							   
							 "	</div>"+
							"</div>"+
							"<div class='clear'></div>"+
					   "</div>"+
					  "</div>"; 	
			}
			out.println(htmlStr);
			
			if(rs.getCounts()>0){
		  %>
		  	<div id="discusspage" class="kkpager" style="text-align:right;margin-top:8px;"></div>
		  <%}else{%>
		  	<div class="norecord"><%=SystemEnv.getHtmlLabelName(83320,user.getLanguage())%></div>
		  <%}%>
</div>
</div>

<%if(isfromtab&&!chanceid.equals("")){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" 
				<% if(chanceid.equals("")){%>
					onclick="parent.getDialog(window).close();"
				<%}else{ %>
					onclick="parentWin.closeDialog();"
				<%} %>
				>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>

<form id="mainForm">

	<input type="hidden" name="labelid" id="labelid" value="<%=labelid%>"/>
	<input type="hidden" name="resourceid" id="resourceid" value="<%=resourceid%>"/>
	<input type="hidden" name="viewtype" id="viewtype" value="<%=viewtype%>"/>
	<input type="hidden" name="sector" id="sector" value="<%=sector%>"/>
	<input type="hidden" name="status" id="status" value="<%=status%>"/>
	<input type="hidden" name="from" id="from" value="<%=from%>"/>
	<input type="hidden" name="fromType" id="fromType" value="<%=fromType%>"/>
	<input type="hidden" name="crmIds" id="crmIds" value="<%=crmIds%>"/>
	<input type="hidden" name="manager" id="manager" value="<%=manager%>"/>
	<input type="hidden" name="fromdate" id="fromdate" value="<%=fromdate%>"/>
	<input type="hidden" name="enddate" id="enddate" value="<%=enddate%>"/>
	<input type="hidden" name="_crmids" id="_crmids" value = "<%=customerid %>"/>
</form>

<style>
TABLE.ListStyle tbody tr td {
	padding:0px;
}
TABLE.ListStyle TR.HeaderForXtalbe{
	display:none;
}
/*
TABLE.ListStyle{width:96%}
.feedbackshow{width:100%}
.feedbackrelate{border:0px;}
*/
.fieldName{padding-left:0px !important;}
.paddingLeft18{padding-left:5px !important;}

</style>

<script language="javascript">

var parentWin = null;
if("<%=isfromtab%>" == "true"){
	parentWin = parent;
}else{
	parentWin = parent.getParentWindow(window);
}

	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var keyword = "<%=SystemEnv.getHtmlLabelName(84354,user.getLanguage())%>";
	var begindate = "<%=TimeUtil.getCurrentDateString()%>";
	$(document).ready(function(){

		var pageUrl=getUrl();
		initPageInfo(<%=totalpage%>,<%=pageindex%>,pageUrl);

		initMainHeight();
		initTextarea();

		//反馈信息内容样式
		$("#contactmore").live("mouseover",function(){
			$(this).children("td").css("background","url('../images/more_bg_hover_wev8.png') center repeat-x");
		}).live("mouseout",function(){
			$(this).children("td").css("background","url('../images/more_bg_wev8.png') center repeat-x");
		});
		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("#extendtable").show();
				$("#extendtable").animate({height:125},200,null,function(){
					initMainHeight();
				});
				$(this).attr("_status",1).css("background", "url('../images/btn_up_wev8.png') right no-repeat");
			}else{
				// $("#extendtable").hide();
				$("#extendtable").animate({height:0},200,null,function(){
					initMainHeight();
				});
				$(this).attr("_status",0).css("background", "url('../images/btn_down_wev8.png') right no-repeat");
			}
			$("#maininfo").height($(window).height()-$("#fbmain").height());
		});
		
		//bindUploaderDiv($("#fbUploadDiv"),"relateddoc","");
		bindUploaderDiv($("#uploadDiv")); 
		
		if("<%=from%>"=="rdViewCrm"){
			changeIframeHeight();
		}	
		
	});
	
	
	function initMainHeight(){
		var height=$(window).height()-$("#fbmain").height()-10;
		if("<%=from%>"=="base")
			height=$(window).height()-$("#fbmain").height()-10;
		else if("<%=from%>"=="mine")
			height=$(window).height()-$("#fbmain").height()-40;
		else if("<%=from%>"=="default")
			height=$(window).height()-$("#fbmain").height();
		else if("<%=from%>"=="rdeploy")
			height=$(window).height()-5;
		else if("<%=from%>"=="rdViewCrm"){
			height=$("#maininfo").height()+10;		
		}else if("<%=from%>"==""){
			height=$(window).height()-$("#fbmain").height()-50;
		}
		$("#maininfo").height(height);
	}
	
	//初始化remark
	function initTextarea(){
		$("#ContactInfo").bind("focus",function(){
		   activeTextarea(this);
		});
		
		$(document.body).bind("click",function(event){
			if($(event.target).parents("#fbmain").length==1||$(event.target).attr("tagName")=="BODY") return;
			clearTextarea($("#ContactInfo"));
		});
	}
	
	function activeTextarea(obj){
	   var init=$(obj).attr("_init");
	   if(init=="0"){
		   $(obj).val("").height(100).removeClass("textareaNormal");
		   $("#operationdiv").animate({height:30},200,null,function(){
		   		initMainHeight();
		   });
		   $(obj).attr("_init","1");
	   }
	}
	
	function clearTextarea(obj){
	   	if($(obj).val()==""){
	   	  $(obj).val("<%=SystemEnv.getHtmlLabelName(84370,user.getLanguage())%>").height(20).addClass("textareaNormal");
	   	  $("#operationdiv").animate({height:0},200,null,function(){
	   	  		initMainHeight();
	   	  });
		  $(obj).attr("_init","0");
	   }
	}
	
	function changOrderway(obj){
		var orderway=$(obj).attr("_val");
		$(".orderway").attr("_val",orderway);
		loadData();
	}
	
	function loadData(){
		
		window.location.href=getUrl();
	}
	
	function getUrl(){
	
		var datatype=$("#datatype").val();
		var orderway=$(".orderway").attr("_val");
		
		var params=$("#mainForm").serialize();
		
		var url="/CRM/data/ViewContactLog.jsp?CustomerID=<%=customerid%>&isfromtab=true&keyword=<%=keyword%>&chanceid=<%=chanceid%>";
		url=url+"&orderway="+orderway+"&datatype="+datatype+"&"+params;
		
		return url;
	}
	
	function resizeTextarea(obj){ 
	
		var minHeight = 100;
		var maxHeight = 100; 
		var t =obj; 
		h = t.scrollHeight-6; 
		var styleHeight=t.style.height;
		
		if(h>=minHeight&&h<=maxHeight){
		
			if(h>$(t).height()){
				$(t).height(h).css("height",h+"px"); 
			}else if(h!=40){
				$(t).height(h-8);
			}
		}	
		initMainHeight();
	} 


	document.onkeydown=keyListener;
	function keyListener(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){
	    	//var target=$.event.fix(e).target;
	    	//ctrl+enter 直接提交反馈
			if(event.ctrlKey){
				doFeedback();
			}
	    	 
	    }    
	}
	var ContactInfo;
	var upfilesnum=0; //获得上传文件总数
	function doFeedback(){
		ContactInfo = $.trim($("#ContactInfo").val());
		if(ContactInfo==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84370,user.getLanguage())%>");
			return;
		}
		if(ContactInfo==keyword){
			$("#ContactInfo").focus();
			return;
		}
		
		try{
			var oUploader=window[$("#uploadDiv").attr("oUploaderIndex")];
			upfilesnum = oUploader.getStats().files_queued
			if(upfilesnum == 0){ //如果没有选择附件则直接提交
				exeFeedback();  //提交
			}else{ 
 				oUploader.startUpload();
			}
		}catch(e) {
			exeFeedback();
	  	}
	}
	
	function doSaveAfterAccUpload(){//附件上传的回调函数
		exeFeedback();
	}
	
	function exeFeedback(){
		
		var relateddoc = $("#_docids").val();relateddoc = cutval(relateddoc);
		var relatedwf = $("#_wfids").val();relatedwf = cutval(relatedwf);
		var relatedcus = $("#_crmids").val();relatedcus = cutval(relatedcus);
		var relatedprj = $("#_projectids").val();relatedprj = cutval(relatedprj);
		var sellchanceid=$("#sellchanceid").val();
		var contacterid=$("#contacterid").val();
		var relatedfile=$("#relatedfile").val(); 
		
		$("#submitload").show();
		$("div.btn_feedback").hide();
		//$("#fbdate").hide();
		var status=$("#btnSubmit").attr("_status");
		if(status==1){ 
			return;
		}else{
			$("#btnSubmit").attr("_status","1");
		}	
		$.ajax({
			type: "post",
			url: "/CRM/data/ViewContactOperation.jsp",
			contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			data:{"operation":"addquick","ContactInfo":encodeURIComponent(ContactInfo),"CustomerID":"<%=customerid%>","sellchanceid":sellchanceid,
				"contacterid":contacterid,"relateddoc":relateddoc,"relatedwf":relatedwf,"relatedcus":relatedcus,"relatedprj":relatedprj,"begindate":begindate,"relatedfile":relatedfile}, 
			complete: function(data){
				//getContact(begindate);
				var records = $.trim(data.responseText);
				$("#noinfo").remove();
		    	$("#feedbacktable").prepend(records);
				$("#submitload").hide();
				$("div.btn_feedback").show();
				//$("#fbdate").show();
				//cancelFeedback();
				$("#ContactInfo").val("");
				//_table. reLoad();
				$("#btnSubmit").attr("_status","0");
				loadData();
				
			}
		});
		
	}
	function cutval(val){
		if(val==",") val = "";
		// if(val!="") val = val.substring(1,val.length-1);
		return val;
	}
	function cancelFeedback(){
		var obj = $("#ContactInfo")
		obj.val(keyword);
		obj.addClass("blur_text");
		$("div.btn_feedback").hide();
		var _status = $("#fbrelatebtn").attr("_status");
		if(_status==1) $("#fbrelatebtn").click();
		$("#fbrelatebtn").hide();
			//begindate = "<%=TimeUtil.getCurrentDateString()%>";
			//$("#fbdate").hide().html("联系日期："+begindate);
		$("#maininfo").css("top",$("#fbmain").height()+$("#contacttitle").height());

		$("#_docids_val").val(",");$("#_wfids_val").val(",");$("#_projectids_val").val(",");
		$("table.feedrelate").find("div.txtlink").remove();

		$("input[name=relateddoc]").val("");
	}

	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}
	//回车事件方法
	function keyListener2(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){    
	    	$(foucsobj2).blur();   
	    }    
	}
	//删除选择性内容
	function delItem(fieldname,fieldvalue){
		$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
		var vals = $("#"+fieldname+"_val").val();
		var _index = vals.indexOf(","+fieldvalue+",")
		if(_index>-1 && $.trim(fieldvalue)!=""){
			vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
			$("#"+fieldname+"_val").val(vals);
			if(!startWith(fieldname,"_")){
				exeUpdate(fieldname,vals,'str',fieldvalue);
			}
		}
	}
	//选择内容后执行更新
	function selectUpdate(fieldname,id,name,type){
		var addtxt = "";
		var addids = "";
		var addvalue = "";
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += ids[i] + ",";
				addvalue += ids[i] + ",";
				addtxt += transName(fieldname,ids[i],names[i]);
			}
		}
		$("#"+fieldname+"_val").val(vals+addids);
		addids = vals+addids;
		$("#"+fieldname).before(addtxt);
	}
	function showFeedback(){
		$("#content").focus();
	}
	
	function showop(obj,classname,txt){
		$(obj).removeClass(classname).html(txt);
	}
	function hideop(obj,classname,txt){
		$(obj).addClass(classname).html(txt);
	}
	
	var dialog;
	function ContacterRemind(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/CRM/data/AddContacterLogRemind.jsp?CustomerID=<%=customerid%>&isfromCrmTab=true";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84369,user.getLanguage())%>";
		
		
		
		dialog.Width = 420;
		dialog.Height =200;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function ContacterRemindCallback(CustomerID){
		dialog.close();
	}
	
	function addCustomerPlan(){  
		var url = encodeURI("/workplan/data/WorkPlanAdd.jsp?from=2&type_n=3&resourceid=<%=userid%>&crmid=<%=customerid%>&description="+jQuery("#ContactInfo").val());
		dialog =new window.top.Dialog();
	   	dialog.currentWindow = window; 
	   	dialog.Title="<%=SystemEnv.getHtmlLabelName(16426,user.getLanguage())%>";
		dialog.Width =680;
		dialog.Height =600;	
		dialog.Drag = true;
		dialog.URL=url;
		dialog.show();
	}
	
	function closeWin(){
		if(dialog){
			dialog.close();
		}
		loadData();
	}
	
	function setContactStatus(planId){
		 jQuery.post("/CRM/report/CRMContactLogRp.jsp",{"planId":planId,"operation":"once"},function(){
		 	_table.reLoad();
		 });
	}
	
	jQuery(function(){
		if(jQuery(".current",parent.document).attr("id") == "crmContract"){//如果是通过客户联系卡片进来的，则刷新
			if(jQuery("#contactNum",parent.document).length==1){
				jQuery.post("/CRM/data/ViewContactOperation.jsp",
					{"operation":"workPlanViewLog","customerid":"<%=customerid%>"},function(){
						jQuery("#contactNum",parent.document).remove();
				});
			}
		}
	
	});
	
	function changeIframeHeight(){ 
    	window.parent.document.getElementById('contaceLogFrame').height=$("#maininfo").height()+$("#fbmain").height()+10;
    }
	
</script>
</body>

