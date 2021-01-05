<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.conn.RecordSet"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	int layoutid = Util.getIntValue(request.getParameter("layoutid"));
	int d_identy = Util.getIntValue(Util.null2String(request.getParameter("d_identy")));
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	int languageid = Util.getIntValue(request.getParameter("languageid"),7);
	String detaillimit = Util.null2String(request.getParameter("detaillimit"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	String detailname="明细表"+d_identy;
	
	String dtladd = "1".equals(detaillimit.substring(0,1))?" checked":"";
	String dtledit = "1".equals(detaillimit.substring(1,2))?" checked":"";
	String dtldel = "1".equals(detaillimit.substring(2,3))?" checked":"";
	String dtlcopy = "1".equals(detaillimit.substring(3,4))?" checked":"";
	String dtlhide = "1".equals(detaillimit.substring(4,5))?" checked":"";
	String dtldef = "1".equals(detaillimit.substring(5,6))?" checked":"";
	String dtlned = "1".equals(detaillimit.substring(6,7))?" checked":"";
	String dtlprintserial = "1".equals(detaillimit.substring(7,8))?" checked":"";
	String dtlallowscroll = "1".equals(detaillimit.substring(8,9))?" checked":"";
	String dtlmul = "1".equals(detaillimit.substring(9,10))?" checked":"";
	
	String isdisabled = (layouttype==0 || layouttype==3) ? "disabled":"";
	if(!dtladd.equals(" checked") && !dtledit.equals(" checked"))
		isdisabled = "disabled";
	else
		isdisabled = "";
				
	int dtl_defrow=0;
	if(detaillimit.indexOf("*")>-1){
		String _temp=detaillimit.substring(detaillimit.indexOf("*")+1);
		dtl_defrow = Util.getIntValue(_temp,0);
	}
	if(dtl_defrow<1)	dtl_defrow=1;
%>
<HTML>
<HEAD>
<TITLE></TITLE>
<script type="text/javascript">
var parentWin_Main = parent.getParentWindow(window);		//全局变量-明细表获取主表window
jQuery(document).ready(function(){
	$(".tableBody").css("height",($(window).height()-485)+"px");
	loadDetailTable("<%=d_identy %>");
	
	var t=setTimeout(bindgound,100);
	function bindgound(){
		clearTimeout(t);
		$("div[name=somethingdiv]").find("tr.groupHeadHide").find(".hideBlockDiv").click(function(e){
			var ishow = $(this).attr("_status");
			if(ishow==="0"){
				$(".tableBody").css("height",($(".tableBody").height()-252)+"px");
			}else{
				$(".tableBody").css("height",($(".tableBody").height()+252)+"px");
			}
		});
		<%if(layouttype==0 || layouttype==2){%>
			$("div[name=sortfielddiv]").find("tr.groupHeadHide").find(".hideBlockDiv").click(function(e){
				var ishow = $(this).attr("_status");
				if(ishow==="0"){
					$(".tableBody").css("height",($(".tableBody").height()-130)+"px");
				}else{
					$(".tableBody").css("height",($(".tableBody").height()+130)+"px");
				}
			});
		<%}%>
	}
});

</script>
</HEAD>
<BODY style="margin:0px; padding:0px;">
<form id="LayoutForm" name="LayoutForm" style="height:100%;" action="excel_operation.jsp" target="_self" method="post" enctype="multipart/form-data">
	<input type="hidden" id="formid" name="formid" value="<%=formid%>" />
	<div class="filedTab">
		<div class="tableSearch" style="padding:5px;">
			<span class="searchInputSpan">
				<input type="text" class="searchInput" name="searchVal" onkeypress="if(event.keyCode==13) {searchDetailTable('<%=d_identy %>');return false;}"/></input>
				<span>
					<img src="/images/ecology8/request/search-input_wev8.png" onclick="searchDetailTable('<%=d_identy %>')"></img>
				</span>
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
						<td class="rightBorder">标签</td>
						<td>字段</td>
					</tr>
				</tbody>
			</table>
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
		<wea:layout type="twoCol" attributes="{'cw1':'60%','cw2':'40%'}">
			<wea:group context='<%=detailname %>' >
				<%if(layouttype==0 || layouttype==2){%>
				<wea:item>
				<%
					int dindex = d_identy-1;
					RecordSet rs = new RecordSet();
					rs.executeSql("select * from mode_layout_querySql where layoutid ='"+layoutid+"' and detailtype='"+dindex+"'");
					boolean ishavequery = false;
					String layoutQueryId = "";
					if(rs.next()){
						layoutQueryId = Util.null2String(rs.getString("id"));
						String querytype = Util.null2String(rs.getString("querytype"));
						String sqlconetent = Util.null2String(rs.getString("sqlconetent"));
						String javafilename = Util.null2String(rs.getString("javafilename"));
						String javafileAddress = Util.null2String(rs.getString("javafileAddress"));
						if("1".equals(querytype)&&!"".equals(sqlconetent)){
							ishavequery = true;
						}else if("2".equals(querytype)&&!"".equals(javafilename)){
							ishavequery = true;
						}else if("2".equals(querytype)&&!"".equals(javafileAddress)){
                            ishavequery = true;
                        }
						
					}
					if(ishavequery){
						%>
						<div id="query<%=dindex%>" name="query<%=dindex%>" class="querydiv">
							<a href="javascript:openQuerySet('/formmode/setup/LayoutDtlQuerySet.jsp?layoutid=<%=layoutid%>&type=<%=dindex%>&id=<%=layoutQueryId %>')"  style="color:blue;"><%=SystemEnv.getHtmlLabelName(82171,user.getLanguage())%><!-- 查询条件(已设置) --></a>
						</div>
						<%
					}else{
						%>
						<div id="query<%=dindex%>" name="query<%=dindex%>" class="querydiv">
							<a href="javascript:openQuerySet('/formmode/setup/LayoutDtlQuerySet.jsp?layoutid=<%=layoutid%>&type=<%=dindex%>')"  style="color:blue;"><%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%><!-- 查询条件 --></a>
						</div>
						<%
					}
				%>
				</wea:item>
				<wea:item ></wea:item>
				<%} %>
				<wea:item ><%=SystemEnv.getHtmlLabelName(19394,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtladd" name="dtladd" <%if(layouttype==0 || layouttype==3 || layouttype==4){%>disabled<%}else{%><%=dtladd%> <%}%> onchange="onNotEdit(this)" onclick="checkChange()"/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19395,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtledit" name="dtledit" <%if(layouttype==0 || layouttype==3 || layouttype==4){%>disabled<%}else{%><%=dtledit%> <%}%> onchange="onNotEdit(this)" />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19396,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtldel" name="dtldel" <%if(layouttype==0 || layouttype==3 || layouttype==4){%>disabled<%}else{%><%=dtldel%> <%}%> />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(82661,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtlcopy" name="dtlcopy" <%if(layouttype==0 || layouttype==3 || layouttype==4){%>disabled<%}else{%><%=dtlcopy%> <%}%> />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(24801,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtlned" name="dtlned" <%if(layouttype==0 || layouttype==3 || layouttype==4){%>disabled<%}else{%> <%=dtlned%><%}%> <%=isdisabled %> />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(24796,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtldef" name="dtldef" <%if(layouttype==0 || layouttype==3 || layouttype==4){%>disabled<%}else{%> <%=dtldef%><%}%> <%=isdisabled %> />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(31592,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtlmul" name="dtlmul" <%if(layouttype==0 || layouttype==3 || layouttype==4||!dtladd.equals(" checked")){%>disabled<%}else{%> <%=dtlmul %><%}%> <%=isdisabled %> />
				</wea:item>
				<%if(layouttype==4){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22363,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtlhide" name="dtlhide" <%=dtlhide %> />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(81857,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtlprintserial" name="dtlprintserial" <%=dtlprintserial %> />
				</wea:item>
				<%} %>
				<wea:item><%=SystemEnv.getHtmlLabelName(83507,languageid)%></wea:item>
				<wea:item>
					<input type="checkbox" id="dtlallowscroll" name="dtlallowscroll" <%=dtlallowscroll %> />
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<%if(layouttype==0 || layouttype==2){%>
	<div name="sortfielddiv" style="position:relative;">
		<wea:layout type="twoCol" attributes="{'cw1':'45%','cw2':'55%'}">
			<wea:group context="字段排序" attributes="{itemAreaDisplay:none}">
				<wea:item><%=SystemEnv.getHtmlLabelName(18558,user.getLanguage())%><!-- 是否排序 --></wea:item>
				<wea:item>
					<input type="checkbox" id="issort" onclick="issortClickFun()" notBeauty=true/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(17736, user.getLanguage()) %></wea:item>
				<wea:item>
					<select id="ordertype" name="ordertype" onchange="issortClickFun()" style="width:80px;"  notBeauty=true>
						<option value="asc"><%=SystemEnv.getHtmlLabelName(339, user.getLanguage()) %></option>
						<option value="desc"><%=SystemEnv.getHtmlLabelName(340, user.getLanguage()) %></option>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(22413, user.getLanguage()) %></wea:item>
				<wea:item>
					<input id="ordernum" name="ordernum" style="width:80px;" onchange="issortClickFun()" />
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<%}%>
	<div class="moduleBottom"></div>
</form>
</BODY>
</HTML>
