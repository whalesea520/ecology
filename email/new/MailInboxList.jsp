<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.MailCommonUtils"%>  
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.domain.*" %>
<%@ page import="weaver.docs.category.security.AclManager" %>
<%@page import="weaver.hrm.resource.ResourceUtil"%>
<%@page import="weaver.email.service.MailResourceService"%>
<%@page import="weaver.email.service.MailAccountService"%>

<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="mailSearchComInfo" class="weaver.email.search.MailSearchComInfo" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<%
	if(user == null) return ;

	float space = 1f;
	rst.execute("select totalSpace ,occupySpace from HrmResource where id = "+user.getUID());
	if(rst.next()){
	    space = Util.getFloatValue(rst.getString("totalSpace"), 0f) - Util.getFloatValue(rst.getString("occupySpace"), 0f);
	}

	boolean isSystemManager = false;
	rs.executeSql("select 1 from hrmresourcemanager where id="+user.getUID());
	if(rs.getCounts()>0) isSystemManager = true;

	String method = Util.null2String(request.getParameter("method"));
	String checkuser=Util.null2String(request.getParameter("checkuser"));
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
	
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
	String receivemailid = Util.null2String(request.getParameter("receivemailid"));
	String star = Util.null2String(request.getParameter("star"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String folderid = Util.null2String(request.getParameter("folderid"));	
	String receivemail = Util.null2String(request.getParameter("receivemail"));	
	String subject = Util.null2String(request.getParameter("subject"));		
	
	String waitdeal = Util.null2String(request.getParameter("waitdeal"),"");
	
	//快速搜索
	String quickSearch = Util.null2String(request.getParameter("quickSearch"));		
	if(quickSearch.equals("true")){
		subject = mailSearchComInfo.getSubject();
	}
	
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));	
	String tohrmid = Util.null2String(request.getParameter("tohrmid"));	
	String fromhrmid = Util.null2String(request.getParameter("fromhrmid"));	
	String status = Util.null2String(request.getParameter("status"));	
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));	
	String datetype = Util.null2String(request.getParameter("datetype"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	//clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索
	String clickObj=Util.null2String(request.getParameter("clickObj"));
	//1表示标签是在页面点击出来的，而不是通过超链接点击出来的
	String labelidchecked=Util.null2String(request.getParameter("labelidchecked"));
	
	Object obj=session.getAttribute("newEmailurl");
	if(null!=obj){
		//如果作用域不为Null,表示参数来源于/email/new/MailInboxListMain.jsp,需要重置参数
		String newEmailurl=obj+"";
		String newurl[]=newEmailurl.split("#");
		if(null!=newurl&&newurl.length>=16){
						isInternal=Util.getIntValue(newurl[0],-1);
						receivemailid=newurl[1];
						star=newurl[2];
						labelid=newurl[3];
						folderid=newurl[4];
						receivemail=newurl[5];
						subject=newurl[6];
						from=newurl[7];
						to=newurl[8];
						status=newurl[9];
						mailaccountid=newurl[10];
						attachmentnumber=newurl[11];
						startdate=newurl[12];
						enddate=newurl[13];
						labelidchecked=newurl[14];
						clickObj=newurl[15].trim();
						tohrmid = newurl[16];
						fromhrmid = newurl[17].trim();
						datetype = newurl[18].trim();
						waitdeal = newurl[19].trim();
		}
		//清空作用域
		session.removeAttribute("newEmailurl");
	}
	
	if(userLayout==3){
%>
		<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js" charset="UTF-8"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js" ></script>
		<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect_wev8.js"></script>
		<script type="text/javascript" src="/email/js/checkbox/jquery.checkbox_wev8.js"></script>
		<script type="text/javascript" src="/email/js/leanModal/jquery.leanModal.min_wev8.js"></script>
		<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language="javascript" defer="defer" src="/js/init_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/wui/theme/ecology7/skins/default/wui_wev8.css" />
		
		<script type="text/javascript" src="/email/joyride/jquery.cookie_wev8.js"></script>
		<script type="text/javascript" src="/email/joyride/modernizr.mq_wev8.js"></script>
		<script type="text/javascript" src="/email/joyride/jquery.joyride-1.0.5_wev8.js"></script>
		<link rel="stylesheet" href="/email/joyride/joyride-1.0.5_wev8.css">
		<link rel="stylesheet" href="/email/joyride/mobile_wev8.css">
		<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete_wev8.js"></script>
		<link href="/email/js/autocomplete/jquery.autocomplete_wev8.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
	}else{
%>
		<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect_wev8.js"></script>
		<script type="text/javascript" src="/email/js/checkbox/jquery.checkbox_wev8.js"></script>
		<script type="text/javascript" src="/email/js/leanModal/jquery.leanModal.min_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect_wev8.css" />
		<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete_wev8.js"></script>
		<link href="/email/js/autocomplete/jquery.autocomplete_wev8.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%	
	}
	
	String url = "";
	if(userLayout == 1){
		 url="/email/new/MailInboxListMain.jsp";
	}else if(userLayout == 2){
		 url="/email/new/MailInboxListMain.jsp";
	}else{
		url="/email/new/MailInboxList.jsp";
	}
	 url+="?isInternal="+isInternal;
	 url+="&receivemailid="+receivemailid;
	 url+="&star="+star;
	 url+="&labelid="+labelid;
	 url+="&labelidchecked="+labelidchecked;
	 url+="&folderid="+folderid;
	 url+="&receivemail="+receivemail;
	 url+="&status="+status;
	 url+="&clickObj="+clickObj;
	 url+="&quickSearch="+quickSearch;
	 url+="&checkuser="+checkuser+"";
	 url+="&subject="+subject;
	 url+="&from="+from;
	 url+="&to="+to;
	 url+="&tohrmid="+tohrmid;
	 url+="&fromhrmid="+fromhrmid;
	 url+="&attachmentnumber="+attachmentnumber;
	 url+="&startdate="+startdate;
	 url+="&enddate="+enddate;
	 url+="&mailaccountid="+mailaccountid;
	 url+="&datetype="+datetype;
	 url+="&waitdeal="+waitdeal;
	String receivemailname="";
	
	if(!receivemailid.equals("")){
		mas.setId(receivemailid);
		mas.selectMailAccount();
		if(mas.next()){
			receivemailname = mas.getAccountname();
		}
	}
	
	int index = Util.getIntValue(request.getParameter("index"),1);
	int perpage =20;
	
	mss.selectMailSetting(user.getUID());
	if(!Util.null2String(mss.getPerpage()).equals("")){
		perpage = Util.getIntValue(mss.getPerpage());
	}
	
	int layout = Util.getIntValue(mss.getLayout(),3);
	
	int main = Util.getIntValue(mss.getMainid(),-1);
	int sub = Util.getIntValue(mss.getSubid(),-1);
	int sec = Util.getIntValue(mss.getSecid(),-1);
	
	// 文档导出目录设置
	//mss.get
	mrs.resetParameter();
	
	//总邮件数
	mrs.setResourceid(user.getUID()+"");
	mrs.setFolderid(folderid);
	mrs.setSubject(subject.trim());
	mrs.setLabelid(labelid);
	mrs.setStarred(star);
	mrs.setSendfrom(from);
	mrs.setSendto(to);
	mrs.setFromhrmid(fromhrmid);
	mrs.setTohrmid(tohrmid);
	//mrs.setStatus(status);
	mrs.setAttachmentnumber(attachmentnumber);
	mrs.setMailaccountid(mailaccountid);
	mrs.setIsInternal(isInternal);
	mrs.setStartdate(startdate);
	mrs.setEnddate(enddate);
	mrs.setDatetype(datetype);
	mrs.setWaitdealid(waitdeal);
//	mrs.selectMailResourceOnlyCount();
	int totalMailCount = mrs.getRecordCount();
	//String param = {"mailsId": needfulMailsId.toString(), "operation": "cancelLabel"};
	String param ="{";
			 param+="\"folderid\":\""+folderid+"\",";
			 param+="\"subject\":\""+subject.trim()+"\",";
			 param+="\"labelid\":\""+labelid+"\",";
			 param+="\"star\":\""+star+"\",";
			 param+="\"from\":\""+from+"\",";
			 param+="\"to\":\""+to+"\",";
			 param+="\"tohrmid\":\""+tohrmid+"\",";
			 param+="\"fromhrmid\":\""+fromhrmid+"\",";
			 param+="\"attachmentnumber\":\""+attachmentnumber+"\",";
			 param+="\"mailaccountid\":\""+mailaccountid+"\",";
			 param+="\"isInternal\":\""+isInternal+"\",";
			 param+="\"startdate\":\""+startdate+"\",";
			 param+="\"enddate\":\""+enddate+"\",";
			 param+="\"datetype\":\""+datetype+"\",";
			 param+="\"waitdeal\":\""+waitdeal+"\",";
			 param+="\"status\":\""+status+"\"";
			 param+="}";

	if(receivemail.equals("true")){
		if(receivemailid.equals("0")){
			receivemailid =  mas.getAutoReceiveAccountIds(user.getUID());
		}else if(receivemailid.equals("-1")){
			receivemailid =  mas.getAllAccountIds(user.getUID());
		}
	}
	
	 
	String displayName =""; 
	if(!folderid.equals("")){
		displayName = mfs.getSysFolderName(Util.getIntValue(folderid),user.getLanguage());
		if(displayName.equals("")){
			mfs.selectMailFolderInfo(Util.getIntValue(folderid));
			if(mfs.next()){
				displayName = mfs.getFolderName();
			}
		}
	}else if(!labelid.equals("")){
		displayName = lms.getLabelInfo(labelid).getName();
	}else if(isInternal==1){
		displayName =  SystemEnv.getHtmlLabelName(24714,user.getLanguage());
	}else{
		displayName = SystemEnv.getHtmlLabelName(81337,user.getLanguage());
	}
	
	if(method.equals("dosearch")){
		displayName = SystemEnv.getHtmlLabelName(81289,user.getLanguage()); 
	}
	
	rs.execute("select innerMail ,outterMail from MailConfigureInfo");
	int innerMail = 1;
	int outterMail = 1;
	while(rs.next()){
		innerMail = rs.getInt("innerMail");
		outterMail = rs.getInt("outterMail");
	}
	
	float totalspace = 0f;
	float occupyspace = 0f; 
	if(!isSystemManager){
		rs.execute("select totalspace ,occupyspace from hrmresource where id = "+user.getUID());
		if(rs.next()){
			 totalspace = Util.getFloatValue(rs.getString("totalspace"), 0f);
			 occupyspace = Util.getFloatValue(rs.getString("occupyspace"), 0f);
		}
		if(occupyspace < 0){//没有统计数据
			String sql = "UPDATE HrmResource SET occupySpace = " +
			    " round((select sum(size_n) from MailResource where resourceid = "+user.getUID()+" and canview = 1)*1.0/(1024*1024),2)" +
				" WHERE id = "+user.getUID();
			rs.execute(sql);
			rs.execute("select totalspace ,occupyspace from hrmresource where id = "+user.getUID());
			if(rs.next()){
			    totalspace = Util.getFloatValue(rs.getString("totalspace"), 0f);
				occupyspace = Util.getFloatValue(rs.getString("occupyspace"), 0f); 
			}
		}
	}
    
	int isEml = 0;
	rs.execute("select * from MailConfigureInfo");
	while(rs.next()){
		isEml = rs.getInt("isEml");
	}
%>
<script type="text/javascript" src="/email/js/waitdeal/jquery.qtip-1.0.0-rc3.js"></script>
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<link href="/email/css/color_wev8.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<style>
*{		
	font-family:"Microsoft YaHei"!important; 
}
</style>

<!-- 遮罩层 -->
<DIV id=bgAlpha></DIV>

<div id="loading">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(31199, user.getLanguage())%>...</span>
</div>
<div id="mailListContainer" >
<div class="w-all h-all " >
	<div id="mailListTop">
	<!-- 头部start -->
	<div class="font12 color333 m-l-5 relative">
			<div id="totalOrUnread" class="left">
				<span class="btnSpan  p-l-5 p-r-5  <%if("".equals(status)){out.println(" btnSpanOver selected");}%>" target=''>
						<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
						(<span  id=totalMailCount_id></span>)
				</span>
				-
				<span class="btnSpan p-l-5 p-r-5 <%if("0".equals(status)){out.println("btnSpanOver  selected");}%>"  target='0'  id="changeBk02"  _xuhao=1>
							<!-- 未读 -->
						<%=SystemEnv.getHtmlLabelName(25396,user.getLanguage()) %>
						(<span id="unreadMailCount_id"></span>)
				</span>
			</div>
			<%if(innerMail == 1 && outterMail ==1){ %>
				<%if(!folderid.equals("")||"1".equals(star)||!"".equals(labelid)||"1".equals(waitdeal)){%>
				<div id="outerOrInner" class="left" style="margin-left: 5px;">
					<span id="Inner" class="btnSpan  p-l-5 p-r-5  <%if(isInternal==1){out.println(" btnSpanOver selected");}%>" isInternal='1'>
							<%=SystemEnv.getHtmlLabelName(24714,user.getLanguage()) %>
					</span>
					-
					<span class="btnSpan p-l-5 p-r-5 <%if(isInternal==0){out.println("btnSpanOver  selected");}%>" isInternal='0'>
							<%=SystemEnv.getHtmlLabelName(31139,user.getLanguage()) %>
					</span>
				</div>
				<%}%>
			<%}%>
			<!-- label标签显示区域start -->
			<%
					if(!"".equals(labelid)&&"1".equals(labelidchecked)){ 
						//标签id不为空，并且这个标签id来自页面，而不是来自菜单
						MailLabel  mailLabels = lms.getLabelInfo(labelid);
						String labelStr = "";
						labelStr+="<div class='label hand left' style='  background:"+mailLabels.getColor()+"'  _topmenu='1'>"
								+	"<div class='left lbName'>"+mailLabels.getName()+"</div>"
								+     "<input type='hidden' name='lableId' value='"+mailLabels.getId()+"' />"
								+     "<input type='hidden' name='mailId' value='' />"
								+	"<div class='left closeLb hand hide '   title='"+SystemEnv.getHtmlLabelName(81338,user.getLanguage())+"' name='sb'></div>"
								+ "<div class='cleaer'></div>"	
								+"</div>";
						out.println(labelStr);
						out.println("<input type='hidden' id='labelidchecked_true'>");
				}
			 %>
			<!-- label标签显示区域end -->
			
			<div id="receiveLoading" class=" h-20 left p-r-5 hide colorfff absolute" ><div class="left" style="background-image: url(/email/images/loading_wev8.gif);background-repeat:no-repeat;background-position: center;width: 20px;">&nbsp;</div><%=SystemEnv.getHtmlLabelName(81290,user.getLanguage()) %> <%=receivemailname %></div>
			<div id="receiveError" class=" h-20 left p-r-5 hide colorfff absolute" >
				<div class="left" style="width: 20px;">&nbsp;</div>
				<%=SystemEnv.getHtmlLabelName(83109,user.getLanguage()) %>！
				<a href='javascript:showmsg()' style='text-decoration:underline;'><%=SystemEnv.getHtmlLabelName(83110,user.getLanguage()) %></a>
			</div>
			<!-- 布局显示 -->
			<div class="userLayout right" id="changeBk" _xuhao=0>
				<div class="layout" value="3" _currentLayout="<%=userLayout%>" style="background:url('/email/images/layout<%=userLayout==3?"_a":""%>_3_wev8.png') no-repeat center center;"></div>
				<div class="layout" value="2" _currentLayout="<%=userLayout%>" style="background:url('/email/images/layout<%=userLayout==2?"_a":""%>_2_wev8.png') no-repeat center center;"></div>
				<div class="layout" value="1" _currentLayout="<%=userLayout%>" style="background:url('/email/images/layout<%=userLayout==1?"_a":""%>_1_wev8.png') no-repeat center center;"></div>
			</div>
			
			<!-- 空间使用量 -->
			<%if(!isSystemManager){ %>
            <div class="right">
                <% if(HrmUserVarify.checkUserRight("email:spaceSetting", user)){ %>
                <div id="spaceManage" class="m-l-10 spaceManage left"><%=SystemEnv.getHtmlLabelName(33450, user.getLanguage())%></div>
                <% } %>
    			<div class="e8_outPercent left m-l-5" title="<%=SystemEnv.getHtmlLabelName(83111,user.getLanguage()) + " " + occupyspace + "M/" + totalspace + "M" %>" style="width: 100px;margin-top: 2px;">
    				<span class="e8_innerPercent" id="schedule" style="width: 0%;"></span>
    				<span class="e8_innerText" id="scheduleValue">0.00%</span>
    			</div>
            </div>
			<%} %>
			<div class="clear"></div>
	</div>
	<div class="h-5 ">&nbsp;</div>
	<!-- 头部end -->
	
	<!-- 菜单栏--start -->
	<div id="inBoxTitle"    style="" class="m-b-3">
		
		<!-- 左边按钮-start -->
		<div class="left" style="width: 500px;padding-left:2px;">
		<%if(!folderid.equals("-3")) {%>
		<button class="btnGray1 left" style="margin-left:0px;margin-right:0px;border-right:0px;" type="button" onclick="moveMail2DelFolder()"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %></button>
		<%}%>
		<button class="btnGray1 left" style="margin-left:0px;margin-right:0px;" type="button" onclick="deleteCheckedMail()"><%=SystemEnv.getHtmlLabelName(2031,user.getLanguage()) %></button>
		<div class="btnGrayDrop relative left " id="saveAs" style="width:60px;" _xuhao=2><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage()) %>...
		</div>
		
		<ul id="saveAsMenu" class="btnGrayDropContent hide" style="position: fixed;width: 92px;" >
			<li class="item" onclick="doExportDocs(event)"><%=SystemEnv.getHtmlLabelName(19821,user.getLanguage()) %></li>
			<li class="item" onclick="doExportContacts(event)"><%=SystemEnv.getHtmlLabelName(124898,user.getLanguage()) %></li>
			<%if(isEml == 1) {%>
				<li class="item" onclick="doExportEML(event)"><%=SystemEnv.getHtmlLabelName(25986,user.getLanguage()) %></li>
			<% }%>
		</ul>
        
        <div style="display:none;">
            <!-- 文档目录选择对话框 -->
            <brow:browser viewType="0" name="seccategory" browserValue="" idKey="id" nameKey="path" language='<%=""+user.getLanguage() %>'
                _callback="cbDoExportDocs" temptitle='<%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%>'
                browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+AclManager.OPERATION_CREATEDOC %>'
                 isSingle="true" hasBrowser = "true" isMustInput='2'
                browserBtnID="selectTaohongMouldBtn"
                linkUrl="#" width="30%">
            </brow:browser>
        </div>
		
		<div class="btnGrayDrop relative left " id="signAs" style="width:60px;" _xuhao=3><%=SystemEnv.getHtmlLabelName(81293 ,user.getLanguage()) %>...
		</div>
		<ul  id="signAsMenu" class="btnGrayDropContent hide" style="position: fixed;width:100px;" >
				
				<%
					if(!folderid.equals("-2")){
				%>
				<li class="item" onclick="updateMailStatus(0,event)">
					<div style="background:url('/email/images/icon_read_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(83697 ,user.getLanguage()) %></div>
				</li>
				<li class="item" onclick="updateMailStatus(1,event)">
					<div style="background:url('/email/images/icon_unread_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(81295 ,user.getLanguage()) %></div>
				</li>
				<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
				<%} %>
				<li class="item" onclick="waitDeal(1,event)">
					<div style="background:url('/email/images/mail_wait_deal_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(83090 ,user.getLanguage()) %></div>
				</li>
				<li class="item" onclick="blacklist(1,event)">
					<div style="background:url('/email/images/mail_blacklist_set_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(31859 ,user.getLanguage()) %></div>
				</li>
				<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
				<li class="item" onclick="markStar(1,event)">
					<div style="background:url('/email/images/icon_star_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(81337 ,user.getLanguage()) %></div>
				</li>
				<li class="item" onclick="markStar(0,event)">
					<div style="background:url('/email/images/icon_unstar_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(81297 ,user.getLanguage()) %></div>
				</li>
				<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
				<%
				 	ArrayList lmsList= lms.getLabelManagerList(user.getUID());
					for(int i=0; i<lmsList.size();i++){
						MailLabel ml = (MailLabel)lmsList.get(i);
						%>
						<li class="markLabel item" title="<%=ml.getName()%>" target="<%=ml.getId()%>"><div class="m-r-5 left " style="margin-top:2px;border-radius:2px; height:10px;width:10px;margin-left:3px;background:<%=ml.getColor()%>;">&nbsp;</div><%=Util.getMoreStr(ml.getName(),4,"...") %></li>
						<%
					}
				%>
				<%
					if(lmsList.size()>0){
						%>
					<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
						<%
					}
				%>
				
				<!-- 取消所有标签--start -->
				<li class="item"  onclick="cancelLabel(this)">
					<div style="background:url('/email/images/icon_cancel_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(31219 ,user.getLanguage()) %></div>
				</li>
				<!-- 取消所有标签--end -->
				<!-- 新建并标记--start -->
				<li class="item"   onclick="createLabel(1,this)">
					<div style="background:url('/email/images/icon_add_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(31220 ,user.getLanguage()) %></div>
				</li>
				<!-- 新建并标记--end -->
		</ul>
		
		<div class="btnGrayDrop relative left " id="moveTo" style="width:60px;"><%=SystemEnv.getHtmlLabelName(78 ,user.getLanguage()) %>...
		</div>
		<ul id="moveToMenu" class="btnGrayDropContent hide" style="position: fixed;width: 92px;" >
				<li class="item" target="0"><%=SystemEnv.getHtmlLabelName(19816 ,user.getLanguage()) %></li>
				<li class="item" target="-1"><%=SystemEnv.getHtmlLabelName(19558 ,user.getLanguage()) %></li>
				<li class="item" target="-3"><%=SystemEnv.getHtmlLabelName(2040 ,user.getLanguage()) %></li>
				<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
				<%
					ArrayList folderList= fms.getFolderManagerList(user.getUID());
					for(int i=0; i<folderList.size();i++){
						MailFolder mf = (MailFolder)folderList.get(i);
						%>
						<li class="item" target="<%=mf.getId()%>"><%=Util.getMoreStr(mf.getFolderName(), 4, "...") %></li>
						<%
					}
				%>
				<%
					if(folderList.size()>0){
						%>
					<li style="height: 10px;"><div class="line-1 m-t-5"></div></li>
						<%
					}
				%>
				<!-- 新建并移动--start -->
				<li class="newitem"  onclick="createLabel(2,this)">+<%=SystemEnv.getHtmlLabelName(31221 ,user.getLanguage()) %></li>
				<!-- 新建并移动--end -->
			</ul>
		<%if(waitdeal.equals("1")) {%>
			<button class="btnGray1 left" style="margin-left:0px;margin-right:0px;" type="button" onclick="waitDealComplete()"><%=SystemEnv.getHtmlLabelName(83112 ,user.getLanguage()) %></button>
		<%}%>
		<%
			boolean isshowacc = false;
			if(isInternal != 1)isshowacc = true;
			MailAccountService mas2 = new MailAccountService();
			mas2.setUserid(user.getUID()+"");
			mas2.selectMailAccount();
			String defaultMailAccount = SystemEnv.getHtmlLabelNames("82857,20869,23845",user.getLanguage()); 
			boolean isallAccount = false;
			while(mas2.next()){
				if(mailaccountid.equals(mas2.getId())){
					defaultMailAccount = Util.getMoreStr(mas2.getAccountname(), 9, "...");
					isallAccount = true;
				}
			}
		%>
		
		<div class="btnGrayDrop relative left " id="mailte" style="width:140px;<%if(!isshowacc)out.print("display:none"); %>" _xuhao=3><%=defaultMailAccount %>
		</div>
		<ul  id="mailtemp" class="btnGrayDropContent hide" style="position: fixed;width:150px;<%if(!isshowacc)out.print("display:none"); %>" >
		<%if(isallAccount) { %>
			<li class="item" target="" title="<%=SystemEnv.getHtmlLabelNames("82857,20869,23845",user.getLanguage()) %>" mail="<%=SystemEnv.getHtmlLabelNames("82857,20869,23845",user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelNames("82857,20869,23845",user.getLanguage()) %></li>
		<% }%>
		<%
			MailAccountService mas3 = new MailAccountService();
			mas3.setUserid(user.getUID()+"");
			mas3.selectMailAccount();
			while(mas3.next()){
		%>
			<li class="item" target="<%=mas3.getId()%>" title="<%=mas3.getAccountname() %>" mail="<%=Util.getMoreStr(mas3.getAccountname(), 9, "...") %>"><%=Util.getMoreStr(mas3.getAccountname(), 9, "...") %></li>
			<%
			}
			%>
		</ul>			
		<!-- 邮件规则--start -->
		<button class="btnGray1 left" style="display:none;" type="button" onclick="popAddMailRule(this)" id="changeBk04" _xuhao=4>
		<%=SystemEnv.getHtmlLabelName(19828 ,user.getLanguage()) %>
		</button>
		<!-- 邮件规则--end -->
		</div>
		<!-- 左边按钮-end -->
		
		<div class="right m-r-5 m-l-5" style="height:22px; border:1px solid #dadada;" id="changeBk05" _xuhao="5">
			<div class="left ">
				<input type="text" class="w-80 p-l-5" style="height:22px!important;font-weight: normal;font-size: 12px;border:0px;" id="keyword" value="<%=subject%>" onchange="$('#subject').val(this.value)" />
			</div>
			<div class="left  hand "  style="height:18px;">
				<div class="w-20" style="height:18px;background: url(/email/images/btn_search_wev8.png) center center no-repeat;margin-top:3px;" onclick="$('#highSearchForm')[0].submit()"></div>
				<form id="highSearchForm" name="highSearchForm" action="/email/new/MailInboxListMain.jsp" method="post">
				<!-- clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索 -->
				<input name="clickObj"  id="clickObj" type="hidden" value="0"/>
				<input name="folderid" id="folderid" type="hidden" value="<%=folderid%>"/>
				<input name="labelid" id="labelid" type="hidden" value="<%=labelid%>"/>
				<input name="labelidchecked" id="labelidchecked" type="hidden" value="<%=labelidchecked %>"/>
				<input name="star" id="star" type="hidden" value="<%=star%>"/>
				<input name="waitdeal" id="waitdeal" type="hidden" value="<%=waitdeal%>"/>
				<input name="method" id="method" type="hidden" value="dosearch"/>
				<input name="perpage" id="perpage" type="hidden" value="<%=perpage%>"/>
				<input name="isInternal" id="isInternal" type="hidden" value="<%=isInternal%>"/>
				<input name ="index"  id="index" type="hidden" value="<%=index %>"/>
				<input name ="totalPage"  id="totalPage" type="hidden" value=""/>
				<input name="isInternal" id="isInternal" type="hidden" value="<%=isInternal%>"/>
				<!-- 默认排序字段，排序规则 -->
				<input name ="sortColumn"  id="sortColumn" type="hidden" value="senddate"/>
				<input name ="sortType"  id="sortType" type="hidden" value="DESC"/>
				<!-- 缓存当前切换的url -->
				<input type="hidden" id="comurl" value="<%=url%>"/>
				
				<div id="highSearchDiv" name="highSearchDiv" _status="0" class="hide " style="position:fixed; top:55px;right:0px; border: 1px solid #DADADA;background: #fff;z-index: 999;">
					
					<wea:layout type="4col">
						<wea:group context="<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>">
							<wea:item><%=SystemEnv.getHtmlLabelName(344 ,user.getLanguage()) %></wea:item>
							<wea:item>
								<input class="w-180" type="text" id="subject" name="subject" value="<%=subject%>"/>
							</wea:item>
							
							<wea:item><%=SystemEnv.getHtmlLabelName(2034 ,user.getLanguage()) %></wea:item>
							<wea:item >
								<%
									if(!fromhrmid.equals("")){
										
										ResourceUtil ru = new ResourceUtil();
										from = ru.getHrmShowName(fromhrmid);
									}
								%>
								<input class="w-180" type="text" id="from" name="from" onchange="$('#fromhrmid').val('');" target="fromhrmid" value="<%=from %>" />
								<input class="w-180" type="hidden" id="fromhrmid" name="fromhrmid" value="<%=fromhrmid %>" /> 
							</wea:item>
							
							<wea:item><%=SystemEnv.getHtmlLabelName(2046 ,user.getLanguage()) %></wea:item>
							<wea:item >
								<%
									if(!tohrmid.equals("")){
										
										ResourceUtil ru = new ResourceUtil();
										to = ru.getHrmShowName(tohrmid);
									}
								%>
								<input class="w-180" type="text" id="to" name="to" onchange="$('#tohrmid').val('');" target="tohrmid" value="<%=to%>"/>
								<input class="w-180" type="hidden" id="tohrmid" name="tohrmid" value="<%=tohrmid%>"/> 
							</wea:item>
					        
							<wea:item><%=SystemEnv.getHtmlLabelName(19844 ,user.getLanguage()) %></wea:item>
							<wea:item >
								<select name="attachmentnumber" id="attachmentnumber" class="w-150">
									<option value="" <%if(attachmentnumber.equals("")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="1" <%if(attachmentnumber.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(346 ,user.getLanguage()) %></option>
									<option value="0" <%if(attachmentnumber.equals("0")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(15507 ,user.getLanguage()) %></option>
								</select>
							</wea:item>
							
							<wea:item><%=SystemEnv.getHtmlLabelName(23845 ,user.getLanguage()) %></wea:item>
							<wea:item >
								<select id="mailaccountid" name="mailaccountid" class="w-150">
										<option value="" <%if(mailaccountid.equals("")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<%
										mas.clear();
										mas.setUserid(user.getUID()+"");
										mas.selectMailAccount();
										while(mas.next()){
											%>
											<option value="<%=mas.getId()%>" <%if(mailaccountid.equals(mas.getId())) out.print("selected"); %>><%=mas.getAccountname() %></option>
											<%
										}
										%>
										
									</select>
							</wea:item>
							
							<wea:item><%=SystemEnv.getHtmlLabelName(18958 ,user.getLanguage()) %></wea:item>
							<wea:item attributes="{'colspan':'3'}">
								<select name="status" id="status" class="w-150">
										<option value="" <%if(status.equals("")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<option value="1" <%if(status.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(25425 ,user.getLanguage()) %></option>
										<option value="0" <%if(status.equals("0")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(25396 ,user.getLanguage()) %></option>
								</select>
							</wea:item>
							
							<wea:item><%=SystemEnv.getHtmlLabelName(18002 ,user.getLanguage()) %></wea:item>
							<wea:item >
								<span>
									<SELECT name="datetype" id="datetype" onchange="onChangetype(this)" class="w-100">
									  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
									  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
									  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
									  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
									  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
									  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
									</SELECT>   
								</span>
							
								<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
							        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)"></button>
									<span id="startdatespan"><%=startdate%></span>
									<input type="hidden" id="startdate" name="startdate" value="<%=startdate%>"/>
									
									－
									<button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)"></button>
									<span id="enddatespan"><%=enddate%></span>
									<input type="hidden" id="enddate" name="enddate" value="<%=enddate%>"/> 
								</span>
							</wea:item>
						</wea:group>
						
						<wea:group context="" attributes="{'Display':'none'}">
							<wea:item type="toolbar">
								<input type="button" class="e8_btn_submit" onclick="submitdata()" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" id="searchBtn"/>
								<span class="e8_sep_line">|</span>
								<input type="button" onclick="resetConditionmail(highSearchDiv);" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
								<span class="e8_sep_line">|</span>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
							</wea:item>
						</wea:group>
						
					</wea:layout>		
				</div>
				</form>
			</div>
			<div class="left" id="showHighSearch" style="padding-left:4px;padding-right:4px;border-left:1px solid #dadada;font-size:12px;text-align:center;height:22px;line-height:22px;cursor:pointer;">
				<%=SystemEnv.getHtmlLabelName(347 ,user.getLanguage()) %>
			</div>
		</div>
		
		
		
		
		<div class=" right font12 relative"  style="border:1px solid #dadada;">
			<div class="btnPage left f-s-16" style="border-left:0px solid #dadada;color:<%=index<=1?"#B1ABAB":"#555555" %>" id="prevPageBtn" onclick="prevPage()">&lt;</div>
			<div class="btnPage left f-s-16" onclick="nextPage()" style="color:<%=index>=0?"#B1ABAB":"#555555" %>" id="nextPageBtn">&gt;</div>
			<div class="btnPage left" style="background:#3ac0ff;color:#fff;width:auto;">
				<div style="margin:3px 10px 0px 10px;">
					<span id="currentIndex"><%=index %></span>/<span id="totalPageIndex"></span>
				</div>	
			</div>
			<div class="btnPage left" style="width:30px;">
				<input type="text" name="goto" id="goto" class="gototxt" value="<%=index %>"/>
			</div>
			<div class="btnPage left gotobtn" onclick="gotoPage()">
			</div>
			<div class="clear"></div>
		</div>

			<div style="clear: both;height: 0px">&nbsp;</div>
	</div>
	


		
		
		<table cellspacing="0" cellpadding="0" style="table-layout:fixed;width:100%;*width:auto;border-collapse:none" class="O2">
			<tbody>
				<tr>
					<td style="padding:1px 0 1px 5px;" width="27">
					
						<input id="selectAll" type="checkbox" title="<%=SystemEnv.getHtmlLabelName(2241 ,user.getLanguage()) %>/<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage()) %>"/>
					</td>
					<td class="o_title2" style="width:6px;font-size:1px;padding:0;">&nbsp;</td>
					<td style="width:40px;padding:0;"><div class='cir left ' style='width: 7px;height:15px;' >&nbsp;</div><div class="ico_mailtitle">&nbsp;</div></td>
					<%if(userLayout==2) { %>
					<td class="o_title2" style="width:20%;<%=folderid.equals("-1")||folderid.equals("-2")?"":"cursor:pointer;"%>;" <%=folderid.equals("-1")||folderid.equals("-2")?"":"onclick=\"mailSort(this,'from')\""%> name="state"><%=folderid.equals("-1")||folderid.equals("-2")?SystemEnv.getHtmlLabelName(2046 ,user.getLanguage()):SystemEnv.getHtmlLabelName(2034 ,user.getLanguage())%></td>
					<%} else { %>
					<td class="o_title2" style="width:20%;<%=folderid.equals("-1")||folderid.equals("-2")?"":"cursor:pointer;"%>" <%=folderid.equals("-1")||folderid.equals("-2")?"":"onclick=\"mailSort(this,'from')\""%> name="state"><%=folderid.equals("-1")||folderid.equals("-2")?SystemEnv.getHtmlLabelName(2046 ,user.getLanguage()):SystemEnv.getHtmlLabelName(2034 ,user.getLanguage())%></td>
					<%} %>
					<td class="o_title2" style="cursor:pointer;" onclick="mailSort(this,'subject')" name="state"><%=SystemEnv.getHtmlLabelName(344 ,user.getLanguage()) %></td>
					<td class="o_title2" style="padding-left:2px;width:100px;cursor:pointer;"   onclick="mailSort(this,'date')" name="state"><span style="margin-left:10px;"><%=SystemEnv.getHtmlLabelName(25130 ,user.getLanguage()) %></span></td><td style="width:20px;font-size:1px;padding-left:2px">&nbsp;</td>
				</tr>
			</tbody>
		</table>
		</div>
		<div id="mailList" style="position: relative;overflow:auto;"> 
		
		</div>
		<!-- group end -->
	
	<input type="hidden" name="selectedAccountIds" id="selectedAccountIds"/>
</div>
</div>
<div id="mailContentContainer">
</div>
	<div id='mailaddrdiv' style="text-align: left;position:absolute; background-color: #ffffff;border:1px solid #DADADA;z-index:10;display:none;">
		<div class="mailaddarrow" style="background:url('/email/images/mail_box_sharp.png'); no-repeat;position:absolute;top: -7px;left: 30px;width: 14px;height: 7px;"></div>
		<div id="mailaddrname" style="height:26px;line-height:26px;padding-left:10px;"></div>
		<div id='mailaddrspan' style="height:26px;line-height:26px;padding-left:10px;"></div>
		<div style="border-top:1px solid #dadada;height:30px;line-height: 30px;">
			<div style="float:left;height:100%;width:100px;text-align: center;border-right: 1px solid #dadada;">
				<a href="javascript:void(0);" id='writeletterbtn'><%=SystemEnv.getHtmlLabelName(81300 ,user.getLanguage()) %></a>
			</div>
			<div style="float:left;height: 100%;width:100px;text-align: center;">
				<a href="javascript:void(0);" id='addblackbtn'><%=SystemEnv.getHtmlLabelName(124900 ,user.getLanguage()) %></a>
			</div>
			<div style="clear:both"></div>
		</div>
	</div>

<!-- 添加过滤规则 -->
<div id="addMailRule" name="addMailRule" style="height: 250px; overflow-y: auto;display:none"></div>
<!-- 静态初始化一个leanModal遮罩 -->
<div id="lean_overlay"></div>
<iframe id="<%=userLayout == 3 ? "downLoadFrame" : "downLoadFrame_eml" %>" style="display:none;"></iframe>
<div class="maskguidelist" id="maskguidelist"></div>

<script>
var checkuser="<%=checkuser%>";
var userLayout="<%=userLayout%>";
jQuery(document).ready(function(){

	if(userLayout=="3"&&checkuser=="false"){
		//$("#maskguide").height("47px");
		//$(this).joyride({"postStepCallback":nextWizard,"postRideCallback":finishALL,"inline":"true"});
	}
	if(userLayout=="1"||userLayout=="2"){
		$("#clickshowjoy").hide();
	}else{
		$("#mailList").css("height",$("body").height()-$("#mailListTop").height());
		$("#clickshowjoy").show();
	}
	
	$(".layout").hover(function(){
		var layout=$(this).attr("value");
		var currentLayout=$(this).attr("_currentLayout");
		if(layout==currentLayout) return;
		$(this).css("background-image","url('/email/images/layout_a_"+layout+"_wev8.png')");
	},function(){
		var layout=$(this).attr("value");
		var currentLayout=$(this).attr("_currentLayout");
		if(layout==currentLayout) return;
		$(this).css("background-image","url('/email/images/layout_"+layout+"_wev8.png')");
	});
	
	$(".layout").click(function(){
		var tempjie=$(this).attr("value");
		if($(this).attr("value")==$("#comcss").val()){
			return;
		}else{
			
			$.post("/email/new/MailManageOperation.jsp",{operation:"editLayout",layout:$(this).attr("value")},function(){
				//刷新树菜单的布局的值
				try{
					window.parent.parent.changeUserLayout(tempjie);
				}catch(e){
						try{
							//说明是老版的模式查看
							window.parent.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.changeUserLayout(tempjie);	
						}catch(e){
							//左右树形结构查看
							try{
								window.parent.parent.document.getElementById("mailFrameLeft").contentWindow.changeUserLayout(tempjie);
							}catch(e){}
						}	
			
				}
				
				var url="";
				if(tempjie=="1"||tempjie=="2"){
						url=$("#comurl").val().replace("MailInboxList.jsp","MailInboxListMain.jsp");
						$("#clickshowjoy").hide();
						//alert("1-2"+url);
				}else{
						url=$("#comurl").val().replace("MailInboxListMain.jsp","MailInboxList.jsp");
						$("#clickshowjoy").show();
						//alert("3"+url);
				}
				//addClass
				$("#changeBk").removeClass("userLayout1");
				$("#changeBk").removeClass("userLayout2");
				$("#changeBk").removeClass("userLayout3");
				//设置为缓存的css
				$("#comcss").val(tempjie);
				$("#changeBk").addClass("userLayout"+tempjie);
				
				window.location.href=url;
			})
			
		
		}
	})
	
	$('#to').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
		minChars: 1,
		scroll: true,
		//max:30,
		width:400,
		multiple:"",
		matchSubset: false,
	    scrollHeight: 280,
		matchContains: "word",
		autoFill: false,
		formatItem: function(row, i, max) {
			return  row.name +"&lt;"+row.department+"&gt;";
		},
		formatMatch: function(row, i, max) {
			return row.name+ " " + row.pinyin+ " " + row.loginid;
		},
		formatResult: function(row) {
			return row.name;
		}
	})
	
	$('#from').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
		minChars: 1,
		scroll: true,
		//max:30,
		width:400,
		multiple:"",
		matchSubset: false,
	    scrollHeight: 280,
		matchContains: "word",
		autoFill: false,
		formatItem: function(row, i, max) {
			return  row.name +"&lt;"+row.department+"&gt;";
		},
		formatMatch: function(row, i, max) {
			return row.name+ " " + row.pinyin+ " " + row.loginid;
		},
		formatResult: function(row) {
			return row.name;
		}
	})
	
	
	
	$(".btnSpan").hover(
			function(){$(this).addClass("btnSpanOver")},
			function(){if(!$(this).hasClass('selected'))$(this).removeClass("btnSpanOver")}
	).click(function(){
			var parentid=$(this).parent().attr("id");
			//全部-未读
			if(parentid=="totalOrUnread"){
				$("#totalOrUnread .selected").removeClass("selected").removeClass("btnSpanOver");
				$(this).addClass("selected");
				showMail(); 
			}
			//内部-外部
			if(parentid=="outerOrInner"){
				if($(this).hasClass("selected"))
				   	$(this).removeClass("selected");
				else{   
					$("#outerOrInner .selected").removeClass("selected").removeClass("btnSpanOver");
					$(this).addClass("selected");
				}
				showMail(); 
			}
			
	});
	
	/*初始化搜素下拉框*/
	/*
	$("select").tzSelect({
		 selectClick:function(dropDown){
		 	$(".tzSelect .dropDown").each(function(){
		 	    if(this!=dropDown[0])
		 		   $(this).trigger('hide');
		 	});
			dropDown.trigger('toggle');
		 }
	});
	*/
	if('<%=receivemail%>'=='true' && '<%=outterMail%>' == 1){
		setAutoMailAccountId();
	}
	loadMailListContent($("#index").val());
	//标记指定邮件
	$(".markLabel").bind("click", function(){
		$(".btnGrayDropContent").hide();
		stopEvent();
		var self = $(this);
		
		var mails = getCheckedMailList();
		if(mails=="") {
			//请选中邮件
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226  ,user.getLanguage()) %>!");
			return;
		}
		var needfulMailsId = new Array();
		for(var i=0; i<mails.length; i++){
			var isExist = false;
			var tempId = mails[i].id;
			var lables = mails[i].lables;
			for(var j=0; j<lables.length; j++){
				if(lables[j]==self.attr("target")){
					isExist = true;
					break;
				}
			}
			if(!isExist){
				needfulMailsId.push(tempId);
			}
		}
		//判断是否存在需要添加标签的邮件
		if(needfulMailsId.length==0){
			//您选中的邮件已经添加过该标签了
			//
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31227,user.getLanguage()) %>!")
			return;
		}
		var param = {"mailsId": needfulMailsId.toString(), "operation": "addLable", "lableId": self.attr("target")};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			loadMailListContent($("index").val());
		});
	});
	
	//移动指定邮件
	$("#moveToMenu").find(".item").bind("click", function(event){
		$(".btnGrayDropContent").hide();
		stopEvent();
		var mails = getCheckedMailIds();
		
		if(mails!="") {
			var folderid = $(this).attr("target")
			if(mails==""){
				return;
			}
			moveMailToFolder2(mails,folderid)
		} else {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
		}
	});
	
	$("#mailtemp").find(".item").bind("click", function(event){
		$(".btnGrayDropContent").hide();
		stopEvent();
		var target = $(this).attr("target");
		var mail = $(this).attr("mail");
		var title = $(this).attr("title");
		loadSelAccMail(target,mail,title);
	});
	
	// 绑定高级搜索显示
	$("#showHighSearch").bind("click",function(event){
		 var x=$(this).offset().left
		 var y=$(this).offset().top
		 //alert($(this).offset().left);
		 $("#highSearchDiv").css("top",y+25);
		 $("#highSearchDiv").css("left",0);
		 
		 if("<%=userLayout%>"!="3")
		 	$("#highSearchDiv").css("width",$(".northDiv").width()-2);
		 	
		 var status=$("#highSearchDiv").attr("_status");
		 if(status=="1"){	
		 	$("#cancel").click();
		 }else{
		 	$("#highSearchDiv").show();
		 	$("#highSearchDiv").attr("_status","1");
		 }	
		stopEvent(); 
	})
	
	$("#cancel").bind("click",function(event){
		$("#highSearchForm")[0].reset();  
		$("#highSearchDiv").hide();
		$("#highSearchDiv").attr("_status","0");
		stopEvent();
	})
	
	//绑定导出为按钮事件
	$("#saveAs").bind("click",function(event){
		 var x=$(this).offset().left
		 var y=$(this).offset().top
		 //alert($(this).offset().left);
		 $("#saveAsMenu").css("top",y+25);
		 $("#saveAsMenu").css("left",x);
		 
		$(".btnGrayDropContent").hide();
		$("#saveAsMenu").show();
		
		stopEvent();
	})
	
	$("#signAs").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		 var x=$(this).offset().left;
		 var y=$(this).offset().top;
		 //alert($(this).offset().left);
		 $("#signAsMenu").css("top",y+25);
		 $("#signAsMenu").css("left",x);
		 $("#signAsMenu").show(); 
		stopEvent();
	})
	
	$("#moveTo").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		var x=$(this).offset().left
		var y=$(this).offset().top
		 //alert($(this).offset().left);
		$("#moveToMenu").css("top",y+25);
		$("#moveToMenu").css("left",x);
		$("#moveToMenu").show();
		stopEvent();
	})
	
	$("#mailte").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		var x=$(this).offset().left
		var y=$(this).offset().top
		 //alert($(this).offset().left);
		$("#mailtemp").css("top",y+25);
		$("#mailtemp").css("left",x);
		$("#mailtemp").show();
		stopEvent();
	})
	
	$(document).bind("click",function(){
		//这个地方为什么要重置，导致翻页有问题
		//$("#highSearchForm")[0].reset();  

		//$("#highSearchDiv").hide();
		$(".btnGrayDropContent").hide();
	})
 	
 	jQuery('body').jNice();
 	
 	$(".mailitem").live("mouseover",function(){
 		$(this).css("background","#F5FAFB");
 	}).live("mouseout",function(){
 		$(this).css("background","#fff");
 	});
 	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
 	
});

