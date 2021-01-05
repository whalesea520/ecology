
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.portal.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="freemarker.template.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.rtx.RTXExtCom" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="oracle.sql.CLOB"%> 

<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_DocContent" class="weaver.conn.RecordSet" scope="page" />

<link href="/js/jquery/plugins/menu/menuh/menuh_wev8.css" type="text/css" rel=stylesheet>
<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
<link href="/js/jquery/plugins/menu/menuh/menuh_wev8.css" type="text/css" rel=stylesheet>
<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuh/menuh_wev8.js"></script>


<%
	String tempdata = Util.null2String(request.getParameter("tempdata"));
	int templateIdInt=Util.getIntValue(Util.null2String(request.getParameter("templateId")));
	String templateId=templateIdInt+"";
	String logintemplatetiltle="",pagetemplateid="",menuid="",menustyleid="",floatwidth="",floatheight="",floatid="",openwindowlink="",windowwidth="",windowheight="",defaultshow="";	
	
	String leftmenuid="";
	String leftmenustyleid="";
	rs.executeSql("SELECT * FROM SystemLoginTemplate"+tempdata+" WHERE logintemplateid="+templateId);
	
	if(rs.next()){
		logintemplatetiltle=Util.null2String(rs.getString("logintemplatetitle"));
		pagetemplateid=Util.null2String(rs.getString("modeid"));
		menuid=Util.null2String(rs.getString("menuid"));
		menustyleid=Util.null2String(rs.getString("menutypeid"));
		floatwidth=Util.null2String(rs.getString("floatwidth"));
		floatheight=Util.null2String(rs.getString("floatheight"));
		floatid=Util.null2String(rs.getString("docid"));
		openwindowlink=Util.null2String(rs.getString("openwindowlink"));
		windowwidth=Util.null2String(rs.getString("windowwidth"));
		windowheight=Util.null2String(rs.getString("windowheight"));
		defaultshow=Util.null2String(rs.getString("defaultshow"));
		leftmenuid=Util.null2String(rs.getString("leftmenuid"));
		leftmenustyleid = Util.null2String(rs.getString("leftmenustyleid"));
	}
	if("".equals(pagetemplateid) || "0".equals(pagetemplateid)){
		out.println("<script>top.Dialog.alert('"+SystemEnv.getHtmlLabelName(30933,7)+"');</script>");
		return;
	}
	
	//System.out.println("select dir from pagetemplate where id="+pagetemplateid);
	//得到自定义模板文件所存放的位置
	String dir="";
	rs.executeSql("select dir from pagetemplate where id="+pagetemplateid);
	if(rs.next()){
		dir=Util.null2String(rs.getString("dir"));
	}
	String gopage=Util.null2String(request.getParameter("gopage"));
	session.setAttribute("gopages",gopage);
	String dirTemplate=pc.getConfig().getString("template.path");

	String fileTemplateName=GCONST.getRootPath()+dirTemplate+dir;
	//System.out.println("pagetemplateid:"+pagetemplateid);
	File f=new File(fileTemplateName);

	Configuration  c=new Configuration();
	c.setDirectoryForTemplateLoading(f);
	Template t=c.getTemplate("index.htm","UTF-8");

	
	HashMap hm=new HashMap();
	hm.put("url",dirTemplate+dir);
	hm.put("title",logintemplatetiltle);
	hm.put("menu", "<div class='menuhContainer' id='menuhContainer'></div>");
	hm.put("leftmenu", "<div class='menuv' id='menuv'></div>");
	hm.put("content", "<iframe id='mainFrame' name='mainFrame' src='"+Util.urlAddPara(defaultshow,"isfromportal=1")+"&"+request.getQueryString()+"&"+request.getQueryString()+"' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></iframe>");
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><%=logintemplatetiltle%></title>

	<STYLE TYPE="text/css">
		<%=mhsc.getCss(menustyleid)%>
		<%=mvsc.getCss(leftmenustyleid)%>
		iframe{
			width:100%;
			height:expression(document.body.offsetHeight-165+"px");
		}	
	</STYLE>
	<SCRIPT language="javascript">
		menuh.init({
			mainmenuid: "menuh", 
			orientation: 'h',
			contentsource: ["menuhContainer", "MenuContent.jsp?menuid=<%=menuid%>&menutype=menuh"] 		
		});
		menuh.init({
			mainmenuid: "menuv", 
			//orientation: 'h',
			contentsource: ["menuv", "MenuContent.jsp?menuid=<%=leftmenuid%>&menutype=menuv"] 		
		});
		$(document).ready(function(){			
			$("#mainFrame").bind("load",function(){	
				var oFrame=document.getElementById("mainFrame");
				if(oFrame.contentWindow.document.URL.indexOf("Homepage.jsp")!=-1){ //如果此iframe中的地址是与首页相关的。可以不用做任何处理，只需把body设为auto
					myBody.scroll="auto";
					oFrame.contentWindow.document.body.scroll="no";
				} else {				
					if(oFrame.contentWindow.document.frames.length>1){ //页面内容中如果具有iframe 把body的scroll设为no并且需要把iframe的高度设定好
						myBody.scroll="no";
						oFrame.contentWindow.document.body.scroll="auto";
						this.style.height=document.body.offsetHeight-165+"px";	
					} else { //页面内容中如果具有iframe 把body的scroll设为auto 并且需要把iframe里面的高度设定到外面来进行处理就可以了
						myBody.scroll="auto";
						oFrame.contentWindow.document.body.scroll="no";
						this.style.height=oFrame.contentWindow.document.body.scrollHeight*1.1+"px"
					}
				}
			});
		});

		<%if(!"".equals(openwindowlink)){%>
			window.open("<%=openwindowlink%>",'newwindow',"width<%=windowwidth%>,height=<%=windowheight%>,top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no");
		<%}%>
	</SCRIPT>
</head>
<body id="myBody" scroll="no">
 <%
	Writer outWrite = new StringWriter();
	try {
		t.process(hm, outWrite);
	} catch (Exception e) {
		out.println(e);			
	} 		
	out.println(outWrite.toString());	
  %>
</body>
</html>
<!--以下用来处理浮动窗口-->
<!--以下用来处理浮动窗口-->
<%if(!"".equals(floatid.trim())){%>

	
		<div  class="divFloat" style="width:<%=floatwidth%>;height:<%=floatheight%>;position:absolute;left:10;top:expression(10+parseInt(document.body.scrollTop))">
			<a style="color: rgb(0, 0, 0); text-decoration: none; font-size: 12px;position :absolute;right:2;top:2;" onclick="$('.divFloat').hide()"  href="javascript:;"><%=SystemEnv.getHtmlLabelName(309,7) %></a>
			<br>
			<iframe style="width:100%;height:100%"  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='no'  src="/page/maint/login/FloatWindowContent.jsp?docid=<%=floatid%>"></iframe>
		</div>
		
		<div  class="divFloat" style="width:<%=floatwidth%>;height:<%=floatheight%>;position:absolute;right:10;top:expression(10+parseInt(document.body.scrollTop))">
			<a style="color: rgb(0, 0, 0); text-decoration: none; font-size: 12px;position :absolute;right:2;top:2;" onclick="$('.divFloat').hide()"  href="javascript:;"><%=SystemEnv.getHtmlLabelName(309,7) %></a>
			<br>
			<iframe style="width:100%;height:100%"  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='no'  src="/page/maint/login/FloatWindowContent.jsp?docid=<%=floatid%>"></iframe>
		</div>
<%}%>