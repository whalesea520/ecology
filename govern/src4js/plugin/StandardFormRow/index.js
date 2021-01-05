import React from 'react';

import './index.css'

class standardFormRow extends React.Component {

  render() {
    const { title, children, after } = this.props;
    return (
      <div className={"standardFormRow" + after} >
        {
          title && (
            <div className="label">
              <span>{title}</span>
            </div>
          )
        }
        < div className="content" >
          {children}
        </div >
      </div >
    )
  }
}

export default standardFormRow;