function loadSelAccMail(account,mail,title) {
	$('#mailaccountid').val(account);
	$('#mailte').html(mail);
	$('#mailte').attr("title",title);
	submitdata();
}	
		
function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

//邮件批量星标功能操作
function markStar(star,event){
	$(".btnGrayDropContent").hide();
	stopEvent(); 
	var mailids = getCheckedMailIds();
	if(mailids!=""){
		var param = {"mailId": mailids, "star": star, "operation": "updateStar"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			loadMailListContent($("index").val());
		});
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}
}

var diag=null;
//邮件待办
var closeDialog1 = function() {
		if(diag){
			diag.close();
			loadMailListContent($("index").val());
			mailUnreadUpdate();
		}
	};
	
function waitDeal(){
	$(".btnGrayDropContent").hide();
	stopEvent(); 
	var mailids = getCheckedMailIds();
	showWaitDeal(mailids);
}


function showWaitDeal(mailids) {
	if(mailids!=""){
	    var title="<%=SystemEnv.getHtmlLabelName(83114,user.getLanguage()) %>";
		diag=getMailWaitDealDialog(title,400,500);
		diag.URL = "/email/new/MailWaitDeal.jsp?mailids="+mailids;
		diag.show();
		document.body.click();
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}
}

function getMailWaitDealDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:400;	
	diag.Height =height?height:500;
	diag.ShowButtonRow=false;
	diag.Title = title;
	return diag;
} 

