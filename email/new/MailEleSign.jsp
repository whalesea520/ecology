
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="esRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/email/css/base_wev8.css" />

<%
	/*
	String userid = Util.null2String(request.getParameter("userid"));
	if("".equals(userid)) {
	    userid = String.valueOf(user.getUID());
	}
	*/
	String userid = String.valueOf(user.getUID());
	String signid = Util.null2String(request.getParameter("signid"),"0");
	String cardtop = Util.null2String(request.getParameter("cardtop"),"0");
	String cardleft = Util.null2String(request.getParameter("cardleft"),"0");
	int isedit = Integer.parseInt(Util.null2String(request.getParameter("isedit"),"0"));
	rs.executeProc("HrmResource_SelectByID",userid);
	rs.next();
	
    esRs.execute("select * from MailElectronSign where signid = " + signid);
	String lastname = "";
	String jobname = "";
	String email = "";
	String jobtitle = "";
	String location = "";
	String telephone = "";
	String mobile = "";
	String fax = "";
	String url = "";
	String locationid = "";
	String departmentid = "";
	String selected = "1,2,3,4,5,6,7";    // 默认显示名片字段
	String qrcodepath = "";
	String headimg = "";
	Map<String, String> itemMap = new HashMap<String, String>();
	boolean isSet = false;
	if(esRs.next()) {
		lastname = esRs.getString("name");
		email = esRs.getString("email");
		jobtitle = esRs.getString("jobtitle");
		location = esRs.getString("location");
		telephone = esRs.getString("telephone");
		fax = esRs.getString("fax");
		jobname = esRs.getString("jobname");
		url = esRs.getString("url");
		mobile = esRs.getString("mobile");
		selected = esRs.getString("selected");
		qrcodepath = esRs.getString("qrcodepath");
		headimg = esRs.getString("signheadpath");
		isSet = true;
	}
	if(!isSet) {
		lastname = Util.toScreen(rs.getString("lastname"),user.getLanguage()) ;			/*姓名*/
	//	sex = Util.toScreen(rs.getString("sex"),user.getLanguage()) ;
		email = Util.toScreen(rs.getString("email"),user.getLanguage()) ;				/*电邮*/
	//	jobtitle = Util.toScreen(rs.getString("jobtitle"),user.getLanguage()) ;			/*岗位*/
		jobtitle = JobTitlesComInfo.getJobTitlesname(rs.getString("jobtitle"));
		locationid = Util.toScreen(rs.getString("locationid"),user.getLanguage()) ;		/*办公地点*/
		telephone = Util.toScreen(rs.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
		mobile = ResourceComInfo.getMobileShow(userid, user) ;			/*移动电话*/
		fax = Util.toScreen(rs.getString("fax"),user.getLanguage()) ;				/*传真*/
		departmentid = Util.toScreen(rs.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
		location = Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage());
	//	subcompanyid = Util.toScreen(rs.getString("subcompanyid1"),user.getLanguage()) ;
	}
//	itemMap.put("1", new ArrayList());
	String resourceimageid = Util.getFileidOut(rs.getString("resourceimageid")) ;	/*照片id 由SequenceIndex表得到，和使用它的表相关联*/
	
%>
<script language="javascript" src="/qrcode/js/jquery.qrcode-0.7.0_wev8.js"></script>

<script type="text/javascript">


jQuery(document).ready(function(){
	jQuery('#isheadimghid').val('<%=resourceimageid%>');
	initCardItem();

	createQRcode();	
});	

	function createQRcode() {
		//生成二维码	
	    var	txt = "BEGIN:VCARD \n"+
		"VERSION:3.0 \n"+
		"N:<%=Util.toScreen(lastname,user.getLanguage())%> \n"+
		"EMAIL:<%=email%> \n"+
		"TEL;CELL;VOICE:<%=mobile%> \n"+ 
		"TEL;WORK;VOICE:<%=telephone%> \n"+
		"TITLE:<%=Util.toScreen(jobtitle,user.getLanguage())%> \n"+
		"ADR;WORK:<%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%> \n"+
		"END:VCARD";
		
		jQuery('#showSQRCodeDiv1').qrcode({
			render: 'canvas',
			background:"#ffffff",
			foreground:"#000000",
			msize:0.3,
			size:150,
			mode:0,
			//mode 1,2 二维码中插入lable、mode=3或4 二维码中插入 插入，注意IE8及以下版本不支持插图及labelmode设置无效
			label:'<%=lastname%>',
			image:"/images/hrm/weixin_wev8.png",
			text: utf16to8(txt)
		});
		
//		jQuery("#showQRcodeMain").hide();
	}
	
	
	function utf16to8(str) {                                         
  		var out, i, len, c;                                          
  		out = "";                                                    
  		len = str.length;                                            
  		for(i = 0; i < len; i++) {                                   
	    	c = str.charCodeAt(i);                                       
  			if ((c >= 0x0001) && (c <= 0x007F)) {                        
      			out += str.charAt(i);                                    
  			} else if (c > 0x07FF) {                                     
      		out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));  
      		out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));  
      		out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
  	    	} else {                                                    
      			out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));  
      			out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
  			}                                                           
  		}                                                           
  		return out;                                                 
	} 
	
	
	/**
	* 编辑属性
	* Shunping Fu
	**/
	var selectItem = '';
	var selectIndex = '';
	
	function showAddDiv(ev) {
		var oEvent=ev||event;
		var oTop=(oEvent.clientY+15)+'px'
		jQuery('#cardTypediv').html("<select  class='InputStyle' name='cardType' id='cardType'  style='width: 120px;' >" +
										getOptionValue(0)+
									"</select>");
		jQuery('#editcarddivback').css("left",'290px');
		jQuery('#editcarddivback').css("top",oTop);
		jQuery('#editcarddivback').show();
		jQuery('#zd_btn_update').hide();
		jQuery('#zd_btn_delete').hide();
		jQuery('#zd_btn_add').show();
		
	}
	
	function deleteCardItem(selectIndex, rowId){
		delItemCacheIndex(selectIndex);
		if(jQuery('#'+rowId));
			jQuery('#'+rowId).remove();
	//	closeCardItem();
	}
	
	function closeCardItem(){
		jQuery('#editcarddivback').hide();
	}
	
	
	/**
	* 获取可以选择的属性选项
	* Shunping Fu
	**/
	function getOptionValue(index) {
		var optionstr = "";
		if(index != 0)
			optionstr = "<option value='"+index+"'>"+cardItems[index-1]+"</option>";
		var availbleArr = getAvailableItemIndex();
		for(var i=0; i<availbleArr.length; i++){
			optionstr += "<option value='"+availbleArr[i]+"'>"+cardItems[availbleArr[i]-1]+"</option>";
		}
		return optionstr;
	}
	
	/**
	* 获取可以选择的属性索引集合
	* Shunping Fu
	**/
	function getAvailableItemIndex() {
		var availableArr = [];
		var max = cardItems.length;
		
		for(var i=1; i < max+1; i++) {
			 var bl = false;
			 for(var j=0; j< itemCache.length; j++) {
			 	if(i == itemCache[j]) {
			 		bl = true;
			 		continue;
			 	}
			 }
			 if(!bl)availableArr.push(i);
		}
		return availableArr;
	}
	
    /**
	*   删除缓存中指定index
	*   Shunping Fu
	**/
	function delItemCacheIndex(index) {
		var newItemCache = [];
		for(var i=0; i<itemCache.length; i++) {
			if(itemCache[i] != index) newItemCache.push(itemCache[i]);
		}
		itemCache = newItemCache; 
	}
	
	/**
	*   修改到缓存中指定newindex, oldindex
	*   Shunping Fu
	*/
	function addItemCacheIndex(newindex, oldindex) {
		for(var i=0; i<itemCache.length; i++) {
			if(itemCache[i]==oldindex) {
				itemCache.splice(i, 1, parseInt(newindex)); 
			}
		}
//	   	delItemCacheIndex(oldindex);
//	   	itemCache.push(parseInt(newindex));
	}
	
	function updateIndexs() {
		var indexs = '';
		jQuery('#mailSignCardItem').find('.itemdiv').each(function(){
			var namevalue = jQuery(this).attr('name');
			var index = namevalue.substring(namevalue.indexOf('&index=')+7,namevalue.length);
			indexs += index+',';
		});
		jQuery('#selecteIdItem').val(indexs.substring(0, indexs.length-1));
	}
	
	
	//姓名413，岗位6086，邮箱20869，名称195，地址110，手机422，电话421，传真494，网址20637
	var cardItems = ['<%=SystemEnv.getHtmlLabelName(413,user.getLanguage()) %>', '<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(20869,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%>', '<%=SystemEnv.getHtmlLabelName(20637,user.getLanguage())%>'];
	var cardItemNames = ['lastname', 'jobtitle', 'email', 'jobname', 'location', 'mobile', 'telephone', 'fax', 'url'];
	var cardValues = ['<%=lastname %>', '<%=jobtitle%>', '<%=email %>', '<%=jobname %>', '<%=location %>', '<%=mobile %>', '<%=telephone %>', '<%=fax %>', '<%=url %>'];
	var itemCache = [];       //页面缓存，用于存储记录用户选择的卡片属性index
	var isedit = <%=isedit %>;
	/**
	*   初始化名片属性显示列
	*   Shunping Fu
	**/
	function initCardItem() {
		var selected = "<%=selected%>";
		var selectedArr = selected.split(',');
		var itemtable = document.getElementById("mailSignCardItem");
		
		if(isedit != 1)
			jQuery('#addItem').hide();
			
		for(var i=0; i<selectedArr.length; i++) {
			var cardindex = selectedArr[i];
			var row = itemtable.insertRow();
			var valueId = cardItemNames[cardindex-1];
			row.id = 'tr'+valueId;
			var cell = row.insertCell();
			
			var celltool = row.insertCell();
			celltool.width="70px";
			
			
			cell.innerHTML=itemTdStr(cardItems[cardindex-1], valueId, cardValues[cardindex-1], cardindex);
			celltool.innerHTML= itemTdToolStr(cardindex, valueId);
			itemCache.push(cardindex);
		}
		
		
		addEvent();
	}
	/**
	*  绑定鼠标进入属性行事件 
	*  Shunping Fu
	**/
	function addEvent(){
		$("#mailSignCardItem").find("tr").bind("mouseenter",function(){
			$(this).find("div.control").show();
			
		}).bind("mouseleave",function(){
				$(this).find("div.control").hide();
		});
	}
	
	/**
	*  初始化属性编辑 
	*  Shunping Fu
	**/
	function itemTdToolStr(index, valueId) {
		var trid = 'tr' + valueId;
		var deletebtn = "<input type='button' class='delbtn' onmouseover='onoverbtn(this, \"delbtn2\")' onmouseout='onoutbtn(this,\"delbtn2\")' onclick=\"deleteCardItem("+index+", '"+trid+"')\" title='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>'>";
		if(index == '1' || index == '3') {
				deletebtn = "";
		}
		return "<div class='control' style='display:none'>"+
				"<input id='' type='button' class='addbtn' onmouseover='onoverbtn(this, \"addbtn2\")' onmouseout='onoutbtn(this,\"addbtn2\")' onclick='addCardItem(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>'>" +
				"<input id='' type='button' class='editbtn' onmouseover='onoverbtn(this, \"editbtn2\")' onmouseout='onoutbtn(this,\"editbtn2\")' onclick='showEdit(\""+valueId+"div\")' title='<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>'>" +
				deletebtn +
    			"</div>";
	}
	
	/**
	*  初始化属性显示  
	*  Shunping Fu
	**/
	function itemTdStr(name, valueId, value, index) {
		var valueHidden = 'name='+name + '&valueId='+valueId + '&value='+ value + '&index='+index;
		return "<div   style = 'width:220px;height:26px;line-height:26px;cursor:pointer;'   >" +
				"<input type='hidden' name='"+valueId+"' value='"+ value +"'/>"+
				"<div class='itemdiv' id='"+valueId+"div' name='"+ valueHidden +"'  style = 'height:30px;width:220px;line-height:30px;padding-left:3px;'> " +
				"<span class='STYLE6'>"+ name +"&nbsp;：&nbsp;</span>" +
				"<span class='STYLE61' id='"+ valueId +"'>" + value + "</span>" +
				"</div>" +
				"</div>";
	
	}
	
	/**
	*  展现编辑框属性字段可编辑 
	*  Shunping Fu
	**/
	function showEdit(valuedivId) {
		setTimeout(function(){
			var eidtHtml = '';
			var valueHidden = jQuery('#'+valuedivId).attr('name');
			var valueId = getHidValue(valueHidden, 'valueId');
			var value = getHidValue(valueHidden, 'value');
			var index = getHidValue(valueHidden, 'index');
			eidtHtml += "<select  class='inputStyle' name='cardType' id='cardType'  style='width: 75px;' >" +
							getOptionValue(parseInt(index))+
						"</select>" +
						"<input class='inputStyle' id='"+ valueId +"' value='"+value+"' style='margin-left:5px;width: 135px;' />";
			jQuery('#'+valuedivId).html(eidtHtml);
			
			jQuery('#'+valueId).focus().blur(function() {
					cancelEditor(valueId, valuedivId, index);
			});
			
			jQuery('#cardType').blur(function() {
					cancelEditor(valueId, valuedivId, index);
			});
		
		},'20');
	}
	
	/**
	*  取消编辑框变为不可编辑  
	*  Shunping Fu
	**/
	function cancelEditor(inputid, valuedivId, oldindex) {
		
		setTimeout(function(){
			//属性选择，值输入框同时失去焦点时处理
			if(!jQuery("#cardType").is(":focus") && !jQuery("#" + inputid).is(":focus")) {
				var index = jQuery('#cardType option:selected').val();
				var name = cardItems[index-1];
				var value = jQuery("#" + inputid).val();
				var eidtHtml = "<span class='STYLE6'>"+ name +"&nbsp;：&nbsp;</span>" +
				"<span class='STYLE61' id='"+ inputid +"'>" + value + "</span>";
				addItemCacheIndex(index, oldindex);
				jQuery('#'+valuedivId).attr('name',setHidValue(name, valuedivId.replace("div",""), value, index)).html(eidtHtml);
				jQuery(jQuery("input[name='"+inputid+"']")[0]).val(value);
			}
		},'10');
	
	}
	/**
	*  组装隐藏参数获取属性对应值  
	*  Shunping Fu
	**/
	function setHidValue(name, valueId, value, index) {
		return 'name='+name + '&valueId='+valueId + '&value='+ value + '&index='+index;;
		
	}
	/**
	*  解析隐藏参数获取属性对应值  
	*  Shunping Fu
	**/
	function getHidValue(valueHidden, name) {
		var arry = valueHidden.split('&');
		for(var key in arry) {
			var index = arry[key].indexOf('=');
			if(arry[key].substring(0, index) == name) {
				return arry[key].substring(index+1, arry[key].lenth);
			}
		}
		return '';
	}
	
	function addCardItem(obj) {
		var rowindex = obj.parentNode.parentNode.parentNode.rowIndex;
	
		var arryItems = getAvailableItemIndex();
		if(arryItems.length<2) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83108,user.getLanguage()) %>！");
			return;
		}	
	
		var itemtable = document.getElementById("mailSignCardItem");
		var index = getAvailableItemIndex()[0];
		var row = itemtable.insertRow(rowindex+1);
		var valueId = cardItemNames[index-1];
		row.id = 'tr'+valueId;
		var cell = row.insertCell();
		
		var celltool = row.insertCell();
		celltool.width="70px";
			
		celltool.innerHTML= itemTdToolStr(index, valueId);
		cell.innerHTML=itemTdStr(cardItems[index-1], valueId, cardValues[index-1], index);
		itemCache.push(index);
		
		addEvent();
		showEdit(valueId+"div");
	}
	
	function editCardItem(valueId) {
	}
	
	function hasClass(obj, cls) {
        return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
    }
	
	function onoverbtn(btn, cls) {
		if (!this.hasClass(btn, cls))btn.className += " " + cls;
	}
	
	function onoutbtn(btn, cls) {
		 if (hasClass(btn, cls)) {
            var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
            btn.className = btn.className.replace(reg, ' ');
         }
	}
	/**
	*  头像上传  
	*  Shunping Fu
	**/
	var dialog;
	function showUploadHead(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/email/new/GetSignIcon.jsp?userid=<%=user.getUID()%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("68,83088",user.getLanguage()) %>";
		dialog.Width = 650;
		dialog.Height = 550;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
		
	}
	
	function createBQCode(){
		if(jQuery("#showQRcodeMain").is(":hidden"))
			jQuery("#showQRcodeMain").show();
		else
			jQuery("#showQRcodeMain").hide();
	}
	

