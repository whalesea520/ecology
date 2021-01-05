<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%
	String gridUrl = Util.null2String(request.getParameter("gridUrl"));
	int displayUsage =  Util.getIntValue(request.getParameter("displayUsage"),0);
	int seccategory= Util.getIntValue(request.getParameter("seccategory"),0);
	String subcategory =  Util.null2String(request.getParameter("subcategory"));
	String maincategory =  Util.null2String(request.getParameter("maincategory"));
	String userid=  Util.null2String(request.getParameter("userid"));
	String customSearchPara=(String)session.getAttribute("customSearchPara_cu_"+userid);
	String from =  Util.null2String(request.getParameter("from"));
	String showtype =  Util.null2String(request.getParameter("showtype"));
	String columnUrl =  Util.null2String(request.getParameter("columnUrl"));
	String urlType =  Util.null2String(request.getParameter("urlType"));
	String isShow =  Util.null2String(request.getParameter("isShow"));
	String offical =  Util.null2String(request.getParameter("offical"));
	String isUsedCustomSearch =  Util.null2String(request.getParameter("isUsedCustomSearch"));
	int userightmenu_self= Util.getIntValue(request.getParameter("userightmenu_self"),0);
	int lang= Util.getIntValue(request.getParameter("lang"),7);
	String topButton =  Util.null2String(request.getParameter("topButton"));
	String useCustomSearch =  Util.null2String(request.getParameter("useCustomSearch"));
	String docdetachable =  Util.null2String(request.getParameter("docdetachable"));
	String isDetach =  Util.null2String(request.getParameter("isDetach"));
	String fromAdvancedMenu =  Util.null2String(request.getParameter("fromAdvancedMenu"));
	String infoId = Util.null2String(request.getParameter("infoId"));
	String selectedContent = Util.null2String(request.getParameter("selectedContent"));
	int language = Util.getIntValue(request.getParameter("language"),7);
%>




<script type="text/javascript">

function setCustomSearch(e,d,n,seccategory){
		jQuery.post(
				'/docs/search/ext/CustomFieldExtProxy.jsp',
				{
					'seccategory' : d.id
				},
				function(data){					
					jQuery('#customSearchDiv').html(data);		
					customSearch = true;		
					__defaultTemplNamespace__.initLayout();
					jQuery('#customSearchDiv').find('select').each(function(i,v){
						beautySelect(jQuery(v));
					});
				}
			);
	}


		function getajaxurl(typeId){
			var url = "";
			if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
			   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
				url = "/data.jsp?type=" + typeId;			
			} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
				url = "/data.jsp";
			} else {
				url = "/data.jsp?type=" + typeId;
			}
			url = "/data.jsp?type=" + typeId;	
			//alert(typeId + "," + url);
		    return url;
		}

function updateSearchDivHeight(){
	if(jQuery.browser.msie){
		jQuery('#advancedSearchOuterDiv').css('height','100%')
		var height = jQuery('#advancedSearchOuterDiv').outerHeight()+2;
		if(height>jQuery(window).height()){
			height = jQuery(window).height()-2;
		}
		jQuery('#advancedSearchOuterDiv').height(height);
	}
}


function onShowMDocidForOwner(spanId, inputeId, checkboxId, para){
	jQuery("#otherDocId_btn").data("spanId",spanId);
	jQuery("#otherDocId_btn").data("inputeId",inputeId);
	jQuery("#otherDocId_btn").data("checkboxId",checkboxId);
	jQuery("#otherDocId_btn").data("para",para);
	jQuery("#otherDocId_btn").trigger("click");
}

function getBrowserUrl(){
	var inputeId = jQuery("#otherDocId_btn").data("inputeId");
	var para = jQuery("#otherDocId_btn").data("para");
	return "/systeminfo/BrowserMain.jsp?url=/docs/docsubscribe/MutiDocByOwenerBrowser.jsp?documentids=" + inputeId.value + "&subscribePara=" + para;
}

function selectCheckbox(obj){
     changeCheckboxStatus(obj);
     _xtalbe_chkCheck(obj) ;
 }

