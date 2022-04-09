import React, { useContext, useEffect, useRef, useState } from "react";
import { useHistory } from "react-router-dom";
import DBHelper from "../../../../helpers/DBHelper";
import './Customer.css';

const customerField =["ID","name","IDCardNumber","phoneNumber","email","username","point","type"];
function Customer() {
    const DBHelperCtx = useContext(DBHelper);
    const [maxCustomer, setMaxCustomer] = useState(0);
    useEffect(() => {
        DBHelperCtx.fetchCustomerList();
        setMaxCustomer(DBHelperCtx.customerList.length);
        // eslint-disable-next-line
    }, []);

    const name = useRef();
    const history = useHistory();
    
    function autoSearchHandler() {
        if (name.current.value === "" || maxCustomer < 100) {
            DBHelperCtx.fetchCustomerByName(name.current.value);
        }
    }

    function searchHandler(event) {
        event.preventDefault();
        DBHelperCtx.fetchCustomerByName(name.current.value);
    }

    function showCustomer(customer,idx) {
        return (
            <tr key={idx} style={{cursor:"pointer"}} onClick={()=>
                {
                    history.push("/admin/reservation/"+customer["ID"]);
                }}>
                    {customerField.map((field,idx)=><td key={idx}>{customer[field]}</td>)}
            </tr>
        );
    }

    function showCustomerList() {
        var content = DBHelperCtx.customerList.length
            ? DBHelperCtx.customerList.map(function(customer,idx) {
                return showCustomer(customer,idx);
            })
            : null;

        return DBHelperCtx.customerList.length
        ? (<table className = "content-table">
            <thead>
                <tr>
                    <td>ID</td>
                    <td>Họ và tên</td>
                    <td>CMND/CCCD</td>
                    <td>Điện thoại</td>
                    <td>Email</td>
                    <td>Username</td>
                    <td>Điểm</td>
                    <td>Loại</td>
                </tr>
            </thead>
            <tbody>
                {content}
            </tbody>
        </table>)
        : <h4>Không có khách nào ở đây cả...</h4>;
    }

    return (
        <React.Fragment>
            <div className="search-form">
                <h3>Tìm kiếm</h3>
                <form onSubmit={searchHandler}>
                    <label>Tên khách hàng:</label>
                    <input type="text" placeholder="Nguyễn Văn A" className="box" ref={name} onChange={autoSearchHandler} />
                    <input type="submit" value="Tìm" className="btn" />
                </form>
            </div>
            {showCustomerList()}
        </React.Fragment>
    );
}

export default Customer;