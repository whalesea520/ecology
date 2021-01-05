<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xmlParser" class="weaver.workflow.layout.WorkflowXmlParser" scope="page" />
<html xmlns:v="urn:schemas-microsoft-com:vml">
<HEAD>
<TITLE></TITLE>
<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>
<% 
	String type = Util.null2String(request.getParameter("type"));
	String workflowId = Util.null2String((String)request.getParameter("wfId"));
	String serverstr=request.getScheme()+"://"+request.getHeader("Host");
    xmlParser.setWorkflowId(workflowId);
    xmlParser.setUser(user);
    String xmlContent = xmlParser.parseWorkflowToXML(type);
%>
<script type="text/javascript">
var type ='<%=type%>';
</script>
<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/workflow/design/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/workflow/design/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/workflow/design/lang-tw_wev8.js'></script>
<%}%>
<link href="/css/wfdesign_wev8.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/WeaverMsgExt_wev8.js"></script>
<!--script type="text/javascript" src="/js/workflow/design/WeaverPropertyGrid_wev8.js"></script-->
<script type="text/javascript" src="/js/workflow/design/common_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/dtree_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/shape_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/toppanel_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/topflow_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/topflowevent_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/contextmenu_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />

</HEAD>

<BODY  oncontextmenu="return false" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
<div id="loading" style="display:none">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>
<div style='left:0px;top:0px;width:100%;height:100%;position:absolute;z-index:-1000' id="Canvas" onclick="canvasOnClick()"></div>
<v:rect class="toolui" style="display:none" id="_rectui">
<v:Stroke dashstyle="dashdot"/>
</v:rect>
<v:rect class="toolui" style="display:none" fillcolor="#CCCCCC" id="_fillrectui">
<v:Stroke dashstyle="dashdot"/>
</v:rect>
<v:roundrect class="toolui" style="display:none;left:0px;top:0px;width:60px;height:50px;" id="_roundrectui">
<v:Stroke dashstyle="dashdot"/>
</v:roundrect>
<v:shape type="#diamond" class="toolui" style="display:none;left:0px;top:0px;width:60px;height:50px;" strokeweight="1px" id="_diamondui">
<v:Stroke dashstyle="dashdot"/>
</v:shape>
<v:oval class="toolui" style="display:none;left:0px;top:0px;width:60px;height:50px;" id="_ovalui">
<v:Stroke dashstyle="dashdot"/>
</v:oval>
<v:line class="toolui" style="display:none" from="0,0" to="100,0" id="_lineui">
<v:Stroke dashstyle="dashdot" StartArrow="" EndArrow="Classic"/>
</v:line>
<v:polyline class="toolui" style="display:none" from="0,0" to="100,0" id="_polylineui" filled="false" StrokeWeight="1" StrokeColor="#55AAFF">
<v:Stroke dashstyle="dashdot" StartArrow="" EndArrow="Classic"/>
</v:polyline>
<v:rect class="toolui" style="display:none;left:0px;top:0px;width:60px;height:50px;" filled='false' strokecolor="#7D9AF0" strokeweight="1pt" id="_selectboxui">
  <v:stroke dashstyle="dashdot"/>
</v:rect>
<script type="text/javascript">
var xmlContent = '<%=xmlContent%>';
var mask = new Ext.LoadMask(Ext.getBody(),{msg:wmsg.wfdesign.processing})
toggleMenu(false);
if(xmlContent!=''){
	_FLOW.loadFromXML(xmlContent);
	DrawVML();
	//TODO
	_FLOW.setAllStepInfo();
}

if(type=='edit'){
 	grid();
}

//function
function DrawVML(){
  
  Canvas.innerHTML = _FLOW.ProcString();
  Canvas.innerHTML += _FLOW.StepString();
  _FLOW.getInnerObject();
  //_FOCUSTEDOBJ = null;
}

