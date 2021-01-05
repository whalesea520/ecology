
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.*,weaver.matrix.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<html><head>
    <title>matrix design</title>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
    <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<link rel="stylesheet" href="../css/matrixdesign_wev8.css">

</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33943,user.getLanguage());
//矩阵id
String matrixid=request.getParameter("matrixid");
String fieldinfojson=MatrixUtil.getMatrixJsonByIdForDesignList(matrixid);

//System.out.println(fieldinfojson);


//获取矩阵配置的 浏览框类型
Properties prop=new Properties();         
//out.println(GCONST.getPropertyPath()+ "Matrix.properties");
File matrixFile = new File(GCONST.getPropertyPath()+ "Matrix.properties");
InputStreamReader matrixInputStream =new InputStreamReader(new FileInputStream(matrixFile));
prop.load(matrixInputStream);   
String browsers = prop.get("browserlist")+"";
Map<String, Map<String,String>> browsermap = new LinkedHashMap<String, Map<String,String>>();
if(!"".equals(browsers)){
	String[] array = browsers.split(",");
	for(String str : array){
		Map map = new HashMap<String,String>();
		map.put(str,SystemEnv.getHtmlLabelName(Integer.valueOf(str),user.getLanguage()));
		browsermap.put(str,map);
	}
}

Map<String, String> m = null;
while(BrowserComInfo.next()){//名称无重复
	if(("224".equals(BrowserComInfo.getBrowserid()))||"225".equals(BrowserComInfo.getBrowserid())){
			continue;//老版本的sap浏览按钮不支持老表单
	}
	if (BrowserComInfo.notCanSelect()) continue;
    
	m = browsermap.get(BrowserComInfo.getBrowserlabelid());
	if(m!= null){
		m.put("name", SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage()));
		m.put("id", BrowserComInfo.getBrowserid());
		m.put("py", BrowserComInfo.getBrowserPY(user.getLanguage()));
	}
}

%>
<body>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 
 <%

	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:matrixdesign.saveItems(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

%>
 
 <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

   <table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="matrixdesign.saveItems()">					
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>  

  
      
       <div class="descr"> <span style="color:#ffbc00;font-weight:bold"><%=SystemEnv.getHtmlLabelName(83939,user.getLanguage())%></span> <%=SystemEnv.getHtmlLabelName(83940,user.getLanguage())%>  <span><%=SystemEnv.getHtmlLabelName(83941,user.getLanguage())%> </span><%=SystemEnv.getHtmlLabelName(83942,user.getLanguage())%> </div>
       <!--外围容器-->
        <div class="matrixcontainerwrapper" style="width: 100%;overflow: auto;">
            
            
            
            <input name='matrixid' type='hidden' value='<%=matrixid%>'/>
            
            <div class="matrixcontainer">
                <!--匹配条目-->
                <div class="matchitemcontainer">
        
                </div>
        
                <div class="matchaddcontainer">
        
                </div>
        
                <div class="selectitemcontainer">
        
                </div>
        
                <div class="selectaddcontainer">
        
                </div>
        
            </div>
        </div>
        
        <div class="matrixsysarea" >
            <fieldset>
                <legend><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%></legend>
                <div class="previewcontainer">
                    <ul class="previewlist">
        
                    </ul>
                </div>
            </fieldset>
        </div>
        
        <div class="matrixitem matchitem matchselect matchitemclone">
            <div class="letter" title="<%=SystemEnv.getHtmlLabelName(83943,user.getLanguage())%>">
                <div class="letterdraghandler">
        
                </div>
            </div>
            <div class="setting">
                <div class="field matchlegalfield">
                     <select notBeauty=true class="inputstyle"  size=1 >
						  <% for (Iterator it =  browsermap.keySet().iterator();it.hasNext();) {
							  Object key = it.next(); 
						  %>
							  <option match="<%=browsermap.get(key).get("py") %>" value="<%=browsermap.get(key).get("id")%>" ><%=browsermap.get(key).get("name")%></option>
						   <%}%>
	                </select>
                </div>
				<div class='field matchlegalfield' style='display:none;'>
				   <div class='custbrower'>
				   </div>
				</div>

				<div class='field matchlegalfield' style='display:none;'>
				   <div class='custmultibrower'>
				   </div>
				</div>

                <div class="field" >
                    <input name="labelname" title="<%=SystemEnv.getHtmlLabelName(83944,user.getLanguage())%>" placeholder="<%=SystemEnv.getHtmlLabelName(83944,user.getLanguage())%>">
                </div>
                <div class="field">
                    <input name="fieldname" title="<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>" placeholder="<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>">
                </div>
            </div>
        
            <!--删除-->
            <div class="itemdelete" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>">
                <div class="deleteblock">
                </div>
            </div>
        
        </div>
        
        <div class="matrixitem matchitem  addicon matchitemaddclone">
            <div class="letter" title="<%=SystemEnv.getHtmlLabelName(83943,user.getLanguage())%>">
                <div>
        
                </div>
            </div>
            <div class="addpng addmatch">
                <img src="../images/m-add_wev8.png">
            </div>
        
        </div>
        
        
        <div class="matrixitem selectitem addselect selectitemclone">
            <div class="letter" title="<%=SystemEnv.getHtmlLabelName(83943,user.getLanguage())%>">
                <div class="letterdraghandler">
        
                </div>
            </div>
            <div class="setting">
			    <div class="field matchlegalfield">
                    <select disabled='disabled' notBeauty=true class=inputstyle  size=1>
					    <option value='17'><%=SystemEnv.getHtmlLabelName(83496,user.getLanguage())%></option>
					</select>
                </div>
                <div class="field">
                    <input name="labelname" title="<%=SystemEnv.getHtmlLabelName(83944,user.getLanguage())%>" placeholder="<%=SystemEnv.getHtmlLabelName(83944,user.getLanguage())%>">
                </div>
                <div class="field">
                    <input name="fieldname" title="<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>" placeholder="<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>">
                </div>
            </div>
        
            <!--删除-->
            <div class="itemdelete" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>">
                <div class="deleteblock">
                </div>
            </div>
        
        </div>
        
        <div class="matrixitem selectitem addicon selectitemaddclone">
            <div class="letter">
                <div>
        
                </div>
            </div>
            <div class="addpng addselect">
                <img src="../images/add_wev8.png">
            </div>
        </div>
         
        
        <script src="../js/jquery_wev8.js"></script>
        <script src="../js/jquery-ui_wev8.js"></script>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
		
		<script type='text/javascript' src="/js/nicescroll/jquery.nicescroll.min_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css">
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
        <script language=javascript src="../js/jquery.selectbox-0.2_wev8.js"></script>
        <script src="../js/uuid_wev8.js"></script>
        <script src="../js/matrixdesign_wev8.js"></script>
        
         

        <script>
                 
                 
                 $(document).ready(function(){
				     var fieldinfojson=<%=fieldinfojson%>;
	                 if(fieldinfojson.length===0){
	                   //初始化设计器
	                   matrixdesign.initDesign();
	                 }else{
	                   matrixdesign.recoverDesigner(fieldinfojson);
	                   matrixdesign.registerEvent();  
	                 }
				});
        </script>


    </body>
</html>
