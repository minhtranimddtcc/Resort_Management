const mysql = require('mysql');
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

const db = mysql.createPool({
    connectionLimit: 100,
    host: "localhost",
    user: "sManager",
    password: "123456",
    database: "hotel_california"
});

// Authentication
app.get("/api/authenticate", (req, res) => {
    const data = req.query;

    if (data.username !== "sManager") {
        res.send("Username does not exist");
    } else if (data.password !== "123456") {
        res.send("Password is incorrect");
    } else {
        res.send("Success");
    }
});


// Get customer list
app.get("/api/admin/getcustomerlist", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL getCustomerInfo()";

    db.query(sqlGet, (err, result)=>{
        res.send(result);
    });
});

// Get customer by name
app.get("/api/admin/getcustomerbyname", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL getCustomerInfoByName(?)";

    db.query(sqlGet, [data.name], (err, result)=>{
        res.send(result);
    });
});

// Get reservation by customerID
app.get("/api/admin/getreservation", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL getCustomerReservation(?)";

    db.query(sqlGet, [data.customerID], (err, result)=>{
        res.send(result);
    });
});

// Insert room type
app.get("/api/admin/insertroomtype", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL insertRoomType(?, ?, ?, ?)";

    db.query(sqlGet, [data.name, data.area, data.maxGuest, data.description], (err, result)=>{
        res.send(result);
        console.log(err);
    });
});

// Insert bed info
app.get("/api/admin/insertbedinfo", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL insertBedInfo(?, ?, ?)";

    db.query(sqlGet, [data.roomTypeID, data.size, data.quantity], (err, result)=>{
        res.send(result);
        console.log(err);
    });
});

// Get supply type
app.get("/api/admin/getsupplytype", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL getSupplyType()";

    db.query(sqlGet, (err, result)=>{
        res.send(result);
        console.log(err);
    });
});

// Insert supply type
app.get("/api/admin/insertsupplytype", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL insertSupplyTypeInRoomType(?, ?, ?)";

    db.query(sqlGet, [data.name, data.roomTypeID, data.quantity], (err, result)=>{
        res.send(result);
        console.log(err);
    });
});

// get room query
app.get("/api/getroom",(req, res)=>{
    const data = req.body;
    res.send("YEEEEE");
    // const sqlGet = "Call GetRoomAvailable(?);";

    // db.query(sqlGet, [data.branchID],(err, result)=>{
    //     console.log(err)
    // });

})

// Lấy danh sách phòng đã đăt của khách
app.get("/api/guest/getroom", (req, res)=>{
    const data = req.query;
    const sqlGet = "CALL PhongDaThue(?, ?, ?)";

    db.query(sqlGet, [data.customerID, data.phoneNumber, data.IDCardNumber], (err, result)=>{
        res.send(result);
    });
});



app.get("/api/getbranch", (req, res)=>{
    const data = req.body;
    const sqlGet = "CALL getBranch();";

    db.query(sqlGet, [data.imageURL, ...data], (err, result)=>{
        console.log(err);
    });
})

app.get("/api/admin/getBranchStatistic", (req, res)=> {
    const data = req.query;
    const sqlGet = "CALL ThongKeLuotKhach(?,?);";

    db.query(sqlGet, [data.branchID, data.year], (err, result)=>{
        res.send(result);
        console.log(err);
    });
})

app.listen(3001, ()=>{
    console.log("Running on port 3001");
})