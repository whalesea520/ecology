
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.*"%>

<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>

<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj" %>

<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />

<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
%>

<%
    MenuMaint mm = new MenuMaint("left", 3, user.getUID(), user.getLanguage());
    List menuArray = byClickCntSort(user, mm.getAllMenus(user, 1));
    boolean rmflg = menuArray.remove(null); 
    while(rmflg) {
    	rmflg = menuArray.remove(null);
    }
    String skin = (String)request.getAttribute("REQUEST_SKIN_FOLDER");
	 StaticObj staticobj = null;
    staticobj = StaticObj.getInstance();
    String software = (String)staticobj.getObject("software") ;
    if(software == null) software="ALL";

    int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
    String Customertype = Util.null2String(""+user.getType()) ;
    String logintype = Util.null2String(user.getLogintype()) ;
	
	String signWeekBg = getWeekBg(user);
%>


<%!
private String[] convMenuInfo(User user, Map map) {
	String[] result = new String[3];
	
    int level = Integer.parseInt((String) map.get("levelid"));
    String sicon = "";
    String sname = "";
	String position = "";
	String isDefault="1"; //是否具有默认图标菜单
    switch (level) {
    //任务管理
    case -2908:            
        sname = SystemEnv.getHtmlLabelName(1332, user.getLanguage());
        position += "-0 -111";
        break;
    //集成系统
    case -2774:            
        sname = SystemEnv.getHtmlLabelName(26267, user.getLanguage());
        position += "-0 -37";
        break;
    //计划任务
    case -2741:            
        sname = SystemEnv.getHtmlLabelName(407, user.getLanguage());
        position += "-148 -74";
        break;
    //临时LICENSE
    case -2080:
        sname = SystemEnv.getHtmlLabelName(18599, user.getLanguage());
        position += "-185 -74";
        break;
    //流程
    case 1:       
        sname = SystemEnv.getHtmlLabelName(22244, user.getLanguage());
        position += "-111 -0";
        break;
    //我的知识
    case 2:
        sname = SystemEnv.getHtmlLabelName(26268,user.getLanguage());
        position += "-74 -0";
        break;
    //我的客户
    case 3:
        sname = SystemEnv.getHtmlLabelName(21313, user.getLanguage());
        position += "-148 -0";
        break;
    //我的项目
    case 4:
        sname = SystemEnv.getHtmlLabelName(25106, user.getLanguage());
        position += "-185 -0";
        break;
    //人事
    case 5:
        sname = SystemEnv.getHtmlLabelName(20694, user.getLanguage());
        position += "-222 -0";
        break;
    //我的会议
    case 6:
        sname = SystemEnv.getHtmlLabelName(2103, user.getLanguage());
        position += "-74 -37";
        break;
    //我的资产
    case 7:
        sname = SystemEnv.getHtmlLabelName(535, user.getLanguage());
        position += "-37 -37";
        break;
    //我的邮件
    case 10:
        sname = SystemEnv.getHtmlLabelName(71, user.getLanguage());
        break;
    //我的短信
    case 11:
        sname = SystemEnv.getHtmlLabelName(22825, user.getLanguage());
        break;
    //我的协助    
    case 80:
        sname = SystemEnv.getHtmlLabelName(26269, user.getLanguage());
        position += "-37 -0";
        break;
    //目标绩效
    case 94:
        sname = SystemEnv.getHtmlLabelName(26270, user.getLanguage());
        position += "-111 -74";
        break;
    //我的通信
    case 107:
        sname = SystemEnv.getHtmlLabelName(26271, user.getLanguage());
        position += "-74 -111";
        break;
    //我的报表
    case 110:
        sname = SystemEnv.getHtmlLabelName(15101, user.getLanguage());
        position += "-37 -74";
        break;
    //信息中心
    case 111:
        sname = SystemEnv.getHtmlLabelName(87, user.getLanguage());
        position += "-0 -74";
        break;
    //系统设置
    case 114:
        sname = SystemEnv.getHtmlLabelName(22250, user.getLanguage());
        position += "-74 -74";
        break;
    //我的日程
    case 140:
        sname = SystemEnv.getHtmlLabelName(2211, user.getLanguage());
        position += "-148 -37";
        break;
     //车辆管理
    case 144:
        sname = SystemEnv.getHtmlLabelName(920, user.getLanguage());
        position += "-185 -37";
        break;
    //我的相册
    case 199:
        sname = SystemEnv.getHtmlLabelName(20003, user.getLanguage());
        position += "-222 -37";
        break;
    //临时LICENSE
    case 227:
        sname = SystemEnv.getHtmlLabelName(18599, user.getLanguage());
        position += "-185 -74";
        break;
    //计划任务
    case 263:
        sname = SystemEnv.getHtmlLabelName(407, user.getLanguage());
        position += "-148 -74";
        break;
    //我的客服
    case 352:
        sname = SystemEnv.getHtmlLabelName(26272, user.getLanguage());
        position += "-222 -74";
        break;
    case 392:
        sname = SystemEnv.getHtmlLabelName(26467, user.getLanguage());
        position += "-37 -111"; 
        break;  
    //我的邮件
    case 536:
        sname = SystemEnv.getHtmlLabelName(71, user.getLanguage());
        position += "-111 -37";
        break;
    default:
        sname = (String) map.get("name");
        String topIcon=(String)map.get("topIcon");
        if("".equals(topIcon))
    	   position += "";
        else{
           position+=topIcon;
           isDefault="0";
        }   
        break;
    }

    if (sname == null || "".equals(sname.trim())) {
    	sname = SystemEnv.getHtmlLabelName(149, user.getLanguage());
    } 
    
    if ("".equals(position)) {
        position += "-315 0";
    }
    
    result[0] = sname;
    result[1] = position;
    result[2] = isDefault;
    return result;
}

