package data

/*
#include <sql.h>
#include <sqlext.h>
#cgo linux LDFLAGS: -lodbc -ldl
#cgo darwin LDFLAGS: -lodbc -ldl
#cgo linux CFLAGS: -I"/usr/include/" -std=c11
#cgo darwin CFLAGS: -I"/usr/local/include/" -std=c11
*/
import "C";
import (
	"../common"
	"fmt"
)
var MAX_COLUMN_LENGTH = 1024;

type DataConnectionOdbc struct {
	hEnv                     C.SQLHENV
	hHandler                 C.SQLHDBC
	DatabaseConnectionString string
	DatabaseUsername         string
	DatabasePassword         string
	IsConnected              bool
}
func (x *DataConnectionOdbc) check(a C.SQLRETURN, b string) {
	if a != C.SQL_SUCCESS && a != C.SQL_SUCCESS_WITH_INFO && a != 100  && b != " data" {
		panic(fmt.Sprintf("%s (%v)", b, a));
	}
}
func (x *DataConnectionOdbc) Query(a string) *DataTable {
	var result = &DataTable{};
	var statement C.SQLHSTMT;
    var columns = x.GetColumnNames(a);
    if x.connect() {
        x.check(C.SQLAllocHandle(C.SQL_HANDLE_STMT, x.hHandler, &statement), "Allocate statement (Query)");
        x.check(C.SQLExecDirect(statement, (*C.uchar)(common.ToConstStr(a)), C.SQL_NTS), "Execute");
        var row = -1;
        var status C.SQLRETURN;
        for ;; {
            row++;
            status = C.SQLFetch(statement);
            if status != C.SQL_SUCCESS && status != C.SQL_SUCCESS_WITH_INFO {
                if status != 100 {
					println(fmt.Sprintf("Error occurred on fetch... %v", status));
				}
                break;
            }
            var tempRow = &DataRow{};
            for col := 0; col < len(columns); col++ {
                var data = make([]byte, 400000);
                var tempColumn = &DataColumn{};
				var dataLen C.SQLLEN;
                tempColumn.SetName(columns[col]);
                x.check(C.SQLGetData(statement, C.ushort(col + 1), C.SQL_C_CHAR, C.SQLPOINTER(&data[0]), 400000, &dataLen), "Get data");
                var dataValue = string(data);
                tempColumn.SetValue(dataValue);
                tempRow.AddColumn(tempColumn);
            }
            result.AddRow(tempRow);
        }
        if statement != nil {
            x.check(C.SQLFreeHandle(C.SQL_HANDLE_STMT, statement), "Free statement");
        }
        x.disconnect();
    }
	return result;
}
func (x *DataConnectionOdbc) RunQuery(a string) bool {
	var result = false;
    var statement C.SQLHSTMT;
    if x.connect() {
        x.check(C.SQLAllocHandle(C.SQL_HANDLE_STMT, x.hHandler, &statement), "Allocate statement (RunQuery)");
        _ = C.SQLExecDirect(statement, (*C.SQLCHAR)(common.ToConstStr(a)), C.SQL_NTS);
		_ = C.SQLExecDirect(statement, (*C.SQLCHAR)(common.ToConstStr("COMMIT")), C.SQL_NTS);
        result = true;
        if statement != nil {
            x.check(C.SQLFreeHandle(C.SQL_HANDLE_STMT, statement), "Free statement");
        }
		x.check(C.SQLAllocHandle(C.SQL_HANDLE_STMT, x.hHandler, &statement), "Allocate statement (RunQuery)");
		if statement != nil {
            x.check(C.SQLFreeHandle(C.SQL_HANDLE_STMT, statement), "Free statement");
        }
        x.disconnect();
	}
    return result;
}
func (x DataConnectionOdbc) GetColumnNames(a string) []string {
	var result []string;
	var statement C.SQLHSTMT;
    var cols C.SQLSMALLINT;
    if x.connect() {
        x.check(C.SQLAllocHandle(C.SQL_HANDLE_STMT, x.hHandler, &statement), "Allocate statement (Columns)");
        x.check(C.SQLExecDirect(statement, (*C.uchar)(common.ToConstStr(a)), C.SQL_NTS), "Execute");
        x.check(C.SQLNumResultCols(statement, &cols), "Column count");
        for i := 0; i < int(cols); i++ {
			var columnName = make([]byte, 1024);
            x.check(C.SQLColAttribute(statement, C.ushort(i + 1), C.SQL_DESC_LABEL, C.SQLPOINTER(&columnName[0]), 1000, nil, nil), "Column attribute");
            var value = common.CleanString(string(columnName));
            result = append(result, value);
        }
        if statement != nil {
            x.check(C.SQLFreeHandle(C.SQL_HANDLE_STMT, statement), "Release statement");
        }
        x.disconnect();
    }
	return result;
}
func (x DataConnectionOdbc) GetTableNames() []string {
	var result []string;
	return result;
}
func (x *DataConnectionOdbc) connect() bool {
	if x.IsConnected { return true; }
	x.check(C.SQLAllocHandle(C.SQL_HANDLE_ENV, nil, &x.hEnv), "Allocation of environment");
    x.check(C.SQLSetEnvAttr(x.hEnv, C.SQL_ATTR_ODBC_VERSION, C.SQLPOINTER(uintptr(C.SQL_OV_ODBC2)), 0), "Set version");
    x.check(C.SQLAllocHandle(C.SQL_HANDLE_DBC, x.hEnv, &x.hHandler), "Allocation of connection");
	x.check(C.SQLDriverConnect(x.hHandler, nil, (*C.SQLCHAR)((*C.uchar)(common.ToConstStr(x.DatabaseConnectionString))), C.SQL_NTS, nil, 0, nil, C.SQL_DRIVER_COMPLETE), "Connect");
    C.SQLSetConnectAttr(x.hHandler, C.SQL_ATTR_AUTOCOMMIT, C.SQLPOINTER(uintptr(1)), 0);
	x.IsConnected = true;
	return true;
}
func (x *DataConnectionOdbc) disconnect() {
	x.check(C.SQLDisconnect(x.hHandler), "Disconnect");
	x.check(C.SQLFreeHandle(C.SQL_HANDLE_DBC, x.hHandler), "Release connection");
    x.check(C.SQLFreeHandle(C.SQL_HANDLE_ENV, x.hEnv), "Release environment");
    x.IsConnected = false;
}
func (x DataConnectionOdbc) ConnectionString() string { return x.DatabaseConnectionString; }
func (x DataConnectionOdbc) Username() string { return x.DatabaseUsername; }
func (x DataConnectionOdbc) Password() string { return x.DatabasePassword; }
func (x *DataConnectionOdbc) SetUsername(a string) { x.DatabaseUsername = a; }
func (x *DataConnectionOdbc) SetPassword(a string) { x.DatabasePassword = a; }
func (x *DataConnectionOdbc) SetConnectionString(a string) {
	x.DatabaseConnectionString = a;
	if string(x.DatabaseConnectionString[len(x.DatabaseConnectionString) - 1]) != ";" { x.DatabaseConnectionString += ";"; }
    x.DatabaseConnectionString += fmt.Sprintf("UID=%s;PWD=%s;", x.DatabaseUsername, x.DatabasePassword);
}
