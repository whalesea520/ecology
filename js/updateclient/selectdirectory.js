$(document).ready(function()
{
	//alert(0);
	if($("#ecologyPath").val()!=""){
    	 $("#ecologytitle").html("ecology安装目录");
      }
      if($("#ecologyPath").val()=="")
      {
          $("#divecologyPath").html("此项必填！");
      }
      else
      {
          $("#divecologyPath").html();
      }
	$("#savedata").click(function(){
		dosave();
    });
	var isconnect = $("#isconnect").val();
	if("1" == isconnect) {
		showEle("addresstr");
	} else {
		hideEle("addresstr");
	}
	
	var upgradeBackup = $("#upgradeBackup").val();
	if(upgradeBackup=="") {
		$("#divupgradeBackup").html("此项必填！");
	}
	//alert($(parent.parent.document).find(".liCss2").length);
	$(parent.parent.document).find(".liCss2").removeClass("leftsubmenuselected");
	$(parent.parent.document).find(".leftMenuSelected").removeClass("leftMenuSelected");
	$(parent.parent.document).find(".liCss2").eq(0).addClass("leftsubmenuselected");
	$(parent.parent.document).find(".liCss2").eq(0).children("div.leftMenuItemCenter").addClass("leftMenuSelected");
 });

function dosave() {
	  var iscansave = true;
      if($("#upgradeBackup").val()==""){
          $("#divupgradeBackup").html("此项必填！");
          iscansave = false;
      }else{
          $("#divupgradeBackup").html();
      }
      
      var customer = $("#customer").val();
      var manager = $("#manager").val();
     
      var beginTime = $("#beginTime").val();
      //var beginTime = $("#beginTime option:selected").val();
      
      
      var issysadmin = $("#issysadmin option:selected").val();

      
      var remindtype = "";
      $("input[name='remindtype']").each(function(){
    	  if($(this).attr("checked")) {
    		  remindtype=remindtype+$(this).val()+",";
    	  }
      });
      //var phone = $("#phone").val();
      //var mail = $("#mail").val();
      //var address = $("#address").val();
/*      var reg = new RegExp("^[1][0-9]{10}$");
      if(phone != "") {
          if(!reg.test(phone)) {
        	  top.Dialog.alert("手机号码格式不正确！");
        	  $("#spanphone").html("手机号码格式不正确！");
        	  return;
          } else {
        	  $("#spanphone").html("");
          }
      }
      if(mail!= "") {
          reg = new RegExp("^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+");
          if(!reg.test(mail)) {
        	  top.Dialog.alert("邮箱格式不正确！");
        	  $("#spanmail").html("邮箱格式不正确！");
        	  return;
          } else {
        	  $("#spanmail").html("");
          } 
      }*/
      

      
      var isconnect= $("#isconnect").attr("checked") == true ? "1":"0";
      var isclusters = $("#isclusters").attr("checked") == true ? "1":"0";
      var isemobile = $("#isemobile").attr("checked") == true ? "1":"0";
      var isemessage = $("#isemessage").attr("checked") == true ? "1":"0";
      if(iscansave)
      {
	      $.get('/writeprop.do?date='+(new Date()).valueOf(),{
	    	  "upgradeBackup":$("#upgradeBackup").val(),
	    	  "emessagepath":$("#emessagepath").val(),
	    	  "emobilepath":$("#emobilepath").val(),
	    	  "clusters":$("#clusters").text(),
	    	  "isclusters":isclusters,
	    	  "isemobile":isemobile,
	    	  "isemessage":isemessage,
	    	  "manager":$("#manager").val(),
	    	  "isconnect":isconnect,
	    	  "remindtype":remindtype,
	    	  "issysadmin":issysadmin,
	    	  "beginTime":beginTime,
	    	  "customer":customer
	    	  },function(data){
	      	if(data.indexOf("ecologynotexists")>-1)	{
	      		$("#divupgradeBackup").html("目录不存在,请重新填写!");
	      	} else if(data.indexOf("emobilenotexists")>-1){
	      		$("#emobilepathspan").html("EMobile目录不存在,请重新填写!");
	      	} else if(data.indexOf("emessagenotexists")>-1){
	      		$("#emessagepathspan").html("EMessage目录不存在,请重新填写!");
	      	} else {
	      		document.location="/jsp/selectdirectory.jsp";
	      		top.Dialog.alert("修改成功");
	      	}
	      });
      }
}

function showAddress() {
	var checked = $("#isconnect").attr("checked");
	if(checked) {
		hideEle("addresstr");
	} else {
		showEle("addresstr");
	}
}

function changetime(val) {
	$("#beginTime").val(val);
}