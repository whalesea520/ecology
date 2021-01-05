
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.GetShowCondition"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.field.FieldManager" scope="page" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	String type = Util.null2String(request.getParameter("type"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String fielddec = Util.null2String(request.getParameter("fielddec"));
%>

<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_field_id') {
if(!document.form2.elements[i].disabled){
	document.form2.elements[i].checked=(checked==true?true:false);
}
} } }


function unselectall()
{
	if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
	}
}
function confirmdel() {
	len=document.form2.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.form2.elements[i].name=='delete_field_id')
			if(document.form2.elements[i].checked)
				break;
	}
	if(i==len){
		alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>") ;
}

</script>
<body>
<br>
<%
	String fieldid=""+Util.getIntValue(request.getParameter("fieldid"),0);
	String fieldname=Util.null2String(request.getParameter("fieldname"));
	String fielddbtype=Util.null2String(request.getParameter("fielddbtype"));

	ArrayList idList = new ArrayList();
	ArrayList fieldnameList = new ArrayList();
	ArrayList descriptionList = new ArrayList();
	ArrayList fielddbtypeList = new ArrayList();
	ArrayList fieldhtmltypeList = new ArrayList();
	ArrayList typeList = new ArrayList();
	ArrayList textheightList = new ArrayList();
	ArrayList issystemList = new ArrayList();
	ArrayList crmnameList = new ArrayList();
	ArrayList isshowList = new ArrayList();
	ArrayList iseditList = new ArrayList();
	ArrayList ismandList = new ArrayList();
	ArrayList wttypeList = new ArrayList();
	ArrayList orderidList = new ArrayList();
	ArrayList defaultvalueList = new ArrayList();
	ArrayList defaultvaluecnList = new ArrayList();

	String sql = "select id, fieldname, description, fielddbtype, fieldhtmltype, type, issystem, crmname, isshow, wttype, isedit, ismand, orderid, defaultvalue, defaultvaluecn, textheight from worktask_fielddict f left join worktask_taskfield t on f.id=t.fieldid where t.taskid="+wtid+" order by wttype asc, isshow desc, orderid asc";
    //System.out.println("worktasklistedit:"+sql);
	String useids = "";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		idList.add(Util.null2String(RecordSet.getString("id")));
		fieldnameList.add(Util.null2String(RecordSet.getString("fieldname")));
		descriptionList.add(Util.null2String(RecordSet.getString("description")));
		fielddbtypeList.add(Util.null2String(RecordSet.getString("fielddbtype")));
		fieldhtmltypeList.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
		typeList.add(Util.null2String(RecordSet.getString("type")));
		issystemList.add(Util.null2String(RecordSet.getString("issystem")));
		crmnameList.add(Util.null2String(RecordSet.getString("crmname")));
		isshowList.add(Util.null2String(RecordSet.getString("isshow")));
		iseditList.add(Util.null2String(RecordSet.getString("isedit")));
		ismandList.add(Util.null2String(RecordSet.getString("ismand")));
		wttypeList.add(Util.null2String(RecordSet.getString("wttype")));
		orderidList.add(Util.null2String(RecordSet.getString("orderid")));
		defaultvalueList.add(Util.null2String(RecordSet.getString("defaultvalue")));
		defaultvaluecnList.add(Util.null2String(RecordSet.getString("defaultvaluecn")));
		textheightList.add(Util.null2String(RecordSet.getString("textheight")));
	}
	
	
	//根据浏览框id值获取具体的名称
	GetShowCondition broconditions=new GetShowCondition();
	 //多选按钮id
    String browsermoreids=",17,18,37,257,57,65,194,240,135,152,162,166,168,170";

%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="formField" method="post" action="worktaskFieldOperation.jsp">
	<input type="hidden" name="mothed" value="">
	<input type="hidden" name="wtid" value="<%=wtid%>">
	<input type="hidden" name="wttype_delete" value="" >
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(wtid == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21930, user.getLanguage())+",javascript:newworktask(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;

