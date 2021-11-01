import React from 'react';
import  { Component} from 'react';
import NFT from './logo192.png';


class App extends Component {
  handleSubmit = () => {
        console.log(this.refs.input.value)   //方法一
       
      }
   render () {
        return (
      <div >
          <img src={NFT} alt=""/>
<br />
              highestprice: 1 ETC
         <br />
              yourprice:
               <input
                    type='number'
                    ref='input' defaultValue="" />
                    <button type='submit' onClick={this.handleSubmit}>Bid</button>
              
        </div>
     )
    }
}

export default App;