//添加黑名单
function blacklist() {
	$(".btnGrayDropContent").hide();
	stopEvent(); 
	var mailids = getCheckedMailIds();
	if(mailids!=""){
		var param = {"mailIds": mailids, "operation": "addblacklist"};
		$.post("/email/MailOperation.jsp", param, function(){
			loadMailListContent($("index").val());
			RefreshCount();
		});
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}

}
//移动到垃圾箱
function movetodustbin() {
	$(".btnGrayDropContent").hide();
	stopEvent(); 
	var mailids = getCheckedMailIds();
	if(mailids!=""){
		var param = {"mailIds": mailids, "operation": "movetodustbin"};
		$.post("/email/MailOperation.jsp", param, function(){
			loadMailListContent($("index").val());
		});
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}


}


function showmailaddrdiv(ev, obj) {
	var oEvent=ev||event; 
	var oTop=(oEvent.clientY+15)+'px';
	//alert(obj.offset().left);
	$('#mailaddrdiv').css("left",obj.offset().left + (obj.width()/2));
	$('#mailaddrdiv').css("top",obj.offset().top + 17);	
	$('#mailaddrspan').html(obj.attr('rel'));
	$('#mailaddrname').html('<strong>'+obj.attr('re1l')+'</strong>');
	
	$('#mailaddrdiv .mailaddarrow').css({"left:":obj.offset().left+($(obj).width()/2)});
	
	$('#addblackbtn').click(function(){
			addBlackInfo(obj.attr('rel'));
	});
	$('#writeletterbtn').click(function(){
			openShowNameHref(obj.attr('rel'),$(this),obj.attr('isInternal'));
	});
	$('#mailaddrdiv').show();
}

