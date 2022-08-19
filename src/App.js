import './App.css';

import { NavigationBar } from './components/NavigationBar';
import { AddCar } from './components/addcar';
import { useState, useEffect, useCallback } from "react";


import Web3 from "web3";
import { newKitFromWeb3 } from "@celo/contractkit";
import BigNumber from "bignumber.js";


import Carcompanies from "./contracts/Carcompanies.abi.json";
import IERC from "./contracts/IERC.abi.json";
import { Cars } from './components/Cars';


const ERC20_DECIMALS = 18;


const contractAddress = "0xB68D376CdB9b3007cca697C3FbB92C39dBa3aFB7";
const cUSDContractAddress = "0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1";



function App() {
  const [contract, setcontract] = useState(null);
  const [address, setAddress] = useState(null);
  const [kit, setKit] = useState(null);
  const [cUSDBalance, setcUSDBalance] = useState(0);
  const [car, setCars] = useState([]);


  const connectToWallet = async () => {
    if (window.celo) {
      try {
        await window.celo.enable();
        const web3 = new Web3(window.celo);
        let kit = newKitFromWeb3(web3);

        const accounts = await kit.web3.eth.getAccounts();
        const user_address = accounts[0];

        kit.defaultAccount = user_address;

        await setAddress(user_address);
        await setKit(kit);
      } catch (error) {
        console.log(error);
      }
    } else {
      alert("Error Occurred");
    }
  };

  const getBalance = useCallback(async () => {
    try {
      const balance = await kit.getTotalBalance(address);
      const USDBalance = balance.cUSD.shiftedBy(-ERC20_DECIMALS).toFixed(2);

      const contract = new kit.web3.eth.Contract(Carcompanies, contractAddress);
      setcontract(contract);
      setcUSDBalance(USDBalance);
    } catch (error) {
      console.log(error);
    }
  }, [address, kit]);



  const getCar = useCallback(async () => {
    const carLength = await contract.methods.getCarLength().call();
    const cars = [];
    for (let index = 0; index < carLength; index++) {
      let _cars = new Promise(async (resolve, reject) => {
      let car = await contract.methods.getCar(index).call();

        resolve({
          index: index,
          owner: car[0],
          brand: car[1],
          model: car[2],
          image: car[3],
          likes: car[4],
          dislikes: car[5],
          price: car[6],
          carsAvailable: car[7],
          numberOfreview: car[8],
          reviews: car[9]   
        });
      });
      cars.push(_cars);
    }


    const _cars = await Promise.all(cars);
    setCars(_cars);
  }, [contract]);


  const addCar = async (
    _brand,
    _model,
    _image,
    price,
    _carsAvailable) => {
      const _price = new BigNumber(price).shiftedBy(ERC20_DECIMALS).toString();

    try {
      await contract.methods
        .addCar(_brand, _model, _image, _price, _carsAvailable)
        .send({ from: address });
      getCar();
    } catch (error) {
      alert(error);
    }
  };



const likeCar = async (index) => {
    try {
      await contract.methods.likesCar(index).send({ from: address });
    } catch (error) {
      console.log(error);
    } finally {
      getCar();
    }
  };
  const dislikeCar = async (index) => {
    try {
      await contract.methods.dislikesCar(index).send({ from: address });
    } catch (error) {
      console.log(error);
    } finally {
      getCar();
    }
  };


  const addReview = async (
    _index,
    _review
  ) => {
    try {
      await contract.methods
        .addReview(_index, _review)
        .send({ from: address });
      getCar();
    } catch (error) {
      alert(error);
    }
  };



    const BuyCar = async (_index) => {
      const cUSDContract = new kit.web3.eth.Contract(IERC, cUSDContractAddress);
      try {
        
        await cUSDContract.methods
          .approve(contractAddress, car[_index].price)
          .send({ from: address });
        await contract.methods.buyCar(_index).send({ from: address });
        getCar();
        getBalance();
        alert("Congratulations on your successful purchase, cheer!!!");
      } catch (error) {
        alert(error);
      }};


  useEffect(() => {
    connectToWallet();
  }, []);

  useEffect(() => {
    if (kit && address) {
      getBalance();
    }
  }, [kit, address, getBalance]);

  useEffect(() => {
    if (contract) {
      getCar();
    }
  }, [contract, getCar]);
  
  return (
    <div className="App">
      <NavigationBar cUSDBalance={cUSDBalance} />
      <Cars 
      userWallet={address}

      Cars={car} 
      addReview={addReview} 
      buyCar={BuyCar}
      likeCar={likeCar}
      dislikeCar={dislikeCar}/>
      <AddCar addCar={addCar} />
    </div>
  );
}

export default App;
 