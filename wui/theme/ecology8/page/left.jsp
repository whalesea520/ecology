
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.general.Util,java.sql.Timestamp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.ArrayList,java.lang.reflect.Method"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.systeminfo.menuconfig.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.homepage.HomepageUtil" %>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />

<script type="text/javascript">

function Map() {    
    var struct = function(key, value) {    
        this.key = key;    
        this.value = value;    
    }    
     
    var put = function(key, value){    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                this.arr[i].value = value;    
                return;    
            }    
        }    
        this.arr[this.arr.length] = new struct(key, value);    
    }    
         
    var get = function(key) {    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                return this.arr[i].value;    
            }    
        }    
        return null;    
    }    
         
    var remove = function(key) {    
        var v;    
        for (var i = 0; i < this.arr.length; i++) {    
            v = this.arr.pop();    
            if ( v.key === key ) {    
                continue;    
            }    
            this.arr.unshift(v);    
        }    
    }    
         
    var size = function() {    
        return this.arr.length;    
    }    
         
    var isEmpty = function() {    
        return this.arr.length <= 0;    
    }    
       
    this.arr = new Array();    
    this.get = get;    
    this.put = put;    
    this.remove = remove;    
    this.size = size;    
    this.isEmpty = isEmpty;    
}

</script>

<%
	User user = HrmUserVarify.getUser(request, response);
	
	String showlasthp = SystemComInfo.getShowlasthp();

	HomepageUtil homepageUtil = new HomepageUtil();
	int defaultHpid = homepageUtil.getUserNewHpid(user);
	//皮肤取得
	String lskin = (String)request.getAttribute("REQUEST_SKIN_FOLDER");

	List homeMenus = new ArrayList();

	//横菜单
	homeMenus = getPortalMenus(user);

	out.write("<script type=\"text/javascript\">");
	out.write("var menuMap = new Map();");

	out.write("menuMap.put('-9999', \""
			+ grtlftMenu(homeMenus, user)
					.replaceAll("\"", "####") + "\");");
	out.write("</script>");

%>

