const express = require('express');
const path = require('path');
const mysql = require('mysql2');
const mysql2 = require('mysql2/promise');

const Connection = require('mysql/lib/Connection');
const { connect } = require('http2');
const { isNull } = require('util');
const { DATETIME, DECIMAL } = require('mysql/lib/protocol/constants/types');
const moment = require('moment');
const { Console } = require('console');
const app = express();

// Set EJS as templating engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Create a connection to local database (Creat and use this for testing)
const connConfig = {
    host: 'localhost',
    user: 'root',
    password: 'Omnibits',
    database: 'betracker'
};

// Create a connection to Azure Database (Do not use for testing yet)
/* const connConfig = {
    host:'obsserver.mysql.database.azure.com',
    user:'OBSAdmin',
    password:'OmnibitsS1',
    database:'betracker'
} */

class clsMessages { 

    messages = new Array([]);

    //Methods
    add (messageID) {
        this.messages.push(messageID);
    }

    parseURLSearchParams()
    {
        let mergedMessageIds="";
        let urlParams = null;

        if(this.messages.length > 0) {
            this.messages.forEach((element,index) => {
                if(index == 0) {
                    mergedMessageIds = mergedMessageIds + element;
                } else {
                    mergedMessageIds = mergedMessageIds + "." + element;
                }
            });
            urlParams = new URLSearchParams({m: mergedMessageIds});
        }
        else{
            urlParams = new URLSearchParams();
        }
        return urlParams;
    }

    extractSQLWhereURLSearchParams(colName, inMessages) {

        let messageList = inMessages.split(".");
        
        returnString = "";
        if(messageList.length > 0) {
            messageList.forEach((element,index) => {
                if(length == 0) {
                    returnString = colName + "=" + element;
                } else {
                    returnString = returnString + " OR " + colName + "=" + element;
                }
            });
        }

        return returnString;
    }
};

// Load Recurring Period List
const recurringPeriodList = 
    [
        [""],           // Index 0
        ["Week"],       // Index 1
        ["Fortnight"],  // Index 2
        ["Month"],      // Index 3
        ["Quarter"],    // Index 4
        ["Half Year"],  // Index 5
        ["Year"]        // Index 6
    ];

const IncomeOrExpense = {
    Null: 0,
    Income: 1,
    Expense: 2
}

function setNullIfEmpty(value, isNumber)
{
    if(isNumber) {
        if(value == "null" || value == null || value == "" || value == 0 || value == undefined || isNaN(value)) {
            return "null";
        }
        else {
            return ("'" + value + "'");
        }        
    } else {
        if(value == "null" || value == null || value == "" || value == 0 || value == undefined) {
            return "null";
        }
        else {
            return ("'" + value + "'");
        }
    }
};

function convertSelectNull(value, isNumber)
{

    if(isNumber) {
        if(value == "null" || value == null || value == "" || value == 0 || value == undefined || isNaN(value)) {
            return "is null";
        }
        else {
            return "=" + setNullIfEmpty(value, isNumber);
        } 
    } else {
        if(value == "null" || value == null || value == "" || value == 0 || value == undefined) {
            return "is null"
        }
        else {
            return "=" + setNullIfEmpty(value);
        }
    }
}

function setNextDatePeriod(currentDate, datePeriodID) {

    let newDate = moment(currentDate);

    switch(datePeriodID) {
        case '1': {
            newDate.add(7,"days");
            break;
        }
        case '2': {
            newDate.add(14,"days");
            break;
        }
        case '3': {
            newDate.add(1,"month");
            break;
        }
        case '4': {
            newDate.add(3,"months");
            break;
        }
        case '5': {
            newDate.add(6,"months");
            break;
        }
        case '6': {
            newDate.add(1,"year");
            break;
        }
        default: {
            console.log("Invalid Period = ["+datePeriodID+"]");
            break;
        };
    }

    return newDate;
}

async function getDayOfWeekDate( dtDate, dtDayOfWeek) {

    dt = new moment(dtDate);

    let dtDay = dt.day();

    if(dt.day() >= dtDayOfWeek) {
        dt.subtract((dtDay - dtDayOfWeek),"days");
    }
    else{
        dt.subtract((7 - (dtDayOfWeek - dtDay)),"days");
    }

    return dt; 
}

const connection = mysql.createConnection(connConfig);

// Connect to the database (to be changed to MySql promise/await connection pool method)
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

app.get('/incomes', (req, res) => {
    connection.query(`
        SELECT i.IncomeID, i.Name, i.Description, it.IncomeTypeID, it.Name as IncomeTypeName, i.AssetID, a.Name as AssetName, 
               i.LiabilityID, l.Name as LiabilityName, i.Amount, DATE_FORMAT(i.StartDate, "%Y-%m-%d") as StartDate, 
               DATE_FORMAT(i.EndDate, "%Y-%m-%d") as EndDate, i.RecurringPeriodID, 
               DATE_FORMAT(i.LastReceivedDate, "%Y-%m-%d") as LastReceivedDate, i.Applied  
        FROM incomes i 
        LEFT OUTER JOIN incometypes it ON i.IncomeTypeID = it.IncomeTypeID 
        LEFT OUTER JOIN assets a ON i.AssetID = a.AssetID
        LEFT OUTER JOIN liabilities l ON i.LiabilityID = l.LiabilityID

    `, (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        connection.query('SELECT IncomeTypeID, Name FROM incometypes ORDER BY Name', (err, results2) => {
            if (err) {
                return res.send('Error fetching data: ' + err.message);
            }
            connection.query('SELECT AssetID, Name FROM assets ORDER BY Name', (err, results3) => {
                if (err) {
                    return res.send('Error fetching data: ' + err.message);
                }
                connection.query('SELECT LiabilityID, Name FROM liabilities ORDER BY Name', (err, results4) => {
                    if (err) {
                        return res.send('Error fetching data: ' + err.message);
                    }
                    
                    res.render('incomes', { incomes: results, incomeTypes: results2, assets: results3, liabilities: results4, recurringPeriod: recurringPeriodList });
                });  
            });
        });
    });
});

app.get('/incometypes', (req, res) => {
    connection.query('SELECT * FROM incometypes', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        res.render('incometypes', { incometypes: results });
    });
});

app.get('/expensetypes', (req, res) => {
    connection.query('SELECT * FROM expensetypes', (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        res.render('expensetypes', { expensetypes: results });
    });
});
app.get('/expenses', (req, res) => {
    connection.query(`
        SELECT e.ExpenseID, e.Name, e.Description, et.ExpenseTypeID, et.Name as ExpenseTypeName, e.AssetID, a.Name as AssetName, 
        e.LiabilityID, l.Name as LiabilityName, e.Amount, DATE_FORMAT(e.StartDate, "%Y-%m-%d") as StartDate, 
               DATE_FORMAT(e.EndDate, "%Y-%m-%d") as EndDate, e.RecurringPeriodID, 
               DATE_FORMAT(e.LastPaidDate, "%Y-%m-%d") as LastPaidDate, e.Applied  
        FROM expenses e 
        LEFT OUTER JOIN expensetypes et ON e.ExpenseTypeID = et.ExpenseTypeID 
        LEFT OUTER JOIN assets a ON e.AssetID = a.AssetID
        LEFT OUTER JOIN liabilities l ON e.LiabilityID = l.LiabilityID
    
    `, (err, results) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        connection.query('SELECT ExpenseTypeID, Name FROM expensetypes ORDER BY Name', (err, results2) => {
            if (err) {
                return res.send('Error fetching data: ' + err.message);
            }
            connection.query('SELECT AssetID, Name FROM assets ORDER BY Name', (err, results3) => {
                if (err) {
                    return res.send('Error fetching data: ' + err.message);
                }
                connection.query('SELECT LiabilityID, Name FROM liabilities ORDER BY Name', (err, results4) => {
                    if (err) {
                        return res.send('Error fetching data: ' + err.message);
                    }
                    
                    res.render('expenses', { expenses: results, expenseTypes: results2, assets: results3, liabilities: results4, recurringPeriod: recurringPeriodList });
                });                    
            });
        });
    });
});

