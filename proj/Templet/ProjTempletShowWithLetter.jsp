<%@page import="org.json.JSONObject"%>
<%@page import="net.sourceforge.pinyin4j.PinyinHelper"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<HTML>
	<HEAD>
	    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	    <SCRIPT language="javascript" src="/proj/js/common_wev8.js"></SCRIPT>
		<script  src='/js/ecology8/jquery_wev8.js'></script>
        <script  src='/js/ecology8/weaverautocomplete/jquery.autocomplete_wev8.js'></script>
        <style>
           .listbox2 ul {
             margin: 0 0 0 0;
             padding: 0px;
             list-style: none;
      /**       border-top: 1px solid #ccc;**/
            }

            .listbox2 {
             width:99%;
          /**   border: 1px solid #ccc; **/
			 margin-bottom: 32px;
			 margin-right:0px;
             }

            .listbox2 .titleitem{
			height: 26px;
            line-height: 26px;
         /**   background: #F7F7F7;**/
            font-weight: bold;
		/**	padding-left: 10px;**/
			border-bottom: 2px solid #e4e4e4;
			}
         
            .listbox2 .opimg{
			vertical-align: middle;
			margin-right:10px;
			}

		    TABLE.ViewForm TD {
              padding: 0 0 0 5;
			  BACKGROUND-COLOR: white;
            }

		    .listbox2 ul li a{
		     color: black;
			 margin-left:8px;
			 margin-right:12px;
		    }

          .listbox2 ul li {
             height: 30px;
             line-height: 30px;
			 border-bottom:1px dashed #f0f0f0;
			 padding-left: 0px;
		/**	 background-image:url(http://localhost:9090/images/ecology8/top_icons/1-1_wev8.png);
			 background-position:0px 50%;
			 background-repeat:no-repeat no-repeat;**/
            }
          

		   TABLE.ViewForm A:link {
			  COLOR: grey;
			  TEXT-DECORATION: none;
			  vertical-align: middle;
			  line-height: 24px;
           }

           .ViewForm .commonitem{
			 /**  border: 1px solid #ccc;**/
			   margin-bottom: 32px;
			   width: 99.7%;
		 
		   }

			TABLE.ViewForm TD {
				padding: 0px;
				BACKGROUND-COLOR: white;
			}
			
			.ViewForm .commonitem .commonitemtitle{
				height: 26px;
				line-height: 26px;
			/**	background: #F7F7F7;**/
				font-weight: bold;
				border-bottom: 2px solid #e4e4e4;
			/**	padding-left: 10px;**/
			}
			
			.ViewForm .increamentinfo{
			  color:grey;
			  margin-left: 10px;
			}
			#warn{
				width: 260px;
				height: 65px;
				line-height:65px;
				background-color: gray;
				position: absolute;
				display:none;
				text-align:center;
				background: url("/images/ecology8/addWorkGround_wev8.png");
			}
			.titlecontent{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
			}
			.commian{
				float:left;
				color:#232323;
			/**	margin-top: 0.5px;**/
				border-bottom:2px solid #9e17b6;
			}

				
				 
		    .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
				}

			.autocomplete-suggestions { border: none;background: #F5F5F5;}
			.autocomplete-suggestion { padding: 2px 5px; color:#5b5b5b;white-space: nowrap; overflow: hidden;height:30px;line-height:30px;cursor: pointer;text-overflow:ellipsis;border-bottom:1px solid #e2e3e4;}
			.autocomplete-selected { border-bottom:1px solid #99cdf8;color:#292828; }

			.autocomplete-suggestions strong { font-weight: normal; color: #292828; }
 
            /*代理样式*/
            .agentitem{

				padding: 2px;
				
			}
            
			.chosen{
			   background:#3399ff;
			   color:white;
			   cursor:pointer;
			}

			.agentitem a:hover{
			color:#ffffff !important;
			}

             .letters
			 {
			   
			   position:fixed;
			   left:0;
			   background:white;
			   padding-top:10px;
			   z-index:999;
			   width:100%;
			   top: expression( (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) + 'px' );
			   
			 }

			 .lettersplacehold{
			   height:50px;
               width:100%;
			 }
             
			 .letters ul{
			 
			    list-style: none;
				padding: 0;
				margin-left: 10px;
				font-size: 14px;
				margin-top: 2px;

			 }

			 .letters .letteritem{
			   
				float: left;
				height: 30px;
				line-height: 30px;
				margin-left: -1px;
				border: 1px dashed #dddddd;
				width: 30px;
				text-align: center;
				cursor:pointer;
				color: #667dad;
				position: relative;
			 }

			 .letterhasdata{
			 	 position:absolute;
				 top:0px;
				 right:0px;
				 display:none;
			 }
			 
			 .letters a{
			 
				 color: #e5e5e5;
				 width: 100%;
				 display: inline-block;
				 height: 100%;
				 cursor:text;
				 
			 }

             .letters a:hover{
			  
             margin-top:-3px;
			 
			 

			 }
             
			 .selectedletter a:hover
			 {
			  color:white !important;
			 
			 }
			
             .acolor{
			 
			 color:white !important;
			 
			 }



			 .lettercontainer{
			 
			 margin-bottom:40px;
			 clear: left;
			 
			 }

			 .signalletter{
			 
			 height: 45px;
			line-height: 45px;
			font-size: 18px;
			margin-left: 8px;
		    font-weight: 200;;
			border-bottom: 2px solid #e2e2e2;
			 
			 }
             .letterline{
			   height:2px;
               width:70px;
			   margin-top: -2px;
			 }
			 .itemdetail{
			  height:32px;
			  line-height:32px;
			  width: 30%;
			  margin-right: 3%;
              float: left;
			
			 }
              /*帮助元素里面的节点垂直居中展示*/
			   .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
				}
		  .menuitem{

		    margin-bottom:5px;
		   
		   
		   }
					/*动态计算浮动签字栏距离top的距离*/
		  .flowmenuitem {
			  /* IE5.5+/Win - this is more specific than the IE 5.0 version */
			  right: auto; bottom: auto;
			  top: expression( ( -0.1 - this.offsetHeight + ( document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) ) + 'px' );
			  BACKGROUND-COLOR: #F7F7F7;

			}


            
			.selectedletter{
			
			  background:#2a8ede !important;
              color:white !important;
			
			
			}
			  
			 .wrapper{
			    position: absolute;
				width: 100%;
				height: 42px;
				top: 0;
				left: 0;
				background: #999999;
				z-index: -1;
			 
			 }
             
			

		</style>
		<link href="/css/ecology8/request/requestTypeShow_wev8.css" type="text/css" rel="STYLESHEET">	    
	    
	    
	</HEAD>

<%
    
    String imagefilename = "/images/sales_wev8.gif";
	String titlename = "";
	String needfav ="1";
	String needhelp ="";//取得相应设置的值
	int userid=user.getUID();
	String logintype = user.getLogintype();

    ArrayList projectColList = new ArrayList();
    //ArrayList secondColList = new ArrayList();

    int firstColNum = 0;
    int totalProjectType = ProjectTypeComInfo.getProjectTypeNum();
    if (totalProjectType%2==0)   firstColNum = totalProjectType/2;
    else firstColNum = totalProjectType/2+1;

      
    int i=0;
    while(ProjectTypeComInfo.next()){
        String projectTypeId = ProjectTypeComInfo.getProjectTypeid();       
        //if (i>=firstColNum) {
            //firstColList.add(projectTypeId);
        //} else {
            //secondColList.add(projectTypeId);
        //}
        projectColList.add(projectTypeId);
        i++;
    }
    
    /* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
	
    String selectArr = "";
    
    if(selectedContent!=null && selectedContent.startsWith("key_")){
		String menuid = selectedContent.substring(4);
		RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
		selectedContent = "";
		while(RecordSet.next()){
			String keyVal = RecordSet.getString(2);
			selectedContent += keyVal +"|";
		}
		if(selectedContent.indexOf("|")!=-1)
			selectedContent = selectedContent.substring(0,selectedContent.length()-1);
	}
    
	boolean navigateTo = false;
	int proTypeId = 0;
    if(fromAdvancedMenu==1){//目录选择来自高级设置
    	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    	if(info!=null){
    		selectArr = info.getSelectedContent();
    		List projectNum = Util.TokenizerString(selectArr,"|");
    		int tnum = 0;
    		for(Iterator it = projectNum.iterator();it.hasNext();){
    			if(((String)it.next()).startsWith("P")) tnum++;
    		}
    		if(tnum==1) navigateTo = true;
    	}
    }
    if(navigateTo){
        if(!selectArr.equals("")) proTypeId = Util.getIntValue(selectArr.substring(1));
    	response.sendRedirect("/proj/data/AddProject.jsp?projTypeId="+proTypeId);
    	return;
    }
    if(!"".equals(selectedContent))
    {
    	selectArr = selectedContent;
    }
    if(!selectArr.equals("")) selectArr+="|";
    /* end */

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%	
if(fromAdvancedMenu==1){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(16346,user.getLanguage())+",javascript:onuserdefault(0),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
}
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">	
 if(parent.$("#searchInput").length && parent.$("#searchInput").length===1){
	parent.$("#searchInput").remove();
 }
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" id='searchInput' class="searchInput" name="flowTitle" value=""/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
         	<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18375,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">



<div style="margin-left:10px!important;margin-right:10px!important;">

 <div class='lettersplacehold' ></div>

  
  <div class='letters' style='top:0;_POSITION: absolute;'>
      
	  <ul>
         <li class='letteritem'><a class='#A'>A</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#B'>B</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#C'>C</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#D'>D</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#E'>E</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#F'>F</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#G'>G</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#H'>H</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#I'>I</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#J'>J</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#K'>K</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#L'>L</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#M'>M</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#N'>N</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#O'>O</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#P'>P</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#Q'>Q</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#R'>R</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#S'>S</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#T'>T</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#U'>U</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#V'>V</a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#W'>W</a><div class='letterhasdata'><img src='\images\ecology8\request\l3_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#X'>X</a><div class='letterhasdata'><img src='\images\ecology8\request\l4_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#Y'>Y</a><div class='letterhasdata'><img src='\images\ecology8\request\l5_wev8.png' ></div></li>
		 <li class='letteritem'><a class='#Z'>Z</a><div class='letterhasdata'><img src='\images\ecology8\request\l1_wev8.png' ></div></li>
		 <li class='letteritem' style='width:60px'><a class='#<%=SystemEnv.getHtmlLabelNames("375",user.getLanguage())%>'><%=SystemEnv.getHtmlLabelNames("375",user.getLanguage())%></a><div class='letterhasdata'><img src='\images\ecology8\request\l2_wev8.png' ></div></li>
	  </ul>  

  </div>
 
  
   <div class='wfcontentarea'>


								

                                          
<%
    

//包含特殊字符的流程
final TreeMap<String,JSONObject>  specialtmap=new TreeMap<String,JSONObject>();  
//按字母排序流程
final Map<String,Map<String,JSONObject>>  letterdatas=new TreeMap<String,Map<String,JSONObject>>();
String specialstr="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*()--+|{}【】‘；：”“’。，、？]"; 

HashMap<String,String> isSelectedMap=new HashMap<String,String>();
JSONObject jsonObject=null;
String sql="select * from Prj_Template  where status='1' order by proTypeId,isSelected desc ";
rs.executeSql(sql);
while(rs.next()){
	String wfid=Util.null2String( rs.getString("id"));
	String wfname=Util.null2String( rs.getString("templetName"));
	String isSelected=Util.null2String( rs.getString("isSelected"));
	String prjTypeId=Util.null2String( rs.getString("proTypeId"));
	if(isSelectedMap.containsKey(prjTypeId)){
		continue;
	}
	
	if("1".equals(isSelected)){
		isSelectedMap.put(prjTypeId, wfid);
		wfname+="("+SystemEnv.getHtmlLabelName(17908,user.getLanguage())+")";
	}
	
	jsonObject=new JSONObject();
	jsonObject.put("name", wfname);
	jsonObject.put("isSelected", isSelected);
	jsonObject.put("prjTypeId", prjTypeId);
	
	
	if(specialstr.indexOf(wfname.charAt(0))>=0){
   		specialtmap.put(wfid,jsonObject);
	}else{
	  char chinese = wfname.charAt(0);
	  String letter=PinyinHelper.toHanyuPinyinStringArray(chinese)==null?chinese+"":PinyinHelper.toHanyuPinyinStringArray(chinese)[0];
	  letter=(letter.charAt(0)+"").toUpperCase();
	  Map<String,JSONObject>  letteritems;	 
	 
	  if(!letterdatas.containsKey(letter)){
	     letteritems=new  LinkedHashMap<String,JSONObject>();
	     letterdatas.put(letter,letteritems);
	  }else{
	  	letteritems=letterdatas.get(letter);
	  }
	  
	  letteritems.put(wfid,jsonObject);
	}
	
}

String[] colorful=new String[]{"#9e17b6","#166ca5","#953735","#01b0f1","#cf39a4"};
int itemcolorindex=0;
if(!specialtmap.isEmpty()){
	letterdatas.put(""+SystemEnv.getHtmlLabelNames("375",user.getLanguage()),specialtmap);
}
  

	    for ( Map.Entry<String, Map<String,JSONObject>> e : letterdatas.entrySet() )
		{
             
          %>
             
			  
          <div class='lettercontainer'>
		     <div  class='<%=e.getKey()%>  signalletter'  style='color:<%=colorful[itemcolorindex%5]%>'>
			 <a id='<%=e.getKey()%>' style='color:<%=colorful[itemcolorindex%5]%>'><%=e.getKey()%></a></div>	
           
		     <script>
				    if($("a[class='#<%=e.getKey()%>']").length>0)
			          {
				          var letteritem=$("a[class='#<%=e.getKey()%>']");
				         // $("a[href='#<%=e.getKey()%>']").parent().find(".letterhasdata").show();
                          letteritem.css("color","#667dad");
						  letteritem.css("cursor","pointer");
                          letteritem.addClass("linkletteritem");
			          }

		     </script>



			 <div class='letterline' style='background:<%=colorful[itemcolorindex%5]%>'></div> 


		   <%
			Map<String,JSONObject> item=e.getValue();
		    int isagent=0;
			int beagenter=0;
			String agentname="";
		    ArrayList agenterlist=new ArrayList();
			for(Map.Entry<String,JSONObject>  entry:item.entrySet())
			   {
				
				JSONObject obj=entry.getValue();
				String ename= obj.getString("name");
				String eisselected= obj.getString("isSelected");
				String eprjtypeid= obj.getString("prjTypeId");
				
                %>
				
				 <div class='itemdetail'>
				 
				 <div class='centerItem'>
					<div class='fontItem'>

					 <img name='esymbol' src="/images/ecology8/request/workflowTitle_wev8.png" style="vertical-align: middle;"/>
					 
					<a style="color:grey;margin-left:8px;margin-right:10px;vertical-align: middle;" href="javascript:onNewPrj('<%=eprjtypeid %>','<%=entry.getKey() %>'<%="1".equals(eisselected)?",true":"" %>);">    <%=Util.toScreen(ename,user.getLanguage())%> </a>
                   
				   

					</div>
					<div class='imageItem'>
							<div class='imgspan'>
								<img onclick="onPreview('<%=entry.getKey() %>', this)" class='opimg'  src='/proj/img/preview_wev8.png' title='预览' />
							</div>
					</div>
            
			 </div>  
			</div>
		  <%
			itemcolorindex++;
		}
	}
	   
%>
                                    
      	</div>
 </div>
 
 
</div>


			
		</wea:item>
	</wea:group>
</wea:layout>



<div  class='flowmenuitem'  style='position:fixed;bottom:20px;right:20px;_POSITION: absolute;'>

  <div  class='menuitem freewf' style="display:none;">
  <input type='hidden' name='overitem' value='/images/ecology8/request/freewfover_wev8.png'>
  <input type='hidden' name='outitem' value='/images/ecology8/request/freewfout_wev8.png'>
   <input type='hidden' name='itemname' value='freewf'>
  <img src='/images/ecology8/request/freewfout_wev8.png' ></div>
  <div  class='menuitem'>
  <input type='hidden' name='overitem' value='/images/ecology8/request/wfsimpleover_wev8.png'>
  <input type='hidden' name='outitem' value='/images/ecology8/request/wfsimpleout_wev8.png'>
  <input type='hidden' name='itemname' value='simple'>
  <img src='/images/ecology8/request/wfsimpleout_wev8.png'></div>

   <div  class='menuitem' style='display:none'>
  <input type='hidden' name='overitem' value='/images/ecology8/request/voiceover_wev8.png'>
  <input type='hidden' name='outitem' value='/images/ecology8/request/voiceout_wev8.png'>
  <input type='hidden' name='itemname' value='voice'>
  <img src='/images/ecology8/request/voiceout_wev8.png'></div>

  <div  class='menuitem'>
  <input type='hidden' name='overitem' value='/images/ecology8/request/topover_wev8.png'>
  <input type='hidden' name='outitem' value='/images/ecology8/request/topout_wev8.png'>
        <input type='hidden' name='itemname' value='totop'>
  <img src='/images/ecology8/request/topout_wev8.png'></div>
 
 </div>


<script type="text/javascript">
			
function  bindInputEvent(){
   if(parent.$("#searchInput").length && parent.$("#searchInput").length===1){
		if(/msie/i.test(navigator.userAgent)){
			parent.document.getElementById('searchInput').onpropertychange=onBtnSearchClick;
		} else {//非ie浏览器，比如Firefox 
			parent.document.getElementById('searchInput').addEventListener("input",onBtnSearchClick,false);
		}                    
   }else{
       setTimeout(bindInputEvent,1000);
   }
}

$(function(){
	bindInputEvent();
	jQuery(".centerItem").unbind("mouseover");
	 jQuery(".centerItem").mouseover(function (){
		jQuery(this).css("background-color","#fbfbfb");
		//代理流程div
		var agent=jQuery(this).find(".agentlistdata").css("display");
		var imports=jQuery(this).find(".importwf").css("display");
		jQuery(".agentlistdata").css("display","none");
		jQuery(this).find(".agentlistdata").css("display",agent);
		
		jQuery(".importwf").css("display","none");
		jQuery(this).find(".importwf").css("display",imports);

		jQuery(".autocomplete-suggestions").css("display","none");

		jQuery(".imageItem").css("display","none");
		jQuery(".imgdiv").removeClass("imgdiv");
		
		if(agent!="none"&&jQuery(this).find(".agentlistdata").length>0){
			jQuery(this).find(".agent").addClass("imgdiv");
		}else{
			jQuery(this).find(".agent img").attr("src","/images/ecology8/agentwf_wev8.png");
		}
		if(imports!="none"&&jQuery(this).find(".importwf").length>0){
			jQuery(this).find(".import").addClass("imgdiv");
			if(jQuery(this).find(".importwf").find(".labelText").length>0){
			  jQuery(this).find(".importwf").css("height",76);
			}else{
			  jQuery(this).find(".importwf").css("height",(56+jQuery(".autocomplete-suggestions").height()));
			}
			jQuery(".autocomplete-suggestions").css("display","block");
		}else
           jQuery(this).find(".import img").attr("src","/proj/img/preview_wev8.png");


		jQuery(this).find(".imageItem").css("display","block");
	 })
		
	 jQuery(".centerItem").mouseleave(function (){
		jQuery(this).css("background-color","#ffffff");
		if(jQuery(this).find(".agentlistdata").length>0){
			//代理流程div
			var agent=jQuery(this).find(".agentlistdata").css("display");
			if(agent=="none"){
				jQuery(this).find(".imageItem").css("display","none");
			}
		}else if(jQuery(this).find(".importwf").length>0){
			//导入流程div
			var imports=jQuery(this).find(".importwf").css("display");
			if(imports=="none"){
				jQuery(this).find(".imageItem").css("display","none");
				jQuery(".autocomplete-suggestions").css("display","none");
			}
		}else{
			jQuery(this).find(".imageItem").css("display","none");
			//更改背景色
			jQuery(".imgdiv").removeClass("imgdiv");
		}	
	 })
	 
	 jQuery(".agentlistdata").mouseover(function (){
		jQuery(this).parent().find(".imageItem").css("display","block");
	 });
	 jQuery(".importwf").mouseover(function (){
		jQuery(this).parent().find(".imageItem").css("display","block");
	 });
	jQuery(".agentlistdata").find("a").mouseover(function (){
		jQuery(this).parent().css("border-bottom","1px solid #99cdf8");
	});
	jQuery(".agentlistdata").find("a").mouseout(function (){
		jQuery(this).parent().css("border-bottom","1px solid #e2e3e4");
	});
	jQuery(".menuitem").mouseover(function(){
		  jQuery(this).find("img").attr("src",jQuery(this).find("input[name='overitem']").val());
	});
  	jQuery(".menuitem").mouseleave(function(){
		  jQuery(this).find("img").attr("src",jQuery(this).find("input[name='outitem']").val());
	});

	jQuery(".menuitem").click(function(){
	      var itemname=jQuery(this).find("input[name='itemname']").val();
		  if(itemname==='simple'){//保存流程展示方式
           $.ajax({
				  type: "POST",
				  url: "/proj/Templet/ProjTempletShowOperation.jsp",
				  data: { showtype:0,userid:<%=userid%>}
				}).done(function( msg ){
				   if('success'===$.trim(msg)){
				   //先确认设置			 

					var iframe=jQuery(parent.document).find(".e8_box ").find("iframe");
				   //console.log("iframe:"+iframe);
					var links=jQuery(parent.document).find(".tab_menu").find("a");
					$(links[0]).attr("href","/proj/Templet/ProjTempletSeleTab.jsp?needPopupNewPage=true&dfdfid=a&needall=1");
					$(links[1]).attr("href","/proj/Templet/ProjTempletSeleTab.jsp?needPopupNewPage=true&dfdfid=b&needall=0")
				   
					iframe.attr("src","/proj/Templet/ProjTempletSeleTab.jsp?needPopupNewPage=true&dfdfid=a&needall=1");
				   }
				}); 
		  }
		  else if(itemname==='totop'){
			  jQuery(window).scrollTop(0);
		  }

	});
	
	
	jQuery(".letteritem a").click(function(){
		 
	      if(jQuery(this).hasClass("linkletteritem"))
		 {
	      jQuery(".letteritem a").parent().removeClass("selectedletter");
	      jQuery(".letteritem a").removeClass("acolor");
	      $(this).parent().addClass("selectedletter");
		  $(this).addClass("acolor");
	       
	      var  letterinfo=$(this).html();
		  var  letterdetail=$("#"+letterinfo).parent();

		  var  topheight=letterdetail.offset().top;

		  
		  //窗口高度
		  var windheight=$(window).height();	  
	     
		  //滚动条高度
		  var scrollheight=$(document).height()-windheight;

	      
		  if(topheight<scrollheight)
		  {
	          $(document).scrollTop(topheight-50);
		  }
		  else
		  {
		  $(document).scrollTop(scrollheight);
		  }

		 }
	 });
	
});


function onNewWindows(redirectUrl){
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
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

function openwins(suggestion,wfid)
{
}

function showPromt()
{
}


function  c(wfid,item)
{
	item.src="/images/ecology8/agentclick_wev8.png";

	var pitem=jQuery(item).parent();
	var offset=pitem.position();
	pitem.addClass("imgdiv");
	
	var pagent=pitem.parent().parent();
	var agent=pagent.find(".agentlistdata");
	agent.css("display","block");
	agent.css("left",(pagent.width()-pitem.parent().width())+offset.left+pitem.width()-agent.width());
	agent.css("top",(pitem.height()+offset.top+4));

	pagent.find(".importwf").css("display","none");
	
	var scrollTop=Math.max(document.documentElement.scrollTop,document.body.scrollTop);
	var window_height=jQuery(window).height();
	var top_min=pagent.offset().top;
	var importwf_height=pagent.find(".agentlistdata").height();
	if((top_min+importwf_height)>(scrollTop+window_height)){
		window.scrollTo(0,(top_min+importwf_height));
	}



    function  showOrHideForAgent(e){
  
         var containera = jQuery(item).parent().parent().parent();
		var containerb = pitem.parent();
		if ((!containera.is(e.target) 
			&& containera.has(e.target).length === 0)  &&  (!containerb.is(e.target) && containerb.has(e.target).length === 0)) // ... nor a descendant of the container
		{
			jQuery(".imageItem").css("display","none");
			jQuery(".imgdiv").removeClass("imgdiv");
			jQuery(".agentlistdata").css("display","none");
			jQuery(item).attr("src","/images/ecology8/agentwf_wev8.png");
			$(document).unbind("mousedown",showOrHideForAgent);
		}
	 
   }
    
     $(document).bind("mousedown",showOrHideForAgent);


}


function  generateLoading(item)
{

   var flowdiv=$("<div class='loadingarea' style='width:100px;height:100px;position:absolute;'><img  src='/images/ecology8/loading_wev8.gif'></div>");

   flowdiv.css("left",95);
   flowdiv.css("top",50);

   item.append(flowdiv);

}


function importWf(wfid,item)
{

}
function showAlert(title){
	jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
	jQuery("#warn").css("top",215+document.body.scrollTop);
	jQuery("#warn").find("label").html(title);
	jQuery("#warn").css("display","block");
	setTimeout(function (){
		jQuery("#warn").css("display","none");
	},1500);
}
//添加自定义
function addWorkflow(wfid,typeid,img,text){
}
//删除自定义
function removeWorkflow(wfid,typeid,img){
}
function onuserdefault(flag){
}

function onNewRequest(wfid,agent,beagenter){
}

function onNewWindow(redirectUrl){
	    var width = screen.availWidth-10 ;
	    var height = screen.availHeight-50 ;
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

jQuery(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	 	jQuery("#hoverBtnSpan").hoverBtn(); 		 	
});

function onBtnSearchClick(){
	var searchText=parent.jQuery("#searchInput").val();
	var searchLength=searchText.length;
	var innerSearchText=searchText.toLowerCase();
	var innerText="";
	var bindex="";
	var searchStr="";
	var innerHtml="";

	jQuery(".titlecontent label").each(function (){
		var text=jQuery(this).text();
		if(searchLength>0){
			innerText=text.toLowerCase();
			bindex=innerText.indexOf(innerSearchText);
			
			if(bindex!=-1){
				searchStr=text.substr(bindex,searchLength);
				innerHtml="<label class='search_view' style='background-color: #003667'><font color='#ffffff'>"+searchStr+"</font></label>";

				text=text.replace(searchStr,innerHtml);
			}
		}
		jQuery(this).html(text);
		
	});
	jQuery(".fontItem a").each(function (){
		var text=jQuery(this).text();
		if(searchLength>0){
			innerText=text.toLowerCase();
			bindex=innerText.indexOf(innerSearchText);
			
			if(bindex!=-1){
				searchStr=text.substr(bindex,searchLength);
				innerHtml="<label class='search_view' style='background-color: #003667'><font color='#ffffff'>"+searchStr+"</font></label>";

				text=text.replace(searchStr,innerHtml);
			}
		}
		jQuery(this).html(text);	
	});
	jQuery(".commian label").each(function (){
		var text=jQuery(this).text();
		if(searchLength>0){
			innerText=text.toLowerCase();
			bindex=innerText.indexOf(innerSearchText);
			
			if(bindex!=-1){
				searchStr=text.substr(bindex,searchLength);
				innerHtml="<label class='search_view' style='background-color: #003667'><font color='#ffffff'>"+searchStr+"</font></label>";

				text=text.replace(searchStr,innerHtml);
			}
		}
		jQuery(this).html(text);
	});
	
	var top_min=-1;
	//标签的绝对位置
	var top_real;
	//标签dom对象
	var label;
	//标签parent对象
	var label_Parent;
	jQuery(".search_view").each(function (){
		label=this;
		top_real=label.offsetTop;
		while(label.offsetParent!=null){
			label_Parent = label.offsetParent;
			top_real+=label_Parent.offsetTop ;
			label=label_Parent;
		}
		if(top_min==-1){
			top_min=top_real;
		}
		if(top_min>top_real){
			top_min=top_real;
		}
	})
	
	//滚动条滑动
	if(top_min!=-1){
		window.scrollTo(0,top_min);
	}
}

</script>


<script>
function onuserdefault(flag){
	if(flag==0)
		location='/proj/Templet/ProjTempletSele.jsp';
	else
		location='/proj/Templet/ProjTempletSele.jsp?fromadvancedmenu=1&infoId=-152';
}


function onNewPrj(prjtypeid,prjtmpid,isOnly,obj){
	var url="/proj/data/AddProject.jsp?templetId="+prjtmpid+"&projTypeId="+prjtypeid;
	if(isOnly){
		url+="&isOnly=Y";
	}
	var title="<%=SystemEnv.getHtmlLabelNames("15007",user.getLanguage())%>";
	openDialog(url,title,1000,700,false,true);
}
function onPreview(prjtmpid,obj){
	var url="/proj/Templet/ProjTempletView.jsp?templetId="+prjtmpid+"&preview=1&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("83980",user.getLanguage())%>";
	openDialog(url,title,1000,700);
}
</script>
</BODY>
</HTML>