function openShowNameHref(to,type){
	if(type==1){
		window.parent.addTab("1","/email/new/MailAdd.jsp?to="+to,"<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}else{
		window.parent.addTab("1","/email/new/MailAdd.jsp?to="+to+"&isInternal=0","<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}
}

//添加黑名单
function addBlackInfo(mailaddr) {
	var str="该邮箱已经收发的所有邮件将会自动进入到垃圾箱中，且不能自动恢复到原位置，请确定是否把该邮箱添加到黑名单中?";
	window.top.Dialog.confirm(str,function(){
		var param = {"mailaddress": mailaddr, "operation": "saveblacklist"};
		$.post("/email/MailOperation.jsp", param, function(){
			$('#mailaddrdiv').hide();
			loadMailListContent($("index").val());
			RefreshCount();
		});
	});
		
}


function initwaitdeal() {
		//邮件标题提示框控制
		$(".mailaddresstitle").bind("mouseenter",function(){
				showmailaddrdiv(event, $(this));
		});
		
		$(".mailaddresstitle").bind("mouseleave",function(){
			setTimeout(function(){
				if(!$('#mailaddrdiv').is(":hover")){
					$('#addblackbtn').unbind("click");
					$('#mailaddrdiv').hide();
				}
			},'500');
			
		});
		
		$("#mailaddrdiv").bind("mouseleave",function(){
			
			if(!$('.mailaddresstitle').is(":hover")){
				$('#addblackbtn').unbind("click");
				$('#mailaddrdiv').hide();
			}
			
		});

		// 使用each（）方法来获得每个元素的属性
	$('.nameInfo').each(function(){
		$(this).qtip({
			content: {
				// 设置您要使用的文字图像的HTML字符串，正确的src URL加载图像
	//			text: '<img class="throbber" src="images/throbber.gif" alt="Loading..." />',
				url: $(this).attr('rel'), // 使用的URL加载的每个元素的rel属性
				title:{
					text: $(this).attr("title"), // 给工具提示使用每个元素的文本标题
					button: '关闭' // 在标题中显示关闭文字按钮
				}
			},
			position: {
				corner: {
					target: 'bottomMiddle', // 定位上面的链接工具提示
					tooltip: 'topMiddle'
				},
				adjust: {
					screen: true // 在任何时候都保持提示屏幕上的
				}
			},
			show: { 
				when: 'click', //或click 
				solo: true // 一次只显示一个工具提示
			},
			hide: 'unfocus',
			style: {
				tip: true, // 设置一个语音气泡提示在指定工具提示角落的工具提示
				border: {
					width: 0,
					radius: 4
				},
				name: 'light', // 使用默认的淡样式
				width: 450, // 设置提示的宽度
				height: 110
			}
		})
	});
	
}

function bindwait() {
	jQuery('.mailtr').hover(function(){
		var isVisible = jQuery(this).find('.nameInfo').is(':visible');  //是否已设置过待办
		if(!isVisible)
			jQuery(this).find('.setwaitdealdiv').show();
	}, function(){
		jQuery(this).find('.setwaitdealdiv').hide();
	});

}

function loadMailListContent(index){
	var t;
	var formData=$("#highSearchForm").serialize();
	showLoading(1);
	RefreshCount();
	jQuery("#mailList").load("/email/new/MailListContent.jsp?"+new Date().getTime(),formData, function(){
		//初始化邮件待办处理窗口
		initwaitdeal();
		bindwait();
		//初始化标星按钮
		initStarTarget2();
		//初始化标签相关响应
		initLableTarget2();
		//全选和取消全选
		initSelectAll();
		//上下和左右排版时，并且是第一页时，默认选中第一行邮件
		if(<%=layout%>==1 || <%=layout%>==2) {
			/*
			if($("#index").val()==1) {
				initSelectedFirstMail();
			}else if ($("#index").val()==0){
				$("#centerFrame").attr("src",'');
			}
			*/
			$("#centerFrame").attr("src",'/email/new/noticeSelectMail.jsp');
		}
		//用非文件夹为入口查看时，为草稿邮件添加前缀。
		if(<%=folderid.equals("")%>) {
			//220
			$("div#mailList").find("div#draft").prepend("(<%=SystemEnv.getHtmlLabelName(220,user.getLanguage()) %>)");
		}
		
		$(".label").mouseenter(function(){
			var obj = $(this);
			t=setTimeout(function(){
				
				$(obj).find(".closeLb").show();
			},500);
		}).mouseleave(function(){
			var obj = $(this);
			
			$(obj).find(".closeLb").hide();
			clearTimeout(t);
			
		});
		changeCheckboxStatus($("#selectAll")[0],false);
		showLoading(0);
		
		jQuery('body').jNice();
		
	});
}

//选中第一行邮件
function initSelectedFirstMail() {
	$("div#mailList table:first").find("div.title").addClass("bold").click();
}

function ctwMail(mailId,obj) {
	var url ="/email/new/MailAdd.jsp?id="+ mailId +"&flag=4";
	
	window.parent.addTab("2",url,obj.innerHTML,"s_"+mailId);
	
}

function viewMail(mailId,obj){

	$('.activeMail').removeClass('activeMail');
	$(obj).parents(".mailitem").addClass('activeMail');

	//只有草稿箱的邮件和平铺的邮件点击打开一个新的弹出tab页
	 var url = "/email/new/MailView.jsp?mailid="+mailId+"&folderid=<%=folderid%>&loadjquery=1";
	jQuery(obj).removeClass("bold")
	if(<%=layout%>==3){//平铺
		window.parent.addTab("2",url,jQuery(obj).html(),"s_"+mailId);
	}else{
		$("#centerFrame").attr("src",url);
	}
	setTimeout(function(){
		// 刷新总数据和未读数据
 		RefreshCount();
	},500);
	jQuery(obj).parents(".mailitem").find("div.Ru").removeClass("Ru").addClass("Rr");
}

function setAutoMailAccountId(){
	if("<%=receivemailid%>"=="") return false;
	jQuery("#selectedAccountIds").val("<%=receivemailid%>");
	getMail();
}

// 收取邮件
function getMail(){
	if(<%=space%> <= 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83075,user.getLanguage()) %>");
		return;	
	}
	var ids = jQuery("#selectedAccountIds").val();
	var ids2 = ids.split(",");
	var len = ids2.length;
	var status=0;
	var receivedMailCount=0;
	for(var i=0;i<ids2.length;i++){
		jQuery("#receiveLoading").show();
		jQuery.post("/email/MailOperationGet.jsp?operation=get&mailAccountId=" + ids2[i],function(data){
			if(data.receivedMailNumber == '0'){
				jQuery("#receiveLoading").hide();
				return;
			}
		
			var receivedMailNumber=data.receivedMailNumber;
			receivedMailCount+=receivedMailNumber;
			if(receivedMailNumber==-1){
				mailOperationGetHandler(data);
			   jQuery("#receiveLoading").hide();
			   $("#receiveError").show();
			   return ;
			}
			len--;
			if(len==0){
				jQuery("#receiveLoading").hide();
				if(receivedMailCount>0){
					loadMailListContent($("index").val()); // 刷新总数据和未读数据
					RefreshCount();
				}
			}
		},"json")
	}
}

/**
*	mailErrorCache 错误信息缓存对象 
*	shunping.fu
*/
var mailErrorCache = {};
function mailOperationGetHandler(data) {
	if(typeof(data.msg) == 'undefined') 
		return;
	
	mailErrorCache = data.msg;
}

var errordiag=null;

//邮件接收错误信息
function showmsg() {
	$(".btnGrayDropContent").hide();
	
	var title="<%=SystemEnv.getHtmlLabelName(25700,user.getLanguage())%>";
	errordiag=getMailWaitDealDialog(title,400,450);
	errordiag.URL = "/email/new/MailErrorWin.jsp?solution=" + mailErrorCache.solution + "&errorString=" + mailErrorCache.errorString + "&mailaccid=" + mailErrorCache.mailaccid;
	errordiag.show();
	document.body.click();
}


//星标功能
function initStarTarget2(){
	$("td.fg").bind("click", function(){
		var self = this;
		var mailId = $(self).find("input[name=mailId]").val();
		if($(self).hasClass("fs1")) {
			var param = {"mailId": mailId, "star": 0, "operation": "updateStar"};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				$(self).removeClass("fs1");
				$(self).attr("title","<%=SystemEnv.getHtmlLabelName(81337 ,user.getLanguage()) %>")
			});
		} else {
			var param = {"mailId": mailId, "star": 1, "operation": "updateStar"};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				$(self).addClass("fs1");
				$(self).attr("title","<%=SystemEnv.getHtmlLabelName(81297 ,user.getLanguage()) %>")
			});
		}
	});
}