private String getWeekBg(User user) {
	String strWeek = "";
    java.util.GregorianCalendar g=new java.util.GregorianCalendar();
    int week = g.get(java.util.Calendar.DAY_OF_WEEK);
    switch(week) {
    case 1:
    	strWeek = SystemEnv.getHtmlLabelName(24626,user.getLanguage());
        break;
    case 2:
    	strWeek = SystemEnv.getHtmlLabelName(392,user.getLanguage());
        break;
    case 3:
    	strWeek = SystemEnv.getHtmlLabelName(393,user.getLanguage());
        break;
    case 4:
    	strWeek = SystemEnv.getHtmlLabelName(394,user.getLanguage());
        break;
    case 5:
    	strWeek = SystemEnv.getHtmlLabelName(395,user.getLanguage());
        break;
    case 6:
    	strWeek = SystemEnv.getHtmlLabelName(396,user.getLanguage());
        break;
    case 7:
    	strWeek = SystemEnv.getHtmlLabelName(397,user.getLanguage());
        break;
    default:
    	break;
    }
    
    return strWeek;
}

private List byClickCntSort(User user, List target) {
	int displayMenuCount = 6;
	//result
	List sortList = new ArrayList();
	//初始化返回菜单列表
	for(int i=0; i<displayMenuCount; i++) {
		sortList.add(null);
	}
	//点击量最高的6个菜单id列表
	List menuIds = new ArrayList();
	
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String dbType = rs.getDBType();
	String exeSql = "";
	//System.out.println(dbType);
	if ("sqlserver".equals((dbType))) {
		exeSql = "SELECT menuId, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " order by clickCnt desc, menuid";
	} else {
		//exeSql = "select t.rownumber,t.menuId, t.clickCnt  from ( SELECT rownum as rownumber,menuId, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " order by clickCnt desc, menuid) t  where t.rownumber<=6";	
		exeSql = "select t.rownumber,t.menuId, t.clickCnt  from ( SELECT rownum as rownumber,menuId, clickCnt from (SELECT menuId, clickCnt FROM HrmUserMenuStatictics WHERE userid=" + user.getUID() + " order by clickCnt desc, menuid) t ) t  where t.rownumber>=0";	
	}
	
	//取得点击量最高的6个菜单
	rs.executeSql(exeSql);
	int displayClickMenuCnt = 0;
	while(rs.next()) {
		long clickCnt = 0;
		int menuId = 0;
		try {
			clickCnt = Long.parseLong(rs.getString("clickCnt"));
		} catch(NumberFormatException e) {
			clickCnt = 0;
		}
		menuId = Util.getIntValue(rs.getString("menuId"), 0);
		
		if (clickCnt > 0 && hasVisible(menuId, target)) {
			if (displayClickMenuCnt > displayMenuCount - 1) {
				continue;				
			}
			displayClickMenuCnt++;
			menuIds.add(new Integer(menuId));	
		}
	}
	
	Iterator it = target.iterator();
	while(it.hasNext()) {
		Map map = (Map) it.next();
		int menuId = Integer.parseInt((String)map.get("levelid"));
		int index = menuIds.indexOf(new Integer(menuId));
		
		if (index != -1) {
			sortList.set(index, map);
			continue;
		}
		sortList.add(map);
	}
	
	return sortList;
}