<%!

	public String grtlftMenu(List elements, User user) {

		if (elements == null) {
			return "<ul></ul>";
		}

		//左侧菜单HTML
		StringBuffer sfcm = new StringBuffer();
		//---------------------------
		// 菜单项背景图片随机显示
		// bgcnt   : 左侧菜单背景图片个数
		// bgindex : 左侧菜单背景图片随机用下标
		// abgs    : 左侧菜单背景图片数组
		//---------------------------
		int bgcnt = 4;
		int bgindex = 4;

		String[] sbgPostions = new String[] { "0 -28", "0 -84", "0 0", "0 -56" };

		sfcm.append("<ul>");
		for (int licnter = 0; licnter < elements.size(); licnter++) {
			Map map = (Map) elements.get(licnter);

			bgindex++;

			sfcm.append(getChildMenu(map, sbgPostions[bgindex % 4]));

			String extra = Util.null2String((String) map.get("extra"));

			if (extra != null && !"".equals(extra)) {

			} else {
				List chilList = (List) map.get("child");

				if (chilList != null && !chilList.isEmpty()) {
					String shtm = grtlftMenu(chilList, user);
					sfcm.append(shtm);
				}
			}

			sfcm.append("</li>");
		}
		sfcm.append("</ul>");

		return sfcm.toString();

	}

	public String getChildMenu(Object obj, String sbgPosition) {
		StringBuffer sfcm = new StringBuffer();
		
		if (!(obj instanceof Map)) {
			return sfcm.toString();	
		}
		
		Map map = (Map) obj;

		//sfcm.append("<li><div style='width:100%;'> ");
		sfcm.append("<li><div> ");
		sfcm.append("<a id="+map.get("id")+" class='lfMenuItem' href='");
		if (map.get("url") == null || map.get("url").toString().equals("")
				|| map.get("url").toString().equals("#")) {
			sfcm.append("javascript:void(0);");
		} else {
			sfcm.append(((String) map.get("url")).replaceAll("&#38;", "&"));
		}
        String menuname=map.get("name").toString();
		//sfcm.append("' style='background:url(").append(abg).append(") no-repeat;' ");
		sfcm.append("' _bgPosition='" + sbgPosition + "'");
		sfcm.append(" target='" + map.get("target") + "' title='" + menuname + "'>");
		sfcm.append("<div class='leftMenuItemLeft' style='background-position:" + sbgPosition + ";'></div>");
		sfcm.append("<div class='leftMenuItemCenter' style=''><span class='e8text'>");
		sfcm.append(menuname);
		sfcm.append("</span><span style='display:none;' class='iconImage'>")
				 	.append(map.get("icon")).append("</span>");
		sfcm.append("<span class='e8_number' id='num_"+map.get("levelid").toString()+"'></span>");
		sfcm.append("</div>");
		sfcm.append("<div class='leftMenuItemRight' style=''></div><div style='width:4px;display:none;'></div></a></div>");


		return sfcm.toString();
	}

	public List getPortalMenus(User user) throws Exception {
		int parenthpid = 0;
		boolean queryChild =  true;
		List<Map> result = new ArrayList<Map>();
		HomepageUtil homepageUtil = new HomepageUtil();
		RecordSet rs = new RecordSet();
		String sharehpids = homepageUtil.getShareHomapage(user);
		if("".equals(sharehpids)&&user.getUID()!=1){
			return result;
		}
		String sql = "select id,infoname,subcompanyid,pid from hpinfo h where infoname is not null and subcompanyid>0   and isuse=1  and id in (" + sharehpids+ ") order by ordernum1";
		if (user.getUID() == 1) {
			sql = "select id,infoname,subcompanyid,pid from hpinfo h where infoname is not null  and subcompanyid>0  and isuse=1 order by  ordernum1";
		}
		//System.out.print("Sql"+sql);
		rs.executeSql(sql);
		result = convertRsToList(rs, "pid", "id", null, 0);
		if(parenthpid > 0){
			result = getSpecificList(result, "id", "" + parenthpid);
		}
		addIsParentToList(result,!queryChild);
		
		addPortalItemToList(result,0);
		return result;
	}
	
	private List<Map> convertRsToList(RecordSet rs,String parentIdKey,String idKey,String checkParentKey,int checkParentValue){
		List<Map> list = new ArrayList<Map>();
		Map<String,String> keyMap = new HashMap<String,String>();
		while (rs.next()){
			String pId = rs.getString(parentIdKey);
			String id = rs.getString(idKey);
			if(pId!= null &&  !"0".equals(pId) && keyMap.get(pId)==null){
				continue; //如果父级不显示，则不显示；防止出现父级菜单没有权限，但是子菜单有权限的情况
			}
			Map tmp =new HashMap();
			String[] cols = rs.getColumnName();
			String colValue = null;
			for(String col : cols){
				colValue = rs.getString(col);
				if(col.toLowerCase().indexOf("name") != -1){
					formatMultiString(colValue);
				}
				tmp.put(col.toLowerCase(),colValue);
			}
			if(checkParentKey !=null){
				tmp.put("isParent",rs.getInt(checkParentKey)> checkParentValue);	//大于对应值就是有子菜单
			}
			 
			if(pId!= null &&  !"0".equals(pId)){
				String path = keyMap.get(pId);
				String[] arr = path.split("-");
				List<Map> chileList = list;
				for(String ts : arr){
					int i = Integer.valueOf(ts);
					if(chileList.get(i).get("child") != null){
						chileList = (List)chileList.get(i).get("child");
					}else{
						chileList.get(i).put("child",new ArrayList());
						chileList = (List)chileList.get(i).get("child");
						break;
					}
				}
				keyMap.put(id, path+"-"+chileList.size());
				chileList.add(tmp);
			}else{
				keyMap.put(id, ""+list.size());
				list.add(tmp);
			}
		}
		return list;
	}
	private List<Map> getSpecificList(List<Map> menuArray, String searchKey, String parentId) {
		List<Map> retList = null;
		for (Map item : menuArray) {
			if (item.get(searchKey) == null) {
				continue;
			}
			String infoId = item.get(searchKey).toString();
			if (parentId.equals(infoId)) {
				if (item.get("child") != null) {
					retList = (List<Map>) item.get("child");
				} else {
					retList = new ArrayList<Map>();
				}
				break;
			} else if (item.get("child") != null) {
				retList = getSpecificList((List<Map>) item.get("child"), searchKey, parentId);
				if (retList != null) {
					break;
				}
			}
		}
		return retList;
	}
	private void addIsParentToList(List<Map> list,boolean noChild){
		for(Map item : list){
			if(item.get("child") != null ){
				List<Map> child = (List)item.get("child");
				item.put("isParent", child.size()>0);
				if(noChild){
					item.remove("child");
				}else{
					addIsParentToList(child,noChild);
				}
			}else{
				item.put("isParent", false);
			}
		}
	}
	private int addPortalItemToList(List<Map> result,int index){
		for(Map map : result){
			int tempHpid = Util.getIntValue(map.get("id").toString(),0);
			int tempPid = Util.getIntValue(Util.null2String(map.get("pid")),0);
			if("".equals(Util.null2String(map.get("infoname")))){continue;}
			String tempHpSubcompanyid = Util.null2String(map.get("subcompanyid"));
			map.put("hpid", tempHpid);
			map.put("url", "/homepage/Homepage.jsp?hpid=" + tempHpid + "&subCompanyId=" + tempHpSubcompanyid + "&isfromportal=1&isfromhp=0");
			map.put("target", "mainFrame");
			if(0==tempPid){
				map.put("levelid", index + "_portal");
			}else{
				map.put("levelid", tempHpid);
			}
			map.put("icon", "");
			map.put("id", "portal" + tempHpid);
			map.put("name", Util.null2String(map.get("infoname")));
			
			index++;
			if(map.get("child") != null){
				index = addPortalItemToList((List)map.get("child"),index);
			}
		}
		return index;
	}
	public static String formatMultiString(String value){
		if("".equals(Util.null2String(value))){
			return "";
		}
		String retValue = value;
		try{
			retValue = Util.formatMultiLang(value);
		}catch(NoSuchMethodError e){
			retValue = value;
		}
		return retValue;
	}
	%>






