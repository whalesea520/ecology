
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelLayoutManager" class="weaver.workflow.exceldesign.ExcelLayoutManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), -1);
int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);

int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
int isform = Util.getIntValue(request.getParameter("isform"), 0);
int nodetype = -1;
rs.execute("select nodetype from workflow_flownode where nodeid="+nodeid);
if(rs.next()){
	nodetype = Util.getIntValue(rs.getString("nodetype"), -1);
}
int canFieldEdit = 1;//设置这个属性，在wfEditorConf.js获得hidden的input的value，以判断是否出现“只读”、“可编辑”、“必填”3个右键菜单
if(nodetype==3 || layouttype==1){
	canFieldEdit = 0;
}

//获取模板信息
ExcelLayoutManager.setRequest(request);
ExcelLayoutManager.setUser(user);
HashMap<String,String> ret_map = ExcelLayoutManager.doGetExcelLayout();
String layoutname = Util.null2String(ret_map.get("layoutname"));
String otherslayoutname = Util.null2String(ret_map.get("otherslayoutname"));
String datajson = Util.null2String(ret_map.get("datajson"));
String pluginjson = Util.null2String(ret_map.get("pluginjson"));
//自定义属性写&#13;串引起模板解析报错
datajson = datajson.replaceAll("&#13;", "#title_br_replacestr#");
pluginjson = pluginjson.replaceAll("&#13;", "#title_br_replacestr#");

String scripts = Util.null2String(ret_map.get("scripts"));
int isactive = Util.getIntValue(ret_map.get("isactive"), 0);

//获取字段、节点、SQL属性等信息
Hashtable rhs = ExcelLayoutManager.getFieldAttr4LEF();
ArrayList fieldidList = (ArrayList)rhs.get("fieldidList");
Hashtable fieldLabel_hs = (Hashtable)rhs.get("fieldLabel_hs");
Hashtable fieldAttr_hs = (Hashtable)rhs.get("fieldAttr_hs");
Hashtable detailFieldid_hs = (Hashtable)rhs.get("detailFieldid_hs");
ArrayList detailGroupList = (ArrayList)rhs.get("detailGroupList");
Hashtable detailGroupTitle_hs = (Hashtable)rhs.get("detailGroupTitle_hs");
Hashtable fieldSQL_hs = (Hashtable)rhs.get("fieldSQL_hs");

ArrayList nodeidList = (ArrayList)rhs.get("nodeidList");
ArrayList nodenameList = (ArrayList)rhs.get("nodenameList");
ArrayList detailGroupAttrList = (ArrayList)rhs.get("detailGroupAttrList");
String fileFieldids = Util.null2String((String)rhs.get("fileFieldids"));
String inputFieldids = Util.null2String((String)rhs.get("inputFieldids"));
String especialFieldids = Util.null2String((String)rhs.get("especialFieldids"));
String dateFields = Util.null2String((String)rhs.get("dateFields"));
String zhengshuFields = Util.null2String((String)rhs.get("zhengshuFields"));
String shuziFieldids = Util.null2String((String)rhs.get("shuziFieldids"));	
StringBuffer fieldAttr_sb = new StringBuffer();//字段属性，拼html代码。主表和明细表字段放一起拼
StringBuffer detailGroupAttr_sb = new StringBuffer();//明细表属性

StringBuffer fieldSQL_sb = new StringBuffer();//字段SQL属性

StringBuffer fieldid_sb = new StringBuffer();//记录所有字段id
String detailnum="";

