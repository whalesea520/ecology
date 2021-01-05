<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="surveyData.jsp" %>

<%
	//是否允许上传附件（是否显示附件上传图标）
	boolean uploadAttr = "on".equals(votingconfig.get("annex")) ? true : false;
%>
<html style='overflow:hidden;overflow-y: hidden !important;' scroll="no">
<head>
    <title></title>
    <link rel="stylesheet" href="../css/esurvey_wev8.css">
    <link rel="stylesheet" href="../css/popup_wev8.css">
	<link rel="stylesheet" href="../css/spectrum_wev8.css">
    <link type="text/css" rel="stylesheet" href="/kindeditor/skins/default_wev8.css">
	<link rel="stylesheet" type="text/css" href="/js/swfupload/default_wev8.css">
	<link rel="stylesheet" type="text/css" href="../css/surverydesign.css?version=291300"/>
</head>
<body style="overflow-y:hidden">
<div class="editor_nav">
    <div class="container">
	    <input type='hidden' name='votingid' value='<%=votingid%>' >
        <div class="title" data-intro="biaot" data-position="top">
            <%=SystemEnv.getHtmlLabelNames("15218,83723",user.getLanguage())%>
        </div>
        <div class="btns" data-intro="<%=SystemEnv.getHtmlLabelNames("221,15022,86",user.getLanguage())%>" data-position="top">
              <!--<a href="javascript:void(0);" class="bemax" onclick="parentDialog.maxOrRecoveryWindow();">max</a>
           <a href="javascript:void(0);" class="close" onclick="parentDialog.close();">关闭</a> -->
            <span title="<%=SystemEnv.getHtmlLabelNames("309",user.getLanguage())%>" class="close" onclick="parentDialog.close();"> </span>&nbsp;
        </div>
         <div class="nav" data-intro="<%=SystemEnv.getHtmlLabelNames("83724,83725",user.getLanguage())%>" data-position="left">
            <span class="current survey_opitem s_content" name="parts"><%=SystemEnv.getHtmlLabelNames("83724",user.getLanguage())%></span>
            <span class="survey_opitem s_view" class=""><%=SystemEnv.getHtmlLabelNames("83728",user.getLanguage())%></span>
        </div>
    </div>
</div>