function afterShowMDocidForOwner(e, id1, name, params) {
    var spanId = jQuery("#otherDocId_btn").data("spanId");
	var inputeId = jQuery("#otherDocId_btn").data("inputeId");
	var checkboxId = jQuery("#otherDocId_btn").data("checkboxId");
	var para = jQuery("#otherDocId_btn").data("para");
    if (id1!=null) {
        if (id1.id != "") {
            selectCheckbox(checkboxId);
            DocIds = id1.id;
            DocName = id1.name;
            sHtml = "";
            inputeId.value = DocIds;
            while (DocIds.indexOf(",")>-1){
             curid = DocIds.substring(0, DocIds.indexOf(",") - 1);
             curname = DocName.substring(0, DocName.indexOf(",") - 1);
             DocIds = DocIds.substring(DocIds.indexOf(",") + 1, DocIds.length);
             DocName = DocName.substring(DocName.indexOf(",") + 1, DocName.length);
             sHtml = sHtml + curname + "&nbsp";
             
            }
            sHtml = sHtml + DocName + "&nbsp";
            jQuery(spanId).html(sHtml);
            
        } else {
            spanId.innerHTML = "";
            inputeId.value = "";
        };
        //alert(inputeId.id +" "+inputeId.value);
    }
}

var sessionId="";		
var colInfo;
var gridUrl ='<%=gridUrl%>';
var displayUsage = '<%=displayUsage%>';
var seccategoryid='<%=seccategory%>';
var subcategoryid = '<%=subcategory%>';
var maincategoryid = '<%=maincategory%>';
var customSearchPara = '<%=customSearchPara%>';
function URLencode(sStr) 
{
	 return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}

function getSearchPara(){
	
	
	 try{
        if($G("ownerid2").value+"" != "0"){
        	
        	//jQuery("input[name='ownerid']")[0].value = $G("ownerid2").value;
        }

        if($G("doccreaterid2").value+"" != "0"){
           //$G("doccreaterid").value = $G("doccreaterid2").value;
        }
    }catch(e){}
    
	var docSearchForm = document.forms.frmmain;
	var searchPara ='';
	
	for(i=0;i<docSearchForm.elements.length;i++)
	{
		if(docSearchForm.elements[i].type=='checkbox'){
			if(docSearchForm.elements[i].checked==false){
				continue;
			}
		}
		if(docSearchForm.elements[i].name=='customSearchPara'){
			continue;
		}

		if(docSearchForm.elements[i].name=='maincategory' && maincategoryid!='0'){
			//searchPara+='&maincategory='+maincategoryid;
		}
		else if(docSearchForm.elements[i].name=='subcategory'&&subcategoryid!='0'){
			//searchPara+='&subcategory='+subcategoryid;
		}
		else if(docSearchForm.elements[i].name=='seccategory'&&seccategoryid!='0'){
			searchPara+='&seccategory='+jQuery("#seccategory").val();
		}else if(docSearchForm.elements[i].name!= ''){

			if(docSearchForm.elements[i].value!=''){

				/*if(docSearchForm.elements[i].name=='docsubject'||docSearchForm.elements[i].name=='flowTitle'){
					searchPara+='&'+docSearchForm.elements[i].name+'='+URLencode(docSearchForm.elements[i].value);
				}else{*/
					searchPara+='&'+docSearchForm.elements[i].name+'='+URLencode(docSearchForm.elements[i].value);
				//}
			}
		}
	}
	
	searchPara='sessionId='+sessionId+'&list=all&from=<%=from%>&showtype=<%=showtype%>'+searchPara+"&fromadvancedmenu=<%=fromAdvancedMenu%>&selectedContent=<%=selectedContent%>&infoId=<%=infoId%>";
	return searchPara;
}	


function getGridInfo(){
		var url = '<%=columnUrl%>';
		var data2duringparam = "";
		if(document.getElementById("date2during"))
		{
			data2duringparam = "&date2during="+document.getElementById("date2during").value;
		}
		if(url.indexOf("?")==-1){
			url = url+"?seccategoryid="+$GetEle("seccategoryid").value+"&isUsedCustomSearch="+$GetEle("isUsedCustomSearch").value+data2duringparam;
		}else{
			url = url+"&seccategoryid="+$GetEle("seccategoryid").value+"&isUsedCustomSearch="+$GetEle("isUsedCustomSearch").value+data2duringparam;
		}
		//if(displayUsage==1){

		if(customSearchPara==''){
			url =url+'&'+getSearchPara();
		}else{
			url =url+'&'+customSearchPara;
		}
		//}


		//alert(url)

		//alert("colinfo:"+colInfo);
	
		var obj; 
	
	    if (window.ActiveXObject) { 
	        obj = new ActiveXObject('Microsoft.XMLHTTP'); 
	    } 
	    else if (window.XMLHttpRequest) { 
	        obj = new XMLHttpRequest(); 
	    } 	
	    
		obj.open('GET', url+"&b="+new Date().getTime(), false); 
	    obj.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
	    obj.send(null); 
	    if (obj.status == "200") {
	    	var tmpcolInfo =  obj.responseText;
	    	
	    	var posTemp=tmpcolInfo.indexOf("^^");
			if(posTemp!=-1){
		    	colInfo=tmpcolInfo.substring(0,posTemp);
		    	sessionId=tmpcolInfo.substring(posTemp+2,tmpcolInfo.length);
			}else{
				colInfo=tmpcolInfo;
			}
	    	//colInfo.subString(colInfo.indexOf("^^"))
		} else {
		} 	    
		
		
	
		
}
</script>