</script>
<style type="text/css"> 
.itemdiv{
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
#mailSignCardItem tr:hover{ 
	background-color: #fff9eb;
}
.delbtn { 	
	border:none;BACKGROUND: url(/email/images/del_1_wev8.png) no-repeat;color:#333;WIDTH: 21px;height:21px;text-align:left;cursor:pointer;padding-left:5px;padding-top:2px;margin-right:5px;
	background-position:50% 50%;
}
.delbtn2 { 	
	border:none;BACKGROUND: url(/email/images/del_2_wev8.png) no-repeat;color:#333;WIDTH: 21px;height:21px;text-align:left;cursor:pointer;padding-left:0px;padding-top:2px;margin-right:0px;
	background-position:50% 50%;
}
.addbtn { 	
	border:none;BACKGROUND: url(/email/images/add_1_wev8.png) no-repeat;color:#333;WIDTH: 21px;height:21px;text-align:left;cursor:pointer;padding-left:0px;padding-top:2px;margin-right:0px;
	background-position:50% 50%;
}
.addbtn2 { 	
	border:none;BACKGROUND: url(/email/images/add_2_wev8.png) no-repeat;color:#333;WIDTH: 21px;height:21px;text-align:left;cursor:pointer;padding-left:0px;padding-top:2px;margin-right:0px;
	background-position:50% 50%;
}
.editbtn { 	
	border:none;BACKGROUND: url(/email/images/edit_1_wev8.png) no-repeat;color:#333;WIDTH: 21px;height:21px;text-align:left;cursor:pointer;padding-left:0px;padding-top:2px;margin-right:0px;
	background-position:50% 50%;
}
.editbtn2 {
	border:none;BACKGROUND: url(/email/images/edit_2_wev8.png) no-repeat;color:#333;WIDTH: 21px;height:21px;text-align:left;cursor:pointer;padding-left:0px;padding-top:2px;margin-right:0px;
	background-position:50% 50%;
}
.STYLE4 {
	FONT-FAMILY: Verdana;
	font-size: 14px;
	cursor: hand;
}