<div class="survey_container">
    <div class="survey_menu">
        <!-- <div style="padding: 3px;background: #F4F4F4;padding-left: 12px;">
            <span>调查表结构</span>
            <span class="survey_inside"></span>
        </div> -->
         <div class="toolbar">
            <span class="gray up"  title="<%=SystemEnv.getHtmlLabelNames("15084",user.getLanguage())%>"><span class="menu menu_up"></span></span>
            <span class="gray down"  title="<%=SystemEnv.getHtmlLabelNames("15085",user.getLanguage())%>"><span class="menu menu_down"></span></span>
            <span class="gray cut"  title="<%=SystemEnv.getHtmlLabelNames("16179",user.getLanguage())%>"><span class="menu menu_cut"></span></span>
            <span class="gray copy"  title="<%=SystemEnv.getHtmlLabelNames("77",user.getLanguage())%>"><span class="menu menu_copy"></span></span>
            <span class="gray paste"  title="<%=SystemEnv.getHtmlLabelNames("16180",user.getLanguage())%>"><span class="menu menu_paste"></span></span>
            <span class="gray delete"  title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span class="menu menu_editor_del"></span></span>
        </div>
        <div class="survey_tree">
	        <ul class="surveytree" id="surveytree">
	
	        </ul>
	    </div>
    </div>

    <div class="survey_outsidecontainer">
        <div style='padding: 5px 3px;'><span class="survey_outside"></span></div>
    </div>

    <div class="survey_wrapper">
        <div class="survey_body">
            <div>

                <div class="survey_toobar">
                    <div style="margin: 0 auto;height: 35px;">

                        <ul class="editor_tool seditor">
                            <!-- <li class="addnewpage">新建页</li> -->
                            <li class="survery_question select"><%=SystemEnv.getHtmlLabelNames("83731",user.getLanguage())%></li>
                            <li class="survery_question matrix"><%=SystemEnv.getHtmlLabelNames("83735,83731",user.getLanguage())%></li>
                            <li class="survery_question introduce"><%=SystemEnv.getHtmlLabelNames("85",user.getLanguage())%></li>
							<li class="survery_question blankfilling"><%=SystemEnv.getHtmlLabelNames("84365",user.getLanguage())%></li>
                        </ul>

						   <ul class="editor_tool sview" style="display: none">
                            <li class="pagebgset survey_viewsetcurrent"><%=SystemEnv.getHtmlLabelNames("22967,22979",user.getLanguage())%></li>
                            <!--<li class="pagelogoset">logo</li>-->
                            <li class="pageset"><%=SystemEnv.getHtmlLabelNames("33832",user.getLanguage())%></li>
                            <li class="pagetitleset"><%=SystemEnv.getHtmlLabelNames("33832,229",user.getLanguage())%></li>
                            <li class="pagequestionset"><%=SystemEnv.getHtmlLabelNames("33832,83747",user.getLanguage())%></li>
                            <li class="pageoptionset"><%=SystemEnv.getHtmlLabelNames("83748",user.getLanguage())%></li>
                        </ul>
                        <div class="survey_viewset">
                             <input type="hidden" name="viewsetbgcolor">
                             <input type="hidden" name="viewsetftcolor">
                             <ul>
                                 <li class="survey_bgcolorset">
                                     <span><%=SystemEnv.getHtmlLabelNames("83749",user.getLanguage())%>&nbsp;:&nbsp;</span>
                                  </li>
                                 <li class="survey_bgcolorset">
                                     <span class="surveycolor survey_bgcolor" style="margin-top: 6px;margin-right: 8px;width: 10px;height: 10px;background: #ffffff;border: 1px solid #000000"></span>
                                 </li>
                                 <li class="survey_bgpicset">
                                     <span><%=SystemEnv.getHtmlLabelNames("33440",user.getLanguage())%></span>
                                 </li>
                                 <li  class="survey_bgpicset">
                                     <span class="bgimg-preview-inner"  style="margin-top: 6px;margin-right: 8px;width: 10px;height: 10px;border: 1px solid #000000"></span>
                                 </li>
                                 <li  class="survey_bgpicset">
                                     <span style="margin-top: 2px;"><input name="isrepeat" type="checkbox"></span>
                                 </li>
                                 <li  class="survey_bgpicset" style="margin-left: -5px;">
                                     <span><%=SystemEnv.getHtmlLabelNames("19852",user.getLanguage())%></span>
                                 </li>
                                 <li  class="survey_pagewidthset">
                                     <span><%=SystemEnv.getHtmlLabelNames("33818",user.getLanguage())%>&nbsp;:&nbsp;</span>
                                 </li>

                                 <li  class="survey_pagewidthset">
                                     <span><input name="pagewidth" type="text" size="3" style="height: 12px;"></span>
                                 </li>
								 
								  <li  class="survey_bgset">
                                     <span><%=SystemEnv.getHtmlLabelNames("22432,33819",user.getLanguage())%>&nbsp;:&nbsp;</span>
                                 </li>
                                 <li  class="survey_bgset">
                                     <span><input name="bgpictopheight" type="text" size="3" style="height: 12px;"></span>
                                 </li>

                                 <li  class="survey_bgset">
                                     <span><%=SystemEnv.getHtmlLabelNames("22433,33819",user.getLanguage())%>&nbsp;:&nbsp;</span>
                                 </li>
                                 <li  class="survey_bgset">
                                     <span><input name="bgpicbottomheight" type="text" size="3" style="height: 12px;"></span>
                                 </li>

                                 <li  class="survey_fontset">
                                     <span>
                                         <select name="surveyfamily" data-prop="font-family">
                                             <option value="">- <%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%> -</option>
                                             <option value="SimSun"><%=SystemEnv.getHtmlLabelName(16190,user.getLanguage())%></option>
                                             <option value="SimHei"><%=SystemEnv.getHtmlLabelName(16192,user.getLanguage())%></option>
                                             <option value="KaiTi"><%=SystemEnv.getHtmlLabelName(16195,user.getLanguage())%></option>
                                             <option value="LiSu"><%=SystemEnv.getHtmlLabelName(16193,user.getLanguage())%></option>
                                             <option value="Arial">Arial</option>
                                             <option value="Comic Sans MS">Comic Sans MS</option>
                                             <option value="Georgia">Georgia</option>
                                             <option value="Lucida Sans Unicode">Lucida Sans Unicode</option>
                                             <option value="Tahoma">Tahoma</option>
                                             <option value="Times New Roman">Times New Roman</option>
                                             <option value="Verdana">Verdana</option>
                                        </select>
                                      </span>
                                 </li>

                                 <li class="survey_fontset">
                                     <span><%=SystemEnv.getHtmlLabelNames("16189,2036",user.getLanguage())%>&nbsp;:&nbsp;</span>
                                 </li>

                                 <li class="survey_fontset">
                                      <span>
                                          <select name="surveyfontsize" data-prop="font-size">
                                              <option value="">- <%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%> -</option>
                                              <option value="10px">10px</option>
                                              <option value="12px">12px</option>
                                              <option value="14px">14px</option>
                                              <option value="18px">18px</option>
                                              <option value="24px">24px</option>
                                              <option value="28px">28px</option>
                                              <option value="32px">32px</option>
                                          </select>
                                      </span>
                                 </li>

                                 <li class="survey_fontcolorset">
                                     <span><%=SystemEnv.getHtmlLabelName(2076,user.getLanguage())%>&nbsp;:&nbsp;</span>
                                 </li>
                                 <li class="survey_fontcolorset">
                                     <span class="surveycolor survey_ftcolor" style="margin-top: 6px;margin-right: 8px;width: 10px;height: 10px;background: #ffffff;border: 1px solid #000000"></span>
                                 </li>

                                  <li class="survey_fontstyleset">
                                      <span><button type="button" name="font-weight" data-value="bold" data-role="switch" class="gray"><span style="padding: 0px;" class="i i_bold"></span></button></span>
                                  </li>

                                  <li class="survey_fontstyleset">
                                      <span>
                                          <button type="button" name="font-style" data-value="italic" data-role="switch" class="gray"><span style="padding: 0px;" class="i i_italic"></span></button>
                                      </span>
                                  </li>

                                  <li class="survey_alignset">
                                      <span>
                                          <button type="button" data-prop="text-align" data-value="left" data-role="switch" class="gray"><span style="padding: 0px;" class="i i_align_left"></span></button>
                                      </span>
                                  </li>
                                 <li class="survey_alignset">
                                      <span>
                                          <button type="button" data-prop="text-align" data-value="center" data-role="switch" class="gray"><span style="padding: 0px;" class="i i_align_center"></span></button>
                                      </span>
                                 </li>
                                 <li class="survey_alignset">
                                     <span>
                                         <button type="button" data-prop="text-align" data-value="right" data-role="switch" class="gray"><span style="padding: 0px;" class="i i_align_right"></span></button>
                                     </span>
                                 </li>

                             </ul>

                    </div>
                    <div style="float:right">
                        <!-- <button type="button" class="blue preview" onclick="return false;">预览</button>
                         &nbsp;&nbsp;
                         <button type="button" class="blue surveysave">保存</button>
                         &nbsp; -->
                         <span title="<%=SystemEnv.getHtmlLabelName(83868,user.getLanguage())%>" class="btoobar addnewpage"> </span>
                         &nbsp;
                         <span title="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" class="btoobar preview"> </span>
                         &nbsp;
                         <span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="btoobar surveysave"> </span>
                         &nbsp;&nbsp;
                         
                    </div>
                </div>

                <div class="survey_content">
                    <div class="survey_editor">
					    <!--<div class="survey-logo"></div> -->
                        <!--调查页面部分-->
                        <div class="survey_page">


                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>
