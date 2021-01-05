import React from 'react';

class DetailSumCell extends React.Component {

    render() {
        const {symbol,fieldObj,modeField,data} = this.props;
        const fieldid = fieldObj?fieldObj.fieldid:"";
        const detailtype = fieldObj?fieldObj.type:"";
        let needSum = false;
        let colcalstr = modeField?modeField.colcalstr:{};

        if(colcalstr&&colcalstr[fieldid]){
            needSum = true
        }
        let showSumValue = "";
        if(needSum){
            let fieldSumValue = 0;
            let detailValue = data.data;
            for(var i=0;i<detailValue.length;i++){
                let fieldValue = detailValue[i][fieldid].value;
                if(!!fieldValue && !isNaN(fieldValue))
                    fieldSumValue += parseFloat(fieldValue)
            }
            let decimals = 2;
            if(fieldObj && detailtype == "2")
                decimals = 0;
            else if(fieldObj && (detailtype == "3" || detailtype == "5"))
                decimals = parseInt(fieldObj.get("qfws"));
            let thousands = detailtype == "5" ? 1 : 0;
            showSumValue = FormatFloatValue(fieldSumValue, decimals, thousands);
        }
        return <span>{showSumValue}</span>
    }
}


function FormatFloatValue(realval, decimals, thousands){
    //console.log("realval",realval,"decimals",decimals,"thousands",thousands)
	var regnum = /^(-?\d+)(\.\d+)?$/;
	if(!regnum.test(realval)){
		return realval;
	}
    realval = realval.toString();
	var formatval = "";
	if(decimals === 0){		//需取整
		formatval = Math.round(parseFloat(realval));
	}else{
        var n = Math.pow(10, decimals);
        formatval = Math.round(parseFloat(realval)*n)/n;
		var pindex = realval.indexOf(".");
		var pointLength = pindex>-1 ? realval.substr(pindex+1).length : 0;	//当前小数位数
		if(decimals > pointLength){		//需补零
            if(pindex == -1)
			    formatval += ".";
			for(var i=0; i<decimals-pointLength; i++){
				formatval += "0";
			}
		}
	}
	formatval = formatval.toString();
	var index = formatval.indexOf(".");
	var intPar = index>-1 ? formatval.substring(0,index) : formatval;
	var pointPar = index>-1 ? formatval.substring(index) : "";
	if(thousands===1){				//整数位format成千分位
   		var reg1 = /(-?\d+)(\d{3})/;
        while(reg1.test(intPar)) {   
        	intPar = intPar.replace(reg1, "$1,$2");   
        } 
	}
	formatval = intPar + pointPar;
	return formatval;
}

export default DetailSumCell