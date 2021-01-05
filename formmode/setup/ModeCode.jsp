
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.setup.CodeBuild"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19381,user.getLanguage());//编码规则
String needfav ="";
String needhelp ="";

%>
<head>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/cpt/css/common_wev8.css" type=text/css rel=STYLESHEET>
<style>
.Line {
	background-color: #B5D8EA;
    background-repeat: repeat-x;
    height: 1px;
}
.spancls {
	width:30% !important;
	display:inline-block;
	padding-top: 3px;
}
.selectcls {
	width:30% !important;
	display:inline-block;
}
.Serial {
    padding-left:60px;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
int formId=Util.getIntValue(request.getParameter("formId"),0);
if(modeId > 0 && formId == 0){
		formId = modelInfoService.getFormInfoIdByModelId(modeId); 
}
int codeId = 0;
if(modeId > 0 && formId == 0){
	rs.executeSql("select formid from modeinfo where id="+modeId);
	if(rs.next()) {
		formId = rs.getInt(1);
	}
}
CodeBuild cbuild = new CodeBuild(modeId); 
cbuild.setLanguage(user.getLanguage());
codeId = cbuild.getCodeId();

//初始值
ArrayList coderMemberList = cbuild.getBuild();
int isUse = cbuild.getIsUse();		//是否启用
int codeFieldId = cbuild.getCodeFieldId();//编号字段
int startcodenum = cbuild.getStartCode();


String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

%>

<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >
<INPUT TYPE="hidden" NAME="method">
<INPUT TYPE="hidden" NAME="postValue">
<INPUT TYPE="hidden" NAME="codemainid" value="<%=codeId%>">
<INPUT TYPE="hidden" NAME="modeId" value="<%=modeId%>">

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%>' attributes="{'groupDisplay':''}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item><!-- 是否启用 -->
		<wea:item>
			<input class="inputStyle" type="checkbox" name="txtUserUse" tzCheckbox="true" value="1" <%if (isUse==1) out.println("checked");%>>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none;'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(19503,user.getLanguage())%></wea:item><!-- 编号字段 -->
		<wea:item>
		    <wea:required id="codeFieldId_span" required="true">
				<select name="codeFieldId" style="width: 120px;" onchange="checkinput('codeFieldId','codeFieldId_span')">
					<option value=""></option>
			    <%
				  String sql="select id,fieldlabel from workflow_billfield where viewtype=0 and type='1' and fieldhtmltype='1' and billid="+formId;
				  rs.executeSql(sql);
				  while(rs.next()){
					  int fieldId = rs.getInt(1);
					  int fieldlabel = rs.getInt(2);
				%>
					<option  value=<%=fieldId %> <%if(codeFieldId == fieldId){%>selected<%}%>>
					 <%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
					</option>
				<%
				  }
				%></select>
			</wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'startcodenum_td'}"><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></wea:item><!-- 起始编号 -->
		<wea:item attributes="{'samePair':'startcodenum_td'}">
			<input class="InputStyle" style="width:50px!important" type="text" name="startcodenum" value="<%=startcodenum %>" onKeyPress="ItemCount_KeyPress()"  onKeyUp='NotWriteZero(this)' onBlur='checknumber("startcodenum")' >
		</wea:item>
	</wea:group>
	<!-- 编码规则 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19381,user.getLanguage())%>' attributes="{'samePair':'codedetail_g','itemAreaDisplay':'true'}">
		<wea:item type="groupHead">
			<div style="margin-top:5px;width:219px;">
				<button type="button" class="addbtn2" onclick="onAddField()" title="<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>"></button><!-- 添加字段 -->
			</div>
		</wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<table class=ViewForm id="membersTable">
		  <colgroup>
    	  	<col width="20%">
    	  	<col width="80%">
    	  </colgroup>
    	  <TBODY>
		  <%
		  Map datamap = null;
		  for (int i=0;i<coderMemberList.size();i++){
			  datamap = (Map)coderMemberList.get(i);
			  String detailid = (String)datamap.get("id");
			  String codeMemberName = (String)datamap.get("showname");
		      String codeMemberValue = (String)datamap.get("showvalue");
		      String codeMemberType = (String)datamap.get("showtype");
		      String tablename = (String)datamap.get("tablename");
		      String fieldname = (String)datamap.get("fieldname");
		      String fieldnamestr = (String)datamap.get("fieldnamestr");
		      String shownamestr = (String)datamap.get("shownamestr");
		      String isSerial = (String)datamap.get("isSerial");
		      String serialChkStr = "";
		      if ("1".equals(isSerial)) serialChkStr = " checked ";
		      String titlenamestr = "";
		      String titlenamestr_ = "";
		      titlenamestr = shownamestr;
		      
		      if ("".equals(titlenamestr)) { //没有显示名的
		    	  titlenamestr = SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage());
		    	  
		      }else{
		    	  String lablename = "select  h.labelname,a.fieldhtmltype,a.type "
		    			  			+"from workflow_billfield a left join HtmlLabelInfo h  on h.indexid=a.fieldlabel "
		    			  			+"where billid=? and a.fieldname=? and h.languageid=7";
		    	  rs.executeQuery(lablename,formId,codeMemberValue);
		    	  if(rs.next()) {
		    		  //浏览框（a）字段  -->xx(a-浏览框)
		    		  //titlenamestr = titlenamestr.replace("浏览框", rs.getString("labelname"));
		    		  String htmltype = rs.getString("fieldhtmltype");
		    		  String t = rs.getString("type");
		    		  String lbn = rs.getString("labelname");
		    		  titlenamestr = titlenamestr.substring(titlenamestr.indexOf("("),titlenamestr.indexOf(")"));
		    		  if(htmltype.equals("3")){
		    		  	titlenamestr = lbn +titlenamestr+"-浏览框)";
		    		  }else if(htmltype.equals("4")){
		    			titlenamestr = lbn +titlenamestr+"-Check框)";
		    		  }else if(htmltype.equals("5")){
		    			titlenamestr = lbn +titlenamestr+"-选择框)";
		    	 	  }else if(htmltype.equals("2")){
		    	 		titlenamestr = lbn +titlenamestr+"-多行文本)";
		    	 	  }else{
		    	 		titlenamestr = lbn +titlenamestr+"-单行文本)";
		    	 	  }
		    	  }
		      }
		      if (titlenamestr.length() > 10) {
		    	  titlenamestr_ = titlenamestr.substring(0, 10) + "...";
		      } else {
		    	  titlenamestr_ = titlenamestr;
		      }
		  %>
		  <TR detailid="<%=detailid %>" datatype="<%=codeMemberType %>" customer1="member" onmouseover="$(this).find('img[moveimg]').attr('src','/proj/img/move-hot_wev8.png');" onmouseout="$(this).find('img[moveimg]').attr('src','/proj/img/move_wev8.png');">
		    <TD class="fieldName">
		       <img moveimg src="/proj/img/move_wev8.png" title="<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>" /><!-- 拖动 -->
		       <span title="<%=titlenamestr %>"><%=titlenamestr_ %></span>
		    </TD>
		    <TD class="field">
		      <%
		      StringBuffer sb1 = new StringBuffer("");
		      String sql="select id,fieldlabel,type,fielddbtype,fieldhtmltype,fieldname from workflow_billfield where viewtype=0 and fieldhtmltype not in (2,4,6,7) and billid="+formId+" and fieldname='"+codeMemberValue+"'";
			  rs.executeSql(sql);
			  if(rs.next()){
				  int fieldId = rs.getInt(1);
				  int fieldlabel = rs.getInt(2);
				  String type = rs.getString(3);
				  String fielddbtype = rs.getString(4);
				  String fieldhtmltype = rs.getString(5);
				  String fieldname_ = rs.getString(6);
				  int language = user.getLanguage();
				  String checkstr = "";
				  
				  if ("3".equals(fieldhtmltype)) { //browser框
						if ("161".equals(type)) { //自定义单选
							sql = "select b.formid from datashowset a,mode_custombrowser b where showname='"+fielddbtype.replace("browser.","")+"' and a.customid=b.id";
							rs.executeSql(sql);
							if (rs.next()) {
								String formid = rs.getString("formid");
								rs.executeSql("select m.tablename,b.fieldname,h.labelname from workflow_bill m,workflow_billfield b,HtmlLabelInfo h where m.id=b.billid and h.languageid=7 and b.fieldlabel=h.indexid and viewtype=0 and fieldhtmltype='1' and billid="+formid);
								while (rs.next()) {
									String fieldname2 = rs.getString("fieldname");
									String labelname2 = rs.getString("labelname");
									checkstr = "";
									if (fieldname.equals(fieldname2)) {//如果字段和保存的字段一样，则选中
										 checkstr = " selected ";
									 } 
									sb1.append("<option ").append("value='").append(fieldname2).append("'").append(checkstr).append(" label='").append(labelname2).append("'").append(">").append(labelname2).append("</option>").append("\n");
								}
							}
						} else if ("2".equals(type)) { //日期
							if ("Y".equals(fieldname)) checkstr = " selected ";
				            sb1.append("<option value='Y'").append(checkstr).append(" label='").append(SystemEnv.getHtmlLabelName(445,language)).append("'");
				            sb1.append(">").append(SystemEnv.getHtmlLabelName(445,language)).append("</option>");//年
				            checkstr = "";
							if ("M".equals(fieldname)) checkstr = " selected ";
				            sb1.append("<option value='M'").append(checkstr).append(" label='").append(SystemEnv.getHtmlLabelName(6076,language)).append("'");
				            sb1.append(">").append(SystemEnv.getHtmlLabelName(6076,language)).append("</option>");//月
				            checkstr = "";
							if ("D".equals(fieldname)) checkstr = " selected ";
				            sb1.append("<option value='D'").append(checkstr).append(" label='").append(SystemEnv.getHtmlLabelName(16889,language)).append("'");
				            sb1.append(">").append(SystemEnv.getHtmlLabelName(16889,language)).append("</option>");//日
				            checkstr = "";
							if ("YM".equals(fieldname)) checkstr = " selected ";
				            sb1.append("<option value='YM'").append(checkstr).append(" label='").append(SystemEnv.getHtmlLabelName(445,language)).append(SystemEnv.getHtmlLabelName(6076,language)).append("'");
				            sb1.append(">").append(SystemEnv.getHtmlLabelName(445,language)).append(SystemEnv.getHtmlLabelName(6076,language)).append("</option>");//年月
				            checkstr = "";
							if ("MD".equals(fieldname)) checkstr = " selected ";
				            sb1.append("<option value='MD'").append(checkstr).append(" label='").append(SystemEnv.getHtmlLabelName(6076,language)).append(SystemEnv.getHtmlLabelName(16889,language)).append("'");
				            sb1.append(">").append(SystemEnv.getHtmlLabelName(6076,language)).append(SystemEnv.getHtmlLabelName(16889,language)).append("</option>");//月日
				            checkstr = "";
							if ("YMD".equals(fieldname)) checkstr = " selected ";
				            sb1.append("<option value='YMD'").append(checkstr).append(" label='").append(SystemEnv.getHtmlLabelName(445,language)).append(SystemEnv.getHtmlLabelName(6076,language)).append(SystemEnv.getHtmlLabelName(16889,language)).append("'");
				            sb1.append(">").append(SystemEnv.getHtmlLabelName(445,language)).append(SystemEnv.getHtmlLabelName(6076,language)).append(SystemEnv.getHtmlLabelName(16889,language)).append("</option>");//年月日
						} else if ("1".equals(type)) { //单人力资源
							sb1.append("<option ").append("value='").append("workcode").append("'").append(" selected ").append(" label='").append(SystemEnv.getHtmlLabelName(27940, user.getLanguage())).append("'").append(">").append(SystemEnv.getHtmlLabelName(27940, user.getLanguage())).append("</option>").append("\n");
						} else if ("4".equals(type)) { //部门
							sb1.append("<option ").append("value='").append("departmentcode").append("'").append(" selected ").append(" label='").append(SystemEnv.getHtmlLabelName(22290, user.getLanguage())).append("'").append(">").append(SystemEnv.getHtmlLabelName(22290, user.getLanguage())).append("</option>").append("\n");
						} else if ("164".equals(type)) { //所属分部
							sb1.append("<option ").append("value='").append("subcompanycode").append("'").append(" selected ").append(" label='").append(SystemEnv.getHtmlLabelName(81809, user.getLanguage())).append("'").append(">").append(SystemEnv.getHtmlLabelName(81809, user.getLanguage())).append("</option>").append("\n");
						} else if ("256".equals(type)) { //树形browser
							String tablenamesql = "select tablename,sourceid,sourcefrom from mode_customtree m,mode_customtreedetail d where m.id=d.mainid and m.id="+fielddbtype;
							String tablenames = "";
							String formids = "";
							rs.executeSql(tablenamesql);
							while(rs.next()){
								String _tablename = "";
								String _formid = "";
								String sourceid = Util.null2String(rs.getString(2));
								String sourcefrom = Util.null2String(rs.getString(3));
								
								if(sourcefrom.equals("1") && !"".equals(sourceid)){//模块
									recordSet.executeSql("select formid,b.tablename from modeinfo m,workflow_bill b where m.formid=b.id and m.id="+sourceid);
									if(recordSet.next()){
										_formid = recordSet.getString(1);
										formids += ","+_formid;
									}
								}else{
									_tablename = rs.getString(1);
									tablenames += ",'"+_tablename+"'";
								}
							}
							
							String wheresql = "";
							if(!tablenames.equals("")){
								tablenames = tablenames.substring(1);
								wheresql += " m.tablename in ("+tablenames+")";
							}else{
								wheresql += " 1=2 ";
							}
							
							if(!formids.equals("")){
								formids = formids.substring(1);
								wheresql += " or m.id in ("+formids+")";
							}else{
								wheresql += " or 1=2 ";
							}
							wheresql = " and ("+wheresql+")";
							
							rs.executeSql("select distinct m.tablename,b.fieldname,h.labelname from workflow_bill m, workflow_billfield b,HtmlLabelInfo h where m.id=b.billid and h.languageid=7 and b.fieldlabel=h.indexid and viewtype=0 and fieldhtmltype='1'"+wheresql);
							while (rs.next()) {
								String tablename2 = rs.getString("tablename");
								String fieldname2 = rs.getString("fieldname");
								String labelname2 = rs.getString("labelname");
								checkstr = "";
								if (fieldname.equals(fieldname2)) {//如果字段和保存的字段一样，则选中
									 checkstr = " selected ";
								 } 
								sb1.append("<option ").append("value='").append(fieldname2).append("'").append(checkstr).append(" label='").append(labelname2).append("'").append(">").append(labelname2).append("</option>").append("\n");
							}
						} else { //其它类型
							//TODO
						}
					}
			  }
		      
		      
		      
		      	 StringBuffer sb = new StringBuffer("");
		         if ("1".equals(codeMemberType)){   //1:年,月,日,模块名称
		           	if ("1".equals(codeMemberValue)){
		               	out.println("<input type=checkbox class=inputstyle  tzCheckbox=\"true\" checked value=1  onclick=proView()>");
		           	} else {
		               	out.println("<input type=checkbox class=inputstyle  tzCheckbox=\"true\" value=1  onclick=proView()>");
		           	}
		         } else if ("2".equals(codeMemberType)){   //2:流水号
		              out.println("<input type=text class=inputstyle onkeyup=proView() maxlength='20' onKeyPress='ItemCount_KeyPress()' onKeyUp='NotWriteZero(this)' value="+codeMemberValue+">");
		         } else if ("3".equals(codeMemberType)){  //3:前缀
		        	  out.println("<input type=text class=inputstyle onkeyup=proView() maxlength='20'  value="+codeMemberValue+">");
		         } else {
		        	 if ("4".equals(codeMemberType)){//4:字段编码  browser和树形
		        		 sb.append("<span class=spancls>");
			        	 sb.append("<select showvalue='"+codeMemberValue+"'>");
			      		 sb.append(sb1.toString());
			      		 sb.append("</select>");
			      		 sb.append("</span>");
			             sb.append("<span class='Serial'>").append(SystemEnv.getHtmlLabelName(82782,user.getLanguage())).append("：<input class='InputStyle' type='checkbox' id='fieldNum_"+detailid+"'").append(serialChkStr).append(" tzCheckbox='true' value='1'></span>");
			         } else if ("5".equals(codeMemberType)) {//5:日期字段
			        	 sb.append("<span class=spancls>");
			        	 sb.append("<select showvalue='"+codeMemberValue+"'>");
			      		 sb.append(sb1.toString());
			      		 sb.append("</select>");
			      		 sb.append("</span>");
			             sb.append("<span class='Serial'>").append(SystemEnv.getHtmlLabelName(82782,user.getLanguage())).append("：<input class='InputStyle' type='checkbox' id='fieldNum_"+detailid+"'").append(serialChkStr).append(" tzCheckbox='true' value='1'></span>");
			         } else if ("6".equals(codeMemberType)) {//6:字符串
			      		 sb.append("<input type=text class=inputstyle maxlength='20' value='").append(codeMemberValue).append("' onkeyup=proView() />");
			         } else if ("7".equals(codeMemberType)) { //7:文本框
			        	 sb.append("<span class=spancls showvalue='").append(codeMemberValue).append("'>").append(fieldnamestr).append("</span>");
			         } else if ("8".equals(codeMemberType)) { //8:下拉框
			        	 sb.append("<span class=spancls showvalue='").append(codeMemberValue).append("'>").append(fieldnamestr).append("</span>");
				         sb.append("<span class='Serial'>").append(SystemEnv.getHtmlLabelName(82782,user.getLanguage())).append("：<input class='InputStyle' type='checkbox' id='fieldNum_"+detailid+"'").append(serialChkStr).append(" tzCheckbox='true' value='1'></span>");
			         } else if ("9".equals(codeMemberType)) { //其它类型
			        	 sb.append("<span class=spancls showvalue='").append(codeMemberValue).append("'").append(" fieldname='").append(fieldname).append("'>").append(fieldnamestr).append("</span>");
			         }
		        	 sb.append("<span style='float:right;padding-right:160px;width:30px;'><input type=button  class=delbtn onclick='onDelete(").append(detailid).append(")' ").append("title='"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"' ></input></span>");
		        	 out.println(sb.toString());
		         }
		    %>
		    </TD>                   
		  </TR>  
		  <tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
		  <%
		  }%>
		  </TBODY>
		</table>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>' attributes="{'samePair':'codedetail_g','itemAreaDisplay':'true'}" ><!-- 预览 -->
		<wea:item>
			<table border="1" cellspacing="0" cellpadding="0">
               <tr id="TR_pro"></tr>
               
             </table>
		</wea:item>
	</wea:group>
