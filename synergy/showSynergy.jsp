
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/init.jsp" %>

<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page"/>
<jsp:useBean id="sm" class="weaver.synergy.SynergyManage" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="eu" class="weaver.page.element.ElementUtil" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
	//由于这个页面include 在 initjsp中，因此这里尽量减少逻辑；
	//首先判断页面地址是否在数据库中有记录，如果不在，直接return掉；   注：数据库记录是初始化进去的，目前不可维护
	String _synergypath = Util.null2String(request.getServletPath());
	String _s_hpid = sc.isSynergyModule(_synergypath,request);//正数
	//baseBean.writeLog("showSynergy.jsp _synergypath:===>"+_synergypath);
	//baseBean.writeLog("showSynergy.jsp _s_hpid:===>"+_s_hpid);
	if(_s_hpid.equals("") || (null != request.getParameter("needsynergy") && "0".equals(request.getParameter("needsynergy")) && request.getHeader("User-Agent").toLowerCase().indexOf("msie") == -1) || (request.getAttribute("flag")!= null && request.getAttribute("flag").equals("1")))return;
	request.setAttribute("flag","1");

	// 协同 的 _s_hpid 都为 负数， 值为 synergy_base id
	_s_hpid = "-"+_s_hpid; 
	
	//判断当前协同是否启用
	rs.execute("select * from synergyconfig where hpid="+_s_hpid);
	if(rs.next()){
		if("0".equals(rs.getString("isuse")) || "".equals(rs.getString("isuse")))return;
	}else{
		return;
	}
	//判断当前 协同是否有 元素内容，如果没有则不展示
	rs.execute("select * from hplayout where hpid="+_s_hpid);
	String areaElements = "";
	if(rs.next()){
		if("".equals(rs.getString("areaElements"))){
			return;
		}else{
			areaElements = rs.getString("areaElements");
		}
	}else{
		return;
	}
	
	//判断当前用户对 当前协同是否有 查看元素的权限
	  
	int nodelUserid=pu.getHpUserId(_s_hpid,"-1",user);
    int nodelUsertype=pu.getHpUserType(_s_hpid,"-1",user);
    
    
    if("".equals(eu.filterElementByUserRight(areaElements,user.getUID()+"",nodelUserid,nodelUsertype))){
    	//无 有权限查看的元素
    	return ;
    }

	
   
	
	//流程中心需要使用requestid
	int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
	//文档中心则使用“docid”，id
	if(-1==requestid){
		 //docid
	     requestid = sc.getDocID(_synergypath,request);
	}
	
	//baseBean.writeLog("_s_hpid="+_s_hpid);
	
    
%>


<head>