%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="saveData()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(21930,user.getLanguage()) %>" class="e8_btn_top middle" onclick="newworktask()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>" class="e8_btn_top middle" onclick="useSetto()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<%
			//for(int r=1; r<=3; r++){//不展示任务反馈字段  和 任务验证字段
			String showOtherCol = Util.null2String(new BaseBean().getPropValue("worktask","showOtherCol"));
			int r_tmp = 1;
			if(showOtherCol.equals("1")){
				r_tmp = 3;
			}
			for(int r=1; r<=r_tmp; r++){
				String title_tmp = "";
				if(r == 1){
					title_tmp = SystemEnv.getHtmlLabelName(21932,user.getLanguage());
				}else if(r == 2){
					title_tmp = SystemEnv.getHtmlLabelName(21935,user.getLanguage());
				}else{
					title_tmp = SystemEnv.getHtmlLabelName(21936,user.getLanguage());
				}
		%>
			<wea:layout type="2col">
			  <wea:group context='<%=title_tmp%>' >
			    <wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<TABLE width="200px" style="margin-top: -34px;margin-right: 26px;float: right;">
	            				<TR>
	            					<TD align=right>
	            						<BUTTON class="addbtn" type=button accessKey=A  onclick="addrow('<%=r%>')" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
	            						<BUTTON class="delbtn" type=button accessKey=E onclick="delrow('<%=r%>')" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
	            					</TD>
	            				</TR>
	          		</TABLE>
				<table class="ListStyle" id="table<%=r%>" style="margin-bottom: 30px !important;" >
					<COLGROUP>
					<!--xwj for td3344 20051208 begin-->
				<COL width="5%">
				<COL width="12%">
				<COL width="12%">
				<COL width="12%">
				<COL width="9%">
				<COL width="9%">
				<COL width="9%">
				<COL width="8%">
				<COL width="12%">
				<COL width="12%">
					<!--xwj for td3344 20051208 end-->
				<tr class="header">
					<td></td>
					<td><%=SystemEnv.getHtmlLabelName(21933,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(21938,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
					  <%
						int htmltype=0;
						int linecolor=0;
						int fieldtype=0;
						for(int i=0; i<idList.size(); i++){
							String wttype = (String)wttypeList.get(i);
							if(!(""+r).equals(wttype)){
								continue;
							}
							
							String fieldhtmltype = (String)fieldhtmltypeList.get(i);
							if(fieldhtmltype.equals("1")){
								htmltype=688;
							}else if(fieldhtmltype.equals("2")){
								htmltype=689;
							}else if(fieldhtmltype.equals("3")){
								htmltype=695;
							}else if(fieldhtmltype.equals("4")){
								htmltype=691;
							}else if(fieldhtmltype.equals("5")){
								htmltype=690;
							}else if(fieldhtmltype.equals("6")){
								htmltype=17616;
							}else if(fieldhtmltype.equals("7")){
								htmltype=21691;
							}
							fieldtype = Util.getIntValue((String)typeList.get(i), 0);
	
							String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
	
							String issystem = (String)issystemList.get(i);
							String id = (String)idList.get(i);
							String crmname = Util.null2String((String)crmnameList.get(i));
							String isshow = Util.null2String((String)isshowList.get(i));
							String isedit = Util.null2String((String)iseditList.get(i));
							String ismand = Util.null2String((String)ismandList.get(i));
							int orderid = Util.getIntValue((String)orderidList.get(i), 0);
							String defaultvalue = Util.null2String((String)defaultvalueList.get(i));
							String defaultvaluecn = Util.null2String((String)defaultvaluecnList.get(i));
							int textheight = Util.getIntValue((String)textheightList.get(i));
	                        String fielddbtypee = Util.null2String((String)fielddbtypeList.get(i));
	                        
	                        //判断 浏览框 是否 多选
	                        String isSingle = browsermoreids.indexOf(fieldtype+"")>0?"false":"true";
	                        
	                      //不展示系统的
							if("1".equals(issystem)){
								continue;
							}
	                        
					  %>
					<tr class="DataDark" >
						<td>
							<input type="hidden"  name="fieldid" value="<%=id%>" >
						<%if(!"1".equals(issystem)){%>
							<input type="checkbox"  name="delete_field_id<%=r%>" value="<%=id%>" >
						<%} else {%>
						Sys
						<%}%>
						</td>
						<td>
						<%
						if("1".equals(issystem)){
							out.print(Util.null2String((String)fieldnameList.get(i)));
						}else{
						%>
							<a href="#" onclick="fieldedit('/worktask/base/fieldAdd.jsp?wttype=<%=wttype %>&src=editfield&fieldid=<%=id %>&isused=true')"><%=Util.null2String((String)fieldnameList.get(i))%></a>
						<% 
						  }
						%>
						</td>
						<td><%=Util.toScreen((String)descriptionList.get(i), user.getLanguage())%></td>
						<td><input class=Inputstyle type="text" name="crmname_<%=id%>" size="20" maxlength="10" value="<%=crmname%>"></td>
						<td><input type="checkbox"  name="isshow_<%=id%>" value="1" onClick="changeShow(this)" <%if("1".equals(isshow)){%>checked<%}%>></td>
						<% if(fieldhtmltype.equals("4")) {%>
						    <td><input type="checkbox"  name="isedit_<%=id%>" value="1" onClick="changeEdit(this)"  disabled></td>
						<% }else {%>
						    <td><input type="checkbox"  name="isedit_<%=id%>" value="1" onClick="changeEdit(this)" <%if("1".equals(isedit)){%>checked<%}%>></td>
						<% } %>
						<td><input type="checkbox"  name="ismand_<%=id%>" value="1" onClick="changeMand(this)" <%if("1".equals(ismand)){%>checked<%}%>></td>
						<td><input class=Inputstyle type="text" name="orderid_<%=id%>" size="4" maxlength="2" onchange="checkint('orderid_<%=id%>')" value="<%=orderid%>"></td>
						<td><%=SystemEnv.getHtmlLabelName(htmltype,user.getLanguage())%></td>
						<td>
							<%
								if((fieldhtmltype.equals("1")&&fieldtype==1) || fieldhtmltype.equals("2")){
							%>
							<input class=Inputstyle type="text" name="defaultvalue_<%=id%>" size="15" maxlength="<%=fieldhtmltype.equals("2")?20:textheight/2-1%>" value="<%=defaultvalue%>">
							<%}else if(fieldhtmltype.equals("1")&&fieldtype==2){%>
							<input class=Inputstyle type="text" name="defaultvalue_<%=id%>" size="15" maxlength="10" onchange="checkint('defaultvalue_<%=id%>')" value="<%=defaultvalue%>">
							<%}else if(fieldhtmltype.equals("1")&&fieldtype==3){%>
							<input class=Inputstyle type="text" name="defaultvalue_<%=id%>" size="15" maxlength="10" onKeyPress="ItemDecimal_KeyPress()" value="<%=defaultvalue%>">
							<%}else if(fieldhtmltype.equals("4")){%>
							<input type="checkbox"  name="defaultvalue_<%=id%>" value="1" <%if("1".equals(defaultvalue)){%>checked<%}%>>
							<%}else if(fieldhtmltype.equals("3")){
								String url=BrowserComInfo.getBrowserurl(""+fieldtype);     // 浏览按钮弹出页面的url
								String linkurl=BrowserComInfo.getLinkurl(""+fieldtype);    // 浏览值点击的时候链接的url
								%>
								<%if(fieldtype==2 || fieldtype==19){%>
									<input type="hidden" name="defaultvalue_<%=id%>" value="<%=defaultvalue%>" >
									<button class=Calendar type="button"   
									<%if(fieldtype==2){%>
									 onclick="onSearchWFDate(defaultvaluespan_<%=id%>, defaultvalue_<%=id%>)"
									<%}else{%>
									 onclick ="onSearchWFTime(defaultvaluespan_<%=id%>, defaultvalue_<%=id%>)"
									<%}%>
									 ></button>
									 <span name="defaultvaluespan_<%=id%>" id="defaultvaluespan_<%=id%>"><%=defaultvalue%></span>
								<%}else if("liableperson".equalsIgnoreCase(fieldname_tmp)){
									out.println(SystemEnv.getHtmlLabelName(21691, user.getLanguage()));
									out.print("<input type=\"hidden\" id=\"defaultvalue_"+id+"\" name=\"defaultvalue_"+id+"\" value=\"\" >");
									out.print("<input type=\"hidden\" id=\"defaultvaluecn_"+id+"\" name=\"defaultvaluecn_"+id+"\" value=\"\" />");
								}else if(fieldtype==161 || fieldtype==162){%>
			                        <brow:browser viewType="0" name='<%="defaultvalue_"+id%>'
										browserUrl='<%=url+"?type="+fielddbtypee%>'
										hasInput="false" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
										completeUrl='<%="/data.jsp?type="+fieldtype %>'   browserValue='<%=defaultvalue%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", defaultvalue, "1",fielddbtypee) %>' width="80%">
							       </brow:browser> 	
	                        <%}
	
	                            else{%>
								 <brow:browser viewType="0" name='<%="defaultvalue_"+id%>'
								browserUrl='<%=url+"?selectedids=&resourceids="%>'
								hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
								completeUrl='<%="/data.jsp?type="+fieldtype %>' browserValue='<%=defaultvalue%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", defaultvalue, "1") %>'   width="80%">
					      			 </brow:browser> 	
								<%}%>
							<%}else if(fieldhtmltype.equals("5")){%>
								<select class=inputstyle name="defaultvalue_<%=id%>" id="defaultvalueselect_<%=id%>" >
									<option value=""></option>
								<%
									RecordSet.execute("select * from worktask_selectItem where fieldid="+id+" order by orderid");
									while(RecordSet.next()){
										String selectvalue = Util.null2String(RecordSet.getString("selectvalue"));
										String selectname = Util.null2String(RecordSet.getString("selectname"));
								%>
										<option value="<%=selectvalue%>" <%if(defaultvalue.equals(selectvalue)){%>selected<%}%>><%=selectname%></option>
									<%}
								}%>
							</td>
						</tr>
					<%
						if(linecolor==0) linecolor=1;
							else linecolor=0;
						}
					  %>
				  </table>
			   </wea:item>
	     	</wea:group>
	     </wea:layout>
		<%}%>


</form>
<script language="javascript">
function saveData(){
	formField.mothed.value="save";
	formField.submit();
}
function newworktask(){
	parent.location.href = "worktaskAdd.jsp?isnew=1";
}
function showLog(){


}
function changeShow(obj){
	if(obj.checked == false){
	    //var ss = jQuery(jQuery(obj).parents("tr:first").children()[5]).find('input[type=checkbox]');
	    //ss.attr("checked",false);
	    //console.log(ss.attr("checked"));
	    //alert(jQuery(jQuery(obj).parents("tr:first").children()[5]).find('input[type=checkbox]').name);
		//jQuery(jQuery(obj).parents("tr:first").children()[5]).children()[0].checked=false;
		//jQuery(jQuery(obj).parents("tr:first").children()[6]).children()[0].checked=false;
		changeCheckboxStatus(jQuery(jQuery(obj).parents("tr:first").children()[5]).find('input[type=checkbox]'),false);
		changeCheckboxStatus(jQuery(jQuery(obj).parents("tr:first").children()[6]).find('input[type=checkbox]'),false);
	}
}
function changeEdit(obj){
	if(obj.checked == false){
		//obj.parentElement.parentElement.children(6).children(0).checked = false;
		//jQuery(jQuery(obj).parents("tr:first").children()[6]).children()[0].checked=false;
		changeCheckboxStatus(jQuery(jQuery(obj).parents("tr:first").children()[6]).find('input[type=checkbox]'),false);
	}else{
		//obj.parentElement.parentElement.children(4).children(0).checked = true;
		//jQuery(jQuery(obj).parents("tr:first").children()[4]).children()[0].checked=true;
		changeCheckboxStatus(jQuery(jQuery(obj).parents("tr:first").children()[4]).find('input[type=checkbox]'),true);
	}
}
function changeMand(obj){
	if(obj.checked == true){
		//obj.parentElement.parentElement.children(4).children(0).checked = true;
		//obj.parentElement.parentElement.children(5).children(0).checked = true;
		//jQuery(jQuery(obj).parents("tr:first").children()[4]).children()[0].checked=true;
		//jQuery(jQuery(obj).parents("tr:first").children()[5]).children()[0].checked=true;
		changeCheckboxStatus(jQuery(jQuery(obj).parents("tr:first").children()[4]).find('input[type=checkbox]'),true);
		changeCheckboxStatus(jQuery(jQuery(obj).parents("tr:first").children()[5]).find('input[type=checkbox]'),true);
	}
}

var dialog = null;

function addrow(wttype){
		
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>";
    dialog.URL = "/worktask/base/fieldAdd.jsp?wtid=<%=wtid%>&wttype="+wttype;
	dialog.Width = 660;
	dialog.Height = 460;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
	
}

function fieldedit(url){
		
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>";
    dialog.URL = url;
	dialog.Width = 660;
	dialog.Height = 460;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
	
}


function MainCallback(){
	dialog.close();
	window.location.reload();
}


function delrow(wttype){
    //判断有没有 选中需要删除的记录
    var delids = "";
    $("input[name='delete_field_id"+wttype+"']:checked").each(function(){
       delids += $(this).val()+",";
    });
	
	if(delids.length==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
	 }else{		 
		 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
	       	formField.wttype_delete.value = wttype;
			formField.mothed.value="delete";
			formField.submit();
	   });
	 }
}
function ItemCount_KeyPress_self(event){
    event = event || window.event
	if(!((event.keyCode>=48) && (event.keyCode<=57))){
		event.keyCode=0;
	}
}
function useSetto(){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>";
    dialog.URL = "/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=0";
	dialog.Width = 660;
	dialog.Height = 660;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

function onShowBrowser2(id,url,linkurl,type1){
ismand = "0";
sHtml = "";
if (type1 == 2 || type1 == 19){
    spanname = "defaultvalue_span"+id;
    inputname = "defaultvalue_"+id;
	if (type1 == 2){
	  onFlownoShowDate(spanname,inputname,ismand);
	}else{
      onWorkFlowShowTime(spanname,inputname,ismand);
	}
	sHtml = jQuery("input[name=defaultvalue_"+id+"]").val();
}else{
	if(type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170){
		id1 = window.showModalDialog(url);
	}else{
        if (type1==135){
			tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?projectids="+tmpids);
        }else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids);
        }else if( type1==37){
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids);
        }else if( type1==142){
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
        }else if (type1==165 || type1==166 || type1==167 || type1==168){
        	index=id.indexof("_");
	        if (index>0){
		        tmpids=unescape("?isdetail=1+fieldid="+ id.substr(1,index-1) +"+resourceids="+jQuery("input[name=defaultvalue_"+id+"]").val());
		        id1 = window.showModalDialog(url+tmpids);
	        }else{
		        tmpids=unescape("?fieldid="+id+"+resourceids="+jQuery("input[name=defaultvalue_"+id+"]").val());
		        id1 = window.showModalDialog(url+tmpids);
	        }
        }else{
	        tmpids = jQuery("input[name=defaultvalue_"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
        }
	}
	if (id1!=null){
		if (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170){
			if (id1.id!= ""  && id1.id!= "0"){
				ids = id1.id.split(",");
				names =id1.name.split(",");
				resourceids = id1.id.substr(2,id1.id.length);
				resourcename = id1.name.substr(2,id1.name.length);
				for( var i=0;i<ids.length;i++){
					if(ids[i]!=""){
						sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_new'>"+names[i]+"</a>&nbsp;";
					}
				}
				jQuery("span[name=defaultvaluespan_"+id+"]").html(sHtml);
				jQuery("input[name=defaultvaluecn_"+id+"]").val(sHtml);
				jQuery("input[name=defaultvalue_"+id+"]").val(resourceids);
			}else{
				if (ismand==0){
					jQuery("span[name=defaultvaluespan_"+id+"]").html(empty);
					jQuery("input[name=defaultvaluecn_"+id+"]").val("");
				}else{
					jQuery("input[name=defaultvalue_"+id+"]").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				}
				jQuery("input[name=defaultvalue_"+id+"]").val("");
			}

		}else{
		   if  (id1.id!=""  && id1.id!= "0"){
               if (type1==162){
                   var str1 = id1.id;
                   var str2 = id1.name;
                   //var str3 = id1.other1;
                   ids = str1.split(",");
                   names = str2.split(",");
                   //descs = str3.split(",");
                   //ids = id1.id.substr(2,id1.id.length);
                   jQuery("input[name=defaultvalue_"+id+"]").val(ids);
                   // names = id1.name.substr(2,id1.name.length);
                   // descs = id1.other1.substr(2,id1.desc.length);
                   for( var i=0;i<ids.length;i++){
                       if(ids[i]!=""){
                           sHtml +=","+ names[i];
                       }
                   }
                   if(sHtml.length>0){
                       sHtml = sHtml.substring(1);
                   }
                   jQuery("span[name=defaultvaluespan_"+id+"]").html(sHtml);
                   jQuery("input[name=defaultvaluecn_"+id+"]").val(sHtml);
                   //exit sub
               }       else
               if (type1==161){
                   name = id1.name;
                   desc = id1.other1;
                   jQuery("input[name=defaultvalue_"+id+"]").val(id1.id);
                   sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp;";
                   jQuery("span[name=defaultvaluespan_"+id+"]").html(sHtml);
                   jQuery("input[name=defaultvaluecn_"+id+"]").val(sHtml);
                   //exit sub
               }   else{
                   if (linkurl == ""){
                       jQuery("span[name=defaultvaluespan_"+id+"]").html(id1.name);
                       jQuery("input[name=defaultvaluecn_"+id+"]").val(id1.name);
                   }else{
                       jQuery("span[name=defaultvaluespan_"+id+"]").html("<a href="+linkurl+id1.id+" target='_new'>"+id1.name+"</a>");
                       jQuery("input[name=defaultvaluecn_"+id+"]").val("<a href="+linkurl+id1.id+" target='_new'>"+id1.name+"</a>");
                   }
                   jQuery("input[name=defaultvalue_"+id+"]").val(id1.id);
               }

		   }else{
				if (ismand==0){
					jQuery("span[name=defaultvaluespan_"+id+"]").html(empty);
					jQuery("input[name=defaultvaluecn_"+id+"]").val("");
				}else{
					jQuery("span[name=defaultvaluespan_"+id+"]").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				}
				jQuery("input[name=defaultvalue_"+id+"]").val("");
		   }
		}
	}
}
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
