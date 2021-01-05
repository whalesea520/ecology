
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%@ include file="/wui/common/page/initWui.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PortalDataSource" class="weaver.admincenter.homepage.PortalDataSource" scope="page"/>

<%
//Map skinConfig = getProperties(this.getServletConfig().getServletContext().getRealPath("/") + "wui/skins/default/config.properties");
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
  response.sendRedirect("/login/Login.jsp");
  return;
}
//当前主题
String curTheme = "";
//当前皮肤
String cskin = "";

curTheme = getCurrWuiConfig(session, user, "theme");
cskin = getCurrWuiConfig(session, user, "skin");
%>

<%

String theme = "";
String skin = "";
String logoTop = "";
String logoBottom = "";
int isopen = 0;
int islock = 0;
String lockProj = "";

%>


<%!
private List getAllSkinInfo(String path) {
    List syskinsConfig = null;
    if (path == null || "".equals(path)) {
        return null;
    }
    
    File parentFile = new File(path);
    
    if (!parentFile.exists() || !parentFile.isDirectory()) {
        return null;
    }
    syskinsConfig = new ArrayList();
    File[] files = parentFile.listFiles();
    for (int i = 0; i < files.length; i++) {
        File item = files[i];
        if (item.isDirectory()) {
        	syskinsConfig.add(getProperties(path + item.getName() + "/config.properties"));
        }
    }
    
    return syskinsConfig;
}

