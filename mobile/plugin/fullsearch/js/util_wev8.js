String.prototype.startWith=function(str){  
            if(str==null||str==""||this.length==0||str.length>this.length)  
              return false;  
            if(this.substr(0,str.length)==str)  
              return true;  
            else  
              return false;  
            return true;  
}
 
String.prototype.endWith=function(str){  
    if(str==null||str==""||this.length==0||str.length>this.length)  
      return false;  
    if(this.substring(this.length-str.length)==str)  
      return true;  
    else  
      return false;  
    return true;  
} 
 
String.prototype.replaceAll = function(s1,s2){  
	return this.replace(new RegExp(s1,"gm"),s2);  
} 

String.prototype.trim=function(){
　　 return this.replace(/(^\s*)|(\s*$)/g, "");
}

String.prototype.ltrim=function(){
　　 return this.replace(/(^\s*)/g,"");
}

String.prototype.rtrim=function(){
　　 return this.replace(/(\s*$)/g,"");
}

function trimQuotes(key){
	if(key.startWith("“")){
		key=key.substring(1);
	}
	if(key.endWith("”")){
		key=key.substring(0,key.length-1);
	}
	return key;
}

function trimHtmlTag(key){
	key=key.replaceAll("</?[^>]+>", "").replaceAll("&nbsp;", " ");
	return key
}


function addQuotes(key){
	if(!key.startWith("“")){
		key="“"+key;
	}
	if(!key.endWith("”")){
		key=key+"”";
	}
	return key;
}

$.fn.longPress = function(fn) {
    var timeout = undefined;
    var $this = this;
    for(var i = 0;i<$this.length;i++){
        $this[i].addEventListener('touchstart', function(event) {
            timeout = setTimeout(fn, 350);
            }, false);
        $this[i].addEventListener('touchend', function(event) {
            clearTimeout(timeout);
            }, false);
    }
}


var chnNumChar = {
  零:0,
  一:1,
  二:2,
  三:3,
  四:4,
  五:5,
  六:6,
  七:7,
  八:8,
  九:9,
  两:2
};

var chnNameValue = {
  十:{value:10, secUnit:false},
  百:{value:100, secUnit:false},
  千:{value:1000, secUnit:false},
  万:{value:10000, secUnit:true},
  亿:{value:100000000, secUnit:true}
}

function ChineseToNumber(chnStr){
  var rtn = 0;
  var section = 0;
  var number = 0;
  var secUnit = false;
  var str = chnStr.split('');
 
  for(var i = 0; i < str.length; i++){
    var num = chnNumChar[str[i]];
    if(typeof num !== 'undefined'){
      number = num;
      if(i === str.length - 1){
        section += number;
      }
    }else{
      if(number==0) number=1;
      var unit = chnNameValue[str[i]].value;
      secUnit = chnNameValue[str[i]].secUnit;
      if(secUnit){
        section = (section + number) * unit;
        rtn += section;
        section = 0;
      }else{
        section += (number * unit);
      }
      number = 0;
    }
  }
  return rtn + section;
}


function ChineseAmountToNumber(str){
		var seps = new Object();
		seps["元"] = 1;
		seps["块"] = 1;
		seps["十"] = 10;
		seps["拾"] = 10;
		seps["百"] = 100;
		seps["佰"] = 100;
		seps["千"] = 1000;
		seps["仟"] = 1000;
		seps["万"] = 10000;
		seps["亿"] = 100000000;
		seps["角"] = 0.1;
		seps["毛"] = 0.1;
		seps["分"] = 0.01;


		var nums = new Object();
		nums["零"] = 0;
		nums["一"] = 1;
		nums["壹"] = 1;
		nums["二"] = 2;
		nums["贰"] = 2;
		nums["两"] = 2;
		nums["三"] = 3;
		nums["叁"] = 3;
		nums["四"] = 4;
		nums["肆"] = 4;
		nums["五"] = 5;
		nums["伍"] = 5;
		nums["六"] = 6;
		nums["陆"] = 6;
		nums["七"] = 7;
		nums["柒"] = 7;
		nums["八"] = 8;
		nums["捌"] = 8;
		nums["九"] = 9;
		nums["玖"] = 9;
		 
 
		var temp = "0";
		var rtn=0;
		var currentUnits=1;
		var units=[1,0.1,0.01];
		strFor:
		for(var i =0;i<str.length;i++){

			for(var key in seps){
				if(str.charAt(i)==key){
					if(parseFloat(temp)>0){
						rtn += parseFloat(temp) * parseFloat(seps[key]);
					}else{
						rtn = rtn * parseFloat(seps[key]);
					}
					currentUnits=parseFloat(seps[key]);
					temp="0";
					continue strFor;
				}
			}

			for(var key in nums){
				if(str.charAt(i) == key){
					temp += "" + nums[key];
					continue strFor;
				}
			}
			temp += "" + str.charAt(i);
		}
		
		if(rtn==0){
			rtn=parseFloat(temp);
		}else{
			if(parseFloat(temp)>0){
				var needUnits=1;
				for(var i= 0;i<units.length;i++){
					if(units[i]==currentUnits){
						if((i+1)<=units.length){
							needUnits=units[i+1];
							break;
						}
					} 
				}  
				rtn+=parseFloat(temp)*needUnits;
			}
		}
		return rtn.toFixed(2);
	}
	
function ChineseMonthToNumber(month){
	var m="";
	var monthStr = new Object();
	monthStr["一"] = 1;
	monthStr["二"] = 2;
	monthStr["三"] = 3;
	monthStr["四"] = 4;
	monthStr["五"] = 5;
	monthStr["六"] = 6;
	monthStr["七"] = 7;
	monthStr["八"] = 8;
	monthStr["九"] = 9;
	monthStr["十"] = 10;
	monthStr["十一"] = 11;
	monthStr["十二"] = 12;
	for(var key in monthStr){
		if(month==key){
			m=monthStr[key];
			break;
		}
	}
	return m;
}