/**
  作用：    时间控件的统一管理
  创建者：  brant
  时间：    2008.3.28
**/
var $J = jQuery ? jQuery : $;
var languageStr = 'zh-cn';
$J(document).ready(function () {
	$J(".wuiDateSpan").each(function(){
		var x = "";
		var select = "";
		var selectId=$J(this).attr("selectId")||"spansel_"+Math.round((Math.random()*100000000));
		var selectValue=$J(this).attr("selectValue");
		var defaultValue=$J(this).attr("_defaultValue")||"";
		var needAllOption = $J(this).attr("_needAllOption");
		if(selectId){
			select = "<span><select id='"+selectId+"' _defaultValue='"+defaultValue+"' name='"+selectId+"' onchange=\"changeDateForSelect(this,'"+selectId+"_span')\">";
			if(needAllOption!==false&&needAllOption!=="false"){
				select+="<option value='0'>"+SystemEnv.getHtmlNoteName(3407,readCookie("languageidweaver"))+"</option>";
			}
			select+="<option value='1' "+(selectValue==1?"selected":"")+">"+SystemEnv.getHtmlNoteName(3408,readCookie("languageidweaver"))+"</option>";
			select+="<option value='2'"+(selectValue==2?"selected":"")+">"+SystemEnv.getHtmlNoteName(3409,readCookie("languageidweaver"))+"</option>";
			select+="<option value='3'"+(selectValue==3?"selected":"")+">"+SystemEnv.getHtmlNoteName(3410,readCookie("languageidweaver"))+"</option>";
			select+="<option value='7'"+(selectValue==7?"selected":"")+">"+SystemEnv.getHtmlNoteName(3411,readCookie("languageidweaver"))+"</option>";
			select+="<option value='4'"+(selectValue==4?"selected":"")+">"+SystemEnv.getHtmlNoteName(3412,readCookie("languageidweaver"))+"</option>";
			select+="<option value='5'"+(selectValue==5?"selected":"")+">"+SystemEnv.getHtmlNoteName(3413,readCookie("languageidweaver"))+"</option>";
			select+="<option value='8'"+(selectValue==8?"selected":"")+">"+SystemEnv.getHtmlNoteName(3414,readCookie("languageidweaver"))+"</option>";
			select+="<option value='6'"+(selectValue==6?"selected":"")+">"+SystemEnv.getHtmlNoteName(3415,readCookie("languageidweaver"))+"</option>";
			select+="</select></span>&nbsp;&nbsp;";
			x=select+"<span  class='e8selectspan' id='"+selectId+"_span' style='display:"+(selectValue==6?"":"none")+"'>";
		}
		
		_beautyDate(this,x,selectId);	
		if(selectValue && selectValue!="0" && selectValue!="6"){
			jQuery("#"+selectId).trigger("change");
		}
		if(!selectValue){
			var hiddenarea = jQuery(this).children("input[type='hidden']");
			var startDate = hiddenarea.eq(0).val();
			var endDate = hiddenarea.eq(1).val();
			if(startDate==getTodayDate()&&endDate == getTodayDate()){
				jQuery("#"+selectId).val("1");
			}else if(startDate==getWeekStartDate()&&endDate == getWeekEndDate()){
				jQuery("#"+selectId).val("2");
			}else if(startDate==getMonthStartDate()&&endDate == getMonthEndDate()){
				jQuery("#"+selectId).val("3");
			}else if(startDate==getLastMonthStartDate()&&endDate == getLastMonthEndDate()){
				jQuery("#"+selectId).val("7");
			}else if(startDate==getQuarterStartDate()&&endDate == getQuarterEndDate()){
				jQuery("#"+selectId).val("4");
			}else if(startDate==getYearStartDate()&&endDate == getYearEndDate()){
				jQuery("#"+selectId).val("5");
			}else if(startDate==getLastYearStartDate()&&endDate == getLastYearEndDate()){
				jQuery("#"+selectId).val("8");
			}else if(!startDate&&!endDate){
				jQuery("#"+selectId).val("0");
			}else{
				jQuery("#"+selectId).val("6");
				jQuery("#"+selectId+"_span").show();
			}
		}else if(selectValue=="6"){
			jQuery("#"+selectId+"_span").show();
		}
		beautySelect("#"+selectId);
	});
	_beautyDate(null,"","");	
	
});

function _beautyDate(obj,x,selectId){
	var wuiDate = null;
	if(obj){
		wuiDate = $J(obj).find(".wuiDateSel");
	}else{
		wuiDate = $J(".wuiDate");
	}
	wuiDate.each(function(idx,obj1){
		if($J(this).next("button").length>0)return;
		var z = $J(this), n = z.attr("name"), t = z.attr("type"),v = z.val(), b = z.attr("_button"), s = z.attr("_span"), f = z.attr("_callback"), r = z.attr("_isrequired");
		n = (n == undefined || n == null || n == "") ? new Date().getTime() + "_input" : n;
		b = (b == undefined || b == null || b == "") ? n + "ReleBtn_Autogrt" : b;
		s = (s == undefined || s == null || s == "") ? n + "ReleSpan_Autogrt" : s;
		var index = -1;
		if(n.indexOf("_")!=-1){			
			index =  n.substring(n.indexOf("_")+1,n.length);
		}
		if (t != "hidden") {
			z.css("display", "none");	
			z.attr("name", n + "_back");
		}
		if(index!=-1){
			s = s+"_"+index;
		}
		if (t != "hidden") {
			z.css("display", "none");	
			z.attr("name", n + "_back");
		}
		x+="<button class=\"calendar\" type=\"button\" name=" + b + "\" id=" + b + "\" onclick=\"_gdt('" + n + "', '" + s + "', '" + f + "','"+r+"');\"></button>";
		x += "<span id=\"" + s + "\" name=\"" + s + "\">" + v + "</span>";
		if (r != undefined && r != null && r == "yes") {
			x += "<span id=\"" + s + "img" + "\" name=\"" + s + "img" + "\">";
			if (v == undefined || v == null || v == "") {
				x += "<img align=\"absMiddle\" src=\"/images/BacoError	_wev8.gif\"/>";
			}
			x += "</span>";
			
			//z.bind("propertychange", function () {
			//	checkinput(n, s + "img");
			//});
		}
		if(selectId && idx==wuiDate.length-1){
			x+="</span>";
		}
		if(!obj){
			z.after(x);
			x="";
		}else if(idx!=wuiDate.length-1){
			x+="-&nbsp;&nbsp;"
		}
	});
	if(obj){
		$J(obj).append(x);
	}
	var language=readCookie("languageidweaver");
	if(language==8)
		languageStr ="en";
	else if(language==9)
		languageStr ="zh-tw";
	else
		languageStr ="zh-cn";
}

function changeDateForSelect(obj,id,val){
	//日期控件select自定义change事件，页面调用的地方可以直接覆盖使用
	try {
		__changeDateForSelect(obj,id,val);
	} catch (e) {}
	
	if(val==null)val='6';
	var wuiDateSpan = jQuery(obj).closest("span.wuiDateSpan");
	var e8selectspan = wuiDateSpan.children(".e8selectspan");
	var hiddenarea = wuiDateSpan.children("input[type='hidden']");
	var dateSpan = e8selectspan.children("span");
	if(obj.value==val){
		e8selectspan.show();
		hiddenarea.eq(0).val("");
		dateSpan.eq(0).html("");
		hiddenarea.eq(1).val("");
		dateSpan.eq(1).html("");
	}else{
		e8selectspan.hide();
		if(obj.value=="0"){
			hiddenarea.eq(0).val("");
			dateSpan.eq(0).html("");
			hiddenarea.eq(1).val("");
			dateSpan.eq(1).html("");
		}else if(obj.value=="1"){
				hiddenarea.eq(0).val(getTodayDate());
				dateSpan.eq(0).html(getTodayDate());
				hiddenarea.eq(1).val(getTodayDate());
				dateSpan.eq(1).html(getTodayDate());
		}else if(obj.value=="2"){
				hiddenarea.eq(0).val(getWeekStartDate());
				dateSpan.eq(0).html(getWeekStartDate());
				hiddenarea.eq(1).val(getWeekEndDate());
				dateSpan.eq(1).html(getWeekEndDate());
		}else if(obj.value=="3"){
				hiddenarea.eq(0).val(getMonthStartDate());
				dateSpan.eq(0).html(getMonthStartDate());
				hiddenarea.eq(1).val(getMonthEndDate());
				dateSpan.eq(1).html(getMonthEndDate());
		}else if(obj.value=="7"){//上个月
				hiddenarea.eq(0).val(getLastMonthStartDate());
				dateSpan.eq(0).html(getLastMonthStartDate());
				hiddenarea.eq(1).val(getLastMonthEndDate());
				dateSpan.eq(1).html(getLastMonthEndDate());
		}else if(obj.value=="4"){
				hiddenarea.eq(0).val(getQuarterStartDate());
				dateSpan.eq(0).html(getQuarterStartDate());
				hiddenarea.eq(1).val(getQuarterEndDate());
				dateSpan.eq(1).html(getQuarterEndDate());
		}else if(obj.value=="5"){
				hiddenarea.eq(0).val(getYearStartDate());
				dateSpan.eq(0).html(getYearStartDate());
				hiddenarea.eq(1).val(getYearEndDate());
				dateSpan.eq(1).html(getYearEndDate());
		}else if(obj.value=="8"){//上一年
				hiddenarea.eq(0).val(getLastYearStartDate());
				dateSpan.eq(0).html(getLastYearStartDate());
				hiddenarea.eq(1).val(getLastYearEndDate());
				dateSpan.eq(1).html(getLastYearEndDate());
		}
	}
}

function _gdt(_i, _s, _f,_r) {
	try {
		var returnValue = _gettheDate(_i, _s, _f,_r);
	} catch(e){} 
}

function _gettheDate(inputname,spanname, _f,_r){
	var evt = window.event;

	var _minDate = "";
	var _maxDate = "";
	try{
		_minDate = jQuery("#"+inputname).attr("_minDate");
		_maxDate = jQuery("#"+inputname).attr("_maxDate");
		if(_minDate==null){
			_minDate = "";
		}
		if(_maxDate==null){
			_maxDate = "";
		}
	}catch(ex1){}
	
    WdatePicker({lang:languageStr,
			el : spanname,
			onpicked : function(dp) {
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname).value = returnvalue;
				if(_r == "yes"){
					//手动触发oninput事件
					checkinput(inputname, spanname + "img");
				}
				if (!window.ActiveXObject) {
					//手动触发oninput事件
					//checkinput(inputname, spanname + "img");
				}
				try {
					if (_f != undefined && _f != null && _f != "") {
						eval(_f + "($dp.$(inputname).value, evt)");	
					}
					
				} catch (e) {}
			},
			oncleared : function(dp) {
				$dp.$(inputname).value = '';
				if(_r == "yes"){
					//手动触发oninput事件
					checkinput(inputname, spanname + "img");
				}
				if (!window.ActiveXObject) {
					//手动触发oninput事件
					//checkinput(inputname, spanname + "img");
				}
			},
			minDate : _minDate,
			maxDate : _maxDate
	});
}

//function $() {
function $ele4p() {
	var elements = new Array();
	for (var i = 0; i < arguments.length; i++) {
		var element = arguments[i];
		if (typeof element == 'string') {
			element = document.getElementById(element);
			
			if (element == undefined || element == null) {
				element = document.getElementsByName(arguments[i])[0];
			}
		}
		if (arguments.length == 1) {
			return element;
		}
		elements.push(element);
	}
	return elements;
}