private boolean hasVisible(int id, List target) {
	Iterator it = target.iterator();
	while(it.hasNext()) {
		Map map = (Map) it.next();
		int menuId = Integer.parseInt((String)map.get("levelid"));
		
		if (id == menuId) {
			return true;
		}
	}
	return false;
}
%>

<%
int pdHeight = 0;
if ((menuArray.size() + 1)%5 != 0) {
	pdHeight = ((menuArray.size() + 1)/5 + 1) *  35;
} else {
	pdHeight = ((menuArray.size() + 1)/5) *  35;
}
%>

<style>
    
	
</style>

<script type="text/javascript">
<!--
function topMenuBgIframeOnload(_this) {
	_this.contentWindow.document.body.style.background = 'transparent';
	_this.contentWindow.document.body.style.border='none';
}
//-->
</script>

<table border="0" width="661px" height="50px" align="left" cellpadding="0px" cellspacing="0px" id="topCenterTable">
<tr>
	<td align="left" width="661px">
		<div class="topMenuDiv leftmenueidtor" style="border:1px dashed transparent;height: 49px;">
		<%--//不知道为什么该处要增加一个iframe...
		<iframe src="" style="filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';filter:alpha(opacity=0);opacity:0;position:absolute; visibility:inherit; top:0px; left:0px; width:100%; height:100%; z-index:-1; ">
		</iframe> --%>
		<div class="topMenuDiv_top">
			<div id="divFloatBg"></div>
			<div class="menuItem" style="" onClick1="dymlftenu(this);topMenuContraction();" >
			    <!--<DIV class="menuItemIcon" style="background-position:0 0;"></DIV>-->
				<DIV class="slideItemText"><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%></DIV>
			</div>
			<%
			
			
			//String sicon = "/wui/theme/ecology8/skins/" + skin + "/page/top/menutopicons_wev8.png";
			int topLine = 1;
			//String sicon = "";
			String positoin = "";
			String sname = "";
			String isDefault="";
			String browser_isie=(String)session.getAttribute("browser_isie"); //当前浏览器是否为IE浏览器
			//System.out.println(menuArray.size());
			for (int index = 0; index < menuArray.size(); index++) {
				Map map = (Map) menuArray.get(index);
				
				if (map == null) continue;
				
				//非IE下是否启用系统设置菜单
				int level = Integer.parseInt((String) map.get("levelid"));
				if(!"true".equals(browser_isie)){
					if(level==114){
						String isOpenSysSettingMenu=GCONST.getSystemSettingMenu(); //是否开启系统设置菜单
						if(!isOpenSysSettingMenu.equals("1"))
							continue; //没有开启则不显示系统设置菜单
					}
				}
				if(level==114)continue;
			    String[] convInfo = convMenuInfo(user, map);
			    sname = convInfo[0];
			    //sicon = convInfo[1];
			    positoin = convInfo[1]; 
			    isDefault = convInfo[2]; 
			    String chinese = "[\u0391-\uFFE5]";
			    int length=0;
			    String tempName="";
			    for(int i=0;i<sname.length();i++){
			    	String temp = sname.substring(i, i + 1);
			    	if (temp.matches(chinese)) {
		                length += 2; /* 中文字符长度为2 */
		            } else {
		                length += 1; /* 其他字符长度为1 */
		            }
			    	if(length>4)
			    		break;
			    	else
			    		tempName+=temp;

			    }
			    
			%> 
			<div class="menuItem" style="" onClick1="clickstatictics(this);" levelid="<%=map.get("levelid")%>" id="<%=map.get("id")%>" target="<%=map.get("target")%>"  title="<%=sname%>">
			    <!--<DIV class="menuItemIcon" style="<%=isDefault.equals("1")?"background-position:"+positoin:"background: url('"+positoin+"')"%>;"></DIV>-->
				<DIV class="slideItemText"><%=tempName %></DIV>
			</div>
			<%
				topLine++;
			}
			%>
		</div>
		<div style="height:50px;float:left;">
			<div id="topMenuContr" class="slideItemText moreText leftMenuTopBtn   add" style="vertical-align:middle;width:40px;top:7px;">
				<div style="padding-top:8px; position:absolute;width:100%" class="">
				<img src='/wui/theme/ecology8/page/images/nav_wev8.png' width="16px" height="16px" style='vertical-align:middle;' id='closeTop'/>
				</div>
			</div>
		</div>
		<div style="margin-left:3px;top:7px;"  class="slideItemText moreText leftMenuTopBtn">
			<div id="freqUse" class="freqUse" style="height:100%;line-height:35px;"><%=SystemEnv.getHtmlLabelName(84318,user.getLanguage())%></div>
			
		</div>
	<form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
		<div class="searchBlockBgDiv slideItemText" style="overflow:visible;position:absolute;left:380px;"></div>
			
					<input type="hidden" name="searchtype" value="1">
						<div id="sample" class="dropdown" style="float:left;position:absolute;left:410px;top:8px">
							<div class="selectTile">
								<a href="#" style="width:57px;">
									<span style="height:35px;line-height:28px;float:left;width:32px;display:block;overflow:hidden;text-overflow:ellipsis;color:#fff;padding:0;" class="searchTxt">
										<%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%>
									</span>
									<div class="e8_dropdown"></div>
									<!--background: url(/wui/theme/ecology8/skins/default/page/ecologyShellImg_wev8.png);background-repeat: no-repeat; background-position: -262px  -62px;-->
									<div style="float:right;display: block; width:8px;height:18px;*height:18px;margin-top:3px;" class="searchTxt searchTxtSplit">|</div>
								</a>
							</div>
							<div class="selectContent" style="margin-top:26px;*margin-top:20px;_margin-top:0px;">
								<ul id="searchBlockUl">
									<iframe src="" style="filter:alpha(opacity=0);opacity:0;position:absolute; visibility:inherit; top:0px; left:0px; width:100%; height:100%; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';" >
									</iframe>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/docs_wev8.png"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span></a></li>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/hrs_wev8.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span></a></li>
								<%if(isgoveproj==0){%>
									<%if((Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2"))&&("1".equals(MouldStatusCominfo.getStatus("crm"))||"".equals(MouldStatusCominfo.getStatus("crm")))){%> 
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/crm_wev8.png"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></span></a></li>
									<%
									}
								}
									%>
								<%
								if((!logintype.equals("2")) && software.equals("ALL")&&("1".equals(MouldStatusCominfo.getStatus("cpt"))||"".equals(MouldStatusCominfo.getStatus("cpt")))){%>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/zc_wev8.png"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(30044,user.getLanguage())%></span></a></li>
								<%
								}
								%>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/wls_wev8.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></span></a></li>
								<%
								if(isgoveproj==0&&("1".equals(MouldStatusCominfo.getStatus("proj"))||"".equals(MouldStatusCominfo.getStatus("proj")))){%>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/p_wev8.png"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(30046,user.getLanguage())%></span></a></li>
								<%
								}
								%>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/mail_wev8.png"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
								<%if("1".equals(MouldStatusCominfo.getStatus("message"))||"".equals(MouldStatusCominfo.getStatus("message"))) {%>
									<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/xz_wev8.png"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(30047,user.getLanguage())%></span></a></li>
								<%} %>
								</ul>
							</div>
						</div>
						
						<div style="float:left;vertical-align :middle;position:absolute;left:480px;top:8px;" >
							<span type="text" id="searchvalue" name="searchvalue"  class="searchkeywork" value="<%=SystemEnv.getHtmlLabelName(84128,user.getLanguage())%>" style="vertical-align :middle;width: 100px;display: block;"><%=SystemEnv.getHtmlLabelName(84128,user.getLanguage())%></span>
						</div>
						<div class="keywordsearchbtn" style="position:absolute;left:590px;top:7px;">
							<div   id="searchbt" style="cursor:pointer;height:100%;width:100%;">
								<img style="vertical-align:middle;margin-top:10px;position:absolute;left:8px" src="/wui/theme/ecology8/skins/default/page/search_wev8.png"></img>
							</div>
						</div>
						
				 </form>
			
			<%--
			<div class="slideItemText toolbarItemDiv">
				<div class="toolbarItem"  onclick="mainFrame.history.go(-1);" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>">
					<span style="background:url(/wui/theme/ecology8/page/images/toolbar/back_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm back"></span>
				</div>
				<div class="toolbarItem"onclick="mainFrame.history.go(1);" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>">
					<span style="background:url(/wui/theme/ecology8/page/images/toolbar/forward_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
				</div>
				<div class="toolbarItem"onclick="document.getElementById('mainFrame').contentWindow.document.location.reload();" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>">
					<span style="background:url(/wui/theme/ecology8/page/images/toolbar/refresh_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
				</div>
			</div>
			 --%>
			<!--<div style="float:left;">
					<div style="float:left">
						<div class="topBlockDateBlock" style="float:left;cursor:pointer;font-weight:bold;color:#003366;background:url(/wui/theme/ecology8/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position: -148px -75px;background-repeat: no-repeat;width:54px;height:29px;line-height:32px;text-align:center;overflow:hidden;" >
							<%=signWeekBg %>
						</div>
					</div>-->
					
					<!--<div style="float:left;display:block;background:url(/wui/theme/ecology8/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position: -252 -75px;background-repeat: no-repeat;width:6px;height:29px;" class="toolbarTopRight">
					</div>-->
			</div>
		</div>
		
	</td>
	
</tr>
</table>

<!-- For slide-->
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.easing_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jQueryRotate_wev8.js"></script>    
<script language="javascript">

var isAdd = true;

//顶部菜单最大高度
var TOP_MENU_MAX_HEIGHT = "<%=pdHeight + 10%>";   
jQuery(document).ready(function(){
	//导航块移动
    /*jQuery(".menuItem").bind("mouseover",function() {
    	topMenuNavMove(this);
    });
	jQuery(".menuItem").bind("mouseout",function(){
		topMenuNavOut(this);
	})*/
    //菜单展开或者收缩
    /*jQuery("#topMenuContr").bind("click", function() {
    	if (jQuery(".topMenuDiv_top").height() > 70) {
    		jQuery(this).removeClass("menuNavSpan_Contraction");
    		jQuery(this).addClass("menuNavSpan_Expand");
    		topMenuContraction();
    	} else {
    		jQuery(this).removeClass("menuNavSpan_Expand");
    		jQuery(this).addClass("menuNavSpan_Contraction");
	        topMenuExpand();
	    }
    });*/
    
    //光标不在菜单区域时，如果菜单时展开的则收缩。
    jQuery(".topMenuDiv").hover(function() {}, function() {
    	if (jQuery(".topMenuDiv_top").height() > 70) {
	    	topMenuContraction();
	    }
    });
    
});

function topMenuNavMove(_this) {
    $this=jQuery(_this);
    /*jQuery("#divFloatBg").show();
    jQuery("#divFloatBg").each(function(){jQuery.dequeue(this, "fx");}).animate({                
        top: $this.position().top -3,
        left: $this.position().left+4
    },600, 'easeOutExpo');*/
	$this.children(".slideItemText").addClass("topItemOver");
}

function topMenuNavOut(_this){
	$this=jQuery(_this);
	$this.children(".slideItemText").removeClass("topItemOver");
}

/**
* 菜单收缩
*/
function topMenuContraction() {
	jQuery("#topMenuContr").removeClass("menuNavSpan_Contraction").removeClass("leftcolor");
    jQuery("#topMenuContr").addClass("menuNavSpan_Expand");
    jQuery("#topMenuContr").parent().removeClass("menuNavSpan_Contraction").removeClass("leftcolor");
   	jQuery(".topMenuDiv_top .slideItemText").removeClass("slideItemTextExpand");
	jQuery(".topMenuDiv_top").each(function() {jQuery.dequeue(this, "fx")}).animate({
		height:35
	} , 0);
	if (jQuery("#divFloatBg").offset().top >= 67 ) {
	    jQuery("#divFloatBg").hide();
	}
	/*if(isAdd){
	}else{
		var angle = 0;
		var timer = setInterval(function(){
			angle+=5;
			jQuery("#closeTop").rotate(angle);
			if (angle==90) clearInterval(timer);
		},5);
	}*/
	jQuery(".topMenuDiv_top").removeClass("topMenuDivOver").removeClass("leftcolor")
	//jQuery(".topMenuDiv_top").css("background", "");
	jQuery("#topMenuContr").css("height","35px");
	jQuery(".topItemSelect").removeClass("topItemSelectBorder").removeClass("logobordercolor");
}

/**
* 菜单展开
*/
function topMenuExpand() {
 	return false;
	/*jQuery(".topMenuDiv").css("background", "url(/wui/theme/ecology8/skins/<%=skin %>/page/top/menu_expand_bg_wev8.jpg)  ");*/
	jQuery(".topMenuDiv_top").addClass("topMenuDivOver").addClass("leftcolor");
	jQuery(".topMenuDiv_top").css("background-position","0 <%="-" + (342 - (pdHeight + 10)) %>");
	jQuery(".topMenuDiv_top").css("background-repeat","no-repeat");
	jQuery(".topMenuDiv_top .slideItemText").addClass("slideItemTextExpand");
	if(isIE() && document.documentMode==5){
		jQuery("#topMenuContr").css("height",parseInt(TOP_MENU_MAX_HEIGHT));
	}else{
		jQuery("#topMenuContr").css("height",parseInt(TOP_MENU_MAX_HEIGHT)-2);
	}	
	jQuery("#topMenuContr").parent().addClass("menuNavSpan_Contraction").addClass("leftcolor");
	jQuery(".topItemSelect").addClass("topItemSelectBorder").addClass("logobordercolor");
	/*var angle = 0;
	var timer = setInterval(function(){
	angle+=5;
	isAdd = false;
	jQuery("#closeTop").rotate(angle);
	if (angle==135) clearInterval(timer);
	},5);*/
	jQuery(".topMenuDiv_top").each(function() {jQuery.dequeue(this, "fx")}).animate({
   		height: TOP_MENU_MAX_HEIGHT
		//height:"100px"
   	} , 0);
}

/**
* 点击菜单项时触发，会统计菜单点击的次数，并打开子项（左侧）
*/
function clickstatictics(_this) {
	jQuery("#leftBlockTd").show();
	jQuery("#e8rightContentDiv").css("margin-left","225px");
	jQuery(".e8_leftToggle").removeClass("e8_leftToggleShow");
	topMenuContraction();
	isAdd = true;
	jQuery("#drillcrumb").text(jQuery(_this).text());
	//jQuery(".slideDivHidden").hide();//animate({opacity: "hide", height: "hide"}, 0);
	dymlftenu(_this);
	var ajaxUrl = "/wui/theme/ecology8/page/topMenuClickStatictics.jsp";
	ajaxUrl += "?mid=";
	ajaxUrl += jQuery(_this).attr("levelid");
	ajaxUrl += "&token=";
	ajaxUrl += new Date().getTime();
	
	jQuery.ajax({
	    url: ajaxUrl,
	    dataType: "text", 
	    contentType : "charset=UTF-8", 
	    error:function(ajaxrequest){}, 
	    success:function(content){
	    }  
    });
}
</script>