app.get('/finance', (req, res) => {
    connection.query('SELECT SequenceID, Name, AssetID, LiabilityID FROM fincols ORDER By sequenceID', (err, finColsResults) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }
        connection.query(`
            SELECT fc.SequenceID, DATE_FORMAT(fl.LineDate,'%Y-%m-%d') as LineDate, fl.AssetID, fl.LiabilityID, fl.LineBalance AS LineBalance 
            FROM  fincols fc, finlines fl 
            WHERE if(isnull(fc.AssetID), fc.LiabilityID = fl.LiabilityID, fc.AssetID = fl.AssetID )
            ORDER BY fl.LineDate, fc.sequenceID
            `, (err, finLinesResults) => {
            res.render('finance', { finCols: finColsResults, finLines: finLinesResults});
        });
    });    
});

app.get('/financecols', (req, res) => {
    connection.query(`
        SELECT fc.FinColID, fc.SequenceID, fc.AssetID, a.Name as AssetName, fc.LiabilityID, l.Name as LiabilityName, fc.Name 
        FROM fincols fc 
        LEFT OUTER JOIN assets a ON fc.AssetID = a.AssetID
        LEFT OUTER JOIN liabilities l ON fc.LiabilityID = l.LiabilityID
        ORDER BY SequenceID`, (err, results1) => {
        if (err) {
            return res.send('Error fetching data: ' + err.message);
        }

        connection.query('SELECT AssetID, Name FROM assets ORDER BY Name', (err, results2) => {
            if (err) {
                return res.send('Error fetching data: ' + err.message);
            }
            connection.query('SELECT LiabilityID, Name FROM liabilities ORDER BY Name', (err, results3) => {
                if (err) {
                    return res.send('Error fetching data: ' + err.message);
                }
                
                res.render('financecols', { financecols: results1, assets: results2, liabilities: results3});
            });  
        });
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

const incometype_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const income_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const expensetype_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const expense_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const fincols_middle = express.urlencoded({
    extended:false,
    limit: 10000,
    //parameterLimit: 2,
})

const finbreakdowns_middle = express.urlencoded({
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
                res.redirect(req.get('referer'));
            });
    }
    else if(parseInt(req.body.hiddenAssetTypeID) != "NaN")
    {
        const sql = "UPDATE assettypes SET Name = '" + req.body.editName + 
            "', Description = '" + req.body.editDescription +
            "' WHERE AssetTypeID = '" + req.body.hiddenAssetTypeID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
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
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/assets/update', asset_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.editAssetType == "0") {
        req.body.editAssetType = "";
    }
    if(req.body.hiddenAssetID == "")
    {
        const sql = "INSERT INTO assets (Name, Description, AssetTypeID, InitialBalance, CurrentBalance, StartDate, EndDate, TargetBalance, TargetDate) VALUES (" + 
            setNullIfEmpty(req.body.editName,false) + "," + 
            setNullIfEmpty(req.body.editDescription,false) + "," + 
            setNullIfEmpty(req.body.editAssetType,true) + "," + 
            setNullIfEmpty(req.body.editInitialBalance,true) + "," + 
            setNullIfEmpty(req.body.editCurrentBalance,true) + "," + 
            setNullIfEmpty(req.body.editStartDate,false) + "," + 
            setNullIfEmpty(req.body.editEndDate,false) + "," + 
            setNullIfEmpty(req.body.editTargetBalance,true) + "," + 
            setNullIfEmpty(req.body.editTargetDate,false) + ")";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenAssetID) != "NaN")
    {
        const sql = "UPDATE assets SET " +
            "Name = " + setNullIfEmpty(req.body.editName,false) + "," + 
            "Description = " + setNullIfEmpty(req.body.editDescription,false) + "," + 
            "AssetTypeID = " + setNullIfEmpty(req.body.editAssetType,true) + "," + 
            "InitialBalance = " + setNullIfEmpty(req.body.editInitialBalance,true) + "," + 
            "CurrentBalance = " + setNullIfEmpty(req.body.editCurrentBalance,true) + "," + 
            "StartDate = " + setNullIfEmpty(req.body.editStartDate,false) + "," + 
            "EndDate = " + setNullIfEmpty(req.body.editEndDate,false) + "," + 
            "TargetBalance = " + setNullIfEmpty(req.body.editTargetBalance,true) + "," + 
            "TargetDate = " + setNullIfEmpty(req.body.editTargetDate,false) +
            " WHERE AssetID = '" + req.body.hiddenAssetID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
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
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/liabilities/update', liability_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.editLiabilityType == "0") {
        req.body.editLiabilityType = "";
    }
    if(req.body.hiddenLiabilityID == "")
    {
        const sql = "INSERT INTO liabilities (Name, Description, LiabilityTypeID, InitialBalance, CurrentBalance, StartDate, EndDate, TargetBalance, TargetDate) VALUES (" + 
            setNullIfEmpty(req.body.editName,false) + "," + 
            setNullIfEmpty(req.body.editDescription,false) + "," + 
            setNullIfEmpty(req.body.editLiabilityType,true) + "," + 
            setNullIfEmpty(req.body.editInitialBalance,true) + "," + 
            setNullIfEmpty(req.body.editCurrentBalance,true) + "," + 
            setNullIfEmpty(req.body.editStartDate,false) + "," + 
            setNullIfEmpty(req.body.editEndDate,false) + "," + 
            setNullIfEmpty(req.body.editTargetBalance,true) + "," + 
            setNullIfEmpty(req.body.editTargetDate,false) + ")";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenLiabilityID) != "NaN")
    {
        const sql = "UPDATE liabilities SET " +
            "Name = " + setNullIfEmpty(req.body.editName,false) + "," + 
            "Description = " + setNullIfEmpty(req.body.editDescription,false) + "," + 
            "LiabilityTypeID = " + setNullIfEmpty(req.body.editLiabilityType,true) + "," + 
            "InitialBalance = " + setNullIfEmpty(req.body.editInitialBalance,true) + "," + 
            "CurrentBalance = " + setNullIfEmpty(req.body.editCurrentBalance,true) + "," + 
            "StartDate = " + setNullIfEmpty(req.body.editStartDate,false) + "," + 
            "EndDate = " + setNullIfEmpty(req.body.editEndDate,false) + "," + 
            "TargetBalance = " + setNullIfEmpty(req.body.editTargetBalance,true) + "," + 
            "TargetDate = " + setNullIfEmpty(req.body.editTargetDate,false) +
            " WHERE LiabilityID = '" + req.body.hiddenLiabilityID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
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
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});


// Income Types

