<%@page import="weaver.cpcompanyinfo.ProTransMethod"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@page import="java.net.URLDecoder"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.cpcompanyinfo.CompanyInfoTransMethod"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.docs.docs.DocComInfo"%>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script>
var parentDialog = parent.parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
</script>
<style> 
  .dest{   
    width: 399px;   
    height: 321px; 
    border: solid #ccc 1px;   
    overflow: hidden;   
    /**这个地方在IE6,7下很贱，如果不把它设置为relative， 则在它里面的对象的relative无效**/   
    position: relative;   
    z-index: 9999;
    background:#fff;
  }   
  fieldset { border:0;}

</style> 

<%
int userid = user.getUID();
Random rnd = new Random();
int sjdata=rnd.nextInt(100);
String btnid = Util.null2String(request.getParameter("btnid"));
String companyid = Util.null2String(request.getParameter("companyid"));
%>
<style type="text/css">
.InputStyle{width:30%!important;}
.inputstyle{width:30%!important;}
.Inputstyle{width:30%!important;}
.inputStyle{width:30%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
<%
	if(!btnid.equals("newBtn")){
%>
	div.tab_box{width:600px!important;}
<%
	}
%>

</style>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	rs.execute("SELECT * FROM CPCOMPANYINFO  where companyid="+companyid);		
	String companyname ="";
	if(rs.next()){
			companyname=rs.getString("companyname");
	}	
	


	String licenseid = Util.null2String(request.getParameter("licenseid"));
	/*公司证照*/
	String registeraddress = "";
	String corporation = "";
	String recordnum = "";
	String usefulbegindate = "";
	String usefulenddate = "";
	String usefulyear = "";
	String dateinssue = "";
	String licensestatu = "";
	String annualinspection = "";
	String departinssue = "";
	String scopebusiness = "";
	String registercapital = "";
	String paiclupcapital = "";
	String currencyid = "";
	String currencyname="";
	String corporatdelegate = "";
	String licenseregistnum = "";
	String memo = "";
	String companytype = "";
	String licensename = "";
	String licensetype = "";
	int licenseaffixid = 0;
	String affixdoc = "";
	String imgid = "";
	String imgname = "";
	
	String requestid = "";
	String requestname = "";	
	String requestaffixid = "";
	
	String ispdf = "";

	if (!licenseid.equals("")) {
		String sql = " select * from CPBUSINESSLICENSE t1,CPLMLICENSEAFFIX t2 where t1.licenseaffixid = t2.licenseaffixid and t1.licenseid = "
				+ licenseid;
		rs.execute(sql);
		//System.out.println("查出证照的基本信息"+sql);
		if (rs.next()) {
			registeraddress = Util.null2String(rs
					.getString("registeraddress"));
			corporation = Util.null2String(rs.getString("corporation"));
			recordnum = Util.null2String(rs.getString("recordnum"));
			usefulbegindate = Util.null2String(rs
					.getString("usefulbegindate"));
			usefulenddate = Util.null2String(rs
					.getString("usefulenddate"));
			usefulyear = Util.null2String(rs.getString("usefulyear"));
			dateinssue = Util.null2String(rs.getString("dateinssue"));
			licensestatu = Util.null2String(rs
					.getString("licensestatu"));
			annualinspection = Util.null2String(rs
					.getString("annualinspection"));
			departinssue = Util.null2String(rs
					.getString("departinssue"));
			scopebusiness = Util.null2String(rs
					.getString("scopebusiness"));
			registercapital = Util.null2String(rs
					.getString("registercapital"));
			paiclupcapital = Util.null2String(rs
					.getString("paiclupcapital"));
			currencyid = Util.null2String(rs.getString("currencyid"));
			corporatdelegate = Util.null2String(rs
					.getString("corporatdelegate"));
			licenseregistnum = Util.null2String(rs
					.getString("licenseregistnum"));
			memo = Util.null2String(rs.getString("memo"));
			companytype = Util.null2String(rs.getString("companytype"));
			licensename = Util.null2String(rs.getString("licensename"));
		//	System.out.println("licensename 00 ============"+licensename);
			licensetype = Util.null2String(rs.getString("licensetype"));
			licenseaffixid = rs.getInt("licenseaffixid");
			affixdoc = Util.null2String(rs.getString("affixdoc"));
		//	System.out.println("licenseaffixid 00 ============"+licenseaffixid);
			requestid = Util.null2String(rs.getString("requestid"));
			requestname = Util.null2String(rs.getString("requestname"));
			requestaffixid = Util.null2String(rs.getString("requestaffixid"));
			
			rs02.execute("select id,currencyname,currencydesc from FnaCurrency  where id = '"+currencyid+"'");
			if(rs02.next()){
				currencyname=Util.null2String(rs02.getString("currencyname"));
			}
			
		}
		String affixdoctemp = "";
		if(!"".equals(affixdoc) && affixdoc != null) {affixdoctemp = affixdoc.substring(0,affixdoc.length()-1);}
		//System.out.println("affixdoctemp=="+affixdoctemp);
		String[] affixdoctemparr = affixdoctemp.split(",");
		rs.execute("select * from imagefile where imagefileid='"+affixdoctemparr[0]+"'");
		if(rs.next()){
			imgid=rs.getString("imagefileid");
			imgname = rs.getString("imagefilename");
			if(imgname.lastIndexOf(".")>0){
			if(imgname.substring(imgname.lastIndexOf("."),imgname.length()).toLowerCase().equalsIgnoreCase(".pdf")){
				ispdf = "1";
			}else if(imgname.substring(imgname.lastIndexOf("."),imgname.length()).toLowerCase().equalsIgnoreCase(".jpg")
				|| imgname.substring(imgname.lastIndexOf("."),imgname.length()).toLowerCase().equalsIgnoreCase(".bmp")
				|| imgname.substring(imgname.lastIndexOf("."),imgname.length()).toLowerCase().equalsIgnoreCase(".jpeg")
				|| imgname.substring(imgname.lastIndexOf("."),imgname.length()).toLowerCase().equalsIgnoreCase(".png")
				){
					ispdf ="0";
				}else{
					ispdf ="2";
				}
			}			
		}
	}
	
	String o4sql = " select * from mytrainaccessoriestype where accessoriesname='lmlicense'";
	rs.execute(o4sql);
	String mainId="0";
	String subId="0";
	String secId="0";
	if(rs.next()){
		mainId=rs.getString("mainId");//覆盖默认的0
	 	subId=rs.getString("subId");//覆盖默认的0
	 	secId=rs.getString("secId");//覆盖默认的0c
	}


	//很关键的一个变量，用于判断后续页面是否开发编辑权限
	//0--只有这个公司的查看权限，没有维护权限
	//1--拥有这个公司查看和维护全县
	String showOrUpdate = Util.null2String(request.getParameter("showOrUpdate"));
%>

<link rel="stylesheet" type="text/css" href="/cpcompanyinfo/style/wbox_wev8.css" />
<script type="text/javascript" src="js/magnifier_wev8.js"></script>

<div id="test" style="display:none"></div>
<script type="text/javascript">
	
	
	/* function dozoom(obj){
	
	if(obj.complete){
		//$(".jqzoom").jqzoom();
	}
		//	
	} */
	jQuery(document).ready(function(){
	
/*
		
		jQuery("#licensename").children().each(function(){
			var val = $(this).val();  
			if(val==<%=licenseaffixid%>){
				 //$(this).attr("selected",true);
				 jQuery("#licensename").next().find("a eq(1)").attr("title","");
				 return;
			}
		});
	
	*/
	//alert($(".jqzoom").length)
	/* setTimeout(function(){
		if(jQuery.browser.msie) {
			//如果是ie,就调用一下window对象的某个属性，用于控制放大镜的兼容问题
			window.screenX;
		}
		$(".jqzoom").jqzoom();
	},10)
	 */

		//保存按钮指向保存方法
		//jQuery("#saveLicenseBtn").attr("href","javascript:saveDate();");
		
		if("<%=btnid%>"=="newBtn")
		{
			jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31021,user.getLanguage())%>");
			jQuery("#method").val("add");
           // jQuery("#saveLicenseBtn").attr("href","javascript:saveDate();");
		}
		if("<%=btnid%>"=="editBtn")
		{
			jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31023,user.getLanguage())%>");
			jQuery("#method").val("edit");
			//jQuery("#saveLicenseBtn").attr("href","javascript:saveDate();");
			jQuery("#see_img").hide();
			jQuery("img[iswarn='warning']").hide();
			jQuery("#licenseaffixid").selectbox("disable");
			jQuery("#licensename").addClass("BoxW300").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
		}
		if("<%=btnid%>"=="viewBtn")
		{
			jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31022,user.getLanguage())%>");
			jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
			jQuery(".OSelect[id!='searchSL']").removeClass("OSelect").addClass("OSelect2").focus(function(){this.blur();});
			jQuery("#scopebusiness").addClass("OInput4");
			jQuery("#saveLicenseBtn").css("display","none");
			jQuery("#save_H").hide();
			jQuery("#see_img").hide();
			jQuery("#licenseaffixid").selectbox("disable");
			jQuery(".calendar").hide();
			
			jQuery("#licensename").addClass("BoxW300");
			jQuery(".Clock").hide();
			jQuery("#cu_idH").hide();
			jQuery("#licenseAffixUpload").hide();
			jQuery("img[iswarn='warning']").hide();
			
		}
		if("<%=btnid%>"!="newBtn")
		{
			init_license();//调用公司证照初始化方法
		}else{
			jQuery("#companyname").val("<%=companyname%>");
		}
		/*当有实际证照时才显示放大镜*/
		if("<%=affixdoc%>" == ""){
			jQuery("#source").find("img").attr("src","images/nopic_wev8.jpg");
			jQuery("#_s2uiContent").css("display","none");
		}else{
			
			//mouseonBig();
			jQuery("#_s2uiContent").css("display","");
		}
		
		displayimg(jQuery("#departinssue"));
		displayimg(jQuery("#licensename"));
	});
	

	
	function mouseonBig(){
		/*当鼠标放在图片上才显示放大镜，反之隐藏放大镜*/
		jQuery("#source").bind("mouseover",function(){
			if(jQuery("#affixdoc").val()!=""){	//因为删除图片后，还原无图片状态，不再监听
				var borderBox = document.createElement("div");
				borderBox.setAttribute("id","dest");  
				borderBox.style.clear = "both"; 
				borderBox.style.top = "55px";
				borderBox.style.left = "50px";
				borderBox.className = "dest";
				document.getElementById("destContent").appendChild(borderBox);
				Amplifier.init('source','dest',jQuery("select#speed").val());//调用放大镜
			}
		});
		
		jQuery("#source").bind("mouseout",function(){
			jQuery("#dest,#chooseArea").remove();
		});
	}
	
	/*公司证照 保存方法*/
	function saveBusinessLicense()
	{
		
		var requestname = jQuery('#requestname').val();
		var requestaffixid = "";
		var requestid = "";
		
		if(requestname == "")
		{
			requestname = jQuery('#workflowspan').find("a").html();
			requestid = jQuery('#workflowspan').find("a").attr("requestid");
		}
		else
		{
			requestname = jQuery('#requestname').val();
			requestid = jQuery("#requestid").val();
			requestaffixid = jQuery("#affixIds").val();
		}
		//alert("ln:"+encodeURI(jQuery("#licensename option:selected").text()));
		var o4params = {
			method:jQuery("#method").val(),
			isaddversion:jQuery("#isaddversion").val(),
			companyid:"<%=companyid%>",
			licenseid:"<%=licenseid%>",
			licenseaffixid:encodeURI(jQuery("#licenseaffixid").val()),//id 
			licensename:encodeURI(jQuery("#licenseaffixid option:selected").text()), //文本$("#s1 option:selected“).text();
			
			registeraddress:encodeURI(jQuery("#registeraddress").val()),
			corporation:encodeURI(jQuery("#corporation").val()),
			recordnum:encodeURI(jQuery("#recordnum").val()),
			usefulbegindate:encodeURI(jQuery("#begintime").val()),
			usefulenddate:encodeURI(jQuery("#endtime").val()),
			usefulyear:encodeURI(jQuery("#usefulyear").val()),
			dateinssue:encodeURI(jQuery("#inssuedate").val()),
			annualinspection:encodeURI(jQuery("#annualdate").val()),
			scopebusiness:encodeURI(jQuery("#scopebusiness").val()),
			departinssue:encodeURI(jQuery("#departinssue").val()),
			registercapital:encodeURI(jQuery("#registercapital").val()),
			paiclupcapital:encodeURI(jQuery("#paiclupcapital").val()),
			currencyid:encodeURI(jQuery("#currencyid").val()),
			corporatdelegate:encodeURI(jQuery("#corporatdelegate").val()),
			companytype:encodeURI(jQuery("#companytype").val()),
			licenseregistnum:encodeURI(jQuery("#licenseregistnum").val()),
			memo:encodeURI(jQuery("#memo").val()),
			affixdoc:encodeURI(jQuery("#affixdoc").val()),
			
			requestname1:encodeURI(requestname),
			requestid1:encodeURI(requestid),
			affixids1:encodeURI(requestaffixid),
			
			versionnum:encodeURI(jQuery("#versionnum").val()),
			versionname:encodeURI(jQuery("#versionname").val()),
			versionmemo:encodeURI(jQuery("#versionmemo").val()),
			versionaffix:"",
			date2Version:encodeURI(jQuery("#versionTime").val())
		};
		jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(data){
		
			if(jQuery.trim(data)!="0"){
				alert(data);
			}
			closeMaint4Win("<%=btnid%>");
			//reflush2List();
		});
		
	}
	
	//证照的版本编辑方法
	function editversionDate(versionid,oneMoudel){
			o4params ={
			method:"editversion",
			versionid:versionid,
			versionnum:encodeURI(jQuery("#versionnum").val()),
			versionname:encodeURI(jQuery("#versionname").val()),
			versionmemo:encodeURI(jQuery("#versionmemo").val()),
			versionaffix:"",
			date2Version:encodeURI(jQuery("#versionTime").val()),
			oneMoudel:oneMoudel
			};
			//alert(jQuery("#versionname").val()+"提交数据"+jQuery("#versionnum").val());
			jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31024,user.getLanguage())%>!");
				onLicenseDivClose();
		});
	}
	
	/*验证表单方法*/
	function checkForm()
	{
		var ischecked = false;
		if(jQuery.trim(jQuery("#licensename").val())!="" &&jQuery.trim(jQuery("#inssuedate").val())!="" && jQuery.trim(jQuery("#departinssue").val())!=""  ){
			ischecked = true;
		}
	 	jQuery("#w_chedktable").find("img[align='absMiddle']").each(function (){
			ischecked=false;
		});
		
		if(!jQuery("#_fximg").is(":hidden")){
				ischecked=false;
		}
		if(!jQuery("#businessOnlyDiv").is(":hidden")){
				jQuery("#businessOnlyDiv").find("img[align='absMiddle']").each(function (){
							if(!jQuery(this).is(":hidden")){
										ischecked=false;
							}
				});
		}
		
		if(jQuery.trim(jQuery("#corporation").val())==""||jQuery.trim(jQuery("#recordnum").val())==""||jQuery.trim(jQuery("#scopebusiness").val())==""){
				ischecked=false;
		}
		
		
		return ischecked;
	}
	
	
	function opinionStartTimeEndTime( stratTime , endTime ){
	      var strat = stratTime.split( "-" );
	      var end = endTime.split( "-" );
	      var sdate=new Date(strat[0],strat[1],strat[2]);
	      var edate=new Date(end[0],end[1],end[2]);
	      if(sdate.getTime()>edate.getTime()){
	        return false;
	      }
	      return true;
    }
    
	
	function displayimg(obj){
		if(jQuery.trim(jQuery(obj).val())!=""){
			jQuery(obj).parent().find("img[iswarn='warning']").css("display","none");
		}else{
			jQuery(obj).parent().find("img[iswarn='warning']").css("display","");
		}
	}
	function displayimgNext(obj){
		if(jQuery.trim(jQuery(obj).val())!=""){
			jQuery(obj).next().find("img[iswarn='warning']").css("display","none");
		}else{
			jQuery(obj).next().find("img[iswarn='warning']").css("display","");
		}
	}
	
	
	/* 关闭 qtip */
	function closeMaint4Win(btnid)
	{
		//jQuery("#"+btnid).qtip("hide");
		//jQuery("#"+btnid).qtip("destroy")
		//window.parent.reloadListContent();
		parentWin._table.reLoad();
		parentDialog.close();
		
	}
	/*初始化证照 特别是第二块，针对编辑和查看*/
	function init_license(){
		jQuery("#companyname").val("<%=companyname%>");
		jQuery("#licenseaffixid").val("<%=licenseaffixid%>");
		
		jQuery("#registeraddress").val("<%=registeraddress%>");
		jQuery("#corporation").val("<%=corporation%>");
		jQuery("#recordnum").val("<%=recordnum%>");
		jQuery("#usefulbegindate01").html("<%=usefulbegindate%>");
		jQuery("#begintime").val("<%=usefulbegindate%>");
		
		
		jQuery("#usefulenddate").html("<%=usefulenddate%>");
		jQuery("#endtime").val("<%=usefulenddate%>");
		
		
		jQuery("#usefulyear").val("<%=usefulyear%>");
	
		jQuery("#inssuedate").val("<%=dateinssue%>");
	
		if("<%=btnid%>"=="editBtn")
		{
				jQuery("#dateinssue").html("<%=dateinssue%>");
		}
		if("<%=btnid%>"=="viewBtn")
		{
				jQuery("#dateinssue").html("<%=dateinssue%>");
		}
	
		
		
		jQuery("#licensestatu").val("<%=licensestatu%>");
		
		jQuery("#annualinspection").html("<%=annualinspection%>");
		jQuery("#annualdate").val("<%=annualinspection%>");
		
		
		jQuery("#departinssue").val("<%=departinssue%>");
		
		//jQuery("#workflowspan").html("<a style='color:blue;' viewVersion='N' requestid='<%=requestid%>' href=javascript:onWorkflowAttachmentOpen('<%=requestid%>','<%=requestname%>')><%=requestname%></a>");
		
		//有问题
		jQuery("#test").html("<%=Util.toHtml(scopebusiness)%>");
		jQuery("#scopebusiness").val(jQuery("#test").text());
		
		jQuery("#memo").val("<%=memo%>");
		jQuery("#licensename").val("<%=licensename%>");
		jQuery("#licensetype").val("<%=licensetype%>");
		
		jQuery("#affixdoc").val("<%=affixdoc%>");
		if(jQuery("#affixdoc").val()!=""){
			jQuery("#source").css("display","");
		}
		
		if("<%=licensetype%>"==1){
			jQuery("#businessOnlyDiv").css("display","");
			jQuery("#registercapital").val("<%=registercapital%>");
			jQuery("#paiclupcapital").val("<%=paiclupcapital%>");
			jQuery("#currencyid").val("<%=currencyid%>");
			jQuery("#currencyname").html("<%=currencyname%>");
			jQuery("#corporatdelegate").val("<%=corporatdelegate%>");
			jQuery("#licenseregistnum").val("<%=licenseregistnum%>");
			jQuery("#companytype").val("<%=companytype%>");
		}else{
			jQuery("#businessOnlyDiv").css("display","none");
		}
		
	}
	/*打开选择证照DIV*/
	function onLicenseDivOpen(){
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","80px").css("left","400px");
		jQuery("#wBoxContent").css("width","335px").css("height","225px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31006,user.getLanguage())%>");
		jQuery("#wBoxContent").load("ChooseLicenseList.jsp");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		jQuery("#source").css("display","none");
	}
	
	/*打开选择流程DIV*/
	function onWorkflowDivOpen(){
		
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","268px").css("left","30px");
		jQuery("#wBoxContent").css("width","476px").css("height","225px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31025,user.getLanguage())%>");
		jQuery("#wBoxContent").load("/cpcompanyinfo/ChooseWorkflow.jsp");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		jQuery("#source").css("display","none");
	}
	
	/*打开流程附件DIV*/
	function onWorkflowAttachmentOpen(requestid,requestname){
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","130px").css("left","30px");
		jQuery("#wBoxContent").css("width","400px").css("height","225px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31026,user.getLanguage())%>");
		jQuery("#wBoxContent").load("/cpcompanyinfo/WorkflowAtOperation.jsp?requestid="+requestid+"&requestname="+requestname+"&isNeedReSearch="+jQuery("#isNeedReSearch").val()+"&licenseid=<%=Util.null2String(request.getParameter("licenseid"))%>"+"&viewVersion="+jQuery('#workflowspan').find("a").attr("viewVersion")+
		"&versionId="+jQuery("#versionId").val()+"&isReEdit="+jQuery("#isReEdit").val()+"&affixidsReEdit="+jQuery("#affixidsReEdit").val());
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		jQuery("#source").css("display","none");
	}
	
	/*打开版本新增DIV*/
	function onversionAddDivOpen(){
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","130px").css("left","260px");
		jQuery("#wBoxContent").css("width","335px").css("height","225px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31011,user.getLanguage())%>");
		jQuery("#wBoxContent").load("CompanyVersionMaint.jsp?licenseid=<%=licenseid%>&oneMoudel=license&companyid=<%=companyid%>");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		jQuery("#source").css("display","none");
	}
	
	/*打开版本管理页面*/
	function openVersionManage(){
		jQuery("#wBoxContent").html("");
		//谷歌浏览器下需要提供px，否则不兼容
		jQuery("#wBox").css("top","130px").css("left","200px");
		jQuery("#wBoxContent").css("width","490px").css("height","300px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(19450,user.getLanguage())%>");
		jQuery("#wBoxContent").load("/cpcompanyinfo/CompanyVersionManage.jsp?licenseid=<%=licenseid%>&oneMoudel=license&showOrUpdate=<%=showOrUpdate%>");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		jQuery("#source").css("display","none");
	}
	
	/*关闭选择证照DIV*/
	function onLicenseDivClose() {
		jQuery("#wBox_overlay").removeClass("wBox_overlayBG").addClass("wBox_hide");
		jQuery("#licenseDiv").css("display","none");
		//jQuery("#saveLicenseBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
		jQuery("#source").css("display","");
	} 
	/*点击证照名称后 操作*/
	function clickLicenseName2List(licenseaffixid,licensename,licensetype){
		//jQuery("#licensename").val(licensename);
		//jQuery("#licenseaffixid").val(licenseaffixid);
		var o4params = {
				method:"haved",
				companyid:"<%=companyid%>",
				licenseaffixid:licenseaffixid,
				licenseid:"<%=licenseid%>",
				btnid:"<%=btnid%>"
			}
		jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(data){
			if(licensetype=='1'){//判断是否营业执照，营业执照固定为1
				jQuery("#businessOnlyDiv").css("display","");
			}else{
				jQuery("#businessOnlyDiv").css("display","none");
			}
			if(jQuery.trim(data)=="haved"){
				//所选证照已在该公司存在
				alert("<%=SystemEnv.getHtmlLabelName(31027,user.getLanguage())%>！");
				jQuery("#newimg").html("<img src='images/O_44_wev8.jpg' iswarn='warning' class='ML5' style='margin-bottom: -3px;'  />");
				jQuery("#licensename").val("");
				jQuery("#saveLicenseBtn").css("display","none");
				if(licensetype=='1'){
					jQuery("#businessOnlyDiv").css("display","none");
				}
			}else{
					jQuery("#newimg").html("");
					jQuery("#saveLicenseBtn").css("display","");
					if(licensetype=='1'){
						jQuery("#businessOnlyDiv").css("display","");
					}
					
			}
			
			onLicenseDivClose();
		});
	}
	
	
	
	function saveDate(){
		
		var begintime=jQuery.trim(jQuery("#begintime").val());
		var endtime=jQuery.trim(jQuery("#endtime").val());
		if(""!=begintime&&""!=endtime){
			if(opinionStartTimeEndTime(begintime,endtime)==false){
					alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())  %>!");
					return;
			}
		}
		jQuery("#saveLicenseBtn").attr("href","javascript:void(0);");	//不让保存重复点击
		if(checkForm()){
				var truthBeTold = window.confirm("<%=SystemEnv.getHtmlLabelName(31009,user.getLanguage())%>"); 
				if (truthBeTold) { 
					onversionAddDivOpen();
				} else {
					var truth4Told = window.confirm("<%=SystemEnv.getHtmlLabelName(31010,user.getLanguage())%>？"); 
					if(truth4Told){
						StartUploadAll();
						checkuploadcomplet();
					}else{
						//jQuery("#saveLicenseBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
					}
				}
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
			//jQuery("#saveLicenseBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
		}
	} 
	

	function delImg(imgfileDiv,docid){
		var affix123doc = jQuery("#affixdoc").val().split(",");
		var tempdocid = "";
		for(i=0;i<affix123doc.length-1;i++){
			if(affix123doc[i]!=docid){
				tempdocid+=affix123doc[i]+",";
			}
		}
		jQuery("#affixdoc").val(tempdocid);
		jQuery(imgfileDiv).css("display","none");
		jQuery("#source").find("img").attr("src","images/nopic_wev8.jpg");
		jQuery("#_s2uiContent").css("display","none");
	}
	
	var tempnumFilesUploaded = 0;
	/*flash上传需要的方法*/
	function StartUploadAll() {  
        eval("SWFUpload.instances.SWFUpload_0.startUpload()");
        // files_queued当前上传队列中存在的文件数量        
        tempnumFilesUploaded = eval("upfilesnum+=SWFUpload.instances.SWFUpload_0.getStats().files_queued"); 
	}
	function checkuploadcomplet(){	
	    if(upfilesnum>0){    	
	        setTimeout("checkuploadcomplet()",1000);       	
	    }else{
	       saveBusinessLicense();
	    }
	}
	
	
	
	/*版本方法 开始*/
	
	
	function saveversionDate(){
		jQuery("#isaddversion").val("add");
	//	jQuery("#method").val("add");
		StartUploadAll();
		checkuploadcomplet();
	}
	
	
	/*删除一行或多行*/
	function dodel_gd(){
		var versionids="";
		var _versionnum="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
				_versionnum+= jQuery(this).attr("_versionnum")+",";
			}
		});
		if(versionids.length == 0){
			alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>！");
			return;
		}
		var truthBeTold = window.confirm("<%=SystemEnv.getHtmlLabelName(31013,user.getLanguage())%>？"); 
		if (truthBeTold) { 
			jQuery('#webTable2version tr').each(function(){
				if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
				{
					var o4params={method:"delVersion",versionids:versionids,_versionnum:_versionnum}
					jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(){
						
					});
					jQuery(this).remove();
				}
			});
		}
	}
	
	function viewVersion(){
		var versionids="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
			}
		});

		if(versionids.length == 0){
				alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage()) %>！");
		}else  if(versionids.split(",").length>2){
			alert("<%=SystemEnv.getHtmlLabelName(31014,user.getLanguage())%>！");
		}else{
			jQuery("#versionId").val(versionids);//给版本号赋值
			var o4params = {method:"viewVersion",versionids:versionids}
			jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(data){
				jQuery("#licenseaffixid").val(data[0]["licenseaffixid"]);
				jQuery("#registeraddress").val(data[0]["registeraddress"]);
				jQuery("#corporation").val(data[0]["corporation"]);
				jQuery("#recordnum").val(data[0]["recordnum"]);
				jQuery("#usefulbegindate01").html(data[0]["usefulbegindate"]);
				jQuery("#begintime").val(data[0]["usefulbegindate"]);
				
				jQuery("#spanTitle").html("");
				jQuery("#spanTitle").html("<%=SystemEnv.getHtmlLabelName(31028,user.getLanguage())%>["+data[1]+"]");
				
				jQuery("#usefulenddate").html(data[0]["usefulenddate"]);
				jQuery("#endtime").val(data[0]["usefulenddate"]);
				
				
				jQuery("#usefulyear").val(data[0]["usefulyear"]);
				jQuery("#inssuedate").val(data[0]["dateinssue"]);
				jQuery("#dateinssue").html(data[0]["dateinssue"]);
				
				
				jQuery("#licensestatu").val(data[0]["licensestatu"]);
				jQuery("#annualinspection").html(data[0]["annualinspection"]);
				jQuery("#annualdate").val(data[0]["annualinspection"]);
				
				
				jQuery("#departinssue").val(data[0]["departinssue"]);
				jQuery("#scopebusiness").val(data[0]["scopebusiness"]);
				jQuery("#memo").val(data[0]["memo"]);
				jQuery("#licensename").val(data[0]["licensename"]);
				jQuery("#licensetype").val(data[0]["licensetype"]);
				
				jQuery("#affixdoc").val(data[0]["affixdoc"]);
			//	jQuery("#workflowspan").html("<a style='color:blue;' viewVersion='Y' requestid='' href=javascript:onWorkflowAttachmentOpen('"+data[0]["requestid"]+"','"+data[0]["requestname"]+"')>"+data[0]["requestname"]+"</a>");
				
				if(data[0]["licensetype"]==1){
					jQuery("#businessOnlyDiv").css("display","");
					jQuery("#registercapital").val(data[0]["registercapital"]);
					jQuery("#paiclupcapital").val(data[0]["paiclupcapital"]);
					jQuery("#currencyid").val(data[0]["currencyid"]);
					jQuery("#currencyname").html(data[0]["currencyname"]);
					
					jQuery("#corporatdelegate").val(data[0]["corporatdelegate"]);
					jQuery("#licenseregistnum").val(data[0]["licenseregistnum"]);
					jQuery("#companytype").val(data[0]["companytype"]);
				}else{
					jQuery("#businessOnlyDiv").css("display","none");
				}
				var imgid4db = data[0]["imgid"].split("|");
				if(imgid4db.length>1){jQuery("#source").css("display","");}
				var imgname4db = data[0]["imgname"].split("|");
				jQuery("#source").find("img").attr("src","/weaver/weaver.file.FileDownload?fileid="+imgid4db[0]);
				
				var ispdf02="";
				var imgname4db_0=imgname4db[0];
				//得到第一个附件的类型
				if(imgname4db_0.lastIndexOf(".")>0){
				if(imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".pdf")){
					ispdf02 = "1";
				}else if(imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".jpg")
						|| imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".bmp")
						|| imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".jpeg")
						|| imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".png")
				){
					ispdf02 ="0";
				}else{
					ispdf02="2";
				}
				}
				changePDF(imgid4db[0],ispdf02);
				if(jQuery("#affixcpdosDIV").find("div").length/3>0){
					jQuery("#affixcpdosDIV").html("");
				}
				var html4doc="";
				for(i=0;i<imgid4db.length - 1;i++){
				
				
				 ispdf02="";
				 imgname4db_0=imgname4db[i];
				//得到第一个附件的类型
				if(imgname4db_0.lastIndexOf(".")>0){
				if(imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".pdf")){
					ispdf02 = "1";
				}else if(imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".jpg")
						|| imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".bmp")
						|| imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".jpeg")
						|| imgname4db_0.substring(imgname4db_0.lastIndexOf("."),imgname4db_0.length).toLowerCase()==(".png")
				){
					ispdf02 ="0";
				}
				}
				
					html4doc += "<div id='imgfileDiv"+i+"' style='background-color: #F7F7F7;width:291px;height:20px;padding-left:4px;border: solid 1px #E8E8E8;padding: 4px;margin-bottom: 5px;'>";
					html4doc+="<div style='width:80%;float:left;' >";
					html4doc+="<A id='pdflinkid"+i+"' href=\"javascript:changePDF('"+imgid4db[i]+"','"+ispdf02+"')\" class='aContent0 FL'>"+imgname4db[i]+"</A>";
					html4doc+="</div>";
					html4doc+="<div style='padding-right:0px;float:right;padding-top:0px'>";
					html4doc+="<a href='/weaver/weaver.file.FileDownload?fileid="+imgid4db[i]+"&download=1'><img src='images/downLoadPic_wev8.gif'  title='<%=SystemEnv.getHtmlLabelName(22629,user.getLanguage())%>'  ></a>";
					html4doc+="</div>";
					html4doc+="</div>";
				}
				jQuery("#affixcpdosDIV").html(html4doc);
				
				jQuery("#save_H").hide();
				jQuery("#see_img").hide();
				jQuery("#licensename").addClass("BoxW300");
				jQuery(".Clock").hide();
				jQuery("#cu_idH").hide();
				jQuery("#licenseAffixUpload").hide();
				jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
				jQuery(".OSelect[id!='searchSL']").removeClass("OSelect").addClass("OSelect2").focus(function(){this.blur();});
				onLicenseDivClose();
			},"json");
		}
	}
	
	function getVersion(){
		var versionids="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
			}
		});
		if(versionids.split(",").length>2 || versionids.length == 0){
			alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>！");
		}else{
			jQuery("#wBoxContent").html("");
			jQuery("#wBox").css("top","130px").css("left","550px");
			jQuery("#wBoxContent").css("width","335px").css("height","225px");
			jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31018,user.getLanguage())%>");
			jQuery("#wBoxContent").load("CompanyVersionMaint.jsp?versionids="+versionids+"&oneMoudel=license&companyid=<%=companyid%>&licenseid=<%=licenseid%>");
			jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
			jQuery("#licenseDiv").css("display","");
			
		}
		
	}
	
	/*版本方法 结束*/
	
	
	function flashChecker() {
		var hasFlash = 0; //是否安装了flash
		var flashVersion = 0; //flash版本
		var isIE = /*@cc_on!@*/0; //是否IE浏览器
		if (isIE) {
			var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
			if (swf) {
				hasFlash = 1;
				VSwf = swf.GetVariable("$version");
				flashVersion = parseInt(VSwf.split(" ")[1].split(",")[0]);
			}
		} else {
			if (navigator.plugins && navigator.plugins.length > 0) {
				var swf = navigator.plugins["Shockwave Flash"];
				if (swf) {
					hasFlash = 1;
					var words = swf.description.split(" ");
					for ( var i = 0; i < words.length; ++i) {
						if (isNaN(parseInt(words[i])))
							continue;
						flashVersion = parseInt(words[i]);
					}
				}
			}
		}
		return {
			f :hasFlash,
			v :flashVersion
		};
	}
	
	function changePDF(pdfid,ispdf02){
			jQuery("#source").find("iframe").attr("src","/cpcompanyinfo/PdforImgShow/PdforImgindex.jsp?sjdata=<%=sjdata %>&imgid="+pdfid+"&ispdf="+ispdf02);
	}
	
	/*上传空间判断是否安装了flash控件*/
	var fls = flashChecker();
	var flashversion = 0;
	if (fls.f)
		flashversion = fls.v;
	if (flashversion < 9)
		document.getElementById("fsUploadProgress").innerHTML = "<br>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("31512",user.getLanguage())%>:<br><br><a target='_blank' href='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=shockwaveFlash'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("31510",user.getLanguage())%><a>	<br><br><a href='/resource/install_flash9_player.exe' target='_blank'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("31511",user.getLanguage())%></a>";	
	
