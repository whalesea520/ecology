
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pro" class="weaver.cpcompanyinfo.ProManageUtil" scope="page" />

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>

<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
<script>
var parentDialog = parent.parent.getDialog(parent);
//var parentWin = parent.parent.getParentWindow(parent.window);
var parentWin = parent.getParentWindow(window);

</script>
<%
    String zrrhideField="{'samePair':'zrrhideField'}";
	String btnid = Util.null2String(request.getParameter("btnid"));
    boolean notview=!"viewBtn".equals(btnid);
	String companyid = Util.null2String(request
			.getParameter("companyid"));
	/*公司信息*/
	String companyname = ""; //公司名称
	String companyename = ""; //公司英文名称
	String companyaddress = ""; //公司地址
	String archivenum = ""; //全宗号
	String companyregion = ""; //区域	
	String companyregionSpan = ""; //区域
	String foundingTime = ""; //公司成立时间
	int businesstype = 0; //业务类型	
	String loancard = ""; //贷款卡号
	String companyvestin = ""; //公司归属
	/*营业执照信息*/
	String scopebusiness = "";
	String registercapital = "";
	String corporatdelegate = "";
	String usefulbegindate = "";
	String usefulenddate = "";
	String usefulyear = "";
	String licenseregistnum = "";
	String companytype = "";
	/*章程*/
	String aggregateinvest = "";
	String currencyid = "";
	/*董事会*/
	String generalmanager = "";
	
	

	if (!companyid.equals("")) {
		String sql = "select t1.*,t3.*,t4.aggregateinvest,t4.currencyid,t5.generalmanager,hrmcity. cityname from cpcompanyinfo t1 left join ("
				+ " select t2.companyid,t2.scopebusiness,t2.registercapital,t2.corporatdelegate, "
				+ " t2.usefulbegindate,t2.usefulenddate,t2.usefulyear,t2.licenseregistnum,t2.companytype "
				+ " from CPBUSINESSLICENSE t2 , CPLMLICENSEAFFIX taf where t2.licenseaffixid = taf.licenseaffixid and t2.isdel='T' and taf.licensetype = '1' ) t3 on t1.companyid = t3.companyid"
				+ " left join CPCONSTITUTION t4 on t1.companyid = t4.companyid"
				+ " left join CPBOARDDIRECTORS t5 on t1.companyid = t5.companyid "
				+" left join  hrmcity  on t1.companyregion=hrmcity.id"
				+ " where t1.companyid = " + companyid;
	
	
		rs.execute(sql);
		while (rs.next()) {
			/*公司信息*/
			companyname = Util.null2String(rs.getString("companyname")); //公司名称
			companyename = Util.null2String(rs
					.getString("companyename")); //公司英文名称
			companyaddress = Util.null2String(rs
					.getString("companyaddress")); //公司地址
			archivenum = Util.null2String(rs.getString("archivenum")); //全宗号
			companyregion =Util.null2String(rs.getString("companyregion")); //区域id	
			companyregionSpan=Util.null2String(rs.getString("cityname")); //区域名称	
			foundingTime=Util.null2String(rs.getString("foundingTime")); //公司成立时间
			if("NULL".equals(foundingTime)){
				foundingTime="";
			}
			businesstype = rs.getInt("businesstype"); //业务类型	
			loancard = Util.null2String(rs.getString("loancard")); //贷款卡号
			companyvestin = Util.null2String(rs
					.getString("companyvestin")); //公司归属
					//System.out.println(companyvestin);
			/*营业执照信息*/
			scopebusiness = Util.null2String(rs.getString("scopebusiness")).replace("\n", "");
			registercapital = Util.null2String(rs
					.getString("registercapital"));
			corporatdelegate = Util.null2String(rs
					.getString("corporatdelegate"));
			usefulbegindate = Util.null2String(rs
					.getString("usefulbegindate"));
			usefulenddate = Util.null2String(rs
					.getString("usefulenddate"));
			usefulyear = Util.null2String(rs.getString("usefulyear"));
			licenseregistnum = Util.null2String(rs
					.getString("licenseregistnum"));
			companytype = Util.null2String(rs.getString("companytype"));
			/*章程*/
			aggregateinvest = Util.null2String(rs
					.getString("aggregateinvest"));
			currencyid = Util.null2String(rs.getString("currencyid"));
			/*董事会*/
			generalmanager = Util.null2String(rs
					.getString("generalmanager"));
		}
	}
	if(btnid.equals("viewBtn")){
		pro.writeCompanylog("3",companyid,"4",user.getUID()+"",""+SystemEnv.getHtmlLabelName(1361,user.getLanguage()) );
	}
	
	String zrrid="";//得到自然人的id
	String zrrname="";
	if(rs.execute("select id,name from CompanyBusinessService where affixindex=-1")&&rs.next()){
		zrrid=rs.getString("id");
		zrrname=rs.getString("name");
	}

	
