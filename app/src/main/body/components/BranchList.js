import React, { useContext } from "react";
import DBHelper from "../../helpers/DBHelper";


function BranchList() {
    const DBHelperCtx = useContext(DBHelper);
    function showBranch(branch) {
        return (
            <div>
                <div>
                    <a><img src={branch.imageURL}/></a>
                </div>
                <div>
                    <li><a>Branch {branch.ID}</a></li>
                    <li>Address: {branch.address}</li>
                    <li>{branch.province}</li>
                    <li>Email: {branch.email}</li>
                    <li>Phone Number: {branch.phoneNumber}</li>
                </div>
            </div>
        )
    };
    function showBranchList() {
        DBHelperCtx.fetchBranchList();
        var content = DBHelperCtx.branchList.length > 0
        ? DBHelperCtx.branchList.map(function(branch) {
            return showBranch(branch);
        }) 
        : null;
        return ( 
            <div>
                {content}
            </div>
        );
    }
    return (
        <div>
            {showBranchList()}
        </div>
    );
}
export default BranchList;