<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.scrollTo_wev8.js"></script>



<div class="leftMenuTopNavDiv">
	<div id="drillcrumb">
	</div>
</div>
<div id="leftMenu" style="z-index:20px;position:relative;">
	<div id="drillmenu" class="drillmenu content">
		<%=grtlftMenu(homeMenus, user)%>
	</div>
</div>


<!--<div class="navclass leftMenuBottomNavDiv">
	<table align="center" height="27px" cellpadding="0px" cellspacing="0px" width="100%" class="leftMenuBottomNavTbl">
		<tr>
			<td align="center" id="navTd">
			<td>
		</tr>
	</table>
</div>-->


<script type="text/javascript">

/**
 * 左侧菜单最多显示菜单项数目
 */
var leftMenuMaxItem = 7;
/**
 * 菜单滚动速度
 */
var leftMenuScrollSpeed = 200;

/**
 * 菜单每页显示的高度
 */
var leftMenuScrollHeight = leftMenuMaxItem * 28;
//---------------------------------------------------------------
//左侧菜单最多显示菜单高度,由系统自动算出
var LEFT_MENU_MAX_HEIGHT = leftMenuMaxItem * 28;
//左侧菜单显示的菜单项黑度
var LEFT_MENU_ITEM_HEIGHT = 28;
//菜单宽度
var leftMenuItemWidth = 175;
//---------------------------------------------------------------

var defaultHpid="<%=defaultHpid%>";
function setLeftMenuItemFontLt() {
	jQuery(".drillmenu li a").css("padding", "5px 5px 4px 20px");
	
}

function setLeftMenuHeight(size) {
	//jQuery(".drillmenu").css("width", size + "px");//    175
	
	if (size < 150) {
		setLeftMenuItemFontLt();
	}
}

//-------------------------------------
// 20110526 自适应宽度 start
//-------------------------------------
function setLeftMenuItemANavHeight(size) {
	jQuery(".leftMenuItemRight").css("left", size -  5 + "px");
	//jQuery(".leftMenuItemCenter").css("width", size - 16 + "px");
	
	jQuery(".leftMenuItemNavRight").css("left", size + 1 + "px");
	jQuery(".leftMenuItemNavCenter").css("width", size - 10 + "px");
}

function leftMenuInit() {
	
	var clientScreenHeight = window.screen.height;
	var clientScreenWidth = window.screen.width;
	if (clientScreenWidth < 1280) {
		clientScreenWidth = 1280;
	}
    var tpLeftMenuMaxHeight = Math.round(clientScreenHeight / 2.8);
    var tpLeftMenuMaxWidth = Math.round(clientScreenWidth / 8); //8
    
    
    leftMenuMaxItem = Math.round(tpLeftMenuMaxHeight/28);
    //alert(tpLeftMenuMaxWidth);
    leftMenuItemWidth = tpLeftMenuMaxWidth;
	
	setLeftMenuHeight(leftMenuItemWidth);
	setLeftMenuItemANavHeight(leftMenuItemWidth);
	
    
    leftMenuScrollSpeed = 200;
    leftMenuScrollHeight = leftMenuMaxItem * 28;
    LEFT_MENU_MAX_HEIGHT = leftMenuMaxItem * 28;
}

leftMenuInit();

