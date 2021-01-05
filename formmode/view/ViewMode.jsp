<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="modeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="ExpandInfoService" class="weaver.formmode.service.ExpandInfoService" scope="page" />

<!DOCTYPE HTML>
	<HEAD>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/jquery/simpleTabs/simpleTabs_wev8.js"></script>
	
	<style type="text/css">
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px 0 0 2px;
		}
		.e8_form_top{
			padding: 13px 10px 0px 10px;
			position: relative;
			overflow: hidden;
		}
		.e8_form_top_body{
			overflow: hidden;border-bottom:1px solid #e9e9e9;
		}
		.e8_form_top .e8_from_info{
			width:300px;
			float:left;
			padding-bottom: 16px;
		}
		.e8_form_top .e8_from_name{
			color: #333;
		}
		.e8_form_top .e8_from_modify{
			color: #AFAFAF;
		}
		.e8_form_top .e8_form_tabs{
			float:left;
			margin-top:0px;
		}
		.e8_form_top ul{
			list-style: none;
			white-space: nowrap;
			overflow:hidden;
			float:left;
		}
		.e8_form_top ul li{
		    font-size: 12px;
			padding: 0px 5px 0px 5px;
			display:inline-block;
			float:left;
			height:22px;
		}
		.e8_form_top ul li a{
		    font-size: 12px;
			color: #A3A3A3;
			text-decoration: none;
			cursor: pointer;
			height:20px;
			border-bottom: 2px solid #fff;
		}
		
		.e8_form_top .e8_form_tabs ul li.selected a{
		    font-size: 12px;
			color: #0072C6;		
			border-bottom: 2px solid #0072C6 !important;
		}
		.e8_form_center{
			overflow: hidden;
			padding: 0px 10px;
		}
		.e8_form_center .e8_form_frameContainer{
			display: none;
			height: 100%;
		}
		.loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		.e8_from_logo{
			width:40px;
			float:left;
			margin:2px 10px 0 0;
		}
		.e8_form_tabs_button{
			width:18px;
			height:18px;
			float: left;
			margin-top:8px;
			background: url("/js/tabs/images/uparrow_wev8.png") no-repeat;
			cursor:pointer;
			display:none;
		}
		.e8_form_tabs_more{
			position:absolute;
			background:#fffff;
			z-index:20001;
			border:1px solid #ccc;
			top:38px;
			right:10px;
			width: 120px;
			display: none;
		}
		
		.e8_form_tabs_more ul{
		    font-size: 12px;
			list-style: none;
			background-color:#ffffff;
		}
		
		.e8_form_tabs_more ul li:hover{
		    font-size: 12px;
			background-color:#E6E6E6 !important;
		}
		
		.e8_form_tabs_more ul li.selected{
		    font-size: 12px;
			background-color:#E8F2FE;
		}
		
		.e8_form_tabs_more ul li a{
		    font-size: 12px;
			color: #A3A3A3;
			padding: 5px;
			text-decoration: none;
			cursor: pointer;
		}
		
		.e8_form_tabs_more ul li.selected a{
		    font-size: 12px;
			color: #0072C6;
		}
	</style>
	</HEAD>