</wea:layout>
    
</form>
</body>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	load();
	checkinput('codeFieldId','codeFieldId_span');
})
jQuery(function(){
	registerDragEvent();
});

function registerDragEvent(){
	var fixHelper = function(e, ui) {
       ui.children().each(function() { 
          $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
          $(this).height($(this).height());  
       });  
       return ui;  
    };
  
    var copyTR = null;
	var startIdx = 0;
  
    jQuery("#membersTable tbody tr").bind("mousedown",function(e){
		copyTR = jQuery(this).next("tr.Spacing");
	});
  
    jQuery("#membersTable tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
       helper: fixHelper,                  //调用fixHelper  
       axis:"y",  
       start:function(e, ui){
           ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
           if(ui.item.hasClass("notMove")){
           	  e.stopPropagation();
           }
           if(copyTR){
      		  copyTR.hide();
      	   }
      	   startIdx = ui.item.get(0).rowIndex;
           return ui;  
       },  
       stop:function(e, ui){ 
           ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
           if(copyTR){
	      	  if(ui.item.get(0).rowIndex>startIdx){
	       	  	ui.item.before(copyTR.clone().show());
	       	  }else{
	       	  	ui.item.after(copyTR.clone().show());
	       	  }
	      	  copyTR.remove();
	      	  copyTR = null;
      	   }
		   load();
           return ui;  
       }  
   });  
}
jQuery.fn.swap = function(other) {
    $(this).replaceWith($(other).after($(this).clone(true)));
};