app.post('/incometypes/update', incometype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.hiddenIncomeTypeID == "")
    {
        const sql = "INSERT INTO incometypes (Name,Description) VALUES ('" + 
            req.body.editName + "','" + 
            req.body.editDescription + "')";
            
            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenIncomeTypeID) != "NaN")
    {
        const sql = "UPDATE incometypes SET Name = '" + req.body.editName + 
            "', Description = '" + req.body.editDescription +
            "' WHERE IncomeTypeID = '" + req.body.hiddenIncomeTypeID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/incometypes/delete', incometype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);
    if(req.body.hiddenIncomeTypeID !="" && parseInt(req.body.hiddenIncomeTypeID) != "NaN")
        {
            const sql = "DELETE FROM incometypes WHERE IncomeTypeID = '" + req.body.hiddenIncomeTypeID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

// Incomes

app.post('/incomes/update', income_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    async function processNewIncome(pool)
    {
        async function processInsertIncome(conn) {
            try {

                const sql1 = "INSERT INTO incomes (Name, Description, IncomeTypeID, AssetID, LiabilityID, StartDate, EndDate, Amount, RecurringPeriodID, LastReceivedDate) VALUES (" + 
                setNullIfEmpty(req.body.editName,false) + "," + 
                setNullIfEmpty(req.body.editDescription,false) + "," + 
                setNullIfEmpty(req.body.editIncomeType,true) + "," + 
                setNullIfEmpty(req.body.editAsset,true) + "," + 
                setNullIfEmpty(req.body.editLiability,true) + "," + 
                setNullIfEmpty(req.body.editStartDate,false) + "," + 
                setNullIfEmpty(req.body.editEndDate,false) + "," + 
                setNullIfEmpty(req.body.editAmount,true) + "," + 
                setNullIfEmpty(req.body.editRecurringPeriod,true) + "," + 
                setNullIfEmpty(req.body.editLastReceivedDate,false) + ")";

                result = await conn.query(sql1);
                
                return result[0].insertId;
            }
            catch {
                console.log("Failed: processInsertIncome");
            }
        }

        const connectionPool = mysql2.createPool(connConfig);
        const conn = await connectionPool.getConnection();
        
        try {
            await conn.beginTransaction();
            let incomeExpenseID = await processInsertIncome(conn);

            //throw new Error('Error Test');
            
            await conn.commit();
            console.log("commit");

        } catch {
                await conn.rollback();
                console.log("rollback");
        } finally {

            res.redirect(req.get('referer'));
            console.log("Data Returned");
        }
    }

    async function processIncomeUpdate() {
        const sql = "UPDATE incomes SET " +
        "Name = " + setNullIfEmpty(req.body.editName,false) + "," + 
        "Description = " + setNullIfEmpty(req.body.editDescription,false) + "," + 
        "IncomeTypeID = " + setNullIfEmpty(req.body.editIncomeType,true) + "," + 
        "AssetID = " + setNullIfEmpty(req.body.editAsset,true) + "," + 
        "LiabilityID = " + setNullIfEmpty(req.body.editLiability,true) + "," + 
        "StartDate = " + setNullIfEmpty(req.body.editStartDate,false) + "," + 
        "EndDate = " + setNullIfEmpty(req.body.editEndDate,false) + "," + 
        "Amount = " + setNullIfEmpty(req.body.editAmount,true) + "," + 
        "RecurringPeriodID = " + setNullIfEmpty(req.body.editRecurringPeriod,true) + "," + 
        "LastReceivedDate = " + setNullIfEmpty(req.body.editLastReceivedDate,false) +
        " WHERE IncomeID = '" + req.body.hiddenIncomeID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }

    if(req.body.editIncomeType == "0") {
        req.body.editIncomeType = "";
    }

    if(req.body.hiddenIncomeID == "") {
        processNewIncome();
    }
    else if(req.body.hiddenIncomeID != "" && parseInt(req.body.hiddenIncomeID) != "NaN")
    {
        processIncomeUpdate();
    }
});

app.post('/incomes/delete', income_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.editIncomeID == "0") {
        req.body.editIncomeID = "";
    }

    if(req.body.hiddenIncomeID != "" && parseInt(req.body.hiddenIncomeID) != "NaN")
        {
            const sql = "DELETE FROM incomes WHERE IncomeID = '" + req.body.hiddenIncomeID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/incomes/apply', income_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    class clsTransactionInfo { flLineDate; flLineBalance; fbItemDate; fbItemAmount; fbItemIteration; flFinLineID;};

    async function processApplyIncomeToCache() {

        // Moved from Income Save
        async function calculatefinLineItemIterations(iOre, incomeExpense, incomeExpenseId) {
    
            let isIncome = false;
            let isExpense = false;
            
            if(incomeExpense.editExpenseID != null && incomeExpense.editExpenseID != undefined && incomeExpense.editExpenseID != "") {
                isExpense = true;
            } else if(incomeExpense.editIncomeID != null && incomeExpense.editIncomeID != undefined && incomeExpense.editIncomeID != "") {
                isIncome = true;
            }
        
            let dateIteration = moment(incomeExpense.editStartDate);
            let endDate = moment(incomeExpense.editEndDate);
        
            let finLines = [[]];
        
            let iterationIndex = 0;
            while(endDate >= dateIteration)
            {   
                if(iterationIndex > 0) {
                    finLines.push([]);
                }

                if(iOre == IncomeOrExpense.Income) {
                    finLines[iterationIndex][0] = incomeExpenseId;
                    finLines[iterationIndex][1] = "";
                } else if(iOre == IncomeOrExpense.Expense) {
                    finLines[iterationIndex][0] = "";
                    finLines[iterationIndex][1] = incomeExpenseId;
                } else {
                    finLines[iterationIndex][0] = "";
                    finLines[iterationIndex][1] = "";
                }
                finLines[iterationIndex][2] = dateIteration.format("YYYY-MM-DD");
                finLines[iterationIndex][3] = incomeExpense.editName;
                finLines[iterationIndex][4] = incomeExpense.editAmount;
                finLines[iterationIndex][5] = iterationIndex;
        
                dateIteration = setNextDatePeriod(dateIteration,incomeExpense.editRecurringPeriod);
                iterationIndex++;
            }
        
            return finLines;
        };

        // Moved from Income Save
        async function processInsertFinbreakdowns(conn, incomeExpenseID) {
            try {
                const finLineItemInterations = await calculatefinLineItemIterations(IncomeOrExpense.Income, req.body, incomeExpenseID);

                finLineItemInterations.forEach(element => {
                    let sql3 = "INSERT INTO finbreakdowns (IncomeID, ExpenseID, ItemDate, ItemName, ItemAmount, ItemIteration) VALUES (" + 
                        setNullIfEmpty(element[0],true) + "," + 
                        setNullIfEmpty(element[1],true) + "," + 
                        setNullIfEmpty(element[2],false) + "," + 
                        setNullIfEmpty(element[3],false) + "," + 
                        setNullIfEmpty(element[4],true) + "," + 
                        element[5] + ")";

                        result = conn.query(sql3);
                });
            }
            catch {
                console.log("Failed: processInsertFinbreakdowns()");
            }
        }

        async function getRelaventLines(conn) {
            try {
                let mondayDate = await getDayOfWeekDate(req.body.editStartDate,1);

                const sql1 = "SELECT FinLineID, fl.LineDate, fl.LineBalance FROM finlines fl WHERE " +
                                "fl.AssetID " + convertSelectNull(req.body.editAsset,true) + " AND " +
                                "fl.LiabilityID " + convertSelectNull(req.body.editLiability,true) + " AND " +
                                "fl.LineDate >= '" + mondayDate.format("YYYY-MM-DD") + "' " +
                                "ORDER BY fl.LineDate";
                                result = await conn.query(sql1);

                return result[0];
            }
            catch {
                console.log("Failed: getRelaventLines()");
            }
        }

        async function getRelaventBreakdowns(conn) {
            try {

                const sql1 = "SELECT fb.ItemDate, fb.ItemName, fb.ItemAmount, fb.ItemIteration FROM finbreakdowns fb WHERE " +
                                "fb.IncomeID " + convertSelectNull(req.body.hiddenIncomeID,true) + " AND " +
                                "fb.ExpenseID " + convertSelectNull(req.body.hiddenExpenseID,true) + " AND " +                                                              
                                "fb.ItemDate >= " + setNullIfEmpty(req.body.editStartDate,false) + " AND " +
                                "fb.ItemDate <= " + setNullIfEmpty(req.body.editEndDate,false) + " " +
                                "ORDER BY fb.ItemDate";
                result = await conn.query(sql1);

                return result[0];
            }
            catch {
                console.log("Failed: getRelaventBreakdowns()");
            }
        }

        async function buildSQLStatements(listRelaventLines, listRelaventBreakdowns) {

            let listTransactionInfo = new Array();

            try {
                // Load Lines Entries
                await listRelaventLines.forEach( (value, index) => {
                    
                    let objTransactionInfo = new clsTransactionInfo();
                    objTransactionInfo.flLineDate = moment(value.LineDate);
                    objTransactionInfo.flLineBalance = parseFloat(value.LineBalance);
                    objTransactionInfo.fbItemDate = null;
                    objTransactionInfo.fbItemAmount = null;
                    objTransactionInfo.fbItemIteration = null;
                    objTransactionInfo.flFinLineID = value.FinLineID;

                    listTransactionInfo.push(objTransactionInfo);
                })
                
                // Load Breakdowns Entries
                await listRelaventBreakdowns.forEach( async (value, index) => {

                    let DOWDate = await getDayOfWeekDate(value.ItemDate,1)
                    let i = listTransactionInfo.findIndex( (element) => {  return (moment(element.flLineDate).isSame(DOWDate,'day')) });
                    if(i < 0) {
                        let objTransactionInfo = new clsTransactionInfo();
                        objTransactionInfo.flLineDate = DOWDate;
                        objTransactionInfo.fbItemDate = moment(value.ItemDate)
                        objTransactionInfo.fbItemAmount = parseFloat(value.ItemAmount);
                        objTransactionInfo.fbItemIteration = value.ItemIteration;

                        listTransactionInfo.push(objTransactionInfo);
                    }
                    else if (i >= 0)
                    {
                        listTransactionInfo.at(i).fbItemDate = moment(value.ItemDate)
                        listTransactionInfo.at(i).fbItemAmount = parseFloat(value.ItemAmount);
                        listTransactionInfo.at(i).fbItemIteration = value.ItemIteration;
                    }
                })

                listTransactionInfo.sort( (a,b) => { return (a.flLineDate - b.flLineDate) });

                const sqlRunningTotal = "SELECT LineBalance FROM finlines WHERE LineBalance IS NOT NULL AND  " +
                                            "AssetID " + convertSelectNull(req.body.editAsset,true) + " AND " +
                                            "LiabilityID " + convertSelectNull(req.body.editLiability,true) + " AND " +
                                            "LineDate <= " + setNullIfEmpty(req.body.editStartDate,false) + " " +
                                            "ORDER BY LineDate DESC LIMIT 1";

                resultx = await conn.query(sqlRunningTotal);

                let runningTotal = 0.0;

                if(resultx[0].length > 0) {
                    runningTotal =  parseFloat(resultx[0][0].LineBalance);
                }
                else {

                    try {
                        let sqlAssetOrLiabilityCurrentBalance = "";
                        if(req.body.editAsset != null && !isNaN(req.body.editAsset) && req.body.editAsset != undefined) {
                            sqlAssetOrLiabilityCurrentBalance = "SELECT CurrentBalance FROM assets WHERE " +
                                            "AssetID " + convertSelectNull(req.body.editAsset,true);
                        } else if(req.body.editLiability != null && !isNaN(req.body.editLiability) && req.body.editLiability != undefined) {
                            sqlAssetOrLiabilityCurrentBalance = "SELECT CurrentBalance FROM liabilities WHERE " +
                                        "LiabilityID " + convertSelectNull(req.body.editLiability,true);
                        }

                        const resultsAssetOrLiabilityCurrentBalance = await conn.query(sqlAssetOrLiabilityCurrentBalance);

                        if(resultsAssetOrLiabilityCurrentBalance[0].length > 0){
                            
                            if(resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance != null && !isNaN(resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance) && resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance != undefined) {

                                runningTotal = parseFloat(resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance);

                            } else {
                                runningTotal = 0.0;
                            }
                        }
                    }
                    catch {

                    }
                }




                let accumTotal = 0;

                listTransactionInfo.forEach( async (value, index) => {

                    if(value.flLineBalance != null && !isNaN(value.flLineBalance)  && value.flLineBalance != undefined) {
                        value.flLineBalance += accumTotal;
                    } else {
                        value.flLineBalance = runningTotal; // no balance get so previous calculated balance
                    }

                    if(value.fbItemAmount != null && !isNaN(value.fbItemAmount) && value.fbItemAmount != undefined) {
                        accumTotal += value.fbItemAmount;
                        value.flLineBalance += value.fbItemAmount;

                    } 

                    runningTotal = value.flLineBalance;

                    if(value.flFinLineID != undefined) {

                        let sqlUpdate = "UPDATE finlines SET LineBalance = " + value.flLineBalance + " WHERE FinLineID = " + value.flFinLineID;
                        result = await conn.query(sqlUpdate);

                    } else {
                        let sqlInsert = "INSERT INTO finlines (UserID, SequenceID, AssetID, LiabilityID, LineDate, LineBalance) VALUES (" + 
                            "0" + "," + 
                            "1" + "," + 
                            setNullIfEmpty(req.body.editAsset,true) + "," + 
                            setNullIfEmpty(req.body.editLiability,true) + "," + 
                            setNullIfEmpty(value.flLineDate.format('YYYY-MM-DD'),false) + "," + 
                            setNullIfEmpty(value.flLineBalance,true) + ")";
    
                            result = await conn.query(sqlInsert);
                    }
                })

                return listTransactionInfo

            }
            catch {
                console.log("Failed: buildSQLStatements()");
            }
        }

        async function updateAppliedStatus(conn) {

            try {
                let sqlUpdate = "UPDATE incomes SET Applied = 1 WHERE IncomeID = " + setNullIfEmpty(req.body.hiddenIncomeID,true);
                result = await conn.query(sqlUpdate);
            } catch {
                console.log("Failed: updateAppliedStatus()");
            }
        }

        const connectionPool = mysql2.createPool(connConfig);
        const conn = await connectionPool.getConnection();
        
        try {
            await conn.beginTransaction();

            // Moved from Income Save
            await processInsertFinbreakdowns(conn, req.body.hiddenIncomeID);

            let listRelaventLines = await getRelaventLines(conn);

            let listRelaventBreakdowns = await getRelaventBreakdowns(conn);

            let listSQLStaement = await buildSQLStatements(listRelaventLines, listRelaventBreakdowns);

            await updateAppliedStatus(conn);

            //throw new Error('Error Test');
            
            await conn.commit();
            console.log("commit");

        } catch {
                await conn.rollback();
                console.log("rollback");
        } finally {
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        }
    }

    if(req.body.hiddenIncomeID != "" && parseInt(req.body.hiddenIncomeID) != "NaN") {
    
        processApplyIncomeToCache();
    }
});

