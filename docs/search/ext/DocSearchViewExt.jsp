
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/docs/DocDetailLog.jsp"%>
<Div id="divDummy" width="300px" height="160px" style='border:1px solid #CDCDCD;display:none;width:300px;height:160px;background-color:#FFFFFF;overflow:auto'>
<TABLE  style='width:100%;' cellspacing='0' cellpadding='0' valign='top'>
			<TR>
				<TD  style='background-color:#999999;color:#FFFFFF;height:24px'><div style='width:87%;float:left'>&nbsp;<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%></div> <div><a href='javaScript:onCloseImport()'>[<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>]</a></div></TD>
		   </TR>	
			<TR><TD id='tdContent'>
			 <table class='viewform' width="100%" height="100%" id='tblSetting' cellspacing='0' cellpadding='0' class='ViewForm' valign='top'>
				 	 <TR >
					  <TD  style='height:20px;width:30%'>&nbsp;<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></TD>
					  <TD class='field' style='height:20px;width:70%'><button class=Browser type="button" onClick="onShowMutiDummy(document.getElementById('txtDummy'),document.getElementById('spanDummy'))"></button> <input type="hidden" id="txtDummy"  name="txtDummy"><span id="spanDummy"></span></TD>
					</TR>
					<TR colspan='2' style="height:1px;" ><TD  CLASS='line'></TD></TR>						
				</table>
				<br>


				<table class='viewform' id='tblUploading' cellspacing='0' cellpadding='0' valign='top' style='display:none;text-align:center'>
				 <TR>
					<TD id="tdUploading">
						<img src="/images/loading_wev8.gif">&nbsp;<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...	
					</TD>				   
				 </TR>
			 </table>
			
			</TD></TR>
	</TABLE>
</TD>  
</TR>      
</TABLE>
</Div>
<input type="hidden" id="txtSql"  name="txtSql">
<input type="hidden" id="txtDocs"  name="txtDocs">
<input type="hidden" id="txtStatus"  name="txtStatus">
<%	
	RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
	RecordSet.next();
	int docsrecycleIsOpen=Util.getIntValue(RecordSet.getString("propvalue"),0);
	RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsautoclean'");
	RecordSet.next();
	int autoclean=Util.getIntValue(RecordSet.getString("propvalue"),0);
	RecordSet.executeSql("select propvalue from   doc_prop  where propkey='autodeletedays'");
	RecordSet.next();
	int deletedays=Util.getIntValue(RecordSet.getString("propvalue"),30);	