.STYLE6 {
	FONT-FAMILY: Verdana;
	FONT-SIZE: 12px;
}

.STYLE61 {
	FONT-FAMILY: Verdana;
	FONT-SIZE: 12px;
	color: #000000;
}

.simplehrmhead {
	vertical-align:baseline;
}
#signdiv {
	font-size: 12px;
	background-color: #fff;
	margin-left: 5px;
	margin-right: 5px;
	margin-top: 5px;
}

#message_table{
	border: 1px solid #dadedb;
}

#signdiv li a:link {
	color: #2a788e;
	font-size: 12px;
	text-decoration: none;
}

#signdiv li a:visited {
	color: #227086;
	font-size: 12px;
	text-decoration: none;
}

#signdiv li a:hover {
	color: #FFFFFF;
	font-size: 12px;
	text-decoration: none;
}

#headimg {
}
.cardQr {
	text-align: left; 
	margin: 10px;
}
#mailSignCardItem tr{
	height: 20px;
}
#mailSignCardItem {
	padding-bottom: 10px;
}

#editcarddivback {background-color: rgb(228, 228, 228);width: 276px; height: 98px; display: block;position:absolute;top: 14px;left: 118px; z-index:5555;display: none}
</style>

				<div id="signdiv">
					<div id="message_table"  style="adding: 0px; margin: 0px;float:left;">
						<table border="0" align="center" style="vertical-align: middle;width:100%" cellpadding="0" cellspacing="0">
							<tbody>
								<tr>
									<td valign="top" style="position:relative;width:175px;">
									<%if(!"".equals(headimg)) {%>
										<img id="headimg" src="data:image/gif;base64,<%=headimg %>" border="0" width="175" height="222">
									<%}else if(!resourceimageid.equals("0") && resourceimageid.length()> 0 ){ %>
										<img id="headimg"  src="/weaver/weaver.file.FileDownload?fileid=<%=resourceimageid%>" width="175" height="222" />
									<%}else{%>
										<img id="headimg" src="/email/images/mail_men_wev8.png" border="0" width="175" height="222">
									<%}%>
										<div style="background-image:url('/images/messageimages/temp/divbg_wev8.png');width:175px;position:absolute;top:190px;left:0px;padding-top:3px;">
											<a href="javascript:showUploadHead();" style="margin-left:75px;" title="<%=SystemEnv.getHtmlLabelName(83080,user.getLanguage()) %>">
												<img style='height:25px' src="/email/images/mail_sign_head_set_wev8.png" >
											</a>
										</div> 
									</td>
									<td valign="top" width="310px">
										<table id="mailSignCardItem" style="width:100%" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0">
											<tbody>
											</tbody>
										</table>
									</td>
								</tr>
						</tbody></table>
					</div>
					<div id='showQRcodeMain' style="float:left;width:175px;padding-top:8px;">
						<div  class='cardQr' id="showSQRCodeDiv1" ></div>
						<div class='cardQr' ><%=SystemEnv.getHtmlLabelName(83074,user.getLanguage()) %></div>
					</div>
					<div style="clear:both"></div>
				</div>
				<input type='hidden' id='selecteIdItem' name='selecteIdItem' value='<%=selected %>'/>
				<input type='hidden' id='qrcodepath' name='qrcodepath' value='<%=qrcodepath %>'/>