</div>


<!--调查标题(默认面板)-->
<div class="survery_component survery_head survey_template_header " style="display: none;">
    <h1 class="survey-title">[<%=SystemEnv.getHtmlLabelNames("82,33832",user.getLanguage())%>]</h1>
    <div class="survey-intro"></div>
    <div class="survey_buttons" style="display: none">
        <a href="javascript:void(0);" onclick="return false;" class="edit" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"><span
                class="i i_editor_edit"></span></a>
    </div>
</div>

<!--调查标题设置(默认面板)-->
<div class="part_set survey_template_headerset" survey-type="header" style="text-align:center;display: none;">
    <div class="setting">
            <span>
                <label>
                    <%=SystemEnv.getHtmlLabelNames("26398",user.getLanguage())%></label>
            </span>
            <span class="button"> 
                <!-- <a href="javascript:void(0);" onclick="return false;" class="cancel"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></a>
                    <button type="button" class="confirm blue"><%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%></button>
                    <button type="button" class="cancel blue"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></button> -->
                     <span title="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="cancel"> </span>&nbsp;
                     <span title="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" class="confirm"> </span>
            </span>
    </div>
    <div class="content">
        <input type="text" name="title" class="subject" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,33832,229",user.getLanguage())%>" style="text-align:center;"
               maxlength="512">

        <div data-role="container" data-name="intro" style="display:none;">
            <textarea data-prop="intro"></textarea>
        </div>
    </div>
</div>

<!--<%=SystemEnv.getHtmlLabelNames("28626",user.getLanguage())%>题目(默认面板)-->
<div class="survery_component survey_template_select"
     style="opacity: 1; display: none;"><h4 class="title"><span class="index"></span><span
        class="subject"><%=SystemEnv.getHtmlLabelName(24379,user.getLanguage())%></span><span class="require" style="display: inline;">*</span><label class="rules">(<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>,
    <%=SystemEnv.getHtmlLabelName(28626,user.getLanguage())%>)</label></h4>

    <div class="intro"></div>
    <ul class="options">
        <li class="odd"><input type="radio" notBeauty="true" name="24c28f70-f76a-4411-b8f9-d5629000bab3[]"><label><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></label></li>
        <li class="even"><input type="radio" notBeauty="true" name="24c28f70-f76a-4411-b8f9-d5629000bab3[]"><label><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></label></li>
        <li class="odd"><input type="radio" notBeauty="true" name="24c28f70-f76a-4411-b8f9-d5629000bab3[]"><label><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></label></li>
    </ul>
    <div class="survey_buttons" style="display: none">
        <a href="javascript:void(0);" onclick="return false;" class="edit" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"><span
                class="i i_editor_edit"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="up" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>"><span class="i i_up"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="down" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>"><span class="i i_down"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="copy" title="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"><span class="i i_copy"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="paste" title="<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>"><span
                class="i i_paste"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"><span
                class="i i_editor_del"></span></a>
    </div>
</div>