%>
<script type="text/javascript">

	var zrrid="<%=zrrid%>";
	var businesstype="<%=businesstype%>";
	var zrrname01="<%=SystemEnv.getHtmlLabelName(31445,user.getLanguage())%>&nbsp;";
	var zrrname02="<%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>&nbsp;";
	var gsname="<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>";
	var zrrname="<%=zrrname%>";
	function checkzrr(obj){
		if(zrrid!=""&&zrrid==obj.value){
			//说明切换到了自然人
            hideEle('zrrhideField');
		    jQuery(".hidetr_n").hide();
		    if("<%=btnid%>"=="newBtn"){
		   		 jQuery("#zrrname").html(zrrname01);
		   		  jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31448,user.getLanguage())%>");
		    }
		 //   gsname="<%=SystemEnv.getHtmlLabelName(31445,user.getLanguage())%>";
		}else{
			//说明选择的不是自然人
            showEle('zrrhideField');
			 jQuery(".hidetr_n").show();
			 if("<%=btnid%>"=="newBtn"){
				 jQuery("#zrrname").html(zrrname02);
				 jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31049,user.getLanguage())%>");
			 }
		}
	}
	jQuery(document).ready(function(){
		if("<%=btnid%>"=="newBtn")
		{
			jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31049,user.getLanguage())%>");
			jQuery("#method").val("add");
            jQuery("#btnInfoSave").attr("href","javascript:saveCompanyInfo();");//谷歌 火狐
		}
		if("<%=btnid%>"=="editBtn")
		{
			jQuery("#method").val("edit");
			jQuery("#btnInfoSave").attr("href","javascript:saveCompanyInfo();");
			if(businesstype==zrrid){
                hideEle('zrrhideField');
				//gsname="<%=SystemEnv.getHtmlLabelName(31445,user.getLanguage())%>";
				 jQuery(".hidetr_n").hide();
		   		 jQuery("#zrrname01").html(zrrname);
		   		// jQuery("#businesstype").hide();
		   	
		   		//jQuery("table .LayoutTable").find("tr:eq(6)").find("a").text("<%=companyvestin%>");
		   		
		   		jQuery("#businesstype").selectbox("hide");
		   		 jQuery("#zrrname").html(zrrname01);
		   		 jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31446,user.getLanguage())%>");
			}else{
                showEle('zrrhideField');
				jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31050,user.getLanguage())%>");
			}
		}
		if("<%=btnid%>"=="viewBtn")
		{
		
			jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
			jQuery(".OSelect").removeClass("OSelect").addClass("OSelect2").focus(function(){this.blur();});
			jQuery("#companyaddress").addClass("OInput4");
			jQuery("#btndiv").css("display","none");
			jQuery("#city_sel").hide();
			if(businesstype==zrrid){
                hideEle('zrrhideField');
				//gsname="<%=SystemEnv.getHtmlLabelName(31445,user.getLanguage())%>";
				 jQuery(".hidetr_n").hide();
		   		// jQuery("#businesstype").hide();
		   		jQuery("#businesstype").selectbox("hide");
		   		  jQuery("#zrrname01").html(zrrname);
		   		 jQuery("#zrrname").html(zrrname01);
		   		 jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31447,user.getLanguage())%>");
			}else{
                showEle('zrrhideField');
				 jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31051,user.getLanguage())%>");
			}
		}
		
		init_info();//调用公司资料初始化方法
		
		
		if("<%=btnid%>"=="newBtn"){
			displayimg(jQuery("#archivenum01"),1);
			displayimg(jQuery("#companyname"),1);
			if("<%=foundingTime%>"==""){
				jQuery("#foundingTime_zc").html("<img src='images/O_44_wev8.jpg'  absMiddle='absMiddle'  iswarn='warning'/>");
			}
		}else if("<%=btnid%>"=="editBtn"){
			displayimg(jQuery("#archivenum01"),2);
			displayimg(jQuery("#companyname"),2);
			if("<%=foundingTime%>"==""){
				jQuery("#foundingTime_zc").html("<img src='images/O_44_wev8.jpg'  absMiddle='absMiddle'  iswarn='warning'/>");
			}
		}else{
			displayimg(jQuery("#archivenum01"),1);
			displayimg(jQuery("#companyname"),1);
			jQuery("#foundingbtn").hide();
		}
		areromancedivs();
	});
	
	function ishavedLMcompany(methodval){
		//methodval
		var o4params = {
			method:"haved",
			methodval:methodval,
			companyid:"<%=companyid%>",
			archivenum:encodeURI(jQuery("#archivenum01").val()),
			companyname:encodeURI(jQuery("#companyname").val())
		};
		jQuery.post("/cpcompanyinfo/action/CPInfoOperate.jsp",o4params,function(data){
			//alert(jQuery.trim(data));
			jQuery("#btnInfoSave").attr("href","javascript:saveCompanyInfo();");
			if(jQuery.trim(data)=="lmboth"){
				alert("<%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>:["+jQuery("#archivenum01").val()+"]  <%=SystemEnv.getHtmlLabelName(31052,user.getLanguage())%>"+gsname+"：["+jQuery("#companyname").val()+"] <%=SystemEnv.getHtmlLabelName(31053,user.getLanguage())%>！");
				jQuery("#ishaved").val("false");
			}
			else if(jQuery.trim(data)=="lmnum"){
				alert("<%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>：["+jQuery("#archivenum01").val()+"] <%=SystemEnv.getHtmlLabelName(31053,user.getLanguage())%>！");
				jQuery("#ishaved").val("false");
			}
			else if(jQuery.trim(data)=="lmname"){
				alert(""+gsname+"：["+jQuery("#companyname").val()+"] <%=SystemEnv.getHtmlLabelName(31053,user.getLanguage())%>！");
				jQuery("#ishaved").val("false");
			}
			else {
				jQuery("#ishaved").val("true");
			}
		});
	}
	
	/*保存公司资料*/
	function saveCompanyInfo()
	{
		
		jQuery("#btnInfoSave").attr("href","javascript:void(0);");	//不让保存重复点击
		if(jQuery("#companyvestin").val()==""||jQuery("#companyvestin").val()==null){
					alert("<%=SystemEnv.getHtmlLabelName(31054,user.getLanguage())%>！");
		}else if(jQuery("#businesstype").val()==""||jQuery("#businesstype").val()==null){
					alert("<%=SystemEnv.getHtmlLabelName(31055,user.getLanguage())%>！");
		}
		if(checkForm()){
			
			if(jQuery("#ishaved").val()=="false"){
				alert("<%=SystemEnv.getHtmlLabelName(31056,user.getLanguage())%>");
				jQuery("#btnInfoSave").attr("href","javascript:saveCompanyInfo();");
			}else{
				var o4params = {
					method:jQuery("#method").val(),
					companyid:"<%=companyid%>",
					archivenum:encodeURI(jQuery("#archivenum01").val()),
					companyregion:encodeURI(jQuery("input[name=companyregion]").val()),
					companyvestin:jQuery("#companyvestin").val(),
					companyname:encodeURI(jQuery("#companyname").val()),
					companyename:encodeURI(jQuery("#companyename").val()),
					companyaddress:encodeURI(jQuery("#companyaddress").val()),
					businesstype:jQuery("#businesstype").val(),
					loancard:encodeURI(jQuery("#loancard").val()),
					foundingTime:encodeURI(jQuery("#foundingTime").val())
				};
				
				jQuery.post("/cpcompanyinfo/action/CPInfoOperate.jsp",o4params,function(data){
					parentWin._table.reLoad();
					parentDialog.close();
				});
				
			}
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
			//jQuery("#btnInfoSave").attr("href","javascript:saveCompanyInfo();");
		}
		
	}
	/*验证表单方法*/
	function checkForm(){
		var ischecked = false;
        var iszrr=false;
        if(zrrid!=""&&zrrid==jQuery("#businesstype").val()){
            iszrr=true;
        }
		if(!jQuery.trim(jQuery("input[name=companyregion]").val())==""&&!jQuery.trim(jQuery("#archivenum01").val())=="" && !jQuery.trim(jQuery("#companyname").val())==""&&(iszrr || !jQuery.trim(jQuery("#foundingTime").val())=="") ){
			ischecked = true;
		}
		return ischecked;
	}
	
	/* 关闭 qtip */
	function closeMaint4Win(btnid)
	{
		jQuery("#"+btnid).qtip("hide");
		jQuery("#"+btnid).qtip("destroy")
	}
	
	/* 公司资料 编辑、查看 初始化获得数据 */
	function init_info(){
		/*公司信息*/
		jQuery("#companyname").val("<%=companyname%>");
		jQuery("#companyename").val("<%=companyename%>");
		jQuery("#companyaddress").val("<%=companyaddress%>");
		jQuery("#archivenum01").val("<%=archivenum%>"); 
		//jQuery("#companyregion").val("<%=companyregion%>"); 
		//jQuery("#companyregionSpan").html("<%=companyregionSpan%>"); 
		jQuery("#foundingTime").val("<%=foundingTime%>"); 
		jQuery("#foundingTime_zc").html("<%=foundingTime%>"); 
		
		//alert("<%=businesstype%>");
		//alert("<%=companyvestin%>");
		if("<%=businesstype%>"!="0"){
			jQuery("#businesstype").val("<%=businesstype%>");
		}
		if("<%=companyvestin%>"!=""){
			jQuery("#companyvestin").val("<%=companyvestin%>");
		}
		 
		jQuery("#loancard").val("<%=loancard%>");
		/*营业执照信息*/
		jQuery("#scopebusiness").val("<%=scopebusiness%>");
		jQuery("#registercapital").val("<%=registercapital%>");
		jQuery("#corporatdelegate").val("<%=corporatdelegate%>");
		jQuery("#usefulbegindate").val("<%=usefulbegindate%>");
		jQuery("#usefulenddate").val("<%=usefulenddate%>");
		jQuery("#usefulyear").val("<%=usefulyear%>");
		jQuery("#licenseregistnum").val("<%=licenseregistnum%>");
		jQuery("#companytype").val("<%=companytype%>");
		/*章程*/
		jQuery("#aggregateinvest").val("<%=aggregateinvest%>");
		jQuery("#currencyid").val("<%=currencyid%>");
		/*董事会*/
		jQuery("#generalmanager").val("<%=generalmanager%>");

	}
	
	function displayimg(obj,type){
		if(type&&type=="2"){
				//如果type有值,说明来源于Load加载
				//如果type等于2，说明来源于编辑加载
				if(jQuery.trim(jQuery(obj).val())!=""){
					jQuery(obj).parent().find("img").css("display","none");
				}else{
					jQuery(obj).parent().find("img").css("display","");
				}
		
		}else{
				if(jQuery.trim(jQuery(obj).val())!=""){
					jQuery(obj).parent().find("img").css("display","none");
					if(jQuery(obj).attr("id")=="companyname"||jQuery(obj).attr("id")=="archivenum01"){
						if(jQuery("#method").val()=="add"||jQuery("#method").val()=="edit"){
							ishavedLMcompany(jQuery("#method").val());
						}
					}
				}else{
					jQuery(obj).parent().find("img").css("display","");
				}
		}
	}
	