%>
<script language="javaScript">


	function doSubscribe(){
		parent.parent.location.href= "/docs/tabs/DocCommonTab.jsp?_fromURL=93&from=docsubscribe&ishow=false";
	}

	function miniatureDisplay(){
		//$("ipnut[name=displayUsage]").val(1);
		//jQuery("ipnut[name=displayUsage]").val(1)
		$GetEle("displayUsage").value=1;
		var docSearchForm= $('form[name=frmmain]')[0];
		docSearchForm.submit();
	}
	
	function listDisplay(){
		//$("ipnut[name=displayUsage]").val(0);
		//jQuery("ipnut[name=displayUsage]").val(0)
		$GetEle("displayUsage").value=0;
		//var docSearchForm = document.getElementById('frmmain');
		var docSearchForm= $GetEle("frmmain");
		docSearchForm.submit();
	}
	
	
   function initToDummy(txtDocs,txtStatus,txtSql){
	   /*var pTop= document.body.offsetHeight/2+document.body.scrollTop-100;
	   var pLeft= document.body.offsetWidth/2-180;
		
		divDummy.style.position="absolute"
		divDummy.style.top=pTop+"px";
		divDummy.style.left=pLeft+"px";
		divDummy.style.display="inline";
		document.getElementById("spanDummy").innerHTML="";
		document.getElementById("txtDummy").value="";*/
		var dialog = new top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>"; 
		dialog.Height = 300;
		dialog.Width = 600;
		dialog.URL = "/docs/search/ext/DocSearchViewExtNew.jsp?txtDocs="+txtDocs+"&txtStatus="+txtStatus+"&txtSql="+txtSql;
		dialog.show();
		
		
   }
   function importSelectedToDummy(){ 
   		//alert(tableJson);
   		//_table.getCheckBoxValue();
   		//alert(_table._xtable_CheckedCheckboxId());
   		var txtValue = "";
   		if(<%=displayUsage%> == 0&&false)
   		{
			txtValue=_table._xtable_CheckedCheckboxId();
		}
		else
		{
			txtValue=_xtable_CheckedCheckboxId();
		}
		if(txtValue=="") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
		} else {
			initToDummy(txtValue,1);
			//txtStatus.value=1;   
		}
	}
		

   function importAllToDummy(){ 
		initToDummy("",2,sessionId); 
		//txtStatus.value=2;
		//txtSql.value=sessionId;
   }
   function onCloseImport(){
	   tblSetting.style.display='';
	   tblUploading.style.display='none';
	   divDummy.style.display='none';
   }

   function showMsg(txt){		
		tdUploading.innerHTML=txt;
   }

   function onImporting(){
	   tblSetting.style.display='none';
	   tblUploading.style.display='';


	    var importHttp =null;
	    try{
	    	importHttp =new ActiveXObject("Microsoft.XMLHTTP");	  
	    }catch(e){
	    	importHttp =new XMLHttpRequest(); 
	    }
		var actionUrl="/docs/search/DocUpToDummy.jsp?method=add&txtDummy="+txtDummy.value+"&txtSql="+txtSql.value+"&txtDocs="+txtDocs.value+"&txtStatus="+txtStatus.value;		
		//document.write(actionUrl)
		//alert(actionUrl);
		importHttp.open("get",actionUrl, true);
		//alert(importHttp.readyState);   
		importHttp.onreadystatechange = function () {	
			switch (importHttp.readyState) {			   
			   case 4 : 
				    var txt=importHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");;					
					if(txt=="success") {
						//this.onCloseImport();
						//alert('aaa');
						onCloseImport();
					} else {
						//this.showMsg(txt)
						//alert(txt);
						showMsg(txt);
					}					 
			} 
		}	
		
		importHttp.setRequestHeader("Content-Type","text/xml")	

		importHttp.send(null);	
		
   }
</script>


<script language="vbscript">
	
	sub onShowMutiDummy(input,span)	
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1")
		'msgbox("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1")
		if NOT isempty(id) then
			if id(0)<> "" then	
				dummyidArray=Split(id(0),",")
				dummynames=Split(id(1),",")
				dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

				For k = 0 To dummyLen
					sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a><br>"
				Next				
				if sHtml<>"" then
					sHtml=sHtml&"<input type=button value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>	' onclick='onImporting()'>"
			     end if
			     
				input.value=id(0)
				span.innerHTML=sHtml
			else			
				input.value=""
				span.innerHTML=""
			end if
		end if
	end sub
</script>
<script language="javascript">
		function onShowMutiDummy(input,span){
			var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1","",
				"dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

			if (datas) {
				if (datas.id!= ""){
					dummyidArray=datas.id.split(",");
					dummynames=datas.name.split(",");
					dummyLen=dummyidArray.length;
					sHtml="";
					for(var k=0;k<dummyLen;k++){
						sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a><br>"
					}
					if (sHtml!=""){
						sHtml=sHtml+"<input type=button value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>' onclick='onImporting();'>";
					}
					input.value=datas.id;
					$(span).html(sHtml);
				}
				else{			
					input.value="";
					span.innerHTML="";
				}
			}
		}	
	</script>