<script type="text/javascript">
	<%if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){%>
		getGridInfo();	
		
	<%}%>
	<%if((urlType.equals("15")||urlType.equals("11"))&&docdetachable.equals("1")){%>
	if(seccategoryid==0){
	jQuery("#divContent").html("<div align=right style='width:100%;text-align:center;'>请先选择目录...</div>");
	}
	<%}%>
	//alert(jQuery("#_xTable").innerHTML);
	//if(displayUsage==0){
		//alert(colInfo)
		//document.write(colInfo);
	//}
</script>
<%
if(displayUsage==1||isShow.equalsIgnoreCase("false")){
	%>
	<script language='javascript' type='text/javascript' src='/js/xmlextras_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/xmlextras_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/weaverTable_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/ArrayList_wev8.js'></script>
	<script type="text/javascript">
		
		 eval(colInfo);
		 var _xtable_checkedList = new ArrayList();
	     var _xtalbe_checkedValueList = new ArrayList();
	     var _xtalbe_radiocheckId =""; 
	     var _xtalbe_radiocheckValue = "";
	     var _table;
	</script>
	<SCRIPT FOR=window EVENT=onload LANGUAGE='JavaScript'>
		var isShowThumbnail = "";
		if(displayUsage==1){
			isShowThumbnail="1";
		}
		<%if(offical.equals("1")){%>
			isShowThumbnail="2";
		<%}%>
		<%if(!urlType.equals("13")&&!urlType.equals("14")&&!urlType.equals("15")){%>
			var url = '/weaver/weaver.common.util.taglib.SplitPageXmlServlet';
			<%if(urlType.equals("6") && seccategory!=0){%>
				url = url + "?__objId=<%=seccategory%>&__mould=doccategory"
			<%}%>
	     _table = new weaverTable(url,0, '',
	     sessionId,
		 'run',
		 '',
		 'null',
		 '',
		 '',
		 '',
		 isShowThumbnail,
		 '5',
		 '',
		 '');
		 var showTableDiv  = document.getElementById('_xTable');
	     showTableDiv.appendChild(_table.create());
	     //提示窗口
	     var message_table_Div = document.createElement("div")
	     message_table_Div.id="message_table_Div";
	     message_table_Div.className="xTable_message"; 
	     showTableDiv.appendChild(message_table_Div); 
	     var message_table_Div  = document.getElementById("message_table_Div"); 
	     message_table_Div.style.display=""; 
	     /*if (readCookie("languageidweaver")==8){        
	     	message_table_Div.innerHTML="Executing...."; 
	     } else if(readCookie("languageidweaver")==9){
	     	message_table_Div.innerHTML="服務器正在處理,請稍候....";
	     }else {        
			message_table_Div.innerHTML="服务器正在处理,请稍候...."; 
	     }*/
		message_table_Div.innerHTML = SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver"));
	     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;   
	     var pLeft= document.body.offsetWidth/2-50;   
	     message_table_Div.style.position="absolute"
	     jQuery(message_table_Div).css({
	     	"top":pTop,
	     	"left":pLeft,
	     	"position":"absolute"
	     }).show();
	   <%}%>
	</script>
	<% if("1".equals(useCustomSearch)){%>
			<style type="text/css">
				#_xTable table.ListStyle{
					table-layout:auto!important;
				}
				#_xTable div.table{
					overflow:auto;
				}
				body{
					overflow-y:scroll;
					overflow-x:hidden;
				}
			</style>
			<script type="text/javascript">
				var __orWindowHeight = jQuery(window).height();
				function afterDoWhenLoaded(){
					var _table = jQuery("#_xTable div.table");
					_table.width(jQuery(window).width());
					_table.attr("_oriScrollbar",true);
					_table.height(jQuery(window).height()-45);
					if(jQuery.browser.msie){
						//_table.height(_table.children("table.ListStyle").outerHeight()+20);		
					}
				}
				jQuery(window).bind("resize",function(){
					var _table = jQuery("#_xTable div.table");
					_table.width(jQuery(window).width());
					_table.height(jQuery(window).height()-45);
				});
			</script>
		<%} %>
	<%
} %>

