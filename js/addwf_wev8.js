function settab00(){
	document.all('tab000if').src=tabiframesrc;
}

function onShowWorkFlowBase(wfid,expwfid) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowserMuti.jsp?wfid="+wfid, "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
	 
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			if(confirm("是否导入（"+wuiUtil.getJsonValueByIndex(retValue, 1)+"）的默认属性设置?")){
			  doGet(tab0006,"/workflow/workflow/Browsedatadefinition.jsp?ajax=1&wfid="+wfid+"&expwfid="+wuiUtil.getJsonValueByIndex(retValue, 0));
			}
		} 
	}
}

function onShow2(fieldid,type,workflowid,browsespan){
 tmpids=uescape("?fieldid="+fieldid+"&type="+type+"&workflowid="+workflowid);
 datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/RequestBrowserfunction.jsp"+tmpids);
 doGet(tab0006, tab0006URL);
 }
 
 function uescape(url){
    return escape(url);
}
 

function setNowTab(tabname)
//设置当前选择的标签且从后台取数据
{
	nowtab = tabname;
	
	if("tab0" == tabname)
	{
		if(tab1OldURL != tab1URL)
		{
			doGet(tab1, tab1URL);
			tab1OldURL = tab1URL;
		}		
	}
	else if("tab00" == tabname)
	{
		if(tab01oldurl != tab01url)
		{
			doGet(tab01, tab01url);
			tab01oldurl = tab01url;
		}
	} else if("tab000" == tabname){
		if(tab001OldURL != tab0012URL)
		{
			doGet(tab001, tab0012URL);
			tab001OldURL = tab0012URL;
		}	
		//在编辑完字段信息，当点击节点信息、出口信息时，需要刷新页面 TD5395 
		if("tab002" == nowtab0)
		{
			tab2ref();
		}
		else if("tab003" == nowtab0)
		{
			tab3ref();
		}	
	} else if("tab0000" == tabname)
	{
		if(tab0007OldURL != tab0007URL)
		{
			doGet(tab0007, tab0007URL);
			tab0007OldURL = tab0007URL;
		}
	}
}

function setnowtab0(tabname){
	nowtab0=tabname;
	//nowtab = tabname;
}
function setnowtab1(tabname){
	nowtab1=tabname;
}

/*============ 高级设置 ============*/
function setNowTab0000(tabName)
{
	nowtab = tabName;

	if(tab0005OldURL != tab0005URL)
	{
		doGet(tab0005, tab0005URL);
		tab0005OldURL = tab0005URL;
	}
}

function setNowTab0002(tabName)
{
	nowtab = tabName;

	if(tab0006OldURL != tab0006URL)
	{
		doGet(tab0006, tab0006URL);
		tab0006OldURL = tab0006URL;
	}
}

function setNowTab0011(tabName)
{
	nowtab = tabName;

	if(tab0011OldURL != tab0011URL)
	{
		doGet(tab0011, tab0011URL);
		tab0011OldURL = tab0011URL;
	}
}
function setNowTab0010(tabName){
    nowtab = tabName;
    if(tab0010OldURL != tab0010URL){
        doGet(tab0010, tab0010URL);
        tab0010OldURL = tab0010URL;
    }
}

