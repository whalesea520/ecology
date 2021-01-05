
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.portal.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="freemarker.template.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.rtx.RTXExtCom" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="weaver.hrm.settings.BirthdayReminder" %>

<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/page/maint/common/init.jsp"%>  

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<link href="/js/jquery/plugins/menu/menuh/menuh_wev8.css" type="text/css" rel=stylesheet>
<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuh/menuh_wev8.js"></script>
<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuv/menuv_wev8.js"></script>

<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
<link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" rel=stylesheet>


<%
	session.setAttribute("fromlogin","yes");
	String templateId=Util.null2String(request.getParameter("templateId"));
	if(templateId.equals("")){
		templateId =Util.null2String(request.getParameter("templateid"));
	}
	String from = Util.null2String(request.getParameter("from"));

	String tempdata= "";
	if(from.equals("edit")){
		tempdata = "Temp";
	}
	rs.executeSql("select templateTitle from SystemTemplate"+tempdata+" where id ="+templateId);
	String templateTitle="";
	if(rs.next()){
		templateTitle = rs.getString("templateTitle");
	}
	
	String gopage = Util.null2String(request.getParameter("gopage"));
	String pagetemplateid="",menuid="",menustyleid="",useVoting="",useRTX="",useWfNote="",useBirthdayNote="",useDoc="";	
	String floatwidth="",floatheight="",docId="",defaultshow="";
	String leftmenuid="";
	String leftmenustyleid="";

	rs.executeSql("select * from extendHpWebCustom"+tempdata+" where templateid="+templateId);
	if(rs.next()){
		pagetemplateid=Util.null2String(rs.getString("pagetemplateid"));
		menuid=Util.null2String(rs.getString("menuid"));
		menustyleid=Util.null2String(rs.getString("menustyleid"));
		useVoting=Util.null2String(rs.getString("useVoting"));
		useRTX=Util.null2String(rs.getString("useRTX"));
		useWfNote=Util.null2String(rs.getString("useWfNote"));
		useDoc=Util.null2String(rs.getString("useDoc"));
		useBirthdayNote=Util.null2String(rs.getString("useBirthdayNote"));
		floatwidth=Util.null2String(rs.getString("floatWidth"));
		floatheight = Util.null2String(rs.getString("floatHeight"));
		docId = Util.null2String(rs.getString("docId"));
		defaultshow = Util.null2String(rs.getString("defaultshow"));
		leftmenuid=Util.null2String(rs.getString("leftmenuid"));
		leftmenustyleid = Util.null2String(rs.getString("leftmenustyleid"));
	}
	
	String IconMainDown = mhsc.getIconMainDown(menustyleid);//主菜单下拉图标 
	String IconSubDown = mhsc.getIconSubDown(menustyleid);	//二级菜单下拉图标  
	//得到自定义模板文件所存放的位置
	String dir="";
	rs.executeSql("select dir from pagetemplate where id="+pagetemplateid);
	if(rs.next()){
		dir=Util.null2String(rs.getString("dir"));
	}
	String dirTemplate=pc.getConfig().getString("template.path");

	String fileTemplateName=GCONST.getRootPath()+dirTemplate+dir;
	
	File f=new File(fileTemplateName);

	Configuration  c=new Configuration();
	c.setDirectoryForTemplateLoading(f);
	Template t=c.getTemplate("index.htm","UTF-8");

	
	HashMap hm=new HashMap();
	hm.put("title",templateTitle);
	hm.put("url",dirTemplate+dir);
	hm.put("menu", "<div class='menuhContainer' id='menuhContainer'></div>");
	hm.put("leftmenu", "<div id='menuvContainer'></div>");
	//hm.put("content", "<iframe id='mainFrame' name='mainFrame' src='/homepage/Homepage.jsp?hpid=18&subCompanyId=6' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></iframe>");
	if(!from.equals("preview")){
		hm.put("content", "<iframe id='mainFrame' name='mainFrame' src='/homepage/HomepageRedirect.jsp?isfromportal=1&hastemplate=true&"+request.getQueryString()+"&"+defaultshow.substring(defaultshow.indexOf("?")+1)+"' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto' style='height:1000px'></iframe>");
	}else{
		hm.put("content", "<iframe id='mainFrame' name='mainFrame' src='/homepage/HomepageRedirect.jsp?isfromportal=1&hastemplate=true&"+request.getQueryString()+"&"+defaultshow.substring(defaultshow.indexOf("?")+1)+"' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto' style='height:1000px'></iframe>");
	}
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><%=templateTitle%> - <%=user.getUsername()%></title>
	<STYLE TYPE="text/css">
		<%=mhsc.getCss(menustyleid)%>
		<%=mvsc.getCss(leftmenustyleid)%>
		#mainFrame{
			width:100%;
			height:expression(document.body.offsetHeight-165+"px");
		}	
	</STYLE>
	<SCRIPT language="javascript">
		//使用弹出框, 页面底部多余的iframe清除
		try {
			Dialog.prototype.hideShadowIframe = function(){
				if(this.__e8shadowiframe__){
					jQuery("#"+this.__e8shadowiframe__).remove();
				}
				if($("iframe:last").attr("id")==""){
					$("iframe:last").remove()
				}
			}
		} catch(e) {}
		
		menuh.init({
			mainmenuid: "menuh", 
			//orientation: 'h',
			contentsource: ["menuhContainer", "MenuContent.jsp?menuid=<%=menuid%>&menutype=menuh","<%=IconMainDown%>","<%=IconSubDown%>"]	
		});
		
		
		$(document).ready(function(){
			<%	
			if(!"".equals(gopage)){
			%>
			
			window.open('<%=gopage%>');
			
			<%} %>
			$("#menuvContainer").load("MenuContent.jsp?menuid=<%=leftmenuid%>&menutype=menuv",{},function(){
				var mymenu = new SDMenu("menuv");
				mymenu.init();
			})
			$("#mainFrame").bind("load",function(){
					
				var oFrame;
				try{
					oFrame = document.frames("mainFrame");
				}catch(e){
					oFrame = window.frames["mainFrame"];
				}
				//获取url中topflash参数的值
				var sValue=oFrame.document.URL.match(new RegExp("[\?\&]topflash=([^\&]*)(\&?)","i"))
				var topflashSrc = sValue?sValue[1]:sValue;
				//alert(topflashSrc);
				if(topflashSrc!=null&&topflashSrc!=""&&topflashSrc!="null"){
					$("#divTopflash").html("")
					$("#divTopflash").show();
					$("#divTopflash").html("<embed  src=/page/resource/userfile/flash/"+topflashSrc+" width='1002' ></embed>")
					window.setTimeout("$('#divTopflash').fadeOut('slow');",10000)
				}else{
					$("#divTopflash").hide();
				}
				//document.title = oFrame.document.title;
	
				if(oFrame.document.URL.indexOf("Homepage.jsp")!=-1){ //如果此iframe中的地址是与首页相关的。可以不用做任何处理，只需把body设为auto
					myBody.scroll="auto";
					oFrame.document.body.scroll="no";
					setTimeout(setFrameHeightFillScreen,400)//定时刷新内容部分高度，避免设置元素后出现页面空白情况
				} else {				
					if(oFrame.document.frames.length>1){ //页面内容中如果具有iframe 把body的scroll设为no并且需要把iframe的高度设定好
						myBody.scroll="no";
						oFrame.document.body.scroll="auto";
						this.style.height=document.body.offsetHeight-165+"px";	
					} else { //页面内容中如果具有iframe 把body的scroll设为auto 并且需要把iframe里面的高度设定到外面来进行处理就可以了
						myBody.scroll="auto";
						oFrame.document.body.scroll="no";
						this.style.height=oFrame.document.body.scrollHeight*1.1+"px"
					}
				}
				
			});
		});
		function setFrameHeightFillScreen(){
			var oFrame;
			try{
				oFrame = document.frames("mainFrame");
			}catch(e){
				oFrame = window.frames["mainFrame"];
			}
			var form = document.getElementById("mainFrame");
			var bodyHeight = parseInt(oFrame.document.getElementById('container_Table').clientHeight);
			if(parseInt(form.style.height) > bodyHeight){//避免页面多出空白
				form.style.height=bodyHeight+"px";
			}
			setTimeout(setFrameHeightFillScreen,400)
		}
	</SCRIPT>
