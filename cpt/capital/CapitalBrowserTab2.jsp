<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="weaver.cpt.util.html.HtmlUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="weaver.workflow.browserdatadefinition.ConditionField"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs_condition" class="weaver.conn.RecordSet" scope="page" />
<%
String isCapital=Util.null2String(request.getParameter("isCapital"));
String queryStr= request.getQueryString();
int reqid=Util.getIntValue(request.getParameter("reqid"),0);
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
</HTML>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:parent.onSubmitClick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:parent.btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" class="e8_btn_top"  onclick="parent.onSubmitClick()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form id="capitalqueryform" name="capitalqueryform">
<input type="hidden" name="reqid" id="reqid" value="<%=reqid %>" />

<div style="height:155px;max-height:155px;overflow:hidden;" id="e8QuerySearchArea">

<%
//流程浏览定义条件
int bdf_wfid=Util.getIntValue(request.getParameter("bdf_wfid"),-1);
int bdf_fieldid=Util.getIntValue(request.getParameter("bdf_fieldid"),-1);
int bdf_viewtype=Util.getIntValue(request.getParameter("bdf_viewtype"),-1);
List<ConditionField> lst=null;
if("1".equals(isCapital) && request.getParameter("bdf_wfid")!=null && (lst=ConditionField.readAll(bdf_wfid, bdf_fieldid, bdf_viewtype)).size()>0){
	JSONArray arr=new JSONArray();
	boolean allHide=true;
	for(int i=0;i<lst.size();i++){
		ConditionField f=lst.get(i);
		boolean isHide=f.isHide();
		if(allHide && !isHide){
			allHide=false;
		}
		String fname=f.getFieldName();
		JSONObject obj=new JSONObject();
		obj.put("isHide", isHide);
		obj.put("isReadonly", f.isReadonly());
		obj.put("FieldName", fname);
		obj.put("Value", f.getValue());
		obj.put("ConditionField", f);
		arr.put(obj);
	}
	
	if(!allHide){
%>		
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}" >
			<%
			for(int i=0;i<arr.length();i++){
				JSONObject obj=(JSONObject)arr.get(i);
				String fieldname=obj.getString("FieldName");
				String fieldvalue=obj.getString("Value");
				boolean isHide=obj.getBoolean("isHide");
				if(isHide){
					continue;
				}
				boolean isReadonly=obj.getBoolean("isReadonly");
				if("mark".equalsIgnoreCase(fieldname)){
	%>				
				<wea:item ><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
				<wea:item ><input name=mark value='<%=fieldvalue %>' size="35" class="InputStyle" <%=isReadonly?"readonly":"" %> ></wea:item>
	<%
				}else if("fnamark".equalsIgnoreCase(fieldname)){
	%>				
				<wea:item ><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></wea:item>
				<wea:item ><input name=fnamark value='<%=fieldvalue %>' size="35" class="InputStyle" <%=isReadonly?"readonly":"" %> ></wea:item>
	<%
				}else if("name".equalsIgnoreCase(fieldname)){
	%>				
					<wea:item ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item ><input name=name value='<%=fieldvalue %>' size="35" class="InputStyle" <%=isReadonly?"readonly":"" %> ></wea:item>
	<%
				}else if("capitalSpec".equalsIgnoreCase(fieldname)){
	%>				
					<wea:item ><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
					<wea:item ><input name=capitalspec value='<%=fieldvalue %>' size="35" class="InputStyle" <%=isReadonly?"readonly":"" %> ></wea:item>
	<%
				}else if("departmentid".equalsIgnoreCase(fieldname)){
					ConditionField f=(ConditionField)obj.get("ConditionField");
					String vtype= f.getValueType();
					if("1".equals(vtype)){//当前操作者的值
						fieldvalue=ResourceComInfo.getDepartmentID( ""+user.getUID());
					}else if("3".equals(vtype)){//取表单字段值
						fieldvalue="";
						if(f.isGetValueFromFormField()){
							fieldvalue=Util.null2String( f.getDepartmentIds( Util.null2String(request.getParameter("bdf_"+fieldname)).split(",")[0]));
						}
					}
	%>				
					<wea:item ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item >
				        <brow:browser viewType="0" name="departmentid" 
						browserValue='<%=fieldvalue %>' browserSpanValue='<%=DepartmentComInfo.getDepartmentname(fieldvalue) %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
						hasInput='<%=(""+!isReadonly) %>' isSingle="true" hasBrowser = "true" isMustInput='<%=(isReadonly?"0":"1") %>'
						completeUrl="/data.jsp?type=4" />
					</wea:item>
	<%				
				}
			}
			
			%>
		</wea:group>
	</wea:layout>	
<%
	}
	//隐藏
	for(int i=0;i<arr.length();i++){
		JSONObject obj=(JSONObject)arr.get(i);
		String fieldname=obj.getString("FieldName");
		String fieldvalue=obj.getString("Value");
		boolean isHide=obj.getBoolean("isHide");
		if(!isHide){
			continue;
		}
		if("departmentid".equalsIgnoreCase(fieldname)){
			ConditionField f=(ConditionField)obj.get("ConditionField");
			String vtype= f.getValueType();
			if("1".equals(vtype)){//当前操作者的值
				fieldvalue=ResourceComInfo.getDepartmentID( ""+user.getUID());
			}else if("3".equals(vtype)){//取表单字段值
				fieldvalue="";
				if(f.isGetValueFromFormField()){
					fieldvalue=Util.null2String( f.getDepartmentIds( Util.null2String(request.getParameter("bdf_"+fieldname)).split(",")[0]));
				}
			}
		}
%>		
		<input type="hidden" name="<%=fieldname %>" id="<%=fieldname %>" value="<%=fieldvalue %>" />
<%
	}
}else{//默认显示
	
	String sql_condition="select t1.*,t2.* from cpt_browdef t1,cptDefineField t2 where t1.iscondition=1 and t1.fieldid=t2.id and t2.isopen='1' order by t1.displayorder";
	rs_condition .executeSql(sql_condition);
	String needHideField=",";//用来隐藏字段
	if(!"1".equals(isCapital)){//资产资料
		needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,";
	}
	%>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'  attributes="{'groupSHBtnDisplay':'none'}" >
		<%
		while(rs_condition.next()){
			String fieldname=rs_condition.getString("fieldname");
			if(needHideField.contains(","+fieldname+",")) continue;
			
			String id=Util.null2String(rs_condition.getString("id"));
		    String fielddbtype=Util.null2String(rs_condition.getString("fielddbtype"));
		    String fieldhtmltype=Util.null2String(rs_condition.getString("fieldhtmltype"));
		    String type=Util.null2String(rs_condition.getString("type"));
		    String imgwidth=Util.null2String(rs_condition.getString("imgwidth"));
		    String imgheight=Util.null2String(rs_condition.getString("imgheight"));
		    String fieldlabel=Util.null2String(rs_condition.getString("fieldlabel"));
		    String viewtype=Util.null2String(rs_condition.getString("viewtype"));
		    String fromuser=Util.null2String(rs_condition.getString("fromuser"));
		    String textheight=Util.null2String(rs_condition.getString("textheight"));
		    String dsporder=Util.null2String(rs_condition.getString("dsporder"));
		    String isopen=Util.null2String(rs_condition.getString("isopen"));
		    String ismand=Util.null2String(rs_condition.getString("ismand"));
		    String isused=Util.null2String(rs_condition.getString("isused"));
		    
		    String issystem=Util.getIntValue(rs_condition.getString("issystem"),0)+"";
		    String allowhide=Util.null2String(rs_condition.getString("allowhide"));
		    String groupid=Util.null2String(rs_condition.getString("groupid"));
		    String fieldkind="1";
		    String eleclazzname=HtmlUtil.getHtmlClassName(fieldhtmltype);
			
			if("resourceid".equalsIgnoreCase(fieldname)&&!"1".equals(isCapital) ){
				fieldlabel=""+1507;
			}
			
			
			JSONObject jsonObject=new JSONObject();
		    jsonObject.put("id", id);
			jsonObject.put("fieldname", fieldname);
			jsonObject.put("fielddbtype", fielddbtype);
			jsonObject.put("fieldhtmltype", fieldhtmltype);
			jsonObject.put("type", type);
			jsonObject.put("imgwidth", imgwidth);
			jsonObject.put("imgheight", imgheight);
			jsonObject.put("fieldlabel", fieldlabel);
			jsonObject.put("viewtype", viewtype);
			jsonObject.put("fromuser", fromuser);
			jsonObject.put("textheight", textheight);
			jsonObject.put("dsporder", dsporder);
			jsonObject.put("isopen", "1");
			jsonObject.put("ismand", "0");
			jsonObject.put("isused", isused);
			
			jsonObject.put("issystem", issystem);
			jsonObject.put("allowhide", allowhide);
			jsonObject.put("groupid", groupid);
			jsonObject.put("fieldkind", fieldkind);
			jsonObject.put("eleclazzname", eleclazzname);
			
			if("5".equals(fieldhtmltype)){
				jsonObject.put("seltype", "cpt");
		    }
			
			%>
			<wea:item><%=SystemEnv.getHtmlLabelNames(fieldlabel,user.getLanguage())%></wea:item>
			<wea:item><%=((HtmlElement)Class.forName(jsonObject.getString("eleclazzname")).newInstance()).getHtmlElementString("", jsonObject, user)  %></wea:item>
			<%
		}
		%>
		</wea:group>
	</wea:layout>
<%
}
%>
</div>
</form>
<wea:layout>
	<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
		<wea:item attributes="{'isTableList':'true'}">
			<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			    <tr>
			    	<td>
			    		<IFRAME name=optFrame id=optFrame width=100% height="318px" frameborder=no scrolling=auto src="/cpt/capital/CapitalBrowserList.jsp?<%=queryStr %>">
					    	<%=SystemEnv.getHtmlLabelNames("15017",user.getLanguage())%>
					    </IFRAME>
			    	</td>
			    </tr>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align:center;">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="parent.btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.btncancel_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
jQuery(function(){
	try{
		parent.onSubmitClick();
	}catch (e) {
		// TODO: handle exception
	}
	
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	/*var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}*/
	
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei - 50)+"px";
	dads.top = (jQuery(th).offset().top+8)+"px";
	//dads.left = (tleft - 5)+"px";
	dads.left = jQuery(th).offset().left+"px";
	
	
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	//dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}
</script>
</BODY>
</HTML>