<script type="text/javascript">
 function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
	     //alert(wuiUtil.getJsonValueByIndex(results,0))
	     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
	     $GetEle("usertype").value="1";
	     $GetEle("ownerid2span").innerHTML="";
	     $GetEle("ownerid2").value="";
	     $GetEle("doccreaterid2span").innerHTML="";
	     $GetEle("doccreaterid2").value="";
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     jQuery("input[name='"+inputename+"']").val("");
	     jQuery($GetEle("usertype")).val("");
	  }
	}
}

function afterShowResource(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="1";
		     $GetEle("ownerid2span").innerHTML="";
		     $GetEle("ownerid2").value="";
		     $GetEle("doccreaterid2span").innerHTML="";
		     $GetEle("doccreaterid2").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

function onShowParent(tdname,inputename){
   var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
   if((results)){
      if(wuiUtil.getJsonValueByIndex(results,0)!=""){
       jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1))+"</a>";
       jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
       $GetEle("usertype").value="2";
       
       $GetEle("owneridspan").innerHTML="";
       jQuery("input[name='ownerid']")[0].value="";
	   
	   $GetEle("doccreateridspan").innerHTML="";
	   $GetEle("doccreaterid").value="";
	  }else{
	   jQuery($GetEle(tdname)).html("");
	   $GetEle(inputename).value="";
	   $GetEle("usertype").value="";
	  }
   }
}

function afterShowParent(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="2";
	       $GetEle("owneridspan").innerHTML="";
	       jQuery("input[name='ownerid']")[0].value="";
		   
		   $GetEle("doccreateridspan").innerHTML="";
		   $GetEle("doccreaterid").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

function onShowDept(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowSubcompany(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowLanguage(span,id){
	if(!span)span = "languagespan";
	if(!id)id = "doclangurage";
	var results = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(span)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(id).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(span)).html("");
         $GetEle(id).value="";
	  }
	}
}

function onShowItemCategory(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowCustomer(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowCpt(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowProject(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1))+"</a>";
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowMutiDummy1(input,span){	
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+$GetEle(input).value);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     var dummyidArray=wuiUtil.getJsonValueByIndex(results,0).split(",");
	     var dummynames=wuiUtil.getJsonValueByIndex(results,1).split(",");
	     var sHtml="";
	     for(var i=0;i<dummyidArray.length;i++){
	        if(dummyidArray[i]!=""){
	           //sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[i]+"'>"+dummynames[i]+"</a>&nbsp";
	           sHtml = sHtml+"<a href='#"+dummyidArray[i]+"'>"+dummynames[i]+"</a>&nbsp";
	        }
	     }
	   
	     jQuery($GetEle(span)).html(sHtml);
         $GetEle(input).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(span)).html("");
         $GetEle(input).value="";
	  }
	
	}
}
function onShowBrowser1(id,url,type1){
	if(type1==1){
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
		$GetEle("con"+id+"_valuespan").innerHTML=id1;
    	$GetEle("con"+id+"_value").value=id1;
     }else if(type1==2){
    	id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
 		$GetEle("con"+id+"_value1span").innerHTML=id1;
     	$GetEle("con"+id+"_value1").value=id1;
     }
}
function onShowBrowser(id,url){
	datas = window.showModalDialog(url+"?selectedids="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle("con"+id+"_valuespan").innerHTML=datas.name;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowDepartment(id,url){
	datas = window.showModalDialog(url+"?selectedDepartmentIds="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
            var shtml="";
            if(datas.name.indexOf(",")!=-1){
                 var namearray =datas.name.substr(1).split(",");
                 for(var i=0;i<namearray.length;i++){
                	 shtml +=namearray[i]+" ";
                 }
            }
        	$GetEle("con"+id+"_valuespan").innerHTML=shtml;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}


function onShowBrowserCommon(id,url,type1){

		if(type1==162){
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));

		}
		id1 = window.showModalDialog(url);

		if(id1){

				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						shtml = ""
						ids = ids.substr(1);
						$GetEle("con"+id+"_value").value=ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							shtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;

						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						$GetEle("con"+id+"_value").value=ids;
						shtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;
						return ;
				   }


				}else{
						$GetEle("con"+id+"_valuespan").innerHTML="";
						$GetEle("con"+id+"_value").value="";
						$GetEle("con"+id+"_name").value="";
				}

			}

}

