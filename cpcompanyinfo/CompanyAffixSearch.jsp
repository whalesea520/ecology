
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.docs.docs.DocComInfo"%>

<script>
var parentDialog = parent.parent.getDialog(parent);
//var parentWin = parent.parent.getParentWindow(parent.window);
var parentWin = parent.getParentWindow(window);
</script>

<%

	//很关键的一个变量，用于判断后续页面是否开发编辑权限
	//0--只有这个公司的查看权限，没有维护权限
	//1--拥有这个公司查看和维护全县
	//String showOrUpdate = Util.null2String(session.getAttribute("showOrUpdate")+"");
	//搜索策略是针对每一个用户而言的，所以在此屏蔽搜索策略的增、删、改没意义
	
	String method = Util.null2String(request.getParameter("method"));
	//System.out.println("method========="+method);
	String moudel = Util.null2String(request.getParameter("moudel"));
	//System.out.println("moudel========="+moudel);
	String btn =  Util.null2String(request.getParameter("btn"));
	//System.out.println("btn========="+btn);
	String companyid = Util.null2String(request.getParameter("companyid"));
	//System.out.println("companyid========="+companyid);
	String panelTitle="";
	String moudelName = "";
	if("add".equals(method)&&"search".equals(moudel)){
		panelTitle=""+SystemEnv.getHtmlLabelName(30961,user.getLanguage());
		moudelName=""+SystemEnv.getHtmlLabelName(30959,user.getLanguage())+" ";
	}
	if("edit".equals(method)&&"search".equals(moudel)){
		panelTitle=""+SystemEnv.getHtmlLabelName(30962,user.getLanguage());
		moudelName=""+SystemEnv.getHtmlLabelName(30959,user.getLanguage())+" ";
	}
	if("add".equals(method)&&"delivery".equals(moudel)){
		panelTitle=""+SystemEnv.getHtmlLabelName(30963,user.getLanguage());
		moudelName=""+SystemEnv.getHtmlLabelName(30960,user.getLanguage())+" ";
	}
	if("edit".equals(method)&&"delivery".equals(moudel)){
		panelTitle=""+SystemEnv.getHtmlLabelName(30960,user.getLanguage());
		moudelName=""+SystemEnv.getHtmlLabelName(30964,user.getLanguage())+" ";
	}
	
	String searchid = Util.null2String(request.getParameter("searchid"));
	//System.out.println("searchid========="+searchid);
	String filed0="";
	String filed1="";
	String filed2="";
	String filed3="";
	String filed4="";
	String filed5="";
	String filed6="";
	String filed7="";
	String filed8="";
	String filed9="";
	String ship0="";
	String ship1="";
	String ship2="";
	String ship3="";
	String ship4="";
	String ship5="";
	String ship6="";
	String ship7="";
	String ship8="";
	String searchname="";
	if("edit".equals(method)){
		String sql = " select * from CPCOMPANYAFFIXSEARCH where id="+searchid;
		rs.execute(sql);
		if(rs.next()){
			filed0 = Util.null2String(rs.getString("SEARCHFIELD0"));
			filed1 = Util.null2String(rs.getString("SEARCHFIELD1"));
			filed2 = Util.null2String(rs.getString("SEARCHFIELD2"));
			filed3 = Util.null2String(rs.getString("SEARCHFIELD3"));
			filed4 = Util.null2String(rs.getString("SEARCHFIELD4"));
			filed5 = Util.null2String(rs.getString("SEARCHFIELD5"));
			filed6 = Util.null2String(rs.getString("SEARCHFIELD6"));
			filed7 = Util.null2String(rs.getString("SEARCHFIELD7"));
			filed8 = Util.null2String(rs.getString("SEARCHFIELD8"));
			filed9 = Util.null2String(rs.getString("SEARCHFIELD9"));
			ship0 = Util.null2String(rs.getString("SEARCHSHIP0"));
			ship1 = Util.null2String(rs.getString("SEARCHSHIP1"));
			ship2 = Util.null2String(rs.getString("SEARCHSHIP2"));
			ship3 = Util.null2String(rs.getString("SEARCHSHIP3"));
			ship4 = Util.null2String(rs.getString("SEARCHSHIP4"));
			ship5 = Util.null2String(rs.getString("SEARCHSHIP5"));
			ship6 = Util.null2String(rs.getString("SEARCHSHIP6"));
			ship7 = Util.null2String(rs.getString("SEARCHSHIP7"));
			ship8 = Util.null2String(rs.getString("SEARCHSHIP8"));
			searchname = Util.null2String(rs.getString("searchname"));
		}
		//System.out.println(ship0+"   "+ship1+"   "+ship2);
	}
%>