//标签功能
function initLableTarget2(){
	//初始化标签中的closeLb按钮
	$(".label").find(".closeLb").bind("click", function(){
		var self = this;
		var hisParent = $(self).parent();
		var mailId = $(hisParent).find("input[name=mailId]").val();
		var lableId = $(hisParent).find("input[name=lableId]").val();
		var param = {"mailId": mailId, "lableId": lableId, "operation": "removeLable"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			$(hisParent).remove();
		});
	});
	
	$(".label").bind("click",function(e){
		var _e =e.target; 		 
		//点击的顶部的标签并且触发改事件的对象是close的DIV
		if($(this).attr("_topmenu")=="1"&&_e.getAttribute("name")=="sb"){
				//$("#labelid").val("");
				//$('#highSearchForm')[0].submit(); 
				window.parent.location="/email/new/MailInBox.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime();
		}else if($(this).attr("_conmenu")=="1"&&_e.getAttribute("name")=="nb"){
				//当用户点击列表中的标签关闭按钮时，不触发表单提交事件
		}
		else{
				$("#labelid").val($(this).find("input[name='lableId']").val());
				//表示标签是在页面点击出来的，而不是通过超链接点击出来的
				$("#labelidchecked").val("1");
				$('#highSearchForm')[0].submit();
		}
	})
	
	
}

