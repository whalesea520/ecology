
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<%
	String userid = user.getUID()+"";
	String contacterid = Util.null2String(request.getParameter("ContacterID"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/data/ViewContacter.jsp?ContacterID="+contacterid);
		return;
	}
	rs.executeProc("CRM_CustomerContacter_SByID", contacterid);
	if (rs.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();
	String customerid = rs.getString(2);
	String customertype = "";

	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs2.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs2.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs2.getInt("status")==7 || rs2.getInt("status")==8){
			canedit = false;
		}
		customertype = Util.null2String(rs2.getString("type"));
	}
	
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<link type="text/css" href="/CRM/css/Base_wev8.css" rel=stylesheet>
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<style>
		.traildiv{margin-left:120px;margin-top:15px;}
		.traildiv .trailline{height:180px;width:1px;border-left:1px solid #cbcbcb;position:absolute;left:16px;}
		.traildiv .trailbegin{
			height:32px;width: 32px;background:url('/CRM/images/trail/icon_trail_wev8.png') no-repeat;
		}
		.traildiv .trailend{
			height:9px;width:9px;background:url('/CRM/images/trail/icon_trail_end_wev8.png') no-repeat;margin-left:12px;
		}
		.traildiv .year{
			height:19px;width:77px;position:absolute;top:50px;left:-60px;background:url('/CRM/images/trail/trail_year_wev8.png') no-repeat;
		}
		.traildiv .item{
			height:160px;position:absolute;left:18px;
		}
		.traildiv .item .trailleft{
			position:absolute;left:-6px;height:19px;width:57px;z-index:10
		}
		.traildiv .item .trailcenter{
			margin-left:49px;float: left;height:19px;z-index:10;color:#fff;padding-left:3px;padding-right:3px;cursor:pointer;
		}
		.traildiv .item .trailright{
			float: left;height:19px;width:10px;z-index:10;
		}
		.traildiv .item .contracter{
			padding:5px;border-radius:3px 3px 3px 3px;
		}
	</style>
	<div class="traildiv">
		<div class="trailbegin"></div>
		<%
		  Map contacter=CustomerService.getContacterByid(contacterid);
		  String email=Util.null2String(contacter.get("email"));
		  String firstname=Util.null2String(contacter.get("firstname"));
		  String mobilephone=Util.null2String(contacter.get("mobilephone"));
		  String imcode=Util.null2String(contacter.get("imcode"));
		  
		  String sql="SELECT id,customerid,firstname,title,phoneoffice,mobilephone,email,jobtitle,department,imcode FROM CRM_CustomerContacter where firstname='"+firstname+"'"
		             +" and customerid="+customerid;
		             if(!email.equals("")||!mobilephone.equals("")||!imcode.equals("")) {
		                 sql+= " and (email='"+email+"' or mobilephone='"+mobilephone+"' or imcode='"+imcode+"')";
		             }
		  rs.execute(sql);
		  String[] colors={"#3fcecd","#ef7ed5","#bca0f2"};
		  int index=0;
		  while(rs.next()){	
			  String tempcontacterid=rs.getString("id");
			  String tempcustomerid=rs.getString("customerid");
			  String customerName=CustomerInfoComInfo.getCustomerInfoname(tempcustomerid);
			  String jobtitle=rs.getString("jobtitle");
			  
			  int colorindex=index%3;
			  String color=colors[colorindex];
			  index++;
		%>
		
		<div style="position: relative;height:180px;">
		
			<div class="trailline"></div>
			
			<div class="year" style="display:none;">
				<span style="margin-left:5px;">2014<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></span>
			</div>
			
			<div class="item">
				<table style="height:100%;width:100%">
					<tr>
						<td valign="middle" style="padding-right:10px;">
							<div>
								<div class="trailleft" style="background:url('/CRM/images/trail/trail_left_<%=colorindex%>_wev8.png')"></div>
								<div class="trailcenter" onclick="openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?CustomerID=<%=customerid%>')" style="background:url('/CRM/images/trail/trail_center_<%=colorindex%>_wev8.png');">
									<span></span><%=customerName%>&nbsp;&nbsp;<%=jobtitle%>
								</div>
								<div class="trailright" style="background:url('/CRM/images/trail/trail_right_<%=colorindex%>_wev8.png')"></div>
								<div style="clear: both;"></div>
							</div>
						</td>
						<td valign="middle">
							<div class="contracter" style="border:1px solid <%=color%>;">
								<%
									sql="select resourceid,max(createdate) lastdate from workplan where contacterid="+tempcontacterid+"  GROUP BY resourceid order by lastdate";
									rs2.execute(sql);
									while(rs2.next()){
										String resourceid=rs2.getString("resourceid");
										String lastdate=rs2.getString("lastdate");
								 %>
								 	<div style="height:30px;line-height:30px;">
										<div style="float: left;cursor:pointer;" onclick="pointerXY(event);openhrm('<%=resourceid%>');return false;"><span style="color:<%=color%>"><%=ResourceComInfo.getLastname(resourceid)%></span>&nbsp;<span style="color:#939393"><%=SystemEnv.getHtmlLabelName(84243,user.getLanguage())%></span></div>
										<div style="float: left;margin-left:35px;"><span style="color:#939393"><%=lastdate%>&nbsp;<%=SystemEnv.getHtmlLabelName(84279,user.getLanguage())%></div>
										<div style="clear:both;"></div>
									</div>
								<%}
								    if(rs2.getCounts()==0){
								%>
									<div style="color:#939393"><%=SystemEnv.getHtmlLabelName(84280,user.getLanguage())%></div>
								<%}%>
							</div>
							
						</td>
					</tr>	
				</table>
			</div>
			
		</div>
		<%
		}%>
		<div class="trailend"></div>
	</div>
	
	</body>
</html>
