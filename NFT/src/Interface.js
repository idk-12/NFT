import React, { Component } from 'react';
import App from './App'

let web3 = require('./InitWeb3');
let auction = require('./api')

class Interface extends Component {
         play = async () => {
        console.log('play Button click')
       
        this.setState({ isClicked: true })
        let accounts = await web3.eth.getAccounts()
        try {
            await auction.methods.play().send({
                from: accounts[0],
                value: web3.utils.toWei('0.1', 'ether'),
                gas: '3000000',
            })
            window.location.reload()
            this.setState({ isClicked: false })
            alert('出价成功')
        } catch (e) {
            console.log(e)
            this.setState({ isClicked: false })
            alert('出价失败')
        }
    }
    constructor() {
       super()
       this.state = {
             buyer: '',
             seller: '',
             highestbiding:'',
             amount:'',
       }
    }

  async componentWillMount() {
        //获取当前的所有地址
        let buyer = await web3.eth.getAccounts()
        ler seller = await auction.methods._beneficiary().call()