//全选和取消全选
function initSelectAll() {
	$("input#selectAll").bind("click", function(){
		if(this.checked) {
			$("div#mailList").find(":checkbox").each(function(){
				changeCheckboxStatus(this,true)
			});
		} else {
			$("div#mailList").find(":checkbox").each(function(){
				changeCheckboxStatus(this,false)
			});
		}
	});
}

//获得选中的mail
function getCheckedMailList() {
	var mails = new Array();
	$("div#mailList").find("input").each(function(){
		if(this.checked==true) {
			var mail = new Object();
			mail.id = this.value;
			mail.lables = new Array();
			$(this).parent().parent().parent().find("input[name=lableId]").each(function(){
				mail.lables.push(this.value);
			});
			mails.push(mail);
		}
	});
	return mails;
}

//获取选中的邮件ID
function getCheckedMailIds() {
	var mails = new Array();
	$("div#mailList").find("input:checked").each(function(){
		mails.push($(this).val());
	});
	return mails.toString();
}

function moveMail2DelFolder(){
    var mailIds = getCheckedMailIds();
	if(mailIds==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
		return;
	}
	
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	window.top.Dialog.confirm(str,function(){
		var mails = getCheckedMailIds();
		moveMailToFolder2(mails,'-3');
	});
}


//设置为待办完成
function waitDealComplete() {
    var mailIds = getCheckedMailIds();
	if(mailIds==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
		return;
	}
		var param = {"mailids": mailIds, "Operation": "add"};
		$.post("/email/MailWaitdealOperation.jsp", param, function(){
			mailUnreadUpdate();
			loadMailListContent($("index").val());
		});	

}

//移动邮件到指定文件夹
function moveMailToFolder2(mailIds,folderid){
	if(mailIds!=""){
		var param = {"mailId": mailIds,movetoFolder:folderid, "operation": "move"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
		    var totalMailCount=$("#totalMailCount_id").text()-mailIds.split(",").length;
		    var perpage=$("#perpage").val();
			var totalPage=totalMailCount%perpage==0?totalMailCount/perpage:(parseInt(totalMailCount/perpage)+1);
			var index=$("#index").val();
			if(index>=totalPage){
			    $("#index").val(totalPage);
			    $("#goto").val(totalPage);
			    $("#currentIndex").html(totalPage);
			}    
			
			loadMailListContent($("index").val());
			//刷新总数据和未读数据
			RefreshCount();
		});
	}
}

