import {Input} from 'antd';
// import Input from '../../../_antd1.11.2/input'
import cloneDeep from 'lodash/cloneDeep'
import trim from 'lodash/trim'
import classNames from 'classnames'

const pClasses = ['isWeak','isWeak','isWeak','isWeak','isMiddle','isMiddle','isMiddle','isStrong','isStrong','isStrong','isStrong'];
const tips = ['弱','弱','弱','弱','中','中','中','强','强','强','强']

function getPasswordStrength(v){
    var n = 0;
    if (v.match(/\d/)) n += 10;
    if (v.length > 5) n += 20;
    if (v.match(/[a-z]+/)) n += 20;
    if (v.match(/[A-Z]+/)) n += 20;
    if (v.match(/[^\da-zA-Z]/)) n += 30;
    return n;
}

function getPasswordStrengthCT(v, isTip = false) {
    if (v) {
        let t = getPasswordStrength(v) / 10;
        if (isTip) return tips[t];
        return pClasses[t];
    }
}

class Main extends React.Component {
    static defaultProps={
        type: 'text',
        passwordStrength: false,
    }
    constructor(props) {
        super(props);
        this.state = {
            value: props.defaultValue || props.value || "",
        };
    }
    componentWillReceiveProps(nextProps) {
        if(this.props.value!==nextProps.value) {
            this.setState({
                value:nextProps.value
            });
        }
        if(this.props.defaultValue!==nextProps.defaultValue) {
            this.setState({
                value:nextProps.defaultValue
            });
        }
    }
    shouldComponentUpdate(nextProps, nextState) {
        return nextProps.value !== this.props.value ||
                nextProps.defaultValue !== this.props.defaultValue ||
                nextProps.viewAttr!==this.state.viewAttr ||
                nextState.value !== this.state.value;
    }
    getValue() {
        if (this.refs.inputNormal) return trim(this.state.value);
    }
    render() {
        const {value} = this.state;
        let {viewAttr, style, fieldname, hasBorder, underline, tip, tipLength, passwordStrength, passwordStrengthIdx = 0} = this.props;
        let theProps = cloneDeep(this.props);
        delete theProps.style;
        theProps.value = value;
        let eles;
        const req = classNames({
            'required': (viewAttr === 3 || viewAttr === '3') && trim(value).length === 0,
        });
        const readonly = classNames({
            'border': hasBorder,
            'underline': underline,
        });
        if (viewAttr == '1') {
            return (
                <div className={`wea-field-readonly ${readonly} ${this.props.className || ''}`} style={style}>
                    <span className="child-item wdb" dangerouslySetInnerHTML={{__html: value}}>
                    </span>
                </div>
            )
        } else {
            eles = <Input
                {...theProps} onChange={this.setText.bind(this)}
                onBlur={this.onBlur.bind(this)}
                onFocus={this.onFocus.bind(this)} />
        }
        return (
            <div className={`wea-input-normal ${req} ${this.props.className || ''}`} style={style} ref="inputNormal">
                {eles}
                {tip && <span className="tip" style={{marginLeft: 13}} dangerouslySetInnerHTML={{__html: tip}}></span>}
                {passwordStrength && value &&
                    <div className="password-strength-wrap">
                        <span className={`password-strength ${getPasswordStrengthCT(value)}`}></span>
                        {getPasswordStrengthCT(value, true)}
                    </div>
                }
                <input type="hidden" id={fieldname} name={fieldname} value={value} />
            </div>
        )
    }
    setText(e) {
        if (this.props.length && trim(e.target.value).length > this.props.length) {
            alert(`最长不能超过${this.props.length}个字符`);
            return;
        }
        this.setState({
            value:e.target.value
        });
        this.props.onChange && this.props.onChange(e.target.value);
    }
    onBlur(e) {
        this.props.onBlur && this.props.onBlur(e.target.value);
    }
    onFocus(e) {
        this.props.onFocus && this.props.onFocus(e.target.value);
    }
}

export default Main;