function setNowTab0009(tabName){
    nowtab = tabName;
    if(tab0009OldURL != tab0009URL){
        doGet(tab0009, tab0009URL);
        tab0009OldURL = tab0009URL;
    }
}
function setNowTab0006(tabName){
    nowtab = tabName;
    if(tab0006OldURL != tab0006URL){
        doGet(tab0006, tab0006URL);
        tab0006OldURL = tab0006URL;
    }
}
var tab_t = "tab0007";
function setNowTab00000(tabName)
{
	nowtab = tabName;
	if(tabName == "tab0007"){
		tab_t = tabName;
	}else if(tabName == "tab0008"){
		tab_t = tabName;
	}else if(tabName == "tab00000"){
		nowtab = tab_t;
	}
	if(tabName=="tab0008"){
		doGet(tab0008,"/workflow/workflow/fieldTrigger.jsp?ajax=1&wfid="+workflowidAll);
	}else{
	//if(tab000001OldURL != tab000001URL)
	//{
		doGet(tab0007, tab0007URL);
		tab0007OldURL = tab0007URL;
	//}
	}
}
function tab12ref(){
	doGet(tab0008,"/workflow/workflow/fieldTrigger.jsp?ajax=1&wfid="+workflowidAll);
	tab_t = "tab0008";
	setnowtab0('tab0008');
}
var focus_e;
function showRightClickMenu(e){
        focus_e = document.activeElement;
        var event = e?e:(window.event?window.event:null);
		var rightedge=document.body.clientWidth-event.clientX;
		var bottomedge=document.body.clientHeight-event.clientY;
		if (rightedge<rightMenu.offsetWidth){
			rightMenu.style.left=document.body.scrollLeft+event.clientX-rightMenu.offsetWidth-100;
		}else{
			rightMenu.style.left=document.body.scrollLeft+event.clientX-100;
		}
		var hasVersionMark =  document.getElementById("hasVersionMark").value;
		var hasVersionHeiht = 0;
		if(hasVersionMark=="true") 
			hasVersionHeiht=30;
		if (bottomedge<rightMenu.offsetHeight){
			if(nowtab=="tab0"){
			rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0").offsetTop-document.getElementById("tab1").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab0).scrollTop-hasVersionHeiht;
			}
			else if(nowtab=="tab00"){
			rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab00").offsetTop-document.getElementById("tab01").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab1).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab000"||nowtab=="tab001"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab000").offsetTop-document.getElementById("tab001").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0002"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0002").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0003"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0003").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0004"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0004").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0005"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0005").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0006"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0006").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0007"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0007").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0008"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0008").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0009"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0009").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0010"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0010").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0011"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0011").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0006"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0006").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab00000"||nowtab=="tab0007"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab00000").offsetTop-document.getElementById("tab0007").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0008"){
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab00000").offsetTop-document.getElementById("tab0008").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}
		}else{
			if(nowtab=="tab0"){
			rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0").offsetTop-document.getElementById("tab1").offsetTop+document.getElementById(nowtab0).scrollTop-hasVersionHeiht;
			}
			else if(nowtab=="tab00"){

			rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab00").offsetTop-document.getElementById("tab01").offsetTop+document.getElementById(nowtab1).scrollTop-hasVersionHeiht;
			}
			else if(nowtab=="tab000"||nowtab=="tab001")
			{
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab000").offsetTop-document.getElementById("tab001").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0002")
			{
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0002").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0003")
			{
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0003").offsetTop-rightMenu.offsetHeight+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
            }else if(nowtab=="tab0004"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0004").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0005"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0005").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0006"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0006").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0007"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0007").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0008"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0008").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0009"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0009").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0010"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0010").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0011"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0011").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0006"){
            	rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab0000").offsetTop-document.getElementById("tab0006").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab00000"||nowtab=="tab0007")
			{
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab00000").offsetTop-document.getElementById("tab0007").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}else if(nowtab=="tab0008")
			{
				rightMenu.style.top=document.body.scrollTop+event.clientY-document.getElementById("tab00000").offsetTop-document.getElementById("tab0008").offsetTop+document.getElementById(nowtab).scrollTop-hasVersionHeiht;
			}
		}
		
		//判断当前tab页是否为 节点信息
		if(nowtab == "tab000" &&  nowtab0 == "tab002"){
			//当前body滚动条的拉动值 , 可变值     测试值为0
			var bodyTop = document.body.scrollTop;
			//当前body的总高度, 定值                   测试值为844
			var bodyCt = document.body.clientHeight;
			//tab2即为当前tab页(节点信息tab页)滚动条的拉动值,  可变值
			var tabTop = document.getElementById("tab002").scrollTop;
			//tab2即为当前tab页(节点信息tab页)可滚动的高度值,    变值
			var tabHeight = document.getElementById("tab002").scrollHeight;
			//tab2即为当前tab页(节点信息tab页)的总高度,   变值
			var tabCt = document.getElementById("tab002").clientHeight;
			//可获得该公式        scrollHeight  =   clientHeight   +   scrollTop的最大值
			if ((tabTop + event.clientY) > (bodyCt - 2.5 * (rightMenu.offsetHeight) + tabHeight - tabCt)){
				rightMenu.style.top = bodyTop + bodyCt - 2.5 * (rightMenu.offsetHeight) + tabHeight - tabCt;
			} else {
				rightMenu.style.top = bodyTop + tabTop + event.clientY  - rightMenu.offsetHeight;
			}
		}
		
		rightMenu.style.visibility="visible";
		return false;
}
var mouse_event;
function onRCMenu_copy(){
	var copy_text = document.selection.createRange().text;
	//alert(copy_text);
	window.clipboardData.setData("Text", copy_text);
	rightMenu.style.visibility="hidden";
}

function onRCMenu_plaster(){
	if(window.clipboardData.getData("Text") != null){
		try{
			var plaster_text = window.clipboardData.getData("Text");
			//e = document.activeElement;
			//e = body.focus;
            //alert(focus_e.tagName);
			if(focus_e && focus_e.tagName=="INPUT" && focus_e.type=="text"){
				focus_e.value += plaster_text;
			}else if(focus_e && focus_e.tagName=="TEXTAREA"){
				focus_e.value += plaster_text;
			}
			rightMenu.style.visibility="hidden";
		}catch(e){
        }
	}
}
function nodeedit() {
		doGet(tab002, "/workflow/workflow/addwfnode.jsp?ajax=1&src=editwf&wfid="+workflowidAll);
	}
function toformtab(){
	tab01oldurl="";
	tab01url="/workflow/form/addform.jsp?ajax=1&isformadd=1";
	document.getElementsByTagName("ul")[4].getElementsByTagName("li")[1].click();
	document.getElementsByTagName("ul")[1].getElementsByTagName("li")[0].click();
	tab02oldurl="";
	tab03oldurl="";
	tab04oldurl="";
	tab05oldurl="";
	tab02iframesrc="/workflow/workflow/wfError.jsp";
	tab03url="/workflow/workflow/wfError.jsp";
	tab04url="/workflow/workflow/wfError.jsp";
	tab05url="/workflow/workflow/wfError.jsp";
}
function upselect(formnames,formids){
	var otab=document.getElementById("oTable1");
	var len=otab.options.length;
	otab.options[len]=new Option(formnames,formids);
	tab02iframesrc="/workflow/form/addformfield.jsp?formid="+formids;
	tab03url="/workflow/form/addformfieldlabel.jsp?ajax=1&formid="+formids;
	tab04url="/workflow/form/addformrowcal.jsp?ajax=1&formid="+formids;
	tab05url="/workflow/form/addformcolcal.jsp?ajax=1&formid="+formids;
}
function upselect_new(formnames,formids){
	var otab=document.getElementById("oTable1");
	var len=otab.options.length;
	otab.options[len]=new Option(formnames,formids);
	tab02iframesrc="/workflow/form/editformfield.jsp?formid="+formids;
	tab03url="/workflow/form/addformfieldlabel0.jsp?ajax=1&formid="+formids;
	tab04url="/workflow/form/addformrowcal0.jsp?ajax=1&formid="+formids;
	tab05url="/workflow/form/addformcolcal0.jsp?ajax=1&formid="+formids;
}

function cancelEditNode(){
	try {
		delids = "";
	} catch (e) {}
	doGet(tab002, "/workflow/workflow/Editwfnode.jsp?ajax=1&wfid="+workflowidAll  );
}
function nodefieldedit(id){
		doGet(tab002, "/workflow/workflow/addwfnodefield.jsp?ajax=1&wfid="+workflowidAll+"&nodeid="+id  );
	}
function nodefieldbatchset(nodeid,ajax){
	doGet(tab002, "/workflow/workflow/edithtmlnodefield.jsp?wfid="+workflowidAll+"&nodeid="+nodeid+"&ajax="+ajax);
}
function cancelBatchSet(tmpnodeid){
	doGet(tab002, "/workflow/workflow/addwfnodefield.jsp?ajax=1&wfid="+workflowidAll+"&nodeid="+tmpnodeid);
}
function showHtmlLayoutFck(formid,wfid,nodeid,isbill,layouttype,ajax,modeid){
	openFullWindowHaveBar("/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype="+layouttype+"&ajax="+ajax+"&modeid="+modeid)
}

function callFunction(formid,wfid,nodeid,isbill,layouttype,ajax){
	var needprep = "1";
	var modeid = "0";
	try{
		needprep = nodefieldhtml.needprep.value;
		modeid = nodefieldhtml.modeid.value;
	}catch(e){}
	if(needprep == "0"){
		showHtmlLayoutFck(formid,wfid,nodeid,isbill,layouttype,ajax,modeid);
	}else{
		window.setTimeout(function(){callFunction(formid,wfid,nodeid,isbill,layouttype,ajax);},1000);
	}
}
function nodefieldsave(){
	tab0007OldURL="";
	doPost(nodefieldform,tab002) ;
}
//表单管理页面－－begin
function formaddtab(){
	doGet(tab01,"/workflow/form/addform.jsp?ajax=1");
}
function doSearchForm(){
	fromaddtab.action = "/workflow/form/manageform.jsp";
	doPost(fromaddtab,tab01);
}
function copytemplate(obj){
	if (check_form(weaver,'wfname,subcompanyid')) {
		  weaver.submit();
		obj.disabled=true;
		parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=1";
   }
}
function Savetemplate(workflowids){
	doGet(tab1,"/workflow/workflow/addwf0.jsp?isTemplate=1&isSaveas=1&ajax=1&templateid="+workflowids);
}
function exportWorkflow(workflowid){
	var xmlHttp = ajaxinit();
	xmlHttp.open("post","/workflow/export/wf_operationxml.jsp", true);
	var postStr = "src=export&wfid="+workflowid;
	xmlHttp.onreadystatechange = function () 
	{
		switch (xmlHttp.readyState) 
		{
		   case 4 : 
		   		if (xmlHttp.status==200)
		   		{
		   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
		   			window.open(downxml,"_self");
		   		}
			    break;
		} 
	}
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
	xmlHttp.send(postStr);
}
function unselectall()
{
	if(document.fromaddtab.checkall0.checked){
	document.fromaddtab.checkall0.checked =0;
	}
}
function formCheckAll(checked) {
	len = document.fromaddtab.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.fromaddtab.elements[i].name=='delete_form_id') {
			if(!document.fromaddtab.elements[i].disabled){
				document.fromaddtab.elements[i].checked=(checked==true?true:false);
			}
		}
	}
}
function addformtabsubmit(obj){
	if (check_form(addformtabf,'formname,subcompanyid')){
		tab02oldurl="";
		tab03oldurl="";
		tab04oldurl="";
		tab05oldurl="";
		doPost(addformtabf,tab01);
		obj.disabled=true;
	}
}
function addformtabsubmit0(obj){
	if(check_form(addformtabspecial,'formname,subcompanyid')){
		doPost(addformtabspecial,tab01);
		obj.disabled=true;
	}
}
function addformtabretun(){
	doGet(tab01,"/workflow/form/manageform.jsp?ajax=1");
}
function deleteform(){
	if(isdel()){
		addformtabspecial.action = "/workflow/form/delforms.jsp";
		doPost(addformtabspecial,tab01);
	}
}
function gotab00(url,formid){
	var tempframesrc="/workflow/form/addformfield.jsp?nocancelmenuflag=nocancelmenu&formid="+formid;
	tab02iframesrc=tempframesrc;
	tab03url="/workflow/form/addformfieldlabel.jsp?ajax=1&formid="+formid;
	tab04url="/workflow/form/addformrowcal.jsp?ajax=1&formid="+formid;
	tab05url="/workflow/form/addformcolcal.jsp?ajax=1&formid="+formid;
	doGet(tab01,url);
}
function gotab00_new(url,formid){
	var tempframesrc="/workflow/form/editformfield.jsp?formid="+formid;
	tab02iframesrc=tempframesrc;
	tab03url="/workflow/form/addformfieldlabel0.jsp?ajax=1&formid="+formid;
	tab04url="/workflow/form/addformrowcal0.jsp?ajax=1&formid="+formid;
	tab05url="/workflow/form/addformcolcal0.jsp?ajax=1&formid="+formid;
	doGet(tab01,url);
}
function tab02ref(){
	document.all("tab02iframe").src=tab02iframesrc;
}
function tab03ref(){
	doGet(tab03,tab03url);
	setnowtab1('tab03');
}
function tab04ref(){
	doGet(tab04,tab04url);
	setnowtab1('tab04');
}
function tab05ref(){
	doGet(tab05,tab05url);
	setnowtab1('tab05');
}
function setDesignTime() {
	designTime = '&designTime='+new Date();
	isEdit = 0;
}
function tab2ref(){
	var tmpURL = tab002URL+designTime;
	if(isEdit==1&&usrId!=editor) tmpURL = wfEditor;
	if(tab002OldURL!=tmpURL){
		doGet(tab002,tmpURL);
		tab002OldURL=tmpURL;
	}
	setnowtab0('tab002');
}
function tab3ref(){
	var tmpURL = tab003URL+designTime;
	if(isEdit==1&&usrId!=editor) tmpURL = wfEditor;
	if(tab003OldURL!=tmpURL){
		doGet(tab003,tmpURL);
		tab003OldURL=tmpURL;
	}
	setnowtab0('tab003');
}
function tab4ref(){
	var tmpURL = tab4url+designTime;
	if(tab4oldurl!=tmpURL){
		doGet(tab001,tmpURL);
		tab4oldurl=tmpURL;
	}
	setnowtab0('tab001');
}
function tab0001ref(){
	if(tab0001OldURL!=tab0001URL){
		doGet(tab0001,tab0001URL);
		tab0001OldURL=tab0001URL;
	}
	setnowtab0('tab0001');
}
function tab9ref(){
	if(tab9oldurl!=tab9url){
		doGet(tab9,tab9url);
		tab9oldurl=tab9url;
	}
	setnowtab0('tab9');
	
}
function tab0003ref(){
	if(tab0003OldURL!=tab0003URL){
		doGet(tab0003,tab0003URL);
		tab0003OldURL=tab0003URL;
	}
	setnowtab0('tab0003');
}
function tab0004ref(){
	if(tab0004OldURL!=tab0004URL){
		doGet(tab0004,tab0004URL);
		tab0004OldURL=tab0004URL;
	}
	setnowtab0('tab0004');
}
function fieldselectall(obj){
	tmpstr="";
	destinationList = window.document.tabfieldfrm.destList;
	for(var count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.tabfieldfrm.formfields.value=tmpstr;

	tmpstr="";
	destinationList = window.document.tabfieldfrm.destList2;
	for(count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.tabfieldfrm.formfields2.value=tmpstr;
	window.document.tabfieldfrm.rownum.value=fromfieldoTable.tBodies[0].rows.length - 1;
	var len=fromfieldoTable.tBodies[0].rows.length - 1;
	for(var i=0;i<len;i++)
	{
	dstlists=document.all("destListMul"+i);
	for(var count = 0; count <= dstlists.options.length - 1; count++)
	 {
	  dstlists.options[count].selected=true;
	 }
	 }
	tab03oldurl="";
	tab04oldurl="";
	tab05oldurl="";
	
	tab2oldurl = "";  //TD5395
	tab3oldurl = "";  //TD5395
	
	doPost(tabfieldfrm,tab02);
	//window.document.tabfieldfrm.submit();
	obj.disabled=true;
}

// Add the selected items from the source to destination listMul
function addSrcToDestList3(src,dst) {
	srcList= document.all(src);
	destList=document.all(dst);
	var len = destList.length;
	//window.document.tabfieldfrm.destList2;
	//srcList = window.document.tabfieldfrm.srcList2;	
	var rowindex = fromfieldoTable.tBodies[0].rows.length - 1;
	destList1 = window.document.tabfieldfrm.destList2;
	var len2 = destList1.length;
	
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			//var found1 = false;
			for(var count = 0; count < len2; count++) {
				if (destList1.options[count] != null) {
				  
					if (srcList.options[i].value == destList1.options[count].value) {
					   
						found = true;
						
						break;
			  		}
  				 }
			}
			//var found2 = false;
			for (var count=0;count<rowindex;count++){
				destListTemp=document.all("destListMul"+count);
				if (destListTemp!=destList){
					var len1 = destListTemp.length;
					for(var count1 = 0; count1 < len1; count1++){
						if (destListTemp.options[count1] != null) {
							if (srcList.options[i].value == destListTemp.options[count1].value) {
								found = true;
								break;
				  			}
	  				 	}
					}
				}
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
			}
	 	}
	}
}
// Deletes from the destination mul.
function deleteFromDestList3(src,dst) {
	var destList  = destList=document.all(dst);
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			destList.options[i] = null;
		}
	}
}