//彻底删除选中邮件
function deleteCheckedMail(){
	var mailIds = getCheckedMailIds();
	if(mailIds==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
		return;
	}
	
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	window.top.Dialog.confirm(str,function(){
		var mailIds = getCheckedMailIds();
		if(mailIds!=""){
			var param = {"mailId": mailIds, "operation": "delete"};
			$.post("/email/new/MailManageOperation.jsp", param, function(info){
			    var totalMailCount=$("#totalMailCount_id").text()-mailIds.split(",").length;
				var perpage=$("#perpage").val();
				if(totalMailCount == 0){
			    	$("#index").val(0);
			    } else {
                    // 如果是最后一页清空了，就跳转到上一页
                    var totalPage=totalMailCount%perpage==0?totalMailCount/perpage:(parseInt(totalMailCount/perpage)+1);
                    var index=$("#index").val();
                    if(index>=totalPage){
                        $("#index").val(totalPage);
                        $("#goto").val(totalPage);
                        $("#currentIndex").html(totalPage);
                    }
                }
                
				loadMailListContent($("index").val());
				 // 刷新总数据和未读数据
				RefreshCount();
				
				info = jQuery.trim(info);
				var arr = info.split(",");
				var occupyspace = arr[0];
				var totalspace = arr[1];
				if(totalspace !=0){
					if(occupyspace*100/totalspace >= 90){
						jQuery("#schedule").css("background-color","red");
					}else{
						jQuery("#schedule").css("background-color","rgb(150,215,248)");
					}
					if(occupyspace*100/totalspace >= 100){
						jQuery("#schedule").css("width","100%");
					}else{
						jQuery("#schedule").css("width",(occupyspace*100/totalspace).toFixed(2)+"%");
					}
					jQuery("#scheduleValue").html((occupyspace*100/totalspace).toFixed(2)+"%");
				}
			});
		}
	});
}

//修改邮件状态 1：已读  0:未读
function updateMailStatus(status,event){
	var mailIds = getCheckedMailIds();
	$(".btnGrayDropContent").hide();
	stopEvent();
	if(mailIds!=""){
		doUpdateMailStatus(mailIds,status)
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}
}

//修改邮件状态
function doUpdateMailStatus(mailIds,status){
	if(mailIds!=""){
		var param = {"mailId": mailIds,status:status, "operation": "updateStatus"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			loadMailListContent($("index").val());
			RefreshCount();  // 刷新总数据和未读数据
		});
	}
}

/*下一封邮件*/
function nextMail(mailId){
	var nextmailid = jQuery("#tbl_"+mailId).nextAll("table.mailitem:first").find("input").val();
	viewMail(nextmailid,jQuery("#tbl_"+mailId).nextAll("table.mailitem:first").find(".title"));
}
/*上一封邮件*/
function prevMail(mailId){
	var nextmailid = jQuery("#tbl_"+mailId).prevAll("table.mailitem:first").find("input").val();
	viewMail(nextmailid,jQuery("#tbl_"+mailId).prevAll("table.mailitem:first").find(".title"));
}

//下一页
function nextPage(){
	var index = $("#index").val();
	var totalPage =$("#totalPage").val()
	index = index*1
	totalPage = totalPage*1
	if(totalPage>=index+1){
		$("#index").val(index+1);
		$("#goto").val(index+1);
		$("#currentIndex").text(index+1)
		loadMailListContent($("index").val());
	}
	$("#nextPageBtn").css("color",(index+1>=totalPage?"#B1ABAB":"#555555"));
	$("#prevPageBtn").css("color",(index+1<=1?"#B1ABAB":"#555555"));
}

//上一页
function prevPage(){
	var index = $("#index").val()
	index = index*1
	if(index-1>0){
		$("#goto").val(index-1);
		$("#index").val(index-1)
		$("#currentIndex").text(index-1)
		loadMailListContent($("index").val());
	}
	$("#prevPageBtn").css("color",(index-1<=1?"#B1ABAB":"#555555"));
//	$("#nextPageBtn").css("color",(index>=totalPage?"#B1ABAB":"#555555"));
}

function gotoPage(){
	var gotopage = $("#goto").val()
	var totalPage =$("#totalPage").val()
	var index = $("#index").val()
	gotopage = gotopage*1
	index = index*1;
	totalPage = totalPage*1
	if(totalPage>=gotopage&&gotopage>0&&gotopage!=index){
		$("#index").val(gotopage)
		$("#currentIndex").text(gotopage)
		loadMailListContent($("index").val());
	}
	$("#prevPageBtn").css("color",(gotopage-1<=1?"#B1ABAB":"#555555"));
	$("#nextPageBtn").css("color",(gotopage>=totalPage?"#B1ABAB":"#555555"));
}

//导出文档
function doExportDocs(event){
    stopEvent();
	var mainid;
	var subid;
	var secid;
    var mailids = getCheckedMailIds();
    $("#saveAs").find(".btnGrayDropContent").hide();
	
	if(mailids!=""){
		if(<%=main%><1 && <%=sub%><1 && <%=sec%><1){
            jQuery("#selectTaohongMouldBtn").trigger("click");  
		}else{
			mainid = '<%=main%>';
			subid = '<%=sub%>';
			secid = '<%=sec%>';
            var param = {mailIds:mailids,operation:'exportDocs',mainId:mainid,subId:subid,secId:secid};
            showLoading(1, 'doExportDoc');
            $.post("/email/MailOperation.jsp",param,function(){
                showLoading(0);
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
            });
		}		
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}
}

// 执行导出为文档
function cbDoExportDocs(event, datas) {
    if(datas){
        var secid = datas.id;
        var mainid = datas.mainid;
        var subid = datas.subid;
        if(secid=="" || secid==0 || mainid=="" || subid==""){
            return;
        }
        var mailids = getCheckedMailIds();
        var param = {mailIds:mailids,operation:'exportDocs',mainId:mainid,subId:subid,secId:secid};
        showLoading(1, 'doExportDoc');
        $.post("/email/MailOperation.jsp",param,function(){
            showLoading(0);
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
        })
    } 
}

//导出客户联系
function doExportContacts(event){
	
	var mailids = getCheckedMailIds();
	$("#saveAs").find(".btnGrayDropContent").hide();
	if(mailids!=""){
		
		crmIds = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
		if(crmIds){
			try{
				if(crmIds.id!=""){
					var temp = crmIds.id;
					//$("formMailList").crmIds.value =crmIds.id;
					//alert($("formMailList").crmIds.value);
					//$("formMailList").operation.value = "exportContacts";
					//$("formMailList").submit();
					var param = {mailIds:mailids,operation:'exportContacts',crmIds:temp}
					$.post("/email/MailOperation.jsp",param,function(){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
					})
					//hideRightClickMenu();
					//showMsgBox($("actionMsgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19949,user.getLanguage())%>...");
				}
			}catch(e){
				//TODO
				window.top.Dialog.alert("error");
			}
		}
   }else{
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!")
   }
	stopEvent();
}


//导出为EML
function doExportEML(event){
	var mailids = getCheckedMailIds();
	$("#saveAs").find(".btnGrayDropContent").hide();
	stopEvent();
    
    if(mailids != "") {
        jQuery.post("/email/new/MailManageOperation.jsp",{'mailIds': mailids, 'operation':'checkEml'},function(isexist){
            isexist = jQuery.trim(isexist);
    		if(isexist == 'false') {
    			window.top.Dialog.alert("EML<%=SystemEnv.getHtmlLabelName(20041,user.getLanguage()) %>");	
    			return;
    		} else {
                var userLayout = <%=userLayout%>;
                var frameId = userLayout == 3 ? "downLoadFrame" : "downLoadFrame_eml";
                if(mailids.indexOf(',') > 0) {
                    $("#" + frameId).attr("src","/weaver/weaver.email.FileDownloadLocation?downtype=batch&downfiletype=eml&mailId="+mailids);
                } else {
                    $("#" + frameId).attr("src","/weaver/weaver.email.FileDownloadLocation?download=1&downfiletype=eml&mailId="+mailids);
                }
            }
    	});
    } else {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
    }
}

//弹出添加邮件过滤规则
function popAddMailRule(himself){
	//隐藏弹出框，避免和添加邮件规则的弹出框一块显示
	$(".btnGrayDropContent").hide();
	//$("div#addMailRule").load("/email/new/MailRuleEdit.jsp", function(){
		//$(himself).show_modal({ overlay:0.3, closeButton: ".modal_close" }, this);
		var diag = new window.top.Dialog();
		diag.Width  = "480px";
		diag.Height  = 350;
		diag.Title = "<%=SystemEnv.getHtmlLabelName(19834,user.getLanguage()) %>";
		diag.URL="/email/new/MailRuleEdit.jsp";
		diag.OKEvent = function(){diag.innerFrame.contentWindow.submitAddMailRule()};
		diag.show();
	//});
}

function showMsgBox(o, msg){
	with(o){
		innerHTML = msg;
		style.display = "inline";
		style.position = "absolute"
		style.top = document.body.offsetHeight/2+document.body.scrollTop-50;
		style.left = document.body.offsetWidth/2-50;
	}
}

//打开发件人
function openShowNameHref(hrmid,obj,type){	
	parent.addTab("1","/email/new/MailAdd.jsp?to="+hrmid+"&isInternal="+type,"<%=SystemEnv.getHtmlLabelName(30912,user.getLanguage()) %>");		
}	

function showMail(){
	var obj=$("#totalOrUnread").find(".selected");
	$(obj).addClass("btnSpanOver").addClass("selected");
	
	$("#status").val($(obj).attr("target"));
		
	//loadMailListContent($("#index").val());
	if($(obj).attr("target")=="0"){
		$("#clickObj").val("1");
		$("#status").next().find(".selectBox").html("<%=SystemEnv.getHtmlLabelName(25396,user.getLanguage()) %>");
	}else if($(obj).attr("target")=="1"){
		$("#status").next().find(".selectBox").html("<%=SystemEnv.getHtmlLabelName(25425,user.getLanguage()) %>");
	}else if($(obj).attr("target")==""){
		$("#clickObj").val("0");
		$("#status").next().find(".selectBox").html("");
	}
	var obj2=$("#outerOrInner .selected");
	if($("#outerOrInner").size()!=0){
		if(obj2.length>0)
			$("#isInternal").val(obj2.attr("isInternal"));
		else
			$("#isInternal").val("-1");	
	}
	try{
		if($("#labelidchecked_true")){
					//说明是在有标签的情况下，点击全部或未读
					$("#labelidchecked").val("1");
		}
	}catch(e){}
    
	$("#highSearchForm").submit();
	//loadMailListContent(1);
}