<%--选择题 --%>
<!--<%=SystemEnv.getHtmlLabelNames("28626",user.getLanguage())%>设置(默认面板)-->
<div class="part_set  survey_template_selectset" survey-type="select" style="display: none">
	<div class="fieldset flash process"   style='position: absolute;left: 10px;top: 10px;width:300px;opacity: 1;z-index:100;'></div>
    <div class="setting">
        <div style='width:100%;'>
                <span class="survey_type">
                    <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
                    <label><input type="radio" name="type" data-prop="type" notBeauty="true" value="0" checked="checked" onclick="changeType(this)">
                        <%=SystemEnv.getHtmlLabelName(28626,user.getLanguage())%></label>
                    <label><input type="radio" name="type" data-prop="type" notBeauty="true" value="1" onclick="changeType(this)">
                        <%=SystemEnv.getHtmlLabelName(28627,user.getLanguage())%></label>
                    <label><input type="radio" name="type" data-prop="type" notBeauty="true" value="2" onclick="changeType(this)">
                        <%=SystemEnv.getHtmlLabelNames("83955,82753",user.getLanguage())%></label>
                </span>
                <span class="required">
                    <label><input type="checkbox" name='isrequest' notBeauty="true">
                        <%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></label>
                </span>
				<span class="isother">
                    <label><input type="checkbox" name='isother'  notBeauty="true">
                        <%=SystemEnv.getHtmlLabelName(23333,user.getLanguage())%></label>
                </span>
                <span class="button">
                     <!-- <a href="javascript:void(0);" onclick="return false;" class="cancel"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></a>
                    <button type="button" class="confirm blue"><%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%></button>
                    <button type="button" class="cancel blue"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></button> -->
                     <span title="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="cancel"> </span>&nbsp;
                     <span title="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" class="confirm"> </span>
                </span>
        </div>
        <div class="row">
            <%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>:
                <span class="container limited" style="display: none;">
                    <label> <%=SystemEnv.getHtmlLabelNames("83956",user.getLanguage())%> <input type="number" min="0" name='limit' class="limit">
                        <%=SystemEnv.getHtmlLabelNames("83957",user.getLanguage())%></label>
                    <label><%=SystemEnv.getHtmlLabelNames("83958",user.getLanguage())%> <input type="number" min="0" name='max' class="limit">
                        <%=SystemEnv.getHtmlLabelNames("83957",user.getLanguage())%></label>
                </span>
                <span class="container percolumns" style="display: inline;">
                    <label><%=SystemEnv.getHtmlLabelNames("82118,31835",user.getLanguage())%> <select name='column' data-prop="column">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                    </select><%=SystemEnv.getHtmlLabelNames("83959",user.getLanguage())%> </label>
                </span>
            <label style='display:none;'><input notBeauty="true" type="checkbox" name="shuffle" data-prop="shuffle">
                <%=SystemEnv.getHtmlLabelNames("1025,83960,338",user.getLanguage())%></label>
                <span data-role="container" data-name="fix_last" style="display:none;">
                    <label><input type="checkbox" data-prop="fix_last">
                        <%=SystemEnv.getHtmlLabelName(83961,user.getLanguage())%></label>
                </span>
            <label>
            	<span>图片宽度</span>
            	<input type="text" name="imageWidth" value="100" class="imageWidth"/>px&nbsp;&nbsp;
            	<span>图片高度</span>
            	<input type="text" name="imageHeight" value="80" class="imageHeight"/>px&nbsp;&nbsp;
            </label> 
        </div>
    </div>
    <div class="content">
        <input type="hidden" name="qid" value=""/>
        <input type="text" class="subject" name='subject' data-prop="subject" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,24419,229",user.getLanguage())%>" maxlength="512">

        <div data-role="container" data-name="intro" style="display:none;">
            <textarea data-prop="intro"></textarea>
        </div>
        <div class="options">
            <button type="button" name="batch" class="gray"><%=SystemEnv.getHtmlLabelNames("20839,456,1025",user.getLanguage())%></button>
            <ul class="list ui-sortable">
                <!--<li class="option">
                    <span class="i i_handle"></span>
                    <input type="text" name="label" class="input" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
                    <a href="javascript:void(0);" onclick="return false;" class="create" title="<%=SystemEnv.getHtmlLabelNames("83443",user.getLanguage())%>"><span
                            class="i i_create"></span></a>
                    <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span
                            class="i i_del"></span></a>
                    
                </li>
                <li class="option">
                    <span class="i i_handle"></span>
                    <input type="text" name="label" class="input" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
                    <a href="javascript:void(0);" onclick="return false;" class="create" title="<%=SystemEnv.getHtmlLabelNames("83443",user.getLanguage())%>"><span
                            class="i i_create"></span></a>
                    <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span
                            class="i i_del"></span></a>
                </li>
                <li class="option">
                    <span class="i i_handle"></span>
                    <input type="text" name="label" class="input" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
                    <a href="javascript:void(0);" onclick="return false;" class="create" title="<%=SystemEnv.getHtmlLabelNames("83443",user.getLanguage())%>"><span
                            class="i i_create"></span></a>
                    <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span
                            class="i i_del"></span></a>
                </li> -->
           </ul>
        </div>
        <ul class="clone" style="display:none;">
            <li class="option">
				<div class="voting_question has_data">
					<input type="hidden" name="oid" value=""/>
					<input type="hidden" class="innerorder" name="oinner" value=""/>
					<span class="i i_handle"></span>
	                <input type="text" name="label" class="input" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
	                <a href="javascript:void(0)" class="image" title="图片">	
	                	<span class="i i_image">
	                		<span class="uploader"></span>
	                	</span>
	                </a>
	                <%if(uploadAttr){%>
	                <a href="javascript:void(0)" class="attr" title="附件">	
	                	<span class="i i_attr">
	                		<span class="uploader"></span>
	                	</span>
	                </a>
	                <%} %>
	                <a href="javascript:void(0)" onclick="return false;" class="remark" title="说明">	
	                	<span class="i i_remark"></span>
	                </a>
	                <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
	                <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
	                <div class='voting_operator'>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_up i'></span>
                		</a>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_down i'></span>
                		</a>
                	</div>
                </div>
                <div class="voting_image">
                	<div class='voting_operator'>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_up i'></span>
                		</a>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_down i'></span>
                		</a>
                	</div>
                </div>              
                <div class="voting_attr">
                	<div class='voting_operator'>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_up i'></span>
                		</a>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_down i'></span>
                		</a>
                	</div>
                </div>              
                <div class="voting_remark">
                	<div class='voting_operator'>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_up i'></span>
                		</a>
                		<a href="javascript:void(0);" onclick="return false;">
                			<span class='voting_down i'></span>
                		</a>
                	</div>
                </div>              
            </li>
        </ul>
    </div>
