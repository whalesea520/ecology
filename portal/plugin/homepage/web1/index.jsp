
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.portal.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="org.jdom.*,HT.HTSrvAPI" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.rtx.RTXExtCom" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.login.Account" %>
<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript"
	src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%if("false".equals(isIE)){ 
  //当前非浏览器不支持网站模式	
  request.setAttribute("labelid","27890");
  request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
}else{ %>
<script language="javaScript">
	var arrayFlash = new Array();
	

 <%
 session.setAttribute("fromlogin","yes");	
 Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
	
	Calendar today = Calendar.getInstance();
	String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
	String currentmonth = Util.add0(today.get(Calendar.MONTH)+1, 2) ;
	String currentdate = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	String currenthour = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) ;
	String currentYearMonthDate=currentyear+"-"+currentmonth+"-"+currentdate;
 
	int userId=user.getUID();
	int userSubcompanyId=user.getUserSubCompany1();
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String lang = Util.null2String(request.getParameter("lang"));
	if("tw".equals(lang)) {
		user.setLanguage(9);
		rs.executeSql("update hrmresource set systemlanguage=9 where id="+userId);
	}
	if("en".equals(lang)) {
		user.setLanguage(8);
		rs.executeSql("update hrmresource set systemlanguage=8 where id="+userId);
	}
	if("cn".equals(lang)) {
		user.setLanguage(7);
		rs.executeSql("update hrmresource set systemlanguage=7 where id="+userId);
	}
	String initsrcpage = "" ;

	String gopage = Util.null2String(request.getParameter("gopage"));
	String frompage = Util.null2String(request.getParameter("frompage"));
	if(!gopage.equals("")){
		gopage=URLDecoder.decode(gopage);
		if(!"".equals(frompage)){
			initsrcpage = gopage+"&message=1&id="+user.getUID();
		}else{
			initsrcpage = gopage;
		}
	}
	//网站模式RTX消息提醒中打开流程
	String para = Util.null2String(request.getParameter("para"));
	if(!para.equals("")){
		gopage=URLDecoder.decode(para);
		initsrcpage = gopage+"&message=1&id="+user.getUID();
	}else{
		initsrcpage = gopage;
	}


	int leftid = Util.getIntValue((request.getParameter("leftmenuid")),0);


	int resourcetype = Util.getIntValue((request.getParameter("resourcetype")),0);
	int resourceid = Util.getIntValue((request.getParameter("resourceid")),0);
	
	

	
	
	String userName=user.getLastname();	
	String from = Util.null2String(request.getParameter("from"));
	UserTemplate  ut=new UserTemplate();
	int extendTempletid=0;

	

	if("preview".equals(from)){
		int templateId=Util.getIntValue(request.getParameter("templateId"));
		userSubcompanyId=Util.getIntValue(request.getParameter("userSubcompanyId"));
		extendTempletid=Util.getIntValue(request.getParameter("extendtempletid"));


		ut.getTemplateByTemplateID(templateId);
	} else {			
		ut.getTemplateByUID(userId,userSubcompanyId);
		extendTempletid=ut.getExtendtempletid();
			
	}
	String isSignInOrSignOut=Util.null2String(GCONST.getIsSignInOrSignOut());//是否启用前到签退功能
	HrmScheduleDiffUtil.setUser(user);
	boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(CurrentDate);
	boolean isSyadmin=true;
	//判断分权管理员
	String Sysmanager = "select loginid from hrmresourcemanager where loginid = '"+user.getLoginid()+"'";
	RecordSet1.executeSql(Sysmanager);
	if(RecordSet1.next()){
		isSyadmin = false;
	}
	if(user.getLoginid().equalsIgnoreCase("sysadmin")){
		isSyadmin = false;
	}
	if(isSyadmin){
		RecordSet1.executeSql("select loginid from hrmresource where loginid = '"+user.getLoginid()+"'");
		if(RecordSet1.next()){
		   isSyadmin = true;
		} else {
		   isSyadmin = false;
		}
	}
	//判断当前用户当天有没有签到
	String signType="1";
	RecordSet.executeSql("SELECT 1 FROM HrmScheduleSign where userId="+user.getUID()+" and  userType='"+user.getLogintype()+"' and signDate='"+currentYearMonthDate+"' and signType='1'  and isInCom='1'");
	if(RecordSet.next()){
		signType="2";
	}
		
	
	int templateId=ut.getTemplateId();


	int extendtempletvalueid=ut.getExtendtempletvalueid();
	String templateTitle=ut.getTemplateTitle();


	/*if(0==0) {
		out.println("extendTempletid:"+extendTempletid);
		out.println("templateId:"+templateId);
		out.println("templateId:"+templateId);
		return;
	}*/


	String extendurl="";
	
	rsExtend.executeSql("select extendurl from extendHomepage where id="+extendTempletid);
	if(rsExtend.next()){
		extendurl=Util.null2String(rsExtend.getString("extendurl"));
	}
	String navimg="";	
	
	String flash="";

	String flash1="";
	String flash2="";
	String flash3="";
	String flash4="";
	String flash5="";
	String copyinfo="";
	String logo="";
	String hiddenLMenu="";

	ArrayList flashList=new ArrayList();
	rsExtend.executeSql("select * from extendHpWeb1 where id="+extendtempletvalueid);
	if(rsExtend.next()){
		logo=Util.null2String(rsExtend.getString("logo"));
		navimg=Util.null2String(rsExtend.getString("navimg"));
		flash1=Util.null2String(rsExtend.getString("flash1"));
		flash2=Util.null2String(rsExtend.getString("flash2"));
		flash3=Util.null2String(rsExtend.getString("flash3"));
		flash4=Util.null2String(rsExtend.getString("flash4"));
		flash5=Util.null2String(rsExtend.getString("flash5"));
		copyinfo=Util.null2String(rsExtend.getString("copyinfo"));
		hiddenLMenu=Util.null2String(rsExtend.getString("hiddenLMenu"));

		flash1=Util.replace(flash1,"\\\\","/",0);
		flash2=Util.replace(flash2,"\\\\","/",0);
		flash3=Util.replace(flash3,"\\\\","/",0);
		flash4=Util.replace(flash4,"\\\\","/",0);
		flash5=Util.replace(flash5,"\\\\","/",0);

		//System.out.println(Util.replace(flash1,"\\\\","/",0));

		if(!"".equals(flash1)) {
			flashList.add(flash1); 
			out.println("arrayFlash.push('"+flash1+"');");
		}else {
			flashList.add("/portal/plugin/homepage/web1/images/flash_wev8.jpg");
			out.println("arrayFlash.push('/portal/plugin/homepage/web1/images/flash_wev8.jpg');");
		}
		if(!"".equals(flash2)) {
			flashList.add(flash2);
			out.println("arrayFlash.push('"+flash2+"');");
		}
		if(!"".equals(flash3)) {
			flashList.add(flash3);
			out.println("arrayFlash.push('"+flash3+"');");
		}
		if(!"".equals(flash4)) {
			flashList.add(flash4);
			out.println("arrayFlash.push('"+flash4+"');");
		}
		if(!"".equals(flash5)) {
			flashList.add(flash5);
			out.println("arrayFlash.push('"+flash5+"');");
		}
	}
	
	if(flashList.size()>0){
		Random rd=new Random();
		flash=(String)flashList.get(rd.nextInt(flashList.size()));
	}	
	if ("".equals(logo))	logo="images/logo_wev8.jpg";
	if ("".equals(navimg))	navimg="images/nav_wev8.jpg";
	
	

  %>