// Up selections from the destination mul.
function upFromDestList3(dst) {
	var destList  = destList=document.all(dst);
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);
			}
		}
	}
}
// Down selections from the destination mul.
function downFromDestList3(dst) {
	var destList  = destList=document.all(dst);
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);
			}
		}
	}
}
// Add the selected items from the source to destination list
function addSrcToDestList() {
	destList = window.document.tabfieldfrm.destList;
	srcList = window.document.tabfieldfrm.srcList;
	var len = destList.length;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}

// Add the selected items from the source to destination list2
function addSrcToDestList2() {
	destList = window.document.tabfieldfrm.destList2;
	srcList = window.document.tabfieldfrm.srcList2;
	var len = destList.length;
	var rowindex = fromfieldoTable.tBodies[0].rows.length - 1;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}

			for (var count=0;count<rowindex;count++)
			{
			destListTemp=document.all("destListMul"+count);
		    var len1 = destListTemp.length;
			for(var count1 = 0; count1 < len1; count1++)
			{
			if (destListTemp.options[count1] != null) {
					if (srcList.options[i].value == destListTemp.options[count1].value) {
						found = true;
						break;
			  		}
  				 }
			}
			}

			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}
// Deletes from the destination list.
function deleteFromDestList() {
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// Deletes from the destination list2.
function deleteFromDestList2() {
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
function upFromDestList() {
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = 0; i <= (len-1); i++) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i>0 && destList.options[i-1] != null){
		fromtext = destList.options[i-1].text;
		fromvalue = destList.options[i-1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i-1] = new Option(totext,tovalue);
		destList.options[i-1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
// Up selections from the destination list2.
function upFromDestList2() {
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = 0; i <= (len-1); i++) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i>0 && destList.options[i-1] != null){
		fromtext = destList.options[i-1].text;
		fromvalue = destList.options[i-1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i-1] = new Option(totext,tovalue);
		destList.options[i-1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}
// Down selections from the destination list.
function downFromDestList() {
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i<(len-1) && destList.options[i+1] != null){
		fromtext = destList.options[i+1].text;
		fromvalue = destList.options[i+1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i+1] = new Option(totext,tovalue);
		destList.options[i+1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}

// Down selections from the destination list2.
function downFromDestList2() {
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i<(len-1) && destList.options[i+1] != null){
		fromtext = destList.options[i+1].text;
		fromvalue = destList.options[i+1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i+1] = new Option(totext,tovalue);
		destList.options[i+1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);
	}
      }
   }
}

function fieldlabeldelRow()
{
    if (isdel()){
    var selectlangids = document.fieldlabelfrm.selectlangids.value;
	len = document.fieldlabelfrm.elements.length;
    rownum=parseInt(document.fieldlabelfrm.rownum.value);
    var i=0;
	var temps="";;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang'){
			if(document.fieldlabelfrm.elements[i].checked==true) {
//				if(document.fieldlabelfrm.elements[i].value!='0')
//					delids +=","+ document.fieldlabelfrm.elements[i].value;
				var tmp = document.fieldlabelfrm.elements[i].value + ',';
				if (temps!="")
				temps= temps+","+document.fieldlabelfrm.elements[i].value;
				else
				temps= document.fieldlabelfrm.elements[i].value;
				selectlangids=selectlangids.replace(tmp, '');
				//alert(selectlangids+" "+tmp+" "+selectlangids);
				

			}
			rowsum1 -=1;
		}

	}
	
	if (temps!="")
	{
	temparray=temps.split(",");
	for (l=0;l<temparray.length;l++)
	{
	var m=0;
	var tempss=temparray[l];
    if(oTable.rows(0).cells.length>1)
	{
	for (k=0;k<oTable.rows(0).cells.length;k++)
		{
	     if (oTable.rows(0).cells(k).innerHTML.indexOf(tempss)>0&&oTable.rows(0).cells(k).innerHTML.indexOf("checkbox")>0)
			{
		      m=k;
		    }
	    }
	}
	for(j=0;j<oTable.rows.length;j++)
		{
			if(oTable.rows(j).cells.length>1)
			{ 
				oTable.rows(j).deleteCell(m);
			}
		}
	}
	}
    document.fieldlabelfrm.selectlangids.value=selectlangids;
    }
}

function fieldlablesall(){
    if(document.fieldlabelfrm.fieldSize.value!="0")
	document.fieldlabelfrm.formfieldlabels.value=document.fieldlabelfrm.selectlangids.value;
    tab04oldurl="";
    tab05oldurl="";
    doPost(fieldlabelfrm,tab03);
}
	function fieldlablesall0(){
		var checks = document.all("checkitems").value;
		if(check_form(fieldlabelfrm,checks)){
			doPost(fieldlabelfrm,tab03);
		}else{
			return;
		}		
	}
	function setChange(fieldid){
		document.all("checkitems").value += "field_"+fieldid+"_CN,"
		var changefieldids = document.all("changefieldids").value;
		if(changefieldids.indexOf(fieldid)<0)
			document.all("changefieldids").value = changefieldids + fieldid + ",";
	}
//行计算
function rowsaveRole(){
    doPost(rowcalfrm,tab04);
}

function rowsaveRole1(){
	clearexp();
    rowsaveRole();
}
function addexp(obj){
    fieldid[rowcurindex]=obj.accessKey;
    if("+-*/()=".indexOf(obj.accessKey)==-1){
        fieldlable[rowcurindex]="<span style='color:#000000'>"+obj.innerHTML+"</span>";
    }else{
        fieldlable[rowcurindex]=obj.innerHTML;
    }
    rowcurindex++;

    refreshcal();

}
function removeexp(){
    rowcurindex --;
    if(rowcurindex<0){
        rowcurindex = 0;
    }
    refreshcal();
}