</script>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="cpcompany"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("31435",user.getLanguage())%>'/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span  id="save_H">	
				<a id="saveLicenseBtn" href="javascript:void(0);"  class="hover">
					<input class="e8_btn_top" type="button" value="<%=SystemEnv.getHtmlLabelNames("31005",user.getLanguage())%>" onclick="saveDate();" />
				</a>
			</span>	
			<span  >	
			<a href="javascript:openVersionManage();" id="versionManage" class="hover">
				<input  class="e8_btn_top" type="button"  value="<%=SystemEnv.getHtmlLabelNames("19450",user.getLanguage())%>" onclick="openVersionManage();" />
			</a>
			</span>	
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form>
<!--表头浮动层 start-->
<input type="hidden" id="method" />
<input type="hidden" id="isaddversion"/>

<span id="workflowspan"></span>
<input type="hidden" name="affixIds" id="affixIds" /> 
<input type="hidden" name="requestid" id="requestid"  />
<input type="hidden" name="requestname" id="requestname"  /> 
<input type="hidden" name="isNeedReSearch" id="isNeedReSearch" value="N" /> 
<input type="hidden" name="versionId" id="versionId" /> 
<input type="hidden" name="isReEdit" id="isReEdit" value="N"/>
<input type="hidden" name="affixidsReEdit" id="affixidsReEdit" />