</script>

<HTML>
 <HEAD>
  <TITLE><%=templateTitle%> - <%=userName%></TITLE>
	<link href="/portal/plugin/homepage/web1/main_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
<%
if(needusb0==1&&"2".equals(usbtype0)){
	String randLong = ""+Math.random()*1000000000;
	String serialNo = user.getSerial();
	HTSrvAPI htsrv = new HTSrvAPI();
	String sharv = "";
	sharv = htsrv.HTSrvSHA1(randLong, randLong.length());
	sharv = sharv + "04040404";
	String ServerEncData = htsrv.HTSrvCrypt(0, serialNo, 0, sharv);
%>
<script language="JavaScript"  src="/js/htusbjs_wev8.js"></script>
<script language="JavaScript"  src="/js/htusb_wev8.js"></script>
<OBJECT id="htactx" name="htactx" classid="clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E" codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px;display:none"></OBJECT>
<script language="JavaScript">
var usbuserloginid = "<%=user.getLoginid()%>";
var usblanguage = "<%=user.getLanguage()%>";
var ServerEncData = "<%=ServerEncData%>";
var randLong = "<%=randLong%>";
var password = "<%=user.getPwd()%>";
checkusb();
</script>
<%
}%>
 </HEAD>

  

 
 <body id="oBody">
		
	  <DIV id="wrapper">
		<DIV id="divLogo" style="background:url('<%=logo%>') no-repeat;"></DIV>

		<DIV id="divTopMenu">
		<form name="frmSearch" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
			<DIV id="divSearch">		
					<%
					List accounts =(List)session.getAttribute("accounts");
					%>
					<%if(weaver.general.GCONST.getMOREACCOUNTLANDING() && accounts!=null && accounts.size()>0){%>
					<%//多账号%>
					<%
		                if(accounts!=null&&accounts.size()>1){
		                 
		                    Iterator iter=accounts.iterator();
		
		                %>
		                <select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"  disabled>
		                    <% while(iter.hasNext()){
			                    Account a=(Account)iter.next();
			                    String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
			                    String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
			                    String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());         
			                    int accountId=a.getId();
		                    %>
		                    <option <%if(accountId==user.getUID()){%> selected <%}%> value="<%=accountId%>"><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></option>
		                    <%}%>
		                </select>
		            	<%}%>
		            	<span>&nbsp;</span>	
					<%}%>
							
					<%if(rtxClient.isValidOfRTX()){
						RTXConfig rtxConfigtmp = new RTXConfig();
						String RtxOrElinkType = (Util.null2String(rtxConfigtmp.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
						if("ELINK".equals(RtxOrElinkType)){ 
					%>
                        <a href="javascript:openEimClient()">OCS</a>
						<span>&nbsp;</span>
					<%  } else {%>
						<a href="javascript:openRtxClient()">RTX</a>
						<span>&nbsp;</span>
					 <%}}%>
					<span id="loginouthref" style="display:none">
						<%
						if(isMultilanguageOK){
							BaseBean basebean = new BaseBean();
							String twlanguage = basebean.getPropValue("MutilLanguageProp","ZH_TW_LANGUAGE");
							String enlanguage = basebean.getPropValue("MutilLanguageProp","EN_LANGUAGE");
							if(user.getLanguage()==8){
								if(twlanguage.equals("1")){
									out.println("<a href=\"index.jsp?lang=tw&leftmenuid="+leftid+"&from="+from+"&userSubcompanyId="+userSubcompanyId+"\">"+SystemEnv.getHtmlLabelName(33598,user.getLanguage())+"</a>");
								}else {
									out.println("<a href=\"index.jsp?lang=cn&leftmenuid="+leftid+"&from="+from+"&userSubcompanyId="+userSubcompanyId+"\">"+SystemEnv.getHtmlLabelName(33597,user.getLanguage())+"</a>");
								}
							} else if(user.getLanguage()==7){
								if(enlanguage.equals("1")){
									out.println("<a href=\"index.jsp?lang=en&leftmenuid="+leftid+"&from="+from+"&userSubcompanyId="+userSubcompanyId+"\">English</a>");
								}else if(twlanguage.equals("1")){
									out.println("<a href=\"index.jsp?lang=tw&leftmenuid="+leftid+"&from="+from+"&userSubcompanyId="+userSubcompanyId+"\">"+SystemEnv.getHtmlLabelName(33598,user.getLanguage())+"</a>");
								}
							} else if(user.getLanguage()==9){
								out.println("<a href=\"index.jsp?lang=cn&leftmenuid="+leftid+"&from="+from+"&userSubcompanyId="+userSubcompanyId+"\">"+SystemEnv.getHtmlLabelName(33597,user.getLanguage())+"</a>");
							}
						%>		
						<span>&nbsp;</span>				
						<%}%>
						
						<a href="javaScript:onLoginout()"><%=SystemEnv.getHtmlLabelName(1205, user.getLanguage())%></a>
						<span>&nbsp;</span>
					</span>
<!--签到 -->
				<%
				if(isSignInOrSignOut.equals("1")&&isWorkday&&isSyadmin){
				String signStr = "";
				if(signType.equals("1")){
					signStr = SystemEnv.getHtmlLabelName(20032,user.getLanguage());
				}else{
					signStr = SystemEnv.getHtmlLabelName(20033,user.getLanguage());
				}
				%>
				<span id="signInOrSignOutDiv" style="border-left:0px;border-right:0px;"><a id="signInOrSignOutNew_a" href="javaScript:signInOrSignOutNew(<%=signType%>)"><%=signStr%></a>&nbsp;</span>
<!--签退 -->
				<span>&nbsp;</span>
				<% }%>
					<select name="searchtype" style="width:50px">
						<option value=1><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
						<option value=2><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
						<%if(isgoveproj==0){%>
						<option value=3><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
						<option value=6><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
						<%} %>
						<option value=4><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
						<option value=5><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>
						<option value=7><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></option>
					</select>					
					<input name="searchvalue" size="14">
					
					<img src="images/search_wev8.jpg" style="cursor:hand" align="absmiddle" border=0 onclick="frmSearch.submit();">				
				    
			</DIV>
			</form>
			<DIV>
						<%
							//if(0==0){
							//	PortalMenu topMenu=new PortalMenu(user,"top",extendurl);
							//	out.println(topMenu.getMenuStr(leftid));
							//} else {%>
								<%@ include file="top/topmenu.jsp" %>
							<%//}%>
			
			</DIV>
		</DIV>

		<DIV id="divFlash" style="background:url('<%=flash%>') no-repeat;"></DIV>

		<%
		String leftMenuStyleHidden="";
		if("1".equals(hiddenLMenu)){
			leftMenuStyleHidden="display:none";
		}
		
		%>			
		<DIV id="divLeftMenu" style="<%=leftMenuStyleHidden%>">
			<div id="divNavImg" style="background:url('<%=navimg%>') no-repeat;cursor:hand"  title="<%=SystemEnv.getHtmlLabelName(20607, user.getLanguage())%>" onclick="HiddenAllMenu()">
			&nbsp;
			</div>
			<%
				PortalMenu pmenu=null;
				if(resourcetype==0)  {
					 pmenu=new PortalMenu(user,"left",extendurl);
				} else {
					 pmenu=new PortalMenu(user,"left",extendurl,resourcetype,resourceid);
				}
					
				out.println(pmenu.getMenuStr(leftid));
				session.putValue("pmenu",pmenu);
				
				String srcUrl= "";
				if(!initsrcpage.equals("")){
					srcUrl = initsrcpage;
				}else{
					srcUrl=pmenu.getMenuAddress(leftid);
				}
				//String srcUrl=pmenu.getMenuAddress(leftid);
				String srcNav=pmenu.getMenuNav(leftid);

				//判断srcUrl是不是主页的URL，如果是需要隐掉导航栏，并且需要更改部分样式
				
				//if(srcUrl.indexOf("/homepage/Homepage.jsp")!=-1){
				//	srcUrl=srcUrl+"&needNav=false";
				//	out.println("<style type=text/css>#divContent{margin:-15px,-10px,-5px,0px;}  #navgate{margin:15px,26px,0px,10px;}</style>");
				//}
			%>			 
		</div>
		
		<DIV id="divContent">		
				<div id="navgate">
						<span  style="width:96%">
							<a href="javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=userId%>')"><%=userName%></a>
							
							<%if("1".equals(hiddenLMenu)){%>	
								<%=SystemEnv.getHtmlLabelName(21273, user.getLanguage())%>!
							<%} else {%>
								<%=SystemEnv.getHtmlLabelName(20763, user.getLanguage())%>
								<span id="spanNavgateInfo"><%=srcNav%></span>
							<%}%>
						</span>
						<span  style="width:4%"><a href="javascript:mainFrame.location.reload()"><%=SystemEnv.getHtmlLabelName(354, user.getLanguage())%></a></span>
				</div>
				<iframe id="mainFrame"  name="mainFrame" BORDER=0 FRAMEBORDER=no scrolling="auto" NORESIZE=NORESIZE height="100%" width="100%" src="<%=srcUrl%>" onload="frmOnload(this)"></iframe>	
		</DIV>
		  <DIV id="divFooter">
		  <%if(!"".equals(copyinfo)) {
			  out.println(copyinfo);
		  } else {
		  %>
			<div style="border-top: 1px solid #CACACA;">				
				<table width="100%">
					<tr height=3px><td></td><td></td></tr>
					<tr style="background:#EFEFEF;">
						<td width=80%>
							&nbsp;&nbsp;<a href="#"><%=SystemEnv.getHtmlLabelName(84214, user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp; <a href="#"><%=SystemEnv.getHtmlLabelName(84215, user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp; <a href="#"><%=SystemEnv.getHtmlLabelName(84216, user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="#"><%=SystemEnv.getHtmlLabelName(81973, user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="#"><%=SystemEnv.getHtmlLabelName(84217, user.getLanguage())%></a>&nbsp;&nbsp;|&nbsp;&nbsp;
						</td>
						<td width=20%>
							
						</td>
					</tr>
					
				</table>
				 
			</div>

			<div style="color:#919191">&nbsp;&nbsp;&nbsp;&nbsp;@1996-2005 JinJiang Intemational.inc.All rights reserved.JingJiang proprietary infomation.</div>
		<%}%>
		</DIV>
	  </DIV>
<div id='divShowSignInfo' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'>
</div>
<div id='message_Div' style='display:none'>
</div>
 </BODY>
 <%
	String logmessage = Util.null2String((String)session.getAttribute("logmessage")) ;
	logmessages=(Map)application.getAttribute("logmessages");
	logmessages.put(""+user.getUID(),logmessage);				
 %>
<!--文档弹出窗口-- 开始-->
<% 
String docsid = "";
String pop_width = "";
String pop_hight = "";
String is_popnum = "";
String popupsql = "select docid,pop_num,pop_hight,pop_width,is_popnum from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') and pop_num > is_popnum";
RecordSet.executeSql(popupsql); 
while(RecordSet.next()){ 
docsid = RecordSet.getString("docid");
pop_hight = RecordSet.getString("pop_hight");
pop_width = RecordSet.getString("pop_width");
is_popnum = RecordSet.getString("is_popnum");
if("".equals(pop_hight)) pop_hight = "500";
if("".equals(pop_width)) pop_width = "600";
%>
<script language=javascript> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
  var docid_num = docsid +"_"+ is_popnum;
  window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocDsp.jsp?popnum="+docid_num,"","dialogheight:"+pop_hight+"px;dialogwidth:"+pop_width+"px;scrollbars;resizable:yes;status:yes;Minimize=yes;Maximize=yes");
</script> 
<%}%>
<!--文档弹出窗口-- 结束--> 
</HTML>
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">
<script>
function window.onload()
{
}

var img=null; 
function s() 
{ 
if(img)img.removeNode(true); 
img=document.createElement("img"); 
img.style.position="absolute"; 
img.style.visibility="hidden"; 
img.attachEvent("onreadystatechange",orsc); 
img.attachEvent("onerror",oe); 
document.body.insertAdjacentElement("beforeend",img); 
img.src="/login/images/welcome_wev8.gif"; 
} 
function oe() 
{ 
} 
function orsc() 
{ 
if(img.readyState!="complete")return false; 
var chasm = screen.availWidth;
var mount = screen.availHeight;
window.open('/login/welcome.html','','scrollbars=no,resizable=no,width=' + img.offsetWidth + ',height=' + img.offsetHeight + ',left=' + ((chasm - img.offsetWidth - 10) * .5) + ',top=' + ((mount - img.offsetHeight - 30) * .5));
} 
s();
</script>
<script>  
  //function   window.onbeforeunload()
 // function   window.onunload()  
  window.onbeforeunload =function()
  {  var   n   =   window.event.screenX   -   window.screenLeft;      
     var   b   =   n   >   document.documentElement.scrollWidth-20;   
	//确保刷新系统时不执行退出操作。
	//if(window.screenTop>0&&window.screenTop<10000)
	if(b   &&   window.event.clientY   <   0   ||   window.event.altKey) 
	{
		
	var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }   
    <%if(!"preview".equals(from)){
    %>
    ajax.open("GET", "/login/Logout.jsp", false);
    <%}%>  
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send();
	}
  }
  </script>

<SCRIPT LANGUAGE="JavaScript">
<!--		
	function onLoginout(){
		if(confirm("<%=SystemEnv.getHtmlLabelName(16628, user.getLanguage())%>"))
			window.location='/login/Logout.jsp'
		//document.frames("frmContent").document.location.href = "PortalLogin.jsp";
	}
	function frmOnload(o){
		try{
			//隐掉系统标题栏
			 oFrm=document.frames("mainFrame");
			 oDivTopTitle=oFrm.document.getElementById("divTopTitle");
			 //alert(oDivTopTitle.outerHTML);
			 if (oDivTopTitle!=null)oDivTopTitle.style.display='none';
			 //隐掉边框
			 var tabs=oFrm.document.getElementsByTagName("TABLE");
			 for (var i=0;i<tabs.length;i++)   {
				 var tab=tabs[i];
				var tabClassName=tab.className;
			 	if (tabClassName.toLowerCase()=="shadow"){
					//alert('ok')
			 		tab.style.borderWidth="0px";
					oFrm.document.body.scroll="no";
			 		break;
			 	}
			 }		
			 if(oFrm.document.URL.indexOf("Homepage.jsp")!=-1){ //如果此iframe中的地址是与首页相关的。可以不用做任何处理，只需把body设为auto
				oBody.scroll="auto";
				oFrm.document.body.scroll="no";
			} else {								
				if(oFrm.document.frames.length>1){ //页面内容中如果具有iframe 把body的scroll设为no并且需要把iframe的高度设定好										
					//oBody.scroll="no";
					oFrm.document.body.scroll="auto";
					//alert(1)
					//alert(document.body.offsetHeight)
					//alert(document.body.offsetHeight-500+"px");
					//if(window.frames['mainFrame'].window.document.getElementById('oTable1') == null){ 
						o.style.height=document.body.scrollHeight-400+"px";	
					//}
				} else { //页面内容中如果具有iframe 把body的scroll设为auto 并且需要把iframe里面的高度设定到外面来进行处理就可以了
					oBody.scroll="auto";
					oFrm.document.body.scroll="auto";
					if(window.frames['mainFrame'].window.document.getElementById('oTable1') == null){ 
						//o.style.height=oFrm.document.body.scrollHeight;
						o.style.height=window.screen.height;
					}
				}
			} 
			 //var realHeight=oFrm.document.body.scrollHeight;
			 //alert(realHeight)
			 //if(realHeight<400) realHeight=400;
			 //o.height=realHeight+10;
			 
			   var ifm= document.getElementById("mainFrame");   
			var subWeb = document.frames ? document.frames["mainFrame"].document : ifm.contentDocument;   
			var lefMenu=document.getElementById("divLeftMenu");
			var divContent=document.getElementById("divContent");
			if(ifm != null && subWeb != null) {
			   //ifm.style.height = subWeb.body.scrollHeight;
			  
			}  
			
			//ifm.style.height=(document.body.clientHeight-ifm.offsetTop-20);
			
			if(ifm != null && subWeb != null) {
			  // ifm.style.height = subWeb.body.scrollHeight;
			} 
		} catch(e){
			//alert(e)
		}
	}


	function showorhidden(obj,mainMenuId){
		//alert(obj.outerHTML)
		if(obj.innerText==6)  {//打开
			changeMenuChildenStat(obj,"block");
			obj.innerText=5;

			

			if(mainMenuId!=""){	
				var oLi=obj.parentNode.parentNode;
			   if(oLi.getElementsByTagName("UL").length<=0) {
				   var oUl=document.createElement("UL");
				   oLi.appendChild (oUl);
				   oUl.innerHTML="Loading...";
				   oUl.style.display="block";	
				   
				  var url="";
				  if(mainMenuId=="news") url="server.jsp?method=news";
				  else if(mainMenuId=="voting") url="server.jsp?method=voting";
				  else if(mainMenuId=="remind") url="server.jsp?method=remind";
				  else  url="server.jsp?method=getChild&mainMenuId="+mainMenuId;	
				  
				  GetMenu(url,oUl);	
			   }
			}	


		}
		else if(obj.innerText==5) { //收缩
			changeMenuChildenStat(obj,"none");
			obj.innerText=6;
		}
		
	 // alert(obj.innerText);
	}

	function onLeftMenuClick(obj,leftmenuid,url,mode,mainMenuId){	
		var oSpanLeft=obj.parentNode;
		var oSpanRight=oSpanLeft.nextSibling;
		var odiv=oSpanLeft.parentNode;	
		var oLi=odiv.parentNode;

		showorhidden(oSpanRight,mainMenuId);	
		goUrl_web1(leftmenuid,url,mode,obj);	
	}


	



	function goUrl_web1(leftmenuid,url,mode,obj){
		if(url=="javascript:void(0);") return;
		//alert(mode)
		try{
			if(mode=="mainFrame"){
				//更新图片
				var arrayRand=""+(Math.random()*arrayFlash.length);
				
				var flashimg=arrayFlash[arrayRand.substr(0,1)];
				//alert(arrayRand+":"+flashimg);
				//alert(arrayRand);
				//alert(flashimg);
				//alert(document.getElementById("divFlash").style.background )
				//document.getElementById("divFlash").style.backgrond="url('"+flashimg+"')";
				document.getElementById("divFlash").style.background ="url('"+flashimg+"')";
				document.getElementById("divFlash").style.backgroundRepeat="no-repeat";
				//更新导航栏
				GetContent("server.jsp?method=navinfo&leftid="+leftmenuid);		
			}
			if(url!="") {
				if(url.toLowerCase().indexOf("http")==-1){
					if(url.indexOf("?")!=-1) url=url+"&isfromportal=1";
					else  url=url+"?isfromportal=1";
				}
				window.open(url,mode)
			}
			

		} catch(e){
		}
	}


	function  GetContent(url){
		var xmlHttp = XmlHttp.create();
		xmlHttp.open("GET",url, true);
		xmlHttp.onreadystatechange = function () {
			switch (xmlHttp.readyState) {				
			   case 4 :					
				   document.getElementById("spanNavgateInfo").innerHTML=xmlHttp.responseText;	
			}
		}
		xmlHttp.setRequestHeader("Content-Type","text/xml")
		xmlHttp.send(null);
	}

	function  GetMenu(url,oUl){
		var xmlHttp = XmlHttp.create();
		xmlHttp.open("GET",url, true);
		xmlHttp.onreadystatechange = function () {
			switch (xmlHttp.readyState) {				
			   case 4 :		
					var text=xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
					//alert(text)
				    oUl.innerHTML=text;
				   
				  //document.getElementById("spanNavgate").innerHTML=xmlHttp.responseText;	
			}
		}
		xmlHttp.setRequestHeader("Content-Type","text/xml")
		xmlHttp.send(null);
	}

	function HiddenAllMenu(){
		try{
			//alert("ok")
			var ulMenu=document.getElementById("ulMenu");
			//alert(ulMenu.outerHTML)

			//更改显示与隐藏
			var ulChilds=ulMenu.childNodes;
			for(i=0;i<ulChilds.length;i++)		{
				var child=ulChilds[i];
				//alert(child.outerHTML)
				
				
				if(child.tagName=="LI")			{
					
					var uls=child.getElementsByTagName("UL");
					if(uls!=null){
						for(var j=0;j<uls.length;j++){
							var ulobj=uls[j];
							ulobj.style.display="none";
							//txtInfo.value=ulobj.outerHTML;
						}
						//txtInfo.value+=uls.length+"\n";
					}
					//alert(child.firstChild.firstChild.tagName);
					//child.style.display="none";
				}
			}

			//更改相显示与隐藏按钮
			var sapnObjs=ulMenu.getElementsByTagName("SPAN");
			for(i=0;i<sapnObjs.length;i++)		{
				var spanObj=sapnObjs[i];
				if(spanObj.className=="spanRight") spanObj.innerHTML=6;			
			}
		} catch(e){
		}
	}

    function openEimClient(){
		document.all("rtxClient").src="/EimClientOpen.jsp";
    }
	function openRtxClient(){
		document.all("rtxClient").src="/RTXClientOpen.jsp?notify=true";
	}
	function ajaxInit(){
	    var ajax=false;
	    try {
	        ajax = new ActiveXObject("Msxml2.XMLHTTP");
	    } catch (e) {
	        try {
	            ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	            ajax = false;
	        }
	    }
	    if (!ajax && typeof XMLHttpRequest!='undefined') {
	    ajax = new XMLHttpRequest();
	    }
	    return ajax;
	}
	function signInOrSignOut(signType){
		if(signType==1){
			signInOrSignOutSpan.innerHTML='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON><div   style="color:blue"><%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%></div></BUTTON>';
		}else{
			signInOrSignOutSpan.innerHTML='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON><div   style="color:blue"><%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%></div></BUTTON>';
		}

	    var ajax=ajaxInit();
	    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send("signType="+signType);
	    //获取执行状态
	    ajax.onreadystatechange = function() {
	        //如果执行状态成功，那么就把返回信息写到指定的层里
	        if (ajax.readyState == 4 && ajax.status == 200) {
	            try{
	            showPromptForShowSignInfo(ajax.responseText);
				signInOrSignOutSpan.innerHTML='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON onclick="signInOrSignOut(2)"><div   style="cursor:hand;color:blue"><%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%></div>';

	            }catch(e){
				
				}

	        }
	    }

	}
	function signInOrSignOutNew(signType){
		if(signType==1){
			signInOrSignOutDiv.innerHTML = "<a id=\"signInOrSignOutNew_a\" href=\"javaScript:signInOrSignOutNew(1)\"><%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%></a>&nbsp;";
		}else{
			signInOrSignOutDiv.innerHTML = "<a id=\"signInOrSignOutNew_a\" href=\"javaScript:signInOrSignOutNew(2)\"><%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%></a>&nbsp;";
		}
	    var ajax=ajaxInit();
	    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send("signType="+signType);
	    //获取执行状态
	    ajax.onreadystatechange = function() {
	        //如果执行状态成功，那么就把返回信息写到指定的层里
	        if (ajax.readyState == 4 && ajax.status == 200) {
	            try{
	            showPromptForShowSignInfo(ajax.responseText);
	            signInOrSignOutDiv.innerHTML= "<a id=\"signInOrSignOutNew_a\" href=\"javaScript:signInOrSignOutNew(2)\"><%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%></a>&nbsp;";

	            }catch(e){
				
				}

	        }
	    }

	}
	var showTableDiv  = document.getElementById('divShowSignInfo');
	var oIframe = document.createElement('iframe');


	//type  1:显示提示信息
//	      2:显示返回的历史动态情况信息
	function showPromptForShowSignInfo(content){

	    //showTableDiv.style.display='';

	    var message_Div = document.getElementById('message_Div');
	     message_Div.id="message_Div";
	     message_Div.className="xTable_message";
	     showTableDiv.appendChild(message_Div);

	     message_Div.style.display="inline";
	     message_Div.innerHTML=content;

		 pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	     pLeft= document.body.offsetWidth/2-200;

	     message_Div.style.position="absolute"
	     message_Div.style.posTop=pTop;
	     message_Div.style.posLeft=pLeft;
	     message_Div.style.zIndex=1002;


	     oIframe.id = 'HelpFrame';
	     showTableDiv.appendChild(oIframe);
	     oIframe.frameborder = 0;
	     oIframe.style.position = 'absolute';
	     oIframe.style.top = pTop;
	     oIframe.style.left = pLeft;
	     oIframe.style.zIndex = message_Div.style.zIndex - 1;
	     oIframe.style.width = parseInt(message_Div.offsetWidth);
	     oIframe.style.height = parseInt(message_Div.offsetHeight);
	     oIframe.style.display = 'block';

	     showTableDiv.style.posTop=pTop;
	     showTableDiv.style.posLeft=pLeft;
	     showTableDiv.style.display='';
	}

	function onCloseDivShowSignInfo(){
		divShowSignInfo.style.display='none';
		message_Div.style.display='none';
		document.all.HelpFrame.style.display='none'
	}

	<%if(isSignInOrSignOut.equals("1")&&isWorkday&&isSyadmin&&"1".equals(signType)){%>
	if(confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>")){
		signInOrSignOutNew(<%=signType%>);
	}
	<%}%>
//-->


var firstTime = new Date().getTime();
function onCheckTime(obj){
	window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
}
function setAccountSelect(){
	var nowTime = new Date().getTime();
	if((nowTime-firstTime) < 10000){
		setTimeout(function(){setAccountSelect();},1000);
	}else{
		try{
			document.getElementById("accountSelect").disabled = false;
		}catch(e){}
	}
}
setAccountSelect();
</SCRIPT>
<!--网上调查部分 -->
<%
String sql=""; 
//String CurrentDate=TimeUtil.getCurrentDateString();
//String CurrentTime=TimeUtil.getOnlyCurrentTimeString();
sql="select distinct t1.id from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+user.getUID()+" and t1.status=1 "+ 
" and t1.id not in (select distinct votingid from votingresource where resourceid ="+user.getUID()+")" 
+" and t1.id not in (select distinct votingid from VotingRemark where resourceid = "+user.getUID()+") and (t1.beginDate<'"+CurrentDate+"' or (t1.beginDate='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"'))) "
; 
rs.executeSql(sql); 
while(rs.next()){ 
String votingid = rs.getString("id"); 
%> 

<script language=javascript> 
    window.open("/voting/VotingPoll.jsp?votingid=<%=votingid%>", "", "toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100") ; 
</script> 
<%}%> 

<!--消息提醒部分 -->
<%if(!user.getLogintype().equals("2")){%>
	<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC=/system/SysRemind.jsp></iframe>
<%}%>


<!-- rxt -->
<%    
    HrmUserSettingHandler handler = new HrmUserSettingHandler();
	HrmUserSetting setting = handler.getSetting(user.getUID());

	boolean rtxOnload = setting.isRtxOnload();

    if(rtxClient.isValidOfRTX() && rtxOnload){
		String rtxorelinkurl = "";
		RTXConfig rtxConfig = new RTXConfig();
		String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
		if("ELINK".equals(RtxOrElinkType)){ 
			rtxorelinkurl = "EimClientOpen.jsp";
		} else {
			rtxorelinkurl = "RTXClientOpen.jsp";
		}
%>
	<iframe name="rtxClient" src="/<%=rtxorelinkurl%>" style="display:none"></iframe>
<%  }else{  %>
	<iframe name="rtxClient" src="" style="display:none"></iframe>
<%  } %>

<!--生日提醒-->
<%
//String frommain = Util.null2String(request.getParameter("frommain")) ;
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String birth_valid = settings.getBirthvalid();
String birth_remindmode = settings.getBirthremindmode();
BirthdayReminder birth_reminder = new BirthdayReminder();
if(birth_valid!=null&&birth_valid.equals("1")&&birth_remindmode!=null&&birth_remindmode.equals("0")){
  String strToday = TimeUtil.getCurrentDateString();
 if( application.getAttribute("birthday")==null||application.getAttribute("birthday")!=strToday){
   application.setAttribute("birthday",strToday);
   ArrayList birthEmployers=birth_reminder.getBirthEmployerNames(user);
   application.setAttribute("birthEmployers",birthEmployers);
   }
 ArrayList birthEmployers=(ArrayList)application.getAttribute("birthEmployers");
 
 if(birthEmployers.size()>0){    
%>
<script>
var chasm = screen.availWidth;
var mount = screen.availHeight;
function openCenterWin(url,w,h) {
   window.open(url,'','scrollbars=yes,resizable=no,width=' + w + ',height=' + h + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5));
}
openCenterWin('/hrm/setting/Birthday.jsp',516,420);
</script>
<%}}%>

<%
String gopageOrientation = Util.null2String(request.getParameter("gopageOrientation")) ; 
if(gopageOrientation.equals("")){
	if(session.getAttribute("gopageOrientation") != null){
		String goPage = session.getAttribute("gopageOrientation").toString();
		if(goPage.contains("/workflow/request/ViewRequest.jsp")){
			gopageOrientation = goPage;
		}
	}
}
if(session.getAttribute("gopageOrientation") != null){
	session.removeAttribute("gopageOrientation");
}
if(!"".equals(gopageOrientation)){
%>
<script>
window.open('<%=gopageOrientation%>');
</script>
<%} %>

<script defer="defer" language="javascript">
    document.getElementById('loginouthref').style.display="";
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<%}%>