</div>

<!--组合题目(默认面板)-->
<div class="survery_component survey_template_matrix"  style="opacity: 1; display: none;">
    <h4 class="title">
         <span class="index"></span>
         <span class="subject"><%=SystemEnv.getHtmlLabelNames("82,24419",user.getLanguage())%></span>
         <span class="require" style="display: inline;">*</span><label class="rules">(<%=SystemEnv.getHtmlLabelNames("18019",user.getLanguage())%>, <%=SystemEnv.getHtmlLabelNames("28626",user.getLanguage())%>)</label>
    </h4>
    <div class="intro"></div>
    <table class="optionstable">
         <tbody>
                  <tr><th></th><th><%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%></th></tr>
                  <tr align="center" class="odd">
                          <td align="left"><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%></td>
                          <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[173b6e4f-fb47-4966-89b8-c348908a3a27][]"></td>
                          <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[173b6e4f-fb47-4966-89b8-c348908a3a27][]"></td>
                          <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[173b6e4f-fb47-4966-89b8-c348908a3a27][]"></td>
                          <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[173b6e4f-fb47-4966-89b8-c348908a3a27][]"></td>
                          <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[173b6e4f-fb47-4966-89b8-c348908a3a27][]"></td>
                   </tr>
                  <tr align="center" class="even">
                         <td align="left"><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[aaaf5060-dd87-4a6e-b915-487734d3a6ff][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[aaaf5060-dd87-4a6e-b915-487734d3a6ff][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[aaaf5060-dd87-4a6e-b915-487734d3a6ff][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[aaaf5060-dd87-4a6e-b915-487734d3a6ff][]"></td>
                         <td><input type="radio"  notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[aaaf5060-dd87-4a6e-b915-487734d3a6ff][]"></td>
                  </tr>
                  <tr align="center" class="odd">
                         <td align="left"><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[0c86f7b6-c16f-4539-abfd-149d027c36f7][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[0c86f7b6-c16f-4539-abfd-149d027c36f7][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[0c86f7b6-c16f-4539-abfd-149d027c36f7][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[0c86f7b6-c16f-4539-abfd-149d027c36f7][]"></td>
                         <td><input type="radio" notBeauty="true" name="3e893f57-d191-4d05-a2b5-2a628243c2a2[0c86f7b6-c16f-4539-abfd-149d027c36f7][]"></td>
                  </tr>
          </tbody>
    </table>
    <div class="survey_buttons" style="display: none">
        <a href="javascript:void(0);" onclick="return false;" class="edit" title="<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>"><span class="i i_editor_edit"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="up" title="<%=SystemEnv.getHtmlLabelNames("15084",user.getLanguage())%>"><span class="i i_up"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="down" title="<%=SystemEnv.getHtmlLabelNames("15085",user.getLanguage())%>"><span class="i i_down"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="copy" title="<%=SystemEnv.getHtmlLabelNames("77",user.getLanguage())%>"><span class="i i_copy"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="paste" title="<%=SystemEnv.getHtmlLabelNames("16180",user.getLanguage())%>"><span class="i i_paste"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span class="i i_editor_del"></span></a>
     </div>
</div>

<!--组合题目设置(默认面板)-->
<div class="part_set  survey_template_matrixset"  survey-type="matrix"  style="display: none">
    <div class="setting">
            <div>
	            <span class="survey_type">
	                <%=SystemEnv.getHtmlLabelNames("63",user.getLanguage())%>:
	                <label><input type="radio" notBeauty="true" data-prop="type" name="type" value="0" checked="checked">
	                    <%=SystemEnv.getHtmlLabelNames("28626",user.getLanguage())%></label>
	                <label><input type="radio" notBeauty="true" data-prop="type" name="type" value="1">
	                    <%=SystemEnv.getHtmlLabelNames("28627",user.getLanguage())%></label>
	            </span>
	            <span class="required">
	                <label><input type="checkbox" notBeauty="true" name='isrequest'>
	                    <%=SystemEnv.getHtmlLabelNames("18019",user.getLanguage())%></label>
	            </span>
	            <span class="button">
	                <!-- <a href="javascript:void(0);" onclick="return false;" class="cancel"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></a>
	                    <button type="button" class="confirm blue"><%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%></button>
	                    <button type="button" class="cancel blue"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></button> -->
	                     <span title="<%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%>" class="cancel"> </span>&nbsp;
	                     <span title="<%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%>" class="confirm"> </span>
	            </span>
            </div>
    </div>
    <div class="content">
    	<input type="hidden" name="qid" value=""/>
        <input type="text" name="subject" class="subject" placeholder="<%=SystemEnv.getHtmlLabelNames("83869",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("229",user.getLanguage())%>" maxlength="512">
        <div data-role="container" data-name="intro" style="display:none;">
            <textarea data-prop="intro"></textarea>
        </div>
        <table width="100%">
            <tbody><tr>
                <td valign="top" class="row_options" width="42%">
                    <%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("633",user.getLanguage())%>                       <button type="button" name="batch" class="gray"><%=SystemEnv.getHtmlLabelNames("20839,83476,24419",user.getLanguage())%></button>
                    <ul class="list ui-sortable" data-dir="row">
                    <!-- 
                    <li class="option" data-dir="row">
                        <span class="i i_handle"></span>
                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("229",user.getLanguage())%> maxlength="512">
                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
                    </li><li class="option" data-dir="row">
                        <span class="i i_handle"></span>
                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("229",user.getLanguage())%> maxlength="512">
                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
                    </li><li class="option" data-dir="row">
                        <span class="i i_handle"></span>
                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("229",user.getLanguage())%> maxlength="512">
                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
                    </li>
                    -->
                    </ul>
                </td>
                <td valign="top" class="col_options">
                    <%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("633",user.getLanguage())%>                       <button type="button" name="batch" class="gray"><%=SystemEnv.getHtmlLabelNames("20839,83476,1025",user.getLanguage())%></button>
                    <ul class="list ui-sortable" data-dir="col">
                    	<!--
	                    <li class="option" data-dir="col">
	                        <span class="i i_handle"></span>
	                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
	                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
	                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
	
	                    </li><li class="option" data-dir="col">
	                        <span class="i i_handle"></span>
	                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
	                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
	                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
	
	                    </li><li class="option" data-dir="col">
	                        <span class="i i_handle"></span>
	                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
	                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
	                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
	
	                    </li><li class="option" data-dir="col">
	                        <span class="i i_handle"></span>
	                        <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
	                        <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
	                        <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
	
	                    </li>
                    	-->
                    </ul>
                </td>
            </tr>
            </tbody></table>
        <ul class="clone" style="display:none;">
            <li class="option row" >
                <span class="i i_handle"></span>
                <input type="hidden" name="oid" value=""/>
                <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("229",user.getLanguage())%>" maxlength="512">
                <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
                <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
            </li>
            <li class="option col">
                <span class="i i_handle"></span>
                <input type="hidden" name="oid" value=""/>
                <input type="text" name="label" class="input_matrixsort" placeholder="<%=SystemEnv.getHtmlLabelNames("83869,1025,22360",user.getLanguage())%>" maxlength="512">
                <a href="javascript:void(0);" onclick="return false;" class="create"><span class="i i_create"></span></a>
                <a href="javascript:void(0);" onclick="return false;" class="remove"><span class="i i_del"></span></a>
            </li>
        </ul>
    </div>
</div>

<!--说明视图(默认面板)-->
<div class="survery_component survey_template_introduce"
        style="opacity: 1; display: none;">
    <div class="code" style="padding: 10px">
    </div>
    <div style="clear:both"></div>
   <div class="survey_buttons" style="display: none;">
        <a href="javascript:void(0);" onclick="return false;" class="edit" title="<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>"><span class="i i_editor_edit"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="up" title="<%=SystemEnv.getHtmlLabelNames("15084",user.getLanguage())%>"><span class="i i_up"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="down" title="<%=SystemEnv.getHtmlLabelNames("15085",user.getLanguage())%>"><span class="i i_down"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="copy" title="<%=SystemEnv.getHtmlLabelNames("77",user.getLanguage())%>"><span class="i i_copy"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="paste" title="<%=SystemEnv.getHtmlLabelNames("16180",user.getLanguage())%>"><span class="i i_paste"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span class="i i_editor_del"></span></a>
    </div>
	
 </div>
<!--说明视图(设置面板)-->
<div class="part_set survey_template_introduceset"
     style="opacity: 1; display: none;">
    <!--上传进度区域(非签章)-->
    <div class="fieldset flash process"   style='position: absolute;left: 10px;top: 10px;width:300px;opacity: 1;z-index:100;'></div>
    <div class="setting">
            <span class="button">
               <!-- <a href="javascript:void(0);" onclick="return false;" class="cancel"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></a>
                    <button type="button" class="confirm blue"><%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%></button>
                    <button type="button" class="cancel blue"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></button> -->
                     <span title="<%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%>" class="cancel"> </span>&nbsp;
                     <span title="<%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%>" class="confirm"> </span>
            </span>
    </div>
    <div class="content" style="padding: 0px;margin-bottom: 0px;">
    	<input type="hidden" name="qid" value=""/>
    	<input type="hidden" name="oid" value=""/>
        <textarea  name='contentdata'  ></textarea>
    </div>
	<div style='overflow:hidden;'>
	      <div class="optItem doc">
				  <div class="title" style="background: url('/voting/surveydesign/images/app-doc_wev8.png') no-repeat left center;" onclick="openApp(this,'doc')">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelNames("30041",user.getLanguage())%></a>
				  </div>
	      </div>
		  <div class="optItem flow">
				  <div class="title" style="background: url('/voting/surveydesign/images/app-wl_wev8.png') no-repeat left center;" onclick="openApp(this,'workflow')">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelNames("33569",user.getLanguage())%></a>
				  </div>
		  </div>
		  <div class="optItem customer">
				  <div class="title" style="background: url('/voting/surveydesign/images/app-crm_wev8.png') no-repeat left center;" onclick="openApp(this,'crm')">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelNames("21313",user.getLanguage())%></a>
				  </div>
	      </div>
		  <div class="optItem  project">
				  <div class="title" style="background: url('/voting/surveydesign/images/app-project_wev8.png') no-repeat left center;" onclick="openApp(this,'project')">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelNames("30046",user.getLanguage())%></a>
				  </div>
	      </div>
		  <div class='annex' style='float:left;padding-top:4px;'>
		      <span style='display:inline-block;with:16x;height:16px;'><img src='/voting/surveydesign/images/app-attach_wev8.png'/></span>
		  </div>
		  <div class="optItem annex" >
		   <a href='javascript:void(0)' style='font-size:12px;'><span class='holder' style='cursor: pointer;'></span></a>
          </div>
	</div>
</div>

<!--填空视图(默认面板)-->
<div class="survery_component survey_template_blankfilling"
     style="opacity: 1; display: none;">
           <h4 class="title"><span class="index"></span><span
            class="subject"><%=SystemEnv.getHtmlLabelNames("82,24419",user.getLanguage())%></span><span class="require" style="display: inline;">*</span><label class="rules">(<%=SystemEnv.getHtmlLabelNames("18019",user.getLanguage())%>,<%=SystemEnv.getHtmlLabelNames("83741",user.getLanguage())%>)</label></h4>
    <div class="fillcdata" style="padding: 10px">
        <textarea  style="width: 100%;height: 50px;" readonly>
        </textarea>
    </div>
    <div style="clear:both"></div>
    <div class="survey_buttons" style="display: none;">
        <a href="javascript:void(0);" onclick="return false;" class="edit" title="<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>"><span class="i i_editor_edit"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="up" title="<%=SystemEnv.getHtmlLabelNames("15084",user.getLanguage())%>"><span class="i i_up"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="down" title="<%=SystemEnv.getHtmlLabelNames("15085",user.getLanguage())%>"><span class="i i_down"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="copy" title="<%=SystemEnv.getHtmlLabelNames("77",user.getLanguage())%>"><span class="i i_copy"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="paste" title="<%=SystemEnv.getHtmlLabelNames("16180",user.getLanguage())%>"><span class="i i_paste"></span></a>
        <a href="javascript:void(0);" onclick="return false;" class="remove" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>"><span class="i i_editor_del"></span></a>
    </div>
</div>
<!--填空视图(设置面板)-->
<div class="part_set survey_template_blankfillingset"
     style="opacity: 1; display: none;">
    <div class="setting">
           <span class="required">
                    <label><input type="checkbox" notBeauty="true" name='isrequest' >
                        <%=SystemEnv.getHtmlLabelNames("18019",user.getLanguage())%></label>
           </span>
           <span class="button">
		             <span title="<%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%>" class="cancel"> </span>&nbsp;
                     <span title="<%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%>" class="confirm"> </span>
            </span>
    </div>
    <div class="content" style="padding: 0px">
    	<input type="hidden" name="qid" value=""/>
    	<input type="hidden" name="oid" value=""/>
        <input type="text" class="subject" name='subject' data-prop="subject" placeholder="<%=SystemEnv.getHtmlLabelNames("83869",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("24419",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("229",user.getLanguage())%>" maxlength="512">
    </div>
</div>


<!--弹出框-->
<div id="popup" style="left: 433px;width: 410px;min-width:410px;height: 340px; position: absolute; top: 433.5px; z-index: 9999; opacity: 0; display: none;">
    <span class="button b-close"><span class="close" style="padding-top: 5px;padding-left:0px;"></span></span>
          <input type="hidden" name="qusuuid">
          <input type="hidden" name="roworcolumn">
          <p class="head"><%=SystemEnv.getHtmlLabelNames("20839,456,1025",user.getLanguage())%></p>
          <p><%=SystemEnv.getHtmlLabelNames("83962",user.getLanguage())%></p>
          <textarea name="options" style="margin: 0px 0px 0px 10px; height: 242px; width: 384px;"></textarea>
          <div style="text-align: center">
           <!-- <a href="javascript:void(0);" onclick="return false;" class="cancel"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></a>
           <span title="<%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%>" class="cancel"> </span>&nbsp;
                     <span title="<%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%>" class="confirm"> </span>-->
                    <button type="button" class="confirm blue"><%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%></button>
                    <button type="button" class="cancel blue"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></button> 
                     
          </div>
 </div>

<!--图片弹出框-->
<div id="imgpopup" style="left: 433px;width: 600px;min-width:410px;height: 505px; position: absolute; top: 433.5px; z-index: 9999; opacity: 0; display: none;">
    <span class="button b-close"><span class="close" style="padding-top: 5px;padding-left:0px;"></span></span>
    <input type="hidden" name="qusuuid">
    <input type="hidden" name="roworcolumn">
    <p class="head"><%=SystemEnv.getHtmlLabelNames("83476,19074",user.getLanguage())%></p>
    <p><%=SystemEnv.getHtmlLabelNames("18890,1426",user.getLanguage())%><button type="button" class="clearbgimg blue" style='width: 100px;margin-left: 430px;'><%=SystemEnv.getHtmlLabelNames("311,19074",user.getLanguage())%></button></p>
       <div class="imgcontainer" style="height: 400px;width: 575px;margin: auto">
         <ul>

         </ul>
    </div>
   <div style="text-align: center;padding-top: 10px;">
        <button type="button" class="confirm blue"><%=SystemEnv.getHtmlLabelNames("826",user.getLanguage())%></button>
        <button type="button"  onclick="return false;" class="cancel blue"><%=SystemEnv.getHtmlLabelNames("31129",user.getLanguage())%></button>
    </div>
</div>

<div id='divStatus' style='display:none;'>

</div>



<script>
    var languageid=7;
</script>
<script src="../js/jquery_wev8.js"></script>
<script src="../js/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/voting/surveydesign/kindeditor/kindeditor_wev8.js"></script>
<script type="text/javascript" src="/voting/surveydesign/kindeditor/kindeditor-Lang_wev8.js"></script>
<script src="../js/jquery.bpopup.min_wev8.js"></script>
<script src="../js/spectrum_wev8.js"></script>
<script src="../js/uuid_wev8.js"></script>

<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<script src="../js/surveyutil_wev8.js"></script>
<script src="../js/surveymodel_wev8.js?version=1.0"></script>
<script src="../js/surveydsigner_wev8.js"></script>


<script>
    
    var pageitems=<%=pageitems%>;
	var viewset=<%=viewset%>;
	var surveysubject="<%=surveysubject%>";
	var votingconfig=<%=votingconfigstr%>;
	if((1 in pageitems) || viewset!=''){
	  surveydsigner.initDesigner(1,pageitems,viewset);
	  var _qusid = jQuery("div.part_set[survey-type='select']:visible").attr("qussetid");
	  if(_qusid){
	  	surveydsigner.getCurrentPage().getQuestionByKey(_qusid).addUpload();	
	  }
	}else{
	  surveydsigner.initDesigner(0);
	}

   //打开应用程序
   function openApp(obj,type){
	   var editorId="kid"+jQuery(obj).parents(".part_set").attr("qussetid");
	   var votingid=$("input[name='votingid']").val();
	   onShowApp(type,editorId);
	}
  //打开<%=SystemEnv.getHtmlLabelNames("1025",user.getLanguage())%>  
   function onShowApp(type,editorId){
	   var id1;
	   var dlg=new window.top.Dialog();//定义Dialog对象
       dlg.Model=true;
       dlg.Width=800;//定义长度
       dlg.Height=560;
       
	   if(type=='doc'){
	        dlg.URL="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids=";
            dlg.Title="<%=SystemEnv.getHtmlLabelNames("857",user.getLanguage())%>";
			dlg.callbackfun=function(params,data){
				if(data){
					if(data.id){
						var ids = data.id.split(",");
						var names = data.name.split(",");
						var sHtml = "";
						for(var i=0;i<ids.length;i++){
							var id = ids[i];
							var name = names[i];
							sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+id+" linkType='doc' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+name+"</a>&nbsp;";
						}
						KE.insertHtml(editorId,sHtml); 
					}
				}
		   }
           dlg.show();
		 
	   }else if(type=='project'){
	       dlg.URL="/systeminfo/BrowserMain.jsp?mouldID=proj&url=/proj/data/MultiProjectBrowser.jsp?projectids=";
           dlg.Title="<%=SystemEnv.getHtmlLabelNames("782",user.getLanguage())%>";
		   dlg.callbackfun=function(params,data){
				if(data){
					if(data.id){
						var ids = data.id.split(",");
						var names = data.name.split(",");
						var sHtml = "";
						for(var i=0;i<ids.length;i++){
							var id = ids[i];
							var name = names[i];
							sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+id+" linkType='project' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+name+"</a>&nbsp;";
						}
						KE.insertHtml(editorId,sHtml);  
					}
				}
		   }
           dlg.show();
	   }   
	   else if(type=='task')   
	      id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids=",null,"dialogWidth=600px;dialogHeight=580px");
	   else if(type=='crm'){
	      //id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=",null,"dialogWidth=600px;dialogHeight=580px");
	       dlg.URL="/systeminfo/BrowserMain.jsp?mouldID=crm&url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=";
           dlg.Title="<%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%>";
		   dlg.callbackfun=function(params,data){
				if(data){
					if(data.id){
						var ids = data.id.split(",");
						var names = data.name.split(",");
						var sHtml = "";
						for(var i=0;i<ids.length;i++){
							var id = ids[i];
							var name = names[i];
							sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+id+" linkType='crm' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+name+"</a>&nbsp;";
						}
						KE.insertHtml(editorId,sHtml);
					}
				}
		   }
           dlg.show();
	   }   
	   else if(type=='workflow') {
	      dlg.URL="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=";
          dlg.Title="<%=SystemEnv.getHtmlLabelNames("22105",user.getLanguage())%>";
	      dlg.callbackfun=function(params,data){
				if(data){
					if(data.id){
						var ids = data.id.split(",");
						var names = data.name.split(",");
						var sHtml = "";
						for(var i=0;i<ids.length;i++){
							var id = ids[i];
							var name = names[i];
							sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+id+" linkType='workflow' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+name+"</a>&nbsp;";
						}
						KE.insertHtml(editorId,sHtml);
					}
				}
		   }
           dlg.show();
	   }  
	   else if(type=="workplan")
		  id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workplan/data/WorkplanEventsBrowser.jsp",null,"dialogWidth=600px;dialogHeight=580px");    
    }

</script>

</body>
</html>
