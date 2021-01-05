
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.homepage.HomepageBean"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.*,weaver.hrm.settings.RemindSettings,weaver.general.GCONST,weaver.general.StaticObj" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<%
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String message0 = Util.null2String(request.getParameter("message")) ;
String message=message0;
String loginid="";
String OpenPasswordLock = settings.getOpenPasswordLock();
if(message0.equals("nomatch")) message = "";
if(!message.equals("")) message = SystemEnv.getErrorMsgName(Util.getIntValue(message0),7) ;
if("16".equals(message0)){
	if("1".equals(OpenPasswordLock)){
		rs.executeSql("select id from HrmResourceManager where loginid='"+loginid+"'");
		if(!rs.next()){
			loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
			String sql = "select sumpasswordwrong from hrmresource where loginid='"+loginid+"'";
			rs1.executeSql(sql);
			rs1.next();
			int sumpasswordwrong = Util.getIntValue(rs1.getString(1));
			int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
			int leftChance = sumPasswordLock-sumpasswordwrong;
			if(leftChance==0){
				sql = "update HrmResource set passwordlock=1,sumpasswordwrong=0 where loginid='"+loginid+"'";
				rs1.executeSql(sql);
				message0 = "110";
			}else{
				message = SystemEnv.getHtmlLabelName(24466,7)+leftChance+SystemEnv.getHtmlLabelName(24467,7);
			}
		}
	}
}
session.removeAttribute("tmploginid1");
if(message0.equals("16")) {
	loginid = "";
} 
if(message0.equals("101")) {
    //loginid=Util.null2String((String)session.getAttribute("tmploginid"));
    //session.removeAttribute("tmploginid");
    message=SystemEnv.getHtmlLabelName(20289,7);
}
if(message0.equals("110")) 
{
	loginid = "";
	int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
    message=SystemEnv.getHtmlLabelName(24593,7)+sumPasswordLock+SystemEnv.getHtmlLabelName(18083,7)+"，"+SystemEnv.getHtmlLabelName(24594,7);
}
if((message0.equals("101")||message0.equals("57"))&&loginid.equals("")){
    message="";
}
String logintype = Util.null2String(request.getParameter("logintype")) ;
if(logintype.equals("")) logintype="1";

//IE 是否允许使用Cookie
String noAllowIe = Util.null2String(request.getParameter("noAllowIe")) ;
if (noAllowIe.equals("yes")) {
	message = "IE"+SystemEnv.getHtmlLabelName(83703,7)+"Cookie";
}

//用户并发数错误提示信息
if (message0.equals("26")) { 
	message = SystemEnv.getHtmlLabelName(23656,7);
}

//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();//0: 否,1: 是
int validatetype=settings.getValidatetype();//验证码类型，0：数字；1：字母；2：汉字
int islanguid = 0;//7: 中文,9: 繁体中文,8:英文
Cookie[] systemlanid= request.getCookies();
for(int i=0; (systemlanid!=null && i<systemlanid.length); i++){
	//System.out.println("ck:"+systemlanid[i].getName()+":"+systemlanid[i].getValue());
	if(systemlanid[i].getName().equals("Systemlanguid")){
		islanguid = Util.getIntValue(systemlanid[i].getValue(), 0);
		break;
	}
}
boolean ismuitlaguage = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
	multilanguage = (String)staticobj.getObject("multilanguage") ;
}
if("y".equals(multilanguage)){
	ismuitlaguage = true;
}
if("16".equals(message0) || "17".equals(message0)){
	message=SystemEnv.getHtmlLabelName(124919,7);
		//message = "用户名或密码有误";
}
%>

<%
if(message0.equals("46")){
	String usbType = settings.getUsbType();
%>
<script language="JavaScript">
flag=confirm('<%=SystemEnv.getHtmlLabelName(83709,7)%>')
if(flag){
	<%if("1".equals(usbType)){%>
		window.open("/weaverplugin/WkRt.exe")
	<%}else{%>
		window.open("/weaverplugin/HaiKeyRuntime.exe")
	<%}%>
}
</script>
<%}%>
<%
	//Get Parameter
	int hpidInt = Util.getIntValue(Util.null2String(request.getParameter("hpid")),-1);
	String hpid=hpidInt+"";
	int isfromportal = Util.getIntValue(request.getParameter("isfromportal"), 0);
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);
	boolean isSetting = "true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting")));

	//如果首页ID为0将不显示页面
	if ("0".equals(hpid)){
		out.println(SystemEnv.getHtmlLabelName(20276, 7));
		return;
	}	
	
	//计算相关页面数据
	HomepageBean hpb = pu.getHpb(hpid);
	String layoutid = hpb.getLayoutid();
	String styleid = hpb.getStyleid();
	
	String isRedirectUrl = pc.getIsRedirectUrl(hpid);
	if("1".equals(isRedirectUrl)){
		String redirectUrl = pc.getRedirectUrl(hpid);
		if(redirectUrl != null &&!"".equals(redirectUrl)){
			if(!redirectUrl.startsWith("http") && !redirectUrl.startsWith("/")){
				redirectUrl ="http://" + redirectUrl;
			}
			//request.getRequestDispatcher(redirectUrl).forward(request, response);
			response.sendRedirect(redirectUrl);
			return ;
		}	
	}
	
