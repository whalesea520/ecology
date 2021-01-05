<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(30180,user.getLanguage());//设置关联字段
	String needfav ="1";
	String needhelp ="";
	
	int id = Util.getIntValue(request.getParameter("id"),0);
	int pageexpandid = Util.getIntValue(request.getParameter("pageexpandid"),0);
	String modeid=Util.null2String(request.getParameter("modeid"));
	String modename = "";
	String modeformid = "0";
	String modeisbill = "1";
	String sql = "";
	if(!modeid.equals("")){
		sql = "select modename,formid from modeinfo where id = " + modeid;
		rs.executeSql(sql);
		while(rs.next()){
			modename = Util.null2String(rs.getString("modename"));
			modeformid = Util.null2String(rs.getString("formid"));
		}
	}
	
	String hreftype=Util.null2String(request.getParameter("hreftype"));
	String hrefid=Util.null2String(request.getParameter("hrefid"));
	String hrefname = InterfaceTransmethod.getHrefName(String.valueOf(hrefid), String.valueOf(hreftype));
	String hrefformid = "";
	String hrefisbill = "1";
	
	if(hreftype.equals("1")){
		sql = "select formid from modeinfo where id = " + hrefid;
		rs.executeSql(sql);
		while(rs.next()){
			hrefformid = Util.null2String(rs.getString("formid"));
			hrefisbill = "1";
		}
	}else if(hreftype.equals("3")){
		sql = "select a.id,a.modeid,b.modename,a.customname,a.customdesc,b.formid from mode_customsearch a,modeinfo b where a .modeid = b.id and a.id = " + hrefid;
		rs.executeSql(sql);
		while(rs.next()){
			hrefformid = Util.null2String(rs.getString("formid"));
			hrefisbill = "1";
		}
	} 
	
	HashMap existsMap = new HashMap();
	if(id>0){
		sql = "select b.* from mode_pagerelatefield a,mode_pagerelatefielddetail b where a.id = b.mainid and a.id = " + id;
	}else{
		sql = "select b.* from mode_pagerelatefield a,mode_pagerelatefielddetail b where a.id = b.mainid and a.modeid = " + modeid + " and a.hreftype = " + hreftype + " and a.hrefid = " + hrefid+" and a.pageexpandid = " + pageexpandid;
	}
	rs.executeSql(sql);
	while(rs.next()){
		id = rs.getInt("mainid");
		String modefieldname = rs.getString("modefieldname");
		String hreffieldname = rs.getString("hreffieldname");
		String key = modefieldname+"|"+hreffieldname;
		String value = "1";
		existsMap.put(key,value);
	}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;//删除
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javaScript:doClose(),_self} " ;//关闭
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_save" class="e8_btn_top" onclick="doSubmit()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form name="frmSearch" method="post" action="/formmode/interfaces/ModePageExpandRelatedFieldSetOperation.jsp">
	<input type="hidden" name="operation" id="operation" value="save">
	<input type="hidden" id="id" name="id" value="<%=id%>">
	<input type="hidden" id="pageexpandid" name="pageexpandid" value="<%=pageexpandid%>">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td class=Field>
				<%=SystemEnv.getHtmlLabelName(30174,user.getLanguage())%><!-- 链接目标来源 -->
			</td>
			<td>
				<span><%=InterfaceTransmethod.getHrefType(hreftype,String.valueOf(user.getLanguage()))%></span>
			</td>
			
			<td class=Field>
				<%=SystemEnv.getHtmlLabelName(30181,user.getLanguage())%><!-- 链接目标 -->
			</td>
			<td>
				<span><%=hrefname%></span>
				<input type="hidden" name="hrefid" id="hrefid" value="<%=hrefid%>">
				<input type="hidden" name="hreftype" id="hreftype" value="<%=hreftype%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		
		<tr>
			<td class="Field">
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
			</td>
			<td colspan="3">
		  		 <!-- button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></button-->
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		<tr style="height:30px"><td colspan=4 class=Field></td></tr>
	</table>
	
	<TABLE class=ViewForm>
		<COLGROUP>
			<COL width="30%">
			<COL width="70%">
		</COLGROUP>
  		<TBODY>
			<TR class=Spacing style="height:1px;">
				<TD class=Line1 colSpan=2></TD>
			</TR>
			<tr>
				<td colspan=2 style="padding-left: 0px;">
					<table class="listStyle" style="width: 100%;">
						<colgroup>
							<col width="30%">
							<col width=70%">
						</colgroup>
						<tr class="header">
						    <td style="border-bottom: 2px solid #b7e0fe;"><%=SystemEnv.getHtmlLabelName(30181,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td><!-- 链接目标字段 -->
                  			<td style="border-bottom: 2px solid #b7e0fe;"><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td><!-- 模块字段 -->
              			</tr>
              			<%
	              			ArrayList modeFieldIdList = new ArrayList();
	              			ArrayList modeLabelNameList = new ArrayList();
	              			
	              			FieldInfo.GetManTableField(Util.getIntValue(modeformid),Util.getIntValue(modeisbill),user.getLanguage());
	              		    ArrayList ManTableFieldIds = FieldInfo.getManTableFieldIds();
	              		    ArrayList ManTableFieldFieldIds = FieldInfo.getManTableFieldFieldIds();
	              		    ArrayList ManTableFieldlabel = FieldInfo.getManTableFieldlabel();
	              		    ArrayList ManTableFieldNames = FieldInfo.getManTableFieldNames();
	              		    ArrayList ManTableFieldFieldNames = FieldInfo.getManTableFieldFieldNames();
							ArrayList ManTableFieldHtmltypes = FieldInfo.getManTableFieldHtmltypes();
              			
              				//被触发流程字段信息
              				int detailno = 0;
              				String dataclass = "datalight";
              				if(!hrefformid.isEmpty()) {
              				sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where viewtype = 0 and billid = " + hrefformid + " and fieldhtmltype in(3,5,8) order by viewtype asc,detailtable asc";
	              			rs.executeSql(sql);
	              			while(rs.next()){
	              				String fieldid = Util.null2String(rs.getString("id"));
	              				String fieldname = Util.null2String(rs.getString("fieldname"));
	              				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
	              				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
	              				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
	              				String type = Util.null2String(rs.getString("type"));
	              				String viewtype = Util.null2String(rs.getString("viewtype"));
	              				String detailtable = Util.null2String(rs.getString("detailtable"));
	              				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
	              				String selectedstr = "";
	              				String key = "-1"+"|"+fieldname;
	              				boolean selected = existsMap.containsKey(key);
	              				if(selected){
										selectedstr = "selected";
								}else{
										selectedstr = "";
								}
	              		%>
	              				<tr class="<%=dataclass%>">
	              					<td class=Field>
	              						<%=labelname%>
	              						<input type="hidden" id="hreffieldname" name="hreffieldname" value="<%=fieldname%>">
              						</td>
	              					<td class=Field>
	              						<select name="modefieldname" id="modefieldname">
	              							<option value="">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<option value="-1" <%=selectedstr%>><%=SystemEnv.getHtmlLabelName(81287,user.getLanguage())%></option><!-- 数据Id -->
	              							<%
              									for(int i=0;i<ManTableFieldIds.size();i++){
              										String tempfieldid = (String)ManTableFieldIds.get(i);
              										String tempfieldname = (String)ManTableFieldFieldNames.get(i);
              										String tempfieldlabelname = (String)ManTableFieldNames.get(i);
              										String tempfieldhtmltype = (String)ManTableFieldHtmltypes.get(i);
              										if(!(tempfieldhtmltype.equals("3")||tempfieldhtmltype.equals("5")||tempfieldhtmltype.equals("8"))){
              											continue;
              										}
	              									key = tempfieldname+"|"+fieldname;
	              									selected = existsMap.containsKey(key);
	              									if(selected){
	              										selectedstr = "selected";
	              									}else{
	              										selectedstr = "";
	              									}
           									%>
         												<option value="<%=tempfieldname%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
           									<%
              									}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
	              				<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	              		<%
	              				if(dataclass.equals("datalight")){
	              					dataclass = "datadark";
	              				}else{
	              					dataclass = "datalight";
	              				}
	              			}
	              			}
              			%>
                	</table>
            	</td>
			</tr>
		</TBODY>
	</TABLE>
	
</form>

<%



%>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doDel(){
        if(isdel()){
			enableAllmenu();
			$("#operation").val("del");
			document.frmSearch.submit();
        }
    }
    function doClose(){
    	parent.doClose();
	}
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
</script>

</BODY>
</HTML>