<script language="javaScript">
	var docid;
    function onSearch(){
        frmSearch.submit();    
    }
	var dialog = null;
    function doDocDel(docid,isMulti,isLast){
        if (isMulti || isdel()){
        	var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
        	jQuery.ajax({
        		url : url , 
				data : {},
				url : url ,
				type: 'POST',
				async:false,
				success: function ( data) {
					if(isMulti==null || isMulti==false || isLast){
						//alert(result.responseText.trim());
	       				//Ext.Msg.alert('Status', result.responseText.trim());
	       				_table.reLoad();
						_xtable_CleanCheckedCheckbox();
	       			}
				},
				error: function ( xhr) { 
					//Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result);
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>"); 
				} 
			});
        }
    }
    
    //批量删除文档
	var docsrecycleIsOpen=<%=docsrecycleIsOpen%>;
	var autoclean=<%=autoclean%>;
	var deletedays=<%=deletedays%>;
	var deletetips="<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	if(docsrecycleIsOpen==1&&autoclean!=1){
		deletetips="<%=SystemEnv.getHtmlLabelName(130656,user.getLanguage())%>";
	}else if(docsrecycleIsOpen==1&&autoclean==1){
		deletetips="<%=SystemEnv.getHtmlLabelName(130656,user.getLanguage())%><br><span style='color:red'>&nbsp;&nbsp;("+deletedays+"<%=SystemEnv.getHtmlLabelName(130657,user.getLanguage())%>)</span>";
	}
	<%if(user.getLogintype().equals("2")){%>//客户
		deletetips="<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	<%}%>
    function doMuliDelete(delDocIds){
    	if(!delDocIds){
    		delDocIds = _xtable_CheckedCheckboxId();
    	}
    	if(!delDocIds){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
			return;
		}
		var delIdArr = delDocIds.split(",");
    	top.Dialog.confirm(deletetips,function(){
    		var isLast = false;
    		for(var i=0;i<delIdArr.length;i++){
    			if(i==delIdArr.length-1)
    				isLast = true;
    			doDocDel(delIdArr[i],true,isLast);
    		}
    	});
    }

    function doDocShare(docid){        
		//var DocSharePane=new DocShareSnip(docid,true).getGrid();
		
        /*var winShare = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 600,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.share,
	        items: DocSharePane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	        	winShare.hide();
	            }
	        }]
	    });
        winShare.show(null);*/
         dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(1985,user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 510;
		dialog.checkDataChange = false;
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=46&isdialog=1&id="+docid;
		dialog.maxiumnable = true;
		//dialog.DefaultMax = true;
		dialog.show();
        //var url = "/docs/docs/DocOperate.jsp?operation=share&docid="+docid;
        //openFullWindowHaveBar(url);
    }
    function doDocViewLog(docid){
    	
    	//var DocDetailLogPane=getDocDetailLogPane(docid,500,300,false);
        /*var winLog = new Ext.Window({
        	//id:'DocSearchViewWinLog',
	        layout: 'fit',
	        width: 600,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        //plain: true,
	        modal: true,
	        title: wmsg.doc.detailLog,
	        items: DocDetailLogPane,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	                 winLog.hide();
	            }
	        }]
	    });
	    winLog.show(null);    */
	    dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 500;
		dialog.checkDataChange = false;
		dialog.URL = "/docs/DocDetailLogTab.jsp?_fromURL=0&isdialog=1&id="+docid;
		dialog.maxiumnable = true;
		dialog.show();
       
    }
    function signReaded(signReadbtn){
        var signReadIds = "";
        if(<%=displayUsage%> == 0&&false)
   		{
			signReadIds=_table._xtable_CheckedCheckboxId();
		}
		else
		{
			signReadIds = _xtable_CheckedCheckboxId();
		}
        if (signReadIds==""){
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
            return ;
        }
        /*document.frmmain.action="/docs/search/DocSearchOperation.jsp";
        document.frmmain.operation.value="signReaded";        
       
		document.frmmain.signValus.value=signReadIds;
        document.frmmain.submit();*/
        jQuery.ajax({
			url:"/docs/search/DocSearchOperation.jsp",
			data:{
				operation:"signReaded",
				signValus:signReadIds
			},
			type:"post",
			dataType:"html",
			beforeSend:function(){
				jQuery(signReadbtn).attr('disabled','disabled');
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(xhr,status){
				e8showAjaxTips("",false);
			},
			success:function(data){
				jQuery(signReadbtn).removeAttr('disabled');
				_table.reLoad();
				_xtable_CleanCheckedCheckbox();
				refreshLeftTreeNumForDoc(0);
			}
		});
    }
    
    /*订阅相关 start */
    function onAgree(id) {
		var docIds = "";
		if(!id){
			id=_xtable_CheckedCheckboxId();
			docIds = _xtable_CheckedCheckboxValue();
		}else{
			docIds = jQuery("#_xTable_"+id).val();
		}
    	if(!id){
    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
	        return;
    	}
		var idArr = id.split(",");
		var otherDocId = "";
		for(var i=0;i<idArr.length;i++){
			if(idArr[i]){
				otherDocId = jQuery("#otherDocId_"+idArr[i]).val();
				if(otherDocId){
					var input = jQuery(document.frmmain).find("#otherDocId_"+idArr[i]);
					if(input.length==0){
						input = jQuery("<input type='hidden' id='otherDocId_"+idArr[i]+"' name='otherDocId_"+idArr[i]+"'></input");
						jQuery(document.frmmain).append(input);
					}
					input.val(otherDocId);
				}
			}
		}
       document.frmmain.operation.value="approve";
       document.frmmain.action="/docs/docsubscribe/DocSubscribeOperate.jsp" ;                
       document.frmmain.subscribeIds.value=id;
       document.frmmain.docIds.value=docIds;
       //obj.disabled = true ;
       document.frmmain.submit();
     }
     
     function onReject(id){
		var docIds = "";
		if(!id){
			id=_xtable_CheckedCheckboxId();
			docIds = _xtable_CheckedCheckboxValue();
		}else{
			docIds = jQuery("#_xTable_"+id).val();
		}
    	if(!id){
    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
	        return;
    	} 
       document.frmmain.operation.value="reject";       
       document.frmmain.action="/docs/docsubscribe/DocSubscribeOperate.jsp" ;                
       document.frmmain.subscribeIds.value=id;
       document.frmmain.docIds.value=docIds;
       //obj.disabled = true ;
       document.frmmain.submit();
     }
     
     function onGetBack(id) {      
		var docIds = "";
		if(!id){
			id=_xtable_CheckedCheckboxId();
			docIds = _xtable_CheckedCheckboxValue();
		}else{
			docIds = jQuery("#_xTable_"+id).val();
		}
    	if(!id){
    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
	        return;
    	}                      
        document.frmmain.operation.value="getback";       
        document.frmmain.action="/docs/docsubscribe/DocSubscribeOperate.jsp" ;                
        document.frmmain.subscribeIds.value=id;
        document.frmmain.docIds.value=docIds;
       // obj.disabled = true ;
        document.frmmain.submit();;
      }
     
    /*订阅相关 end */
    
    /*批量共享相关 start*/
    
     function shareNext(obj){
	    var sharedocids = _xtable_CheckedCheckboxId();
	    if(sharedocids==""){
	        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
	        return;
	    }
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(31794,user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 450;
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=45&urlType=10&sharedocids="+sharedocids;
		dialog.maxiumnable = true;
		dialog.show();
	    //document.frmmain.action="/docs/docs/ShareMutiDocTo.jsp?sharedocids="+sharedocids;
	    //document.frmmain.submit();
	}
    
    /*批量共享相关 end*/
    
    /*批量调整共享相关 start*/
	
	function shareNextManage(obj){
	    var sharedocids = _xtable_CheckedCheckboxId();
	    if(sharedocids==""){
	        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
	        return;
	    }
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(31794,user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 450;
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=45&urlType=11&sharedocids="+sharedocids;
		dialog.maxiumnable = true;
		dialog.show();
	    //document.frmmain.action="/docs/docs/ShareMutiDocTo.jsp?sharedocids="+sharedocids;
	    //document.frmmain.submit();
	}
	
	 function shareEntire(obj){
		
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(31794,user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 450;
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=45&urlType=11&sharedocids=shareentire";
		dialog.maxiumnable = true;
		dialog.show();
	    //document.docshare.action="/docs/docs/ShareManageDocTo.jsp?sharedocids=shareentire";
		
	       //document.frmmain.submit();
	
	    
	}
    /*批量调整共享相关 end*/
    
    
    function closeDialog(){
    	dialog.close();
    }
    
    /*文档弹窗设置 start*/
    function showDetailInfo(id){
    	if(!!id){}else{
    		id = getCheckedId();
    	}
    	if(!id){
    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83439,user.getLanguage())%>");
    		return;
    	}
    	var forwardurl = "/docs/tabs/DocCommonTab.jsp?_fromURL=31&docsid="+id;
    	dialog = new window.top.Dialog();
    	dialog.currentWindow = window;
    	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21885,user.getLanguage())%>";
    	dialog.Width = 600;
		dialog.Height = 357;
		dialog.Drag = true;
		dialog.URL = forwardurl;
		//dialog.okLabel = "提交";
	   	//dialog.cancelLabel = "取消";
	   	//dialog.textAlign = "center";
	   	/*dialog.OKEvent = function(){
			jQuery("iframe[id^='_DialogFrame_']").get(0).contentWindow.doSave(dialog);	
		}
	   	dialog.CancelEvent = function(){
			dialog.close();
		}*/
		dialog.show();
    }
    /*文档弹窗设置 end*/
    
	function treeView(){
		
	}
	function viewbyOrganization(){
		
	}
	function sutraView(){
		
	}

    function viewByTreeDocField(){
		
    }   
</script>