<script type="text/javascript">
	jQuery(document).ready(function(){
		var have_value="";
		if("<%=method%>"=="edit"){
			jQuery("#field0").val("<%=filed0%>");
			if("<%=filed0%>"!=""){have_value=0;}
			jQuery("#field1").val("<%=filed1%>");
			if("<%=filed1%>"!=""){have_value=1;}
			jQuery("#field2").val("<%=filed2%>");
			if("<%=filed2%>"!=""){have_value=2;}
			jQuery("#field3").val("<%=filed3%>");
			if("<%=filed3%>"!=""){have_value=3;}
			jQuery("#field4").val("<%=filed4%>");
			if("<%=filed4%>"!=""){have_value=4;}
			jQuery("#field5").val("<%=filed5%>");
			if("<%=filed5%>"!=""){have_value=5;}
			jQuery("#field6").val("<%=filed6%>");
			if("<%=filed6%>"!=""){have_value=6;}
			jQuery("#field7").val("<%=filed7%>");
			if("<%=filed7%>"!=""){have_value=7;}
			jQuery("#field8").val("<%=filed8%>");
			if("<%=filed8%>"!=""){have_value=8;}
			jQuery("#field9").val("<%=filed9%>");
			if("<%=filed9%>"!=""){have_value=9;}
		
			jQuery("#andor").find("tr:eq(0)").find("td").find("a:eq(1)").text("<%=ship0%>");
			jQuery("#andor").find("tr:eq(1)").find("td").find("a:eq(1)").text("<%=ship1%>");
			jQuery("#andor").find("tr:eq(2)").find("td").find("a:eq(1)").text("<%=ship2%>");
			jQuery("#andor").find("tr:eq(3)").find("td").find("a:eq(1)").text("<%=ship3%>");
			jQuery("#andor").find("tr:eq(4)").find("td").find("a:eq(1)").text("<%=ship4%>");
			jQuery("#andor").find("tr:eq(5)").find("td").find("a:eq(1)").text("<%=ship5%>");
			jQuery("#andor").find("tr:eq(6)").find("td").find("a:eq(1)").text("<%=ship6%>");
			jQuery("#andor").find("tr:eq(7)").find("td").find("a:eq(1)").text("<%=ship7%>");
			jQuery("#andor").find("tr:eq(8)").find("td").find("a:eq(1)").text("<%=ship8%>");

			
			/**
			jQuery("#ship0").val("<%=ship0%>");
			jQuery("#ship1").val("<%=ship1%>");
			
			jQuery("#ship2").val("<%=ship2%>");
			jQuery("#ship3").val("<%=ship3%>");

			jQuery("#ship4").val("<%=ship4%>");
			jQuery("#ship5").val("<%=ship5%>");
			jQuery("#ship6").val("<%=ship6%>");
			jQuery("#ship7").val("<%=ship7%>");
			jQuery("#ship8").val("<%=ship8%>");
			**/
			if(have_value>0){
					for(var i=0;i<=have_value;i++){
						jQuery("#field"+i).removeClass("OInput3").addClass("OInput2").attr("disabled",false);
						if(i>=1){
							//jQuery("#ship"+(i-1)).attr("disabled","");
							jQuery("#ship"+(i-1)).selectbox("enable");
						}
					}
			}
			jQuery("#searchname").val("<%=searchname%>");
			jQuery("button[issave]").attr("issave","F");
			searchMethod("search");
		}
	});
	
	function checkMust(_save){
		var ischecked = false;
		if(_save=="search&save"){
			if(jQuery("#searchname").val()=="")alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
			else ischecked = true;
		}else{
			ischecked = true;
		}
		return ischecked;
	}
	
	function searchMethod(_save){
		if(checkMust(_save)){
		var searchcondition="?companyid=<%=companyid%>";
		searchcondition+="&field0="+jQuery("#field0").val();
		searchcondition+="&field1="+jQuery("#field1").val();
		searchcondition+="&field2="+jQuery("#field2").val();
		searchcondition+="&field3="+jQuery("#field3").val();
		searchcondition+="&field4="+jQuery("#field4").val();
		searchcondition+="&field5="+jQuery("#field5").val();
		searchcondition+="&field6="+jQuery("#field6").val();
		searchcondition+="&field7="+jQuery("#field7").val();
		searchcondition+="&field8="+jQuery("#field8").val();
		searchcondition+="&field9="+jQuery("#field9").val();
		searchcondition+="&ship0="+jQuery("#ship0").val();
		searchcondition+="&ship1="+jQuery("#ship1").val();
		searchcondition+="&ship2="+jQuery("#ship2").val();
		searchcondition+="&ship3="+jQuery("#ship3").val();
		searchcondition+="&ship4="+jQuery("#ship4").val();
		searchcondition+="&ship5="+jQuery("#ship5").val();
		searchcondition+="&ship6="+jQuery("#ship6").val();
		searchcondition+="&ship7="+jQuery("#ship7").val();
		searchcondition+="&ship8="+jQuery("#ship8").val();
		var _searchid="<%=searchid%>";
		/* if(jQuery("button[issave]").attr("issave")=="F"){
			_searchid=$("#searchid").val();
		} */
		var o4params = {
			method:_save,
			isadd:jQuery("button[issave]").attr("issave"),
			companyid:"<%=companyid%>",
			searchname:encodeURI(jQuery("#searchname").val()),
			moudel:"<%=moudel%>",
			searchid:_searchid,
			field0:encodeURI(jQuery("#field0").val()),
			field1:encodeURI(jQuery("#field1").val()),
			field2:encodeURI(jQuery("#field2").val()),
			field3:encodeURI(jQuery("#field3").val()),
			field4:encodeURI(jQuery("#field4").val()),
			field5:encodeURI(jQuery("#field5").val()),
			field6:encodeURI(jQuery("#field6").val()),
			field7:encodeURI(jQuery("#field7").val()),
			field8:encodeURI(jQuery("#field8").val()),
			field9:encodeURI(jQuery("#field9").val()),
			ship0:encodeURI(jQuery("#ship0").val()),
			ship1:encodeURI(jQuery("#ship1").val()),
			ship2:encodeURI(jQuery("#ship2").val()),
			ship3:encodeURI(jQuery("#ship3").val()),
			ship4:encodeURI(jQuery("#ship4").val()),
			ship5:encodeURI(jQuery("#ship5").val()),
			ship6:encodeURI(jQuery("#ship6").val()),
			ship7:encodeURI(jQuery("#ship7").val()),
			ship8:encodeURI(jQuery("#ship8").val())
		};

		jQuery.post("/cpcompanyinfo/action/CPManageOperate.jsp",o4params,function(data){
			jQuery("#frame2affixlist")[0].src="CompanyAffixList.jsp"+searchcondition;
			//jQuery("#frame2affixlist").attr("src","CompanyAffixList.jsp"+searchcondition);
			if(_save=="search&save"){
				//jQuery("button[issave]").attr("issave","F");
				//alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
				//jQuery("#searchid").val(data);
				parentWin.reflush2List();
				parentDialog.close();
				//window.parent.parent.location.reload();
			}
		});
		}
	}
	/*更改input text 状态*/
	function changBoxStatus(i,j){
		if(jQuery("#field"+i).val()!="" && jQuery("#ship"+i).attr("disabled")){
			jQuery("#field"+j).removeClass("OInput3").addClass("OInput2").attr("disabled",false);
			//jQuery("#ship"+i).attr("disabled",false);
			jQuery("#ship"+i).selectbox("enable");
		}
	}
	
	
