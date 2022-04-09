import './Home.css';
import React from 'react';
import { useContext, useEffect, useRef } from "react";
import DBHelper from "../../../../helpers/DBHelper";
function Home() {
    const DBHelperCtx = useContext(DBHelper);
    useEffect(() => {
        DBHelperCtx.fetchBranchCustomerStatisticByIDAndYear(name.current.value, year.current.value);
        // eslint-disable-next-line
    }, []);

    const name = useRef();
    const year = useRef();
    var totalGuestOfYear = 0;
    function autoSearchHandler() {
        if (name.current.value === "") {
            DBHelperCtx.fetchBranchCustomerStatisticByIDAndYear(name.current.value, year.current.value);
        }
    }
    
    function searchHandler(event) {
        event.preventDefault();
        DBHelperCtx.fetchBranchCustomerStatisticByIDAndYear(name.current.value, year.current.value);
    }

    function showBranchCustomer(branchCustomerStatistic) {
        totalGuestOfYear+=branchCustomerStatistic["Tổng số lượt khách"];
        return (
            <tr>
                <td>{branchCustomerStatistic["Tháng"]}</td>
                <td>{branchCustomerStatistic["Tổng số lượt khách"]}</td>
            </tr>
        );
    }

    function showBranchCustomerList() {
        var content = DBHelperCtx.branchCustomerStatistic.length
            ? DBHelperCtx.branchCustomerStatistic.map(function(branchCustomerStatistic) {
                return showBranchCustomer(branchCustomerStatistic);
            })
            : null;
        console.log(content);
        return DBHelperCtx.branchCustomerStatistic.length
        ? (<table className="content-table">
            <thead>
                <tr>
                    <td>Tháng</td>
                    <td>Tổng số lượt khách</td>
                </tr>
            </thead>
            <tbody>
                {content}
                <tr>
                    <td>Cả năm </td>
                    <td>{totalGuestOfYear}</td>
                </tr>
            </tbody>
        </table>)
        : <h4>Không có chi nhánh</h4>;
    }

    return (
        <React.Fragment>
            
            <div className="search-formHome">
                <h3>Thống kê lượt khách</h3>
                <form onSubmit={searchHandler}>
                    <label>Mã Chi nhánh</label>
                    <span>
                        <input type="text" placeholder="CN1" className="box" defaultValue="CN1" ref={name}  onChange={autoSearchHandler}/>
                        <input type="text" placeholder="2021" className="box" defaultValue="2021" ref={year}  onChange={autoSearchHandler}/>
                        <input type="submit" value="Tìm" className="btn" />
                    </span>
                </form>
            </div>
            {showBranchCustomerList()}
            
        </React.Fragment>
    );
}

/*
    return (
        <React.Fragment>
            Hello
        </React.Fragment>
    );

}*/
export default Home;