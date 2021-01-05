<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="PrjWfConfComInfo" class="weaver.proj.util.PrjWfConfComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String rightStr="Cpt4Mode:DeprecationSettings";
if(!HrmUserVarify.checkUserRight(rightStr,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id = Util.null2String(request.getParameter("id"));
String deprename = "";
String depremethod="";
String sptcount="";
String wftype= "";
String isopen="1";
String issystem= "";
boolean isEdit=false;
boolean canEdit=false;
if (Util.getIntValue(id) > 0) {
	RecordSet.executeSql("select * from uf4mode_cptdepreconf where id="+id);
	if(RecordSet.next()){
		isEdit = true;
		deprename = RecordSet.getString("deprename");
		depremethod = RecordSet.getString("depremethod");
		sptcount = RecordSet.getString("sptcount");
		isopen = RecordSet.getString("isopen");
		issystem = RecordSet.getString("issystem");
		if(!"1".equals(issystem)){
			canEdit=true;
		}

	}

}
//不能选的wf
String notwfid="";
String titlelabel="125865";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

	String title="";
	title+= "<ul style='padding-left:15px;'>";
	title+=  	"<li>"+ SystemEnv.getHtmlLabelName(127960, user.getLanguage()) +"</li>";
	title+=  	"<li>"+ SystemEnv.getHtmlLabelName(127961, user.getLanguage()) +"</li>";
	title+=  	"<li>"+ SystemEnv.getHtmlLabelName(127962, user.getLanguage()) +"</li>";
	title+=  	"<li>"+ SystemEnv.getHtmlLabelName(127963, user.getLanguage()) +"</li>";
	title+=  	"<li>"+ SystemEnv.getHtmlLabelName(127964, user.getLanguage()) +"</li>";
	title+= "</ul>";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(1),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelNames(titlelabel,user.getLanguage()) %>"/>
</jsp:include>

<FORM id=weaver action="/formmode/cuspage/cpt/conf/cptdeprecationop.jsp" method=post>
<input type="hidden" name="method" id="method" value="<%=isEdit?"edit":"add" %>" />
<input type="hidden" name="id" value="<%=id %>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

  
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(1359,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="deprename_span" required="true">
				<input type="text" name="deprename" id="deprename" value="<%=deprename %>" onchange='checkinput("deprename","deprename_span");this.value=trim(this.value)'/>
			</wea:required>

		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%>&nbsp;&nbsp;<span id="help" title="<%=title %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item >
			<div class="container">
					<div  style="float: left!important;">
						<textarea   style="width: 300px; height: 100px;" name="depremethod" id="depremethod"><%=depremethod %></textarea>
					</div>
					<div style="float: left!important;margin-left:10px;">
						<select name="fieldname" ondblclick="doAppend(this);" id="fieldname" multiple style="height:100px;width: 150px;margin: 5px;">
							<option value="usedmonth"><%=SystemEnv.getHtmlLabelNames("125891",user.getLanguage()) %></option>
							<%
							RecordSet.executeSql("select t1.fieldname,t1.fieldlabel from workflow_billfield t1, workflow_bill t2 where t2.id = t1.billid and lower(t2.tablename)='uf_cptcapital' and ( (t1.fieldhtmltype='1' and t1.type in(2,3) )  ) and t1.fieldname!='currentval'");
								while (RecordSet.next()){
							%>
							<option value="<%=RecordSet.getString("fieldname") %>"><%=SystemEnv.getHtmlLabelNames( RecordSet.getString("fieldlabel"),user.getLanguage()) %></option>
							<%
								}

							%>
						</select>
					</div>




			</div>


		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125873,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="wftype" id="wftype">
				<option value="1" <%="1".equalsIgnoreCase(sptcount)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></option>
				<option value="0" <%="0".equalsIgnoreCase(sptcount)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(125023,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox"  tzCheckbox="true" <%="1".equals(isopen)?"checked":"" %> name="isopen" value="1" />
		</wea:item>
	</wea:group>
</wea:layout>	
	
			<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>  

</FORM>
<script language="javascript">

function checkFormula(){
	var form=jQuery("#weaver");
	var form_url=form.attr("action");
	var form_data=form.serialize();
	jQuery.ajax({
		url : form_url+"?method=checkformula",
		type : "post",
		async : true,
		data : form_data,
		dataType : "json",
		contentType: "application/x-www-form-urlencoded; charset=utf-8",
		success: function do4Success(data){
			if(data&&data.msg){
				window.top.Dialog.alert(data.msg);
				return;
			}else{
				jQuery.ajax({
					url : form_url,
					type : "post",
					async : true,
					data : form_data,
					dataType : "json",
					contentType: "application/x-www-form-urlencoded; charset=utf-8",
					success: function doSuccess(msg){
						parentWin._table.reLoad();
						parentWin.closeDialog();
					}
				});
			}

		}
	});
}

function submitData(type)
{
	var checkstr="deprename";
	if (check_form(weaver,checkstr)){
		checkFormula();
	}
}

$(function(){
	checkinput("deprename","deprename_span");
	jQuery("#help").wTooltip({html:true});
});
;(function($){
	/*
	 * 文本域光标操作（选、添、删、取）
	 */
	$.fn.extend({
		/*
		 * 获取光标所在位置
		 */
		iGetFieldPos:function(){
			var field=this.get(0);
			if(document.selection){
				//IE
				$(this).focus();
				var sel=document.selection;
				var range=sel.createRange();
				var dupRange=range.duplicate();
				dupRange.moveToElementText(field);
				dupRange.setEndPoint('EndToEnd',range);
				field.selectionStart=dupRange.text.length-range.text.length;
				field.selectionEnd=field.selectionStart+ range.text.length;
			}
			return field.selectionStart;
		},
		/*
		 * 选中指定位置内字符 || 设置光标位置
		 * --- 从start起选中(含第start个)，到第end结束（不含第end个）
		 * --- 若不输入end值，即为设置光标的位置（第start字符后）
		 */
		iSelectField:function(start,end){
			var field=this.get(0);
			//end未定义，则为设置光标位置
			if(arguments[1]==undefined){
				end=start;
			}
			if(document.selection){
				//IE
				var range = field.createTextRange();
				range.moveEnd('character',-$(this).val().length);
				range.moveEnd('character',end);
				range.moveStart('character',start);
				range.select();
			}else{
				//非IE
				field.setSelectionRange(start,end);
				$(this).focus();
			}
		},
		/*
		 * 选中指定字符串
		 */
		iSelectStr:function(str){
			var field=this.get(0);
			var i=$(this).val().indexOf(str);
			i != -1 ? $(this).iSelectField(i,i+str.length) : false;
		},
		/*
		 * 在光标之后插入字符串
		 */
		iAddField:function(str){
			var field=this.get(0);
			var v=$(this).val();
			var len=$(this).val().length;
			if(document.selection){
				//IE
				$(this).focus()
				document.selection.createRange().text=str;
			}else{
				//非IE
				var selPos=field.selectionStart;
				$(this).val($(this).val().slice(0,field.selectionStart)+str+$(this).val().slice(field.selectionStart,len));
				this.iSelectField(selPos+str.length);
			};
		},
		/*
		 * 删除光标前面(-)或者后面(+)的n个字符
		 */
		iDelField:function(n){
			var field=this.get(0);
			var pos=$(this).iGetFieldPos();
			var v=$(this).val();
			//大于0则删除后面，小于0则删除前面
			$(this).val(n>0 ? v.slice(0,pos-n)+v.slice(pos) : v.slice(0,pos)+v.slice(pos-n));
			$(this).iSelectField(pos-(n<0 ? 0 : n));
		}
	});
})(jQuery);

function doAppend(obj){
	$("#depremethod").iGetFieldPos();
	$("#depremethod").iAddField("#<"+$(obj).val()+">");
}
</script>
</BODY>
</HTML>