//主字段隐藏域
for(int i=0; i<fieldidList.size(); i++){
	String fieldid_tmp = (String)fieldidList.get(i);
	String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
	String fieldAttr_tmp = Util.null2String((String)fieldAttr_hs.get("fieldAttr"+fieldid_tmp));
	fieldAttr_sb.append("<input type=\"hidden\" id=\"fieldattr"+fieldid_tmp+"\" fieldname=\""+fieldlabel_tmp+"\" nodetype=\"-1\" name=\"fieldattr"+fieldid_tmp+"\" value=\""+fieldAttr_tmp+"\">").append("\n");
	String fieldSQL_tmp = Util.null2String((String)fieldSQL_hs.get("fieldsql"+fieldid_tmp));
	String datasourceid = Util.null2String((String)fieldSQL_hs.get("datasourceid"+fieldid_tmp));
	int caltype_tmp = Util.getIntValue((String)fieldSQL_hs.get("caltype"+fieldid_tmp), 0);
	int othertype_tmp = Util.getIntValue((String)fieldSQL_hs.get("othertype"+fieldid_tmp), 0);
	int transtype_tmp = Util.getIntValue((String)fieldSQL_hs.get("transtype"+fieldid_tmp), 0);
	fieldSQL_sb.append("<input type=\"hidden\" id=\"fieldsql"+fieldid_tmp+"\" name=\"fieldsql"+fieldid_tmp+"\" value=\""+fieldSQL_tmp+"\">").append("\n");
	fieldSQL_sb.append("<input type=\"hidden\" id=\"caltype"+fieldid_tmp+"\" name=\"caltype"+fieldid_tmp+"\" value=\""+caltype_tmp+"\" >").append("\n");
	fieldSQL_sb.append("<input type=\"hidden\" id=\"othertype"+fieldid_tmp+"\" name=\"othertype"+fieldid_tmp+"\" value=\""+othertype_tmp+"\">").append("\n");
	fieldSQL_sb.append("<input type=\"hidden\" id=\"transtype"+fieldid_tmp+"\" name=\"transtype"+fieldid_tmp+"\" value=\""+transtype_tmp+"\">").append("\n");
	fieldSQL_sb.append("<input type=\"hidden\" id=\"datasourceid"+fieldid_tmp+"\" name=\"datasourceid"+fieldid_tmp+"\" value=\""+datasourceid+"\">").append("\n");
	fieldid_sb.append(fieldid_tmp+",");
}
//明细字段隐藏域
if(detailGroupList!=null && detailGroupList.size()>0){
	detailnum="<input type=\"hidden\" id=\"detailnum\" name=\"detailnum\" value=\""+detailGroupList.size()+"\" />";
	for(int i=0; i<detailGroupList.size(); i++){
		String groupid_tmp = (String)detailGroupList.get(i);
		String detailGroupAttr = (String)detailGroupAttrList.get(i);
		ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
		if(detailFieldidList!=null && detailFieldidList.size()>0){
			String title_tmp = (String)detailGroupTitle_hs.get("grouptitle"+groupid_tmp);
			detailGroupAttr_sb.append("<input type=\"hidden\" id=\"detailgroupattr"+i+"\" name=\"detailgroupattr"+i+"\" value=\""+detailGroupAttr+"\">").append("\n");

			for(int j=0; j<detailFieldidList.size(); j++){
				String detailFieldid_tmp = (String)detailFieldidList.get(j);
				String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
				String detailFieldAttr_tmp = (String)fieldAttr_hs.get("fieldAttr"+detailFieldid_tmp);
				fieldAttr_sb.append("<input type=\"hidden\" id=\"fieldattr"+detailFieldid_tmp+"\" fieldname=\""+detailFieldlabel_tmp+"\" nodetype=\""+i+"\" name=\"fieldattr"+detailFieldid_tmp+"\" value=\""+detailFieldAttr_tmp+"\">").append("\n");
				String fieldSQL_tmp = Util.null2String((String)fieldSQL_hs.get("fieldsql"+detailFieldid_tmp));
				int caltype_tmp = Util.getIntValue((String)fieldSQL_hs.get("caltype"+detailFieldid_tmp), 0);
				int othertype_tmp = Util.getIntValue((String)fieldSQL_hs.get("othertype"+detailFieldid_tmp), 0);
				int transtype_tmp = Util.getIntValue((String)fieldSQL_hs.get("transtype"+detailFieldid_tmp), 0);
				String datasourceid = Util.null2String((String)fieldSQL_hs.get("datasourceid"+detailFieldid_tmp));
				fieldSQL_sb.append("<input type=\"hidden\" id=\"fieldsql"+detailFieldid_tmp+"\" name=\"fieldsql"+detailFieldid_tmp+"\" value=\""+fieldSQL_tmp+"\">").append("\n");
				fieldSQL_sb.append("<input type=\"hidden\" id=\"caltype"+detailFieldid_tmp+"\" name=\"caltype"+detailFieldid_tmp+"\" value=\""+caltype_tmp+"\" >").append("\n");
				fieldSQL_sb.append("<input type=\"hidden\" id=\"othertype"+detailFieldid_tmp+"\" name=\"othertype"+detailFieldid_tmp+"\" value=\""+othertype_tmp+"\">").append("\n");
				fieldSQL_sb.append("<input type=\"hidden\" id=\"transtype"+detailFieldid_tmp+"\" name=\"transtype"+detailFieldid_tmp+"\" value=\""+transtype_tmp+"\">").append("\n");
				fieldSQL_sb.append("<input type=\"hidden\" id=\"datasourceid"+detailFieldid_tmp+"\" name=\"datasourceid"+detailFieldid_tmp+"\" value=\""+datasourceid+"\">").append("\n");
				fieldid_sb.append(detailFieldid_tmp+",");
			}
		}
	}
}
//节点信息隐藏域
StringBuffer wfnode_sb = new StringBuffer();
if(nodeidList != null && nodenameList != null){
	for(int i=0; i<nodeidList.size(); i++){
		wfnode_sb.append("<input type=\"hidden\" name=\"wfnode"+nodeidList.get(i)+"\" id=\"wfnode"+nodeidList.get(i)+"\" value=\""+nodenameList.get(i)+"\" />").append("\n");
	}
}
%>
<HTML>
<HEAD>
<script type="text/javascript">
	var mainFields=null;		//全局变量-主表字段信息
	var detailFields=null;		//全局变量-明细表字段信息

	var WfNodes=null;			//全局变量-节点信息
	jQuery(document).ready(function(){
		$(".tableBody").css("height",($(window).height()-273)+"px");
		//异步初始化全局变量
		initGlobalData();
		//tableHead绑定click、初始化加载
		operTableHead();
		if(wfinfo)
			wfinfo.isactive = "<%=isactive %>";	
		
		window.setTimeout(function(){
			jQuery(".discriptionArea").closest("td").css("cssText", "padding-left:10px!important;padding-right:5px;");
			$("div[name=somethingdiv]").find("tr.groupHeadHide").find(".hideBlockDiv").click(function(e){
				var ishow = $(this).attr("_status");
				if(ishow==="0"){
					$(".tableBody").css("height",($(".tableBody").height()-137)+"px");
				}else{
					$(".tableBody").css("height",($(".tableBody").height()+137)+"px");
				}
			});
		},200);
	});
