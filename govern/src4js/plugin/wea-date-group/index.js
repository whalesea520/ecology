import { DatePicker, Select } from 'antd';
// import DatePicker from '../../_antd1.11.2/date-picker'
// import Select from '../../_antd1.11.2/select'
import cloneDeep from 'lodash/cloneDeep'
import isEmpty from 'lodash/isEmpty'
const Option = Select.Option;
import WeaSelect from '../wea-tools'

import './style/index.css'

class WeaDateGroup extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            startValue: null,
            endValue: null
        }
        if (!isEmpty(props.values) && !isEmpty(props.domkey)) {
            if (props.values[props.domkey[1]]) {
                this.state.startValue = new Date(props.values[props.domkey[1]]);
            }
            if (props.values[props.domkey[2]]) {
                this.state.endValue = new Date(props.values[props.domkey[2]]);
            }
        }
    }
    componentWillReceiveProps(nextProps) {
        const { value, domkey } = nextProps;
        if (this.props.value == '6' && value !== '6') {
            this.setState({
                startValue: null,
                endValue: null
            });
        }
    }
    // componentDidUpdate(prevProps){
    //   const {value,form,domkey} = this.props;
    //   if(prevProps.value == '6' && value !== '6' && form){
    //         let clear = {};
    //         clear[domkey[1]] = '';
    //         clear[domkey[2]] = '';
    //       form.setFieldsValue(clear);
    //   }
    // }
    //                  <Option value="0">全部</Option>
    //                  <Option value="1">今天</Option>
    //                  <Option value="2">本周</Option>
    //                  <Option value="3">本月</Option>
    //                  <Option value="4">本季</Option>
    //                  <Option value="5">本年</Option>
    //                  <Option value="7">上个月</Option>
    //                  <Option value="8">上一年</Option>
    //                  <Option value="6">指定日期范围</Option>
    render() {
        let that = this;
        let theProps = cloneDeep(this.props);
        const { datas, value, domkey, viewAttr } = this.props;
        let { selectValue, startValue, endValue } = this.state;
        let disabled = false;
        if (viewAttr == '1') disabled = true;
        let options = [];
        datas.map(d => {
            options.push({ key: d.value, selected: d.selected, showname: d.name })
        })
        return (
            <div className="wea-date-group">
                <Select defaultValue='0' style={{ width: '32%', minWidth: 100 }} {...theProps} disabled={disabled} size={'default'}
                    onChange={(v) => {
                        let { startValue = null, endValue = null } = this.state;
                        if (v != '6') {
                            startValue = null;
                            endValue = null;
                        }
                        this.setState({ selectValue: v, startValue, endValue });
                        this.props.onChange && this.props.onChange([v, startValue, endValue]);
                    }}>
                    {datas && datas.map(d => {
                        return <Option key={d.value} value={d.value} selected={d.selected}>{d.name}</Option>
                    })}
                </Select>
                {value === "6" && <DatePicker
                    disabled={disabled}
                    style={{ width: '32%', marginLeft: '2%', minWidth: 100 }}
                    format="YYYY-MM-DD"
                    disabledDate={current => { return this.state.endValue && current.getTime() >= this.state.endValue.getTime() }}
                    onChange={(a, b) => {
                        let { selectValue, endValue = null } = this.state;
                        this.setState({ startValue: b });
                        this.props.onChange && this.props.onChange([selectValue, b, endValue]);
                    }} />}
                {value === "6" && <DatePicker
                    disabled={disabled}
                    style={{ width: '32%', marginLeft: '2%', minWidth: 100 }}
                    format="YYYY-MM-DD"
                    disabledDate={current => { return this.state.startValue && current.getTime() <= this.state.startValue.getTime() }}
                    onChange={(a, b) => {
                        let { selectValue, startValue = null } = this.state;
                        this.setState({ endValue: b });
                        this.props.onChange && this.props.onChange([selectValue, startValue, b]);
                    }} />}
            </div>
        )
    }
}

export default WeaDateGroup