<%
	//type=0&modeId=2&formId=-241&billid=103
	String logintype = user.getLogintype();
	String type = Util.null2String(request.getParameter("type"));
	boolean checkisRight = false;
	if(logintype.equals("2") && type.equals("0")){
		checkisRight = true;
	}
	String modeId = Util.null2String(request.getParameter("modeId"));
	String formId = Util.null2String(request.getParameter("formId"));
	String billid = Util.null2String(request.getParameter("billid"));
	int fromSave = Util.getIntValue(request.getParameter("fromSave"),0);
	int customid = Util.getIntValue(request.getParameter("customid"),0);
	String sql = "";
	String iframeList = "";
	String pkfield = Util.null2String(request.getParameter("pkfield"));//主键字段，用于浏览按钮设置主键字段时解析billid
	if(!"id".equals(pkfield)&&!"".equals(pkfield)){//当设置了主键时，重新解析billid
		FormManager fManager = new FormManager();
		String table = fManager.getTablename(formId);
		try {
			rs.executeSql("select id from "+table+" where "+pkfield+"='"+billid+"' and formmodeid="+modeId);
			if(rs.next()){
				billid = Util.null2String(rs.getInt("id"));
			}
		} catch(Exception e) {}	
	}
	//============================================虚拟表基础数据====================================
	String vdatasource = null;	//虚拟表单数据源
	String vprimarykey = "id";	//虚拟表单主键列名称
	boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formId);	//是否是虚拟表单
	Map<String, Object> vFormInfo = new HashMap<String, Object>();
	if(isVirtualForm){
		vFormInfo = VirtualFormHandler.getVFormInfo(formId);
		vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//虚拟表单数据源
		vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//虚拟表单主键列名称
	}
	expandBaseRightInfo.setUser(user);
	ModeRightInfo.setModeId(Util.getIntValue(modeId));
	ModeRightInfo.setType(Util.getIntValue(type));
	ModeRightInfo.setUser(user);
	boolean isRight = false;
	boolean isEdit = false;		//是否有编辑权限，主要针对右键按钮是否显示
	boolean isDel = false;		//是否有删除权限，主要针对右键按钮是否显示
	if(Util.getIntValue(type) == 1 || Util.getIntValue(type) == 3){//新建、监控权限判断
		if(Util.getIntValue(type) == 3){
			FormModeRightInfo.setUser(user);
			isRight = FormModeRightInfo.checkUserRight(customid,4);
		}
		if(!isRight)
			isRight = ModeRightInfo.checkUserRight(Util.getIntValue(type));
	}
	ModeShareManager.setModeId(Util.getIntValue(modeId));
	if(Util.getIntValue(type) == 0 || Util.getIntValue(type) == 2){//查看、编辑权限
		String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",user);
		
		rs.executeSql("select * from "+rightStr+" t where sourceid="+billid);
		if(rs.next()){
			int MaxShare = rs.getInt("sharelevel");
			isRight = true;
			if(MaxShare > 1) {
				isEdit = true;		//有编辑或完全控制权限的出现编辑按钮
				if(MaxShare == 3) isDel = true;		//有完全控制权限的出现删除按钮
			}
		}
	}
	if(checkisRight){
		isRight = true;
}
	String formmodeflag = StringHelper.null2String(request.getParameter("formmode_authorize"));
	if(formmodeflag.equals("formmode_authorize")){
		isRight = true;
	}

	if(!isRight&&!isVirtualForm){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//虚拟表单删除和编辑不用校验权限  默认为true
	if(isVirtualForm){
		isEdit = true;
		isDel = true;
	}
	
	
	//获得主表的数据
	FieldInfo.setUser(user);
	HashMap hm = FieldInfo.getMainTableData(modeId,formId,billid);
	
	//获得模块的主字段
	HashMap modeMainFieldMap = FieldInfo.getModeFieldList(modeId);

	FormManager fManager = new FormManager();
%>
<BODY>
	
		<div class="e8_form_tabs_more">
		<ul></ul>
	    </div>

	<div class="e8_form_top">
		<div class="e8_form_top_body">
		 	<div class="e8_form_tabs">
				<ul>
				   					<%
				   						String modename = "";
				   						sql = "select * from modeinfo where id = " + modeId;
				   						rs.executeSql(sql);
				   						while(rs.next()){
				   							modename = rs.getString("modename");
				   						}
				   						String mainmodehreftarget = "/formmode/view/AddFormMode.jsp?isfromTab=1&type="+type+"&modeId="+modeId+"&formId="+formId+"&billid="+billid+"&fromSave="+fromSave;
				   						mainmodehreftarget = mainmodehreftarget+"&"+Util.null2String(request.getQueryString());
				   						iframeList=" <iframe src='"+mainmodehreftarget+"'  id='iframepage'  frameBorder=0 scrolling=auto width=100% height='100%' onload=\"loading()\"  style='display:block;'></iframe>";
				   					%>
				   					<li href="#tabs-content-0" defaultSelected="true" url="<%=mainmodehreftarget%>" title="<%=modename%>">
				   						<a href="<%=mainmodehreftarget%>" target="tabcontentviewframe"><%=modename %></a>
				   					</li>
				   					
						   		<%
						   			//只查询顶部tab页
						   			String addpagesql = "";
						   			if(Util.getIntValue(type) == 0){//显示
						   				addpagesql = "and viewpage=1";
						   			}else if(Util.getIntValue(type) == 2){//编辑
						   				addpagesql = "and managepage=1";
						   			}else if(Util.getIntValue(type) == 1){//新建
						   				addpagesql = "and createpage=1";
						   			}
						   			sql = "select id,expendname,showtype,opentype,hreftype,hrefid,hreftarget,showorder,issystem from mode_pageexpand where modeid = "+modeId+" and isshow = 1 "+addpagesql+" and showtype = 1 and (tabshowtype is null or tabshowtype=0) and isbatch in(0,2) order by showorder asc";
						   			rs.executeSql(sql);
						   			
						   			while(rs.next()){
						   				String detailid = Util.null2String(rs.getString("id"));
						   				if(!expandBaseRightInfo.checkExpandRight(detailid, Util.null2String(modeId), billid)) {
											continue;
										}
						   		    	String expendname = Util.null2String(rs.getString("expendname"));
						   		    	String hreftitle = Util.null2String(rs.getString("expendname"));
						   		    	String hreftarget = Util.null2String(rs.getString("hreftarget"));
						   		    	int hreftype = rs.getInt("hreftype");
						   		    	int hrefid = rs.getInt("hrefid");
						   		    	boolean isshowcurrentpage = true;
						   		    	String tableName = isVirtualForm ? VirtualFormHandler.getRealFromName(fManager.getTablename(formId)) : fManager.getTablename(formId);
						   		    	if(hreftype==1&&hrefid>0){//模块
						   		    		sql = "select * from modeinfo where id = " + hrefid;
						   		    		RecordSet.executeSql(sql);
						   		    		//out.println(sql);
											if(RecordSet.next()){
												int modeformid = RecordSet.getInt("formid");
												String vdatasource_ = null;	//虚拟表单数据源
												String vprimarykey_ = "id";	//虚拟表单主键列名称
												boolean isVirtualForm_ = VirtualFormHandler.isVirtualForm(modeformid);	//是否是虚拟表单
												Map<String, Object> vFormInfo_ = new HashMap<String, Object>();
												tableName = fManager.getTablename(modeformid);
												if(isVirtualForm_){
													vFormInfo_ = VirtualFormHandler.getVFormInfo(modeformid);
													vdatasource_ = Util.null2String(vFormInfo_.get("vdatasource"));	//虚拟表单数据源
													vprimarykey_ = Util.null2String(vFormInfo_.get("vprimarykey"));	//虚拟表单主键列名称
													tableName = VirtualFormHandler.getRealFromName(tableName);
												}
												String sqlwhere = FieldInfo.getRelateSqlWhere(modeId,hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm);
												sql = "select "+vprimarykey_+" from " + tableName + " " + sqlwhere;
												
												String fromSql;
												//查询有权限查询的数据是否存在，如果存在的话，就进入查看页面，如果不存在，则新建
												if(isVirtualForm_){	//是虚拟表单
													fromSql  = sql;
												}else{
													modeShareManager.setModeId(hrefid);
													String rightStr = modeShareManager.getShareDetailTableByUser("formmode",user);
													fromSql = "select * from "+rightStr+" t ";
													fromSql = fromSql + ",("+sql+") t2 where t.sourceid=t2.id " ;
												}
												fromSql += " order by " + vprimarykey_;
												RecordSet.executeSql(fromSql,vdatasource_);
												
												if(RecordSet.next()){//存在直接打开数据
													type = "0";
													String subid = RecordSet.getString(vprimarykey_);
													//http://127.0.0.1:86/formmode/view/addformmode.jsp?isfromTab=1&type=0&modeId=10&formId=-257&billid=5
													hreftarget = "/formmode/view/AddFormMode.jsp?type="+type+"&modeId="+hrefid+"&formId="+modeformid+"&billid="+subid;
												}else{//如果不存在，新建数据
													hreftarget = FieldInfo.getRelateHrefAddress(modeId,hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm,modeMainFieldMap);
												}
											}
						   		    	}else if(hreftype==3&&hrefid>0){//模块查询列表
						   		    		try{
						   		    			hreftarget = FieldInfo.getRelateHrefAddress(modeId,hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm,modeMainFieldMap);
						   		    		}catch(Exception e){
						   		    			out.println(e);
						   		    		}
						   		    	}else{
						   		    		hreftarget = FieldInfo.getRelateHrefAddress(modeId,hrefid,hreftype,Util.getIntValue(detailid,0),hreftarget,hm,modeMainFieldMap);
						   		    	}
						   		    	
						   		    	if(hreftarget.indexOf("?")>-1){
						   		    		hreftarget = hreftarget + "&isfromTab=1";
						   		    	}else{
						   		    		hreftarget = hreftarget + "?isfromTab=1";
						   		    	}
						   		    	hreftarget += "&tabid="+detailid;

								%>
										<li href="#tabs-content-<%=detailid%>" url="<%=hreftarget%>" title="<%=hreftitle%>">
											<a href="<%=hreftarget%>" target="tabcontentviewframe"><%=expendname %></a>
										</li>
								<%
						   			}
						   		%>
							</ul>
							<div class="e8_form_tabs_button"></div>
							
		</div>
		
		</div>
	</div>
	
	<div class="e8_form_center">
		<iframe src="<%=mainmodehreftarget %>" id="tabcontentviewframe" name="tabcontentviewframe" class="flowFrame" frameborder="0" height="100%" width="100%;" scrolling="auto"></iframe>
	</div>

<script language="javascript">

$(document).ready(function () {
			$(".e8_form_tabs").simpleTabs();
			$(window).resize(forPageResize);
			forPageResize();
			
			$(".e8_form_tabs_button").hover(function(){
     			var offsetLeft=$(".e8_form_tabs_button")[0].offsetLeft-102;
				$(".e8_form_tabs_more").css("left",offsetLeft<0?0:offsetLeft);
				$(".e8_form_tabs_more").slideDown(100);
				$(".e8_form_tabs_button").data("isOpen",true);
			},function(){
				$(".e8_form_tabs_button").data("isOpen",false);
				window.setTimeout(function(){
					if(!$(".e8_form_tabs_button").data("isOpen")){
						$(".e8_form_tabs_more").slideUp(100);
					}
				},600);
			});
			
			$(".e8_form_tabs_more").hover(function(){
				$(".e8_form_tabs_button").data("isOpen",true);
			},function(){
				$(".e8_form_tabs_button").data("isOpen",false);
				window.setTimeout(function(){
					if(!$(".e8_form_tabs_button").data("isOpen")){
						$(".e8_form_tabs_more").slideUp(100);
					}
				},600);
			});
		});
		
		function forPageResize(){
			var $body = $(document.body);
			var $e8_form_top = $(".e8_form_top");
			var $e8_form_center = $(".e8_form_center");
			var centerHeight = $body.height() - $e8_form_top.outerHeight(true);
			
			$e8_form_center.height(centerHeight);
			changeTabsWidth();
		}
		
		function changeTabsWidth(){
			var $body = $(document.body);
			var $e8_form_tabs_button=$(".e8_form_tabs_button");
			var buttonWidth=$e8_form_tabs_button.outerWidth(true);
			var tabsWidth=$body.width()-30;
			if(tabsWidth<buttonWidth){
				tabsWidth=buttonWidth;
			}
			var hasRemoveTabs=removeTabs(tabsWidth);
			if(!hasRemoveTabs){
				retrieveTabs(tabsWidth);
			}
		}
		
		function removeTabs(tabsWidth){
			var $e8_form_tabs=$(".e8_form_tabs");
			var $e8_form_tabs_more_ul=$(".e8_form_tabs_more ul");
			var $e8_form_tabs_button=$(".e8_form_tabs_button");
			var buttonWidth=$e8_form_tabs_button.outerWidth(true);
			var $ul_temp=$("<ul></ul>");
			var lisWidth=0;
			var endflag=false;
			$(".e8_form_tabs ul li").each(function(){
				var liWidth=$(this).outerWidth(true);
				$(this).attr("liwidth",liWidth);
				lisWidth+=liWidth;
				if(endflag){
					$ul_temp.append($(this));
				}else if((tabsWidth<=buttonWidth)||tabsWidth<(buttonWidth+lisWidth)){
					endflag=true;
					$ul_temp.append($(this));
				}
			})
			if(endflag){
				$e8_form_tabs_more_ul.prepend($ul_temp.children("li"));
				$e8_form_tabs_button.show();
				$e8_form_tabs.width(tabsWidth);
			}
			return endflag;
		}
		
		function retrieveTabs(tabsWidth){
			var $e8_form_tabs=$(".e8_form_tabs");
			var $e8_form_tabs_ul=$(".e8_form_tabs ul");
			var $e8_form_tabs_button=$(".e8_form_tabs_button");
			var buttonWidth=$e8_form_tabs_button.outerWidth(true);
			var lisWidth=0;
			$(".e8_form_tabs ul li").each(function(){
				lisWidth+=$(this).outerWidth(true);
			})
			var buttonHidden=false;
			var moreLiSize=$(".e8_form_tabs_more ul li").size();
			$(".e8_form_tabs_more ul li").each(function(i){
				var liWidth=$(this).attr("liwidth");
				lisWidth+=parseInt(liWidth);
				if((lisWidth+buttonWidth)<=tabsWidth){
					$e8_form_tabs_ul.append($(this));
					if(i==moreLiSize-1){
						buttonHidden=true;
					}
				}else if(lisWidth<=tabsWidth&&i==moreLiSize-1){
					$e8_form_tabs_ul.append($(this));
					buttonHidden=true;
				}
			})
			if(buttonHidden){
				$e8_form_tabs.width(tabsWidth);
				$e8_form_tabs_button.hide();
			}else if(lisWidth<=tabsWidth){
				$e8_form_tabs.width(tabsWidth);
			}else{
				$e8_form_tabs.width(tabsWidth);
			}
		}
</script>
</BODY></HTML>