var shiftKeyFlag = false;
var leftcontainmenuWidth = 0;
jQuery(document).ready(function(event) {
 	//设置左侧菜单高度
    //jQuery("#leftMenu").height(LEFT_MENU_MAX_HEIGHT);
    //左侧菜单导航
   /* var myLftMenu = new drilldownmenu(
        {menuid: 'drillmenu',menuheight: 'auto',breadcrumbid: 'drillcrumb',persist: {enable: false, overrideselectedul: false},speed:0,homeDir:'<%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%>'}
    );*/
	 jQuery(".arrowclass").css("position","").css("position","absolute"); 
    //--------------------------------------------------------
    // 绑定事件
    //--------------------------------------------------------
    jQuery(".drillmenu ul li a").bind("click", function() {
		
		//alert(jQuery(this).get(0));
		//jQuery(this).get(0).onclick();
		
        currMObj = this;
        if(!selFlg) {
            selFlg = true;
            jQuery("#leftMenu").scrollTo( {top:'0px',left:+'0px'}, 0 );
        } else {
		   jQuery("#drillmenu").find("li.liSelected").removeClass("liSelected");
		 
		    jQuery("#drillmenu").find("div").removeClass("aSelected");
		    jQuery("#freqUseBlk").find(".aSelected").removeClass("aSelected");
		   jQuery("#drillmenu").css("width",jQuery("#leftmenucontainer").css("width"));
		  jQuery(this).closest("li").addClass("liSelected");
		  jQuery(this).children("div").addClass("aSelected");
		
		  
        }
        lMOpenUrl(jQuery(this));
        if(!isJSOpen(jQuery(this)))
           return false;
    });
    //-------------------------------------------------------
    lMNavBindClick();
	
    syncLMHeight();
    if(jQuery("#mainFrame").attr("src")==""){
    	
    	if(defaultHpid!=0){
        	isOpenFirstMenu = false;
        }else{
        	isOpenFirstMenu=true;
        }
        if("<%=showlasthp%>"!="1"){
        	isOpenFirstMenu=true;
        }
        updateScroll("#leftMenu","#drillmenu");
    	lMnavToFirstNav(isOpenFirstMenu);
		jQuery("#drillcrumb").html(jQuery("div#head").find("div.slideItemText").eq(0).text());
		jQuery("div#head").find("div.slideItemText").eq(0).addClass("topItemSelect");
		
    }else{
		updateScroll("#leftMenu","#drillmenu");
    	
		jQuery("#drillcrumb").html(jQuery("div#head").find("div.slideItemText").eq(0).text());
		jQuery("div#head").find("div.slideItemText").eq(0).addClass("topItemSelect");
	}
    //
});

//---------------------------------------------------------------
// 以下变量为菜单的相关设置
// currSubMParent      :  当前子菜单所属父菜单
// selFlg              :  目前的位置：是否在父菜单是否在父亲那里
// parentMCntLinked    :  保存层级菜单子菜单的个数，用于计算菜单高度.
// parentMObjLinked    :  保存层级菜单,确保点击url返回时,有正确的动作
// parentMLinkedIndex  :  保存层级菜单当前位置
// currMObj            :  当前点击菜单项
var currSubMParent;
var selFlg = true;
var parentMCntLinked = new Array();
var parentMObjLinked = new Array();
var parentMLinkedIndex = 0;
var currMObj = null;
// END
//---------------------------------------------------------------

//---------------------------------------------------------------
// 菜单隐藏时，保持最后点击的菜单
//---------------------------------------------------------------
var recentlyClickTopMenuObj = null;
var lyClickTopmenuStatictics = 0;
/**
 * 动态改变左侧菜单项
 * 点击顶部菜单时，调用此函数
 * @param ele 当前点击的一级(顶级)菜单
 */