function refreshcal(){
    currowcalexp = "";
    document.all("rowcalexp").innerHTML="";
    for(var i=0; i<rowcurindex; i++){
        currowcalexp+=fieldid[i];
        document.all("rowcalexp").innerHTML+=fieldlable[i];
    }
}
function clearexp(){
    currowcalexp = "";
    rowcurindex = 0;
    document.all("rowcalexp").innerHTML="";
}
function colsaveRole(){
    doPost(colcalfrm,tab05);
}
function gotab000(url){
     doGet(tab000,url);
}
function nodeopadd(formid,nodeid,isbill,iscust){
        doGet(tab002, "addoperatorgroup.jsp?ajax=1&wfid="+workflowidAll+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust);
}
function nodeopedit(formid,nodeid,id,isbill,iscust){
        doGet(tab002, "editoperatorgroup.jsp?ajax=1&wfid="+workflowidAll+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust+"&id="+id);
    }
function nodeopdelete(obj){
	if (isdel()) {
    obj.disabled=true;
    addopform.src.value="delgroups";
    doPost(addopform,tab002) ;
  }
}
function wfurgersave(obj){
        var rowindex4op = 0;
        var rowsum1 = jQuery("input[name=wfcheck_node]").length;
        if (rowsum1 > 0) {
            var obj=jQuery("input[name=wfcheck_node]")[rowsum1-1];
            var rowindex=jQuery(obj).attr("rowindex");
            rowindex4op = parseInt(rowindex) + 1;
        }
        wfurgerform.groupnum.value = rowindex4op;

        obj.disabled = true;
        doPost(wfurgerform, tab0004);
}
//xwj for td3665 200602223
function wfmsave(obj){
    obj.disabled=true;
    doPost($("form[name=wfmForm]")[0],tab0001);
}
function flowTitleSave(obj)
{
 obj.disabled=true;
 doPost(flowTitleForm,tab9);
}
function flowCodeSave(obj)
{
 obj.disabled=true;
 onSave(obj);
 doPost($("form[name=frmCoder]")[0],tab0003);
}
function switchCataLogType(objval){
	objval=document.weaver.catalogtype.value;
    if(objval == 0){
		document.all("selectcatalog").style.display = 'none';
        document.all("selectCategory").style.display = '';
        document.all("mypath").style.display = '';
    }else{
    	document.all("selectcatalog").style.display = '';
        document.all("selectCategory").style.display = 'none';
        document.all("mypath").style.display = 'none';
    }
}
function onchangewfdocownertype(objvalue){
	var wfdocownertype = objvalue;
	document.getElementById("selectwfdocowner").style.display = "none";
	document.getElementById("wfdocownerspan").style.display = "none";
	document.getElementById("wfdocownerfieldid").style.display = "none";
	try{
		if(wfdocownertype=="1"){
			document.getElementById("selectwfdocowner").style.display = "";
			document.getElementById("wfdocownerspan").style.display = "";
		}else if(wfdocownertype=="2"){
			document.getElementById("wfdocownerfieldid").style.display = "";
		}
	}catch(e){}
}
function openFullWindow(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBar(url){
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

//为了删除时用
function openFullWindow1(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top="+height/2+"," ;
  szFeatures +="left="+width/2+"," ;
  szFeatures +="width=181," ;
  szFeatures +="height=129," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=no" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ;
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
function change(thisele) {
	var modeid= thisele.value;
    if(modeid=="1"){
        oDivOfAddWfNodeField.style.display="none";
        hDivOfAddWfNodeField.style.display="none";
        tDivOfAddWfNodeField.style.display="";
    }else if(modeid=="0"){
        oDivOfAddWfNodeField.style.display="";
        hDivOfAddWfNodeField.style.display="none";
        tDivOfAddWfNodeField.style.display="none";
    }else if(modeid=="2"){
    	oDivOfAddWfNodeField.style.display="none";
    	tDivOfAddWfNodeField.style.display="none";
    	hDivOfAddWfNodeField.style.display="";
    }
}

function onchangeNodeid2(obj, tabform){
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	//
	if(nodetype == "0"){
		//alert(nodetype);
		tabform.changetime.disabled = true;
		tabform.changetime.options[1].selected = true;
		tabform.changetimeinput.value="2";
	}else if(nodetype == "3"){
		//alert(nodetype);
		tabform.changetime.disabled = true;
		tabform.changetime.options[0].selected = true;
		tabform.changetimeinput.value="1";
	}else{
		tabform.changetime.disabled = false;
		tabform.changetime.options[0].selected = true;
		tabform.changetimeinput.value="0";
	}
}
function addWPRow(){
	CreateWorkplanByWorkflow.operationType.value = "add";
	doPost(CreateWorkplanByWorkflow, tab0004);
}
function delWPRow(){
	if(isdel()){
		CreateWorkplanByWorkflow.operationType.value = "del";
		doPost(CreateWorkplanByWorkflow, tab0004);
	}
}
function detailConfig_wp(id_cp, workflowid){
	doGet(tab0004, "/workflow/workflow/CreateWorkplanByWorkflowDetail.jsp?ajax=1&id="+id_cp+"&wfid="+workflowid);
}
function saveCreateWPDetail(){
	CreateWorkplanByWorkflowDetail.operationType.value = "save";
	doPost(CreateWorkplanByWorkflowDetail, tab0004);
}
function comebackCreateWP(workflowid, formID, isbill){
	doGet(tab0004, "/workflow/workflow/CreateWorkplanByWorkflow.jsp?ajax=1&errorMessage=0&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill);

}
function showWFfield2(type){
	if(type==1){
		CreateWorkplanByWorkflowDetail.wffield.style.display = "";
	}else{
		CreateWorkplanByWorkflowDetail.wffield.style.display = "none";
	}
}
function showRemindTime_wp(obj){
	if("1" == obj.value){
		document.all("remindTimeTR").style.display = "none";
		document.all("remindTimeLineTR").style.display = "none";
	}else{
		document.all("remindTimeTR").style.display = "";
		document.all("remindTimeLineTR").style.display = "";
	}
}
function linkageviewattrsubmit(obj){
    if (check_form(frmlinkageviewattr,document.all('checkfield').value)) {
        obj.disabled=true;
        doPost(frmlinkageviewattr,tab0007)  ;
   }
}

function addWTRow(){
	CreateWorktaskByWorkflow.operationType.value = "add";
	doPost(CreateWorktaskByWorkflow, tab0003);
}
function delWTRow(){
	if(isdel()){
		CreateWorktaskByWorkflow.operationType.value = "del";
		doPost(CreateWorktaskByWorkflow, tab0003);
	}
}
function detailConfig_wt(id_ct, workflowid){
	doGet(tab0003, "/workflow/workflow/CreateWorktaskByWorkflowDetail.jsp?ajax=1&id="+id_ct+"&wfid="+workflowid);
}
function saveCreateWTDetail(){
	CreateWorktaskByWorkflowDetail.operationType.value = "save";
	doPost(CreateWorktaskByWorkflowDetail, tab0003);
}
function comebackCreateWT(workflowid, formID, isbill){
	doGet(tab0003, "/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&errorMessage=0&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill);

}
function showWFfield(type){
	if(type==1){
		CreateWorktaskByWorkflowDetail.wffield.style.display = "";
	}else{
		CreateWorktaskByWorkflowDetail.wffield.style.display = "none";
	}
}

function onchangeNodeid(obj, tabform){
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	//
	if(nodetype == "0"){
		//alert(nodetype);
		tabform.changetime.disabled = true;
		tabform.changetime.options[1].selected = true;
		tabform.changetimeinput.value="2";
	}else if(nodetype == "3"){
		//alert(nodetype);
		tabform.changetime.disabled = true;
		tabform.changetime.options[0].selected = true;
		tabform.changetimeinput.value="1";
	}else{
		tabform.changetime.disabled = false;
		tabform.changetime.options[0].selected = true;
		tabform.changetimeinput.value="0";
	}
	dochangeChangeTime(tabform.changetime);
	if(nodetype == "0"){
		document.getElementById("changemodetr1").style.display = "none";
		document.getElementById("changemodetr0").style.display = "none";
		document.getElementById("changemodetr2").style.display = "none";
		document.getElementById("changemode").style.display = "none";
		document.getElementById("changemode0").style.display = "none";
	}else if(nodetype == "3"){
		document.getElementById("changemodetr1").style.display = "none";
		document.getElementById("changemodetr0").style.display = "none";
		document.getElementById("changemodetr2").style.display = "none";
		document.getElementById("changemode").style.display = "none";
		document.getElementById("changemode0").style.display = "none";
	}
}

function changeDateShowType(obj){

    var objId=obj.id
    var objValue=obj.value

    var divName="divDateShowType_"+objId.substr(objId.lastIndexOf("_")+1)

    var objHtmlType=objValue.substring(objValue.indexOf("_")+1,objValue.lastIndexOf("_"));
    var objType=objValue.substring(objValue.lastIndexOf("_")+1);
    
    if(objHtmlType=='3'&&objType=='2'){
        document.all(divName).style.display=""
    }else{
        document.all(divName).style.display="none"
    }

}
function ItemFloat_KeyPress_ehnf(obj){
	if(!((window.event.keyCode>=48 && window.event.keyCode<=57) || window.event.keyCode==46)){
		window.event.keyCode=0;
	}
}
function checkFloat_ehnf(obj){
	var valuenow = obj.value;
	var index = valuenow.indexOf(".");
	var valuechange = valuenow;
	if(index > -1){
		if(index == 0){
			valuechange = "0"+valuenow;
			index = 1;
		}
		valuenow = valuechange.substring(0, index+1);
		valuechange = valuechange.substring(index+1, valuechange.length);
		if(valuechange.length > 2){
			valuechange = valuechange.substring(0, 2);
		}
		index = valuechange.indexOf(".");
		if(index > -1){
			valuechange = valuechange.substring(0, index);
		}
		valuenow = valuenow + valuechange;
		index = valuenow.indexOf(".");
		if(index>-1 && index==valuenow.length-1){
			if(valuenow.length>=6){
				valuenow = valuenow.substring(0, index);
			}else{
				valuenow = valuenow + "0";
			}
		}
		obj.value = valuenow;
	}
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}


//填充日期下拉框
function createDayCodeSeqSet(n,day){
	//清空下拉框
	clearOptionsCodeSeqSet(day);
	//几天，就写入几项
	for(var i=1; i<=n; i++){
		day.options.add(new Option(i,i));
	}
}

//删除下拉框中的所有选项
function clearOptionsCodeSeqSet(ctl)
{
	for(var i=ctl.options.length-1; i>=0; i--){
		ctl.remove(i);
	}
}

//判断是否闰年	　　
function isLeapYear(year){
	return( (year%4==0&&year%100!=0 )|| year%400 == 0);
}


function codeSeqReservedSet(talID, workflowId, formId, isBill){
	doGet(talID, 'WorkflowCodeSeqReservedSet.jsp?workflowId=' + workflowId + '&formId=' + formId + '&isBill=' + isBill+ '&ajax=1' );
}

function onSearchCodeSeqReservedSet(obj) {
	if(checkValueCodeSeqSet()){
		obj.disabled = true;
		formCodeSeqSet.action="WorkflowCodeSeqReservedSet.jsp" ;
		doPost(formCodeSeqSet, tab0003);
	}
}

function onSaveCodeSeqReservedSet(obj) {
	obj.disabled = true;
	formCodeSeqSet.action="WorkflowCodeSeqReservedSetOperation.jsp" ;
	doPost(formCodeSeqSet, tab0003);

}

function shortNameSetting(talID, workflowId, formId, isBill,fieldId){
	doGet(talID, 'WorkflowShortNameSetting.jsp?workflowId=' + workflowId + '&formId=' + formId + '&isBill=' + isBill+ '&fieldId=' + fieldId+ '&ajax=1' );
}



function onCancelShortNameSetting(obj){
	doGet(tab0003, tab0003URL);
}

function onSaveShortNameSetting(obj) {
	obj.disabled = true;
	formShortNameSetting.action="WorkflowShortNameSettingOperation.jsp" ;
	doPost(formShortNameSetting, tab0003);
}

function supSubComAbbr(talID, workflowId, formId, isBill,fieldId){
	doGet(talID, 'WorkflowSupSubComAbbr.jsp?workflowId=' + workflowId + '&formId=' + formId + '&isBill=' + isBill+ '&fieldId=' + fieldId+ '&ajax=1' );
}
function onSearchSupSubComAbbr(obj) {
	obj.disabled = true;
	formSupSubComAbbr.action="WorkflowSupSubComAbbr.jsp" ;
	doPost(formSupSubComAbbr, tab0003);
}
function onSaveSupSubComAbbr(obj) {
	obj.disabled = true;
	formSupSubComAbbr.action="WorkflowSupSubComAbbrOperation.jsp" ;
	doPost(formSupSubComAbbr, tab0003);
}
function onCancelSupSubComAbbr(obj){
	doGet(tab0003, tab0003URL);
}

function subComAbbr(talID, workflowId, formId, isBill,fieldId){
	doGet(talID, 'WorkflowSubComAbbr.jsp?workflowId=' + workflowId + '&formId=' + formId + '&isBill=' + isBill+ '&fieldId=' + fieldId+ '&ajax=1' );
}
function onSearchSubComAbbr(obj) {
	obj.disabled = true;
	formSubComAbbr.action="WorkflowSubComAbbr.jsp" ;
	doPost(formSubComAbbr, tab0003);
}
function onSaveSubComAbbr(obj) {
	obj.disabled = true;
	formSubComAbbr.action="WorkflowSubComAbbrOperation.jsp" ;
	doPost(formSubComAbbr, tab0003);
}
function onCancelSubComAbbr(obj){
	doGet(tab0003, tab0003URL);
}


function deptAbbr(talID, workflowId, formId, isBill,fieldId){
	doGet(talID, 'WorkflowDeptAbbr.jsp?workflowId=' + workflowId + '&formId=' + formId + '&isBill=' + isBill+ '&fieldId=' + fieldId+ '&ajax=1' );
}
function onSearchDeptAbbr(obj) {
	obj.disabled = true;
	formDeptAbbr.action="WorkflowDeptAbbr.jsp" ;
	doPost(formDeptAbbr, tab0003);
}
function onSaveDeptAbbr(obj) {
	obj.disabled = true;
	formDeptAbbr.action="WorkflowDeptAbbrOperation.jsp" ;
	doPost(formDeptAbbr, tab0003);
}
function onCancelDeptAbbr(obj){
	doGet(tab0003, tab0003URL);
}

function onShowViewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){

    url=encode("/workflow/workflow/showViewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
}

function onShowNewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){

    url=encode("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
}

function onShowChooseReservedCode(workflowId,formId,isBill,recordId){

    url=encode("/workflow/workflow/showChooseReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&recordId="+recordId);	
	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
}

 function viewSourceUrl()
{

    prompt("",location);

}

function  upWord()
{
if(top.document.body.style.zoom!=0) 
top.document.body.style.zoom*=1.1; 
else top.document.body.style.zoom=1.1;
}

function  lowWord()
{
if(top.document.body.style.zoom!=0) 
	top.document.body.style.zoom*=0.9; 
else top.document.body.style.zoom=0.9;
}
function selectviewall(checkname, opt){
	var tab_id = checkname+"tab";
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=0; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
        var tmpTd0 = tmpTr.cells(0);
		if(tmpTd0 == undefined){
			continue;
		}
        if(opt) tmpTd0.childNodes[0].checked = opt;
        tmpTd0.childNodes[0].disabled = opt;
        var tmpTd1 = tmpTr.cells[1];
		if(tmpTd1 == undefined){
			continue;
		}
        if(opt) tmpTd1.childNodes[0].checked = opt;
        tmpTd1.childNodes[0].disabled = opt;
    }
}
function selectviewall2(checkname, opt){
	var tab_id = checkname+"tab002";
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=0; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
        var tmpTd0 = tmpTr.cells(0);
		if(tmpTd0 == undefined){
			continue;
		}
        if(opt) tmpTd0.childNodes[0].checked = opt;
        tmpTd0.childNodes[0].disabled = opt;
        var tmpTd1 = tmpTr.cells[1];
		if(tmpTd1 == undefined){
			continue;
		}
        if(opt) tmpTd1.childNodes[0].checked = opt;
        tmpTd1.childNodes[0].disabled = opt;
    }
}
function changeset(obj){
   if(obj.value==4){
      document.all("timesettr")[0].style.display='';
      document.all("timesettr")[1].style.display='';
      document.all("datetypetr")[0].style.display='none';
      document.all("datetypetr")[1].style.display='none';
      document.all("datetypetd").style.display='none';      
   }else{
      document.all("timesettr")[0].style.display='';
      document.all("timesettr")[1].style.display='';
      document.all("datetypetr")[0].style.display='';
      document.all("datetypetr")[1].style.display='';
      document.all("datetypetd").style.display=''; 
   }
}
function linkagevaselectall(){
    len = document.frmlinkageviewattr.elements.length;
    var i=0;
    for(i=len-1; i >= 0;i--) {
       if (document.frmlinkageviewattr.elements[i].name=='check_node'){
           document.frmlinkageviewattr.elements[i].checked=document.frmlinkageviewattr.checkall.checked;
       }
    }
}

function onSearchCodeSeqSet(obj) {
	if(checkValueCodeSeqSet()){
		obj.disabled = true;
		formCodeSeqSet.action="WorkflowCodeSeqSet.jsp" ;
		doPost(formCodeSeqSet, tab0003);
	}
}

function onSaveCodeSeqSet(obj) {
	//if(checkValueCodeSeqSet()){
		obj.disabled = true;
		formCodeSeqSet.action="WorkflowCodeSeqSetOperation.jsp" ;
		doPost(formCodeSeqSet, tab0003);
	//}
}

function codeSeqSet(talID, workflowId, formId, isBill){
	doGet(talID, 'WorkflowCodeSeqSet.jsp?workflowId=' + workflowId + '&formId=' + formId + '&isBill=' + isBill+ '&ajax=1' );
}

function onCancelCodeSeqSet(obj){
	doGet(tab0003, tab0003URL);
}


function setHelpURL(div, url)
{
	if("0" == div)
	//点击大项
	{
		if(help0URL == help0OldURL)
		//点击过
		{
			helpURL = help0InnerURL;
		}
		else
		//未点击过
		{
			helpURL = help0URL;
			help0OldURL = help0URL;
		}

	}
	else if("-0" == div)
	//点击小项
	{
		help0InnerURL = url;
		helpURL = url;

	}
	
	else if("1" == div)
	{
		if(help1URL == help1OldURL)
		{
			helpURL = help1InnerURL;
		}
		else
		{
			helpURL = help1URL;
			help1OldURL = help1URL;
		}

	}
	else if("-1" == div)
	{
		help1InnerURL = url;
		helpURL = url;
;
	}
	
	else if("2" == div)
	{
		if(help2URL == help2OldURL)
		{
			helpURL = help2InnerURL;
		}
		else
		{
			helpURL = help2URL;
			help2OldURL = help2URL;
		}

	}
	else if("-2" == div)
	{
		help2InnerURL = url;
		helpURL = url;

	}
	
	else if("3" == div)
	{
		if(help3URL == help3OldURL)
		{
			helpURL = help3InnerURL;
		}
		else
		{
			helpURL = help3URL;
			help3OldURL = help3URL;
		}

	}
	else if("-3" == div)
	{
		help3InnerURL = url;
		helpURL = url;

	}
    else if("4" == div)
	{
		if(help4URL == help4OldURL)
		{
			helpURL = help4InnerURL;
		}
		else
		{
			helpURL = help4URL;
			help4OldURL = help4URL;
		}

	}
	else if("-4" == div)
	{
		help4InnerURL = url;
		helpURL = url;

	}
}

function showHelp(){
    var pathKey = helpURL;
    //alert(pathKey);
    
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";

    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");

}

jQuery.fn.swap = function(other) {
    $(this).replaceWith($(other).after($(this).clone(true)));
};
function imgDownOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //var obj2 = obj1.nextSibling.nextSibling;
  //var checkbox2 =obj2.childNodes[1].firstChild;
  var obj2 =jQuery(obj1).nextAll("tr[customer1='member']").filter("tr:visible:first");
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");

  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  $(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
 
}

function changeTrFieldSequenceAlone(obj){
	var selectFieldId=obj.value;
	if(selectFieldId>0){
		trFieldSequenceAlone.style.display=''
		trLineFieldSequenceAlone.style.display=''
	}else{
		trFieldSequenceAlone.style.display='none'
		trLineFieldSequenceAlone.style.display='none'
	}
}

function load(){  //检查Imag的状态
  var img_ups = document.getElementsByName("img_up");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  {img_up.style.visibility ='hidden';
    img_up.style.width =0;}
    else  
    {img_up.style.visibility ='visible';
    img_up.style.width =10;
    }
  }

  var img_downs = document.getElementsByName("img_down");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  {img_down.style.visibility ='hidden';
    img_down.style.width =0;
    }
    
    else  {img_down.style.visibility ='visible';
    img_down.style.width =10;
    }
  }

  proView();
}

function proView(){
	 var TR_doc =  jQuery("#TR_pro");
	 jQuery(TR_doc).children("td").remove();
	 jQuery("tr[customer1='member']").each(function(index,obj){
			
		  var codeTitle = $(obj).find("td::eq(0)").text()
		  codeTitle = jQuery.trim(codeTitle)
		  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
		  
		  var codeValue;

	      if (codeTypeTag=="INPUT") {
	        codeValue= $(obj).find("td::eq(1)").children(":first").val(); 

	        if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	           codeValue = $(obj).find("td::eq(1)").children(":first").val();
	        } else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	           codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	        }
	      }
	      else if (codeTypeTag=="DIV"){
	    	  codeValue = $(obj).find("td::eq(1)").children(":first").text();
	      }else if(codeTypeTag=="SELECT"){

			  //objSelect=TR_member.childNodes[1].firstChild;
			  codeValue= $(obj).find("td::eq(1)").children(":first").find("option:selected").text(); 
		  }
	      
	      if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="不使用")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="1"){ 
	                	 var selectObjs=$(obj).find("td::eq(1)").find("select");                 
	                     if (selectObjs.length>=1)  {
	                       if($(selectObjs).find(":first").val()=="0") codeValue="**";
	                       else codeValue="****";
	                     }
	                }
	            }

	        var tempTd = document.createElement("TD");
	        var tempTable = document.createElement("TABLE");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);


	        var newCol = newRow.insertCell(-1);
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);

	        jQuery(newRowMiddle).css("height","1px");
	        newColMiddle.className="Line";

	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        //tempTd.appendChild(tempTable);
	        jQuery(TR_doc).append(tempTd)
	        //TR_doc.appendChild(tempTd);
	      } 
   })
}