</script>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="cpcompany"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("1851",user.getLanguage())%>'/>
</jsp:include>

<table id="topTitle" cellpadding="0"  cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="btndiv">
			<a id="btnInfoSave" href="javascript:void(0);" class="hover">
				<input  type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="saveCompanyInfo();" />
			</a>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>	

<!--表头浮动层 start-->
<input type="hidden" id="method" />
<input type="hidden" id="ishaved" value="true"/>
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>' attributes="">
		
	<%--	<table class="ListStyle" border="0" align="center" cellpadding="0" cellspacing="0"   >--%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" id="archivenum01" class="OInput2 BoxW120" onblur="displayimg(this)"  maxlength="20" />
			<img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(28100,user.getLanguage())%></wea:item>
		<wea:item>		<!-- 区域 -->
		<%if(notview){ %>
			<div areaType="city" areaName="companyregion" areaValue="<%=companyregion%>" 
areaSpanValue="<%=companyregionSpan%>"  areaMustInput="2" areaCallback="callBack"  class="_areaselect" id="_areaselect_companyregion"></div>	
				<%-- id="city_sel"--%>				
		<%}else{ %>
				<%=companyregionSpan%>
		<%} %>
		</wea:item>
		<!-- 自然人 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(26800,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="zrrname01"></span>
				<select class="OSelect" style="width: 122px;" id="businesstype" <%=!notview?"disabled ":"" %>  onchange="checkzrr(this)">
					<%
							String	 sql="select * from CompanyBusinessService  where affixindex !=-1 order by affixindex";
							rs.execute(sql);
							while(rs.next()){
							String c_name=rs.getString("name");
							String c_id=rs.getString("id");
				  %>
						<option value="<%=c_id%>" <%=c_id.equals(businesstype+"")?"selected":"" %>>
							<%=c_name %>
						</option>
					<%
						}
					 %>
					 
					 <%
							sql="select * from CompanyBusinessService  where affixindex =-1 ";
							rs.execute(sql);
							while(rs.next()){
							String c_name=rs.getString("name");
							String c_id=rs.getString("id");
							if(zrrid.equals(c_id)&&!btnid.equals("newBtn")&&!(businesstype+"").equals(c_id)){
								continue;
							}
				  %>
						<option value="<%=c_id%>">
							<%=c_name %>
						</option>
					<%
						}
					 %>
				</select>
		</wea:item>
					
		<wea:item><%=SystemEnv.getHtmlLabelName(30987,user.getLanguage())%></wea:item>				
		<wea:item>
			<%
				String sql="select * from   Companyattributable order by affixindex "; 
				rs.execute(sql);
				if(rs.next()){
			%>
			<select name="companyvestin" id="companyvestin" class="OSelect" style="width: 122px;" <%=!notview?"disabled ":"" %>>
					
				<%
					rs1.execute(sql);
					while(rs1.next()){
					String c_name=rs1.getString("name");
					String c_id=rs1.getString("id");
				%>
						<option value="<%=c_id%>" <%if(companyvestin.equals(c_id)){out.print("selected");} %> >
							<%=c_name %>
						</option>
				<%
					}
				}else{
				 %>
				 <span style="color: red"><%=SystemEnv.getHtmlLabelName(31054,user.getLanguage())%></span>
				 <%} %>
			</select>
		</wea:item>
		
		<wea:item><span  id="zrrname"><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></span></wea:item>
		<wea:item>
			<input type="text" name="companyname" id="companyname" onblur="displayimg(this)"  maxlength="40" <%=!notview?"readonly ":"" %> />
			<img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;" />
		</wea:item>
		
		<wea:item ><%=SystemEnv.getHtmlLabelName(23204,user.getLanguage())%></wea:item>
		<wea:item >
			<input type="text" name="companyename" id="companyename"  maxlength="40" <%=!notview?"readonly ":"" %> />
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(31057,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<textarea name="companyaddress"  class="OInput2 BoxWAuto BoxHeight30" id="companyaddress" ></textarea>
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(30976,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="companytype" id="companytype" onfocus="this.blur();" class="OInput3 BoxW120" style="background-color:#f8f8f8;"/>
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(30975,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<button type=button class=calendar id=foundingbtn onclick="onShowDate(document.getElementById('foundingTime_zc'),foundingTime)"></BUTTON>
			<input type="hidden" id="foundingTime" name="foundingTime"/>
			<span id="foundingTime_zc">
			<img src="images/O_44_wev8.jpg"   absMiddle="absMiddle"  iswarn='warning'/>
			</span>
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(31031,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<textarea name="scopebusiness" class="OInput4 BoxWAuto BoxHeight40" onfocus="this.blur();" id="scopebusiness" style="background-color:#f8f8f8;"></textarea>
		</wea:item>
	
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(20668,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="registercapital" id="registercapital" onfocus="this.blur();" class="OInput3 BoxW120" style="background-color:#f8f8f8;"/>
		</wea:item>
	
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(31038,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="aggregateinvest" id="aggregateinvest" 	onfocus="this.blur();" class="OInput3 BoxW120" style="background-color:#f8f8f8;"/>
		</wea:item>
				
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(20656,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="corporatdelegate" id="corporatdelegate" onfocus="this.blur();" class="OInput3 BoxW120" style="background-color:#f8f8f8;"/>
		</wea:item>
				
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(20696,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="generalmanager" id="generalmanager" onfocus="this.blur();" class="OInput3 BoxW120" style="background-color:#f8f8f8;"/>
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(31058,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<%
				String dshcysql = " select t1.officename from CPBOARDOFFICER t1,CPBOARDDIRECTORS t2 where t1.directorsid = t2.directorsid and t2.companyid= '"+companyid+"'"; 
				String dshcy = "";
				rs.execute(dshcysql);
				while(rs.next()){
					dshcy+=rs.getString("officename")+",";
				}
				if(!"".equals(dshcy)){
					dshcy=dshcy.substring(0, dshcy.length()-1);
				}
			%>
			<textarea name="officename" class="OInput4 BoxWAuto BoxHeight40" onfocus="this.blur();" id="officename" style="background-color:#f8f8f8;"><%=dshcy %></textarea>
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(31059,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="usefulbegindate" style="width:80px;background-color:#f8f8f8;" id="usefulbegindate" onfocus="this.blur();"  />
			<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>
			<input type="text" name="usefulenddate" style="width:80px;background-color:#f8f8f8;" id="usefulenddate" onfocus="this.blur();"  />
			<%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>
			<input type="text" name="usefulyear" style="width:80px;background-color:#f8f8f8;" id="usefulyear" onfocus="this.blur();"  />
			<%=SystemEnv.getHtmlLabelName(26577,user.getLanguage())%>
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(31060,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="loancard" id="loancard" class="OInput2"  maxlength="40" />
		</wea:item>
		
		<wea:item attributes='<%=zrrhideField %>'><%=SystemEnv.getHtmlLabelName(23798,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=zrrhideField %>'>
			<input type="text" name="licenseregistnum" id="licenseregistnum" onfocus="this.blur();" style="background-color:#f8f8f8;"/>
		</wea:item>
	</wea:group>
</wea:layout>

<wea:layout  >
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("31039",user.getLanguage())%>' attributes="">
		<wea:item attributes="{'isTableList':'true'}">
			<table width="430" border="0" cellpadding="0" cellspacing="1"  class="ListStyle">
				<colgroup>
					<col width="35%">
					<col width="35%">
					<col width="*">
				</colgroup>
				
				<tr class="header">
					<th><%=SystemEnv.getHtmlLabelName(27336,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(31040,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(31109,user.getLanguage())%></th>
				</tr>
				
					<%
						String sql = "select t2.* from CPSHAREHOLDER t1,CPSHAREOFFICERS t2 where t1.shareid = t2.shareid and t1.companyid = '" + companyid+"'";
						rs.execute(sql);
						while (rs.next()){
					 %>
					<tr class="DataLight">
						<td >
							<%=Util.null2String(rs.getString("officername")) %>
						</td>
						<td>
							<%=Util.null2String(rs.getString("aggregateinvest")) %>
						</td>
						<td>
							<%=Util.null2String(rs.getString("investment")) %>
						</td>
					</tr>
					<%
					}
					 %>
			</table>

		</wea:item>
	</wea:group>
</wea:layout>
<%
if(!btnid.equals("newBtn")){
 %>
<div style="height:70px;">
</div>
<% 
}else{
%>
<div style="height:50px;">
</div>
<%
}
%>
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
<!--
	</div>
</div>
表头浮动层 end-->