/*********************************
 path: ../car/CarInfoAdd.jsp or CarInfoEdit.jsp or CarInfoView.jsp  
*********************************/
function getBuyDate(){
   WdatePicker({lang:languageStr,el:'buyDateSpan',onpicked:function(dp){$dp.$('buyDate').value = dp.cal.getDateStr()}})
}
	
/*********************************
 path: ../car/CarInfoBrowser.jsp,CarInfoMaintenace.jsp
       ../hrm/report/HrmRpTrainHourByDep.jsp,HrmRpTrainHourByType.jsp,HrmRpTrainPeoNumDep.jsp,HrmRpTrainPeoNumByType.jsp
*********************************/
function getStartDate(){
	WdatePicker({lang:languageStr,el:'startdatespan',onpicked:function(dp){
		  $dp.$('startdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate').value = ''}})
}
function getEndDate(){
	WdatePicker({lang:languageStr,el:'enddatespan',onpicked:function(dp){
		$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}})	
}

/*********************************
 path: ../car/CarUserInfo.jsp
       ../datacenter/maintenance/reportstatus/ReportDetailCrm.jsp
       ../hrm/resource/HrmResourceAbsense.jsp,HrmResourcePlan.jsp
	   ../cpt/capital/CptCapitalUsePlan.jsp
*********************************/
function getSubTheDate(){
	 WdatePicker({lang:languageStr,el:'hiddenSpan',onpicked:function(dp){
	        document.frmmain.currentdate.value = dp.cal.getDateStr();
			document.frmmain.submit()},oncleared:function(dp){$dp.$('currentdate').value = ''}})
}

/*********************************
 path:  ../hrm/report/RptSalaryDiff.jsp
*********************************/
function getcurrentdate(){
   WdatePicker({lang:languageStr,el:'currentdatespan',onpicked:function(dp){
	   var recurrentdate  = dp.cal.getDateStr(); document.frmmain.currentdate.value = recurrentdate.substring(0,7); 
	   document.frmmain.submit()},oncleared:function(dp){$dp.$('currentdate').value = ''}})
}

/*********************************
 path: ../docs/docs/DocAdd.jsp,DocEdit.jsp,DocAddExt.jsp,DocEditExt.jsp
*********************************/
function getInvalidationDate(l){
  //var userl = l;
  var returnvalue;
  //var stringvalue;
  
  var clearingFunc = function(){
	  //if(userl == 7){
		  //stringvalue = "文档改变为正常文档后内容会丢失，确认要改变吗";
	  //}
	 // if(userl == 8){
		  //stringvalue = "Content will lost while changing into normal doc,sure to change?";
	 // }
	  //if(window.confirm(stringvalue)){
		  document.getElementById('invalidationdate').value = '';
	  //}
  }
  WdatePicker({lang:languageStr,el:'invalidationdatespan',onpicked:function(dp){
	    returnvalue = dp.cal.getDateStr(); 
		//$ele4p('invalidationdatespan').innerHTML = '';
	    //if(userl == 7){
		 // stringvalue = "文档改变为临时文档后内容会丢失，确认要改变吗?";
		 // }
	    //if(userl == 8){
		 // stringvalue = "Content will lost while changing into temporary doc,sure to change?";
	   // }	    
	    //if(window.confirm(stringvalue)){
			$dp.$('invalidationdate').value = returnvalue;
            $ele4p('invalidationdatespan').innerHTML = returnvalue;
	    //}  
	  },
	  onclearing:clearingFunc})
}

function getInvalidationDate2(l,callbackFunc){
	  //var userl = l;
	  var returnvalue;
	  //var stringvalue;
	  
	  var clearingFunc = function(){
		  //if(userl == 7){
			  //stringvalue = "文档改变为正常文档后内容会丢失，确认要改变吗";
		  //}
		 // if(userl == 8){
			  //stringvalue = "Content will lost while changing into normal doc,sure to change?";
		 // }
		  //if(window.confirm(stringvalue)){
		   $GetEle('invalidationdate').value = '';
		  	callbackFunc.call(this);
		  //}
	  }
	  WdatePicker({lang:languageStr,el:'invalidationdatespan',onpicked:function(dp){
		    returnvalue = dp.cal.getDateStr(); 
			//$ele4p('invalidationdatespan').innerHTML = '';
		    //if(userl == 7){
			 // stringvalue = "文档改变为临时文档后内容会丢失，确认要改变吗?";
			 // }
		    //if(userl == 8){
			 // stringvalue = "Content will lost while changing into temporary doc,sure to change?";
		   // }	    
		    //if(window.confirm(stringvalue)){
				$dp.$('invalidationdate').value = returnvalue;
	            $ele4p('invalidationdatespan').innerHTML = returnvalue;
	            callbackFunc.call(this);
		    //}  
		  },
		  onclearing:clearingFunc});
}

function onShowDocDate(id,fieldbodytype,isbodymand){
	var spanname = "customfield"+id+"span";
	var inputname = "customfield"+id;
	var oncleaingFun = function(){
		  if(isbodymand=="true"){
			 $ele4p("customfield"+id).value = '';
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
          }else{
			 $ele4p("customfield"+id).value = '';
		     $ele4p(spanname).innerHTML = '';
		  }
		}
	if(fieldbodytype == 2){
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
	}

    var hidename = $ele4p(inputname).value;
	if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	}else{
		  if(isbodymand=="true"){
			  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		  }else{
			  $ele4p(spanname).innerHTML = "";
		  }
	}
}

