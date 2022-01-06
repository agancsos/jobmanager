package sr
import (
	"../common"
)

// Constants
type TraceCategory int;
const (
    TC_NONE TraceCategory = iota
    TC_SERVICE
)

var TS *common.TraceService;
var APPLICATION_NAME    = "Job Manager Server";
var APPLICATION_VERSION = "1.0.0";
var APPLICATION_AUTHOR  = "Abel Gancsos";
var API_METHODS         = map[string]string {
	"version"            : "Gets the version of the API",
	"hello"              : "Prints a hello world text",
	"multiply"           : "Multiplies a left and right value",
	"divide"             : "Divides a left and right value",
	"add"                : "Adds a left and right value",
	"subtract"           : "Subtracts a left and right value",
};
var APPLICATION_FLAGS   = map[string]string {
    "-h|--help"          : "Print the help menu",
	"-m|--method"        : "Method name to call",
	"-p|--param"         : "Specifies a parameter for the rpc methods",
};
/*****************************************************************************/

// Static resources
type SR struct {
	SS    *common.SystemService
}
var __sr__ *SR;
func GetSRInstance() *SR {
	if __sr__ == nil {
		__sr__ = &SR{};
	}
	return __sr__;
}
func HelpMenu() {
    println(common.PadLeft("", 80, "#"));
    println(common.PadLeft("# Name     : " + APPLICATION_NAME, 79, " ") + "#");
    println(common.PadLeft("# Author   : " + APPLICATION_AUTHOR, 79, " ") + "#");
    println(common.PadLeft("# Version  : " + APPLICATION_VERSION, 79, " ") + "#");
    println(common.PadLeft("# Flags", 79, " ") + "#");
    for key, value := range APPLICATION_FLAGS {
        println(common.PadLeft("#  " + key + ": " + value, 79, " ") + "#");
    }
	println(common.PadLeft("# Methods", 79, " ") + "#");
    for key, value := range API_METHODS {
        println(common.PadLeft("#  " + key + ": " + value, 79, " ") + "#");
    }
    println(common.PadLeft("", 80, "#"));
}

func (x SR) GetConfigurationFile() string {
	return x.SS.BuildModuleContainerPath() + "/resources/config.json";
}

func (x SR) GetLogFilePath(path string) string {
	if path != "" {
         return path;
	}
    return x.SS.BuildModuleContainerPath() + "/jmserver.log";
}

func (x SR) GetDatabaseFilePath(path string) string {
    if path != "" {
         return path;
    }
    return x.SS.BuildModuleContainerPath() + "/resources/jobmonitor.db";
}
/*****************************************************************************/

// Helpers
/*****************************************************************************/