<script type="text/javascript">

    function  resetItem(){
       var centerTop = 0;
	 	centerTop = jQuery(window).height()/2 - 16;
	 	if(navigator.userAgent.indexOf("MSIE 8.0")>0 && !window.innerWidth){//这里是重点，你懂的
        	vart=setTimeout(
        		function(){
        			centerTop = jQuery(window).height()/2 - 16;
        			jQuery("#synergy_moveDiv").css("top",centerTop);
		 			jQuery("#synergy_moveDiv").css("display","block");
        			}
       		,1000);
      	}else
      	{   
		 	jQuery("#synergy_moveDiv").css("top",centerTop);
		 	jQuery("#synergy_moveDiv").css("display","block");
	 	}
		
	 	if(jQuery(window.document.body).find("._synergyBox").length > 0)
		{
			var ptop ;
			var bodyheight = jQuery(window.document.body).height();
			var headHeight = 0;
			headHeight = jQuery(window.document).find(".e8_boxhead").height();
			ptop = headHeight+1;
			
			jQuery("#synergy_framecontent").css("top",ptop);
			var phei = bodyheight - ptop;
			jQuery("#synergy_framecontent").css("height",phei);
		}else{
			jQuery(window.document).find("#synergy_framecontent").css("height",window.document.body.scrollHeight);
		}
		var executetime=0;
       //设置高度
        setTimeout(function reset(){
          //alert($(window.document.body).height());
		 // alert($(window).height())
	
	      if(executetime<5){
			   var syheight=window.document.body.scrollHeight<$(window).height()?$(window).height():window.document.body.scrollHeight;
			   jQuery(window.document).find("#synergy_framecontent").css("height",syheight);
			   executetime++;
			   reset();
			  }
             
		   },1000);
	
    }

	jQuery(document).ready(function(){
	 	var centerTop = 0;
	 	centerTop = jQuery(window).height()/2 - 16;
	 	if(navigator.userAgent.indexOf("MSIE 8.0")>0 && !window.innerWidth){//这里是重点，你懂的
        	vart=setTimeout(
        		function(){
        			centerTop = jQuery(window).height()/2 - 16;
        			jQuery("#synergy_moveDiv").css("top",centerTop);
		 			jQuery("#synergy_moveDiv").css("display","block");
        			}
       		,1000);
      	}else
      	{   
		 	jQuery("#synergy_moveDiv").css("top",centerTop);
		 	jQuery("#synergy_moveDiv").css("display","block");
	 	}
		
	 	if(jQuery(window.document.body).find("._synergyBox").length > 0)
		{
			var ptop ;
			var bodyheight = jQuery(window.document.body).height();
			var headHeight = 0;
			headHeight = jQuery(window.document).find(".e8_boxhead").height();
			ptop = headHeight+1;
			
			jQuery("#synergy_framecontent").css("top",ptop);
			var phei = bodyheight - ptop;
			jQuery("#synergy_framecontent").css("height",phei);
		}else{
			jQuery(window.document).find("#synergy_framecontent").css("height",window.document.body.scrollHeight);
		}
		var executetime=0;
       //设置高度
        setTimeout(function reset(){
          //alert($(window.document.body).height());
		 // alert($(window).height())
	
	      if(executetime<5){
			   var syheight=window.document.body.scrollHeight<$(window).height()?$(window).height():window.document.body.scrollHeight;
			   jQuery(window.document).find("#synergy_framecontent").css("height",syheight);
			   executetime++;
			   reset();
			  }
             
		   },1000);
		   //resize重置协同区
		   jQuery(window).resize(function(){
		        resetItem();
		        var iframe = jQuery(window.document).find("#synergy_framecontent").contents();
		        if(jQuery(window.document.body).find("._synergyBox").length > 0){
		           jQuery(iframe[0].body).find("#Element_Container").css("height",($(window).height()-jQuery(window.document).find(".e8_boxhead").height())+'px');
		        }else{
		        jQuery(iframe[0].body).find("#Element_Container").css("height",($(window).height()-10)+'px');
		        }
		   });
		   
	});
	function movebtnClick_handle()
	{
		 //var evt = document.createEvent("MouseEvents");   
        //evt.initEvent("click", true, true);
		 //window.frames["synergy_framecontent"].document.getElementById("relbtn").click();
		 jQuery("#synergy_framecontent").contents().find("#relbtn").click();
		
	}
	
</script>
</head>
<body>
<div style="z-index:99996">
<iframe id="synergy_framecontent" src="/synergy/showSynergyFrame.jsp?hpid=<%=_s_hpid %>&requestid=<%=requestid %>"
	frameborder=no scrolling=no 
    style="top: 0px;
    right: 0px;
    position: fixed;
    width: 0px;
    z-index:99997;
    "
></iframe>
<div id="synergy_moveDiv" title="<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(32832,user.getLanguage()) %>" onclick="javascript:movebtnClick_handle();" style="z-index:99998;cursor: pointer;width:10px;height:33px;position:fixed;right:0px;display:none";>
 	<img id="synergy_moveImgBtn" src="/page/resource/userfile/image/synergy/left_wev8.png"/>
</div>
</div>
</body>
