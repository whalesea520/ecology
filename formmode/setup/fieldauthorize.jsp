<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<% weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style type="text/css">
#lavaoTable{
	border-collapse: collapse;
	margin: 10px 0;
	width: 100%;
}	
#lavaoTable tr th{
	text-align: left;
	padding: 4px;
	background-color: #eee;
}
#lavaoTable tr td{
	padding: 4px;
	border-bottom: 1px solid #eee;
}
</style>
<script type="text/javascript">
	function fieldauthorizeSubmit(){
		document.fieldauthorize.submit();
	}
	function openbox(obj){
		if(obj.checked){
			jQuery(obj).parent().find("[name=isopen]").val(1);
		}else{
			jQuery(obj).parent().find("[name=isopen]").val(0);
		}
	}
	function changeOpttype(obj,loayoutidobj){
		var opttype = jQuery(obj).val();
		var browserid = jQuery(obj).attr("browserid");
		if(browserid=="")
			return;
		var defaultvalue = jQuery(loayoutidobj).val();
		var trobj = jQuery(obj).parent().parent();
		var tarObj = jQuery(trobj).find("[name=layoutidoption]");
		var opttype = jQuery(obj).val();
		jQuery(tarObj).find("option").remove();
		jQuery.ajax({
			type: 'POST',
			url:"/formmode/setup/fieldauthorizeOperation.jsp?operate=getBrowserLayout&browserid="+browserid+"&opttype="+opttype,
			success: function(data){
				if(jQuery.trim(data)!=''){
					var optionValue = jQuery.parseJSON(jQuery.trim(data));
					for(var i=0;i<optionValue.length;i++){
						if(defaultvalue&&defaultvalue==optionValue[i].layoutid){
							jQuery("<option selected></option>")
							.val(optionValue[i].layoutid)
							.text(optionValue[i].layoutname)
							.appendTo(tarObj);
						}else{
							jQuery("<option></option>")
							.val(optionValue[i].layoutid)
							.text(optionValue[i].layoutname)
							.appendTo(tarObj);
						}
					}
					changeLayoutidoption(tarObj);
				}else{
					
				}
		    }
		})
		//tarObj.selectbox("detach");
        //beautySelect(tarObj);
	}
	function changeLayoutidoption(obj){
		if(obj)
			jQuery(obj).parent().find("[name=layoutid]").val(jQuery(obj).val());
	}
	function checklayoutlevel(obj){
		if(obj.value==''){
			return;
		}
		var reg = new RegExp("^-?[0-9]+$");  
	    if(!reg.test(obj.value)){  
	        alert("<%=SystemEnv.getHtmlLabelName(27691, user.getLanguage()) %>");
	        obj.value="";
	        return;
	    }  
	}
jQuery(document).ready(function(){
	var opttypes = jQuery("[name=opttype]");
	var layoutids = jQuery("[name=layoutid]");
	for(var i=0;i<opttypes.length;i++){
		changeOpttype(opttypes[i],layoutids[i]);
	}
	jQuery(".loading", window.parent.document).hide(); //隐藏加载图片
})

</script>
</head>
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
int formId = Util.getIntValue(request.getParameter("formId"),0);
if(modeId > 0 && formId == 0){
	formId = modelInfoService.getFormInfoIdByModelId(modeId); 
}