<div>
<%
	if(!btnid.equals("newBtn")){
%>
	<div style="width:600px!important;float:left!important;">
<%
	}
%>


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="companyname" id="companyname" class="OInput3 BoxW300" readonly="true" onfocus="this.blur();" /> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(30945,user.getLanguage())%></wea:item>
		<wea:item>
			
				<%
					String sql = "select affixindex,licenseaffixid,licensename,licensetype from CPLMLICENSEAFFIX order by affixindex";
					rs.execute(sql);					
				%>
		<input type="hidden" name="licensename" id="licensename" value="<%=licensename %>" />
		<SELECT id="licenseaffixid" name="licenseaffixid" style="width:150px"  onchange='onSelected()'>
           <option selected value="0"></option>
			<%
				while(rs.next())
				{
					if(rs.getString("licensename").equals(licensename)){
						%>
							<option  selected value="<%=rs.getString("licenseaffixid")%>"><%=rs.getString("licensename") %></option>
						<%
					}else{
						%>
						<option   value="<%=rs.getString("licenseaffixid")%>"><%=rs.getString("licensename") %></option>
						<%
					}
				}
			%>	
	 </SELECT>
	 	<%if(btnid.equals("editBtn") || btnid.equals("viewBtn")){
	 		%>
	 			<SPAN id=blicense></SPAN>
	 		<% 
	 	}else{
	 		%>
	 			<SPAN id=blicense><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
	 		<%
	 	} %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31133,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="registeraddress" id="registeraddress" 	class="OInput2 BoxW300"  maxlength="40" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(23797,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="corporation" id="corporation" class="OInput2 BoxW300"  maxlength="40"   onblur="displayimg(this)"/>
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" style="margin-bottom: -3px;" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(26609,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="recordnum" id="recordnum" class="OInput2 BoxW300"  maxlength="40"   onblur="displayimg(this)"/>
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" style="margin-bottom: -3px;" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31029,user.getLanguage())%></wea:item>
		<wea:item>
		
			<BUTTON class=calendar  type="button"  onclick="onShowDate(document.getElementById('usefulbegindate01'),document.getElementById('begintime'))"></BUTTON>
			<input type="hidden" name="begintime"   id="begintime" />
			<SPAN id="usefulbegindate01">	
				<img src="images/O_44_wev8.jpg"   class="ML5" />
			</SPAN>
			-
			<BUTTON class=calendar  type="button"   onclick="onShowDate(document.getElementById('usefulenddate'),document.getElementById('endtime'))"></BUTTON>
			<input type="hidden" name="endtime"  id="endtime" />
			<SPAN id="usefulenddate" >
				<img src="images/O_44_wev8.jpg"   class="ML5" />
			</SPAN> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(26852,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="usefulyear" style="width:180px;" id="usefulyear" class="OInput2 BoxW30"  maxlength="3" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  onpaste="javascript: return false;" />
			<%=SystemEnv.getHtmlLabelName(26577,user.getLanguage())%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(28339,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON  class=calendar type="button"  onclick="onShowDate(document.getElementById('dateinssue'),document.getElementById('inssuedate'))"></BUTTON>
			<input type="hidden" id="inssuedate" name="inssuedate"  />
			<span id="dateinssue">
				<img src="images/O_44_wev8.jpg"   class="ML5" style="margin-bottom: -3px;" />
			</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31030,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=calendar  onclick="onShowDate(document.getElementById('annualinspection'),document.getElementById('annualdate'))"></BUTTON>
			<input type="hidden" name="annualdate"   id="annualdate" >
			<span id="annualinspection">
				<img src="images/O_44_wev8.jpg"   class="ML5" style="margin-bottom: -3px;" />
			</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31031,user.getLanguage())%></wea:item>
		<wea:item>
			<textarea name="scopebusiness" id="scopebusiness" class="OInput2 BoxW300" onblur="displayimg(this)"></textarea>
			<span >
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" style="margin-bottom: -3px;" />
		    </span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31020,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="departinssue" id="departinssue"  class="OInput2 BoxW300" onblur="displayimg(this)"  maxlength="40" />
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" style="margin-bottom: -3px;" />
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></wea:item>
		<wea:item>
		
				
				<%if(!CompanyInfoTransMethod.CheckPack("1")){out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(31004,user.getLanguage())+"！</span>");}%>
					<div id="licenseAffixUpload"  >
					<input type="hidden" name="affixdoc" id="affixdoc">
						<span> 
							<span id='spanButtonPlaceHolder'></span><!--选取多个文件-->
							<!-- <img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" style="margin-bottom: -3px;" /> -->
						</span>
						&nbsp;&nbsp;
						<span style="color: #262626; cursor: hand; TEXT-DECORATION: none;<%if(!CompanyInfoTransMethod.CheckPack("1")){out.println("display: none;");}%>"
							disabled id="btnCancel_upload" >
							<span><img src="/js/swfupload/delete_wev8.gif" border="0" onClick="oUploader.cancelQueue()"> </span> <span
							style="height: 19px"> <font style="margin: 0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage()) %>
							
							(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage()) %>100<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage()) %>)
							</font> <!--清除所有--> </span> </span>
						<div id="divImgsAddContent" style="overflow: auto;">
							<div></div>
							<div class="fieldset flash" id="fsUploadProgress"></div>
							<div id="divStatus"></div>
						</div>
						
						<span  id="_fximg">
								<img src='/images/BacoError_wev8.gif' align=absMiddle  >
						 </span>
					</div>
					<div id="affixcpdosDIV">
						<%
							String isdoc="";
							if(!"".equals(affixdoc))
							{
								
								DocComInfo dc=new DocComInfo();						
								String[] slaves=affixdoc.split(",");
								for(int i=0;i<slaves.length;i++)
								{
									String tempid="asid"+slaves[i];
								
									out.println("<div id='imgfileDiv"+i+"' style='background-color: #F7F7F7;width:291px;height:20px;padding-left:4px;border: solid 1px #E8E8E8;padding: 4px;margin-bottom: 5px;' class='progressWrapper'>");
								
								    String ispdf02="";
									String filename="";
									String fileid="";
									rs.execute("select imagefileid,imagefilename from imagefile where imagefileid = "+slaves[i]);
									if(rs.next()){
										ispdf02="";
										filename = rs.getString("imagefilename");
										fileid= rs.getString("imagefileid");
										if(filename.lastIndexOf(".")>0){
										if(filename.substring(filename.lastIndexOf("."),filename.length()).equalsIgnoreCase(".pdf")){
											ispdf02 = "1";
										}else if(filename.substring(filename.lastIndexOf("."),filename.length()).equalsIgnoreCase(".jpg")
											|| filename.substring(filename.lastIndexOf("."),filename.length()).equalsIgnoreCase(".bmp")
											|| filename.substring(filename.lastIndexOf("."),filename.length()).equalsIgnoreCase(".jpeg")
											|| filename.substring(filename.lastIndexOf("."),filename.length()).equalsIgnoreCase(".png")
											){
												ispdf02 ="0";
											}else{
												ispdf02 ="2";
											}
										}
									}
									out.println("<div style='width:80%;float:left;' >");
									String str="<A id='pdflinkid"+i+"' href='javascript:changePDF("+fileid+","+ispdf02+")' class='aContent0 FL'>"+filename+"</A>";
									//输出文档主题，提供下载
									out.println(str);
									out.println("</div>");
									
									//out.println("<div style='width:40%;float:left;'>");
									//输出文档创建时间
									//out.println(dc.getDocCreateTime(slaves));
									//out.println("</div>");
									
									
									out.println("<div style='padding-right:0px;float:right;padding-top:0px'>");
									
									//out.println("文档创建着id"+dc.getDocCreaterid(slaves[i]));
									//getDocOwnerid
									
									//if(dc.getDocCreaterid(slaves[0]).equals(userid+""))//当前用户是文档的创建者
									if(	"viewBtn".equals(btnid))
									{		
									// document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&coworkid="+coworkid;
									
										//输出下载文档超链接									
										out.println("<a href='/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1'><img src='images/downLoadPic_wev8.gif'  title='"+SystemEnv.getHtmlLabelName(22629,user.getLanguage())+"'  ></a>");
										
									}else//编辑
									{
										//输出删除文档超链接												
										//isdoc = "affixdoc";
										out.println("<a href='/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1'><img src='images/downLoadPic_wev8.gif'  title='"+SystemEnv.getHtmlLabelName(22629,user.getLanguage())+"'  ></a>");
										out.println("<img src='images/delwk_wev8.gif' onclick=delImg(document.getElementById('imgfileDiv"+i+"'),"+slaves[i]+") title='"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"'></a>");
									}
								
									out.println("</div>");					
									out.println("</div>");
								}
							}
						%>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(20820,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type="text" name="memo" id="memo" class="OInput2 BoxW300" />
		</wea:item>
		
	</wea:group>
</wea:layout>

<div id="businessOnlyDiv" style="display:none">	
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("84091",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(20668,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="registercapital" id="registercapital" 	class="OInput2 BoxW60"  onblur="displayimg(this)" />
			<span >
			<img src="images/O_44_wev8.jpg" iswarn="warning"  align='absMiddle'/>
		   </span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31032,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="paiclupcapital" id="paiclupcapital" class="OInput2 BoxW60"   onblur="displayimgNext(this)" />
			<span >
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5"  align='absMiddle' />
		   </span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
		<wea:item>
		
					<%
					if("newBtn".equals(btnid) || "editBtn".equals(btnid)){
						%>	
						<brow:browser viewType="0" name="currencyid" browserValue='<%=currencyid %>' browserSpanValue='<%=currencyname %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"  
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=12"  />
						<%
					}else{
						%>	
						<span name="currencyid"  value="<%=currencyid %>"  ><%=currencyname %></span>
						<%
					}
					%>	
							
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(20656,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="corporatdelegate" id="corporatdelegate" class="OInput2 BoxW60"  onblur="displayimg(this)"/>
			<span >
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5"   align='absMiddle'/>
		    </span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(30976,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="companytype" id="companytype" class="OInput2 BoxW120"  onblur="displayimg(this)"/>
			<span >
			<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" align='absMiddle'/>
		 	</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(23798,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="licenseregistnum" id="licenseregistnum" class="OInput2 BoxW271"   onblur="displayimg(this)"/> 
			<span >
				<img src="images/O_44_wev8.jpg" iswarn="warning" class="ML5" align='absMiddle' />
			</span>
		</wea:item>
				
		<wea:item></wea:item>
		<wea:item>
		</wea:item>
		
		<wea:item></wea:item>
		<wea:item>
		</wea:item>
</wea:group>
</wea:layout>
</div>
<%
	if(!btnid.equals("newBtn")){
%>
	</div>
<%
	}
%>
	<div class="BLayerRight2 FL" style="float:right;">
	 <% if(!"".equals(ispdf)){ %>
	 	<div id="source" style="width:370px;height:300px;position: absolute;left:610px;top:200px;">
			<iframe src="/cpcompanyinfo/PdforImgShow/PdforImgindex.jsp?sjdata=<%=sjdata %>&imgid=<%=imgid%>&ispdf=<%=ispdf %>"   frameborder=no  scrolling="no"  style="width:400px;height:300px;">
			</iframe>
		</div>
		<div id="_s2uiContent" style="height:50px;width:399px;position: absolute;left:518px;top:200px;">
			<jsp:include page="select2UISlider.jsp" flush="true"/>
		</div>
		<%} else{
			%>
		<div style="height:50px;width:399px;position: absolute;left:518px;top:200px;">
		</div>
			<%
		}%>
	</div> 

</div>
<!-- 证照弹出层 -->

<div style="clear:both;display:none" id="licenseDiv">
	<div id="wBox" style="top:80px;left:400px;"><!-- 定义层在什么位置上 -->
		<div class="wBox_popup">
    		<table>
    			<tbody>
    				<tr><td class="wBox_tl"/><td class="wBox_b"/><td class="wBox_tr"/></tr>
    				<tr><td class="wBox_b"></td>
    					<td>
		   					<div class="wBox_body">
		       					<table class="wBox_title">
		       						<tr>
		          						<td class="wBox_dragTitle"><div class="wBox_itemTitle"><%=SystemEnv.getHtmlLabelName(31006,user.getLanguage()) %>	</div></td>
		          						<td width="20px" title="<%=SystemEnv.getHtmlLabelNames("309",user.getLanguage())%>" onclick="javascript:onLicenseDivClose();"><div class="wBox_close"></div></td>
		       						</tr>
		     					</table>
		     					<div class="wBox_content" id="wBoxContent" style="width:335px;height:325px;overflow-y:auto;">
		      					<!-- 定义层里面的内容 -->
		     					</div>
		   					</div>
        				</td>
        				<td class="wBox_b"></td></tr>
        			<tr><td class="wBox_bl"></td><td class="wBox_b"></td><td class="wBox_br"></td></tr>
        		</tbody>
        	</table>
   		</div>
	</div>
</div> 

</form>
 <!-- 遮罩层 start -->
<div id='wBox_overlay' class='wBox_hide' style="clear:both;"></div>
<!-- 遮罩层 end --> 
<a href=""  id="load_img"></a>

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

<script language="javascript">
	
	function onSelected(){
		
		var name = jQuery("#licenseaffixid").find("option:selected").text();
		var val =  jQuery("#licenseaffixid  option:selected").val();
		//alert(name);
	//	alert(val);
		jQuery("#licensename").val(name);
		if(val==0){
			jQuery("#blicense").css("display","");
			
		}else{
			jQuery("#blicense").css("display","none");
		}
		
		var type;
		if(val==1){
			type = 1 ;
		}
		clickLicenseName2List(val,name,type);
	}

	/*打开币种DIV*/
	function onCurrOpen(obj){
		var tempid= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp");
		if(tempid){
			if(tempid.name){
				jQuery(obj).next().html(tempid.name);
				jQuery(obj).next().next().val(tempid.id);
				jQuery(obj).next().next().next().html("");
			}else{
				jQuery(obj).next().html("");
				jQuery(obj).next().next().val("");
				jQuery(obj).next().next().next().html("<img src=\"images/O_44_wev8.jpg\" iswarn=\"warning\"  align='absMiddle'/>");
			}
		}else{
			
		}
		//alert(tempid.id);
		//alert(tempid.name);
	}
	
function checkimg(obj){
		if($.trim($(obj).val())==""){
				$("#newimg").html("<img src='images/O_44_wev8.jpg' iswarn='warning' class='ML5' style='margin-bottom: -3px;'  />");
		}else{
				$("#newimg").html("");
				
		}
}

var upfilesnum=0;//计数器
var oUploader;//一个SWFUpload 实例
var mode="add";//当期模式

var settings = {   
	
	flash_url : "/js/swfupload/swfupload.swf",     
	upload_url: "/cpcompanyinfo/action/uploaderOperate.jsp",
	post_params: {
                "mainId": "-1",
                "subId":"-1",
                "secId":"-1"
            },
	file_size_limit :"100MB",							//单个文件大小
	file_types : "*.*", 	//过滤文件类型
	file_types_description : "<%=SystemEnv.getHtmlLabelName(128195,user.getLanguage())%>",					//描述，会添加在类型前面
	file_upload_limit : "50",							//一次性上传几个文件
	file_queue_limit : "0",								
	//customSettings属性是一个空的JavaScript对象，它被用来存储跟SWFUpload实例相关联的数据。
	//它的内容可以使用设置对象中的custom_settings属性来初始化
	custom_settings : {
		progressTarget : "fsUploadProgress",
		cancelButtonId : "btnCancel_upload"
		
	},
	debug: false,
	
	button_image_url : "/js/swfupload/add_wev8.png",	// Relative to the SWF file
	button_placeholder_id : "spanButtonPlaceHolder",
	
	button_width: 100,//“上传"按钮的宽度
	button_height: <%if(!CompanyInfoTransMethod.CheckPack("1")){out.println("0");}else{out.println("18");}%>,//“上传”按钮的高度
	button_text : '<span class="button">'+"<%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%>"+'</span>',//“上传”按钮的文字
	button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
	button_text_top_padding: 0,//“上传"按钮的top_padding
	button_text_left_padding: 18,//“上传"按钮的left_padding
		
	button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
	button_cursor: SWFUpload.CURSOR.HAND,//“上传"按钮的鼠标悬浮样式
	
	file_queued_handler : fileQueued,
	file_queue_error_handler : fileQueueError,
	
	file_dialog_complete_handler : function(){	//设置事件回调函数,file_dialog_complete_handler为类对象的属性		
		//让按钮失效
		//document.getElementById("btnCancel_upload").disabled = true;
		//alert("按钮细小");
		//fileDialogComplete				
	},
	//设置事件回调函数,upload_start_handler为类对象的属性,在文件往服务端上传之前触发此事件，可以在这里完成上传前的最后验证以及其他你需要的操作，例如添加、修改、删除post数据等。
	//在完成最后的操作以后，如果函数返回false，那么这个上传不会被启动，并且触发uploadError事件（code为ERROR_CODE_FILE_VALIDATION_FAILED），
	//如果返回true或者无返回，那么将正式启动上传
	upload_start_handler : uploadStart,	
	upload_progress_handler : uploadProgress,//设置事件回调函数,upload_progress_handler为类对象的属性
	upload_error_handler : uploadError,//设置事件回调函数,upload_error_handler为类对象的属性
	queue_complete_handler : queueComplete,//设置事件回调函数,queue_complete_handler为类对象的属性

	//文件上传成功，调用下面的方法
	upload_success_handler : function (file, server_data) {	//设置事件回调函数,upload_success_handler为类对象的属性
		if(mode=="add"){
			var imageid=server_data.replace(/(^\s*)|(\s*$)/g, "");	
			//得到文档id,得到文件的名字	
			document.getElementById("affixdoc").value += imageid +",";
		}

	},	
	//文件上传成功，调用下面的方法			
	upload_complete_handler : function(){	
		upfilesnum=upfilesnum-1;//计数器减减
	}
	
};	

function queueComplete(numFilesUploaded) {
	var status = document.getElementById("divStatus");
	status.innerHTML = tempnumFilesUploaded + " file" + (tempnumFilesUploaded === 1 ? "" : "s") + " uploaded.";
}
try{
	oUploader = new SWFUpload(settings);//返回:一个SWFUpload 实例
	
} catch(e){alert(e)}


var timer = setInterval(showmustinput , 400);
function showmustinput() {
			var _temp=0;
			var t_length=$(".progressWrapper").each(function(){
						//obj.css("display")=="none"
						//alert($(this).css("display"));
						if($(this).css("display")=="block"){
							_temp++;
						}
			});
			if(_temp>0){
				   $("#_fximg").hide();
			}else{
				   $("#_fximg").show();
			}
         /*  var sta = oUploader.getStats();
          if (sta.files_queued == 0) {
             $("#obj").html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
          } else {
             $("#obj").html("");
          } */
         
}
function showTb(obj){

	if("<%=btnid%>"=="newBtn")
	{
	//31412
	var o4params = {
				licensename:encodeURI($.trim(obj.value+"")),
				method:"haved",
				companyid:"<%=companyid%>",
				judgetype:"1"
			}
	jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(data){
		var datasz=data.split("_");
		if(datasz[0]=="haved"){
			//所选证照已在该公司存在
			jQuery("#licenseaffixid").val(datasz[1]);//获得该证照类型的id
			alert("<%=SystemEnv.getHtmlLabelName(31027,user.getLanguage())%>！");
			jQuery("#newimg").html("<img src='images/O_44_wev8.jpg' iswarn='warning' class='ML5' style='margin-bottom: -3px;'  />");
			jQuery("#licensename").val("");
			jQuery("#saveLicenseBtn").css("display","none");
			
			jQuery("#businessOnlyDiv").css("display","none");
				
		}else{
		
				jQuery("#licenseaffixid").val(datasz[1]);//获得该证照类型的id
				if($.trim(obj.value)!=""){
				jQuery("#newimg").html("");
				}
				jQuery("#saveLicenseBtn").css("display","");
				
				if($.trim(obj.value)=="<%=SystemEnv.getHtmlLabelName(31412,user.getLanguage())%>"){
					jQuery("#businessOnlyDiv").css("display","");
				}else{
						jQuery("#businessOnlyDiv").css("display","none");
				}
		}
	});
	}
}

</script>

