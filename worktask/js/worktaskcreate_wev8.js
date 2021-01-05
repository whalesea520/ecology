  
   //唯一标识uuid对象
   function UUID() {
     this.id = this.createUUID();
	}
	UUID.prototype.valueOf = function () {
		return this.id;
	}
	UUID.prototype.toString = function () {
		return this.id;
	}
    UUID.prototype.createUUID = function () {
		var dg = new Date(1582, 10, 15, 0, 0, 0, 0);
		var dc = new Date();
		var t = dc.getTime() - dg.getTime();
		var h = '-';
		var tl = UUID.getIntegerBits(t, 0, 31);
		var tm = UUID.getIntegerBits(t, 32, 47);
		var thv = UUID.getIntegerBits(t, 48, 59) + '1'; // version 1, security version is 2
		var csar = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
		var csl = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
		var n = UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
			UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
			UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
			UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
			UUID.getIntegerBits(UUID.rand(8191), 0, 15); // this last number is two octets long
		return tl + h + tm + h + thv + h + csar + csl + h + n;
	}
	UUID.getIntegerBits = function (val, start, end) {
		var base16 = UUID.returnBase(val, 16);
		var quadArray = new Array();
		var quadString = '';
		var i = 0;
		for (i = 0; i < base16.length; i++) {
			quadArray.push(base16.substring(i, i + 1));
		}
		for (i = Math.floor(start / 4); i <= Math.floor(end / 4); i++) {
			if (!quadArray[i] || quadArray[i] == '') quadString += '0';
			else quadString += quadArray[i];
		}
		return quadString;
	}
	UUID.returnBase = function (number, base) {
		var convert = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
		if (number < base) var output = convert[number];
		else {
			var MSD = '' + Math.floor(number / base);
			var LSD = number - MSD * base;
			if (MSD >= base) var output = this.returnBase(MSD, base) + convert[LSD];
			else var output = convert[MSD] + convert[LSD];
		}
		return output;
	}
	UUID.rand = function (max) {
		return Math.floor(Math.random() * max);
}


  /** * 对Date的扩展，将 Date 转化为指定格式的String * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、周(E)、季度(q)
    可以用 1-2 个占位符 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) * eg: * (new
    Date()).pattern("yyyy-MM-dd hh:mm:ss.S")==> 2006-07-02 08:09:04.423      
 * (new Date()).pattern("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 二 20:09:04      
 * (new Date()).pattern("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 周二 08:09:04      
 * (new Date()).pattern("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 星期二 08:09:04      
 * (new Date()).pattern("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18      
 */        
Date.prototype.pattern = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//添加任务清单
$(".addwt").click(function(){
	 var cdate = new Date().pattern("yyyy-MM-dd");
	 var tasklist = {
			 tasklistcontent : '',
			 tasklistenddate : cdate,
			 userid : '',
			 username : '',
			 id : ''
			 
	 };
	 //默认添加当前日期
	 addTask(tasklist);
});

function addTask(tasklist){
	  
	  var cdate = new Date().pattern("yyyy-MM-dd");
	  var htmlarray = [],tr;
	  htmlarray.push("<tr>");
	  htmlarray.push("<td width='3%'><input type='checkbox'><input type='hidden' name='tasklistid'  value='"+(tasklist.tasklistid===undefined?'':tasklist.tasklistid)+"'></td>");
	  htmlarray.push("<td width='46%' ><input type='text' name='tasklistcontent' placeholder='"+SystemEnv.getHtmlNoteName(3607,languageid)+"' value='"+tasklist.tasklistcontent+"'/></td>");
	  htmlarray.push("<td width='25%'><img src='../images/datepic_wev8.png' class='datepic' onclick='addDatePicker(this);'><span>"+tasklist.tasklistenddate+"</span><input value='"+tasklist.tasklistenddate+"' type='hidden' name='tasklistenddate'/></td>");
	  htmlarray.push("<td width='25%'><img src='../images/user_wev8.png'><span class='chargername resourceselection'></span></td>");
	  htmlarray.push("</tr>");
	  tr = $(htmlarray.join(""));
     //美化表单元素
	  $(".listbody").find("table").append(tr);
	  //美化check框
	  tr.jNice();
	  //为input添加placeholder属性
	  tr.find("input[type='text']").placeholder();
	  var browcontainer = tr.find(".chargername");
	  generatorResourceBrow(browcontainer,tasklist.userid,tasklist.username);
	
}



//删除任务清单
$(".deletewt").click(function(){
	var checkedItem = $(".worktasklist .listbody").find(".jNiceChecked");
	if(checkedItem.length === 0){
 	   window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3608,languageid)+"!");
 	   return;
    }
    window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(3611,languageid),function(){
       $(".worktasklist .listbody").find(".jNiceChecked").parents("tr").remove()
   });
   

});

$(".tabheader li").click(function(){
	//移除选中的tab样式
   $(".tabheader li").removeClass("firsttabselected").removeClass("tabselected");
   $(".worktasktabs .panel").hide();
   var current = $(this);
   var tabpanel = current.attr("tabitem");
   $("#"+tabpanel).show();
   if(current.prev("li").length===0){
       current.addClass("firsttabselected");
   }else{
       current.addClass("tabselected");
   }

});


/*初始化tab页**/
function initTabs(){
 var tabheader = $(".tabheader");
 pageType = '2';
 if(pageType==='1'){
   //只展示相关资源和任务提醒tab页 
    tabheader.find("li[tabitem='taskexchange']").remove();
    tabheader.find("li[tabitem='tasklog']").remove();
    $("#taskexchange").remove();
	$("#tasklog").remove();
	tabheader.find("li[tabitem='taskresource']").trigger("click");
 }else{
    tabheader.find("li[tabitem='taskexchange']").trigger("click");
 }

}


