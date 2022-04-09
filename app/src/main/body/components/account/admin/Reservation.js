import React, { useContext, useEffect } from "react";
import DBHelper from "../../../../helpers/DBHelper";
import { withRouter } from 'react-router';
import './Reservation.css';

const reservationField=["ID","bookingDate","numberOfGuest","checkInDate","checkOutDate","status","totalCost"];

function Reservation(props) {
    const DBHelperCtx = useContext(DBHelper);

    useEffect(() => {
        DBHelperCtx.fetchReservationList(props.match.params.id);
        // eslint-disable-next-line
    }, []);

    function showReservation(reservation,idx) {
        return (
            <tr key={idx}>
                    {reservationField.map((field,idx)=><td key={idx}>{reservation[field]}</td>)}
            </tr>
        );
    }

    function showReservationList() {
        var content = DBHelperCtx.reservationList.length
            ? DBHelperCtx.reservationList.map(function(reservation,idx) {
                return showReservation(reservation,idx);
            })
            : null;

        return DBHelperCtx.reservationList.length
        ? (<table className = "content-table">
            <thead>
                <tr>
                    <td>ID</td>
                    <td>Ngày đặt phòng</td>
                    <td>Số lượng khách</td>
                    <td>Ngày nhận phòng</td>
                    <td>Ngày trả phòng</td>
                    <td>Tình trạng</td>
                    <td>Giá tiền</td>
                </tr>
            </thead>
            <tbody>
                {content}
            </tbody>
        </table>)
        : <h4>Không có đơn nào cả...</h4>;
    }

    return (
        <React.Fragment>
            <h3 className = "reservation">Đơn đặt phòng</h3>
            {showReservationList()}
        </React.Fragment>
    );
}

export default withRouter(Reservation);