function onSave(obj){
 // obj.disabled=true;
  var postValueStr="";
  jQuery("tr[customer1='member']").each(function(index,obj){
	  var codeTitle = $(obj).find("td::eq(0)").attr("codevalue")
	  codeTitle = jQuery.trim(codeTitle)
	  var codeTypeTag = "";   //checkbox input div  
	  var codeTypeTr = $(obj).find("td::eq(1)").children(":first");
	  if(codeTypeTr){
		  codeTypeTag = codeTypeTr.attr("tagName");
	  }
	  var codeValue;
	  var codeType
	  if (codeTypeTag=="INPUT") {
		  codeValue= $(obj).find("td::eq(1)").children(":first").val();
	      if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	         codeValue =  $(obj).find("td::eq(1)").children(":first").val();
	         if (codeValue=="") codeValue="[(*_*)]";
	         codeType = 2
	      } else if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
		     codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	         codeType=1      //input
	         var selectObjs=$(obj).find("td::eq(1)").find("select");                 
	         if (selectObjs.length>=1)  {
	           codeType=3   //year
	           codeValue=codeValue+"|"+$(selectObjs).find(":first").val();
	         }
	      }
	    }else if(codeTypeTag=="SELECT"){
	    	
			codeValue= $(obj).find("td::eq(1)").children(":first").val(); 
			codeType=5;
		}
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
  })
  
 postValueStr = postValueStr.substring(0,postValueStr.length-1);
 jQuery("#postValue").val(postValueStr);
 //document.frmCoder.postValue.value=postValueStr;
 //document.frmCoder.method.value="update";
 //alert(postValueStr)
 //document.frmCoder.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //var obj2 = obj1.previousSibling.previousSibling;
  //var checkbox2 =obj2.childNodes[1].firstChild;
  var obj2 =jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible:first");
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");

  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  $(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
}

