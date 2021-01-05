
var state=0;

function record2(){
	var presstimeout = undefined;
	var $form_msg = $(".form_msg");
	var $canvas = $("#canvas");
	$(".microphone").click(function(){
		if(state==0){
			presstimeout = setTimeout(function(){
				location = "emobile:speechUnderstand:voiceBackUnderstand:voiceBackErr"; 
				state=1;
				$form_msg.html("开始录音，再次点击进行识别");
				$form_msg.show();
				$canvas.show();
				$(".microphone").attr("src","/mobile/plugin/crm_new/images/translation_.png");
		 	}, 250);
		}
		else{
			clearTimeout(presstimeout);
     		state=0;
     		stopVoice();
			$form_msg.hide();
     		$form_msg.html("正在识别");
     		$form_msg.show();
			$canvas.show();
			$(".microphone").attr("src","/mobile/plugin/crm_new/images/translation.png");
		}
	});
}
	
	//停止语音
	function stopVoice(){
		setTimeout(function(){
			$(".microphone").css("filter","none");
			location="emobile:stopVoice";
		},200);
	}
	
	//语音识别回调
    function voiceBackUnderstand(str){
    	//时间戳
    	var obj = eval("("+str+")");
		$("textarea[name='description']").val($("textarea[name='description']").val()+obj.text);
		$(".form_msg").hide();
		$("#canvas").hide();
		
	}
    function voiceBackErr(str){
    	//时间戳
    	$(".form_msg").html("未识别到语音");
		$("#canvas").hide();
		setTimeout(function(){
			$(".form_msg").hide();
		},2000);
	}