function onSave(obj){
    if (!check_form(frmCoder,'codeFieldId')){
		return;
	}
	enableAllmenu();
  var postValueStr="";
 
  jQuery("tr[customer1='member']").each(function(index,obj){
	   var detailid = $(obj).attr("detailid");
	   var codeDataType = $(obj).attr("datatype");
	   var isSerial = "0";
	   var fieldChkObj = $("#fieldNum_"+detailid);
	   if (fieldChkObj) {
		  if (fieldChkObj.attr("checked")) {
			 isSerial = "1";
		  }
	   }
	   
	   var codeValue="[(*_*)]";
	   var fieldname = "[(*_*)]";
	   if (codeDataType=='1') { //年,月,日,模块
		   codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	   } else if (codeDataType=='2') {//流水号
		   codeValue= $(obj).find("td::eq(1)").children(":first").val();
	   } else if (codeDataType=='3') { //编码前缀
		   codeValue= $(obj).find("td::eq(1)").children(":first").val();
	   } else if (codeDataType=='4'||codeDataType=='5') { //字段编码和下拉选择
		   codeValue= $(obj).find("td::eq(1)").find("span::eq(0)").children(":first").attr("showvalue");
		   fieldname = $(obj).find("td::eq(1)").find("span::eq(0)").children(":first").find("option:selected").val();
	   } else if (codeDataType=='6') { //字符串
		   codeValue= $(obj).find("td::eq(1)").children(":first").val();
	   } else if (codeDataType=='7' || codeDataType=='8') { //文本和下拉框
		   codeValue= $(obj).find("td::eq(1)").children(":first").attr("showvalue");
	   } else { //其它
		   codeValue= $(obj).find("td::eq(1)").children(":first").attr("showvalue");
		   fieldname= $(obj).find("td::eq(1)").children(":first").attr("fieldname");
	   }
	   if (!codeValue) codeValue="[(*_*)]";
	   if (!fieldname) fieldname="[(*_*)]";
	   postValueStr += detailid+"\u001b"+codeValue+"\u001b"+ fieldname+"\u001b"+isSerial+"\u0007";
  })
  postValueStr = postValueStr.substring(0,postValueStr.length-1);
  document.frmCoder.postValue.value=postValueStr;
  document.frmCoder.method.value="update";
  document.frmCoder.submit();
}