function showtitle(evt){   
	if($.browser.msie){
		
		jQuery(".vtip").attr("title","");
		obj = evt.srcElement
		if(obj.selectedIndex!=-1){   
			
			if(obj.options[obj.selectedIndex].text.length > 2){  					
				$("#simpleTooltip").remove();					
				var  tipX;
				var  tipY;
				tipX=evt.clientX+document.body.scrollLeft+6;
				tipY=evt.clientY+document.body.scrollTop+6;		
				$("body").append("<div id='simpleTooltip' style='position: absolute; z-index: 100; display: none;'>" + obj.options[obj.selectedIndex].text + "</div>");
				var tipWidth = $("#simpleTooltip").outerWidth(true)
				$("#simpleTooltip").width(tipWidth);
				$("#simpleTooltip").css("left", tipX).css("top", tipY).fadeIn("medium");
			}
			
		}
		
		jQuery(obj).bind("mouseout",function(){
			
			$("#simpleTooltip").remove();		
		})
	}else{
		jQuery(".vtip").simpletooltip("click");
	}
}

function checkChange(id) {
    //len = document.nodefieldform.elements.length;
   // var isenable=0;
    //if(document.all("dtl_add_"+id).checked || document.all("dtl_edit_"+id).checked){
     //   isenable=1;
   // }
   // if(isenable==1)
   // {
    //	document.all("dtl_ned_"+id).disabled=false;
    //	document.all("dtl_def_"+id).disabled=false;
  //  }
    //else
    //{
	//	document.all("dtl_ned_"+id).disabled=true;
	//	document.all("dtl_def_"+id).disabled=true;
    //}
   // for( i=0; i<len; i++) {
      //  var elename=document.nodefieldform.elements[i].name;
      //  elename=elename.substr(elename.indexOf('_')+1);
      //  if (elename=='edit_g'+id || elename=='man_g'+id || elename=='editall_g'+id || elename=='manall_g'+id || elename=='editall'+id || elename=='manall'+id) {
       //     if(isenable==1){
       //         document.nodefieldform.elements[i].disabled=false;
        //    }else{
		//		document.nodefieldform.elements[i].disabled=true;
		//		//document.nodefieldform.elements[i].checked=false;
          //  }
      //  } 
  //  } 
  //2012-08-31 ypc
   len = document.nodefieldform.elements.length;
    var isenable=0;
    var isen=0; //ypc  2012-08-30
    if(document.all("dtl_add_"+id).checked){
        isen=1;
    }
    //start 2012-08-30 ypc 
    if(document.all("dtl_edit_"+id).checked){
    	isenable=1;
    }
    //end 2012-08-30 ypc 
    if(isen==1)
    {
    	document.all("dtl_ned_"+id).disabled=false;
    	document.all("dtl_def_"+id).disabled=false;
    	document.all("dtl_defrow"+id).disabled=false;
    	if(document.all("dtl_mul_"+id)){ //update by liaodong for qc84694 in 2013年11月5日 start
			 document.all("dtl_mul_"+id).disabled=false;//zzl
		}
    }
    else
    {
    	document.all("dtl_ned_"+id).checked=false;  // 2012-08-30 ypc
    	document.all("dtl_def_"+id).checked=false; // 2012-08-30 ypc
    	if(document.all("dtl_mul_"+id)){ //update by liaodong for qc84694 in 2013年11月5日 start
         	document.all("dtl_mul_"+id).checked=false;//zzl
		}
		document.all("dtl_ned_"+id).disabled=true;
		document.all("dtl_def_"+id).disabled=true;
		if(document.all("dtl_mul_"+id)){ //update by liaodong for qc84694 in 2013年11月5日 start
			  document.all("dtl_mul_"+id).disabled=true;//zzl
		}
		document.all("dtl_defrow"+id).disabled=true;
    }
    for( i=0; i<len; i++) {
        var elename=document.nodefieldform.elements[i].name;
        elename=elename.substr(elename.indexOf('_')+1);
        if (elename=='edit_g'+id || elename=='man_g'+id || elename=='editall_g'+id || elename=='manall_g'+id || elename=='editall'+id || elename=='manall'+id) {
            if(isenable==1||isen==1){
                document.nodefieldform.elements[i].disabled=false;
            }else{
				document.nodefieldform.elements[i].disabled=true;
            }
        } 
    } 
  
	//if(isenable==1){
		//document.getElementsByName("title_editall" + id)[0].disabled = false;
		//document.getElementsByName("title_manall" + id)[0].disabled = false;
	//}else{
		//document.getElementsByName("title_editall" + id)[0].disabled = true;
		//document.getElementsByName("title_editall" + id)[0].checked = false;
		//document.getElementsByName("title_manall" + id)[0].disabled = true;
		//document.getElementsByName("title_manall" + id)[0].checked = false;
	//}
}
function checkChange2(id) {
    //len = document.nodefieldhtml.elements.length;
    //var isenable=0;
    //if(document.all("dtl_add_"+id).checked || document.all("dtl_edit_"+id).checked){
      //  isenable=1;
    //}
    //if(isenable==1) {
	//	document.all("dtl_ned_"+id).disabled=false;
	//	document.all("dtl_def_"+id).disabled=false;
	//} else {
	//	document.all("dtl_ned_"+id).disabled=true;
		//document.all("dtl_def_"+id).disabled=true;
	//}
	
	//2012-08-31 ypc
	len = document.nodefieldhtml.elements.length;
    var isenable=0;
	 var isen=0; //ypc  2012-08-30
    if(document.all("dtl_add_"+id).checked){
        isen=1;
    }
    //start 2012-08-31 ypc 
    if(document.all("dtl_edit_"+id).checked){
    	isenable=1;
    }
    //end 2012-08-31 ypc 
    if(isen==1)
    {
    	document.all("dtl_ned_"+id).disabled=false;
    	document.all("dtl_def_"+id).disabled=false;
    	document.all("dtl_defrow"+id).disabled=false;
		document.all("dtl_mul_"+id).disabled=false;//zzl
    }
    else
    {
    	document.all("dtl_ned_"+id).checked=false;  // 2012-08-31 ypc
    	document.all("dtl_def_"+id).checked=false; // 2012-08-31 ypc
		document.all("dtl_mul_"+id).checked=false; //zzl
		document.all("dtl_ned_"+id).disabled=true;
		document.all("dtl_def_"+id).disabled=true;
		document.all("dtl_defrow"+id).disabled=true;
		document.all("dtl_mul_"+id).disabled=true;//zzl
    }
    for( i=0; i<len; i++) {
        var elename=document.nodefieldhtml.elements[i].name;
        elename=elename.substr(elename.indexOf('_')+1);
        if (elename=='edit_g'+id || elename=='man_g'+id || elename=='editall_g'+id || elename=='manall_g'+id || elename=='editall'+id || elename=='manall'+id) {
            if(isenable==1||isen==1){ // 2012-08-31 ypc
                document.nodefieldhtml.elements[i].disabled=false;
            }else{
				document.nodefieldhtml.elements[i].disabled=true;
            }
        } 
    } 
}
function onChangeViewAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	//alert(tab_id);
	var tab_name = document.getElementById(tab_id);
	//alert(tab_name);
	var row = tab_name.rows.length;
	//alert(row);
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];
		//alert(tmpTr);
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd1 = tmpTr.cells[1];
		if(tmpTd1 == undefined){
			continue;
		}
		//var tmpName = tmpTd1.childNodes[0].name;
		//alert(tmpName);
		if(tmpTd1.childNodes[0].disabled == false){
			tmpTd1.childNodes[0].checked = opt;
		}

		if(opt == false){
			var tmpTd2 = tmpTr.cells[2];
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}

			var tmpTd3 = tmpTr.cells[3];
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeEditAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd2 = tmpTr.cells[2];
		if(tmpTd2 == undefined){
			continue;
		}
		if(tmpTd2.childNodes[0].disabled == false){
			tmpTd2.childNodes[0].checked = opt;
		}
		if(opt == false){
			var tmpTd3 = tmpTr.cells[3];
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
				}
		}else{
			var tmpTd1 = tmpTr.cells[1];
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeManAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd3 = tmpTr.cells[3];
		if(tmpTd3 == undefined){
			continue;
		}
		if(tmpTd3.childNodes[0].disabled == false){
			tmpTd3.childNodes[0].checked = opt;
		}
		if(opt == true){
			var tmpTd1 = tmpTr.cells[1];
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
			var tmpTd2 = tmpTr.cells[2];
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}
		}
	}
}
function doSearchWorkflowTriDiffWfSubWf(){//执行Iframe的src改变的操作
	if(document.getElementById("triDiffWfDiffFieldId")==null){
		return;
	}

	triDiffWfDiffFieldId=document.getElementById("triDiffWfDiffFieldId").value;
	
	pagenum=1;
    subCompanyId=0;
	departmentId=0;
	resourceName="";

	superiorUnitId=0;
	receiveUnitName="";

	if(document.getElementById("pagenumTriDiffWfSubWf")!=null){
		pagenum=document.getElementById("pagenumTriDiffWfSubWf").value;
	}

	if(document.getElementById("subCompanyIdTriDiffWfSubWf")!=null){
		subCompanyId=document.getElementById("subCompanyIdTriDiffWfSubWf").value;
	}
	if(document.getElementById("departmentIdTriDiffWfSubWf")!=null){
		departmentId=document.getElementById("departmentIdTriDiffWfSubWf").value;
	}
	if(document.getElementById("resourceNameTriDiffWfSubWf")!=null){
		resourceName=document.getElementById("resourceNameTriDiffWfSubWf").value;
	}
	if(document.getElementById("superiorUnitIdTriDiffWfSubWf")!=null){
		superiorUnitId=document.getElementById("superiorUnitIdTriDiffWfSubWf").value;
	}
	if(document.getElementById("receiveUnitNameTriDiffWfSubWf")!=null){
		receiveUnitName=document.getElementById("receiveUnitNameTriDiffWfSubWf").value;
	}
	document.all("iFrameWorkflowTriDiffWfSubWf").src = "iFrameWorkflowTriDiffWfSubWf.jsp?triDiffWfDiffFieldId=" + triDiffWfDiffFieldId + "&pagenum=" + pagenum + "&subCompanyId=" + subCompanyId+ "&departmentId=" + departmentId+ "&resourceName=" + encodeURIComponent(encodeURIComponent(resourceName))+ "&superiorUnitId=" + superiorUnitId+ "&receiveUnitName=" + receiveUnitName;

}

