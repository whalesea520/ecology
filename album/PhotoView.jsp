<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="chk" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<%
String src = Util.null2String(request.getParameter("src"));
int id = Util.getIntValue(request.getParameter("id"));
String photoName="",photoPath="",photoDescription="",userId="",postdate="",subcompanyId="";
int parentId = 0;
rs.executeSql("SELECT * FROM AlbumPhotos WHERE id="+id+"");
if(rs.next()){
	parentId = rs.getInt("parentId");
	photoName = rs.getString("photoName");
	photoPath = rs.getString("photoPath");
	photoDescription = rs.getString("photoDescription");
	userId = rs.getString("userId");
	postdate = rs.getString("postdate");
	subcompanyId = rs.getString("subcompanyId");
}
photoPath = "http://"+Util.getRequestHost(request)+"/weaver/weaver.album.ShowImgServlet?id="+id;

//int[] ids = chk.getSubComByUserEditRightId(user.getUID(), "Album:Maint");
int[] ids = chk.getSubComByUserRightId(user.getUID(), "Album:Maint");
String _ids = "," + user.getUserSubCompany1() + ",";
for(int i=0;i<ids.length;i++){
	_ids += ids[i] + ",";
}


int previousId=0, nextId=0;
ArrayList siblingPhotos = new ArrayList();
rs.executeSql("SELECT id FROM AlbumPhotos WHERE parentId="+parentId+" AND isFolder='0' ORDER BY orderNum desc,postDate desc");
while(rs.next()){
	siblingPhotos.add(rs.getString("id"));
}
int myPos = siblingPhotos.indexOf(""+id);
if(myPos>0){
	previousId = Util.getIntValue((String)siblingPhotos.get(myPos-1));
}
if(myPos<siblingPhotos.size()-1){
	nextId = Util.getIntValue((String)siblingPhotos.get(myPos+1));
}

if(_ids.indexOf(","+subcompanyId+",")==-1){
	response.sendRedirect("/notice/noright.jsp");
}


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(74,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/album/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}