function dymlftenu(ele, isOpenFirstMenu) {
	jQuery("#leftBlockTd").show();
	jQuery("#e8rightContentDiv").css("margin-left","225px");
	jQuery(".e8_leftToggle").removeClass("e8_leftToggleShow");
	recentlyClickTopMenuObj = ele;
	lyClickTopmenuStatictics++;
    var paramValue = "";
    var levelid = jQuery(ele).attr("levelid");
    jQuery("#drillcrumb").text(jQuery(ele).text());
	jQuery("#head").find("div.topItemSelect").removeClass("topItemSelect");
	jQuery(ele).children("div").addClass("topItemSelect");
    if(levelid != undefined && levelid != null && levelid != "") {
        paramValue = levelid;
    } else {
        paramValue = "-9999";
    }
    
    var reg=new RegExp("####","g"); 
    
    $(".leftMenuTopNavDiv").css("border-bottom-width","1px");
    if(paramValue==536){
    	$(".leftMenuTopNavDiv").css("border-bottom-width","0px");
	   	jQuery("#navTd").html("");
	   	jQuery("#drillcrumb").html($(ele).find(".slideItemText").text());
	   	jQuery("#drillmenu").html("");
	   	//syncLMHeightForMail();
	    //syncLMHeight();
	   	jQuery("#drillmenu").load("/email/new/leftmenu8.jsp?"+new Date().getTime(),function(){
	   		//jQuery(".leftMenuItemRight").css("left", leftMenuItemWidth -  5); 
	   		//jQuery(".leftMenuItemCenter").css("width", leftMenuItemWidth - 11 - 5);
            jQuery("#leftMenu").scrollTo( {top:'0px',left:+'0px'}, 0 ); 
            $("#drillmenu").height($("#emailCenter").height());
            //$("#autoHight").height($("#leftMenu").height()-30);
            
             //同步菜单高度
        	syncLMHeight();
        	updateHandleRequest();
            //syncLMHeight();
            //updateScroll("#leftMenu","#drillmenu");
           
   	});
   }else if (menuMap.get(paramValue) != undefined && menuMap.get(paramValue) != null && menuMap.get(paramValue) != "" && paramValue != "111") {
        //清空滚动导航项
        jQuery("#navTd").html("");
        currMObj = null;
    
        var leftMenuHtml = menuMap.get(paramValue).replace(reg, "\"");
        jQuery(leftMenuHtml).hide();
        jQuery("#drillmenu").html(leftMenuHtml);
		//$('#drillmenu').perfectScrollbar("update");
        //-------------------------------------
        // 20110526 自适应宽度 start
        //-------------------------------------
        jQuery(".leftMenuItemRight").css("left", leftMenuItemWidth -  5); 
		//jQuery(".leftMenuItemCenter").css("width", leftMenuItemWidth - 11 - 5);
		if (leftMenuItemWidth < 150) {
			setLeftMenuItemFontLt();
		}
        //-------------------------------------
        // 20110526 自适应宽度 end
        //-------------------------------------
        
        jQuery("#leftMenu").scrollTo( {top:'0px',left:+'0px'}, 0 );
         updateScroll("#leftMenu","#drillmenu",paramValue);
        //第一个菜单项
        var lfirst = jQuery("#drillmenu ul li a").get(0);
        
        var isPortal = false;
        if (paramValue == "-9999") {
            isPortal = true;
        }
        //重新绑定菜单项onclick事件
        lMNavEventRebind(jQuery(ele).children(".slideItemText").html(), isPortal);
        //对通信菜单进行特殊处理
        if(paramValue==107){
        	var firstLevels = jQuery("#drillmenu").children("ul").children("li.liCss");
        	firstLevels.each(function(index,obj){
        		if(index==0){
        			jQuery("#drillcrumb").text(jQuery(obj).children("div").find("span.e8text").text());
        			jQuery(obj).children("div").hide();
        		}
        		jQuery(obj).css("background-color","transparent");
        		jQuery(obj).children("div").css("padding-left","0px").css("margin-left","10px");
        		//jQuery(obj).children("div").css("border-bottom","1px solid #565656");
        		jQuery(obj).children("div").find("span.bzCls").hide();
        		jQuery(obj).children("div").children("a").click();
        		//jQuery(obj).children("div").find(".leftMenuItemCenter").css("color","#A19E9E");
        		jQuery(obj).children("div").children("a").removeAttr("oldclick");
        		jQuery(obj).children("ul").children("li.liCss2").children("div.divCss").addClass("e8comLevel1");
        	});
        }
        //同步菜单高度
        syncLMHeight();
        //左侧菜单onclick事件
        lMNavBindClick();
        jQuery(leftMenuHtml).show();
        //选中第一个菜单项
        
        if(isPortal&&defaultHpid!=0){
        	isOpenFirstMenu = false;
        }else{
        	isOpenFirstMenu=true;
        }
        if("<%=showlasthp%>"!="1"){
        	isOpenFirstMenu=true;
        }
        
        lMnavToFirstNav(isOpenFirstMenu);
       updateHandleRequest();
        
    } else if (paramValue == "110" || paramValue == "114" || paramValue == "111") {
        //清空滚动导航项
        jQuery("#navTd").html("");
        currMObj = null;
        //隐藏导航
        //loadding...
        jQuery("#drillmenu").html("<span style=\"align:center;padding-top:50px;padding-left:50px;\"><img src=\"/wui/theme/ecology8/page/images/leftmenu/loader_wev8.gif\"></span>");
        
        jQuery("#drillcrumb").html(paramValue == "114" ? "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>" : (paramValue == "110" ? "<%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%>"));
        jQuery.ajax({
            url: "/wui/theme/ecology8/page/ajaxGetMenu.jsp?typeid=" + paramValue + "&parentid=" + (paramValue == "114" ? "" : "10") + "&lftmn" + new Date().getTime() + "=",
            dataType: "text", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){}, 
            success:function(content){ 
                jQuery(content).hide();
                jQuery("#drillmenu").html(content);
				updateScroll("#leftMenu","#drillmenu");
                //-------------------------------------
		        // 20110526 自适应宽度 start
		        //-------------------------------------
		        jQuery(".leftMenuItemRight").css("left", leftMenuItemWidth -  5); 
				//jQuery(".leftMenuItemCenter").css("width", leftMenuItemWidth - 11 - 5);
				if (leftMenuItemWidth < 150) {
					setLeftMenuItemFontLt();
				}
		        //-------------------------------------
		        // 20110526 自适应宽度 end
		        //-------------------------------------
				if (paramValue != "111") {
                	menuMap.put(paramValue, content);
                }
                jQuery("#leftMenu").scrollTo( {top:'0px',left:+'0px'}, 0 );
                //重新绑定菜单项onclick事件
                lMNavEventRebind(jQuery(ele).children(".slideItemText").html());
                //同步菜单高度
                syncLMHeight();
                lMNavBindClick();
                jQuery(content).show();
                //选中第一个菜单项
                lMnavToFirstNav(isOpenFirstMenu);
				updateHandleRequest();				
            }  
        });
    }
} 