function onSearchWorkflowTriDiffWfSubWf(){//点击右键 搜索 按钮后执行的操作
	if(document.getElementById("pagenumTriDiffWfSubWf")==null){
		return;
	}
	document.getElementById("pagenumTriDiffWfSubWf").value = 1;

	doSearchWorkflowTriDiffWfSubWf();
}

function prePageTriDiffWfSubWf(){//点击 上一页 连接后执行的操作
	if(document.getElementById("pagenumTriDiffWfSubWf")==null){
		return;
	}
	pagenumTriDiffWfSubWf=document.getElementById("pagenumTriDiffWfSubWf").value;
	if(pagenumTriDiffWfSubWf<=1){
		return;
	}
	pagenumTriDiffWfSubWf=parseInt(pagenumTriDiffWfSubWf)-1;
	document.getElementById("pagenumTriDiffWfSubWf").value=pagenumTriDiffWfSubWf;

	doSearchWorkflowTriDiffWfSubWf();
}

function nextPageTriDiffWfSubWf(){//点击 下一页 连接后执行的操作
	if(document.getElementById("pagenumTriDiffWfSubWf")==null){
		return;
	}

	pagenumTriDiffWfSubWf=document.getElementById("pagenumTriDiffWfSubWf").value;
	pagenumTriDiffWfSubWf=parseInt(pagenumTriDiffWfSubWf)+1;
	document.getElementById("pagenumTriDiffWfSubWf").value=pagenumTriDiffWfSubWf;

	doSearchWorkflowTriDiffWfSubWf();
}