private Map getProperties(String propertyPath) {
	Map skinConfig = new HashMap();
	
	Properties config = new Properties();
	try {
		config.load(new FileInputStream(propertyPath));
	} catch (IOException e) {
		e.printStackTrace();
		return skinConfig;
	} 
	
	Enumeration enumeration = config.propertyNames();
	
	while (enumeration.hasMoreElements()) {
		String key = (String)enumeration.nextElement();
		String value = config.getProperty(key, "");
		skinConfig.put(key, value);
	}
	return skinConfig;
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- jquery1.4 -->
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>

<title></title>
<script type="text/javascript">

$(document).ready(function(){
	//皮肤项缩略效果
	$(".skinItemThumbnailBlock").find("span:first").css("width","121px")
	
	$(".sltFlgClass").hover(function() {
		$(this).removeClass("skinItemThumbnailBg");	
		$(this).addClass("skinItemThumbnailSltBg");	
	}, function () {
		$(this).removeClass("skinItemThumbnailSltBg");
		$(this).addClass("skinItemThumbnailBg");	
	});
	
	$(".moreFlgClass").hover(function() {
		$(this).css("background", "url(/wui/theme/ecology8/page/images/skin/moreSlt_wev8.png) no-repeat");	
		
	}, function () {
		$(this).css("background", "url(/wui/theme/ecology8/page/images/skin/more_wev8.png) no-repeat");	
	});
	
	$(".tabitem").bind("click",function(){
		$(".over").removeClass("over");
		$(this).addClass("over")
		var theme = $(this).attr("theme");
		if(theme=="ecology7"){
			$("#ecology7").show();
			$("#ecology8").hide();
		}else{
			$("#ecology8").show();
			$("#ecology7").hide();
		}
	
	})

	$(".tabitem[theme='<%="ecology8".equals(curTheme) ? curTheme :  "ecology7" %>']").trigger("click");
	
});


function changeSysSkin(clickEle) {
    if (clickEle != null && clickEle != undefined) {
	    var skinFolder = $(clickEle).attr("_skin");
	    var themeName = $(clickEle).attr("_theme");
	    var cssid = $(clickEle).attr("_css");
	    var templateId = $(clickEle).attr("_templateId");
	    if (skinFolder != null && skinFolder != undefined && skinFolder != "") {
	        if (window.confirm("<%=SystemEnv.getHtmlLabelName(31564,user.getLanguage()) %>")) {
	        
		        var css="left";
		        if(themeName=="ecology8"){
		        	if(parseInt(cssid)-1>0){
		        		css=css+(parseInt(cssid)-1);
		        	}
		        	//alert("/wui/theme/ecology8/page/skinColorDo.jsp?from=theme&css="+css+"&cssid="+cssid)
		        	jQuery.post("/wui/theme/ecology8/page/skinColorDo.jsp?from=theme&css="+css+"&cssid="+cssid,null,function(){});
		        }
	        	
	           parent.parent.window.location.href = "/wui/theme/ecology8/page/skinSetting.jsp?skin=" + skinFolder + "&theme=" + themeName+ "&templateId=" + templateId+ "&cssid=" + cssid;
	           parentDialog.close();
	           return;
	        }
	    }
    }
    
}



function changeSysSkin80(clickEle) {
	var skinFolder = $(clickEle).attr("_skin");
	if(skinFolder=="default"){
		jQuery.post("/wui/theme/ecology8/page/skinColorDo.jsp?css=left",null,function(){
			$("#portalCss",top.document).attr("href","/wui/theme/ecology8/skins/default/page/left_wev8.css")
		});
	}
}
</script>

<style type="text/css">
/* 皮肤Block */
.skinListBlock {
	width:560px;
	margin-left: 15px;
}

/* 皮肤单项Block */
.skinItemBlock {
	width:130px;height:110px;margin-left:5px;margin-right:5px;margin-bottom:10px;float:left;
}

/* 皮肤单项缩略图Block */
.skinItemThumbnailBlock {
	height:80px;width:130px;margin-top:5px;margin-bottom:0px;border:none;
}



/* 皮肤单项缩略图 */
.skinItemThumbnail {
	height:68px;width:118px;border:none;margin:6px;
}

/* 皮肤单项名称Block */
.skinItemNameBlock {
	height:18px;width:100%;text-align:center;overflow:hidden;font-size:12px;margin-top:0px;color:#3399cc;
}

.skinItemThumbnailBg {
	background:url(/wui/theme/ecology8/page/images/skin/previewBorder_wev8.png) no-repeat;
}
.skinItemThumbnailSltBg {
	background:url(/wui/theme/ecology8/page/images/skin/previewSltBorder_wev8.png) no-repeat;
}

.tab2{
	height: 35px;
	width: 100%;
	border-bottom: 1px solid #dedede;
}

.tabitem{
	font-size:12px;
	width: 100px;
	float: left;
	height: 33px;
	line-height: 33px;
	cursor: pointer;
	padding-left:5px;
	padding-right:5px;
}
.tab2 .over{
	border-bottom: 2px solid #02c63a;
	color:008ff3;
}
</style>
</head>
<script type="text/javascript">
  document.oncontextmenu=function(){return   false;}
</script>
<body style="font-family:微软雅黑;font-size:12px;" onclick="">
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				
			</table>
<table cellpadding="0" cellspacing="0" width="470px">
	<tr>
		<td align="center" width="100%">
		
<div class="skinListBlock">
	<span style="display:none; margin-left:10px;width:100%;text-align:left;color:#3399cc;font-size:12px;">
		<span style="font-size:12px;"><%=SystemEnv.getHtmlLabelName(84134,user.getLanguage()) %></span>
	</span>
	<div class="tab2">
		<div class="tabitem over" theme="ecology7">
			ecology7&nbsp;<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage()) %>
		</div>
		<div class="tabitem" theme="ecology8">
			ecology8&nbsp;<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage()) %>
		</div>
	</div>
	<span style="margin-left:10px;width:450px;;height:3px;overflow:hidden;display:none;margin-bottom:10px;margin-top:5px;border-top:1px dotted #bfbfbf;"></span>
	<table cellpadding="0px" cellspacing="0px" width="100%">
		<tr align="center">
			<td>
		<div id="ecology7">	
		<%
		String srtSql="";
		srtSql = "select * from SystemTemplate WHERE companyId = "+user.getUserSubCompany1()+" AND isOpen =1  and templatetype<>'ecology8' and templatetype<>'custom' order by templatetype asc, skin asc";
		rsExtend.execute(srtSql);
		if(rsExtend.getCounts()==0){
			srtSql = "select * from SystemTemplate WHERE companyId = 0 AND isOpen =1  and templatetype<>'ecology8' and templatetype<>'custom' order by templatetype asc, skin asc";
			rsExtend.execute(srtSql);

		}
		int trflag = 0;
		String temp="";
		String templatetype="";
		String templateId ="";
		for (int i=0; rsExtend.next(); i++) {
			String type = Util.null2String(rsExtend.getString("templatetype"));
			skin = Util.null2String(rsExtend.getString("skin"));
			templateId = Util.null2String(rsExtend.getString("id"));
			if(type.equals("")){
				templatetype = "ecologyBasic";
				skin = "default";
			}else{
				templatetype = type;
			}
				
			
			
			
			String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
			if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
				projectPath += "/";
			}
			
			
				theme = templatetype;
				
				Map skinConfig = getProperties(projectPath + "wui/theme/" + theme + "/skins/" + skin + "/config.properties");
				String id = (String)skinConfig.get("id");
				String name = (String)skinConfig.get("name");
				String description = (String)skinConfig.get("description");
				String date = (String)skinConfig.get("date");
				String author = (String)skinConfig.get("author");
				String isBuy = (String)skinConfig.get("isBuy");
				String preview = (String)skinConfig.get("preview");
				String home = (String)skinConfig.get("home");
				%>
				<div class="skinItemBlock">
					<div class="skinItemThumbnailBlock skinItemThumbnailBg sltFlgClass" _theme="<%=theme %>" _skin="<%=skin %>"  _templateId="<%=templateId %>"  <%=(cskin.equals(skin) && curTheme.equals(theme)) ? "" : "onclick=\"javascript:changeSysSkin(this);\" style='cursor:pointer;'" %>>
						<img src="/wui/theme/<%=theme%>/skins/<%=skin%>/preview_wev8.png" class="skinItemThumbnail" title="<%=theme %>-<%=name %>"/>
					</div>
					<div class="skinItemNameBlock"><%=theme %>-<%=name %></div>
				</div>
				<%
			}
			
			
			
			
 		%>
		</div>		
		<%
		srtSql = "select * from SystemTemplate WHERE companyId = "+user.getUserSubCompany1()+" AND isOpen =1  and templatetype='ecology8' order by templatetype asc, skin asc";
		rsExtend.execute(srtSql);
		if(rsExtend.getCounts()==0){
			srtSql = "select * from SystemTemplate WHERE companyId = 0 AND isOpen =1  and templatetype='ecology8' order by templatetype asc, skin asc";
			rsExtend.execute(srtSql);

		}
		%>
		
		<div id="ecology8">	
		<% for (int i=0; rsExtend.next(); i++) {
				skin = Util.null2String(rsExtend.getString("skin"));
				templateId = Util.null2String(rsExtend.getString("id"));
				rs.execute("select * from ecology8theme where id="+skin);
				if(rs.next()){
					%>
					<div class="skinItemBlock">
						<div class="skinItemThumbnailBlock skinItemThumbnailBg sltFlgClass" _theme="ecology8" _css="<%=rs.getString("id") %>" _skin="default"  _templateId="<%=templateId %>"  onclick="javascript:changeSysSkin(this)" style='cursor:pointer;position: relative;' title="ecology8-<%=rs.getString("name") %>">
			
						<%
							out.println(PortalDataSource.getDiv(rs));
						%>
						</div>
						<div class="skinItemNameBlock">ecology8-<%=rs.getString("name") %></div>
					</div>
					<%
				}
			}
		%>	
		</div>	
			
				
		<!--	
				<div class="skinItemBlock">
					<div class="skinItemThumbnailBlock moreFlgClass" style="background:url(/wui/theme/ecology8/page/images/skin/more_wev8.png) no-repeat;cursor:pointer;" title="<%=SystemEnv.getHtmlLabelName(26277 ,user.getLanguage())%>" onclick="javascript:alert('对不起，泛微官方社区正在建设中...');">
					</div>
					<div class="skinItemNameBlock" style="margin-top:6px;"><%=SystemEnv.getHtmlLabelName(26277 ,user.getLanguage())%></div>
				</div>
				 -->
		</td>
	</table>
	<span style="margin-left:10px;width:420px;;height:3px;overflow:hidden;display:none;margin-top:20px;margin-bottom:5px;border-top:1px dotted #bfbfbf;"></span>
	<!--
		<span style="margin-left:10px;width:100%;display:block;text-align:left;color:#3399cc;font-size:12px;">
			<span style="font-size:13px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(26279 ,user.getLanguage())%>：</span>
			更多主题请访问
			<a href="#" onclick="javascript:alert('对不起，泛微官方社区正在建设中...');">
				泛微官方社区
			</a>
		</span>
	 -->
</div>
</td>
	</tr>
</table>
</body>

</html>