// Expense Types

app.post('/expensetypes/update', expensetype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.hiddenExpenseTypeID == "")
    {
        const sql = "INSERT INTO expensetypes (Name,Description) VALUES ('" + 
            req.body.editName + "','" + 
            req.body.editDescription + "')";
            
            connection.query(sql, (err,result) => {
                if(err) throw err;

                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenExpenseTypeID) != "NaN")
    {
        const sql = "UPDATE expensetypes SET Name = '" + req.body.editName + 
            "', Description = '" + req.body.editDescription +
            "' WHERE ExpenseTypeID = '" + req.body.hiddenExpenseTypeID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/expensetypes/delete', expensetype_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);
    if(req.body.hiddenExpenseTypeID !="" && parseInt(req.body.hiddenExpenseTypeID) != "NaN")
        {
            const sql = "DELETE FROM expensetypes WHERE ExpenseTypeID = '" + req.body.hiddenExpenseTypeID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;

                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

// Expenses

app.post('/expenses/update', expense_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    async function processNewExpense(pool)
    {
        async function processExpenseIncome(conn) {
            try {

                const sql1 = "INSERT INTO expenses (Name, Description, ExpenseTypeID, AssetID, LiabilityID, StartDate, EndDate, Amount, RecurringPeriodID, LastPaidDate) VALUES (" + 
                setNullIfEmpty(req.body.editName,false) + "," + 
                setNullIfEmpty(req.body.editDescription,false) + "," + 
                setNullIfEmpty(req.body.editExpenseType,true) + "," + 
                setNullIfEmpty(req.body.editAsset,true) + "," + 
                setNullIfEmpty(req.body.editLiability,true) + "," + 
                setNullIfEmpty(req.body.editStartDate,false) + "," + 
                setNullIfEmpty(req.body.editEndDate,false) + "," + 
                setNullIfEmpty(req.body.editAmount,true) + "," + 
                setNullIfEmpty(req.body.editRecurringPeriod,true) + "," + 
                setNullIfEmpty(req.body.editLastPaidDate,false) + ")";

                result = await conn.query(sql1);
                
                return result[0].insertId;
            }
            catch {
                console.log("Failed: processExpenseIncome");
            }
        }

        const connectionPool = mysql2.createPool(connConfig);
        const conn = await connectionPool.getConnection();
        
        try {
            await conn.beginTransaction();

            let incomeExpenseID = await processExpenseIncome(conn);

            //throw new Error('Error Test');
            
            await conn.commit();
            console.log("commit");

        } catch {
                await conn.rollback();
                console.log("rollback");
        } finally {

            res.redirect(req.get('referer'));
            console.log("Data Returned");
        }
    }

    async function processExpenseUpdate() {
        const sql = "UPDATE expenses SET " +
        "Name = " + setNullIfEmpty(req.body.editName,false) + "," + 
        "Description = " + setNullIfEmpty(req.body.editDescription,false) + "," + 
        "ExpenseTypeID = " + setNullIfEmpty(req.body.editExpenseType,true) + "," + 
        "AssetID = " + setNullIfEmpty(req.body.editAsset,true) + "," + 
        "LiabilityID = " + setNullIfEmpty(req.body.editLiability,true) + "," + 
        "StartDate = " + setNullIfEmpty(req.body.editStartDate,false) + "," + 
        "EndDate = " + setNullIfEmpty(req.body.editEndDate,false) + "," + 
        "Amount = " + setNullIfEmpty(req.body.editAmount,true) + "," + 
        "RecurringPeriodID = " + setNullIfEmpty(req.body.editRecurringPeriod,true) + "," + 
        "LastPaidDate = " + setNullIfEmpty(req.body.editLastPaidDate,false) +
        " WHERE ExpenseID = '" + req.body.hiddenExpenseID + "'";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }

    if(req.body.editExpenseType == "0") {
        req.body.editExpenseType = "";
    }

    if(req.body.hiddenExpenseID == "") {
        processNewExpense();
    }
    else if(req.body.hiddenExpenseID != "" && parseInt(req.body.hiddenExpenseID) != "NaN")
    {
        processExpenseUpdate();
    }
});

app.post('/expenses/delete', expense_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.hiddenExpenseID != "" && parseInt(req.body.hiddenExpenseID) != "NaN")
        {
            const sql = "DELETE FROM expenses WHERE ExpenseID = '" + req.body.hiddenExpenseID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.post('/expenses/apply', expense_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    class clsTransactionInfo { flLineDate; flLineBalance; fbItemDate; fbItemAmount; fbItemIteration; flFinLineID;};

    async function processApplyExpenseToCache() {

        // Moved form Expense Save
        async function calculatefinLineItemIterations(iOre, incomeExpense, incomeExpenseId) {
    
            let dateIteration = moment(incomeExpense.editStartDate);
            let endDate = moment(incomeExpense.editEndDate);
        
            let finLines = [[]];
        
            let iterationIndex = 0;
            while(endDate >= dateIteration)
            {   
                if(iterationIndex > 0) {
                    finLines.push([]);
                }

                if(iOre == IncomeOrExpense.Income) {
                    finLines[iterationIndex][0] = incomeExpenseId;
                    finLines[iterationIndex][1] = "";
                } else if(iOre == IncomeOrExpense.Expense) {
                    finLines[iterationIndex][0] = "";
                    finLines[iterationIndex][1] = incomeExpenseId;
                } else {
                    finLines[iterationIndex][0] = "";
                    finLines[iterationIndex][1] = "";
                }
                finLines[iterationIndex][2] = dateIteration.format("YYYY-MM-DD");
                finLines[iterationIndex][3] = incomeExpense.editName;
                finLines[iterationIndex][4] = incomeExpense.editAmount;
                finLines[iterationIndex][5] = iterationIndex;
        
                dateIteration = setNextDatePeriod(dateIteration,incomeExpense.editRecurringPeriod);
                iterationIndex++;
            }
        
            return finLines;
        };
        // Moved form Expense Save
        async function processInsertFinbreakdowns(conn, incomeExpenseID) {
            try {
                const finLineItemInterations = await calculatefinLineItemIterations(IncomeOrExpense.Expense, req.body, incomeExpenseID);

                finLineItemInterations.forEach(element => {
                    let sql3 = "INSERT INTO finbreakdowns (IncomeID, ExpenseID, ItemDate, ItemName, ItemAmount, ItemIteration) VALUES (" + 
                        setNullIfEmpty(element[0],true) + "," + 
                        setNullIfEmpty(element[1],true) + "," + 
                        setNullIfEmpty(element[2],false) + "," + 
                        setNullIfEmpty(element[3],false) + "," + 
                        setNullIfEmpty(element[4],true) + "," + 
                        element[5] + ")";

                        result = conn.query(sql3);
                });
            }
            catch {
                console.log("Failed: processInsertFinbreakdowns()");
            }
        }

        async function getRelaventLines(conn) {
            try {
                let mondayDate = await getDayOfWeekDate(req.body.editStartDate,1);

                const sql1 = "SELECT FinLineID, fl.LineDate, fl.LineBalance FROM finlines fl WHERE " +
                                "fl.AssetID " + convertSelectNull(req.body.editAsset,true) + " AND " +
                                "fl.LiabilityID " + convertSelectNull(req.body.editLiability,true) + " AND " +
                                "fl.LineDate >= '" + mondayDate.format("YYYY-MM-DD") + "' " +
                                "ORDER BY fl.LineDate";
                                result = await conn.query(sql1);

                return result[0];
            }
            catch {
                console.log("Failed: getRelaventLines()");
            }
        }

        async function getRelaventBreakdowns(conn) {
            try {

                const sql1 = "SELECT fb.ItemDate, fb.ItemName, fb.ItemAmount, fb.ItemIteration FROM finbreakdowns fb WHERE " +
                                "fb.IncomeID " + convertSelectNull(req.body.hiddenIncomeID,true) + " AND " +
                                "fb.ExpenseID " + convertSelectNull(req.body.hiddenExpenseID,true) + " AND " +                                                              
                                "fb.ItemDate >= " + setNullIfEmpty(req.body.editStartDate,false) + " AND " +
                                "fb.ItemDate <= " + setNullIfEmpty(req.body.editEndDate,false) + " " +
                                "ORDER BY fb.ItemDate";
                result = await conn.query(sql1);

                return result[0];
            }
            catch {
                console.log("Failed: getRelaventBreakdowns()");
            }
        }

        async function buildSQLStatements(listRelaventLines, listRelaventBreakdowns) {

            let listTransactionInfo = new Array();

            try {
                // Load Lines Entries
                await listRelaventLines.forEach( (value, index) => {
                    
                    let objTransactionInfo = new clsTransactionInfo();
                    objTransactionInfo.flLineDate = moment(value.LineDate);
                    objTransactionInfo.flLineBalance = parseFloat(value.LineBalance);
                    objTransactionInfo.fbItemDate = null;
                    objTransactionInfo.fbItemAmount = null;
                    objTransactionInfo.fbItemIteration = null;
                    objTransactionInfo.flFinLineID = value.FinLineID;

                    listTransactionInfo.push(objTransactionInfo);
                })
                
                // Load Breakdowns Entries
                await listRelaventBreakdowns.forEach( async (value, index) => {

                    let DOWDate = await getDayOfWeekDate(value.ItemDate,1)
                    let i = listTransactionInfo.findIndex( (element) => {  return (moment(element.flLineDate).isSame(DOWDate,'day')) });
                    if(i < 0) {
                        let objTransactionInfo = new clsTransactionInfo();
                        objTransactionInfo.flLineDate = DOWDate;
                        objTransactionInfo.fbItemDate = moment(value.ItemDate)
                        objTransactionInfo.fbItemAmount = parseFloat(value.ItemAmount);
                        objTransactionInfo.fbItemIteration = value.ItemIteration;

                        listTransactionInfo.push(objTransactionInfo);
                    }
                    else if (i >= 0)
                    {
                        listTransactionInfo.at(i).fbItemDate = moment(value.ItemDate)
                        listTransactionInfo.at(i).fbItemAmount = parseFloat(value.ItemAmount);
                        listTransactionInfo.at(i).fbItemIteration = value.ItemIteration;
                    }
                })

                listTransactionInfo.sort( (a,b) => { return (a.flLineDate - b.flLineDate) });

                const sqlRunningTotal = "SELECT LineBalance FROM finlines WHERE LineBalance IS NOT NULL AND  " +
                                            "AssetID " + convertSelectNull(req.body.editAsset,true) + " AND " +
                                            "LiabilityID " + convertSelectNull(req.body.editLiability,true) + " AND " +
                                            "LineDate <= " + setNullIfEmpty(req.body.editStartDate,false) + " " +
                                            "ORDER BY LineDate DESC LIMIT 1";

                resultx = await conn.query(sqlRunningTotal);

                let runningTotal = 0.0;

                if(resultx[0].length > 0) {
                    runningTotal =  parseFloat(resultx[0][0].LineBalance);
                }
                else {

                    try {
                        let sqlAssetOrLiabilityCurrentBalance = "";
                        if(req.body.editAsset != null && !isNaN(req.body.editAsset) && req.body.editAsset != undefined) {
                            sqlAssetOrLiabilityCurrentBalance = "SELECT CurrentBalance FROM assets WHERE " +
                                            "AssetID " + convertSelectNull(req.body.editAsset,true);
                        } else if(req.body.editLiability != null && !isNaN(req.body.editLiability) && req.body.editLiability != undefined) {
                            sqlAssetOrLiabilityCurrentBalance = "SELECT CurrentBalance FROM liabilities WHERE " +
                                        "LiabilityID " + convertSelectNull(req.body.editLiability,true);
                        }

                        const resultsAssetOrLiabilityCurrentBalance = await conn.query(sqlAssetOrLiabilityCurrentBalance);

                        if(resultsAssetOrLiabilityCurrentBalance[0].length > 0){
                            
                            if(resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance != null && !isNaN(resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance) && resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance != undefined) {

                                runningTotal = parseFloat(resultsAssetOrLiabilityCurrentBalance[0][0].CurrentBalance);

                            } else {
                                runningTotal = 0.0;
                            }
                        }
                    }
                    catch {

                    }
                }
                    

                let accumTotal = 0;

                listTransactionInfo.forEach( async (value, index) => {

                    if(value.flLineBalance != null && !isNaN(value.flLineBalance)  && value.flLineBalance != undefined) {
                        value.flLineBalance += accumTotal;
                    } else {
                        value.flLineBalance = runningTotal; // no balance get so previous calculated balance
                    }

                    if(value.fbItemAmount != null && !isNaN(value.fbItemAmount) && value.fbItemAmount != undefined) {
                        accumTotal -= value.fbItemAmount;
                        value.flLineBalance -= value.fbItemAmount;
                    } 

                    runningTotal = value.flLineBalance;

                    if(value.flFinLineID != undefined) {

                        let sqlUpdate = "UPDATE finlines SET LineBalance = " + value.flLineBalance + " WHERE FinLineID = " + value.flFinLineID;
                        result = await conn.query(sqlUpdate);

                    } else {
                        let sqlInsert = "INSERT INTO finlines (UserID, SequenceID, AssetID, LiabilityID, LineDate, LineBalance) VALUES (" + 
                            "0" + "," + 
                            "1" + "," + 
                            setNullIfEmpty(req.body.editAsset,true) + "," + 
                            setNullIfEmpty(req.body.editLiability,true) + "," + 
                            setNullIfEmpty(value.flLineDate.format('YYYY-MM-DD'),false) + "," + 
                            setNullIfEmpty(value.flLineBalance,true) + ")";

                            result = await conn.query(sqlInsert);
                    }
                })

                return listTransactionInfo

            }
            catch {
                console.log("Failed: buildSQLStatements()");
            }
        }

        async function updateAppliedStatus(conn) {

            try {
                let sqlUpdate = "UPDATE expenses SET Applied = 1 WHERE ExpenseID = " + setNullIfEmpty(req.body.hiddenExpenseID,true);
                result = await conn.query(sqlUpdate);
            } catch {
                console.log("Failed: updateAppliedStatus()");
            }
        }

        const connectionPool = mysql2.createPool(connConfig);
        const conn = await connectionPool.getConnection();
        
        try {
            await conn.beginTransaction();

            // Moved from Expense Save
            await processInsertFinbreakdowns(conn, req.body.hiddenExpenseID);

            let listRelaventLines = await getRelaventLines(conn);

            let listRelaventBreakdowns = await getRelaventBreakdowns(conn);

            let listSQLStaement = await buildSQLStatements(listRelaventLines, listRelaventBreakdowns);

            await updateAppliedStatus(conn);

            //throw new Error('Error Test');
            
            await conn.commit();
            console.log("commit");

        } catch {
                await conn.rollback();
                console.log("rollback");
        } finally {
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        }
    }

    if(req.body.hiddenExpenseID != "" && parseInt(req.body.hiddenExpenseID) != "NaN") {
    
        processApplyExpenseToCache();
    }
});

app.post('/financecols/update', fincols_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    sequenceID = setNullIfEmpty(req.body.editSequenceID,true);
    if(sequenceID == "null")
    {
        sequenceID = "999";
    }

    if(req.body.hiddenFinColID == "")
    {
        const sql = "INSERT INTO fincols (UserID,SequenceID,AssetID,LiabilityID,Name) VALUES (" + 
            '0' + "," + 
            sequenceID + "," + 
            setNullIfEmpty(req.body.editAsset,true) + "," + 
            setNullIfEmpty(req.body.editLiability,true) + "," + 
            setNullIfEmpty(req.body.editName,false) + ")";
            
            connection.query(sql, (err,result) => {
                if(err) throw err;

                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
    }
    else if(parseInt(req.body.hiddenFinColID) != "NaN")
    {
        const sql = "UPDATE fincols SET SequenceID = " + sequenceID + 
        ", AssetID = " + setNullIfEmpty(req.body.editAsset,true) +
        ", LiabilityID = " + setNullIfEmpty(req.body.editLiability,true) +
        ", Name = " + setNullIfEmpty(req.body.editName,false) +
        " WHERE FinColID = " + req.body.hiddenFinColID + " ";

        connection.query(sql, (err,result) => {
            if(err) throw err;
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        });
    }
});

app.post('/financecols/delete', fincols_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    if(req.body.hiddenFinColID == "0") {
        req.body.hiddenFinColID = "";
    }

    if(req.body.hiddenFinColID != "" && parseInt(req.body.hiddenFinColID) != "NaN")
        {
            const sql = "DELETE FROM fincols WHERE FinColID = '" + req.body.hiddenFinColID + "'";

            connection.query(sql, (err,result) => {
                if(err) throw err;
                res.redirect(req.get('referer'));
                console.log("Data Returned");
            });
        }
});

app.get('/financebreakdowns', (req, res) => {

    console.log(req.query.dateBreakdown);

    async function processBreakdowns() {

         try {
            
            let sqlWhere = "";

            if(req.query.dateBreakdown != undefined)
            {

                dt = moment(req.query.dateBreakdown);
                dtStart = dt.format("YYYY-MM-DD");
                dt.add(6, "days");
                dtEnd = dt.format("YYYY-MM-DD");

                sqlWhere = " WHERE fb.ItemDate >= '" + dtStart + "' AND fb.ItemDate <= '" + dtEnd + "' "
            }

            let sql1 = " SELECT fb.FinBreakdownID, fb.ItemIteration, fb.IncomeID, i.Name as IncomeName, fb.ExpenseID, e.Name as ExpenseName, DATE_FORMAT(fb.ItemDate,'%Y-%m-%d') as ItemDate, fb.ItemName, fb.ItemAmount " +
                "FROM finbreakdowns fb" + " " +
                "LEFT OUTER JOIN incomes i ON fb.IncomeID = i.IncomeID" + " " +
                "LEFT OUTER JOIN expenses e ON fb.ExpenseID = e.ExpenseID" + " " +
                sqlWhere +
                "ORDER BY ItemDate";

            connection.query( sql1, (err, results1) => {
                if (err) {
                    return res.send('Error fetching data: ' + err.message);
                }

                connection.query('SELECT IncomeID, Name FROM incomes ORDER BY Name', (err, results2) => {
                    if (err) {
                        return res.send('Error fetching data: ' + err.message);
                    }
                    connection.query('SELECT ExpenseID, Name FROM expenses ORDER BY Name', (err, results3) => {
                        if (err) {
                            return res.send('Error fetching data: ' + err.message);
                        }
                        else {
                            let messages = null; // messaging is not implemented
                            res.render('financebreakdowns', { messages: messages, financebreakdowns: results1, incomes: results2, expenses: results3});                            
                        }
                    });  
                });
            });

        } catch {

        } finally {

        }
    }

    processBreakdowns();
});

app.post('/financebreakdowns/update', finbreakdowns_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    class clsTransactionInfo { flLineDate; flLineBalance; fbItemDate; fbItemAmount; fbItemIteration; flFinLineID;};

    async  function processUpdate() {

        async function buildSQLStatements(conn, currItemAmount, itemDate) {

            let SOWItemDate = await getDayOfWeekDate(itemDate.format("YYYY-MM-DD"),1);
            let SOWItemDateValue = SOWItemDate.format("YYYY-MM-DD");

            iterationValue = setNullIfEmpty(req.body.ItemIteration,true);
            if(iterationValue == "null")
            {
                iterationValue = "999";
            }

            let assetID = null;
            let liabilityID = null;

            if(req.body.editIncomeOrExpense == IncomeOrExpense.Income) {

                const sql1 = "SELECT AssetID, LiabilityID FROM incomes WHERE IncomeID = " + setNullIfEmpty(req.body.editIncome,true);

                results1 = await conn.query(sql1);

                if(results1[0].length > 0) {

                    if(results1[0].length > 0) {
                        assetID =  parseInt(results1[0][0].AssetID);;
                        if(assetID == undefined) {
                            assetID = null;
                        }
                    }
                    if(results1[0].length > 0) {
                        liabilityID =  parseInt(results1[0][0].LiabilityID);
                        if(liabilityID == undefined) {
                            liabilityID = null;
                        }
                    }
                };
            } else if(req.body.editIncomeOrExpense == IncomeOrExpense.Expense) {

                const sql1 = "SELECT AssetID, LiabilityID FROM expenses WHERE ExpenseID = " + setNullIfEmpty(req.body.editExpense,true)
              
                results1 = await conn.query(sql1);

                if(results1[0].length > 0) {

                    if(results1[0].length > 0) {
                        assetID =  parseInt(results1[0][0].AssetID);
                        if(assetID == undefined) {
                            assetID = null;
                        }
                    }
                    if(results1[0].length > 0) {
                        liabilityID =  parseInt(results1[0][0].LiabilityID);
                        if(liabilityID == undefined) {
                            liabilityID = null;
                        }
                    }
                }
            }

            let startBalance = 0.0;
            let sqlWhereLineDate = "";

            if(SOWItemDate != undefined) {
           
            sqlWhereLineDate = " AND LineDate < '" + SOWItemDateValue + "' ";
            }

            const sqlStartingBalance = "SELECT LineBalance FROM finlines WHERE LineBalance IS NOT NULL AND  " +
            "AssetID " + convertSelectNull(assetID,true) + " AND " +
            "LiabilityID " + convertSelectNull(liabilityID,true) + " AND " +
            "LineDate < " + setNullIfEmpty(req.body.editStartDate,false) + " " +
            sqlWhereLineDate + " " +            
            "ORDER BY LineDate DESC LIMIT 1";
  
            const resultsStartingBalance = await conn.query(sqlStartingBalance);
            
            if(resultsStartingBalance[0].length > 0) {
                startBalance =  parseFloat(resultsStartingBalance[0][0].LineBalance);
            }

            let sqlWhere = "";

            if(SOWItemDate != undefined) {
                let dtStart = SOWItemDate.format("YYYY-MM-DD");
                let dt = moment(SOWItemDate);
                dt.add(6, "days");
                let dtEnd = dt.format("YYYY-MM-DD");
        
                sqlWhere = " AND LineDate >= '" + dtStart + "' ";
            }

            const sql2 = "SELECT FinLineID, LineBalance, LineDate FROM finlines WHERE " +
                " AssetID " + convertSelectNull(assetID,true) + " AND " +
                " LiabilityID " + convertSelectNull(liabilityID,true) + " " +
                sqlWhere + " " +
                " ORDER BY LineDate";

            results2 = await conn.query(sql2);

            listRelaventLines = results2[0];

            let listTransactionInfo = new Array();

            try {
                // Load Lines Entries FinBreakdowns not yet implemenedted but could be used to cascade accumulative values in the future
                await listRelaventLines.forEach( (value, index) => {
                    
                    let objTransactionInfo = new clsTransactionInfo();
                    objTransactionInfo.flLineDate = moment(value.LineDate);
                    objTransactionInfo.flLineBalance = parseFloat(value.LineBalance);
                    objTransactionInfo.fbItemDate = null;
                    objTransactionInfo.fbItemAmount = null;
                    objTransactionInfo.fbItemIteration = null;
                    objTransactionInfo.flFinLineID = value.FinLineID;

                    listTransactionInfo.push(objTransactionInfo);
                })
                
                listTransactionInfo.sort( (a,b) => { return (a.flLineDate - b.flLineDate) });

                let lastFinanceBreakdownAmount = 0


                const sqlPreviousAmount = "SELECT ItemAmount FROM finbreakdowns WHERE " +
                "  FinBreakdownID = " + setNullIfEmpty(req.body.hiddenFinBreakdownID,true); 

                let resultsPreviousAmount = await conn.query(sqlPreviousAmount);

                if(resultsPreviousAmount[0].length > 0) {

                    lastFinanceBreakdownAmount = parseFloat(resultsPreviousAmount[0][0].ItemAmount);
                }

                let runningTotal = 0.0;

                runningTotal = startBalance;

                let accumTotal = 0;

                listTransactionInfo.forEach( async (value, index) => {

                    if(value.flLineBalance != null && !isNaN(value.flLineBalance)  && value.flLineBalance != undefined) {
                        if(req.body.editIncomeOrExpense == IncomeOrExpense.Income)
                        {
                            value.flLineBalance += (currItemAmount - lastFinanceBreakdownAmount)
                        } else if(req.body.editIncomeOrExpense == IncomeOrExpense.Expense) {
                            value.flLineBalance += (lastFinanceBreakdownAmount - currItemAmount);
                        } 
                    }
                    else {
                        value.flLineBalance = runningTotal; // no balance get so previous calculated balance
                    }

                    runningTotal = value.flLineBalance;

                    if(value.flFinLineID != undefined) {

                        let sqlUpdate = "UPDATE finlines SET LineBalance = " + value.flLineBalance + " WHERE FinLineID = " + value.flFinLineID;
                        result = await conn.query(sqlUpdate);
 
                    } 
                })

                return listTransactionInfo

            }
            catch {
                console.log("Failed: buildSQLStatements()");
            }
        }

        const connectionPool = mysql2.createPool(connConfig);
        const conn = await connectionPool.getConnection();

        userMessages = new clsMessages();

        try {
            await conn.beginTransaction();
            let itemDate = moment(req.body.editItemDate);
            if(itemDate == undefined)
            {
                itemDate = (moment.now());
            }

            let itemAmount = parseFloat(req.body.editItemAmount);
            if(itemAmount == undefined) {
                itemAmount = 0;
            }

            let listSQLStaement = await buildSQLStatements(conn, itemAmount, itemDate);

            if(parseInt(req.body.hiddenFinBreakdownID) != "NaN")
            {
                const sql4 = "UPDATE finbreakdowns SET " +
                " IncomeID = " + setNullIfEmpty(req.body.editIncome,true) +
                ", ExpenseID = " + setNullIfEmpty(req.body.editExpense,true) +
                ", ItemDate = " + "'" + itemDate.format("YYYY-MM-DD") + "'" + 
                ", ItemName = " + setNullIfEmpty(req.body.editItemName,false) +
                ", ItemAmount = " + itemAmount +
                ", ItemIteration = " + iterationValue +
                " WHERE FinBreakdownID = " + req.body.hiddenFinBreakdownID + " ";
             
                results4 = await conn.query(sql4);
            }

            //throw new Error('Error Test');

            await conn.commit();
            console.log("commit");
    } catch {
            await conn.rollback();
            console.log("rollback");
    } finally {
        res.URLSearchParams = userMessages.parseURLSearchParams();
        res.redirect(req.get('referer'));
        console.log("Data Returned");
    }
}

    processUpdate();
});

app.post('/financebreakdowns/delete', finbreakdowns_middle, (req,res) => {

    console.log("Data Received");
    console.log(req.body);

    class clsTransactionInfo { flLineDate; flLineBalance; fbItemDate; fbItemAmount; fbItemIteration; flFinLineID;};

    async  function processDelete() {

        async function buildSQLStatements(conn, finBreakdownID) {

            let assetID = null;
            let liabilityID = null;

            let incomeOrExpense = IncomeOrExpense.Null;

            let SOWItemDate = null;
            let SOWItemDateValue = null;
            
            let incomeID = null;
            let expenseID = null;
            let itemDate = null;
            let itemAmount = null;

            let listTransactionInfo = new Array();

            try {

                const sqlGetFinBreakdown = "SELECT IncomeID, ExpenseID, ItemDate, ItemAmount, ItemIteration FROM finbreakdowns WHERE " +
                "  FinBreakdownID = " + setNullIfEmpty(finBreakdownID,true); 

                let resultsGetFinBreakdown = await conn.query(sqlGetFinBreakdown);

                if(resultsGetFinBreakdown[0].length > 0) {

                    incomeID = (resultsGetFinBreakdown[0][0].IncomeID);
                    expenseID = (resultsGetFinBreakdown[0][0].ExpenseID);
                    itemAmount = parseFloat(resultsGetFinBreakdown[0][0].ItemAmount);
                    itemDate = moment(resultsGetFinBreakdown[0][0].ItemDate);

                    console.log(resultsGetFinBreakdown[0][0].ItemDate);

                    SOWItemDate = await getDayOfWeekDate(itemDate.format("YYYY-MM-DD"),1);
                    SOWItemDateValue = SOWItemDate.format("YYYY-MM-DD");

                    if(incomeID != null && !isNaN(incomeID) && (expenseID == null || isNaN(expenseID))) {
                        incomeOrExpense = IncomeOrExpense.Income;
                    } else if(expenseID != null && !isNaN(expenseID) && (incomeID == null || isNaN(incomeID))) {
                        incomeOrExpense = IncomeOrExpense.Expense;
                    }

                    if(incomeOrExpense == IncomeOrExpense.Income) {

                        const sql1 = "SELECT AssetID, LiabilityID FROM incomes WHERE IncomeID = " + setNullIfEmpty(req.body.editIncome,true);
  
                        results1 = await conn.query(sql1);
        
                        if(results1[0].length > 0) {
        
                            if(results1[0].length > 0) {
                                assetID =  parseInt(results1[0][0].AssetID);;
                                if(assetID == undefined) {
                                    assetID = null;
                                }
                            }
                            if(results1[0].length > 0) {
                                liabilityID =  parseInt(results1[0][0].LiabilityID);
                                if(liabilityID == undefined) {
                                    liabilityID = null;
                                }
                            }
                        };
                    } else if(incomeOrExpense == IncomeOrExpense.Expense) {
        
                        const sql1 = "SELECT AssetID, LiabilityID FROM expenses WHERE ExpenseID = " + setNullIfEmpty(req.body.editExpense,true)
              
                        results1 = await conn.query(sql1);
        
                        if(results1[0].length > 0) {
        
                            if(results1[0].length > 0) {
                                assetID =  parseInt(results1[0][0].AssetID);
                                if(assetID == undefined) {
                                    assetID = null;
                                }
                            }
                            if(results1[0].length > 0) {
                                liabilityID =  parseInt(results1[0][0].LiabilityID);
                                if(liabilityID == undefined) {
                                    liabilityID = null;
                                }
                            }
                        }
                    }
        
                    let startBalance = 0.0;
                    let sqlWhereLineDate = "";
        
                    if(SOWItemDate != undefined) {
        
                        sqlWhereLineDate = " AND LineDate < '" + SOWItemDateValue + "' ";
                    }
        
                    const sqlStartingBalance = "SELECT LineBalance FROM finlines WHERE LineBalance IS NOT NULL AND  " +
                    "AssetID " + convertSelectNull(assetID,true) + " AND " +
                    "LiabilityID " + convertSelectNull(liabilityID,true) + " AND " +
                    "LineDate < " + setNullIfEmpty(req.body.editStartDate,false) + " " +
                    sqlWhereLineDate + " " +            
                    "ORDER BY LineDate DESC LIMIT 1";
      
                    const resultsStartingBalance = await conn.query(sqlStartingBalance);
                    
                    if(resultsStartingBalance[0].length > 0) {
                        startBalance =  parseFloat(resultsStartingBalance[0][0].LineBalance);
                    }
        
                    const sql2 = "SELECT FinLineID, LineBalance, LineDate FROM finlines WHERE " +
                        " AssetID " + convertSelectNull(assetID,true) + " AND " +
                        " LiabilityID " + convertSelectNull(liabilityID,true) + " " +
                        " AND LineDate >= '" + SOWItemDateValue + "' "
                        " ORDER BY LineDate";

                    results2 = await conn.query(sql2);
        
                    let listRelaventLines = results2[0];
      
                    // Load Lines Entries FinBreakdowns not yet implemenedted but could be used to cascade accumulative values in the future
                    await listRelaventLines.forEach( (value, index) => {
                        
                        let objTransactionInfo = new clsTransactionInfo();
                        objTransactionInfo.flLineDate = moment(value.LineDate);
                        objTransactionInfo.flLineBalance = parseFloat(value.LineBalance);
                        objTransactionInfo.fbItemDate = null;
                        objTransactionInfo.fbItemAmount = null;
                        objTransactionInfo.fbItemIteration = null;
                        objTransactionInfo.flFinLineID = value.FinLineID;

                        listTransactionInfo.push(objTransactionInfo);
                    })
                    
                    listTransactionInfo.sort( (a,b) => { return (a.flLineDate - b.flLineDate) });

                    let runningTotal = 0.0;

                    runningTotal = startBalance;

                    let accumTotal = 0;

                    listTransactionInfo.forEach( async (value, index) => {

                        if(value.flLineBalance != null && !isNaN(value.flLineBalance)  && value.flLineBalance != undefined) {
                            if(incomeOrExpense == IncomeOrExpense.Income)
                            {
                                value.flLineBalance -= (itemAmount)
                            } else if(incomeOrExpense == IncomeOrExpense.Expense) {
                                value.flLineBalance += (itemAmount);
                            } 
                        }
                        else {
                            value.flLineBalance = runningTotal; // no balance get so previous calculated balance
                        }

                        runningTotal = value.flLineBalance;

                        if(value.flFinLineID != undefined) {
                            let sqlUpdate = "UPDATE finlines SET LineBalance = " + value.flLineBalance + " WHERE FinLineID = " + value.flFinLineID;

                            result = await conn.query(sqlUpdate);

                        } 
                    })
                }

                return listTransactionInfo;
            }
                catch {
                    console.log("Failed: buildSQLStatements()");
                }
        }

        const connectionPool = mysql2.createPool(connConfig);
        const conn = await connectionPool.getConnection();

        userMessages = new clsMessages();

        try {
            await conn.beginTransaction();
            let listSQLStaement = await buildSQLStatements(conn, req.body.hiddenFinBreakdownID);

            if(req.body.hiddenFinBreakdownID == "0") {
                req.body.hiddenFinBreakdownID = "";
            }
        
            if(req.body.hiddenFinBreakdownID != "") {
                    const sqlDelete = "DELETE FROM finbreakdowns WHERE FinBreakdownID = '" + req.body.hiddenFinBreakdownID + "'";

                    resultsDelete = await conn.query(sqlDelete);
                }

            //throw new Error('Error Test');

            await conn.commit();
            console.log("commit");
        } catch {
                await conn.rollback();
                console.log("rollback");
        } finally {
            res.URLSearchParams = userMessages.parseURLSearchParams();
            res.redirect(req.get('referer'));
            console.log("Data Returned");
        }
    }

    processDelete();

});

// Start the server
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});