function changeTriggerTypeAndOperationDiff(){
	$GetEle("trTriggerTimeDiff").style.display="none";
	$GetEle("trTriggerTimeLineDiff").style.display="none";
	$GetEle("trTriggerOperationDiff").style.display="none";
	$GetEle("trTriggerOperationLineDiff").style.display="none";

	$GetEle("triggerOperationDiff").style.display="none";
	$GetEle("triggerTimeDiff").style.display="none";
	//TD23271:20110505 ADD BY QB START
	$GetEle("triggerOperationDiffNew").style.display="none";
	$GetEle("trTriggerOperationDiff").style.display="none";
	document.getElementById("trTriggerOperationDiffNew").style.display="none";
	//TD23271:20110505 ADD BY QB END
    var triggerNodeIdDiff=$GetEle("triggerNodeIdDiff").value;
    var triggerNodeTypeDiff=triggerNodeIdDiff.substring(0,triggerNodeIdDiff.indexOf("_"));
    triggerNodeIdDiff=triggerNodeIdDiff.substr(triggerNodeIdDiff.lastIndexOf("_")+1)

    var triggerTypeDiff=$GetEle("triggerTypeDiff").value;

    var triggerTimeDiff=$GetEle("triggerTimeDiff").value;
	var finalOperationDiffValue="";

	if(triggerTypeDiff==1){
		$GetEle("trTriggerTimeDiff").style.display="";
		$GetEle("trTriggerTimeLineDiff").style.display="";
	    $GetEle("triggerTimeDiff").style.display="";
	    $GetEle("trTriggerOperationDiffNew").style.display="none";
		if(triggerNodeTypeDiff==1||triggerTimeDiff==1){
	        $GetEle("trTriggerOperationLineDiff").style.display="";
	        $GetEle("triggerOperationDiff").style.display="";
	        if(triggerTimeDiff==1){			       
	        	finalOperationDiffValue = $GetEle("triggerOperationDiff").value;
	    		$GetEle("trTriggerOperationDiff").style.display="";
	    		$GetEle("trTriggerOperationDiffNew").style.display="none";
	    	}
	    	if(triggerTimeDiff==2){
	    		finalOperationDiffValue = $GetEle("triggerOperationDiffNew").value;
	    		$GetEle("trTriggerOperationDiff").style.display="none";
	    		$GetEle("trTriggerOperationDiffNew").style.display="";
	    		//TD23271:20110505 ADD BY QB START
	    		$GetEle("triggerOperationDiffNew").style.display="";
	    		$GetEle("triggerOperationDiff").style.display="none";
	    		//TD23271:20110505 ADD BY QB END
	    	}
		} else {
			//TD23271:20110505 ADD BY QB START
			$GetEle("triggerOperationDiffNew").style.display="none";
			$GetEle("triggerOperationDiff").style.display="none";
			//TD23271:20110505 ADD BY QB END
		}
	}
	$GetEle("trTriggerOperationDiffHidden").value = finalOperationDiffValue;
}

function triggerOperationDiffSelected(){
	var triggerNodeIdDiff=document.getElementById("triggerNodeIdDiff").value;
    var triggerNodeTypeDiff=triggerNodeIdDiff.substring(0,triggerNodeIdDiff.indexOf("_"));
    triggerNodeIdDiff=triggerNodeIdDiff.substr(triggerNodeIdDiff.lastIndexOf("_")+1)
    
    var triggerTypeDiff=document.getElementById("triggerTypeDiff").value;
    var triggerTimeDiff=document.getElementById("triggerTimeDiff").value;
    
	var finalOperationDiffValue="";
	if(triggerTypeDiff==1){
		if(triggerNodeTypeDiff==1||triggerTimeDiff==1){
	    	if(triggerTimeDiff==1){ //到达节点
	    		finalOperationDiffValue = document.getElementById("triggerOperationDiff").value;
	    	}
	    	if(triggerTimeDiff==2){ //离开节点
	    		finalOperationDiffValue = document.getElementById("triggerOperationDiffNew").value;
	    	}
		}
	}
	document.getElementById("trTriggerOperationDiffHidden").value = finalOperationDiffValue;
}

function onSaveWorkflowTriDiffWfSubWfField(obj){
	obj.disabled=true;
	doPost(formWorkflowTriDiffWfSubWfField,tab0002);	
}

function onCancelWorkflowTriDiffWfSubWfField(obj,triDiffWfDiffFieldId){
	doGet(tab0002, "/workflow/workflow/WorkflowTriDiffWfSubWf.jsp?ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId);
}
function onCancelWorkflowTriDiffWfSubWf(obj){
	doGet(tab0002, tab0002URL);
}

function goWorkflowTriDiffWfSubWf(talID, triDiffWfDiffFieldId){
	doGet(talID, "/workflow/workflow/WorkflowTriDiffWfSubWf.jsp?ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId);
}
function onShowBrowser4opM1(url,index,tmpindex){
	var tempid = "id_"+index;
	var url1 = url+"?selectedids="+document.all(tempid).value;
	onShowBrowser4opM(url1,index,tmpindex);
}

function deleteRow1(oTableName){
   //ypc 2012-09-04 
	var oTable = null;
	if (oTableName != null && oTableName != undefined) {
		oTable = $G(oTableName);
	}
    if(rowindex == -1)
    rowindex=document.all("noderowsum").innerHTML;
    len = document.nodeform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.nodeform.elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.nodeform.elements[i].name=='check_node'){
			if(document.nodeform.elements[i].checked==true) {
				if(document.nodeform.elements[i].value!='0')
					delids +=","+ document.nodeform.elements[i].value;
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}
function changeattri(obj){
    var attriname=obj.name;
    var passnumname=attriname.substring(0,attriname.length-9)+"passnum";
    if(obj.value=="3"){
        document.nodeform.all(passnumname).style.display='';
    }else{
        document.nodeform.all(passnumname).style.display='none';
    }
}
function subclear(oTableName){
	if (isdel()) {
		deleteRow1(oTableName);
	}
}
function dochangeChangeTime(obj){
	var changetime_tmp = obj.value;
	if(changetime_tmp == "1"){
		document.getElementById("changemodetr1").style.display = "";
		document.getElementById("changemodetr0").style.display = "none";
		document.getElementById("changemodetr2").style.display = "";
		document.getElementById("changemode").style.display = "";
		document.getElementById("changemode0").style.display = "none";
	}else if(changetime_tmp == "2"){
		document.getElementById("changemodetr1").style.display = "none";
		document.getElementById("changemodetr0").style.display = "";
		document.getElementById("changemodetr2").style.display = "";
		document.getElementById("changemode").style.display = "none";
		document.getElementById("changemode0").style.display = "";
	}else{
		document.getElementById("changemodetr1").style.display = "none";
		document.getElementById("changemodetr2").style.display = "none";
		document.getElementById("changemode").style.display = "none";
		document.getElementById("changemodetr0").style.display = "none";
		document.getElementById("changemode0").style.display = "none";
	}
}
function doShowBaseData(wfid_){
	openFullWindow("/system/basedata/basedata_workflow.jsp?wfid="+wfid_);
}