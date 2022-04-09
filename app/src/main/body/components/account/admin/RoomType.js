import React, { useContext, useRef, useEffect } from "react";
import DBHelper from "../../../../helpers/DBHelper";
import './RoomType.css';

function RoomType() {
    const DBHelperCtx = useContext(DBHelper);
    useEffect(() => {
        // DBHelperCtx.fetchRoomTypeList();
        DBHelperCtx.fetchSupplyType();
        // eslint-disable-next-line
    }, []);
    const data = {
        name: useRef(),
        area: useRef(),
        maxGuest: useRef(),
        description: useRef(),
        size: useRef(),
        quantity: useRef(),
        supplyTypeName: useRef(),
        supplyTypeQuantity: useRef()
    }

    function insertHandler(event) {
        event.preventDefault();
        DBHelperCtx.insertRoomType(
            data.name.current.value,
            data.area.current.value,
            data.maxGuest.current.value,
            data.description.current.value
        );
        if (DBHelperCtx.roomTypeID) {
            data.name.current.value = "";
            data.area.current.value = "";
            data.maxGuest.current.value = "";
            data.description.current.value = "";
        }
    }

    function insertBedHandler(event) {
        event.preventDefault();
        DBHelperCtx.insertBed(
            data.size.current.value,
            data.quantity.current.value,
        );
        if (DBHelperCtx.roomTypeID) {
            data.size.current.value = "";
            data.quantity.current.value = "";
        }
    }

    function insertSupplyTypeHandler(event) {
        event.preventDefault();
        DBHelperCtx.insertSupplyType(
            data.supplyTypeName.current.value,
            data.supplyTypeQuantity.current.value,
        );
        if (DBHelperCtx.roomTypeID) {
            data.supplyTypeName.current.value = "";
            data.supplyTypeQuantity.current.value = "";
        }
    }

    function showBedForm() {
        return (
            <div className="insert-form" id="insert-bed-info">
                <h3>Thêm thông tin giường cho loại phòng</h3>
                <form onSubmit={insertBedHandler}>
                    <div>
                        <label>Kích thước:</label>
                        <input type="number" className="box" step="0.1" min="1.6" ref={data.size} />
                    </div>
                    <div>
                        <label>Số lượng:</label>
                        <input type="number" className="box" min="1" ref={data.quantity} />
                    </div>
                    <div>
                        <input type="submit" value="Thêm" className="btn" />
                    </div>
                </form>
            </div>
        );
    }

    function showSupplyType() {
        var ret = [];
        DBHelperCtx.supplyTypeList.map((supplyType)=>{
            console.log(supplyType["name"]);
            ret.push(<option key={supplyType["ID"]} value={supplyType["name"]}>{supplyType["name"]}</option>);
            return true;
        });
        return ret;
    }

    function showSupplyTypeForm() {
        return (
            <div className="insert-form" id="insert-supply-type">
                <h3>Thêm loại vật tư cho loại phòng</h3>
                <form onSubmit={insertSupplyTypeHandler}>
                    <div>
                        <label>Tên:</label>
                        <select ref={data.supplyTypeName}>
                            {showSupplyType()}
                        </select>
                    </div>
                    <div>
                        <label>Số lượng:</label>
                        <input type="text" className="box" ref={data.supplyTypeQuantity} />
                    </div>
                    <div>
                        <input type="submit" value="Thêm" className="btn" />
                    </div>
                </form>
            </div>
        );
    }

    // function showRoomType(roomType) {
    //     return (
    //         <tr key={DBHelperCtx.roomTypeList.indexOf(roomType)}>
    //             <td>{roomType["ID"]}</td>
    //             <td>{roomType["name"]}</td>
    //             <td>{roomType["IDCardNumber"]}</td>
    //             <td>{roomType["phoneNumber"]}</td>
    //         </tr>
    //     );
    // }

    // function showRoomTypeList() {
    //     var content = DBHelperCtx.roomTypeList.length
    //         ? DBHelperCtx.roomTypeList.map(function(roomType) {
    //             return showCustomer(roomType);
    //         })
    //         : null;

    //     return DBHelperCtx.roomTypeList.length
    //     ? (<table>
    //         <thead>
    //             <tr>
    //                 <td>ID</td>
    //                 <td>Loại phòng</td>
    //                 <td>Diện tích</td>
    //                 <td>Số khách tối đa</td>
    //                 <td>Số giường</td>
    //             </tr>
    //         </thead>
    //         <tbody>
    //             {content}
    //         </tbody>
    //     </table>)
    //     : <h4>There is no customer here...</h4>;
    // }

    return (
        <React.Fragment>
            <div className="insert-form" id="insert-room-type">
                <h3>Thêm loại phòng</h3>
                <form onSubmit={insertHandler}>
                    <div>
                        <label>Tên loại phòng:</label>
                        <input type="text" className="box" ref={data.name} />
                    </div>
                    <div>
                        <label>Diện tích:</label>
                        <input type="number" className="box" step="0.1" min="10" ref={data.area} />
                    </div>
                    <div>
                        <label>Số khách tối đa:</label>
                        <input type="number" className="box" min="1" ref={data.maxGuest} />
                    </div>
                    <div>
                        <label>Mô tả:</label>
                        <textarea className="description" ref={data.description}></textarea>
                    </div>
                    <div><input type="submit" value="Thêm" className="btn" /></div>
                </form>
            </div>
            {DBHelperCtx.roomTypeID ? showBedForm() : null}
            {DBHelperCtx.roomTypeID ? showSupplyTypeForm() : null}
        </React.Fragment>
    );
}

export default RoomType;