</head>
<body id="myBody" scroll="auto">

<div id="divTopflash" align="center"></div>
 <%
	Writer outWrite = new StringWriter();
	try {
		t.process(hm, outWrite);
	} catch (Exception e) {
		out.println(e);			
	} 		
	out.println(outWrite.toString());	
  %>
  <%
  	if(!docId.equals("")){
  	
		String floatContent="";
		if(session.getAttribute("float_"+docId)==null){
			String strSql_DocContent="";
			 ConnStatement statement = null;
		    try{
		        statement=new ConnStatement();
				if(("oracle").equals(rs.getDBType())){
					strSql_DocContent="select doccontent from docdetail d1,docdetailcontent d2 where d1.id=d2.docid and d1.id="+docId;
					statement.setStatementSql(strSql_DocContent, false);
				    statement.executeQuery();
					if(statement.next()) {
					 CLOB theclob = statement.getClob("doccontent");
					  String readline = "";
				      StringBuffer clobStrBuff = new StringBuffer("");
				      BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
				      while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				      clobin.close() ;
				      floatContent = clobStrBuff.toString();
					}	
				} else{
					strSql_DocContent="select doccontent from docdetail where id="+docId;
					statement.setStatementSql(strSql_DocContent, false);
				    statement.executeQuery();
					if(statement.next()) floatContent=statement.getString("doccontent");
				}
				statement.close();
			}catch(Exception e){
		    }finally {
		        statement.close();
		    }
			if(!"".equals(floatContent)){
				String disptmp = "";
				int tmppos = floatContent.indexOf("!@#$%^&*");
				if(tmppos!=-1)	{
					floatContent = floatContent.substring(tmppos+8);
				}		
			}
			session.setAttribute("float_"+docId,floatContent);
		}else{
			floatContent = session.getAttribute("float_"+docId).toString();
		}
%>
<input type="hidden" id='templateTitle' name='templateTitle' value=<%=templateTitle%>>
<div id="floatDiv" style="position:absolute; left:35px; top:600px; width:<%=floatwidth %>;height:<%=floatheight %>" >
<div id='closeDiv' style="visibility:hidden"  align='right''><img src='/images/homepage/style/style1/close1_wev8.gif' onclick='closeDiv()'></div>
<%= floatContent%>
</div>

<SCRIPT LANGUAGE="JavaScript">
//首页浮动窗口实现源码
var xPos = 20;
var yPos = document.body.clientHeight;
var step = 1;
var delay = 20;
var width=0;
var height = 0;
var Hoffset = 0;
var Woffset = 0;
var yon = 0;
var xon = 0;
var pause = true;
var interval;
floatDiv.style.top = yPos;

//浮动实现，变换DIV位置
function changePos() {
	width = document.body.clientWidth;
	height = document.body.clientHeight;
	Hoffset = floatDiv.offsetHeight;
	Woffset = floatDiv.offsetWidth;
	floatDiv.style.left = xPos + document.body.scrollLeft;
	floatDiv.style.top = yPos + document.body.scrollTop;
	if (yon) {
		yPos = yPos + step;
	}else {
		yPos = yPos - step;
	}
	if (yPos < 0) {
		yon = 1;
		yPos = 0;
	}

	if (yPos >= (height - Hoffset)) {
		yon = 0;
		yPos = (height - Hoffset);
	}

	if (xon) {
		xPos = xPos + step;
	}else {
		xPos = xPos - step;
	}

	if (xPos < 0) {
		xon = 1;
		xPos = 0;
	}

	if (xPos >= (width - Woffset)) {
		xon = 0;
		xPos = (width - Woffset);
	}
}

//浮动开始控制
function start() {
	floatDiv.style.visibility = "visible";
	interval = setInterval('changePos()', delay);
	//在鼠标移动到该区域时停止滚动并显示关闭按钮，鼠标移开恢复滚动并隐藏关闭按钮
	floatDiv.onmouseover=function(){
		this.style.cursor = "hand"
		document.getElementById("closeDiv").style.visibility="visible";
		clearInterval(interval);
		this.onmouseout=function(){
			document.getElementById("closeDiv").style.visibility="hidden";
			interval = setInterval('changePos()', delay);
		}
	}
}
//浮动开始
start();

//关闭浮动层
function closeDiv(){
	floatDiv.onmouseover=function(){
		
		clearInterval(interval);
		this.onmouseout=function(){
			clearInterval(interval);
		}
	}
	floatDiv.innerHTML="";
}
</script>
<%} %>
</body>
</html>
 <%
	String logmessage = Util.null2String((String)session.getAttribute("logmessage")) ;
	Map logmessages=(Map)application.getAttribute("logmessages");
	logmessages.put(""+user.getUID(),logmessage);				
 %>
