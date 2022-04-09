import React, { useContext, useEffect } from "react";
import DBHelper from "../../helpers/DBHelper";


function RoomList(props) {
    const DBHelperCtx = useContext(DBHelper);
    useEffect(() => {
        DBHelperCtx.fetchRoomList("KH000001", "0987654321", "0123456789");
    }, [DBHelperCtx]);

    function showRoom(room) {
        return (
            <tr key={DBHelperCtx.roomList.indexOf(room)}>
                <td>{room["Mã phòng"]}</td>
                <td>{room["Chi nhánh"]}</td>
                <td>{room["Khu"]}</td>
                <td>{room["Loại phòng"]}</td>
                <td>{room["Diện tích"]}</td>
            </tr>
        );
    }

    function showRoomList() {
        var content = DBHelperCtx.roomList.length > 0
            ? DBHelperCtx.roomList.map(function(room) {
                return showRoom(room);
            })
            : null;

        return DBHelperCtx.roomList.length
        ? (<table>
            <thead>
                <tr>
                    <td>Mã phòng</td>
                    <td>Chi nhánh</td>
                    <td>Khu</td>
                    <td>Loại phòng</td>
                    <td>Diện tích</td>
                </tr>
            </thead>
            <tbody>
                {content}
            </tbody>
        </table>)
        : <h4>You don't have any room ordered yet...</h4>;
    }

    return (
        <div className="list-table">
            {showRoomList()}
        </div>
    );
};

export default RoomList;