%>
<html>
	<head>
		<!-- 引入CSS -->
	<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
		
	<STYLE TYPE="text/css">
  	<%=pu.getHpCss(hpid,-1,0)%>
  	
  	.layouttable{
  		width:100%;
  	}
  	  .layouttable td{
	  	vertical-align:top;
	  }
	  
	  #Container{
			width:99%;
			margin-left:10px;
		}		

	.item{
		margin-top:10px;
	}
	.group{	
		margin-right:10px;
	}
	td .fieldName,.field,.groupHeadHide *,.LayoutTable .ListStyle td{
		vertical-align:middle !important;
	}
	.slidebox_block {
		position: relative;
		width: 100%;
		height: 100%;
		overflow: hidden;
	}
	.slidebox_list_item {
		width: 100%;
		height: 100%;
		position: absolute;
	}
	.slidebox_list img {
		border: 0px;
	}
	
	.slidebox_btbg {
		position: absolute;
		bottom: 0;
		background-color: #000;
		height: 50px;
		filter: Alpha(Opacity=30);
		opacity: 0.3;
		z-index: 1000;
		cursor: pointer;
		width: 100%;
	}
	
	.slidebox_info {
		position: absolute;
		bottom: 0;
		width: 100%;
		height: 50px;
		color: #fff;
		z-index: 1001;
		cursor: pointer
	}
	
	.slidebox_block ul {
		position: absolute;
		list-style-type: none;
		filter: Alpha(Opacity=80);
		opacity: 0.8;
		z-index: 1002;
		margin: 0;
		padding: 0;
		bottom: 3px;
		left:50%;
	}
	
	.slidebox_block ul li {
		float: left;
		display: block;
		color: #FFF;
		cursor: pointer;
		background:url('/page/element/imgSlide/resource/image/p.png') 0 0 no-repeat;
		width:8px;
		height:8px;
		margin:0px 5px;
	}
	
	.slidebox_block ul li.on {
		background:url('/page/element/imgSlide/resource/image/p_slt.png') 0 0 no-repeat;
	}
	.slidebox_list {
		width:100%;
		height:100%;
	}
	.slidebox_list a {
		position: absolute;
		width:100%;
		height:100%;
	}
	
	.slidebox_info_item {
		text-align:center;
		line-height:50px;
		font-size:16px;
		height:100%;
		width:100%;
		background-color: #fff;
		cursor: pointer;
		overflow:hidden;
		opacity: 0.7;
		z-index: 1000;
		color:#4d4d4d;
		filter: Alpha(Opacity=70);
	}
	.slidebox_info_item_slt {
		background-color: #213d7d;
		color:#fff;
	}
	
	.item .ellipsis{
		display: inline-block;
		
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		max-width:95%;
	}
	.item .elementdatatable{
		table-layout: fixed;
	}
	
	.jCarouselLite li{
		margin-left:2px;
		margin-right:2px;
	}
	.clear {clear:both;display:block;}
	.jCarouselLite{
		margin:auto;
	}
  	</STYLE>  
		<!-- 引入JavaScript -->
		<%=pu.getPageJsImportStr(hpid)%>
		<%=pu.getPageCssImportStr(hpid)%>
		<script type="text/javascript">
			
			
		</script>
	</head>
	<body>
		<textarea id="txtDebug"	style="width: 100%; height: 200px; display: none"></textarea>
		<%=pu.getBaseLoginHpStr(hpid, layoutid, styleid, "hp", subCompanyId, isSetting)%>
	</body>
</html>


<SCRIPT LANGUAGE="JavaScript">
$(document).ready(function(){

});
/*修改相应元素位置 到到相应的元素下去*/
function fixedPosition(eid){	
	//alert(1)
	//$('#item_'+eid).nextAll('.item').find('.header').trigger("focus"); 
	//window.setTimeout("$('#item_"+eid+"').nextAll('.item').find('.header').click();",500);
	//$('#item_'+eid).nextAll('.item').find('.header').css('position','static');	
	//window.setTimeout("$('#item_"+eid+"').nextAll('.item').find('.header').css('position','relative');",500);
	
	
		try{				
			var oFrm=parent.document.getElementById("mainFrame");					
			if(parseInt(oFrm.style.height)<parseInt(document.body.scrollHeight)) {
				oFrm.style.height=document.body.scrollHeight+"px";
			} else {
				oFrm.style.height=document.body.scrollHeight+"px";
			}
		} catch(e){
			log(e)
		}
	
	
}
function stockGopage(type,url){
	 if(type==0)
	 	openFullWindowForXtable(url);
	 else
		 this.location = url;
	}
	
//处理元素样式编辑时没有设置图标图片会出现残图现象
$(".iconEsymbol").bind('error',function(){
	if($(this).attr("src")==''){
		$(this).hide();
	}
})


$(".toolbar").find("img").bind('error',function(){
	if($(this).attr("src")==''){
		$(this).hide();
	}
})


  $(".downarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
  })		  

  
  $(".rightarrowclass").bind('error',function(){
		if($(this).attr("src")==''){
			$(this).hide();
		}
  })	

var message ="<%=message%>";
</SCRIPT>
<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
<script type='text/javascript' src='/js/homepage/Article_wev8.js'></script>
<%@ include file="/js/homepage/LoginHomepage_js.jsp"%>