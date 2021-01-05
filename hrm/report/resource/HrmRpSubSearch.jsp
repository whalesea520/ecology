
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<!-- modified by wcd 2014-07-30 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%@ page import="weaver.hrm.report.domain.*,weaver.hrm.report.manager.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmRpSubTemplateManager" class="weaver.hrm.report.manager.HrmRpSubTemplateManager" scope="page"/>
<jsp:useBean id="HrmRpSubTemplateConManager" class="weaver.hrm.report.manager.HrmRpSubTemplateConManager" scope="page"/>
<%!
	private HrmRpSubTemplateCon getBean(String name, List conList){
		HrmRpSubTemplateCon bean = null;
		for(int _index = 0; _index < conList.size(); _index++){
			HrmRpSubTemplateCon conBean = (HrmRpSubTemplateCon)conList.get(_index);
			if(conBean.getColName().equals(name)){
				bean = conBean;
				break;
			}
		}
		return bean;
	}
%>
<%
    String userid =""+user.getUID();
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
        String tempid = RecordSet.getString("resourceid");
        allCanView.add(tempid);
        AllManagers.getAll(tempid);
        while(AllManagers.next()){
            allCanView.add(AllManagers.getManagerID());
        }
    }// end while

    for (int i=0;i<allCanView.size();i++){
        if(userid.equals((String)allCanView.get(i))){
            canView = true;
        }
    }
    if(!canView) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    /*权限判断结束*/
	int cmd = Util.getIntValue(request.getParameter("cmd"),0);
    int scopeId = Util.getIntValue(request.getParameter("scopeid"),0);
	int templateid = Util.getIntValue(request.getParameter("templateid"),0);
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(17602,user.getLanguage())+"—"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	List conList = new ArrayList();
	boolean showTemplate = false;
	Map map = new HashMap();
	if(templateid != 0){
		StringBuffer _sql = new StringBuffer("select id,scopeid,resourceid,colname,showorder,header,templateid from HrmRpSubDefine ")
		.append(" where templateid =").append(templateid)
		.append(" and resourceid=").append(userid)
		.append(" and scopeid='").append(scopeId).append("_").append(cmd).append("'")
		.append(" order by showorder");
		RecordSet.executeSql(_sql.toString());
		while(RecordSet.next()){
			map.put(Util.null2String(RecordSet.getString("colname")),Util.null2String(RecordSet.getString("showorder")));
		}
		showTemplate = true;
		
		Map conmap = new HashMap();
		conmap.put("templateId",templateid);
		conList = HrmRpSubTemplateConManager.find(conmap);
	}

    ArrayList ids = new ArrayList();
    ArrayList colnames = new ArrayList();
    ArrayList opts = new ArrayList();
    ArrayList values = new ArrayList();
    ArrayList names = new ArrayList();
    ArrayList opt1s = new ArrayList();
    ArrayList value1s = new ArrayList();
    ids.clear();
    colnames.clear();
    opt1s.clear();
    names.clear();
    value1s.clear();
    opts.clear();
    values.clear();
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language="javascript">
			var sn_index = 1;
			var dialog = null;
			var dWidth = 400;
			var dHeight = 150;
			var _name = "";
			var _method = "";
		
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function procSave(){
				if(dialog)
					dialog.close();
				if (_name != null) {
					$GetEle("templateName").value = _name;
					$GetEle("method").value = _method;
					$GetEle("SearchForm").action = "/hrm/report/resource/SaveTemplateOperation.jsp";
					$GetEle("SearchForm").submit();
				}
			}
			
			function  onShowBrowser1(id,url,type1){
				var spanname="";
				var inputname="";
				if(type1==1){
				   spanname = "con"+id+"_valuespan";
				   inputname = "con"+id+"_value";
				}else if(type1==2){
				   spanname = "con"+id+"_value1span";
				   inputname = "con"+id+"_value1";
				}
				onHrCrpShowDate(spanname,inputname);
			}

			 function onHrCrpShowDate(spanname,inputname){
				  WdatePicker({el:spanname,onpicked:function(dp){
						$dp.$(inputname).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$(inputname).value = ''}});
			 }
			 
			 function onShowBrowser(id,url){
					var results = window.showModalDialog(url+"?selectedids="+$GetEle("con"+id+"_value").value);
					if(results){
					   if(results.id!=""){
						  jQuery("#con"+id+"_valuespan").html(results.name);
						  $GetEle("con"+id+"_value").value=results.id;
						  $GetEle("con"+id+"_name").value=results.name;
					   }else{
						  jQuery("#con"+id+"_valuespan").html("");
						  $GetEle("con"+id+"_value").value="";
						  $GetEle("con"+id+"_name").value="";
					   }
					}
			}
			function getNumberValue(obj){
				var num = new Number(sn_index);
				sn_index = sn_index + 1;
				return num.toFixed(2);
			}
			function changelevel(tmpindex){
				changeCheckboxStatus(jQuery("#check_show_"+tmpindex),true);
				changeCheckboxStatus(jQuery("#check_con_"+tmpindex),true);
				$GetEle("show"+tmpindex+"_sn_span").style.display = "";
				var showSn = $GetEle("show"+tmpindex+"_sn");
				if(showSn && showSn.value=="0.00"){
					showSn.value = getNumberValue(showSn);
				}
			}
			function selectCheckBox(thisobj,id,suffix){
				var showSpan =  $GetEle("show"+id+"_sn_span");
				if(showSpan){
					showSpan.style.display = thisobj.checked?"":"none";
				}
				var obj = $GetEle("show_sn"+suffix+id);
				if(obj){
					obj.value = (thisobj.checked && obj.value=="0.00")?getNumberValue(obj):"0.00";
				}
			}
			function selectAll(thisobj,checkbox,suffix){
				changeCheckboxStatus(document.getElementsByName(checkbox),thisobj.checked);
				if(checkbox.indexOf("check_show")!=-1){				
					changeSpan("show_sn_span"+suffix,thisobj.checked?"":"none");
					changeTextValue("show_sn",suffix,thisobj.checked?"1":"0");
				}
			}
			function changeTextValue(name,suffix,flag){
				var len = $GetEle("SearchForm").elements.length;
				for(var i=0;i<len;i++) {
					var obj = $GetEle("SearchForm").elements[i];
					if(obj.id.indexOf(name+suffix)!=-1){
						var newId = obj.id.substr((name+suffix).length);
						if(suffix == "" && newId.indexOf("_")!=-1){
							continue;
						}
						if(flag == "1" && obj.value=="0.00"){
							obj.value = getNumberValue(obj);
						}else if(flag == "0"){
							obj.value = "0.00";
						}
					}
				}
			}
			function doSearch(){
				$GetEle("SearchForm").submit();
			}
			function changeSpan(spanName,_display){
				var showSpans = document.getElementsByName(spanName);
				if(showSpans){
					for(var i=0;i<showSpans.length;i++){
						showSpans[i].style.display = _display;
					}
				}
			}
			function doReset(){
				changeSpan("show_sn_span","none");
				changeSpan("show_sn_span_family","none");
				changeSpan("show_sn_span_language","none");
				changeSpan("show_sn_span_education","none");
				changeSpan("show_sn_span_work","none");
				changeSpan("show_sn_span_train","none");
				changeSpan("show_sn_span_certificate","none");
				changeSpan("show_sn_span_rewards_punishment","none");
				var conValuespans = document.getElementsByName("con_valuespan");
				if(conValuespans){
					for(var i=0;i<conValuespans.length;i++){
						conValuespans[i].innerHTML = "";
					}
				}
				changeCheckboxStatus(document.getElementsByName("check_show_all"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_all"),false);
				changeCheckboxStatus(document.getElementsByName("check_show"),false);
				changeCheckboxStatus(document.getElementsByName("check_con"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_family"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_family"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_language"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_language"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_education"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_education"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_work"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_work"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_train"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_train"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_certificate"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_certificate"),false);
				changeCheckboxStatus(document.getElementsByName("check_show_rewards_punishment"),false);
				changeCheckboxStatus(document.getElementsByName("check_con_rewards_punishment"),false);
				jQuery("#SearchForm").find(".Browser").siblings("span").html("");
				jQuery("#SearchForm").find(".Browser").siblings("input[type='hidden']").val("");
				jQuery("#SearchForm").find(".e8_os").find("input[type='hidden']").val("");
				jQuery("#SearchForm").find(".e8_outScroll .e8_innerShow span").html("");
				var _obj = jQuery("#SearchForm").find("select");
				for(var i=0;i<_obj.length;i++){
					changeSelectValue(_obj[i].name,"0");
				}
				$GetEle("SearchForm").reset();
				sn_index = 1;
				
			}
			function doSave(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmConstRpSubSearch&isdialog=1","<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>");
			}
			function doDel(){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					$GetEle("cmd").value = "del";
					$GetEle("SearchForm").action = "/hrm/report/resource/SaveTemplateOperation.jsp";
					$GetEle("SearchForm").submit();
				});
			}
			function reSave(){
				$GetEle("SearchForm").action = "/hrm/report/resource/SaveTemplateOperation.jsp";
				$GetEle("SearchForm").submit();
			}
			function ctrlc(){
				$GetEle("cmd").value = "ctrlc";
				doSave();
			}
			function showTemplate(id){
				parent.location = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method=HrmRpSubSearch&scopeid=<%=scopeId%>&scopeCmd=<%=cmd%>&templateid='+id;
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			if(showTemplate){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:reSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:ctrlc(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}else{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:doReset(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="doSearch();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<%if(showTemplate){%>
					<input type=button class="e8_btn_top" onclick="reSave();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="ctrlc();" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"></input>
					<%}else{%>
					<input type=button class="e8_btn_top" onclick="doReset();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="doSave();" value="<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>"></input>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM name="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="HrmRpSubSearchResult.jsp" method="post">
			<input type="hidden" value="<%=scopeId%>" name="scopeId">
			<input type="hidden" value="<%=templateid%>" name="templateid">
			<input type="hidden" value="" name="templateName">
			<input type="hidden" value="" name="cmd">
			<input type="hidden" value="" name="method">
			<wea:layout attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item type="groupHead">
						<span> 
							<select id="templates" name="templates" onchange="showTemplate(this.value);">
								<option value="0"><%=SystemEnv.getHtmlLabelNames("149,64",user.getLanguage())%></option>
								<%
									Map _map = new HashMap();
									_map.put("scope",scopeId+"_"+cmd);
									_map.put("author",userid);
									List tlist = HrmRpSubTemplateManager.find(_map);
									for(int i=0;i<(tlist==null?0:tlist.size());i++){
										HrmRpSubTemplate template = (HrmRpSubTemplate)tlist.get(i);
									%>
								<option value="<%=template.getId()%>" <%=templateid == template.getId() ? "selected" : ""%>><%=template.getName()%></option>
									<%
									}
								%>
							</select>
						</span>
					</wea:item>
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<table class=ListStyle>
							<COLGROUP>
								<COL width="8%">
								<COL width="7%">
								<COL width="8%">
								<COL width="17%">
								<COL width="15%">
								<COL width="15%">
								<COL width="15%">
								<COL width="15%">
							</COLGROUP>
							<tr class=header>
								<td>
									<input type='checkbox' name='check_show_all' id="check_show_all" onclick="selectAll(this,'check_show','');">
									<%=SystemEnv.getHtmlLabelName(33541,user.getLanguage())%>
								</td>
								<td>&nbsp;</td>
								<td>
									<input type='checkbox' name='check_con_all' id="check_con_all" onclick="selectAll(this,'check_con','');">
									<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>
								</td>
								<td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
								<td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
							</tr>
							<tr class="DataLight">
								<td>
									<input type='checkbox' name='_check_show_all' id="_check_show_all" checked disabled>
								</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
								<td colspan=4>&nbsp;</td>
							</tr>
							<%
								CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
								cfm.getCustomFields();
								int tmpcount = 0;
								while(cfm.next()){
									tmpcount += 1;
									String id = String.valueOf(cfm.getId());
									String name = "field"+id;
									String label = cfm.getLable();
									String htmltype = cfm.getHtmlType();
									String type = String.valueOf(cfm.getType());
									String snValue = "";
									if(showTemplate){
										if(!map.containsKey(name)){
											continue;
										}
										snValue = Tools.vString(map.get(name));
									}
									HrmRpSubTemplateCon conBean = getBean(name,conList);
									boolean showCon = conBean != null;
									String tmpcolname = "",tmpopt = "",tmpvalue = "",tmpopt1 = "",tmpvalue1 = "";
									if(showCon){										
										htmltype = conBean.getConHtmltype();
										type = conBean.getConType();
										tmpcolname = conBean.getColName();
										tmpopt = conBean.getConOpt();
										tmpvalue = conBean.getConValue();
										tmpopt1 = conBean.getConOpt1();
										tmpvalue1 = conBean.getConValue1();
									}
							%>
							<tr class="DataLight">
								<td>
									<input type='checkbox' name='check_show' id="check_show_<%=id%>"  onclick="selectCheckBox(this,'<%=id%>','');"  value="<%=id%>" <%if(showTemplate || ids.indexOf(""+id)!=-1){%> checked <%}%>>
								</td>
								<td>
									<span name="show_sn_span" id="show<%=id%>_sn_span" style="<%=showTemplate?"":"display:none"%>">
										<input type="text" class="inputstyle" id="show_sn<%=id%>" name="show<%=id%>_sn" size=3 maxlength=3 value="<%=showTemplate?snValue:"0.00"%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber2(this)'>
										<input type=hidden name="con<%=id%>_fieldlabel" value="<%=SystemEnv.getHtmlLabelNames(label,user.getLanguage())%>">
									</span>
								</td>
								<td>
									<input type='checkbox' name='check_con' id="check_con_<%=id%>"   value="<%=id%>" <%if(showCon || ids.indexOf(""+id)!=-1){%> checked <%}%>>
								</td>
								<td>
								  <input type=hidden name="con<%=id%>_id" value="<%=id%>">
								  <input type=hidden name="con<%=id%>_ismain" value="1">
								  <%=SystemEnv.getHtmlLabelNames(label,user.getLanguage())%>
								  <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
								</td>
								<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
								<input type=hidden name="con<%=id%>_type" value="<%=type%>">
							<%
									if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
							%>
								<td>
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<%if(!((id.equals("3")&&scopeId==-11)||(id.equals("6")&&scopeId==-12))){%>
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
										<%}%>
										<option value="3" <%if(tmpopt.equals("3")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("3")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										<option value="4" <%if(tmpopt.equals("4")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("4")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>

									</select>
								</td>
								<td colspan=3>
									<input type=text class="inputstyle"  name="con<%=id%>_value"  onfocus="changelevel('<%=id%>')"  <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
								</td>
							<%
									}else if(htmltype.equals("1")&& !type.equals("1")){
							%>
								<td>
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
										<option value="3" <%if(tmpopt.equals("3")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("3")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
										<option value="4" <%if(tmpopt.equals("4")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("4")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
										<option value="5" <%if(tmpopt.equals("5")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("5")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="6" <%if(tmpopt.equals("6")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("6")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
									</select>
								</td>
								<td >
									<input type=text class="inputstyle"  name="con<%=id%>_value"  onfocus="changelevel('<%=id%>')" <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
								</td>
								<td>
									<select name="con<%=id%>_opt1" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt1.equals("1")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt1.equals("2")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
										<option value="3" <%if(tmpopt1.equals("3")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("3")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
										<option value="4" <%if(tmpopt1.equals("4")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("4")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
										<option value="5" <%if(tmpopt1.equals("5")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("5")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="6" <%if(tmpopt1.equals("6")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("6")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
									</select>
								</td>
								<td>
								  <input type=text class="inputstyle"  name="con<%=id%>_value1"  onfocus="changelevel('<%=id%>')"  <%if(ids.indexOf(""+id)!=-1||tmpvalue1.length()>0){%> value=<%=tmpvalue1.length()>0?tmpvalue1:(value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
								</td>
								<td>&nbsp;</td>
							<%
									}else if(htmltype.equals("4")){
							%>
								<td colspan=4>
									<input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=id%>')" <%if(tmpvalue.length()>0||((ids.indexOf(""+id)!=-1)&&(values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1"))){%> checked <%}%>>
								</td>
							<%
									}else if(htmltype.equals("5")){
							%>
								<td>
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
									</select>
								</td>
								<td colspan=3>
									<select name="con<%=id%>_value" class="inputstyle"  onchange="changelevel('<%=id%>')">
							<%
										cfm.getSelectItem(cfm.getId());
										while(cfm.nextSelect()){

											String tmpselectvalue = cfm.getSelectValue();
											String tmpselectname = cfm.getSelectName();
							%>
										<option value="<%=tmpselectvalue%>"  <%if(tmpvalue.equals(tmpselectvalue)||((ids.indexOf(""+id)!=-1)&&(values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue))){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
							<%
										}
							%>
									</select>
								</td>
							<%
									}else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37")){
							%>
								<td>
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
									</select>
								</td>
								<td colspan=3>
							<%
										String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
										if(type.equals("4")) {
											browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
										}
							%>
									<button type="button" class=Browser  onfocus="changelevel('<%=id%>')" onclick="changelevel('<%=id%>');onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
									<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
									<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){%> value=<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
									<span name="con_valuespan" id="con<%=id%>_valuespan">
							<%
										if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){
							%>
									<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
							<%
										}
							%>
									</span>
								</td>
							<%
									} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
							%>
								<td >
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
										<option value="3" <%if(tmpopt.equals("3")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("3")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
										<option value="4" <%if(tmpopt.equals("4")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("4")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
										<option value="5" <%if(tmpopt.equals("5")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("5")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="6" <%if(tmpopt.equals("6")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("6")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
									</select>
								</td>
								<td>
									<button type="button" class=Browser  onfocus="changelevel('<%=id%>')" onclick="changelevel('<%=id%>');onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','1')"></button>
									<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
									<span name="con_valuespan" id="con<%=id%>_valuespan" style="color: #000000 !important;font-weight: normal;">
							<%
										if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){
							%>
										<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
							<%
										}
							%>
									</span>
								</td>
								<td >
									<select name="con<%=id%>_opt1" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt1.equals("1")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt1.equals("2")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
										<option value="3" <%if(tmpopt1.equals("3")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("3")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
										<option value="4" <%if(tmpopt1.equals("4")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("4")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
										<option value="5" <%if(tmpopt1.equals("5")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("5")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
										<option value="6" <%if(tmpopt1.equals("6")||((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("6")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
									</select>
								</td>
								<td >
									<button type="button" class=Browser  onfocus="changelevel('<%=id%>')" onclick="changelevel('<%=id%>');onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','2')"></button>
									<input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1||tmpvalue1.length()>0){%> value=<%=tmpvalue1.length()>0?tmpvalue1:(value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
									<span name="con<%=id%>_value1span" id="con<%=id%>_value1span" style="color: #000000 !important;font-weight: normal;">
							<%
										if(ids.indexOf(""+id)!=-1||tmpvalue1.length()>0){
							%>
										<%=tmpvalue1.length()>0?tmpvalue1:(value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
							<%
										}
							%>
									</span>
								</td>
							<%
									}else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
							%>
								<td >
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									</select>
								</td>
								<td colspan=3>
									<button type="button" class=Browser  onfocus="changelevel('<%=id%>')" onclick="changelevel('<%=id%>');onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
									<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
									<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){%> value=<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
									<span name="con_valuespan" id="con<%=id%>_valuespan">
							<%
										if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){
							%>
										<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
							<%
										}
							%>
									</span>
								</td>
							<%
									} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
							%>
								<td >
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									</select>
								</td>
								<td colspan=3>
									<button type="button" class=Browser  onfocus="changelevel('<%=id%>')" onclick="changelevel('<%=id%>');onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
									<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
									<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){%> value=<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
									<span name="con_valuespan" id="con<%=id%>_valuespan">
							<%
										if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){
							%>
										<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
							<%
										}
							%>
									</span>
								</td>
							<%
									} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含）
							%>
								<td >
									<select name="con<%=id%>_opt" class="inputstyle" onchange="changelevel('<%=id%>')" >
										<option value="1" <%if(tmpopt.equals("1")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("1")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
										<option value="2" <%if(tmpopt.equals("2")||((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id))).equals("2")))){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
									</select>
								</td>
								<td colspan=3>
									<button type="button" class=Browser  onfocus="changelevel('<%=id%>')" onclick="changelevel('<%=id%>');onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
									<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1||tmpvalue.length()>0){%> value=<%=tmpvalue.length()>0?tmpvalue:(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
									<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){%> value=<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
									<span name="con_valuespan" id="con<%=id%>_valuespan">
							<%
										if(ids.indexOf(""+id)!=-1||tmpcolname.length()>0){
							%>
										<%=tmpcolname.length()>0?tmpcolname:(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
							<%
										}
							%>
									</span>
								</td>
							<%
									}
							%>
								</tr>
							<%
								}
							 if(tmpcount >0 || showTemplate){
	  String id = "status";
	  String name = id;
		String htmltype = cfm.getHtmlType();
		String type = String.valueOf(cfm.getType());
		String snValue = "";
		if(showTemplate){
			if(!map.containsKey(name)){
				continue;
			}
			snValue = Tools.vString(map.get(name));
		}
		HrmRpSubTemplateCon conBean = getBean(name,conList);
		boolean showCon = conBean != null;
		String tmpcolname = "",tmpopt = "",tmpvalue = "",tmpopt1 = "",tmpvalue1 = "";
		if(showCon){										
			htmltype = conBean.getConHtmltype();
			type = conBean.getConType();
			tmpcolname = conBean.getColName();
			tmpopt = conBean.getConOpt();
			tmpvalue = conBean.getConValue();
			tmpopt1 = conBean.getConOpt1();
			tmpvalue1 = conBean.getConValue1();
		}
%>
<tr class="DataLight">
								<td>
									<input type='checkbox' name='check_show' id="check_show_<%=id%>"  onclick="selectCheckBox(this,'<%=id%>','');"  value="<%=id%>" <%if(showTemplate || ids.indexOf(""+id)!=-1){%> checked <%}%>>
								</td>
								<td>
									<span name="show_sn_span" id="show<%=id%>_sn_span" style="<%=showTemplate?"":"display:none"%>">
										<input type="text" class="inputstyle" id="show_sn<%=id%>" name="show<%=id%>_sn" size=3 maxlength=3 value="<%=showTemplate?snValue:"0.00"%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber2(this)'>
										<input type=hidden name="con<%=id%>_fieldlabel" value="<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>">
									</span>
								</td>
								<td>
									<input type='checkbox' name='check_con' id="check_con_<%=id%>"   value="<%=id%>" <%if(showCon || ids.indexOf(""+id)!=-1){%> checked <%}%>>
								</td>
								<td>
								  <input type=hidden name="con<%=id%>_id" value="<%=id%>">
								  <input type=hidden name="con<%=id%>_ismain" value="1">
<%
        String label = cfm.getLable();
%>
      <%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>
      <input type=hidden name="constatus_colname" value="<%=name %>">
    </td>
<%
%>
    <input type=hidden name="constatus_htmltype" value="<%=100%>">
    <input type=hidden name="constatus_type" value="<%=100%>">
     <td colspan=4>
            <SELECT class=inputstyle id=status name="con<%=id%>_value" value="" onchange="changelevel('<%=id%>')">
<%
	String status = "";  
    if(status.equals("")){
      status = "8";
    }
%>
                   <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                   <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
                   <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
                   <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                   <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
                   <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
                   <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
                   <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
                   <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
                   <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
                 </SELECT>
    </td>
     </tr>
	<tr><td colspan=6 class=line></td></tr>
    
    <% }%>
							
						</table>
					</wea:item>
				</wea:group>
			</wea:layout>
		</FORM>
	</BODY>
</HTML>