<%
	if("1".equals(useRTX)){		   
		    HrmUserSettingHandler handler = new HrmUserSettingHandler();
			HrmUserSetting setting = handler.getSetting(user.getUID());

		    boolean rtxOnload = setting.isRtxOnload();

		    if(rtxOnload){
		%>
			<iframe name="rtxClient" src="/RTXClientOpen.jsp" style="display:none"></iframe>
		<%  }else{  %>
			<iframe name="rtxClient" src="" style="display:none"></iframe>
		<%  } 
	}
	if("1".equals(useVoting)){%>
		<SCRIPT LANGUAGE="javascript">
		var voteids = "";//网上调查的id
		var voteshows = "";//网上调查是否弹出
		var votefores = "";//网上调查---> 强制调查
		</SCRIPT>


		<%

		    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
		    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
			String belongtoids = user.getBelongtoids();
			String account_type = user.getAccount_type();

		boolean isSys=true;
		RecordSet.executeSql("select 1 from hrmresource where id="+user.getUID());
		if(RecordSet.next()){
			isSys=false;
		}	

		Date votingnewdate = new Date() ;
		long votingdatetime = votingnewdate.getTime() ;
		Timestamp votingtimestamp = new Timestamp(votingdatetime) ;
		String votingCurrentDate = (votingtimestamp.toString()).substring(0,4) + "-" + (votingtimestamp.toString()).substring(5,7) + "-" +(votingtimestamp.toString()).substring(8,10);
		String votingCurrentTime = (votingtimestamp.toString()).substring(11,13) + ":" + (votingtimestamp.toString()).substring(14,16);
		String votingsql=""; 
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		belongtoids +=","+user.getUID();

		votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+ 
		        " and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"'))) "; 
			votingsql +=" and (";
			
		  String[] votingshareids=Util.TokenizerString2(belongtoids,",");
			for(int i=0;i<votingshareids.length;i++){
				User tmptUser=VotingManager.getUser(Util.getIntValue(votingshareids[i]));
				String seclevel=tmptUser.getSeclevel();
				int subcompany1=tmptUser.getUserSubCompany1();
				int department=tmptUser.getUserDepartment();
				String  jobtitles=tmptUser.getJobtitle();
			     	
				String tmptsubcompanyid=subcompany1+"";
				String tmptdepartment=department+"";
				RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
				while(RecordSet.next()){
					tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
					tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
				}
				
				if(i==0){
					votingsql += " ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
					" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
				} else {
					votingsql += " or ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
					" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
				}
				
				  		
			}
			votingsql +=")";

		}else{
			String seclevel=user.getSeclevel();
			int subcompany1=user.getUserSubCompany1();
			int department=user.getUserDepartment();
			String  jobtitles=user.getJobtitle();
			  		
			String tmptsubcompanyid=subcompany1+"";
			String tmptdepartment=department+"";
			RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
			while(RecordSet.next()){
				tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
				tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
			}
			
			votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+
			" and t1.id not in (select distinct votingid from VotingRemark where resourceid ="+user.getUID()+")"+
			" and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"')))"+
			" and t1.id in(select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) )  or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ))"; 
		}
		if(isSys){
			votingsql +=" and 1=2";
		}
		//signRs.writeLog("###abc:"+votingsql);
		signRs.executeSql(votingsql);
		while(signRs.next()){ 
		String votingid = signRs.getString("id");
		String voteshow = signRs.getString("autoshowvote"); 
		String forcevote = signRs.getString("forcevote"); 

		%>

		<script language=javascript>  
		   if(voteids == ""){
		      voteids = '<%=votingid%>';
		      voteshows = '<%=voteshow%>';
		      forcevotes = '<%=forcevote%>';
		   }else{
		      voteids =voteids + "," +  '<%=votingid%>';
		      voteshows =voteshows + "," +  '<%=voteshow%>';
		      forcevotes =forcevotes + "," +  '<%=forcevote%>';
		   }

		   function showVote(){
		     if(voteids !=""){
			     var arr = voteids.split(",");
			     var autoshowarr = voteshows.split(",");
			     var forcevotearr = forcevotes.split(",");
				 for(i=0;i<arr.length;i++){
				    //判断是否弹出调查
				    if(autoshowarr[i] !='' || forcevotearr[i] !=''){//弹出
					    var diag_vote = new Dialog();
						diag_vote.Width = 960;
						diag_vote.Height = 800;
						diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
						diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
						if(forcevotearr[i] !=''){//强制调查
						  diag_vote.ShowCloseButton=false; 
						}
						diag_vote.show();
					}
				 }
			 }
		  }

		  showVote();

		</script> 
		<%
		}
		//------------------------------------
		//网上调查部分 End
		//------------------------------------
		
	}
	if("1".equals(useWfNote)){
		if(!user.getLogintype().equals("2")){%>
		<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width="0" height="0" style="display:none" SCROLLING=no SRC="/system/SysRemind.jsp"></iframe>
		<%}
	}
	if("1".equals(useBirthdayNote)){
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
<%}}}%>
<% 
	if("1".equals(useDoc)){
       String docsid = "";
       String pop_width = "";
       String pop_hight = "";
       String is_popnum = "";
	   String CurrentDate=TimeUtil.getCurrentDateString();
	   String tables=sharemanager.getShareDetailTableByUser("doc",user);
       String tablename=sharemanager.getTableNameByUser("doc",user);
       String popupsql = "select docid,pop_num,pop_hight,pop_width,is_popnum from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') and pop_num > is_popnum";
       rs.executeSql(popupsql); 
       while(rs.next()){ 
       docsid = rs.getString("docid");
       pop_hight = rs.getString("pop_hight");
       pop_width = rs.getString("pop_width");
       is_popnum = rs.getString("is_popnum");
       if("".equals(pop_hight)) pop_hight = "500";
       if("".equals(pop_width)) pop_width = "600";
%>
<script language=javascript defer="defer"> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
  var docid_num = docsid +"_"+ is_popnum;
  window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight+",width="+pop_width+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
</script> 
<%}
}
%>