function dymLMNav() {
    var navCnt = 0;
    var flag = (jQuery("#leftMenu")[0].scrollHeight/leftMenuScrollHeight + "").indexOf("."); 
    if (flag != -1 ) {
        navCnt = parseInt(jQuery("#leftMenu")[0].scrollHeight/leftMenuScrollHeight);
    } else {
        navCnt = parseInt(jQuery("#leftMenu")[0].scrollHeight/leftMenuScrollHeight) - 1;
    }
    
    var navSpan = "";
    if (navCnt > 0) {
        navSpan = "<span navIndex=\"0\" style=\"display:inline-block;margin-left:3px;margin-right:3px;margin-top:1px;height:25px;width:25px;cursor:pointer;background:url(/wui/theme/ecology8/page/images/leftmenu/1_wev8.png);background-repeat: no-repeat;background-position: center center;\">&nbsp;</span>";
    }
    
    for (var i=1; i<=navCnt; i++) {
        navSpan += "<span navIndex=\"" + i + "\" style=\"display:inline-block;margin-left:3px;margin-right:3px;margin-top:1px;height:25px;width:25px;cursor:pointer;background:url(/wui/theme/ecology8/page/images/leftmenu/lm_nav_wev8.png);background-repeat: no-repeat;background-position: center center;\">&nbsp;</span>";                
    }
    
    jQuery("#navTd").html(navSpan)
}


var currentNav = 0;
function lMNavBindClick() {
    dymLMNav();
    jQuery("#navTd span").bind("click", function() {lMNavClick(jQuery(this));});
    
    jQuery("#navTd span").hover(function(){
        $this = jQuery(this);
        var navIndex = $this.attr("navIndex");
        if (currentNav != navIndex) {
            $this.css("background", "url(/wui/theme/ecology8/page/images/leftmenu/" + (parseInt(navIndex) + 1) + ".png) no-repeat ");
			$this.css("background-position","center center")
        }
        
    }, function() {
        $this = jQuery(this);
        var navIndex = $this.attr("navIndex");
        if (currentNav != navIndex) {
            $this.css("background", "url(/wui/theme/ecology8/page/images/leftmenu/lm_nav_wev8.png) no-repeat");
			$this.css("background-position","center center")
        }
        
    });
}

function lMNavClick($this) {
    var navIndex = $this.attr("navIndex");
    currentNav = navIndex;
    $this.parent().children('span').css("background", "url(/wui/theme/ecology8/page/images/leftmenu/lm_nav_wev8.png) no-repeat");
	$this.parent().children('span').css("background-position","center center")
    
    $this.css("background", "url(/wui/theme/ecology8/page/images/leftmenu/" + (parseInt(navIndex) + 1) + ".png) no-repeat");
    $this.css("background-position","center center")
    jQuery("#leftMenu").scrollTo( {top: navIndex * leftMenuScrollHeight + 'px',left:+'0px'}, leftMenuScrollSpeed );
}

/**
 * 移动第一个菜单的导航位置
 */
function navMoveFstIfrmClk(_this) {
        
        var abg = jQuery(_this).attr("_bgPosition");        
		var htmText = jQuery(_this).find(".leftMenuItemCenter").text();
		//取得菜单项的多级标志（箭头图片）
        var htmImg = jQuery(jQuery(_this)[0]).html().substring(0, jQuery(jQuery(_this)[0]).html().toUpperCase().indexOf("<DIV"));
		jQuery(".leftMenuItemNavLeft").css("background-position", abg);
		jQuery(".leftMenuItemNavRight").css("background-position", abg);
		jQuery(".leftMenuItemNavCenter").css("background-position", abg).html("<span title='" + htmText + "' >" + htmText + "</span>");
		
}

