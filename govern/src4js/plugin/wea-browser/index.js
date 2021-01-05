import { Select, Button } from 'antd';

import './style/index.css'
const Option = Select.Option;
import * as Util from '../../util/DbUtil'

class weaBrowser extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            valueData: [],
            value: "",
            valueMult: []
        };
    }

    componentWillReceiveProps(nextProps) {
        if (this.state.valueData !== nextProps.valueData) {
            let valueData = nextProps.valueData;
            let valueMult = [];
            let value = "";
            valueData.map((d) => {
                if (d.id) {
                    valueMult.push(d.id);
                    value += ("," + d.id);
                }
            });
            if (value)
                value = value.substring(1);
            this.setState({ value, valueData, valueMult });
        }
    }

    render() {
        const { ismult } = this.props;
        //let { valueMult, valueData } = this.state;
        let { valueMult, valueData } = this.props;
        let values = [];
        let options = [];
        valueData.map((d) => {
            if (d.id) {
                values.push(d.id)
                options.push(<Option title={d.title || d.name} key={d.id}>{d.name}</Option>)
            }
        });
        let select = <Select
            fieldName="modeTabSelect"
            hasScroll={true}
            onInputBlur={() => { this.setState({ inputVisible: false }) }}
            title="标签"
            hideSelected={true}
            transitionName=""
            animation=""
            placeholder=""
            value={values}
            multiple={true}
            notFoundContent=""
            defaultActiveFirstOption={true}
            onDeselect={this.handleDeselect}
            showArrow={false}
            filterOption={false}
            selectedClose={true}
            dropdownStyle={{ display: "none" }}
            onChange={(v) => {
                console.log("changeValue", v);
            }}
        >
            {options}
        </Select>

        const { style } = this.props;
        return (
            <div className={`wea-db-search wea-db-single`} style={style} ref="searchWrapper">
                {select}
                <div className="ant-input-group-wrap">
                    <Button type="ghost" icon="search" onClick={this.handleClick} />
                </div>
            </div>
        )
    }

    handleDeselect = (value) => {
        const { ismult } = this.props;
        if (ismult) {//多选
            let { valueData, valueMult } = this.state;
            let _valueMult = [];
            let _valueData = [];
            let _value = "";
            for (let i = 0; i < valueData.length; i++) {
                let va = valueData[i];
                if (va.id !== value) {
                    valueData.push(va);
                    valueMult.push(va.id);
                    _value += "," + va.id;
                }
            }
            if (_value != "")
                _value = _value.substring(1);
            this.setState({ value: _value, valueData: _valueData, valueMult: _valueMult });
            this.props.onChange(_value, _valueData);
        } else {
            this.setState({ value: "", valueMult: [], valueData: [] });
            this.props.onChange("", [])
        }
    }

    handleClick = () => {
        let _this = this;
        let url = this.props.url;
        if (this.state.value)
            url += "?selectedids=" + this.state.value
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        //dialog.callbackfunParam = null;
        dialog.URL = url;
        dialog.callbackfun = function (paramobj, id1) {
            try {
                const { ismult } = _this.props;
                if (ismult) {//多选
                    let value = id1.id;
                    let name = id1.name;
                    let va = value.split(",");
                    let na = name.split(",");
                    let valueData = [];
                    let valueMult = [];
                    for (let i = 0; i < va.length; i++) {
                        valueData.push({ id: va[i], name: na[i] });
                        valueMult.push(va[i]);
                    }
                    _this.setState({ value, valueData, valueMult });
                    _this.props.onChange(value, valueData);
                } else {//单选
                    let value = id1.id;
                    let valueData = [{ id: id1.id, name: id1.name }];
                    let valueMult = [value];
                    console.log(paramobj, id1, value, valueMult, valueData);
                    _this.setState({ value, valueMult, valueData });
                    _this.props.onChange(value, valueData)
                }
            } catch (e) {
                console.log(e);
            }
        }
        dialog.Title = "请选择";//请选择
        dialog.Width = 550;
        if (url.indexOf("/MutiResourceBrowser.jsp") != -1) {
            dialog.Width = 648;
        }
        dialog.Height = 600;
        dialog.Drag = true;
        //dialog.maxiumnable = true;
        dialog.show();
    }
}

export default weaBrowser