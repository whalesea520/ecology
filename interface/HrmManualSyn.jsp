
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.resource.HrmSynDAO" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
		<%@ taglib uri="/browserTag" prefix="brow"%>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		</style>
	</head>
	<%
	if (!HrmUserVarify.checkUserRight("intergration:hrsetting", user))
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		HrmSynDAO hrmSynDAO = HrmSynDAO.getInstance();
		hrmSynDAO.loadSyncSet();
		boolean cansync = true;
		//out.println("hrmSynDAO.getIsuselhr() : "+hrmSynDAO.getIsuselhr()+"  hrmSynDAO.getHrmethod() : "+hrmSynDAO.getHrmethod());
		if(!Util.null2String(hrmSynDAO.getIsuselhr()).equals("1"))
		{
			cansync = false;
		%>
		<script language="javascript">
        //QC301936 [80][90]HR同步-解决启用开关未启用，数据同步页面提示信息问题 -start
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33719,32386" ,user.getLanguage())%>!");//HR同步未启用
		//return;
		</script>
		<%
			//return;
		}else if (Util.null2String(hrmSynDAO.getHrmethod()).equals("2")) {
                cansync = false;
        %>
            <script language="javascript">
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32326 ,user.getLanguage())%>!");//HR同步手动同步未启用
        //QC301936 [80][90]HR同步-解决启用开关未启用，数据同步页面提示信息问题 -end
            //return;
            </script>
        <%
            }

		String imagefilename = "/images/hdSystem_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(27236 ,user.getLanguage());//系统手动同步";
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(cansync)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(18240 ,user.getLanguage())+",javascript:onSyn(this),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(17416 ,user.getLanguage())+"EXCEL,javascript:doExcel(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<%
					if(cansync)
					{
					%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(18240 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSyn(this);"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(17416 ,user.getLanguage()) %>EXCEL" class="e8_btn_top" onclick="doExcel()"/>
					<%
					}
					%>
					<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
		   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
		</div>
		<div class="cornerMenuDiv"></div>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
		</div>
		<div id="loading" style="display:none;">
			<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
			<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(32327 ,user.getLanguage())%></span><!-- 正在同步，请不要离开该页面，请稍等 -->
		</div>
		<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="NCManualSynOperation.jsp">
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32328,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  				<wea:item><%=SystemEnv.getHtmlLabelName(32328 ,user.getLanguage())%><!-- 同步内容 -->
					</wea:item>
					<wea:item>
						<select id=type name=type>
							<option value="0">
								<%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage())%><!--全部 -->
							</option>
							<option value="1">
								<%=SystemEnv.getHtmlLabelName(141 ,user.getLanguage())%><!--分部 -->
							</option>
							<option value="2">
								<%=SystemEnv.getHtmlLabelName(18939 ,user.getLanguage())%><!--部门 -->
							</option>
							<option value="3">
								<%=SystemEnv.getHtmlLabelName(6086 ,user.getLanguage())%><!--岗位 -->
							</option>
							<option value="4">
								<%=SystemEnv.getHtmlLabelName(32329 ,user.getLanguage())%><!--人员及帐号 -->
							</option>
						</select>
						</wea:item>
					</wea:group>
				</wea:layout>
				<div id='returnMSg'>
					<wea:layout>
						<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
						  <wea:item attributes="{'colspan':'2'}">
								<BR>
								<B><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(32332 ,user.getLanguage())%><!--按以下顺序全部同步：分部－>部门－>岗位－>人员及帐号-->
								<BR>
								<B><%=SystemEnv.getHtmlLabelName(141 ,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(32333 ,user.getLanguage())%><!--同步分部 -->
								<BR>
								<B><%=SystemEnv.getHtmlLabelName(18939 ,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(32334 ,user.getLanguage())%><!--同步部门 -->
								<BR>
								<B><%=SystemEnv.getHtmlLabelName(6086 ,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(32335 ,user.getLanguage())%><!-- 同步岗位 -->
								<BR>
								<B><%=SystemEnv.getHtmlLabelName(32329 ,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(32336 ,user.getLanguage())%><!-- 同步HR中的人员和帐号，如果同步的人员中所属部门或岗位没有，则将先同步部门或岗位后再同步该人员 -->
								<BR>
								<BR>
							</wea:item>
						</wea:group>
					</wea:layout>
				</div>
			</FORM>
		</BODY>
<script language="javascript">
	function ajaxinit(){
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
	function onSyn(obj)
	{
		var type = document.frmMain.type.value;
	    document.getElementById("loading").style.display = "";
	    document.getElementById("returnMSg").innerHTML="";
	    obj.disabled=true;
	    var ajax=ajaxinit();
	    ajax.open("POST", "HrmManualSynOperation.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send("type="+document.frmMain.type.value);
	    //获取执行状态
	    ajax.onreadystatechange = function() {
	        //如果执行状态成功，那么就把返回信息写到指定的层里
	        if (ajax.readyState == 4 && ajax.status == 200) {
	            try{
	            	document.getElementById("loading").style.display = "none";
	                document.getElementById("returnMSg").innerHTML = ajax.responseText;
	            }catch(e){}
	            obj.disabled=false;
	        }
	    }
	}
	
	function doExcel(){
	  if(document.getElementById('HrmExcelOut') == null || document.getElementById('HrmExcelOut') == ""){
	    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32337 ,user.getLanguage())%>!");//对不起,无数据导出,请先执行同步操作
	  }else{
		location.href = "/weaver/weaver.file.ExcelOut";
	    return;
	  }
	}

</script>
</HTML>