/*********************************
 path: ../docs/docsubscribe/DocSubscribeHistory.jsp,DocSubscribeApprove.jsp,DocSubscribeBack.jsp
       ../docs/report/DocRpReadStatistic.jsp
	   ../workflow/report/FlowTypeStat.jsp,WorkList.jsp,ReportCondition.jsp,ReportConditionEdit.jsp,ReportConditionMould.jsp
	   ../workflow/search/SubWFSearchResult.jsp,WFSearch.jsp,WFSearchResult.jsp,WFCustomSearch.jsp,WFCustomSearchResult.jsp
	                      WFSearchResultForNewBackWorkflow.jsp,WFSuperviselist.jsp
	   ../system/systemmonitor/workflow/WorkflowMonitor.jsp
	   ../systeminfo/SysMaintenanceLog.jsp
	   ../hrm/report/HrmRpContact.jsp,HrmRpResource.jsp
	   ../hrm/career/usedemand/HrmUseDemandAnalyse.jsp
	   ../cpt/capital/CptCapitalFlowView.jsp
	   ../cpt/maintenance/CptCapitalCheckStock.jsp
	   ../cpt/report/CptRpCapitalApportion.jsp,CptRpCapitalCheckStock_bak.jsp,CptRpCapitalFlow.jsp
*********************************/
function gettheDate(inputname,spanname){
		
	    WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../cpt/capital/CptCapitalMend.jsp
*********************************/
function getmendDate(){
	var spanname ="menddatespan";
	 var inputname = "menddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../docs/search/DocSearch.jsp
       ../system/systemmonitor/docs/DocMonitor.jsp
	   ../docs/docs/DocBrowser.jsp,DocBrowserWord.jsp,MutiDocBrowser.jsp,MutiDocBrowser_proj.jsp
	   ../docs/docsubscribe/MutiDocByWenerBrowser.jsp
	   ../docs/news/MultiNewsBrowser.jsp 
	   ../hrm/career/CareerInviteBrowser.jsp
	   ../hrm/career/HrmCareerApplyAddThree.jsp
	   ../hrm/resource/HrmResourceWorkEdit.jsp
	   ../hrm/report/HrmRpMonthSalarySum.jsp,HrmRpResourceSalarySum.jsp,HrmTrainAttendReport.jsp,HrmTrainLayoutReport.jsp,HrmTrainReport.jsp
	                HrmTrainResourceReport.jsp
	   ../hrm/report/careerapply/HrmCareerApplyReport.jsp,HrmRpCareerApply.jsp
	   ../hrm/report/resource/HrmRpResource.jsp
	   ../hrm/report/schedulediff/HrmArrangeShiftReport.jsp,HrmRpScheduleDiff.jsp,HrmRpScheduleDiffDepTime.jsp,HrmRpScheduleDiffDepDay.jsp
	                              HrmRpScheduleDiffType.jsp,HrmRpScheduleDiffTypeDay.jsp,HrmRpTimecard.jsp,HrmRpValidateTimecard.jsp
                                  HrmRpScheduleDiffDepDayReport.jsp,HrmRpScheduleDiffDepMonReport.jsp,HrmScheduleDiffDetailReport.jsp
								  HrmShcheduleDiffReport.jsp,HrmScheDuleDiffTypeMonReport.jsp
       ../hrm/report/usedemand/HrmRpUseDemand.jsp,HrmRpUserDemandDetail.jsp,HrmUseDemandReport.jsp
	   ../hrm/search/HrmResourceSearch.jsp
       ../hrm/schedule/HrmArrangeShiftMaintance.jsp,HrmArrangeShiftProcess.jsp,HrmOutTimecard.jsp,HrmScheduleMaintance.jsp,HrmScheduleMaintanceAdd.jsp
                      HrmWorkTimeWarpList.jsp,HrmWorkTimeWarpCreate.jsp,HrmTimeCarWarpList.jsp
	   ../hrm/career/HrmCareerApplyWorkEdit.jsp,HrmCareerInviteAdd.jsp,HrmCareerInviteEdit.jsp,HrmInterviewAssess.jsp,HrmInterviewPlan.jsp
	                 HrmInterviewResult.jsp
	   ../hrm/career/careerplan/CareerPlanBrowser.jsp,HrmCareerPlanAdd.jsp,HrmCareerPlanEdit.jsp,HrmCareerPlanEditDo.jsp,HrmCareerPlanFinish.jsp
	                            HrmCareerPlanFinishView.jsp
	   ../hrm/career/usedemand/HrmUseDemandAdd.jsp,HrmUseDemandEdit.jsp,HrmUseDemandEditDo.jsp
	   ../hrm/train/train/HrmCareerPlanFinshView.jsp,HrmTrainActorAdd.jsp,HrmTrainAdd.jsp,HrmTrainAssess.jsp,HrmTrainAssessAdd.jsp
	                      HrmTrainAssessEdit.jsp,HrmTrainDayAdd.jsp,HrmTrainDayEdit.jsp,HrmTrainEdit.jsp,HrmTrainEditDo.jsp,HrmTrainFinish.jsp
						  HrmTrainFinishView.jsp,HrmTrainTest.jsp
	   ../hrm/trian/trianlayout/HrmTrainLayoutAdd.jsp,HrmTrainLayoutEdit.jsp,HrmTrainLayoutEditDo.jsp,TrainLayoutAssess.jsp
	   ../hrm/trian/trainplan/HrmTrainLayoutEditDo.jsp,HrmTrainPlanAdd.jsp,HrmTrainPlanEdit.jsp,HrmTrainPlanEditDo.jsp
	   ../hrm/contract/HrmContract.jsp,HrmContractAdd.jsp,HrmContractAddExt.jsp,HrmContractEdit.jsp,HrmContractEditExt.jsp,HrmContractView.jsp,HrmContractViewExt.jsp
       ../hrm/finance/salary/HrmSalaryCreate.jsp,PieceRateMaintenanceEdit.jsp
	   ../workflow/request/ManageBillCptAdjust.jsp,ManageBillCptCarFix.jsp,ManageBillCptCarMantant.jsp,ManageBillCptCarOut.jsp
	                       ManageBillCptCheck.jsp,ManageBillCptFetch.jsp,ManageBillCptPlan.jsp,ManageBillCptRequire.jsp,ManageBillCptStockIn.jsp
						   ManageBillHireResource.jsp,ManageBillHotelBookAll.jsp
	   ../proj/Templet/MutiTaskBrowser.jsp
	   ../proj/process/MutiTaskBrowser.jsp
	   ../proj/plan/EditTaskProcess.jsp,EditProjToolProcess.jsp,EditProjTool.jsp,EditProjMemberProcess.jsp,EditPlan.jsp,AddPlan.jsp,AddProjMember.jsp
	                AddProjMemberProcess.jsp,AddProjTool.jsp,AddProjToolProcess.jsp
       ../fna/report/expense/FnaExpenseTypeCrmDetail.jsp,FnaExpenseTypeDetail.jsp,FnaExpenseTypeProjectDetail.jsp,FnaExpenseTypeResourceDetail.jsp
       ../cpt/search/CptSearch.jsp
	   ../meeting/meetingbrowser.jsp
*********************************/
function getDate(spanname,inputname){  
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../docs/search/DocSummary.jsp,DocSummary3.jsp,DocSearchTemp.jsp,DocSummary(bak1).jsp,DocSummary2(bak1).jsp,DocSummary2.jsp
       ../docs/docs/DocDownloadLog.jsp
	   ../docs/report/DocCreateRp.jsp,DocRpAllDocSum.jsp,DocRpDocSum.jsp,DocRpCreater.jsp,DocRpRelative.jsp,DocRpOrganizationSum.jsp
       ../workflow/report/HrmMonthWorkRp.jsp,HrmWeekRp.jsp,OperateLogRp.jsp,ViewLogRp.jsp
	   ../CRM/report/CRMLoginLogRp.jsp,CRMModifyLogRp.jsp,CRMViewLogRp.jsp,TradeInfoRpSum.jsp,ContractFnaReport.jsp,ContractProReport.jsp
                     ContractReport.jsp,CRMContactLogRp.jsp,CRMEvaluationRp.jsp
	   ../CRM/search/SearchAdvanced.jsp,SearchSimple.jsp
	   ../CRM/sellchance/FailureRpSum.jsp,SelArEACiytRpSum.jsp,SellAreaProRpSum.jsp,SellChanceReport.jsp,SellClientRpSum.jsp,SellManagerRpSum.jsp
	                     SellProductRpSum.jsp,SellStatusRpSum.jsp,SuccessRpSum.jsp
	   ../hrm/resource/HrmResourceExchange.jsp
	   ../hrm/report/hrmAgeRp.jsp,HrmCostcenterRp.jsp,hrmDepartmentRp.jsp,hrmEducationLevelRp.jsp,HrmJobActivityRp.jsp,HrmJobCallRp.jsp
	                 HrmJobGroupRp.jsp,HrmJobLevelRp.jsp,HrmJobTitleRp.jsp,hrmMarriedRp.jsp,HrmRpAbsense.jsp,hrmSevLevelRp.jsp
					 hrmSexRp.jsp,hrmStatusRp.jsp,hrmUsekindRp.jsp
	   ../hrm/report/careerapply/HrmRpCareerApplySearch.jsp
	   ../hrm/report/contract/HrmRpContract.jsp,HrmRpContractDetail.jsp,HrmRpContractType.jsp
	   ../hrm/report/dismiss/HrmDismissReport.jsp,HrmRpDismiss.jsp,HrmRpDismissDetail.jsp,HrmRpDismissTime.jsp
	   ../hrm/report/extend/HrmExtentReport.jsp,HrmRpExtend.jsp,HrmRpExtendDetail.jsp,HrmRpExtendTime.jsp
	   ../hrm/report/fire/HrmFireReport.jsp,HrmRpFire.jsp,HrmRpFireDetail.jsp,HrmRpFireTime.jsp
	   ../hrm/report/hire/HrmHireReport.jsp,HrmRpHire.jsp,HrmRpHireDetail.jsp,HrmRpHireTime.jsp
	   ../hrm/report/redeploy/HrmRedeployReport.jsp,HrmRpRedeploy.jsp,HrmRpRedeployDetail.jsp,HrmRpRedeployTime.jsp
	   ../hrm/report/rehire/HrmRehireReport.jsp,HrmRpRehire.jsp,HrmRpRehireDetail.jsp,HrmRpRehireTime.jsp
       ../hrm/report/resource/HrmRpResourceAdd.jsp,HrmRpResourceAddReport.jsp,HrmRpResourceAddTime.jsp
	   ../hrm/report/retire/HrmRetireReport.jsp,HrmRpRetireTime.jsp,HrmRpRetire.jsp,HrmRpRetireDetail.jsp
	   ../hrm/search/HrmResourceSearch.jsp
	   ../proj/Templet/ProjectModifyLogRp.jsp
       ../fna/report/RptMoneyWeekDetailQuery.jsp
*********************************/
function getfromDate(){
		WdatePicker({lang:languageStr,el:'fromdatespan',onpicked:function(dp){
			$dp.$('fromdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('fromdate').value = ''}});
}
function gettoDate(){
		WdatePicker({lang:languageStr,el:'todatespan',onpicked:function(dp){
			$dp.$('todate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('todate').value = ''}});
}
function getendDate(){
		WdatePicker({lang:languageStr,el:'enddatespan',onpicked:function(dp){
			$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../docs/docdummy/DocDummyRight.jsp
*********************************/
function gettheDummyDate(inputname,spanname){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'subscribeDateTo\').value||\'2020-10-01\'}',el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}
function gettheDummyDate1(inputname,spanname){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'subscribeDateFrom\').value}',el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../docs/search/IndexManager.jsp
*********************************/
function showCalendar(spanId,inputId){
  WdatePicker({lang:languageStr,el:spanId,onpicked:function(dp){
	  var returnvalue = dp.cal.getDateStr();$dp.$(inputId).value = returnvalue;},oncleared:function(dp){$dp.$(inputId).value = ''}});
}

/*********************************
 path: ../voting/VotingAdd.jsp,VotingEdit.jsp
       ../workflow/report/RequestRpPlan.jsp
	   ../workflow/request/AddBillCptAdjust.jsp,AddBillCptApply.jsp,AddBillCptCarFee.jsp,AddBillCptCarFix.jsp,AddBillCptCarMantant.jsp
	                       AddBillCptCarOut.jsp,AddBillCptCheck,jsp,AddBillCptFetch.jsp,AddBillCptPlan.jsp,AddBillCptRequire.jsp
						   AddBillCptStockIn.jsp,AddBillExpense.jsp,AddMeetingroom.jsp,ManageBillWeekInfo.jsp,ManageBillMonthWorkinfo.jsp
	   ../CRM/data/ContractAdd.jsp,ContractEdit.jsp,ContractView.jsp
	   ../CRM/sellchance/AddSellChance.jsp
	   ../hrm/schedule/HrmArrangeShiftAdd.jsp,HrmDefaultScheduleAdd.jsp,HrmDefaultSchedule.jsp
	   ../fna/maintenance/FnaPersonalReturn.jsp,FnaPersonalReturnEdit.jsp,FnaYearsPeriodsAdd.jsp,FnaYearsPoriodsListEdit.jsp
	   ../meeting/data/EditMeeting.jsp
*********************************/
function onShowDate(spanname,inputname){	
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
		var hidename = $ele4p(inputname).value;
		if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		}else{
	      $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
}


function onBillCPTShowDate(spanname,inputname,ismand){	
	  var returnvalue;
	  var oncleaingFun = function(){
		  if(ismand != -1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       spanname.innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
    
	if(ismand != -1){
	 var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
    }
}


/*********************************
 path:  ../workflow/request/AddBillExpense.jsp,ManageBillExpense.jsp,AddBillHrmScheduleMain.jsp
*********************************/
function onBillShowDate(spanname,inputname,ismand){	
	  var returnvalue;
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       spanname.innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
    
	if(ismand == 1){
	 var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
    }
}

/*********************************
 path: ../workflow/request/AddResourcePlan.jsp
*********************************/
function onShowdate(inputname,spanname){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
		   $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../workflow/report/pendingRequestRp.jsp,RequestQualityRp.jsp,WorkflowTypeRp.jsp
 *********************************/
 function getStartDate1(){
    WdatePicker({lang:languageStr,el:'startdatespan1',onpicked:function(dp){
		$dp.$('startdate1').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate1').value = ''}});
 }
 function getStartDate2(){
    WdatePicker({lang:languageStr,el:'startdatespan2',onpicked:function(dp){
		$dp.$('startdate2').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate2').value = ''}});
 }
 function getEndDate1(){
    WdatePicker({lang:languageStr,el:'enddatespan1',onpicked:function(dp){
		$dp.$('enddate1').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate1').value = ''}});
 }
 function getEndDate2(){
    WdatePicker({lang:languageStr,el:'enddatespan2',onpicked:function(dp){
		$dp.$('enddate2').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate2').value = ''}});
 }

 /*********************************
 path: ../workflow/request/AddBill2Request.jsp,AddBill3Request.jsp,AddBill4Request.jsp
 *********************************/
 function getdate(i){ 
   WdatePicker({lang:languageStr,el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
 }

/*********************************
 path: ../workflow/request/AddBillLeaveJob.jsp,AddBillMailboxApply.jsp,AddBillMonthWorkBrief.jsp,AddBillMonthWorkinfo.jsp
                           AddBillMonthWorkPlan.jsp,AddBillTotalBudget.jsp,RequestBrowser.jsp,MultiRequestBrowserRight.jsp
						   ManageBillMonthWorkPlan.jsp
*********************************/
function getTheDate(inputname,spanname){
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../workflow/request/AddBillMonthWorkinfo.jsp,AddBillWeekWorkinfo.jsp
*********************************/
function getMontPlanDate(inputname,spanname){	
	var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		   $ele4p(inputname).value = '';
		}
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../workflow/request/AddOvertime.jsp,AddProjectPlan.jsp
       ../hrm/performance/targetType/TargetBrowserMuti.jsp
	   ../proj/data/MultiTaskBrowser.jsp
	   ../cowork/AddCoWork.jsp
*********************************/
function getBDate(ismand){
    var oncleaingFun = function(){
			if(ismand == 1){
		        document.all("begindatespan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$ele4p('begindate').value = '';
		    }		 
		}
    WdatePicker({lang:languageStr,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();	
		$dp.$('begindatespan').innerHTML = returnvalue;
		$dp.$('begindate').value = returnvalue;
	},oncleared:oncleaingFun});

	if(ismand == 1){
	     var hidename = $ele4p('begindate').value;
		 if(hidename != ""){
			$ele4p('begindate').value = hidename; 
			$ele4p('begindatespan').innerHTML = hidename;
		 }else{
		  $ele4p('begindatespan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
	}
}
function getEDate(ismand){
	var oncleaingFun = function(){
			if(ismand == 1){
		        document.all("enddatespan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$ele4p('enddate').value = '';
		    }		 
		}
    WdatePicker({lang:languageStr,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();	
		$dp.$('enddatespan').innerHTML = returnvalue;
		$dp.$('enddate').value = returnvalue;
	},oncleared:oncleaingFun});

	if(ismand == 1){
	     var hidename = $ele4p('enddate').value;
		 if(hidename != ""){
			$ele4p('enddate').value = hidename; 
			$ele4p('enddatespan').innerHTML = hidename;
		 }else{
		  $ele4p('enddatespan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
	}
}

/*********************************
 path: ../workflow/request/wfAgentAdd.jsp,wfAgentEdit.jsp
*********************************/
function onshowAgentBDate(){
  WdatePicker({lang:languageStr,minDate:'%y-%M-#{%d}',maxDate:'#F{$dp.$(\'endDate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$('beginDate').value = returnvalue;
			},oncleared:function(dp){$dp.$('beginDate').value = ''}});
}

function onshowAgentEDate(){
  WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'beginDate\').value||\'%y-%M-#{%d}\'}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('endDate').value = returnvalue;},oncleared:function(dp){$dp.$('endDate').value = ''}});
}

function onshowAgentBDateNew(){
  WdatePicker({lang:languageStr,minDate:'%y-%M-#{%d}',maxDate:'#F{$dp.$(\'endDate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$('beginDate').value = returnvalue;
			
			var beginDate=$G('beginDate').value;
			var beginTime=$G('beginTime').value;
			var endDate=$G('endDate').value;
			var endTime=$G('endTime').value;
			var beginDateTime =beginDate+' '+beginTime;
			var endDateTime =endDate+' '+endTime;
		     if(endDate!=''&&beginDate!=''){
				if(endTime==''){
						endTime='23:59';
				} 
				if(endDate==''){
					endDate='2099-12-31';
				}
				var beginDateTime =beginDate+' '+beginTime;
				var endDateTime = endDate+' '+endTime;
			    if(beginDateTime.valueOf()>=endDateTime.valueOf()) {
					window.top.Dialog.alert(Htmlmessage); //开始日期时间不能大于等于结束日期时间
					//$G('beginDate').value="";
					//$G('begindatespan').innerHTML="";
					return;
				}
			  }
				
			},oncleared:function(dp){$dp.$('beginDate').value = ''}});
}

function onshowAgentEDateNew(){
  WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'beginDate\').value||\'%y-%M-#{%d}\'}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$('endDate').value = returnvalue;
		    var beginDate=$G('beginDate').value;
			var beginTime=$G('beginTime').value;
			var endDate=$G('endDate').value;
			var endTime=$G('endTime').value;
			var beginDateTime =beginDate+' '+beginTime;
			var endDateTime =endDate+' '+endTime;
			 
		  	 if(endDate!=''&&beginDate!=''){
				if(endTime==''){
						endTime='23:59';
				} 
				if(endDate==''){
					endDate='2099-12-31';
				}
				var beginDateTime =beginDate+' '+beginTime;
				var endDateTime = endDate+' '+endTime;
			    if(beginDateTime.valueOf()>=endDateTime.valueOf()) {
					window.top.Dialog.alert(Htmlmessage); //"结束日期时间不能小于等于开始日期时间"
					//$G('endDate').value="";
					//$G('enddatespan').innerHTML="";
					return;
				}
				
			  }
			},oncleared:function(dp){$dp.$('endDate').value = ''}});
}

/*********************************
 path: ../workflow/request/wfAgentList.jsp
*********************************/
function onlistAgentBDate(){
  WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'todate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('fromdate').value = returnvalue;},oncleared:function(dp){$dp.$('fromdate').value = ''}});
}
function onlistAgentEDate(){
  WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'fromdate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('todate').value = returnvalue;},oncleared:function(dp){$dp.$('todate').value = ''}});
}

/*********************************
 path: ../workflow/request/WorkflowAddRequestBody.jsp,AddBillMeeting.jsp,AddBillCaruseApprove.jsp,WorkflowAddRequestDetailBody.jsp
*********************************/
function onShowFlowDate(id,fieldbodytype,isbodymand){
	var spanname = "field"+id+"span";
	var inputname = "field"+id;
	var oncleaingFun = function(){
		  if(isbodymand == 0){
		     $ele4p(spanname).innerHTML = '';
			 $ele4p("field"+id).value = '';
          }else{
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			 $ele4p("field"+id).value = '';
		  }
		}
	if(fieldbodytype == 2){
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(spanname).innerHTML = returnvalue;
			$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
	}

    if(isbodymand != 0){
	     var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
	}
}
function onShowNoFlowDate(id,fieldbodytype,isbodymand){
	var spanname = "field"+id+"span";
	var inputname = "field"+id;
	var oncleaingFun = function(){
		  if(isbodymand == 0){
		     $ele4p(spanname).innerHTML = '';
			 $ele4p("field"+id).value = '';
          }else{
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			 $ele4p("field"+id).value = '';
		  }
		}
	if(fieldbodytype == 2){
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(spanname).innerHTML = returnvalue;
			$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
	}

    if(isbodymand != 0){
	     var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
	}
}
/*********************************
 path: ../workflow/search/WFCustomSearch.jsp
*********************************/
function onSearchWFDate(spanname,inputname){
	var oncleaingFun = function(){
		  $ele4p(spanname).innerHTML = '';
		  $ele4p(inputname).value = '';
		}
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../datacenter/maintenance/reportstatus/ReportDetailStatus.jsp
*********************************/
function getReportDate(){
   WdatePicker({lang:languageStr,el:'datespan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('date').value = returnvalue;},oncleared:function(dp){$dp.$('date').value = ''}});
}

 /*********************************
 path: ../CRM/data/AddContacter.jsp,AddCustomer.jsp,AddPerCustomer.jsp,EditAddress.jsp,EditContacter.jsp,EditCustomer.jsp,EditPerCustomer.jsp
 *********************************/
 function getCrmDate(i){
   WdatePicker({lang:languageStr,el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
 }

/*********************************
 path: ../CRM/data/AddContacter.jsp,EditContacter.jsp
*********************************/
function getbirthday(){
   WdatePicker({lang:languageStr,el:'birthdayspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('birthday').value = returnvalue;},oncleared:function(dp){$dp.$('birthday').value = ''}});
}

/*********************************
 path: ../CRM/data/AddContactLog.jsp,EditContactLog.jsp
*********************************/
function getContactDate(){
  WdatePicker({lang:languageStr,el:'ContactDatespan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('ContactDate').value = returnvalue;},oncleared:function(dp){$dp.$('ContactDate').value = ''}});
}
function getEndData(){
  WdatePicker({lang:languageStr,el:'EndDataspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('EndData').value = returnvalue;},oncleared:function(dp){$dp.$('EndData').value = ''}});
}

/*********************************
 path: ../CRM/data/ContractAdd.jsp,ContractEdit.jsp,ContractView.jsp
       ../CRM/sellchance/AddSellChance.jsp,EditSellChance.jsp
*********************************/
function onShowDate_1(spanname,inputname){
  var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		$ele4p(inputname).value = '';
  }
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

	 var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}
function onShowDate2(spanname,inputname,inputenameTemp){
  var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		$ele4p(inputname).value = '';
  }
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
	var returnvalue = dp.cal.getDateStr();
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;$dp.$(inputenameTemp).value = returnvalue;},oncleared:oncleaingFun});

     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../CRM/data/EditCustomer.jsp,EditPerCustomer.jsp
*********************************/
function getCreditDate(){
  WdatePicker({lang:languageStr,el:'creditexpirespan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('CreditExpire').value = returnvalue;},oncleared:function(dp){$dp.$('CreditExpire').value = ''}});
}

/*********************************
 path: ../CRM/search/SearchAdvanced.jsp
*********************************/
function getStatusFrom(){
  WdatePicker({lang:languageStr,el:'StatusFromspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('StatusFrom').value = returnvalue;},oncleared:function(dp){$dp.$('StatusFrom').value = ''}});
}
function getStatusTo(){
  WdatePicker({lang:languageStr,el:'StatusTospan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('StatusTo').value = returnvalue;},oncleared:function(dp){$dp.$('StatusTo').value = ''}});
}
function getTypeFrom(){
  WdatePicker({lang:languageStr,el:'TypeFromspan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('TypeFrom').value = returnvalue;},oncleared:function(dp){$dp.$('TypeFrom').value = ''}});
}
function getTypeTo(){
  WdatePicker({lang:languageStr,el:'TypeTospan',onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$('TypeTo').value = returnvalue;},oncleared:function(dp){$dp.$('TypeTo').value = ''}});
}

/*********************************
 path: ../hrm/award/HrmAward.jsp,HrmAwardAdd.jsp,HrmAwardEdit
       ../hrm/check/HrmCheckKindAdd.jsp,HrmCheckKindEdit.jsp,HrmCheckKindView.jsp
*********************************/
function getHrmDate(spanname,inputname){	
	
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:function(dp){
			$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$ele4p(inputname).value = '';
				
		}});
 /* var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		$ele4p(inputname).value = '';
  }
  WdatePicker({lang:languageStr,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
        $dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }*/
}

/*********************************
 path: ../hrm/career/HrmCareerApply.jsp
*********************************/
function getHrmfromDate(){
  WdatePicker({lang:languageStr,el:'fromdatespan',onpicked:function(dp){
			$dp.$('FromDate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('FromDate').value = ''}});
}
function getHrmendDate(){
  WdatePicker({lang:languageStr,el:'enddatespan',onpicked:function(dp){
			$dp.$('EndDate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('EndDate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResource1Add.jsp,HrmResource1Edit.jsp,HrmRsourceAddTwo.jsp,HrmResourceEdit.jsp,HrmResourcePersonalEdit.jsp
       ../hrm/career/HrmCareerApplyAddTwo.jsp
*********************************/
function getbirthdayDate(){
  WdatePicker({lang:languageStr,el:'birthdayspan',onpicked:function(dp){
			$dp.$('birthday').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('birthday').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceAbsense1Add.jsp,HrmResourceCertificationAdd.jsp,HrmResourceCertificationEdit.jsp
                       HrmResourceaWelfareAdd.jsp,HrmResourceaWelfareEdit.jsp,HrmSourceWorkResumeInAdd.jsp,HrmSourceWorkResumeInEdit.jsp
*********************************/
function getDateFrom(){
  WdatePicker({lang:languageStr,el:'datefromspan',onpicked:function(dp){
			$dp.$('datefrom').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('datefrom').value = ''}});
}
function getDateTo(){
  WdatePicker({lang:languageStr,el:'datetospan',onpicked:function(dp){
			$dp.$('dateto').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dateto').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceAdd.jsp
       ../hrm/career/HrmCareerApplyToResource.jsp
*********************************/
function onShowHrmDate(id,id2){
  var spanname = "span"+id2;
  var inputname = "dateField"+id;
  var oncleaingFun = function(){	
	   $ele4p("dateField"+id).value = '';
  }
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
	  var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../hrm/resource/HrmResourceAddThree.jsp
*********************************/
function getstartdate(){
  WdatePicker({lang:languageStr,el:'startdatespan',onpicked:function(dp){
			$dp.$('startdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate').value = ''}});
}
function getenddate(){
  WdatePicker({lang:languageStr,el:'enddatespan',onpicked:function(dp){
			$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}});
}
function getRSDate(spanname,inputname){
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			$dp.$(inputname).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceAddTwo.jsp,HrmResourceEdit.jsp,HrmResourcePersonalEdit.jsp
       ../hrm/career/HrmCareerApplyAddTwo.jsp
*********************************/
function getbememberdateDate(){
  WdatePicker({lang:languageStr,el:'bememberdatespan',onpicked:function(dp){
			$dp.$('bememberdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('bememberdate').value = ''}});
}
function getbepartydateDate(){
  WdatePicker({lang:languageStr,el:'bepartydatespan',onpicked:function(dp){
			$dp.$('bepartydate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('bepartydate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceComponentAdd.jsp,HrmResourceComponentEdit.jsp,HrmResourceEdit.jsp,HrmResourceEducationInfoAdd.jsp
                       HrmResourceEducationInfoEdit.jsp,HrmResourceOtherInfoAdd.jsp,HrmResourceOtherInfoEdit.jsp,HrmResourceWorkEdit.jsp
					   HrmResourceWorkResumeAdd.jsp,HrmResourceWorkResumeEdit.jsp
*********************************/
function getstartDate(){
  WdatePicker({lang:languageStr,el:'startdatespan',onpicked:function(dp){
			$dp.$('startdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdate').value = ''}});
}
function getHendDate(){
  WdatePicker({lang:languageStr,el:'enddatespan',onpicked:function(dp){
			$dp.$('enddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceDismiss.jsp,HrmResourceExtend.jsp,HrmResourceFire.jsp,HrmResourceHire.jsp,HrmResourceReploy.jsp
                       HrmResourceRehire.jsp,HrmResourceRetire.jsp,HrmResourceTry.jsp
*********************************/
function getchangedate(){
   var spanname ="changedatespan";
	 var inputname = "changedate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}
function getchangeenddate(){
  
   var spanname ="changeenddatespan";
	 var inputname = "changeenddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../hrm/resource/HrmResourceEdit.jsp
       ../hrm/search/HrmResourceSearch.jsp
*********************************/
function getHreDate(i){
  WdatePicker({lang:languageStr,el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
}
function getcontractDate(){
  WdatePicker({lang:languageStr,el:'contractdatespan',onpicked:function(dp){
			$dp.$('contractdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('contractdate').value = ''}});
}
function getexpiryDate(){
  WdatePicker({lang:languageStr,el:'expirydatespan',onpicked:function(dp){
			$dp.$('expirydate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('expirydate').value = ''}});
}
function getContractbegintimeDate(){
  WdatePicker({lang:languageStr,el:'contractbegintimespan',onpicked:function(dp){
			$dp.$('contractbegintime').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('contractbegintime').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceRewardsRecordAdd.jsp,HrmResourceRewardsRecordEdit.jsp
*********************************/
function getRewardsDate(){
   WdatePicker({lang:languageStr,el:'rewardsdatespan',onpicked:function(dp){
			$dp.$('rewardsdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('rewardsdate').value = ''}});
}

/*********************************
 path: ../hrm/resource/HrmResourceTrainRecordAdd.jsp,HrmResourceTrainRecordEdit.jsp
*********************************/
function getTrainstartDate(){
   WdatePicker({lang:languageStr,el:'trainstartdatespan',onpicked:function(dp){
			$dp.$('trainstartdate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('trainstartdate').value = ''}});
}
function getTrainendDate(){
   WdatePicker({lang:languageStr,el:'trainenddatespan',onpicked:function(dp){
			$dp.$('trainenddate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('trainenddate').value = ''}});
}

/*********************************
 path: ../hrm/report/contract/HrmRpContract.jsp,HrmRpContractDetail.jsp,HrmRpContractType.jsp
       ../hrm/report/extend/HrmRpExtend.jsp,HrmRpExtendDetail.jsp
	   ../hrm/report/rehire/,HrmRpRehire.jsp,HrmRpRehireDetail.jsp
*********************************/
function getfromToDate(){
   WdatePicker({lang:languageStr,el:'fromTodatespan',onpicked:function(dp){
			$dp.$('fromTodate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('fromTodate').value = ''}});
}
function getendToDate(){
  WdatePicker({lang:languageStr,el:'endTodatespan',onpicked:function(dp){
			$dp.$('endTodate').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('endTodate').value = ''}});
}

/*********************************
 path: ../hrm/report/resource/HrmRpResource.jsp
       ../hrm/search/HrmResourceSearch.jsp
*********************************/
function getstartDateTo(){
   WdatePicker({lang:languageStr,el:'startdateTospan',onpicked:function(dp){
			$dp.$('startdateTo').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('startdateTo').value = ''}});
}
function getcontractDateTo(){
   WdatePicker({lang:languageStr,el:'contractdateTospan',onpicked:function(dp){
			$dp.$('contractdateTo').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('contractdateTo').value = ''}});
}
function getendDateTo(){
   WdatePicker({lang:languageStr,el:'enddateTospan',onpicked:function(dp){
			$dp.$('enddateTo').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('enddateTo').value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmArrangeShift.jsp
*********************************/
function onHrmShowDate(spanname,inputname){
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			$dp.$(inputname).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmPubHolidayAdd.jsp
*********************************/
function getholidayDate(){
   WdatePicker({lang:languageStr,el:'holidaydatespan',onpicked:function(dp){
			$dp.$('holidaydate').value = dp.cal.getDateStr();
			if($dp.$('countryid').value != ''){$dp.$('operation').value = "selectdate";document.frmmain.submit();}},
				oncleared:function(dp){$dp.$('holidaydate').value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmWorkTimeList.jsp,HrmWorkTimeCreate.jsp,HrmWorkTimeEdit.jsp
       ../hrm/finance/HrmDepSalaryPay.jsp
*********************************/
function getSdDate(spanname,inputname){
   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
	 //var yandm = $ele4p(inputname).value;
     //$dp.$(spanname).innerHTML = yandm;
	 var resubing =dp.cal.getDateStr(); 
	 $dp.$(inputname).value =resubing.substring(0,7);
	 $dp.$(spanname).innerHTML =resubing.substring(0,7);
	 },
	 oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/schedule/HrmScheduleMaintanceEdit.jsp
*********************************/
function getSdHrmDate(spanname,inputname){
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
	$dp.$(inputname).value = dp.cal.getDateStr();
	if(frmmain.startdate.value != "" && frmmain.enddate.value != "" && frmmain.starttime.value != "" && frmmain.endtime.value != ""){
       frmmain.operation.value="submit";
       frmmain.submit();
      }
	},oncleared:function(dp){$dp.$(inputname).value = ''}});
}

/*********************************
 path: ../hrm/report/resource/HrmRpResource.jsp
*********************************/
function onRpDateShow(spanname,inputname,isbodymand){
   var oncleaingFun = function(){
		  if(isbodymand == 0){
		     $ele4p(spanname).innerHTML = '';
			 $ele4p(inputname).value = '';
          }else{
		     $ele4p(spanname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			 $ele4p(inputname).value = '';
		  }
		}
   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;
		$dp.$(spanname).innerHTML = returnvalue;
		},oncleared:oncleaingFun});
 
   if(isbodymand != 0){
    var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
   }
}

/*********************************
 path: ../hrm/performance/goal/myGoalAdd.jsp,myGoalBreak.jsp,myGoalEdit.jsp
*********************************/
function getPfStartDate(){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p('startDateSpan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p('startDate').value = '';
	      }
	   WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'endDate\').value||\'2020-10-01\'}',el:'startDateSpan',onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('startDateSpan').innerHTML = returnvalue;
        $dp.$('startDate').value = returnvalue;},oncleared:oncleaingFun});
		var hidename = $ele4p('startDate').value;
		if(hidename != ""){
			$ele4p('startDate').value = hidename; 
			$ele4p('startDateSpan').innerHTML = hidename;
		}else{
	      $ele4p('startDateSpan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
}
function getPfEndDate(){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p('endDateSpan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p('endDate').value = '';
	      }
	   WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'startDate\').value}',el:'endDateSpan',onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('endDateSpan').innerHTML = returnvalue;
        $dp.$('endDate').value = returnvalue;},oncleared:oncleaingFun});
		var hidename1 = $ele4p('endDate').value;
		if(hidename1 != ""){
			$ele4p('endDate').value = hidename1; 
			$ele4p('endDateSpan').innerHTML = hidename1;
		}else{
	      $ele4p('endDateSpan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
}
function getLimitStartDate(startspan,startvalue,endspan,endvalue){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(startspan).innerHTML = ""; 
           $ele4p(startvalue).value = '';
	      }
	   WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\''+endvalue+'\').value||\'2020-10-01\'}',el:startspan,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(startspan).innerHTML = returnvalue;
        $dp.$(startvalue).value = returnvalue;},oncleared:oncleaingFun});
		var hidename = $ele4p(startvalue).value;
		if(hidename != ""){
			$ele4p(startvalue).value = hidename; 
			$ele4p(startspan).innerHTML = hidename;
		}else{
	      $ele4p(startspan).innerHTML = "";
		}
}
function getLimitEndDate(startspan,startvalue,endspan,endvalue){
 	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(endspan).innerHTML = ""; 
           $ele4p(endvalue).value = '';
	      }
	   WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\''+startvalue+'\').value}',el:endspan,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(endspan).innerHTML = returnvalue;
        $dp.$(endvalue).value = returnvalue;},oncleared:oncleaingFun});
		var hidename1 = $ele4p(endvalue).value;
		if(hidename1 != ""){
			$ele4p(endvalue).value = hidename1; 
			$ele4p(endspan).innerHTML = hidename1;
		}else{
	      $ele4p(endspan).innerHTML = "";
		}
}

/*********************************
 path: ../hrm/employee/EmployeeAdd.jsp
*********************************/
function getworkdayDate(){
  WdatePicker({lang:languageStr,el:'workdayspan',onpicked:function(dp){
		$dp.$('workday').value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('workday').value = ''}});
}

/*********************************
 path: ../workflow/request/ManageBillCptApply.jsp
*********************************/
function onShowDate1(spanname,inputname,mand){
  var oncleaingFun = function(){
	    if(mand == 1){
		 $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}else{
		  $ele4p(spanname).innerHTML = '';
		}
		$ele4p(inputname).value = '';
  }
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		$dp.$(inputname).value = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = dp.cal.getDateStr();
		},oncleared:oncleaingFun});

   if(mand == 1){
    var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
   }
}

/*********************************
 path: ../workplan/data/WorkPlanAdd.jsp
*********************************/
function onshowPlanDate(inputname,spanname){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}


/*********************************
 path: /voting/VotingAdd.jsp
*********************************/
function onshowVotingEndDate(inputname,spanname){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = ""; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "";
	 }
}

/*********************************
 path: ../proj/Templet/TempletTaskEdit.jsp
*********************************/
function gettheProjBDate(){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;calculateWorkday();},oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function gettheProjEDate(){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;calculateWorkday();},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../proj/process/AddTask.jsp
*********************************/
function getProjBDate(){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;},oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function getProjEDate(){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../proj/process/DspMember.jsp,ViewProcessByPic.jsp,ViewProcess.jsp,ProjectTaskApprovalDetail.jsp,ProjextTaskApproval.jsp
       ../proj/plan/ViewPlan.jsp,NewPlan.jsp,DspMember.jsp
*********************************/
function getProjSubDate(spanname,inputname){  
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;weaver.submit();},oncleared:function(dp){$dp.$(inputname).value = '';weaver.submit();}});
}

/*********************************
 path: ../proj/data/EditProjMember.jsp,AddProjMember.jsp
*********************************/
function getBDateP(){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p("BDatePspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p('begindate').value = '';
	      }
	   WdatePicker({lang:languageStr,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('BDatePspan').innerHTML = returnvalue;
        $dp.$('begindate').value = returnvalue;},oncleared:oncleaingFun});
}
function getEDateP(){
  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p("EDatePspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p('enddate').value = '';
	      }
	   WdatePicker({lang:languageStr,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$('EDatePspan').innerHTML = returnvalue;
        $dp.$('enddate').value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../proj/plan/EditTask.jsp,AddTask.jsp
*********************************/
function getProjPBDate(){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;
			weaver.action="/proj/data/TaskCountWorkday.jsp";
	        weaver.submit();
			},oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function getProjPEDate(){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;
				var startdate = $dp.$('begindate').value;
				if(startdate=="")
				{
					alert(SystemEnv.getHtmlNoteName(3510,readCookie("languageidweaver")));
				}
				else
				{
					weaver.action="/proj/data/TaskCountWorkday.jsp";
		        	weaver.submit();
		        }
			},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

/*********************************
 path: ../proj/process/EditTask.jsp
*********************************/
Date.prototype.format =function(format){
    var o = {
"M+" : this.getMonth()+1, //month
"d+" : this.getDate(),    //day
"h+" : this.getHours(),   //hour
"m+" : this.getMinutes(), //minute
"s+" : this.getSeconds(), //second
"q+" : Math.floor((this.getMonth()+3)/3),  //quarter
"S" : this.getMilliseconds() //millisecond
    }
    if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
    (this.getFullYear()+"").substr(4- RegExp.$1.length));
    for(var k in o)if(new RegExp("("+ k +")").test(format))
    format = format.replace(RegExp.$1,
    RegExp.$1.length==1? o[k] :
    ("00"+ o[k]).substr((""+ o[k]).length));
    return format;
}

function addBeginDate(dd,dadd,bt){

	var arr= dd.split("-");
	var btt = bt.split(":");
	var a = new Date(arr[0],arr[1]-1,arr[2],btt[0],btt[1]).valueOf();
	a = (a + dadd * 24 * 60 * 60 * 1000)+60*1000;
	a = new Date(a);
	return a.format("yyyy-MM-dd hh:mm");
}

function addEndDate(dd,dadd,bt){

	var arr= dd.split("-");
	var btt = bt.split(":");
	var a = new Date(arr[0],arr[1]-1,arr[2],btt[0],btt[1]).valueOf();
	a = (a + dadd * 24 * 60 * 60 * 1000)-60*1000;
	a = new Date(a);
	return a.format("yyyy-MM-dd hh:mm");
}
/**
 * 自动转化开始日期,结束日期,工期
 */
/**
function genDateAndWorkday(obj,begindate_,enddate_,workday_,begintime_,endtime_,manager,passnoworktime){
	if(obj&&begindate_&&enddate_&&workday_&&begintime_&&endtime_){
		var bObj= jQuery("#"+begindate_);
		var eObj= jQuery("#"+enddate_);
		var wObj= jQuery("#"+workday_);
		var btObj= jQuery("#"+begintime_);
		var etObj= jQuery("#"+endtime_);
		//alert("manager:"+manager);
		//alert("passnoworktime:"+passnoworktime);
		var curEleName=jQuery(obj).attr("bind");
		if(curEleName==begindate_||curEleName==begintime_){
			WdatePicker({lang:languageStr
				,maxDate:eObj.val()||"2030-12-31"
				,el:begindate_+"span"
				,onpicked:function(dp){
							var returnvalue = dp.cal.getDateStr();
							bObj.val(returnvalue);
							var diff= datediff(bObj.val(),eObj.val());
							if(diff>0){
								wObj.val(diff);
							}else{
								wObj.val("");
							}
						}
				,oncleared:function(dp){
							bObj.val("");
							wObj.val("");
						}
				});
		}else if(curEleName==enddate_||curEleName==endtime_){
			WdatePicker({lang:languageStr
				,minDate:bObj.val()
				,el:enddate_+"span"
				,onpicked:function(dp){
							var returnvalue = dp.cal.getDateStr();
							eObj.val(returnvalue);
							var diff= datediff(bObj.val(),eObj.val());
							if(diff>0){
								wObj.val(diff);
							}else{
								wObj.val("");
							}
						}
				,oncleared:function(dp){
							eObj.val("");
							wObj.val("");
						}
				});
		}else if(curEleName==workday_){
			var b=bObj.val();
			var e=eObj.val();
			var w=wObj.val();
			if(w==""&&b!=""&&e!=""){
				eObj.val("");
				jQuery("#"+enddate_+"span").html("");
			}else if(w!=""&&((b!=""&&e!="")||(b!=""&&e==""))){
				if(w>0){
					var tmpe=addDate(b,(w-1));
					eObj.val(tmpe);
					jQuery("#"+enddate_+"span").html(tmpe);
				}else{
					wObj.val("");
					eObj.val("");
					jQuery("#"+enddate_+"span").html("");
				}
				
			}else if(w!=""&&b==""&&e!=""){
				if(w>0){
					var tmpb=addDate(e,-(w-1));
					bObj.val(tmpb);
					jQuery("#"+begindate_+"span").html(tmpb);
				}else{
					wObj.val("");
					bObj.val("");
					jQuery("#"+begindate_+"span").html("");
				}
				
			}
		}
		
	}
}
**/
var bObj= "";
var eObj= "";
var wObj= "";
var btObj= "";
var etObj= "";
var btspqnobj= "";
var etspqnobj= "";
var manager_ ="";
var passnoworktime_ ="";
var timeindex = "";
var ettime ="";
var bttime="";
function genDateAndWorkday(obj,begindate_,enddate_,workday_,begintime_,endtime_,manager,passnoworktime){
	if(obj&&begindate_&&enddate_&&workday_){
		 bObj= jQuery("#"+begindate_);
		 eObj= jQuery("#"+enddate_);
		 wObj= jQuery("#"+workday_);
		 btObj= jQuery("#"+begintime_);
		 etObj= jQuery("#"+endtime_);
		 btspqnobj = jQuery("#"+begintime_+"span");
		 etspqnobj = jQuery("#"+endtime_+"span");
		 bttime = btObj.val();
		 ettime = etObj.val();
		 if(""+bttime=="undefined"){
			 bttime = "";
		 }
		 if(""+ettime=="undefined"){
			 ettime = "";
		 }
		 manager_ =manager;
		 var oldbvalue = bObj.val();
		 var oldevalue = eObj.val();
		 var oldwvalue = wObj.val();
		passnoworktime_ =passnoworktime;
		var curEleName=jQuery(obj).attr("bind");
		if(curEleName==begindate_){
			WdatePicker({lang:languageStr
				,maxDate:eObj.val()||"2030-12-31"
				,el:begindate_+"span"
				,onpicked:function(dp){
							var returnvalue = dp.cal.getDateStr();
							bObj.val(returnvalue);
							var diff ;
							if(eObj.val()!=""){
							   if(bttime!="" && ettime!=""){
									diff= datediff(bObj.val(),eObj.val(),bttime,ettime,manager,passnoworktime);
								}else if(bttime=="" && ettime==""){
									diff= datediff(bObj.val(),eObj.val(),"00:00","23:59",manager,passnoworktime);
								}else if(bttime!="" && ettime==""){
									diff= datediff(bObj.val(),eObj.val(),bttime,"23:59",manager,passnoworktime);
								}else if(bttime=="" && ettime!=""){
									diff= datediff(bObj.val(),eObj.val(),"00:00",ettime,manager,passnoworktime);
								}

								if(diff>0){
									wObj.val(diff);
								}else{
									alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
									bObj.val(oldbvalue);
									jQuery("#"+begindate_+"span").html(oldbvalue);
								}
							}
							
						}
				,oncleared:function(dp){
							bObj.val("");
							wObj.val("");
						}
				});
		}else if(curEleName==enddate_){
			WdatePicker({lang:languageStr
				,minDate:bObj.val()
				,el:enddate_+"span"
				,onpicked:function(dp){
							var returnvalue = dp.cal.getDateStr();
							eObj.val(returnvalue);
							var diff ;
							if(bObj.val()!=""){
							
								if(bttime!="" && ettime!=""){
									diff= datediff(bObj.val(),eObj.val(),bttime,ettime,manager,passnoworktime);
								}else if(bttime=="" && ettime==""){
									diff= datediff(bObj.val(),eObj.val(),"00:00","23:59",manager,passnoworktime);
								}else if(bttime!="" && ettime==""){
									diff= datediff(bObj.val(),eObj.val(),bttime,"23:59",manager,passnoworktime);
								}else if(bttime=="" && ettime!=""){
									diff= datediff(bObj.val(),eObj.val(),"00:00",ettime,manager,passnoworktime);
								}

								if(diff>0){
									wObj.val(diff);
								}else{
									alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
									eObj.val(oldevalue);
									jQuery("#"+enddate_+"span").html(oldevalue);
								}
							}
							
						}
				,oncleared:function(dp){
							eObj.val("");
							wObj.val("");
						}
				});
		}else if(curEleName==workday_){
			var b=bObj.val();
			var e=eObj.val();
			var w=wObj.val();
			var bt=bttime;
			var et=ettime;
			if(bt==""){
				bt="00:00";		
			}
			if(et==""){
				et="23:59";
			}
			
			if(w==""&&b!=""&&e!=""){
				eObj.val("");
				jQuery("#"+enddate_+"span").html("");
			}else if(w!=""&&((b!=""&&e!="")||(b!=""&&e==""))){
				if(w>0){
				if(passnoworktime!="1"){
				
					alldate=addEndDate(b,w,bt);
				}else{
			
					$.ajax({
			           type: "post",
			           url: "/proj/process/GetDateByWorkLong.jsp",
			           data:"method=getEndDate&workLong="+w+"&begindate="+b+"&begintime="+bt+"&manager="+manager_,
			           dataType: "text", 
			           async:false,
			           success:function(data){
			           		alldate = data.trim();
			           }
			       });
				}
					var tmpesp = alldate.split(" ");
					eObj.val(tmpesp[0]);
					jQuery("#"+enddate_+"span").html(tmpesp[0]);
					etObj.val(tmpesp[1]);
					jQuery("#"+endtime_+"span").html(tmpesp[1]);
				}else{
					wObj.val("");
					eObj.val("");
					jQuery("#"+enddate_+"span").html("");
				}
				
			}else if(w!=""&&b==""&&e!=""){
				if(w>0){
					if(passnoworktime!="1"){
					
						alldate=addBeginDate(e,-(w),et);
					}else{
					 $.ajax({
			           type: "post",
			           url: "/proj/process/GetDateByWorkLong.jsp",
			           data:"method=getBeginDate&workLong="+w+"&enddate="+e+"&endtime="+et+"&manager="+manager_,
			           dataType: "text", 
			           async:false,
			           success:function(data){
			           		alldate = data.trim();
			           }
			       });
					}
					var tmpbsp = alldate.split(" ");
					bObj.val(tmpbsp[0]);
					jQuery("#"+begindate_+"span").html(tmpbsp[0]);
					btObj.val(tmpbsp[1]);
					jQuery("#"+begintime_+"span").html(tmpbsp[1]);
				}else{
					wObj.val("");
					bObj.val("");
					jQuery("#"+begindate_+"span").html("");
				}
				
			}
			
		}else if(curEleName==begintime_){
		
		var begintimespan = document.getElementById(begintime_+"span");
		timeindex = "1";
		onProjTaskTime(begintimespan,document.getElementById(begintime_));
		
		
		}else if(curEleName==endtime_){
		
			 var endtimespan = document.getElementById(endtime_+"span");
			 timeindex = "2";
			 onProjTaskTime(endtimespan,document.getElementById(endtime_));
		 
		 
		
		}
	}
}
function getbegintime(returnvalue,bObj,eObj,btObj,etObj,manager,passnoworktime,oldvalue,btspqnobj){
	if(window.console) console.log(returnvalue,bObj.val(),eObj.val(),btObj.val(),etObj.val(),manager,passnoworktime);
	btObj.val(returnvalue);
	if(bObj.val()!="" && eObj.val()!=""&&etObj.val()!=""){
		diff= datediff(bObj.val(),eObj.val(),btObj.val(),etObj.val(),manager,passnoworktime);
		if(window.console) console.log("getbegintime diff:"+diff);
		if(diff>=0){
			wObj.val(diff);
		}else{
			alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
			btObj.val(oldvalue);
			btspqnobj.html(oldvalue);
		}
	}
}

function getendtime(returnvalue,bObj,eObj,btObj,etObj,manager,passnoworktime,oldvalue,etspqnobj){
	if(window.console) console.log(returnvalue,bObj.val(),eObj.val(),btObj.val(),etObj.val(),manager,passnoworktime);
	etObj.val(returnvalue);
	if(bObj.val()!=""&&eObj.val()!=""&&btObj.val()!=""){
	diff= datediff(bObj.val(),eObj.val(),btObj.val(),etObj.val(),manager,passnoworktime);
	if(window.console) console.log("getendtime diff:"+diff);
	if(diff>=0){
		wObj.val(diff);
	}else{
		alert(SystemEnv.getHtmlNoteName(55,readCookie("languageidweaver")));
		etObj.val(oldvalue);
		etspqnobj.html(oldvalue);
	}
}
	
}
function datediff(sDate1,sDate2,sDate3,sDate4,manager,passnoworktime){

  	var aDate, oDate1, oDate2, iDays,odate3,odate4,tdate,otime1,otime2,oDatetime1, oDatetime2;
  	
  	if(passnoworktime!=1){
  	
  		oDate1=new Date(sDate1);
		oDate2=new Date(sDate2);
		odate3=new Date(sDate3);
		odate4=new Date(sDate4);
		
		if(true || ""+oDate1.getFullYear()=="NaN"){
			aDate = sDate1.split("-")
			tdate = sDate3.split(":")
		    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])   //转换为12-18-2002格式
		    oDatetime1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]+" "+tdate[0]+":"+tdate[1]) 
			//if(window.console) console.log("oDate1:"+oDate1);
			//if(window.console) console.log("oDatetime1:"+oDatetime1);
		    aDate = sDate2.split("-")
		    tdate = sDate4.split(":")
		    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
		    oDatetime2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]+" "+tdate[0]+":"+tdate[1])
	    
	    }
		//if(window.console) console.log("oDatetime1:"+(oDatetime1));
		//if(window.console) console.log("oDatetime2:"+(oDatetime2));
	    if(oDate2-oDate1<0){
	   		 iDays = -1 	//日期
	    }else if(oDate2-oDate1==0){
	    	if(sDate4<sDate3){
	    		iDays = -2 //时间
	    	}else{
	    		iDays = (Math.abs(oDatetime1-oDatetime2) / 1000 / 60 / 60 /24).toFixed(2)     
	    	}
	    }else{
	    	 iDays = (Math.abs(oDatetime1-oDatetime2) / 1000 / 60 / 60 /24).toFixed(2)     
	    }
	    if(window.console) console.log("iDays:"+(iDays));
  	}else{
  		
  	 $.ajax({
           type: "post",
           url: "/proj/process/GetWorkDays.jsp",
           data:"begindate="+sDate1+"&begintime="+sDate3+"&enddate="+sDate2+"&endtime="+sDate4+"&manager="+manager,
           dataType: "text", 
           async:false,
           success:function(data){
           		iDays = data.trim();
           		
           }
       });
  	}
    
    return iDays;



/*
	 var aDate, oDate1, oDate2, iDays
    oDate1=new Date(sDate1);
	oDate2=new Date(sDate2);
	if(""+oDate1.getFullYear()=="NaN"){
		aDate = sDate1.split("-")
	    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])  //转换为12-18-2002格式
	    aDate = sDate2.split("-")
	    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
    }
	if (oDate2-oDate1>=0) {
        iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24)  //把相差的毫秒数转换为天数
        iDays=iDays+1;
    } else {        
		iDays = -1 	    
	}
    return iDays
    */
}

function getcalBeWorkday(){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'enddate\').value||\'2020-10-01\'}',el:'begindatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('begindate').value = returnvalue;},
				oncleared:function(dp){$dp.$('begindate').value = ''}});
}
function getcalEeWorkday(){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'begindate\').value}',el:'enddatespan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('enddate').value = returnvalue;},
				oncleared:function(dp){$dp.$('enddate').value = ''}});
}
function getActualBDate(){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'actualEndDate\').value||\'2020-10-01\'}',el:'actualBeginDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualBeginDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualBeginDate').value = ''}});
}
function getActualEDate(){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'actualBeginDate\').value}',el:'actualEndDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualEndDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualEndDate').value = ''}});
}

function getActualBDate_1(){
		WdatePicker({lang:languageStr,maxDate:'#F{$dp.$(\'actualEndDate\').value||\'2020-10-01\'}',el:'actualBeginDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualBeginDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualBeginDate').value = ''}});
}
function getActualEDate_1(){
		WdatePicker({lang:languageStr,minDate:'#F{$dp.$(\'actualBeginDate\').value}',el:'actualEndDateSpan',onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$('actualEndDate').value = returnvalue;},oncleared:function(dp){$dp.$('actualEndDate').value = ''}});
}

/*********************************
 path: ../fna/transaction/FnaTransactionAdd.jsp,FnaTransactionEdit.jsp
*********************************/
function getFnaTaddDate(currentdate){
      var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p("trandatespan").innerHTML = currentdate; 
           $ele4p('trandate').value = currentdate;
	      }
	   WdatePicker({lang:languageStr,el:'trandatespan',onpicking:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$('trandate').value = returnvalue;},oncleared:oncleaingFun});
}

/*********************************
 path: ../fna/report/RptManagementDetailQuery.jsp,RptOtherArPersonDetailQuery.jsp
*********************************/
function getFnafromDate(){
     WdatePicker({lang:languageStr,el:'fromdatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('fromdate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('fromdate').value = ''}});
}
function getFnaendDate(){
     WdatePicker({lang:languageStr,el:'enddatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('enddate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('enddate').value = ''}});
}

 /*********************************
 path: ../proj/data/AddProject.jsp
       ../cpt/capital/CptCapitalAdd.jsp,CptCapitalEdit
 *********************************/
 function getProjdate(i){ 
   WdatePicker({lang:languageStr,el:'datespan'+i,onpicked:function(dp){
	   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
 }

 /*********************************
 path: ../proj/data/EditProjectTask.jsp
 *********************************/

var txtObj1;
var spanObj1;
var endDateObj1;
var spanEndDateObj1;
var timeObj1 ;
var timespanObj1;
var endtimeObj1 ;
var endtimespanObj1 ;
var workLongObj1  ;
var taskid;
 
function onShowBeginTime(txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj,workLongObj){

	 txtObj1 =txtObj;
	 spanObj1=spanObj;
	 endDateObj1 =endDateObj;
	 spanEndDateObj1 =spanEndDateObj;
	 timeObj1 =timeObj;
	 timespanObj1 =timespanObj;
	 endtimeObj1 =endtimeObj;
	 endtimespanObj1 =endtimespanObj;
	 workLongObj1 =workLongObj ;
	
	 taskid = "1";
	 onProjTaskTime(timespanObj,timeObj);
/**
	 WdatePicker({lang:languageStr,el:timespanObj,
	 dateFmt:'HH:mm',//minDate:'9:00',maxDate:'18:00',
	 onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(timespanObj).innerHTML = returnvalue;
        $dp.$(timeObj).value = returnvalue;
        onShowBeginTime1(returnvalue,txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj,workLongObj);
     },
     oncleared:function(dp){$dp.$(timeObj).value = ''}});
 **/    
}
var txtObj2;
var spanObj2;
var beginDateObj2;
var spanBeginDateObj2;
var endtimeObj2;
var endtimespanObj2;
var timeObj2;
var timespanObj2;
var workLongObj2;
function onShowEndTime(txtObj,spanObj,beginDateObj,spanBeginDateObj,endtimeObj,endtimespanObj,timeObj,timespanObj,workLongObj){
		 txtObj2=txtObj;
		 spanObj2=spanObj;
		 beginDateObj2=beginDateObj;
		 spanBeginDateObj2=spanBeginDateObj;
		 endtimeObj2=endtimeObj;
		 endtimespanObj2=endtimespanObj;
		 timeObj2=timeObj;
		 timespanObj2=timespanObj;
		 workLongObj2=workLongObj;
		 taskid = "2";
	  onProjTaskTime(endtimespanObj,endtimeObj);
/**

	 WdatePicker({lang:languageStr,el:endtimespanObj,
	 dateFmt:'HH:mm',//minDate:'9:00',maxDate:'18:00',
	 onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(endtimespanObj).innerHTML = returnvalue;
        $dp.$(endtimeObj).value = returnvalue;
        onShowEndTime1(returnvalue,txtObj,spanObj,beginDateObj,spanBeginDateObj,endtimeObj,endtimespanObj,timeObj,timespanObj,workLongObj);
     },
     oncleared:function(dp){$dp.$(endtimeObj).value = ''}});
     **/
}

 
 function onShowBeginDate(txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj,workLongObj){
	   WdatePicker({lang:languageStr,el:spanObj,onpicked:function(dp){		
		var returndate = dp.cal.getDateStr();
          onShowBeginDate1(returndate,txtObj,spanObj,endDateObj,spanEndDateObj,timeObj,timespanObj,endtimeObj,endtimespanObj,workLongObj);
		},
		oncleared:function(dp){$dp.$(txtObj).value = '';$dp.$(workLongObj).value='';}});
}
 function onShowEndDate(txtObj,spanObj,beginDateObj,spanBeginDateObj,endtimeObj,endtimespanObj,timeObj,timespanObj,workLongObj){
	   WdatePicker({lang:languageStr,el:spanObj,onpicked:function(dp){		
		var returndate = dp.cal.getDateStr();
          onShowEndDate1(returndate,txtObj,spanObj,beginDateObj,spanBeginDateObj,endtimeObj,endtimespanObj,timeObj,timespanObj,workLongObj);
		},
		oncleared:function(dp){$dp.$(txtObj).value = '';$dp.$(workLongObj).value='';}});
}

 /*********************************
 path: ../workflow/request/AddRequest.jsp,WorkflowManageSingForBill.jsp
 *********************************/
function onWorkFlowShowDate(spanname,inputname,ismand){	      
	  var returnvalue;	  
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       $ele4p(spanname).innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

	if(ismand == 1){
	   var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
	}
}

function onFlownoShowDate_fnaDateEvent(inputname){
	try{
		//relatedate_2spanimg
		var inputValue = jQuery("#"+inputname).val();
		jQuery("#"+inputname).val(inputValue);
		jQuery("#"+inputname+"span").html(inputValue);
		try{
			//budgetperiod_0spanimg
			var inputnameArray = inputname.split("_");
			if(inputnameArray.length==2&&(inputnameArray[0]=="budgetperiod" || inputnameArray[0]=="relatedate")){
				if(inputValue!=""){
					jQuery("#"+inputname+"spanimg").html("");
				}else{
					jQuery("#"+inputname+"spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\" />");
				}
			}
		}catch(ex11){}
		var _obj = $ele4p(inputname);
		var _iptIdOrName = "";
		try{_iptIdOrName = _obj.id;}catch(ex1){}
		if(_iptIdOrName==null||_iptIdOrName==""){
			try{_iptIdOrName = _obj.name;}catch(ex1){}
		}
		var _iptFieldid = _iptIdOrName;
		var _rowIndex = "";
        var inputnameArray = _iptIdOrName.split("_");
        if(inputnameArray.length >= 2){
        	_rowIndex = inputnameArray[inputnameArray.length-1];
		if(_iptIdOrName.indexOf("field")>-1){
        		_iptFieldid = "";
        		for(var i=0;i<inputnameArray.length-1;i++){
        			if(i>0){
        				_iptFieldid += "_";
        			}
        			if(i==0){
        				_iptFieldid += inputnameArray[i].substring("field".length);
        			}else{
        				_iptFieldid += inputnameArray[i];
        			}
			}
        	}
        }else{
        	_iptFieldid = _iptIdOrName.substring("field".length);
        }
        try{
        	wfbrowvaluechange_fna(_obj, _iptFieldid, _rowIndex);
        }catch(ex011){
        	window.wfbrowvaluechange(_obj, _iptFieldid, _rowIndex);
        }
	}catch(ex012){}
}

function onFlownoShowDate(spanname,inputname,ismand){
	  var useNewPlugin = false;
	  var isNewPlugisBrowser = jQuery("#isNewPlugisBrowser");
	  //if(isNewPlugisBrowser.length>0&&isNewPlugisBrowser.val()=="1"){//新插件
		//useNewPlugin = true;
	 // }
	  var returnvalue;	 
	  var ismast = 1;
	  if(ismand == 1){
		  ismast = 2;
	  }
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(inputname).value = '';
		   }else{
			   $ele4p(inputname).value = '';
		   } 
	      onFlownoShowDate_fnaDateEvent(inputname);
	      
	       if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
		   }else{
		       $ele4p(spanname).innerHTML = ""; 
		   }
	 };
	 WdatePicker({lang:languageStr,el:inputname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(inputname).value = returnvalue;
	
        if(useNewPlugin){
        	 var sHtml = wrapshowhtml("<a title='" + returnvalue + "'>" + returnvalue + "</a>&nbsp", returnvalue,ismast);
			  $dp.$(spanname).innerHTML = sHtml;
			   hoverShowNameSpan(".e8_showNameClass");
			   jQuery("#"+inputname+"spanimg").html("");
        }else{
	        $dp.$(spanname).innerHTML = returnvalue;
        }
        onFlownoShowDate_fnaDateEvent(inputname);
        
        if(!window.ActiveXObject){		//非IE下手动触发input的onpropertychange事件
        	try{
		        var onpropertychangeStr=jQuery("#"+inputname).attr("onpropertychange");
		        if(!!onpropertychangeStr){
		        	eval(onpropertychangeStr);
		        }
        	}catch(ex){}
        }
     },oncleared:oncleaingFun});
    if(ismand == 1){
	   var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
		   $ele4p(inputname).value = hidename; 
		   if(useNewPlugin){
			  var sHtml = wrapshowhtml("<a title='" + hidename + "'>" + hidename + "</a>&nbsp", hidename,ismast);
			  $ele4p(spanname).innerHTML = sHtml;
			  hoverShowNameSpan(".e8_showNameClass");
			  jQuery("#"+inputname+"spanimg").html("");
		    }else{
			  $ele4p(spanname).innerHTML = hidename;
		    }
		 }else{
			if(useNewPlugin){
			  $ele4p(spanname).innerHTML = "";
			  jQuery("#"+inputname+"spanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    }else{
			  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		    }
		 }
	}
}

function onBoHaiShowDate(spanname,inputname,ismand){	
	  var returnvalue;	  
	  var oncleaingFun = function(){
		  if(ismand == 1){
			   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
			   $ele4p(inputname).value = '';
		   }else{
		       $ele4p(spanname).innerHTML = ""; 
			   $ele4p(inputname).value = '';
		   } 
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
        $dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;getLeaveDays();},oncleared:oncleaingFun});

      if(ismand == 1){
	   var hidename = $ele4p(inputname).value;
		 if(hidename != ""){
			$ele4p(inputname).value = hidename; 
			$ele4p(spanname).innerHTML = hidename;
		 }else{
		  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
	 }
}

/*********************************
 path: ../cpt/cpital/CptCapitalBack.jsp,CptCapitalDiscard.jsp,CptCapitalUse.jsp
*********************************/
function getdiscardDate(spanname,inputname){
	  var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalEdit.jsp
*********************************/
function getStockInDate(){
     WdatePicker({lang:languageStr,el:'getStockInDate',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('StockInDate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('StockInDate').value = ''}});
}

/*********************************
 path: ../cpt/capital/CptCapitalLend.jsp
*********************************/
function getlendDate(){
     var spanname ="lenddatespan";
	 var inputname = "lenddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalLoss.jsp
*********************************/
function getlossDate(){
    var spanname ="lossdatespan";
	 var inputname = "lossdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalMend.jsp
*********************************/
function getmendDate(){
	var spanname ="menddatespan";
	 var inputname = "menddate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalMove.jsp
*********************************/
function getmoveinDate(){
	var spanname ="moveindatespan";
	 var inputname = "moveindate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalInstock2.jsp
*********************************/
function getinstockDate(){
    var spanname ="instockdatespan";
	 var inputname = "instockdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalMoveOut.jsp
*********************************/
function getmoveoutDate(){
	var spanname ="moveoutdatespan";
	 var inputname = "moveoutdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalOther.jsp
*********************************/
function getotherDate(){
   var spanname ="otherdatespan";
	 var inputname = "otherdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalReturn.jsp
*********************************/
function getreturnDate(){
	var spanname ="returndatespan";
	 var inputname = "returndate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../cpt/capital/CptCapitalEdit.jsp
*********************************/
function getDeprestartdate(){
     WdatePicker({lang:languageStr,el:'deprestartdatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('deprestartdate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('deprestartdate').value = ''}});
}

/*********************************
 path: ../cpt/capital/CptCapitalEdit.jsp
*********************************/
function getmanuDate(){
     WdatePicker({lang:languageStr,el:'manudatespan',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('manudate').value =resubing.substring(0,7);},oncleared:function(dp){$dp.$('manudate').value = ''}});
}

/*********************************
 path: ../cpt/car/CptCapitalList.jsp,CptCapitalSalaryRp.jsp,CptCapitalSalaryTotalRp.jsp,CarUseRp.jsp,CarUseTotalRp.jsp
*********************************/
function getStartdate1(){
     WdatePicker({lang:languageStr,el:'startdate1span',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('startdate1').value =resubing;frmmain.submit();},oncleared:function(dp){$dp.$('startdate1').value = ''}});
}
function getStartdate2(){
     WdatePicker({lang:languageStr,el:'startdate2span',onpicked:function(dp){
	 var resubing =dp.cal.getDateStr(); $dp.$('startdate2').value =resubing;frmmain.submit();},oncleared:function(dp){$dp.$('startdate2').value = ''}});
}

/*********************************
 path: ../hrm/schedule/hrmPubHolidayAdd.jsp
*********************************/
function getholiday1Date(){
   WdatePicker({lang:languageStr,el:'holidaydatespan',onpicked:function(dp){
			$dp.$('holidaydate').value = dp.cal.getDateStr();
			if($dp.$('countryid').value != ''){$dp.$('operation').value = "selectdate";
			document.frmmain.submit();}},
				oncleared:function(dp){
				//$dp.$(holidaydate).value = '';
				document.getElementById('holidaydatespan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                $dp.$('holidaydate').value = '';
				}});
}

/*********************************
 path: ../cpt/cpital/CptCapitalBack.jsp,CptCapitalDiscard.jsp
*********************************/
function gethandoverDate(){
   var spanname ="handoverdatespan";
	 var inputname = "handoverdate";
     var returnvalue;
	  var oncleaingFun = function(){
		   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
           $ele4p(inputname).value = '';
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        $dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});

   var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	  $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
}

/*********************************
 path: ../voting/VotingAdd.jsp
*********************************/
function onShowVotingDate(spanname,inputname){	
	  var returnvalue;
	  var oncleaingFun = function(){
		   $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"); 
           $("#"+inputname).val('');
	      }
	   WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        jQuery("#"+inputname)[0].value = returnvalue;$dp.$(spanname).value = returnvalue;},oncleared:oncleaingFun});
        
        var hidename = $(inputname).value;
		 if(hidename != ""){
			$(inputname).value = hidename; 
			$(spanname).innerHTML = hidename;
		 }else{
		  $(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 }
}
/**
HRM ADD BY LVYI
**/
function getRSDate1(obj){
	var spanname = jQuery(obj).parent().find("span[name=showdate]");
	var inputname = jQuery(obj).parent().find("input").attr('name');
  WdatePicker({lang:languageStr,el:inputname,onpicked:function(dp){
			jQuery(spanname).html(dp.cal.getDateStr())},oncleared:function(dp){jQuery(spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");}});
}

/**
*以下是对日期的一些计算函数
*/
var now = new Date(); // 当前日期
var nowDayOfWeek = now.getDay(); // 今天本周的第几天
var nowDay = now.getDate(); // 当前日
var nowMonth = now.getMonth(); // 当前月
var nowYear = now.getYear(); // 当前年
nowYear += (nowYear < 2000) ? 1900 : 0; //

var lastMonthDate = new Date(); // 上月日期
lastMonthDate.setDate(1);
lastMonthDate.setMonth(lastMonthDate.getMonth() - 1);
var lastYear = lastMonthDate.getYear();
var lastMonth = lastMonthDate.getMonth();

// 格局化日期：yyyy-MM-dd
function formatDate(date) {
	var myyear = date.getFullYear();
	var mymonth = date.getMonth() + 1;
	var myweekday = date.getDate();

	if (mymonth < 10) {
		mymonth = "0" + mymonth;
	}
	if (myweekday < 10) {
		myweekday = "0" + myweekday;
	}
	return (myyear + "-" + mymonth + "-" + myweekday);
}

// 获得某月的天数
function getMonthDays(myMonth) {
	var monthStartDate = new Date(nowYear, myMonth, 1);
	var monthEndDate = new Date(nowYear, myMonth + 1, 1);
	var days = (monthEndDate - monthStartDate) / (1000 * 60 * 60 * 24);
	return days;
}

// 获得本季度的开端月份
function getQuarterStartMonth() {
	var quarterStartMonth = 0;
	if (nowMonth < 3) {
		quarterStartMonth = 0;
	}
	if (2 < nowMonth && nowMonth < 6) {
		quarterStartMonth = 3;
	}
	if (5 < nowMonth && nowMonth < 9) {
		quarterStartMonth = 6;
	}
	if (nowMonth > 8) {
		quarterStartMonth = 9;
	}
	return quarterStartMonth;
}

// 获得本周的开端日期
function getWeekStartDate() {
	var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek);
	return formatDate(weekStartDate);
}

// 获得本周的停止日期
function getWeekEndDate() {
	var weekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek));
	return formatDate(weekEndDate);
}

// 获得本月的开端日期
function getMonthStartDate() {
	var monthStartDate = new Date(nowYear, nowMonth, 1);
	return formatDate(monthStartDate);
}

// 获得本月的停止日期
function getMonthEndDate() {
	var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth));
	return formatDate(monthEndDate);
}

// 获得上月开端时候
function getLastMonthStartDate() {
	var lastMonthStartDate = new Date(lastMonth==11?nowYear-1:nowYear, lastMonth, 1);
	return formatDate(lastMonthStartDate);
}

// 获得上月停止时候
function getLastMonthEndDate() {
	var lastMonthEndDate = new Date(lastMonth==11?nowYear-1:nowYear, lastMonth, getMonthDays(lastMonth));
	return formatDate(lastMonthEndDate);
}

// 获得本季度的开端日期
function getQuarterStartDate() {

	var quarterStartDate = new Date(nowYear, getQuarterStartMonth(), 1);
	return formatDate(quarterStartDate);
}

// 或的本季度的停止日期
function getQuarterEndDate() {
	var quarterEndMonth = getQuarterStartMonth() + 2;
	var quarterStartDate = new Date(nowYear, quarterEndMonth,
			getMonthDays(quarterEndMonth));
	return formatDate(quarterStartDate);
}

//获取本年的开端日期
function getYearStartDate(){
	var yearStartDate = new Date(nowYear,0,1);
	return formatDate(yearStartDate);
}

//获取本年的结束日期
function getYearEndDate(){
	var yearEndDate = new Date(nowYear,11,31);
	return formatDate(yearEndDate);
}

//获取本年的开端日期
function getLastYearStartDate(){
	var yearStartDate = new Date(nowYear-1,0,1);
	return formatDate(yearStartDate);
}

//获取本年的结束日期
function getLastYearEndDate(){
	var yearEndDate = new Date(nowYear-1,11,31);
	return formatDate(yearEndDate);
}

//获取今天的日期
function getTodayDate(){
	return formatDate(now);
}
