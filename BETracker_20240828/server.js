const express = require('express');
const path = require('path');
const mysql = require('mysql2');
const app = express();

// Set EJS as templating engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Create a connection to local database (Creat and use this for testing)
/*const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Omnibits',
    database: 'betracker'
}); */

const connection = mysql.createConnection({
    host: 'localhost', // The host of your MySQL server
    user: 'root', // Windows user who has access to MySQL
    password: 'Password', // If the user does not have a password, leave it empty
    database: 'betracker', // The name of the database you want to connect to
  });

// Create a connection to Azure Database (Do not use for testing yet)
/*const connection = mysql.createConnection({
host:'obsserver.mysql.database.azure.com',
user:'OBSAdmin',
password:'OmnibitsS1',
database:'betracker'
}) */


// Connect to the database
connection.connect(err => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the database.');
});

// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));

// Route for the home page
app.get('/', (req, res) => {
    connection.query('SELECT * FROM users', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        res.render('index', { users: results });
    });
});

app.get('/assets', (req, res) => {
    connection.query('SELECT a.AssetID, a.Name, a.Description, at.AssetTypeID, at.Name as AssetTypeName, a.InitialBalance, a.CurrentBalance, DATE_FORMAT(a.StartDate, "%Y-%m-%d") as StartDate, DATE_FORMAT(a.EndDate, "%Y-%m-%d") as EndDate, a.TargetBalance, DATE_FORMAT(a.TargetDate, "%Y-%m-%d") as TargetDate FROM assets a, assettypes at  WHERE a.AssetTypeID = at.AssetTypeID', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        connection.query('SELECT AssetTypeID, Name FROM assettypes ORDER BY Name', (err, results2) => {
            if (err) {
                return res.send('Error fetching data: ' + err.message);
            }
            res.render('assets', { assets: results, AssetTypes: results2 });
        });
        

    });
});

app.get('/assettypes', (req, res) => {
    connection.query('SELECT * FROM assettypes', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        res.render('assettypes', { assettypes: results });
    });
});

app.get('/liabilities', (req, res) => {
    connection.query('SELECT a.LiabilityID, a.Name, a.Description, at.LiabilityTypeID, at.Name as LiabilityTypeName, a.InitialBalance, a.CurrentBalance, DATE_FORMAT(a.StartDate, "%Y-%m-%d") as StartDate, DATE_FORMAT(a.EndDate, "%Y-%m-%d") as EndDate, a.TargetBalance, DATE_FORMAT(a.TargetDate, "%Y-%m-%d") as TargetDate FROM liabilities a, liabilitytypes at  WHERE a.LiabilityTypeID = at.LiabilityTypeID', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        connection.query('SELECT LiabilityTypeID, Name FROM liabilitytypes ORDER BY Name', (err, results2) => {
            if (err) {
                return res.send('Error fetching data: ' + err.message);
            }
            res.render('liabilities', { liabilities: results, LiabilityTypes: results2 });
        });
        

    });
});

app.get('/liabilitytypes', (req, res) => {
    connection.query('SELECT * FROM liabilitytypes', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        res.render('liabilitytypes', { liabilitytypes: results });
    });
});

// Route for the about page
app.get('/about', (req, res) => {
    res.render('about');
});

// Route for the contact page
app.get('/contact', (req, res) => {
    res.render('contact');
});


//POST data

const assettype_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const asset_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const liabilitytype_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const liability_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