var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666","#DD00FF")  ;

function load(){  //检查Imag的状态
  proView();
}

function proView(){
	 var TR_doc =  jQuery("#TR_pro");
	 jQuery(TR_doc).children("td").remove();
	 jQuery("tr[customer1='member']").each(function(index,obj){
		 var codeTitle = $(obj).find("td::eq(0)").text();
		 codeTitle = jQuery.trim(codeTitle)
		 var codeDataType = $(obj).attr("datatype");
		 var codeValue;
		 if (codeDataType=='1') { //年,月,日,模块
		     codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true;
		     if (codeValue) codeValue = "****";
		     else return true;
		 } else if (codeDataType=='2') {//流水号
			 codeValue= $(obj).find("td::eq(1)").children(":first").val();
		     if (!codeValue) return true;
		 } else if (codeDataType=='3') { //编码前缀
			 codeValue= $(obj).find("td::eq(1)").children(":first").val();
		   	 if (!codeValue) return true;
		 } else if (codeDataType=='6') { //字符串
		     codeValue= $(obj).find("td::eq(1)").children(":first").val();
		     if (!codeValue) return true;
		 } else if (codeDataType=='4' || codeDataType=='5' || codeDataType=='7' || codeDataType=='8' || codeDataType=='9') { //字段编码,日期编码,下拉框,其它类型
		   	 codeValue = "****";
		 } 
		 var tempTd = document.createElement("TD");
	     var tempTable = document.createElement("TABLE");
	     var newRow = tempTable.insertRow(-1);
	     var newRowMiddle = tempTable.insertRow(-1);
	     var newRow1 = tempTable.insertRow(-1);
		 var newCol = newRow.insertCell(-1);
	     var newColMiddle=newRowMiddle.insertCell(-1);
	     var newCol1 = newRow1.insertCell(-1);
	
	     jQuery(newRowMiddle).css("height","1px");
		 newColMiddle.className="Line";
	
	     newCol.innerHTML="<font color="+colors[codeDataType]+">"+codeTitle+"</font>";
		 newCol1.innerHTML="<font color="+colors[codeDataType]+">"+codeValue+"</font>";
		 jQuery(tempTd).append(tempTable);
		 jQuery(TR_doc).append(tempTd)
     })
}

