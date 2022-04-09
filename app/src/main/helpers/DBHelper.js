import { useState, createContext } from 'react';
import Axios from "axios";

const DBHelper = createContext({
    loading: false,

    customerList: [],
    fetchCustomerList: ()=>{},
    fetchCustomerByName: ()=>{},
    customerID: "",
    reservationList: [],
    fetchReservationList: ()=>{},

    roomTypeList: [],
    fetchRoomTypeList: ()=>{},
    roomTypeID: 0,
    insertRoomType: ()=>{},
    bedResponse: "",
    insertBed: ()=>{},
    supplyResponse: "",
    insertSupplyType: ()=>{},
    supplyTypeList: [],
    fetchSupplyType: ()=>{},

    // roomsAvailable: [],
    // fetchRoomsAvailable: ()=>{},

    roomList: [],
    fetchRoomList: (customerID, phoneNumber, IDCardNumber)=>{},

    branchList: [],
    fetchBranchList: ()=>{},

    branchCustomerStatistic: [],
    fetchBranchCustomerStatisticByIDAndYear: ()=>{}
})

export function DBHelperProvider(props){
    const [customerList, setCustomerList] = useState([]);
    const [reservationList, setReservationList] = useState([]);
    const [roomTypeList, setRoomTypeList] = useState([]);
    const [roomTypeID, setRoomTypeID] = useState(0);
    const [bedResponse, setBedResponse] = useState("");
    const [supplyResponse, setSupplyResponse] = useState("");
    const [supplyTypeList, setSupplyTypeList] = useState([]);
    // const [roomsAvailable, setRoomsAvailable] = useState([]);
    const [roomList, setRoomList] = useState([]);
    const [branchList, setBranchList] = useState([]);
    const [branchCustomerStatistic, setBranchCustomerStatistic] = useState([]);
    const [loading, setLoading] = useState(false);


    function fetchCustomerListHandler() {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/getcustomerlist/").then(
            (response)=>{
                setCustomerList(response.data[0]);
                setLoading(false);
            }
        )
    }

    function fetchCustomerByNameHandler(name) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/getcustomerbyname/", {
            params: {
                name: name
            }
        }).then(
            (response)=>{
                setCustomerList(response.data[0]);
                setLoading(false);
            }
        )
    }

    function fetchReservationListHandler(customerID) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/getreservation/", {
            params: {
                customerID: customerID
            }
        }).then(
            (response)=>{
                setReservationList(response.data[0]);
                setLoading(false);
            }
        )
    }

    function fetchRoomTypeListHandler() {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/getroomtypelist/").then(
            (response)=>{
                setRoomTypeList(response.data[0]);
                setLoading(false);
            }
        )
    }

    function insertRoomTypeHandler(name, area, maxGuest, description) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/insertroomtype/", {
            params: {
                name: name,
                area: area,
                maxGuest: maxGuest,
                description: description
            }
        }).then(
            (response)=>{
                setRoomTypeID(response.data[0] && response.data[0][0]["ID"]);
                setLoading(false);
            }
        )
    }

    function insertBedHandler(size, quantity) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/insertbedinfo/", {
            params: {
                roomTypeID: roomTypeID,
                size: size,
                quantity: quantity
            }
        }).then(
            (response)=>{
                setBedResponse(response.data[0]);
                setLoading(false);
            }
        )
    }

    function fetchSupplyTypeHandler() {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/getsupplytype/").then(
            (response)=>{
                setSupplyTypeList(response.data[0]);
                setLoading(false);
            }
        )
    }

    function insertSupplyTypeHandler(name, quantity) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/insertsupplytype/", {
            params: {
                name: name,
                roomTypeID: roomTypeID,
                quantity: quantity
            }
        }).then(
            (response)=>{
                setSupplyResponse(response.data[0]);
                setLoading(false);
            }
        )
    }
    // function fetchRoomsAvailableHandler(data) {
    //     setLoading(true);
    //     Axios.get('http://localhost:3001/api/getroom').then(
    //         (response)=>{
    //             // setRoomsAvailable(response.data);
    //             setLoading(false);
    //         }
    //     )
    // }

    function fetchRoomListHandler(customerID, phoneNumber, IDCardNumber) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/guest/getroom/", {
            params: {
                customerID: customerID,
                phoneNumber: phoneNumber,
                IDCardNumber: IDCardNumber
            }
        }).then(
            (response)=>{
                setRoomList(response.data[0]);
                setLoading(false);
            }
        )
    }

    function fetchBranchListHandler(data) {
        setLoading(true);
        Axios.get('http://localhost:3001/api/getbranch').then(
            (response)=>{
                setBranchList(response.data);
                setLoading(false);
            }
        )
    }

    function fetchBranchCustomerStatisticByIDAndYearHandler(branchID, year) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/admin/getBranchStatistic/", {
            params: {
                branchID: branchID,
                year: year
            }
        }).then(
            (response)=>{
                setBranchCustomerStatistic(response.data[0]);
                setLoading(false);
            }
        )
    }

    const context = {
        loading: loading,

        customerList: customerList,
        fetchCustomerList: fetchCustomerListHandler,
        fetchCustomerByName: fetchCustomerByNameHandler,
        reservationList: reservationList,
        fetchReservationList: fetchReservationListHandler,

        roomTypeList: roomTypeList,
        fetchRoomTypeList: fetchRoomTypeListHandler,
        roomTypeID: roomTypeID,
        insertRoomType: insertRoomTypeHandler,
        bedResponse: bedResponse,
        insertBed: insertBedHandler,
        
        supplyTypeList: supplyTypeList,
        fetchSupplyType: fetchSupplyTypeHandler,
        supplyResponse: supplyResponse,
        insertSupplyType: insertSupplyTypeHandler,

        // roomsAvailable: roomsAvailable,
        // fetchRoomsAvailable: fetchRoomsAvailableHandler,

        roomList: roomList,
        fetchRoomList: fetchRoomListHandler,

        branchList: branchList,
        fetchBranchList: fetchBranchListHandler,

        branchCustomerStatistic: branchCustomerStatistic,
        fetchBranchCustomerStatisticByIDAndYear: fetchBranchCustomerStatisticByIDAndYearHandler
    }

    return <DBHelper.Provider value={context}>
        {props.children}
    </DBHelper.Provider>
}

export default DBHelper;