//阻止事件冒泡
function stopEvent(event) {
	if (event && event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}
function cancelLabel(obj){
	var mails = getCheckedMailList();
	if(mails=="") {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
		return;
	}
	var needfulMailsId = new Array();
	for(var i=0; i<mails.length; i++){
		var tempId = mails[i].id;
		needfulMailsId.push(tempId);
	}
	var param = {"mailsId": needfulMailsId.toString(), "operation": "cancelLabel"};
	$.post("/email/new/MailManageOperation.jsp", param, function(){
		loadMailListContent($("index").val());
		$(obj).parent().hide();
	});
}
function createLabel(type,obj){
	var mails = getCheckedMailList();
	if(mails=="") {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
		return;
	}
	var needfulMailsId = new Array();
	for(var i=0; i<mails.length; i++){
		var tempId = mails[i].id;
		needfulMailsId.push(tempId);
	}
	$(obj).parent().hide();
	stopEvent() ;
	 if(type==1){
		openDialogcreateLabel("<%=SystemEnv.getHtmlLabelName(31220,user.getLanguage()) %>","/email/new/LabelCreate.jsp?mailsId="+needfulMailsId.toString()+"&type=1",1);
	}else{
		openDialogcreateLabel("<%=SystemEnv.getHtmlLabelName(31221,user.getLanguage()) %>","/email/new/FolderManageAdd.jsp?mailsId="+needfulMailsId.toString()+"&type=2",2);
	} 
	
}
var dlgcreateLabel;
//在其子页面中，调用此方法打开相应的界面
function openDialogcreateLabel(title,url,type) {
	dlgcreateLabel = new window.top.Dialog();
	dlgcreateLabel.currentWindow = window;
	dlgcreateLabel.Model=true;
	dlgcreateLabel.Width=500;//定义长度
	if(type==2){
		dlgcreateLabel.Height=150;
	}else{
		dlgcreateLabel.Height=200;
	}
	dlgcreateLabel.URL=url;
	dlgcreateLabel.Title=title;
	dlgcreateLabel.show();		
	document.body.click();	
}

function closeDialogcreateLabel() {
	dlgcreateLabel.close();
	loadMailListContent($("index").val());
}

function SaveDatecreateLabel(){
	document.getElementById("_DialogFrame_0").contentWindow.submitDate(dlgcreateLabel);
}

function submitdata(){
	//clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索
	//String clickObj=Util.null2String(request.getParameter("clickObj"));
	//alert($("#tohrmid").val())
		var status=$("#status").val();
		if(status=="1"){
			//已读
			$("#clickObj").val("");
		}else if(status=="0"){
			//未读
			$("#clickObj").val("1");
		}else{
			//全部
			$("#clickObj").val("0");
		}
		$('#highSearchForm')[0].submit();
}
function nextWizard(obj){
	//alert(obj);
}
function finishALLIframe(){
		//alert("向导结束");
		$(".joyride-tip-guide").remove();
		//$("#maskguidelist").height("0px");
		$(window.parent.document.getElementById("clickshowjoy")).attr("href","javascript:showjoy()");
		//window.parent.document.getElementById("maskguide").style.cssText="height:0px";
}
function ShowWizard(){
	$(document).joyride({"postStepCallback":nextWizard,"postRideCallback":finishALLIframe});
}

function isdel(){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	window.top.Dialog.confirm(str,function(){
		return true;
	},function(){
		return false;
	});
 }
 
 // 刷新总数据和未读数据
 function RefreshCount(){
	var param =<%=param%>;
	$.post("/email/new/RefreshCountAjAX.jsp", param, function(data){
			$("#totalMailCount_id").html(data.totalMailCount);
			$("#unreadMailCount_id").html(data.unreadMailCount);
			var perpage=$("#perpage").val();
			var totalPage=data.totalMailCount%perpage==0?data.totalMailCount/perpage:(parseInt(data.totalMailCount/perpage)+1);
			if($("#status").val()=="0"){
				totalPage=data.unreadMailCount%perpage==0?data.unreadMailCount/perpage:(parseInt(data.unreadMailCount/perpage)+1);
			}
			$("#totalPage").val(totalPage); 
			$("#totalPageIndex").html(totalPage);
			
			mailUnreadUpdate();
	},"json");
 }
 
 function　mailUnreadUpdate(){
 	try{
		window.parent.parent.mailUnreadUpdate();
	}catch(e){
			try{
				//说明是老版的模式查看
				window.parent.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.mailUnreadUpdate();	
			}catch(e){
				//左右树形结构查看
				window.parent.parent.document.getElementById("mailFrameLeft").contentWindow.mailUnreadUpdate();
			}	

	}
 }
 
 function showjoy(){
		
		$("#clickshowjoy").attr("href","javascript:void(0)");
		//tabpanel.show(0,false);//跳到收件箱界面
		//$("#maskguide").height("0px");
		//$($("#mainConEmail")[0].contentWindow.document).find("#maskguidelist").height("100%");
		$(document).joyride({"postStepCallback":nextWizard,"postRideCallback":finishALL,"inline":"true"});
}

function nextWizard(obj){
	//每次完成后调用的函数
	
}
function finishALL(obj){
	//完成所有项后提示的函数
	if(obj!="#close"&&(typeof(obj) != "undefined")){
		ShowWizard(); 
	}else{
		$("#clickshowjoy").attr("href","javascript:showjoy()");
	//	$("#maskguide").height("0px");
		//$($("#mainConEmail")[0].contentWindow.document).find("#maskguidelist").height("0px");
	}
	$(".joyride-tip-guide").remove();
	
}

// 打开和关闭遮罩提示
function showLoading(isShow,type){
   switch(type){
      case 'saveing':
         $("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(19941, user.getLanguage())%>...");
         break;
      case 'doExportDoc':
         $("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(18885, user.getLanguage())%>...");
         break;
      default:
         $("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>...");   
         break;   
   }
   if(isShow==1){
   		$("#bgAlpha").show();
   		$("#loading").show();
   }else{
   		$("#bgAlpha").hide();
        $("#loading").hide();	
   }     	
}

/**
**鼠标悬浮显示下划线
**/
jQuery(function(){
	jQuery("td[name='state']").hover(
		function(){jQuery(this).addClass("mailSort");},
		function(){jQuery(this).removeClass("mailSort")
	});
});

var fromState = null;//0为倒序，1为正序
var subjectState = null;//0为倒序，1为正序
var dateState = null;//0为倒序，1为正序
function mailSort(obj,type){
	
	
	if("from" == type){
		removeSort("fromState");
		fromState = setStyle(obj , fromState , "fromState");
		if(<%=folderid.equals("-1")||folderid.equals("-2")%>){//收件人
			jQuery("#sortColumn").val("sendto");
		}else{//发件人
			jQuery("#sortColumn").val("sendfrom");
		}
	}
	
	else if("subject" == type){
		removeSort("subjectState");
		subjectState = setStyle(obj , subjectState ,"subjectState");
		jQuery("#sortColumn").val("subject");
	}
	else{
		removeSort("dateState");
		dateState = setStyle(obj , dateState ,"dateState");
		jQuery("#sortColumn").val("senddate");
	}
	
	loadMailListContent($("index").val());
}
/**
*设置结尾样式 ,排序方式
*/
function setStyle(obj , state , id){
	jQuery(obj).addClass("mailSort");
	if(null == state){
		jQuery("#sortType").val("DESC");
		jQuery(obj).append("<span id='"+id+"'>↓</span>");
		state = 0;
	}else if(1==state){
		jQuery("#sortType").val("DESC");
		jQuery("#"+id).html("↓");
		state = 0;
	}else{
		jQuery("#sortType").val("ASC");
		jQuery("#"+id).html("↑");
		state = 1;
	}
	return state;

}
/**
**清除样式 ，初始化数据
*/
function removeSort(id){
	var arr =["fromState","subjectState","dateState"];
	for(var i=0 ;i<arr.length; i++){
		if(id == arr[i]){//当前正在操作的，不清除样式
			continue;
		}
		jQuery("#"+arr[i]).html("");
		
		//确保每次点击标题的时候，都为倒序
		if("fromState" == arr[i] && null !=fromState && 0 == fromState){
			fromState = 1;
			continue;
		}
		
		if("subjectState" == arr[i] && null!= subjectState && 0 == subjectState){
			subjectState = 1;
			continue;
		}
		
		if("dateState" == arr[i] && null != dateState && 0 == dateState){
			dateState = 1;
			continue;
		}
	}
	
}

jQuery(function(){
	if(<%=folderList.size()>15%>){
		jQuery("#moveToMenu").css("overflow-y","scroll");
		jQuery("#moveToMenu").css("height","400px");
		jQuery("#moveToMenu").css("width","100px");
	}
	
	if(<%=lmsList.size()>12%>){
		jQuery("#signAsMenu").css("overflow-y","scroll");
		jQuery("#signAsMenu").css("height","400px");
		jQuery("#signAsMenu").css("width","120px");
	}
});

jQuery(function(){
	if(<%=totalspace !=0%>){
		if(<%=occupyspace*100/totalspace%> >= 90){
			jQuery("#schedule").css("background-color","red");
		}
		if(<%=occupyspace*100/totalspace%> >= 100){
				jQuery("#schedule").css("width","100%");
		}else{
			jQuery("#schedule").css("width",<%=occupyspace*100/totalspace%>+"%");
		}
		jQuery("#scheduleValue").html("<%=String.format("%.2f",occupyspace*100/totalspace)%>%");
	}
});

function resetConditionmail(selector){
	$("#tohrmid").val('');
	$("#fromhrmid").val("");
	if(!selector)selector="#highSearchDiv";
	jQuery(selector).find("input[type='text']").val("");
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	jQuery(selector).find("select").selectbox("detach");
	jQuery(selector).find("select").val("");
	jQuery(selector).find("select").trigger("change");
	beautySelect(jQuery(selector).find("select"));
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	jQuery(selector).find("input[type='checkbox']").each(function(){
		changeCheckboxStatus(this,false);
	});
}

$(function(){
    $('#spaceManage').click(function(){
        var diag = new window.top.Dialog();
        diag.Width = 880;
        diag.Height = 580;
        diag.Title = "<%=SystemEnv.getHtmlLabelName(33450,user.getLanguage()) %>";
        diag.URL = "/email/maint/MailSpaceFrame.jsp";
        diag.show();
    });
});

</script>
