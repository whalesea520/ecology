<jsp:useBean id="TestWorkflowCheckInitWui" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page"/>
<LINK href="/js/jquery/jquery_dialog_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_dialog_wev8.js"></script>

<script src="/social/js/drageasy/drageasy.js"></script>
<script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>

<script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>
<script type="text/javascript" language="javascript">
function ReloadOpenerByDialogClose() {
    <%out.println(TestWorkflowCheckInitWui.ReloadByDialogClose(request));%>
}

function doScannerEscape(ev, obj){
	IMCarousel.doScannerEscape(ev, obj);
}

function scaleImg(obj, tag){
	IMCarousel.scaleImg(obj, tag);
}

function rotateImg(obj){
	IMCarousel.rotateImg(obj);
}

function downloadImg(obj){
	IMCarousel.downloadImg(obj);
}

function slideImg(obj, direction){
	IMCarousel.slideImg(obj, direction);
}

function showImgScanner(ev, isShow, id){
	IMCarousel.showImgScanner(ev, isShow, id);
}

function downloads(id){
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+id+"&download=1";
}
</script>
<%
    if(TestWorkflowCheckInitWui.checkURI(session,request.getRequestURI(),request.getQueryString())){
        response.sendRedirect("/login/Login.jsp");
        return;
    }
%>
<%@page import="java.util.Map"%><%!
private String getCurrWuiConfig(HttpSession session, User user, String keyword) throws Exception {
	
	if (keyword == null || "".equals(keyword)) {
		return "";
	}
	
	String curTheme = "";
	String curskin = "";

	
		String[] rtnValue = getHrmUserSetting(user);
		
		curTheme = rtnValue[0];
		curskin = rtnValue[1];
		if(curTheme.equals("")||curskin.equals("")){
			String templatetype = getCurrE8TemplateType(user);
			if("".equals(templatetype)){
				curTheme = "ecologyBasic";
				curskin = "default";
			}else if("ecology7".equals(templatetype)){
				curTheme ="ecology7";
				curskin = getCurrE8SkinInfo(user);
			}else{
				curTheme ="ecology8";
				curskin = "default";
			}
			
			
			
			
		}else{
			curTheme = rtnValue[0];
			curskin = rtnValue[1];
		}
		
		if(curTheme.equals("custom")){
			curTheme ="ecology8";
		}
		
		session.setAttribute("SESSION_CURRENT_THEME", curTheme);
		session.setAttribute("SESSION_CURRENT_SKIN", curskin);
	
	if ("THEME".equals(keyword.toUpperCase())) {
		return curTheme;
	}
	
	if ("SKIN".equals(keyword.toUpperCase())) {
		return curskin;
	}
	return "";
}



private String getCurrSkinFolder(User user) throws Exception {
	String pslSkinfolder = "";
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();

	int userid = user.getUID();

	rs.executeSql("select skin from HrmUserSetting where resourceId=" + userid);
	
	if (rs.next()) {
		pslSkinfolder = rs.getString("skin");
	}

	if (pslSkinfolder == null || "".equals(pslSkinfolder)) {
	    pslSkinfolder = "default";
	}
	return pslSkinfolder;
}

private String getCurrE8TemplateType(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	String skin =  userTemplate.getTemplatetype();
	
	
	return skin;
	
}

private String getCurrE8SkinInfo(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	String skin =  userTemplate.getSkin();
	
	
	return skin;
	
}

private int getCurrTemplateId(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	int id =  userTemplate.getTemplateId();
	
	
	return id;
	
}

private String getCurrTemplateLogo(User user){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	String logo =  userTemplate.getLogo();
	
	
	return logo;
	
}

private String[] getHrmUserSetting(User user) throws Exception {
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();

	String[] result = new String[2];
	String theme = "";
	String skin = "";
	
	String sql="select templateid from SystemTemplateSubComp where subcompanyid="+user.getUserSubCompany1();
	rs.executeSql(sql);
	if(rs.next()){	
	
		String curUserCanUse = rs.getString("templateid");
		sql = "SELECT a.* FROM HrmUserSetting a, SystemTemplate  b WHERE a.resourceId="+user.getUID()+" AND a.templateId=b.id  and  b.id="+curUserCanUse;
		rs.execute(sql);
		if(rs.next()){
			theme = rs.getString("theme");
			skin = rs.getString("skin");
			if("ecology8".equals(theme)){
				skin = "default";
			}
			result[0] = theme;
			result[1] = skin;
			return result;
		}
	}
	
	

	
	int userid = user.getUID();
	rs.executeSql("select theme, skin from HrmUserSetting where resourceId=" + userid);
	
	if (rs.next()) {
		theme = rs.getString("theme");
		skin = rs.getString("skin");
	}
	
	//rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + sqltemplateid1 + " and isopen=1 and theme='" + theme + "' and skin='" + skin + "'");
	result[0] = theme;
	result[1] = skin;
	
	
	
	//System.out.println("result"+result[0]+result[1]);
	return result;
}


private java.util.Map getPageConfigInfo(HttpSession session, User user) throws Exception{
	
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	java.util.Map pageConfigkv = new java.util.HashMap();
	
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	pageConfigkv.put("logoTop",userTemplate.getLogo());
	pageConfigkv.put("logoBottom", userTemplate.getLogo());
	pageConfigkv.put("isopen", userTemplate.getIsopen());
	//pageConfigkv.put("islock", rs.getString("islock"));
	
	int extendtempletvalueid = userTemplate.getExtendtempletvalueid();
	rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + extendtempletvalueid + " and isopen=1 and theme='" + getCurrWuiConfig(session, user, "THEME") + "' and skin='" + getCurrWuiConfig(session, user, "SKIN") + "'");
	
	if (rs.next()) {
	
		
		/**
		 * ecologybasic主题用设置项
		 */
		pageConfigkv.put("bodyBg", rs.getString("bodyBg"));
		pageConfigkv.put("topBgImage", rs.getString("topBgImage"));
		pageConfigkv.put("toolbarBgColor", rs.getString("toolbarBgColor"));
		pageConfigkv.put("menuborderColor", rs.getString("menuborderColor"));

		pageConfigkv.put("leftbarBgImage", rs.getString("leftbarBgImage"));
		pageConfigkv.put("leftbarBgImageH", rs.getString("leftbarBgImageH"));

		pageConfigkv.put("leftbarborderColor", rs.getString("leftbarborderColor"));
		pageConfigkv.put("leftbarFontColor", rs.getString("leftbarFontColor"));

		pageConfigkv.put("topleftbarBgImage_left", rs.getString("topleftbarBgImage_left"));
		pageConfigkv.put("topleftbarBgImage_center", rs.getString("topleftbarBgImage_center"));
		pageConfigkv.put("topleftbarBgImage_right", rs.getString("topleftbarBgImage_right"));

		pageConfigkv.put("bottomleftbarBgImage_left", rs.getString("bottomleftbarBgImage_left"));
		pageConfigkv.put("bottomleftbarBgImage_center", rs.getString("bottomleftbarBgImage_center"));
		pageConfigkv.put("bottomleftbarBgImage_right", rs.getString("bottomleftbarBgImage_right"));

	}
	
	return pageConfigkv;
	
}
%>