String titlename= SystemEnv.getHtmlLabelName(128167, user.getLanguage()) ;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldauthorizeSubmit(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="height:400px;">
<%
ArrayList<String> selected_ids = new ArrayList<String>();
ArrayList<String> selected_modelids = new ArrayList<String>();
ArrayList<String> selected_formids = new ArrayList<String>();
ArrayList<String> selected_fieldids = new ArrayList<String>();
ArrayList<String> selected_opttypes = new ArrayList<String>();
ArrayList<String> selected_layoutids = new ArrayList<String>();
ArrayList<String> selected_layoutlevels = new ArrayList<String>();
ArrayList<String> selected_pks = new ArrayList<String>();
String selectedsql="select * from ModeFieldAuthorize where modeid="+modeId+" and formid="+formId+"";
rs.executeSql(selectedsql);
while(rs.next()){
	selected_ids.add(Util.null2String(rs.getString("id")));
	selected_modelids.add(Util.null2String(rs.getString("modeid")));
	selected_formids.add(Util.null2String(rs.getString("formid")));
	selected_fieldids.add(Util.null2String(rs.getString("fieldid")));
	selected_opttypes.add(Util.null2String(rs.getString("opttype")));
	selected_layoutids.add(Util.null2String(rs.getString("layoutid")));
	selected_layoutlevels.add(Util.null2String(rs.getString("layoutlevel")));
	selected_pks.add(Util.null2String(rs.getString("modeid"))+
			"_"+Util.null2String(rs.getString("formid"))+"_"+Util.null2String(rs.getString("fieldid")));
}
%>
<form name="fieldauthorize" id="fieldauthorize" method="post" action="fieldauthorizeOperation.jsp" >
<input type="hidden" value="Addfieldauthorize" name="operate">
<input type="hidden" value="<%=modeId %>" name="modeId">
<input type="hidden" value="<%=formId %>" name="formId">
<wea:layout type="towCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18020,user.getLanguage()) %>'><!-- 主表字段 -->
		<wea:item attributes="{'isTableList':'true'}">
			<table class=ListStyle id="oTable" cols=5  border=0 cellspacing=0>
				<tr class=header>
					<td NOWRAP width='20%'><%=SystemEnv.getHtmlLabelName(685,user.getLanguage()) %></td><!-- 字段名称 -->
					<td NOWRAP width='10%'><%=SystemEnv.getHtmlLabelName(82473 ,user.getLanguage()) %></td><!-- 是否授权 -->
					<td NOWRAP width='15%' style="display: none"><%=SystemEnv.getHtmlLabelName(440, user.getLanguage()) %></td>
					<td NOWRAP width='30%'><%=SystemEnv.getHtmlLabelName(19407 ,user.getLanguage()) %></td><!-- 布局 -->
					<td NOWRAP width='25%'><%=SystemEnv.getHtmlLabelName(82204 ,user.getLanguage()) %></td><!-- 布局级别 -->
				</tr>
				<%
				//rs.executeSql("select * from workflow_billfield where billid="+formId+" and (detailtable is null or detailtable='') and fieldhtmltype=3 and type in(8,135,9,37,23,7,18,16,152,171,161,162,256,257) order by dsporder");
				//rs.executeSql("select * from workflow_billfield where billid="+formId+" and (detailtable is null or detailtable='') and fieldhtmltype=3 and type in(9,37,7,18,16,152,171,161,162,256,257) order by dsporder");
				rs.executeSql("select * from workflow_billfield where billid="+formId+" and (detailtable is null or detailtable='') and fieldhtmltype=3 and type in(9,37,7,18,161,16,152,171,162,256,257) order by dsporder");
				int i=0;
				while(rs.next()){
					i++;
					int id = Util.getIntValue(rs.getString("id"),0);
					String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
					String type = Util.null2String(rs.getString("type"));
					String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
					int fieldlabel = Util.getIntValue(rs.getString("fieldlabel"),0);
					String pk = modeId+"_"+formId+"_"+id;
					int selectedIndex = selected_pks.indexOf(pk);
					String opttype="";
					String layoutid="";
					String layoutlevel="";
					String tempid="";
					if(selectedIndex>-1){
						tempid = selected_ids.get(selectedIndex);
						opttype = selected_opttypes.get(selectedIndex);
						layoutid = selected_layoutids.get(selectedIndex);
						layoutlevel = selected_layoutlevels.get(selectedIndex);
					}
					boolean showlayout = ",161,162,".indexOf(","+type+",")>-1;
					if(showlayout){
						 try{
							  Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
							  String customid = browser.getCustomid();
							  if(StringHelper.isEmpty(customid))
								  continue;
							  rs2.executeSql("select * from mode_custombrowser where id="+customid);
							  if(rs2.next()){
								  int tmpformid = rs2.getInt("formid");
								  if(VirtualFormHandler.isVirtualForm(tmpformid)){//如果是虚拟表单就做授权
									  continue;
								  }
							  }
							  
						 }catch(org.apache.hivemind.ApplicationRuntimeException e){
							 continue;
						 }catch(Exception e){
						    e.printStackTrace();
						 }
					}
					if(!showlayout){
						fielddbtype = "";
					}
					%>
					<tr <%if(i%2==0){%>CLASS="datadark"<%}else{%>class="datalight" <%}%>>
					<td>
					<input name="fieldauthorize_id" value="<%=tempid%>" type="hidden">
					<input name="fieldid" value="<%=id%>" type="hidden">
					<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage()) %>
					</td>
					<td>
						<input type="hidden" name="isopen" value="<%=selectedIndex>-1?"1":"0"%>">
						<input type="checkbox" name=isopenbox value="1" onclick="openbox(this)" tzCheckbox="true" <%=selectedIndex>-1?"checked":""%> >
					</td>
					<td style="display: none">
						<select name="opttype" onchange="changeOpttype(this);" style="display: <%=!showlayout?"none":"" %>"  browserid="<%=fielddbtype%>">
							<option value="0" <%=opttype.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33564, user.getLanguage()) %></option>
							<option value="2" <%=opttype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(126036, user.getLanguage()) %></option>
						</select>
					</td>
					<td>
						<input name="layoutid" type="hidden" value="<%=layoutid%>">
						<%if(showlayout){ %>
						<select name="layoutidoption" width="200px" onchange="changeLayoutidoption(this);">
							<%
							List<Map<String,String>> tmplist = getBrowserOptions(fielddbtype,0);
							for(int g=0;g<tmplist.size();g++){
								Map<String,String> optionMap = tmplist.get(g);
								String tmplayoutid = optionMap.get("layoutid");
								out.print("<option value='"+tmplayoutid+"' "+(layoutid.equals(tmplayoutid)?"selected":"")+">"+optionMap.get("layoutname")+"</option>");
							}
							%>
						</select>
						<%} %>
					</td>
					<td>
							<input name="layoutlevel" onblur="checklayoutlevel(this);" <%=!showlayout?"type='hidden'":"" %> value="<%=layoutlevel%>">
					</td>
					</tr>
					<%
				}		
				%>
				</tr>
			</table>
		</wea:item>
	</wea:group>
	<%
	rs1.executeSql("select * from Workflow_billdetailtable where billid="+formId+" order by orderid");
	while(rs1.next()){
		int orderid = Util.getIntValue(rs1.getString("orderid"),1);
		String tablename = Util.null2String(rs1.getString("tablename"));
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82047,user.getLanguage())+orderid+SystemEnv.getHtmlLabelName(33331,user.getLanguage()) %>'><!-- 子表{1}字段 -->
		<wea:item attributes="{'isTableList':'true'}">
			<table class=ListStyle id="oTable" cols=5  border=0 cellspacing=0>
				<tr class=header>
					<td NOWRAP width='20%'><%=SystemEnv.getHtmlLabelName(685,user.getLanguage()) %></td><!-- 字段名称 -->
					<td NOWRAP width='10%'><%=SystemEnv.getHtmlLabelName(82473 ,user.getLanguage()) %></td><!-- 是否授权 -->
					<td NOWRAP width='15%' style="display: none"><%=SystemEnv.getHtmlLabelName(440, user.getLanguage()) %></td>
					<td NOWRAP width='30%'><%=SystemEnv.getHtmlLabelName(19407 ,user.getLanguage()) %></td><!-- 布局 -->
					<td NOWRAP width='25%'><%=SystemEnv.getHtmlLabelName(82204 ,user.getLanguage()) %></td><!-- 布局级别 -->
				</tr>
				<%
				//rs.executeSql("select * from workflow_billfield where billid="+formId+" and detailtable='"+tablename+"' and fieldhtmltype=3 and type in(8,135,9,37,23,7,18,16,152,171,161,162,256,257) order by dsporder");
				//rs.executeSql("select * from workflow_billfield where billid="+formId+" and detailtable='"+tablename+"' and fieldhtmltype=3 and type in(9,37,7,18,16,152,171,161,162,256,257) order by dsporder");
				rs.executeSql("select * from workflow_billfield where billid="+formId+" and detailtable='"+tablename+"' and fieldhtmltype=3 and type in(9,37,7,18,16,152,171,161,162,256,257) order by dsporder");
				while(rs.next()){
					int id = Util.getIntValue(rs.getString("id"),0);
					String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
					String type = Util.null2String(rs.getString("type"));
					String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
					int fieldlabel = Util.getIntValue(rs.getString("fieldlabel"),0);
					String pk = modeId+"_"+formId+"_"+id;
					int selectedIndex = selected_pks.indexOf(pk);
					String opttype="";
					String layoutid="";
					String layoutlevel="";
					String tempid="";
					if(selectedIndex>-1){
						tempid = selected_ids.get(selectedIndex);
						opttype = selected_opttypes.get(selectedIndex);
						layoutid = selected_layoutids.get(selectedIndex);
						layoutlevel = selected_layoutlevels.get(selectedIndex);
					}
					boolean showlayout = ",161,162,".indexOf(","+type+",")>-1;
					if(showlayout){
						try{
							  Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
							  String customid = browser.getCustomid();
							  if(StringHelper.isEmpty(customid))
								  continue;
							  rs2.executeSql("select * from mode_custombrowser where id="+customid);
							  if(rs2.next()){
								  int tmpformid = rs2.getInt("formid");
								  if(VirtualFormHandler.isVirtualForm(tmpformid)){//如果是虚拟表单就做授权
									  continue;
								  }
							  }
							  
						 }catch(org.apache.hivemind.ApplicationRuntimeException e){
							 continue;
						 }catch(Exception e){
						    e.printStackTrace();
						 }
					}
					%>
					<tr>
					<td>
					<input name="fieldauthorize_id" value="<%=tempid%>" type="hidden">
					<input name="fieldid" value="<%=id%>" type="hidden">
					<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage()) %>
					</td>
					<td>
						<input type="hidden" name="isopen" value="<%=selectedIndex>-1?"1":"0"%>">
						<input type="checkbox" name=isopenbox value="1" onclick="openbox(this)" tzCheckbox="true" <%=selectedIndex>-1?"checked":""%> >
					</td>
					<td style="display: none"><%--0是显示布局  2是编辑布局 --%>
						<select name="opttype" onchange="changeOpttype(this);" style="display: <%=!showlayout?"none":"" %>"  width="200px" browserid="<%=fielddbtype%>">
							<option value="0" <%=opttype.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33564, user.getLanguage()) %></option>
							<option value="2" <%=opttype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(126036, user.getLanguage()) %></option>
						</select>
					</td>
					<td>
						<input name="layoutid" type="hidden" value="<%=layoutid%>">
						<%if(showlayout){ %>
						<select name="layoutidoption" onchange="changeLayoutidoption(this);">
							<%
							List<Map<String,String>> tmplist = getBrowserOptions(fielddbtype,0);
							for(int g=0;g<tmplist.size();g++){
								Map<String,String> optionMap = tmplist.get(g);
								String tmplayoutid = optionMap.get("layoutid");
								out.print("<option value='"+tmplayoutid+"' "+(layoutid.equals(tmplayoutid)?"selected":"")+">"+optionMap.get("layoutname")+"</option>");
							}
							%>
						</select>
						<%} %>
					</td>
					<td>
							<input name="layoutlevel" <%=!showlayout?"type='hidden'":"" %> value="<%=layoutlevel%>">
					</td>
					</tr>
					<%
				}
				%>
				</tr>
			</table>
		</wea:item>
	</wea:group>
	<%} %>