function lMnavToFirstNav(isOpenFirstMenu) {
	var first ;
	  
	if(isOpenFirstMenu!=false){
		first = jQuery("#drillmenu ul li a").get(0);
	}else{
		//alert(jQuery("#portal"+defaultHpid).attr("href"))
		first = jQuery("#portal"+defaultHpid).get(0);
		//alert($(first).attr("isfirstlevel"))
		if($(first).attr("isfirstlevel")==undefined||$(first).attr("isfirstlevel")=="false"){
			
			var parent = $(first).parents("li").find("a[isfirstlevel='true']");
			//alert('do'+parent.length)
			toggleMenu(parent);
		}
	}
    var parentid = jQuery(first).find("span.e8_number").attr("id");
    if(parentid && (parentid=="num_11"||parentid=="num_583")){//通信菜单特殊处理
    	jQuery(".aSelected").removeClass("aSelected");
    	first = jQuery(first).closest("li").children("ul").children("li").find("a").get(0);
    }
    var openFlag = jQuery(jQuery("#drillmenu ul li")[0]).children(".drillmenu").length;
   //alert(openFlag);
    var hphf = jQuery(first).attr("href");

    if((hphf != undefined && hphf != null && hphf != "" && hphf.indexOf("Homepage.jsp") != -1) || openFlag == 0 ) {

       if (first != undefined && first != null && first != "") {
            navMoveFstIfrmClk(first);
            if (checkHref(hphf)) {

            	lMOpenUrl(jQuery(first));
            	//jQuery("#mainFrame").attr("src", jQuery(first).attr("href"));
            }
			//jQuery("#drillmenu").css("width",jQuery("#leftmenucontainer").css("width"));
		  jQuery(first).closest("li").addClass("liSelected");
		  jQuery(first).children("div").addClass("aSelected");
		  /*window.setTimeout(function(){
			  var dest = jQuery(first).find("span.bzCls");
			  var destImage = dest.css("background-image");
			  try{
			  	  if(destImage.indexOf("_sel")==-1){
				  	destImage = destImage.replace(".png","_sel_wev8.png");
				  }
				  dest.css("background-image",destImage);
				}catch(e){}
			},100);*/
		  try{
				//eval(jQuery(first).attr("oldClick"));
		  }catch(e){}
			//lMOpenUrl(jQuery(first));
        } 
    }
}

function checkHref(mhref){
	if(mhref != undefined && mhref != null && mhref != "" && mhref.indexOf("void(0)") != -1)
		return false;
	return true;
}

function lMNavEventRebind(fnavUrlName, isPortal) {
    //取消事件绑定
    jQuery(".drillmenu ul li a").unbind("click");
    //重新绑定事件
    jQuery(".drillmenu ul li a").bind("click", function() {
        currMObj = this;
        
        if ((jQuery(this) != undefined 
                && jQuery(this).attr("href") != undefined
                && jQuery(this).attr("href") != ""
                && jQuery(this).attr("href") != "#"
                )
                || isPortal == true) {
			jQuery("#drillmenu").find("li.liSelected").removeClass("liSelected");
			 if(jQuery(this).attr("isfirstlevel")=="true"){
				/*var src = jQuery("#drillmenu").find("div.aSelected").find("span.bzCls");
				 var srcImage  = src.css("background-image");
				 try{
					 srcImage = srcImage.replace(/_sel/g,"");
				     src.css("background-image",srcImage);
				  }catch(e){}*/
			}
			//jQuery("#drillmenu").css("width",jQuery("#leftmenucontainer").css("width"));
		   jQuery("#drillmenu").find("div").removeClass("aSelected");
		   jQuery("#freqUseBlk").find(".aSelected").removeClass("aSelected");
		  jQuery(this).closest("li").addClass("liSelected");
		  jQuery(this).children("div").addClass("aSelected");
		  if(jQuery(this).attr("isfirstlevel")=="true"){
			  /*var dest = jQuery(this).find("span.bzCls");
			  var destImage = dest.css("background-image");
			  try{
			  	if(destImage.indexOf("_sel")==-1){
				  destImage = destImage.replace(".png","_sel_wev8.png");
				}
				  dest.css("background-image",destImage);
				}catch(e){}*/
			}
		eval(jQuery(this).attr("oldclick"));
			lMOpenUrl(jQuery(this));
			navMoveIfrmClk(this);
			if(!isJSOpen(jQuery(this)))
               return false;
        }
    });
    
    jQuery("#drillmenu").unbind();
    jQuery("#drillcrumb").unbind();

	try{
		if(fnavUrlName == undefined || fnavUrlName == null || fnavUrlName== ""){
			fnavUrlName="<%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%>";
		}
	}catch(e){
	}
       
}