</script>

<script language=vbs>
sub onShowDept1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResource1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
            document.all(tdname).innerHTML = id(1)
            document.all(inputename).value=id(0)
            document.all("usertype").value="1"

            document.all("owner2span2").innerHTML = ""
            document.all("ownerid2").value = "0"

            document.all("doccreaterid2span2").innerHTML = ""
            document.all("doccreaterid2").value = "0"
		else
            document.all(tdname).innerHTML = empty
            document.all(inputename).value=""
            document.all("usertype").value=""
		end if
	end if
end sub

sub onShowParent1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            document.all(tdname).innerHTML = id(1)
            document.all(inputename).value=id(0)
            document.all("usertype").value="2"

            document.all("ownerspan").innerHTML = ""
            document.all("ownerid").value = ""

            document.all("doccreateridspan").innerHTML = ""
            document.all("doccreaterid").value = ""

        else
            document.all(tdname).innerHTML = empty
            document.all(inputename).value=""
            document.all("usertype").value=""
        end if
	end if
end sub

sub onShowLanguage1()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if not isempty(id) then
		if id(0)<>0 then
		languagespan.innerHTML = id(1)
		frmmain.doclangurage.value=id(0)
		else
		languagespan.innerHTML = ""
		frmmain.doclangurage.value=""
		end if
	end if
end sub

sub onShowCustomer1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowProject1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowItem(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowItemCategory1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub
sub onShowCpt1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHTML = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHTML = empty
		document.all(inputename).value=""
		end if
	end if
end sub


sub onShowTreeDocField(spanName,inputeName)
    treeDocFieldId=document.frmMain.treeDocFieldId.value
    url=encode("/docs/category/DocTreeDocFieldBrowserSingle.jsp?superiorFieldId="+treeDocFieldId)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)

	if NOT isempty(id) then
	    if id(0)<> 0 then
            document.all(spanName).innerHTML = id(1)
		    document.all(inputeName).value=id(0)
		else
		    document.all(spanName).innerHTML = empty
		    document.all(inputeName).value="0"
		end if
	end if
end sub


sub onShowMutiDummy2(input,span)	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value)
	if NOT isempty(id) then
	    if id(0)<> "" then	
			dummyidArray=Split(id(0),",")
			dummynames=Split(id(1),",")
			dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

			For k = 0 To dummyLen
				sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a>&nbsp"
			Next

			input.value=id(0)
			span.innerHTML=sHtml
		else			
			input.value=""
			span.innerHTML=""
		end if
	end if
end sub


</script>

<script language=javascript>
var isNeedSubmit = false;
var isUsedCustomSearch = "<%=isUsedCustomSearch%>"
function encode(str){
    return escape(str);
}

function changelevel(tmpindex) {  
    try { //如果只有一个数量的时候就会出现BUG
    	document.all("check_con")(tmpindex-1).checked = true
    } catch (ex)   {
      document.all("check_con").checked = true
    }
}




	
function search(){  //确认搜索提交按钮
	var docSearchForm =$GetEle("frmmain");
	if(isNeedSubmit){
		document.frmmain.submit();
	}
	document.getElementById("isinit").value = "true";
	if(displayUsage==0&&false){
		//if(isinit=="false")
		loadGrid(getSearchPara(),gridUrl);
	}else{
		$GetEle("customSearchPara").value = getSearchPara();
		
		
		docSearchForm.submit();
	}
		

}	

function onBtnSearchClickRight(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		onBtnSearchClick();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			onBtnSearchClick();
		}
	}
}