if("<%=isclose%>"=="1"){
	try{
		parentWin = parent.getParentWindow(window);
		parentWin.closeDialog();	
		parentWin._table.reLoad();
	}catch(e){}
}
</script>
<script type="text/javascript">
function photoResize(){
	//var img = event.srcElement;
	var img = $("oImg");
	var imgWidth = img.width;
	var winWidth = document.body.offsetWidth;
	img.style.width = imgWidth>winWidth ? (winWidth-40)+"px" : imgWidth;
}
function openNewWin(){
	var img = event.srcElement;
	window.open(img.src,"","");
}
function loadPhotoReview(){
	//var o = event.srcElement;
	$("#tdReview").html(document.getElementById('iframeReview').contentWindow.document.body.innerHTML);
}
function submitReview(){
	var currentPhotoId=$("#currentPhotoId").val();
	doSubmit("iframeReview", "PhotoReview.jsp?id="+currentPhotoId+"&operation=add");
	//weaver.reviewContent.innerHTML = "";
	$("#reviewContent").html("");
	$("#addReview_tr").hide();
}
function deleteReview(){
	var currentPhotoId=$("#currentPhotoId").val();
	var reviewId = event.srcElement.getAttribute("reviewId");
	if(!confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>")) return false;
	doSubmit("iframeReview", "PhotoReview.jsp?id="+currentPhotoId+"&reviewId="+reviewId+"&operation=delete");
}
function editReview(){
	var o = event.srcElement;
	var reviewId = o.getAttribute("reviewId");
	o.style.display = "none";
	document.getElementById("linkSave"+reviewId).style.display = "inline";
	document.getElementById("linkCancel"+reviewId).style.display = "inline";
	var td = findTD(o);
	try{
		document.body.removeChild(document.getElementById("hidden_"+reviewId));
	}catch(e){}
	var tempObj = document.createElement("DIV");
	tempObj.style.display = "none";
	tempObj.id = "hidden_"+reviewId;
	tempObj.innerHTML = td.innerHTML;
	document.body.appendChild(tempObj);
	//td.innerHTML = "<textarea class='inputstyle' style='width:100%;height:100px;background-color:#FFFFF1'>"+td.innerHTML.replace(/<BR>/ig,"\n")+"</textarea>";
	td.innerHTML = "<textarea class='InputStyle' style='width:100%;height:20px;background-color:#FFFFFF'>"+$(td).find("span[id^=reviewcontent_]").html().replace(/<BR>/ig,"\n")+"</textarea>";
	
}
function cancelReview(o){
	var o = event.srcElement;
	var reviewId = o.getAttribute("reviewId");
	o.style.display = "none";
	document.getElementById("linkSave"+reviewId).style.display = "none";
	document.getElementById("linkEdit"+reviewId).style.display = "inline";
	var td = findTD(o);
	td.innerHTML = document.getElementById("hidden_"+reviewId).innerHTML;
}
function saveReview(){
	var o = event.srcElement;
	var reviewId = o.getAttribute("reviewId");
	var td = findTD(o);
	var txtReview = td.firstChild;
	txtReview.name = "reviewContentUpdate";
	var currentPhotoId=$("#currentPhotoId").val();
	doSubmit("iframeReview", "PhotoReview.jsp?id="+currentPhotoId+"&reviewId="+reviewId+"&operation=update");
}
function doSubmit(fTarget, fAction){
	weaver.target = fTarget;
	weaver.action = fAction;
	weaver.submit();
}
function findTD(o){
	while(o.tagName!="TABLE"){o = o.parentElement;}
	//return o.rows[1].cells[0];
	return o.rows[0].cells[0];
}
</script>

<link type="text/css" rel="stylesheet" href="slider/css/base_wev8.css" />
<link type="text/css" rel="stylesheet" href="slider/css/flexslider_wev8.css" />
<script type="text/javascript" src="slider/js/jquery.min_wev8.js"></script>
<script type="text/javascript" src="slider/js/jquery.flexslider-min_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
</head>
<%
//编辑权限
boolean canEdit = false;
int parentid =Util.getIntValue(p.getParentId(""+id),0);
int subCompanyId=parentid;
String isFolder="";
String folderName="";
if(parentid<0){
	subCompanyId=Util.getIntValue(p.getSubCompanyId(""+id), -1);
	isFolder=p.getIsFolder(""+id);
	folderName=p.getPhotoName(""+id);
	if(subCompanyId<-1){
		subCompanyId=user.getUserSubCompany1();
	}
}
if(parentId>0){
	   //是否分权系统，如不是，则不显示框架，直接转向到列表页面
	   rs.executeSql("select detachable from SystemSet");
	   int detachable=0;
	   if(rs.next()){
	       detachable=rs.getInt("detachable");
	   }

	   int operatelevel=0;

	   if(detachable==1){  
	       operatelevel= chk.ChkComRightByUserRightCompanyId(user.getUID(),"Album:Maint",subCompanyId);
	   }else{
	       if(HrmUserVarify.checkUserRight("Album:Maint", user)){
	           operatelevel=2;
		}
	   }
	   if(operatelevel>=1){
		   canEdit=true;
	   }
}

%>

<body onload="">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="photo"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("84040",user.getLanguage())%>'/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(src.equals("list")){
	if(canEdit){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit("+id+"),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
	/**
	if(previousId!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20205,user.getLanguage())+",/album/PhotoView.jsp?id="+previousId+"&src="+src+",_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
	if(nextId!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20206,user.getLanguage())+",/album/PhotoView.jsp?id="+nextId+"&src="+src+",_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}**/
	
}else if(src.equals("search")){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/album/PhotoSearchResult.jsp,_self} ";
	//RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form method="post" action="AlbumFolderOperation.jsp" id="weaver" name="weaver">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="parentId" value="<%=id%>" />
<input type="hidden" name="currentPhotoId" id="currentPhotoId" value="<%=id%>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">

		<%
		if(canEdit){
			%>
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>" onclick="onEdit(<%=id %>)"/>
			<%
		}
		%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<div style="float:left;margin-left:10px!important;width:1440px!important;">
<div class="flexslider" style="width:800px;margin:10px auto 0 auto;position:relative;overflow:hidden;float:left;">
	<ul class="slides">
	
<%
String photoPathUrl="http://"+Util.getRequestHost(request)+"/weaver/weaver.album.ShowImgServlet?id=";
for(int i=0;i<siblingPhotos.size();i++){
	%>
		<li>
			<img  photo_index="<%=i %>" photo_id="<%=siblingPhotos.get(i) %>"  src="<%=photoPathUrl+siblingPhotos.get(i) %>" alt="" style="cursor:pointer;"  onclick="openNewWin();" />
		</li>
	<%
}

%>	
	
		
	</ul>
</div>

<div style="float:left;width:400px!important;margin-right:10px;">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("84061",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("84033",user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'photoTitle_td'}"><%=photoName %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("26083",user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'photoUploader_td'}"><%=ResourceComInfo.getResourcename(userId) %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("27780",user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'photoUploadDate_td'}"><%=postdate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("433",user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'photoDesc_td'}"><%=Util.toHtml( photoDescription) %></wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("675",user.getLanguage())%>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item type="groupHead" attributes="{'colspan':'full'}">
			<span style='float:right!important;'>
				<input type="button" class="addbtn" style="margin-top:5px!important;" title="<%=SystemEnv.getHtmlLabelNames("84062",user.getLanguage())%>" onclick="addReview();"/>
			</span>
		</wea:item>
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">

<table class="ViewForm">
<colgroup>
<col width="15%">
<col width="85%">
</colgroup>
<tbody>
<tr>
	<td colspan="2" id="tdReview">
		<img src="/images/loading2_wev8.gif"> <%=SystemEnv.getHtmlLabelName(20010,user.getLanguage())%>
	</td>
</tr>
<tr id="addReview_tr" style="display:none;">
	<td colspan="2">
		<textarea class="inputstyle" name="reviewContent" id="reviewContent" style="width:100%;height:100px"></textarea>
		<input type="text" name="reviewContentUpdate" id="reviewContentUpdate" style="display:none" />
		
		<span class="e8_btn_top" style="float:right;"  onclick="submitReview()"><%=SystemEnv.getHtmlLabelNames("20009",user.getLanguage())%></span>
	</td>
</tr>
</tbody>
</table>			
			
		</wea:item>
	</wea:group>
	
</wea:layout>


</div>

</div>

 
<iframe id="iframeReview" name="iframeReview" src="PhotoReview.jsp?id=<%=id%>" onload="loadPhotoReview()" style="display:none"></iframe>
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


<script type="text/javascript">

</script>
<script type="text/javascript">
$(function() {
    var flexslider= $(".flexslider").flexslider({
    	slideshow:false,
    	startAt:<%=myPos %>,
    	controlNav:false,
    	animationLoop:false,
    	after:afterImg
    });
    checkSibling(flexslider);
    var currentSlide='<%=myPos %>';
    if(currentSlide=='0'){
    	$("a.flex-prev").hide();
    }
});	

function onEdit(id){
	var currentId=$("#currentPhotoId").val();
	if(currentId){
		var url="/album/AlbumFolderEdit.jsp?id="+currentId+"&isdialog=1&from=photoview";
		var title="<%=SystemEnv.getHtmlLabelNames("84038",user.getLanguage())%>";
		openDialog(url,title,450,250);
	}
}
function addReview(){
	$("#addReview_tr").toggle();
}

function afterImg(slider){
	checkSibling(slider);
	var currentIndex= slider.currentSlide;
	//console.log("currentIndex:"+currentIndex);
	var currentPhotoId= $("img[photo_index='"+currentIndex+"']").attr("photo_id");
	$("#currentPhotoId").val(currentPhotoId);
	reloadPhotoInfo(currentPhotoId);
}

function reloadPhotoInfo(photoid){
	if(photoid){
		jQuery.ajax({
			url : "/album/PhotoReloadInfo.jsp",
			type : "post",
			async : true,
			processData : true,
			data : {photoid:photoid},
			dataType : "json",
			success: function do4Success(data){
				if(data){
					if(data.reviewInfo){
						$("#tdReview").html(data.reviewInfo);
					}
					if(data.photo_postdate){
						$("#photoUploadDate_td").html(data.photo_postdate);
					}
					if(data.photo_title){
						$("#photoTitle_td").html(data.photo_title);
					}
					if(data.photo_desc){
						$("#photoDesc_td").html(data.photo_desc);
					}
					if(data.photo_uploader){
						$("#photoUploader_td").html(data.photo_uploader);
					}
				}
			}
		});
	}
}


function checkSibling(slider){
	$("a.flex-prev").show();
	$("a.flex-next").show();
	if(slider.currentSlide==slider.last){
		$("a.flex-next").hide();
	}else if(slider.currentSlide==0){
		$("a.flex-prev").hide();
	}
}
</script> 
</body>
</html>