app.post('/assettypes/update', assettype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.hiddenAssetTypeID == "")
    {
        const sql = "INSERT INTO assettypes (Name,Description) VALUES ('" + 
            req.body.editName + "','" + 
            req.body.editDescription + "')";
            
            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenAssetTypeID) != "NaN")
    {
        const sql = "UPDATE assettypes SET Name = '" + req.body.editName + 
            "', Description = '" + req.body.editDescription +
            "' WHERE AssetTypeID = '" + req.body.hiddenAssetTypeID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            console.log(sql); 
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/assettypes/delete', assettype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);
    if(parseInt(req.body.hiddenAssetTypeID) != "NaN")
        {
            const sql = "DELETE FROM assettypes WHERE AssetTypeID = '" + req.body.hiddenAssetTypeID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/assets/update', asset_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    function setNullIfEmpty(value)
    {
        if(value=="") {
            return "null";
        }
        else {
            return ("'" + value + "'");
        }
    };

    if(req.body.editAssetType == "0") {
        req.body.editAssetType = "";
    }
    if(req.body.hiddenAssetID == "")
    {
        const sql = "INSERT INTO assets (Name, Description, AssetTypeID, InitialBalance, CurrentBalance, StartDate, EndDate, TargetBalance, TargetDate) VALUES (" + 
            setNullIfEmpty(req.body.editName) + "," + 
            setNullIfEmpty(req.body.editDescription) + "," + 
            setNullIfEmpty(req.body.editAssetType) + "," + 
            setNullIfEmpty(req.body.editInitialBalance) + "," + 
            setNullIfEmpty(req.body.editCurrentBalance) + "," + 
            setNullIfEmpty(req.body.editStartDate) + "," + 
            setNullIfEmpty(req.body.editEndDate) + "," + 
            setNullIfEmpty(req.body.editTargetBalance) + "," + 
            setNullIfEmpty(req.body.editTargetDate) + ")";

            console.log(sql);
            
            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenAssetID) != "NaN")
    {
        const sql = "UPDATE assets SET " +
            "Name = " + setNullIfEmpty(req.body.editName) + "," + 
            "Description = " + setNullIfEmpty(req.body.editDescription) + "," + 
            "AssetTypeID = " + setNullIfEmpty(req.body.editAssetType) + "," + 
            "InitialBalance = " + setNullIfEmpty(req.body.editInitialBalance) + "," + 
            "CurrentBalance = " + setNullIfEmpty(req.body.editCurrentBalance) + "," + 
            "StartDate = " + setNullIfEmpty(req.body.editStartDate) + "," + 
            "EndDate = " + setNullIfEmpty(req.body.editEndDate) + "," + 
            "TargetBalance = " + setNullIfEmpty(req.body.editTargetBalance) + "," + 
            "TargetDate = " + setNullIfEmpty(req.body.editTargetDate) +
            " WHERE AssetID = '" + req.body.hiddenAssetID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            console.log(sql); 
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/assets/delete', asset_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.editAssetType == "0") {
        req.body.editAssetType = "";
    }

    if(parseInt(req.body.hiddenAssetTypeID) != "NaN")
        {
            const sql = "DELETE FROM assets WHERE AssetID = '" + req.body.hiddenAssetID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/liabilitytypes/update', liabilitytype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.hiddenLiabilityTypeID == "")
    {
        const sql = "INSERT INTO liabilitytypes (Name,Description) VALUES ('" + 
            req.body.editName + "','" + 
            req.body.editDescription + "')";
            
            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenLiabilityTypeID) != "NaN")
    {
        const sql = "UPDATE liabilitytypes SET Name = '" + req.body.editName + 
            "', Description = '" + req.body.editDescription +
            "' WHERE LiabilityTypeID = '" + req.body.hiddenLiabilityTypeID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            console.log(sql); 
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/liabilitytypes/delete', liabilitytype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);
    if(parseInt(req.body.hiddenLiabilityTypeID) != "NaN")
        {
            const sql = "DELETE FROM liabilitytypes WHERE LiabilityTypeID = '" + req.body.hiddenLiabilityTypeID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/liabilities/update', liability_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    function setNullIfEmpty(value)
    {
        if(value=="") {
            return "null";
        }
        else {
            return ("'" + value + "'");
        }
    };

    if(req.body.editLiabilityType == "0") {
        req.body.editLiabilityType = "";
    }
    if(req.body.hiddenLiabilityID == "")
    {
        const sql = "INSERT INTO liabilities (Name, Description, LiabilityTypeID, InitialBalance, CurrentBalance, StartDate, EndDate, TargetBalance, TargetDate) VALUES (" + 
            setNullIfEmpty(req.body.editName) + "," + 
            setNullIfEmpty(req.body.editDescription) + "," + 
            setNullIfEmpty(req.body.editLiabilityType) + "," + 
            setNullIfEmpty(req.body.editInitialBalance) + "," + 
            setNullIfEmpty(req.body.editCurrentBalance) + "," + 
            setNullIfEmpty(req.body.editStartDate) + "," + 
            setNullIfEmpty(req.body.editEndDate) + "," + 
            setNullIfEmpty(req.body.editTargetBalance) + "," + 
            setNullIfEmpty(req.body.editTargetDate) + ")";

            console.log(sql);
            
            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenLiabilityID) != "NaN")
    {
        const sql = "UPDATE liabilities SET " +
            "Name = " + setNullIfEmpty(req.body.editName) + "," + 
            "Description = " + setNullIfEmpty(req.body.editDescription) + "," + 
            "LiabilityTypeID = " + setNullIfEmpty(req.body.editLiabilityType) + "," + 
            "InitialBalance = " + setNullIfEmpty(req.body.editInitialBalance) + "," + 
            "CurrentBalance = " + setNullIfEmpty(req.body.editCurrentBalance) + "," + 
            "StartDate = " + setNullIfEmpty(req.body.editStartDate) + "," + 
            "EndDate = " + setNullIfEmpty(req.body.editEndDate) + "," + 
            "TargetBalance = " + setNullIfEmpty(req.body.editTargetBalance) + "," + 
            "TargetDate = " + setNullIfEmpty(req.body.editTargetDate) +
            " WHERE LiabilityID = '" + req.body.hiddenLiabilityID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            console.log(sql); 
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/liabilities/delete', liability_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.editLiabilityType == "0") {
        req.body.editLiabilityType = "";
    }

    if(parseInt(req.body.hiddenLiabilityTypeID) != "NaN")
        {
            const sql = "DELETE FROM liabilities WHERE LiabilityID = '" + req.body.hiddenLiabilityID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                console.log(sql); 
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});


// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});