function onBtnSearchClick(){
   
		try
		{
			document.getElementById("isinit").value = "true";
		}
		catch(e)
		{
		}
		<%if(urlType.equals("13")){%>
			jQuery("#urlType").val("10");
		<%}else if(urlType.equals("14")){%>
			jQuery("#urlType").val("6");
		<%}else if(urlType.equals("15")){%>
			jQuery("#urlType").val("11");
		<%}%>
		$GetEle("self").value='true'
		search();
		
	  					
}


function bacthDownloadImageFile(){
    var btdocids = "";
    var displayUsage="<%=displayUsage%>";
    //alert("---displayUsage:"+displayUsage);
    //60版本当是列表显示模式时用_table._xtable_CheckedCheckboxId()取ids,当是缩略显示模式显示时用_xtable_CheckedCheckboxId()取ids,
    //70版本不区分都使用_xtable_CheckedCheckboxId()取ids
    /*
    if(displayUsage==0){//列表显示模式
      btdocids = _table._xtable_CheckedCheckboxId();
    }else{//缩略显示模式
      btdocids =_xtable_CheckedCheckboxId();
    }
    */
    btdocids =_xtable_CheckedCheckboxId();
    if(btdocids==null ||btdocids==''){
     //alert("请先选择文档，再进行文档附件批量下载！");
     top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27694,language)%>");
     return false;
    }else{
     window.location="/weaver/weaver.file.FileDownload?fieldvalue="+btdocids+"&displayUsage="+displayUsage+"&download=1&downloadBatch=1&docSearchFlag=1&urlType=<%=urlType%>&requestid=";
    }
}
</script>

<script language="javaScript">
userightmenu_self = '<%=userightmenu_self%>';

if(userightmenu_self!=1){
	_divSearchDivHeightNo = 61;
    _divSearchDivHeight=185;
	<%if(userightmenu_self!=1){%>
		eval(rightMenuBarItem = <%=topButton%>);
	<%}%>
}else{
	_divSearchDivHeightNo = 33;
    _divSearchDivHeight=175;
}
_isViewPort=true;
_pageId="ExtDocSearch";  
_divSearchDiv='DocSearchDiv'; 
_defaultSearchStatus='show';  //close //show //more	

var customSearch = false;
var baseDiv = 400;
var basePanel = 360;
var baseRow = 23;
var rowCount=0;
var isLoadCombo = false;
</script>
</body>

<script type="text/javascript">
function setCustomSearch2(seccategory){
	
			jQuery.post(
				'/docs/search/ext/CustomFieldExtProxy.jsp',
				{
					'seccategory' : seccategory
				},
				function(data){					
					jQuery('#customSearchDiv').html(data);		
					customSearch = true;		
					__defaultTemplNamespace__.initLayout();
					jQuery('#customSearchDiv').find('select').each(function(i,v){
						beautySelect(jQuery(v));
					});
				}
			);
	
	}
	
	jQuery(document).ready(function(){
		<%if(isDetach.equals("3")){%>
		
		onBtnSearchClickRight();
		showGroup("SearchDivlab");
		<%}%>
		jQuery(".e8tips").wTooltip({html:true});
		<%if(seccategory!=0){%>
			setCustomSearch2(<%=seccategory%>);
			try{
				parent.parent.selectDefaultNode("categoryid",<%=seccategory%>);
			}catch(e){}
		<%}else{%>
			try{
				parent.parent.cancelSelectedNode();
			}catch(e){}
		<%}%>
		if(!isLoadCombo)
		{
			//ComboBoxExtProxy();
			isLoadCombo = true;
		}
	});
	
	function changeType(val,span1,span2,input){
		if(val=="2"){
			jQuery("#"+span1).val("");
			jQuery("#"+span1+"span").html("");
			jQuery("#"+span2+"selspan").show();
			jQuery("#"+span1+"selspan").hide();
		}else{
			jQuery("#"+span2).val("");
			jQuery("#"+span2+"span").html("");
			jQuery("#"+span1+"selspan").show();
			jQuery("#"+span2+"selspan").hide();
		}
		if(input){
			jQuery("input[name='" + input + "']").val(val);
		}
	}
		
	
    function showSearchAdvice(obj){
    	
        if(jQuery("#advicedSearchDiv").is(":hidden")){
           jQuery("#advicedSearchDiv").show();
           jQuery("#searchAdviceImg").attr("src","/images/up_wev8.png");
        }else{
           jQuery("#advicedSearchDiv").hide();
           jQuery("#searchAdviceImg").attr("src","/images/down_wev8.png");
        }
    }


</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>