</wea:layout>
</form>		
</body>
</html>
<%!
public List<Map<String,String>> getBrowserOptions(String browserid,int opttype){
	RecordSet rs = new RecordSet();
	List<Map<String,String>> array = new ArrayList<Map<String,String>>();
	if(browserid.indexOf("browser")==-1)
	  return array;
	
	try{
	 Browser browser=(Browser)StaticObj.getServiceByFullname(browserid, Browser.class);
	 String customid = browser.getCustomid();
	 if(StringHelper.isEmpty(customid))
		  return array;
	  rs.executeSql("select * from mode_custombrowser where id="+customid);
	  if(rs.next()){
		  String tmpmodeid = rs.getString("modeid");
		  if(StringHelper.isEmpty(tmpmodeid))
			  return array;
		  ModelInfoService modelInfoService = new ModelInfoService();
		  int tmpformId = modelInfoService.getFormInfoIdByModelId(Util.getIntValue(tmpmodeid,0)); 
		  String sql="select * from modehtmllayout where type="+opttype+" and modeid="+tmpmodeid+" and formid="+tmpformId;
		  
		  rs.executeSql(sql);
		  while(rs.next()){
			  Map<String,String> map = new HashMap<String,String>();
			  String layoutid = StringHelper.null2String(rs.getString("id"));
			  String layoutname = StringHelper.null2String(rs.getString("layoutname"));
			  map.put("layoutid", layoutid);
			  map.put("layoutname", layoutname);
			  array.add(map);
		  }
	  }
	 }catch(org.apache.hivemind.ApplicationRuntimeException e){
		 e.printStackTrace();
	 }catch(Exception e){
	  e.printStackTrace();
	 }
	return array;
}

%>