/*左对齐*/
function alignLeft(){
	if(selectedItem.length<2){
		return;
	}
	var minX = parseInt(selectedItem[0].X);
	
	if(_SORTBASEPROC!=null){
		minX = parseInt(_SORTBASEPROC.X);
	}else{
		for(var i=0;i<selectedItem.length;i++){
			if(minX>parseInt(selectedItem[i].X)){
				minX = selectedItem[i].X;
			}

		}
	}
	_MOVETYPE = "proc_m";
	var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	var oldVal ;
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		oldVal = {"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		moveObj.objID[ moveObj.objID.length] = _proc.ID;
		_proc.setPropValue("X",minX);
		
		document.all(_proc.ID).style.left=minX
		changeProcPos(document.all(_proc.ID));
		 moveObj._old[moveObj._old.length]=oldVal;
		 moveObj._new[moveObj._new.length]={"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
	}
	 moveObj.moveType = _MOVETYPE;
	 _FLOW.Modified = true;	
	 pushLog("moveproc", moveObj);	
	_MOVETYPE = "";
	//DrawAll();
}
/*右对齐*/
function alignRight(){
	if(selectedItem.length<2){
		return;
	}
	var maxX= parseInt(selectedItem[0].X)+parseInt(selectedItem[0].Width);
	if(_SORTBASEPROC!=null){
		maxX =  parseInt(_SORTBASEPROC.X)+parseInt(_SORTBASEPROC.Width);
	}else{
		for(var i=0;i<selectedItem.length;i++){
			
			if(maxX<parseInt(selectedItem[i].X)+parseInt(selectedItem[i].Width)){
				maxX = parseInt(selectedItem[i].X)+parseInt(selectedItem[i].Width);
			}
			
		}
	}
	_MOVETYPE = "proc_m";
	
	var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	var oldVal ;
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		oldVal = {"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		moveObj.objID[ moveObj.objID.length] = _proc.ID;
		_proc.setPropValue("X",maxX-parseInt(selectedItem[i].Width));
		document.all(_proc.ID).style.left=maxX-parseInt(selectedItem[i].Width)
		changeProcPos(document.all(_proc.ID));
		 moveObj._old[moveObj._old.length]=oldVal;
		 moveObj._new[moveObj._new.length]={"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
	}
	 moveObj.moveType = _MOVETYPE;
	 _FLOW.Modified = true;	
	 pushLog("moveproc", moveObj);	
	_MOVETYPE = "";
	//DrawAll();
}
/*左右间距相等*/
function alignCenter(){
    
	if(selectedItem.length<2){
		return;
	}
	var space=0;
	
	quickSort(selectedItem,0,selectedItem.length-1,'X');
	
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		var _nextProc = _FLOW.getProcByID(selectedItem[i+1].ID);
		space += parseInt(_nextProc.X)-(parseInt(_proc.X)+parseInt(_proc.Width));
		
		if(i+1==selectedItem.length-1){
			break;
		}
	}
	
	space = parseInt(space/(selectedItem.length-1));
	_MOVETYPE = "proc_m";
	var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	var oldVal ;
	for(var i=0;i<selectedItem.length;i++){
		if(i==0){
			continue;
		}
		var _preProc = _FLOW.getProcByID(selectedItem[i-1].ID);
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		oldVal = {"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		moveObj.objID[ moveObj.objID.length] = _proc.ID;
		_proc.setPropValue("X",parseInt(_preProc.X)+parseInt(_preProc.Width)+space)
		document.all(_proc.ID).style.left=parseInt(_preProc.X)+parseInt(_preProc.Width)+space
		changeProcPos(document.all(_proc.ID));
		 moveObj._old[moveObj._old.length]=oldVal;
		 moveObj._new[moveObj._new.length]={"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		
	}
	 moveObj.moveType = _MOVETYPE;
	 _FLOW.Modified = true;	
	 pushLog("moveproc", moveObj);	
	_MOVETYPE = "";
	//DrawAll();
}

/*上对齐*/
function lignTop(){
	if(selectedItem.length<2){
		return;
	}
	var minY = parseInt(selectedItem[0].Y);
	if(_SORTBASEPROC!=null){
		minY = _SORTBASEPROC.Y
	}else{
		for(var i=0;i<selectedItem.length;i++){
			
			if(minY>parseInt(selectedItem[i].Y)){
				minY = selectedItem[i].Y;
			}
			
		}
	}
	_MOVETYPE = "proc_m";
	var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	var oldVal ;
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		oldVal = {"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		moveObj.objID[ moveObj.objID.length] = _proc.ID;
		_proc.setPropValue("Y",minY);
		document.all(_proc.ID).style.top=minY
		changeProcPos(document.all(_proc.ID));
		 moveObj._old[moveObj._old.length]=oldVal;
		 moveObj._new[moveObj._new.length]={"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		
	}
	 moveObj.moveType = _MOVETYPE;
	 _FLOW.Modified = true;	
	 pushLog("moveproc", moveObj);	
	_MOVETYPE = "";
	//DrawAll();
}

/*下对齐*/
function lignBottom(){
	if(selectedItem.length<2){
		return;
	}
	var maxY= parseInt(selectedItem[0].Y)+parseInt(selectedItem[0].Height);
	if(_SORTBASEPROC!=null){
		maxY = parseInt(_SORTBASEPROC.Y)+parseInt(_SORTBASEPROC.Height);
	}else{
		for(var i=0;i<selectedItem.length;i++){
			
			if(maxY<parseInt(selectedItem[i].Y)+parseInt(selectedItem[i].Height)){
				maxY = parseInt(selectedItem[i].Y)+parseInt(selectedItem[i].Height);
			}
			
		}
	}
	_MOVETYPE = "proc_m";
	var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	var oldVal ;
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		oldVal = {"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		moveObj.objID[ moveObj.objID.length] = _proc.ID;
		_proc.setPropValue("Y",maxY-parseInt(selectedItem[i].Height));
		document.all(_proc.ID).style.top=maxY-parseInt(selectedItem[i].Height)
		changeProcPos(document.all(_proc.ID));
		moveObj._old[moveObj._old.length]=oldVal;
		moveObj._new[moveObj._new.length]={"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
	}
	 moveObj.moveType = _MOVETYPE;
	 _FLOW.Modified = true;	
	 pushLog("moveproc", moveObj);	
	_MOVETYPE = "";
	//DrawAll();
}

/*上下间距相等*/
function lignMiddle(){
	if(selectedItem.length<2){
		return;
	}
	
	var space=0;
	quickSort(selectedItem,0,selectedItem.length-1,'Y');
	
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		var _nextProc = _FLOW.getProcByID(selectedItem[i+1].ID);
		space += parseInt(_nextProc.Y)-(parseInt(_proc.Y)+parseInt(_proc.Height));
		
		if(i+1==selectedItem.length-1){
			break;
		}
	}
	
	space = parseInt(space/(selectedItem.length-1));
	_MOVETYPE = "proc_m";
	var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	var oldVal ;
	for(var i=0;i<selectedItem.length;i++){
		if(i==0){
			continue;
		}
		var _preProc = _FLOW.getProcByID(selectedItem[i-1].ID);
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		oldVal = {"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		moveObj.objID[ moveObj.objID.length] = _proc.ID;
		_proc.setPropValue("Y",parseInt(_preProc.Y)+parseInt(_preProc.Height)+space)
		document.all(_proc.ID).style.top=parseInt(_preProc.Y)+parseInt(_preProc.Height)+space
		_MOVETYPE = "proc_m";
		changeProcPos(document.all(_proc.ID));
		moveObj._old[moveObj._old.length]=oldVal;
		moveObj._new[moveObj._new.length]={"X":_proc.X,"Y":_proc.Y,"Width":_proc.Width,"Height":_proc.Height};
		
	}
	 moveObj.moveType = _MOVETYPE;
	 _FLOW.Modified = true;	
	 pushLog("moveproc", moveObj);	
	_MOVETYPE = "";
	//DrawAll();
}

function updateSelectItem(){
	for(var i=0;i<selectedItem.length;i++){
		var _proc = _FLOW.getProcByID(selectedItem[i].ID);
		
		selectedItem[i].setPropValue("Y",_proc.Y);
		selectedItem[i].setPropValue("X",_proc.X);
	}
}

function grid(){
	var obj = document.body.style.backgroundImage;
    if (obj == '') 
    	document.body.style.backgroundImage = 'url(/images/wfdesign/bg_wev8.jpg)';
    else 
    	document.body.style.backgroundImage = '';
}

function DrawAll(){
  //DrawTree();
  DrawVML();
  //DrawDataView();
}

function LoadFlow(AUrl){
  if(AUrl == "")
    _FLOW.createNew("");
  else
    _FLOW.loadFromXML(AUrl);
  DrawAll();
  emptyLog();
}

function ObjSelected(){
  if(_FOCUSTEDOBJ == null){
    parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.noFocus);
    return false;  
  }
  return true;
}


function mnuSaveFlow(){ 
	_FLOW.SaveToXML();
	
}



function mnuDelObj(){
  if(type=='view'){
    return;
  }
  if(selectedItem.length>0){
  	deleteObjs();
  	
  }else if(ObjSelected()){
  	deleteObj(_FOCUSTEDOBJ.id);
  }
  var p = window.parent.property;
  p.setSource({});
}

function mnuSetZoom(Act){
  var rate = Act == "in"?0.2:-0.2;
  var newzoom = _ZOOM + rate;
  if(newzoom > 2) return;
  if(newzoom < 0.2) return;
  changeZoom(newzoom);
  document.all("zoomshow").value = _ZOOM;
}

function changeZoom(v){
  _ZOOM = parseFloat(parseFloat(v).toFixed(2));
  Canvas.style.zoom = _ZOOM;
}


</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--

function canvasOnClick(){
	
	if(event.srcElement.tagName=="DIV"&&event.srcElement.id=='Canvas'){
		if(type=='edit'){
			var p = window.parent.property;
		    p.setSource(_FLOW.getPropertySource());
	  	}
  	}
}
function setType(o){
	_TOOLTYPE = o.cType;
}
function create(){
	LoadFlow("001.xml");
}



</SCRIPT>
<a id='reload' href='/workflow/design/wfdesigncontent.jsp?wfId=<%=workflowId%>&type=<%=type%>' style='display=none'></a>
</BODY>
</HTML>
