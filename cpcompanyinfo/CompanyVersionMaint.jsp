<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
User users=HrmUserVarify.getUser(request,response);
if(users==null){
	return;
}
	String licenseid = Util.null2String(request.getParameter("licenseid"));
	String constitutionid = Util.null2String(request.getParameter("constitutionid"));
	String shareid = Util.null2String(request.getParameter("shareid"));
	String directorsid =  Util.null2String(request.getParameter("directorsid"));
	String companyid =  Util.null2String(request.getParameter("companyid"));
	String versionids = Util.null2String(request.getParameter("versionids"));
	String oneMoudel = Util.null2String(request.getParameter("oneMoudel"));
	
//	System.out.println("licenseid======="+licenseid);
//	System.out.println("constitutionid======="+constitutionid);
//	System.out.println("shareid======="+shareid);
//	System.out.println("directorsid======="+directorsid);
//	System.out.println("companyid======="+companyid);
//	System.out.println("versionids======="+versionids);
//	System.out.println("oneMoudel======="+oneMoudel);
	
	
	
	String sql = "";
	String versionnum05 = "";
	String versionname05 = "";
	String date2Version05 = "";
	String versionTime05 = "";
	String versionmemo05 = "";
	String _versionid = "";
	boolean flag=true;
	if(!versionids.equals("")){
		_versionid = versionids.substring(0,versionids.lastIndexOf(','));
		if(oneMoudel.equals("license")){
			sql = "select * from CPBUSINESSLICENSEVERSION where versionid = "+_versionid;
		}
		if(oneMoudel.equals("constitution")){
			sql = "select * from CPCONSTITUTIONVERSION where versionid = "+_versionid;
		}
		if(oneMoudel.equals("share")){
			sql = "select * from CPSHAREHOLDERVERSION where versionid = "+_versionid;
		}
		if(oneMoudel.equals("director")){
			
			sql = "select * from CPBOARDVERSION where versionid = "+_versionid;
		}
		//System.out.println(sql);
		rs.execute(sql);
		//System.out.println("查出版本数据"+sql);
		if(rs.next()){
			flag=false;
			versionnum05 = rs.getString("versionnum");
			versionname05 = rs.getString("versionname");
			date2Version05 = rs.getString("createdatetime");
			versionTime05 = rs.getString("createdatetime");
			versionmemo05 = rs.getString("versionmemo");
		}
	}
%>
<link rel="stylesheet" type="text/css" href="/cpcompanyinfo/style/wbox_wev8.css" />
<script type="text/javascript">
	jQuery(document).ready(function(){
		
		if("<%=versionids%>" !=""){
			jQuery("#versionSaveBtn05").bind("click",function(){
					if(jQuery.trim(jQuery("#versionnum").val())=="" || jQuery.trim(jQuery("#versionname").val())=="" || jQuery("#versionTime").val()==""){
						alert("<%=SystemEnv.getHtmlLabelName(31122,user.getLanguage()) %>!");
					}else{
						
						//alert("编辑版本"+jQuery("#versionnum").val());
						editversionDate("<%=_versionid%>","<%=oneMoudel%>");
					
					}
			});
		}else{
			jQuery("#versionSaveBtn05").bind("click",function(){
				
				if(jQuery.trim(jQuery("#versionnum").val())=="" || jQuery.trim(jQuery("#versionname").val())=="" || jQuery("#versionTime").val()==""){
					alert("<%=SystemEnv.getHtmlLabelName(31122,user.getLanguage()) %>!");
				}else{
					saveversionDate();
				}
			});
		}
	});
	
	function AjaxCheckVersionnum(obj){
		//defaultValue 
		if(obj.defaultValue!=obj.value&&obj.value!=""){
			var o4params = {
				oneMoudel:"<%=oneMoudel%>",
				licenseid:"<%=licenseid%>",
				companyid:"<%=companyid%>",
				objvalue:obj.value+""
			}
			jQuery("#ck_red").html("<%=SystemEnv.getHtmlLabelName(31123,user.getLanguage()) %>.........").css("color","red");
			jQuery("#versionSaveBtn05").hide();
			jQuery.post("/cpcompanyinfo/AjaxCheckVersionnum.jsp",o4params,function(data){
					if(data==1){
							jQuery(obj).attr("value","").focus();
							jQuery(obj).next().show();
							jQuery("#ck_red").html("<%=SystemEnv.getHtmlLabelName(31124,user.getLanguage()) %>").css("color","red");
					}else{
							jQuery("#ck_red").html("<%=SystemEnv.getHtmlLabelName(31125,user.getLanguage()) %>").css("color","blue");
							jQuery("#versionSaveBtn05").show();
					}
			});
		}else if(obj.defaultValue==obj.value&&obj.value!=""){
				jQuery("#ck_red").html("<%=SystemEnv.getHtmlLabelName(31125,user.getLanguage()) %>").css("color","blue");
		}else if(obj.value==""){
				jQuery("#ck_red").html("");
		}
	}	