function navMoveIfrmClk(_this) {
        
        var abg = jQuery(_this).attr("_bgPosition");        
		var htmText = jQuery(_this).find(".leftMenuItemCenter").text();;
		var htmImg = jQuery(jQuery(_this)[0]).html().substring(0, jQuery(jQuery(_this)[0]).html().toUpperCase().indexOf("<DIV"));
		jQuery(".leftMenuItemNavLeft").css("background-position", abg);
		jQuery(".leftMenuItemNavRight").css("background-position", abg);
		jQuery(".leftMenuItemNavCenter").css("background-position", abg).html("<span title='" + htmText + "' >" + htmText + "</span>");
}



function syncLMHeight() {
     //同步菜单高度
       //jQuery("#drillmenu").height(jQuery("#drillmenu ul").height());
	   //jQuery("#drillmenu").height(jQuery("#leftmenucontainer").height()-jQuery("#lftop").height()-jQuery("#drillcrumb").closest("div").height()-jQuery("#leftBlock_HrmDiv").closest("table").height()+21);
       /* if (jQuery("#drillmenu ul").height() < LEFT_MENU_MAX_HEIGHT) {
            //jQuery("#leftMenu").height(jQuery("#drillmenu").height());
			jQuery("#leftMenu").height(jQuery("#leftmenucontainer").height()-jQuery("#lftop").height()-jQuery("#drillcrumb").closest("div").height()-jQuery("#leftBlock_HrmDiv").closest("table").height()-jQuery("#lftop").height()+68);
            setMainElementHeight(jQuery("#drillmenu").height());
        } else {
            //jQuery("#leftMenu").height(LEFT_MENU_MAX_HEIGHT);
			jQuery("#leftMenu").height(jQuery("#leftmenucontainer").height()-jQuery("#lftop").height()-jQuery("#drillcrumb").closest("div").height()-jQuery("#leftBlock_HrmDiv").closest("table").height()+68);
            setMainElementHeight(LEFT_MENU_MAX_HEIGHT);
        }*/
		jQuery("#leftmenucontainer").height(jQuery(window).height()-jQuery("#lftop").height());
		if(isIE()){
			setBodyScroll();
			jQuery("#leftMenu").height(jQuery("#leftmenucontainer").height()-jQuery("#lftop").height()-jQuery("#drillcrumb").closest("div").height()-jQuery("#leftBlock_HrmDiv").closest("div").height()-jQuery("#freqUseBlk").height()-jQuery("#lftop").height()+39);
		}else {
			setBodyScroll();
			jQuery("#leftMenu").height(jQuery("#leftmenucontainer").height()-jQuery("#lftop").height()-jQuery("#drillcrumb").closest("div").height()-jQuery("#leftBlock_HrmDiv").closest("div").height()-jQuery("#freqUseBlk").height()-jQuery("#lftop").height()+42);
		}
            setMainElementHeight(jQuery("#drillmenu").height());
}

function syncLMHeightForMail() {
    //同步菜单高度
    var clientScreenHeight = document.body.clientHeight;
    tpLeftMenuMaxHeight = clientScreenHeight-290
    jQuery("#leftMenu").height(tpLeftMenuMaxHeight);
    jQuery("#drillmenu").height(tpLeftMenuMaxHeight);
    
    setMainElementHeight(tpLeftMenuMaxHeight);
     
}


function lMOpenUrl($this) {
	var _target = $this.attr("target");
	
	try{		
		if (getEvent().shiftKey || shiftKeyFlag) {
			_target = "_blank";
			shiftKeyFlag = false;
		}
	}catch(e){}
	
	var linksrc = $this.attr("href");
	var host = document.location.host;
	var flag = false;
	if(linksrc.indexOf("javascript")==-1){
		if(linksrc.substring(linksrc.lastIndexOf("/"))!="/"){
			if(linksrc.indexOf(".html")==-1){
				if(linksrc.indexOf(host)>-1){
					flag = true;
				}else if(linksrc.charAt(0)=='/'){
					flag = true;
				}
			}
		}
		if(flag){
			if (linksrc.indexOf("?") != -1) {
				linksrc += "&";
			} else {
				linksrc += "?";
			}			
			linksrc += "e7" + new Date().getTime() + "=";
		}
		try{
		if(linksrc.toLowerCase().indexOf("ftp")!=-1){
			linksrc = $this.attr("href");
		}
		window.open(linksrc, _target);
		}catch(e){}
	}
} 

function isJSOpen($this){
   var linksrc = $this.attr("href");
   if(linksrc.indexOf("javascript")==-1)
      return false;
   else 
      return true;   
}

function randomChar(l) {
    var x="123456789poiuytrewqasdfghjklmnbvcxzQWERTYUIPLKJHGFDSAZXCVBNM";
    var tmp="";
    for(var i=0; i< l; i++) {
        tmp += x.charAt(Math.ceil(Math.random()*100000000)%x.length);
    }
  return tmp;
}



function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}
</script>

<script type="text/javascript" src="/wui/theme/ecology8/page/js/treeMenu_wev8.js"></script>