</script>
<TITLE></TITLE>
</HEAD>
<BODY style="margin:0px; padding:0px;">
<form id="LayoutForm" name="LayoutForm" style="height:100%;" method="post">
	<div class="moduleTitle">模板名称：
		<input id="layoutname" name="layoutname" type="text" style="width:120px" value="<%=layoutname %>" onchange="checkRequired(this, 'layoutnamespan');"></input>
		<span id="layoutnamespan"><img style="<%="".equals(layoutname)?"":"display:none" %>" src="/images/BacoError_wev8.gif" align="absMiddle"></span>
	</div>
	<div class="filedTab">
		<div class="tableHead" style="height:31px;">
			<div style="float:left" class="current" name="mf">主表字段</div>
			<div style="float:right" name="wn">流程节点</div>
		</div>
		<div class="tableSearch" style="padding:5px;">
			<span class="searchInputSpan">
				<input type="text" class="searchInput" name="searchVal" onkeypress="if(event.keyCode==13) {searchTable();}"/></input>
				<span>
					<img src="/images/ecology8/request/search-input_wev8.png" onclick="searchTable()"></img>
				</span>
			</span>
			<span class="addmf" title="新建字段" >
				<img src="/images/ecology8/add_wev8.png" onclick="javascript:addFormField();"></img>
			</span>
		</div>
		<div class="tableBody" style="width:100%;overflow-y:auto;">
			<table style="width:100%;">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tbody>
					<tr class="thead">
						<td class="rightBorder"></td>
						<td></td>
					</tr>
				</tbody>
			</table>
			<div id="labellist-1" class="fieldlist" style="display:none;">
			<%for(int i=0; i<fieldidList.size(); i++){
					String fieldid_tmp = (String)fieldidList.get(i);
					String fieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+fieldid_tmp);
					if("-6".equals(fieldid_tmp) || "-4".equals(fieldid_tmp))
						continue;
					//如果是手机版Html模板，则不显示“签字意见”选项
					if(layouttype == 2 && "签字意见".equals(fieldlabel_tmp))	continue;
			%>
				<div id="field_<%=fieldid_tmp%>" ondblclick="javascript:cool_webcontrollabel(this);">
					<input type="hidden" value="<%=fieldid_tmp%>"/><%=fieldlabel_tmp%>
				</div>
			<%}%>
			</div>
			<%if(detailGroupList!=null && detailGroupList.size()>0){
				for(int i=0; i<detailGroupList.size(); i++){
					String groupid_tmp = (String)detailGroupList.get(i);
					ArrayList detailFieldidList = (ArrayList)detailFieldid_hs.get("group"+groupid_tmp);
					if(detailFieldidList!=null && detailFieldidList.size()>0){
			%>
				<div id="labellist<%=i%>" class="fieldlist" style="display:none;">
			<%
					for(int j=0; j<detailFieldidList.size(); j++){
						String detailFieldid_tmp = (String)detailFieldidList.get(j);
						String detailFieldlabel_tmp = (String)fieldLabel_hs.get("fieldlabel"+detailFieldid_tmp);
						String sqltemp = "select orderid from workflow_billfield a,Workflow_billdetailtable b where a.detailtable = b.tablename and a.id = " + detailFieldid_tmp;
						if(isbill != 1){
							sqltemp = "select groupid + 1 from workflow_formfield where formid = "+formid+" and fieldid = " + detailFieldid_tmp;
						}
						int detailindex = 1;
						rs.execute(sqltemp);
						if(rs.next())
							detailindex = rs.getInt(1);
			%>
						<div id="field_<%=detailFieldid_tmp%>" ondblclick="javascript:cool_webcontrollabel(this);">
							<input type="hidden" value="<%=detailFieldid_tmp%>"/><%=detailFieldlabel_tmp%>(<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=detailindex %>)
						</div>
			<%			}
					}
			%>
				</div>
			<%	}
			}
			%>
			<div name="editfieldDiv" style="display:none;position: relative;height:0px;">
				<div name="editfieldDiv1" style="position: relative;">
					<div name="editfieldCry" style="position:relative;text-align:center;background:#ffffff;padding-bottom:5px;border-top:1px solid #c9c9c9;border-bottom:1px solid #c9c9c9;">
						<input type="hidden" name="fieldid" />
						<div style="float:left;margin-top:5px;height:25px;padding-left:10px;"><img src="/images/ecology8/simplized_wev8.png" /></div>
						<div style="margin-top:5px;height:25px;"><input type="text" id="cnlabel" onblur="checkMaxLength(this)" maxlength="255" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><img style="display:none;" src="/images/BacoError_wev8.gif" align="absMiddle"></div>
						<div style="float:left;margin-top:5px;height:25px;padding-left:10px;"><img src="/images/ecology8/en_wev8.png" /></div>
						<div style="margin-top:5px;height:25px;"><input type="text" id="enlabel"  onblur="checkMaxLength(this)" maxlength="255" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></div>
						<div style="float:left;margin-top:5px;height:25px;padding-left:10px;"><img src="/images/ecology8/tranditional_wev8.png" /></div>
						<div style="margin-top:5px;height:25px;"><input type="text" id="twlabel" onblur="checkMaxLength(this)" maxlength="255" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></div>
						<div id="zDialog_div_bottom" style="margin-top:5px; border-top:1px solid #c9c9c9;padding-top:5px;">
					    	<input type="button" value="确定" id="zd_btn_cancle" onclick="saveEditFieldName()"  class="zd_btn_cancle" style="height: 25px;line-height: 25px;padding-left: 10px;padding-right: 10px;">
					    	<input type="button" value="取消" id="zd_btn_cancle" onclick="cancelEditFieldName()"  class="zd_btn_cancle" style="height: 25px;line-height: 25px;padding-left: 10px;padding-right: 10px;">  
					  	</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div name="somethingdiv" style="position:relative;">
		<wea:layout type="twoCol"  >
			<wea:group context="说明" attributes="{itemAreaDisplay:none}">
				<wea:item attributes="{'colspan':'2'}">
					<div class="discriptionArea"></div>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<div class="moduleBottom"></div>
	<div id="hiddenAttrDiv" style="display:none">
		<!-- 所有隐藏域 -->
		<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>" />
		<input type="hidden" id="formid" name="formid" value="<%=formid%>" />
		<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>" />
		<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>" />
		<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>" />
		<input type="hidden" id="layouttype" name="layouttype" value="<%=layouttype%>" />
		<input type="hidden" id="isactive" name="isactive" value="<%=isactive %>" />
		<input type="hidden" id="isform" name="isform" value="<%=isform%>" />
		<input type="hidden" id="nodetype" value="<%=nodetype %>" />
		<input type="hidden" id="workflowname" value="<%=WorkflowComInfo.getWorkflowname(wfid+"") %>" />
		<input type="hidden" id="otherslayoutname" value="<%=otherslayoutname %>" />
		<!-- 明细表信息 -->
		<%=detailnum %>
		<%=detailGroupAttr_sb.toString()%>
		<textarea style="display:none" name="datajson" id="datajson"><%=datajson %></textarea>
		<textarea style="display:none" name="pluginjson" id="pluginjson"><%=pluginjson %></textarea>
		<textarea style="display:none" name="scripts" id="scripts"><%=scripts %></textarea>
		<!-- 节点信息 -->
		<%=wfnode_sb.toString()%>
		<!-- 字段属性 -->
		<%=fieldAttr_sb.toString()%>
		<!-- SQL属性 -->
		<%=fieldSQL_sb%>
		<input type="hidden" id="fieldids" name="fieldids" value="<%if(fieldid_sb.length()>0){out.print(fieldid_sb.deleteCharAt(fieldid_sb.length()-1));}%>">
		<input type="hidden" id="fileFieldids" name="fileFieldids" value="<%=fileFieldids%>">
		<input type="hidden" id="inputFieldids" name="inputFieldids" value="<%=inputFieldids%>">
		<input type="hidden" id="especialFieldids" name="especialFieldids" value="<%=especialFieldids%>">
		<input type="hidden" id="shuziFieldids" name="shuziFieldids" value="<%=shuziFieldids%>">
		<input type="hidden" id="canFieldEdit" name="canFieldEdit" value="<%=canFieldEdit%>">
		<input type="hidden" id="htmlfile" name="htmlfile" value="">
		<input type="hidden" id="dateFields" name="dateFields" value="<%=dateFields%>">
		<input type="hidden" id="zhengshuFields" name="zhengshuFields" value="<%=zhengshuFields%>">
	</div>
</form>
</BODY>
</HTML>