</script>

<jsp:include page="/systeminfo/commonTabHead.jsp">
<jsp:param name="mouldID" value="cpcompany"/>
<jsp:param name="navName" value="<%=panelTitle %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<!--<input type="text" class="" id="searchname"  maxlength="20" onblur="displayimg(this)" /> -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("527",user.getLanguage())%>" class="e8_btn_top" onclick="searchMethod('search');"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top" onclick="searchMethod('search&save');"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("15504",user.getLanguage())%>" class="e8_btn_top" onclick="cleanMes();"/>
		</td>
	</tr>
</table>
				
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true'}">
			<table  border="0" align="center" cellpadding="0" cellspacing="0" class="ListStyle">
				<tr>
					<td colspan="2">
						<span><%=moudelName %></span>
							<input type="text" id="searchname" tabindex="0" style="width:324px"  maxlength="20"  onblur="displayimg(this)"/><img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;<%if("edit".equals(method)){out.println("display:none");} %>"  />
					<!-- 	<button class="BtnLM" type="button" style="margin-left:15px;padding-top: -5px" onclick="searchMethod('search')">  <%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%></button>
					<button class="BtnLM" type="button" onclick="searchMethod('search&save')" issave="T">  <%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
					--></td>
				</tr> 
			</table>
		 </wea:item>
		</wea:group>	
	  </wea:layout> 
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("2095",user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table border="0" align="center" cellpadding="0" id="andor" cellspacing="0" class="ListStyle">
				<tr>
					<td>
						<%=SystemEnv.getHtmlLabelName(30965,user.getLanguage())%> <input type="text" style="width:218px" id="field0"  tabindex="1"  onblur="changBoxStatus(0,1,this);"/>
						<select class="OSelect MT3 MLeft8" style="width:70px" name="ship0" id="ship0" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
					</tr>  	
				<tr>
					<td >
						<%=SystemEnv.getHtmlLabelName(30966,user.getLanguage())%> <input type="text" id="field1" style="width:218px"  tabindex="2" class="OInput3 BoxW90" disabled="disabled"  onblur="changBoxStatus(1,2,this);"/>
						<select class="OSelect MT3 MLeft8" style="width:70px"  id="ship1"    disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
				</tr>
				<tr>
					<td>
						<%=SystemEnv.getHtmlLabelName(30967,user.getLanguage())%> <input type="text" id="field2"  style="width:218px" tabindex="3" class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(2,3,this);"/>
						<select class="OSelect MT3 MLeft8" style="width:70px" id="ship2" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
					</tr>  	
				<tr>
					<td >
						<%=SystemEnv.getHtmlLabelName(30968,user.getLanguage())%> <input type="text" id="field3"  style="width:218px" tabindex="4" class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(3,4,this);" />
						<select class="OSelect MT3 MLeft8" style="width:70px" id="ship3" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
				</tr>
				<tr>
					<td >
						<%=SystemEnv.getHtmlLabelName(30969,user.getLanguage())%> <input type="text" id="field4"  style="width:218px" tabindex="5" class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(4,5,this);" />
						<select class="OSelect MT3 MLeft8" style="width:70px" id="ship4" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
					</tr>  	
				<tr>
					<td>
						<%=SystemEnv.getHtmlLabelName(30970,user.getLanguage())%> <input type="text" id="field5"  style="width:218px" tabindex="6" class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(5,6,this);" />
						<select class="OSelect MT3 MLeft8" style="width:70px" id="ship5" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
				</tr>
				<tr>
					<td  >
						<%=SystemEnv.getHtmlLabelName(30971,user.getLanguage())%> <input type="text" id="field6" style="width:218px"  tabindex="7"
						class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(6,7,this);" />
						<select class="OSelect MT3 MLeft8" id="ship6" style="width:70px" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
					</tr>  	
				<tr>
					<td  >
						<%=SystemEnv.getHtmlLabelName(30972,user.getLanguage())%> <input type="text"  style="width:218px" id="field7"  tabindex="8"
						class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(7,8,this);" />
						<select class="OSelect MT3 MLeft8" style="width:70px" id="ship7" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
				</tr>
				<tr>
					<td  >
						<%=SystemEnv.getHtmlLabelName(30973,user.getLanguage())%> <input type="text" id="field8"  style="width:218px" tabindex="9"
						class="OInput3 BoxW90" disabled="disabled" onblur="changBoxStatus(8,9,this);" />
						<select class="OSelect MT3 MLeft8"  style="width:70px" id="ship8" disabled="disabled">
						<option value="and">
							and
						</option>
						<option value="or">
							or
						</option>
					</select>
					</td>
					</tr>  	
				<tr>
					<td >
						<%=SystemEnv.getHtmlLabelName(30974,user.getLanguage())%> <input type="text" id="field9"  style="width:218px" tabindex="10"
						class="OInput3 BoxW90"  disabled="disabled"/> &nbsp;&nbsp;
						<!-- <button class="BtnLM" type="button"   onclick="cleanMes()"> <%=SystemEnv.getHtmlLabelName(15504,user.getLanguage())%> </button> -->
					</td>
				</tr>
			</table>
		</wea:item>
		
	</wea:group>
	</wea:layout>
		
		
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(30956,user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true'}">
				<iframe id="frame2affixlist" width="574px" height="70" frameborder=no >
			
				</iframe>
			</wea:item>
		</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doCancel(this)">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">
function doCancel(){
	parentDialog.close();
	//window.close();
}
</script>


<script type="text/javascript">
	/* 关闭 已打开的面板 */
	function closeMaint4Win()
	{
		jQuery("#<%=btn%>").qtip('hide');
		jQuery("#<%=btn%>").qtip('destroy');
	}
	
	function displayimg(obj){
		if(jQuery.trim(jQuery(obj).val())!=""){
			jQuery(obj).parent().find("img").css("display","none");
			if(jQuery(obj).attr("id")=="companyname"){
				if(jQuery("#method").val()=="add"){
					ishavedLMcompany();
				}
			}
		}else{
			jQuery(obj).parent().find("img").css("display","");
		}
	}
	function cleanMes(){
			  jQuery("#field0").attr("value","");
			  jQuery("#field1").attr("value","");
			  jQuery("#field2").attr("value","");
			  jQuery("#field3").attr("value","");
			  jQuery("#field4").attr("value","");
			  jQuery("#field5").attr("value","");
			  jQuery("#field6").attr("value","");
			  jQuery("#field7").attr("value","");
			  jQuery("#field8").attr("value","");
			  jQuery("#field9").attr("value","");
			  
		
	}
	
				
</script>