function enableAllmenu() {
	// TD9015 点击任一按钮，把所有"BUTTON"给灰掉
	for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
		if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
			window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
			//alert(a);
		}
	}
	// window.frames["rightMenuIframe"].event.srcElement.disabled = false;
	
	try{// ext菜单灰色
		parent.Ext.getCmp('tabPanelContent').getTopToolbar().disable();// 鼠标灰掉
	}catch(e){
	}
	try{
		// 头部菜单灰色
		if (window.ActiveXObject) {
			for (b=0;b<parent.document.getElementById("toolbarmenu").all.length;b++){
				if(parent.document.getElementById("toolbarmenu").all.item(b).tagName == "TABLE"){
					parent.document.getElementById("toolbarmenu").all.item(b).disabled=true;
				}
			}
		} else {
			jQuery("#toolbarmenuCoverdiv", parent.document).show();
		}
		
	}
	catch(e)
	{
	}
}

// 判断input框中是否输入的是数字,不包括小数点
function ItemCount_KeyPress()
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
 if(!(((keyCode>=48) && (keyCode<=57))))
  {
     if (evt.keyCode) {
     	evt.keyCode = 0;evt.returnValue=false;     
     } else {
     	evt.which = 0;evt.preventDefault();
     } 
  }
}

//不能输入0
function NotWriteZero(obj){
	if (parseInt(obj.value) == 0) obj.value = "";
}

var diag_vote;
function onAddField(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 520;
	diag_vote.Height = 80;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	//添加字段
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>";//添加字段
	diag_vote.maxiumnable = true;
	diag_vote.URL = "/formmode/setup/addModeCodeField.jsp?modeId=<%=modeId%>&formId=<%=formId%>&codemainid=<%=codeId%>";
	diag_vote.show();
}
function closeDlgARfsh(){
	location.href="/formmode/setup/ModeCode.jsp?id=<%=modeId%>";
	diag_vote.close();	
} 
function onDelete(detailid) {
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){ //确定要删除吗
		jQuery.ajax({
			   type: "POST",
			   dataType:"string",
			   async:false,
			   url: "/weaver/weaver.formmode.servelt.CodeBuildAction?action=delModeCodeDetail",
			   data: "detailid="+detailid,
			   success: function(data){
				   location.href="/formmode/setup/ModeCode.jsp?id=<%=modeId%>";
			   }
		});
	});
}
</script>
</html>