</script>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>' attributes="{'groupDisplay':''}">
		<wea:item attributes="{'isTableList':'true'}">
		

<table width="100%" border="0" align="" cellpadding="0"  cellspacing="0" class="ListStyle" >
			<tr class="DataLight">
				<td >
					<%=SystemEnv.getHtmlLabelName(22186,user.getLanguage()) %></td>
				<td colspan="3">
						<input type=text   name="versionnum"   maxlength="8"  onblur="checkFloat(this);displayimg(this),AjaxCheckVersionnum(this)" id="versionnum" value="<%=versionnum05 %>" 
						onkeypress="ItemDecimal_KeyPress('versionnum',9,6)">
						<%if(flag){%><img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;" iswarn="warning"/><%	}else{
						%>
							<img src="images/O_44_wev8.jpg" class="ML5" style="display:none" iswarn="warning"/>
						<%
						}%>
						<span  id="ck_red">
						
						</span>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="4"><div class="intervalDivClass"></div></td></tr>
			<tr class="DataLight">
				<td>
					<%=SystemEnv.getHtmlLabelName(31126,user.getLanguage()) %>
				</td>
				<td colspan="3">
					<input type="text" name="versionname" id="versionname" value= "<%=versionname05 %>"
						class="OInput2 BoxW208" onblur="displayimg(this)" />
							<%if(flag){%><img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;" iswarn="warning"/><%	}else{
						%>
							<img src="images/O_44_wev8.jpg" class="ML5" style="display:none" iswarn="warning"/>
						<%
						}%>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="4"><div class="intervalDivClass"></div></td></tr>
			<tr class="DataLight">
				<td>
					<%=SystemEnv.getHtmlLabelName(31127,user.getLanguage()) %>
				</td>
				<td colspan="3">
				
				<BUTTON  class=calendar  type="button"    onclick="onShowDate(document.getElementById('date2Version'),document.getElementById('versionTime'))"></BUTTON>
					<input type="hidden" id="versionTime" name="versionTime"  value="<%=date2Version05%>"/>
					<span id="date2Version">
					<%if(flag){%><img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;" iswarn="warning"/><%	}else{out.println(date2Version05);}%>
					</span>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="4"><div class="intervalDivClass"></div></td></tr>
			<tr class="DataLight">
				<td height="40">
					<%=SystemEnv.getHtmlLabelName(31128,user.getLanguage()) %>
				</td>
				<td colspan="3">
					<textarea name="versionmemo"
						class="OInput2 BoxWAuto BoxHeight60" id="versionmemo" rows="3"><%=versionmemo05 %></textarea>
				</td>
			</tr>
			<tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="4"><div class="intervalDivClass"></div></td></tr>
			<tr class="DataLight">
				<td colspan="4"  align="center"  valign="center">  
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 <span style="width:50px!important;"></span>
					 <input type="button" id="versionSaveBtn05" class="BtnLM e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" />
					 &nbsp;&nbsp;&nbsp;&nbsp;
					 <input type="button" name="ccbtn" class="BtnLM e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage()) %>"  onclick="onLicenseDivClose()" />
				</td>
			</tr>
	  </table>
		
		</wea:item>
	</wea:group>	
</wea:layout>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
