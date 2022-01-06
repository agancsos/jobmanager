package models
import (
	"../../common"
	"fmt"
	"strings"
	"strconv"
)

type Filter struct {
	keywords	   []string	 `json:keywords`
	location	   string	 `json:location`
	compensation   float32	 `json:compensation`
	distance	   float32	 `json:distance`
	jobType		   []int	 `json:jobType`
	tech		   []string	 `json:tech`
}

func (x *Filter) ReloadFromJson(json string) {
	var dict = common.StrToDictionary([]byte(json));
	x.keywords = dict["keywords"].([]string);
	x.location = dict["location"].(string);
	var val, _ = strconv.ParseFloat(dict["compensation"].(string), 32);
	x.compensation = float32(val);
	val, _ = strconv.ParseFloat(dict["distance"].(string), 32);
	x.distance = float32(val);
	x.tech = dict["tech"].([]string);
}

func (x *Filter) ToJsonString() string {
	var result = "{";
	result += fmt.Sprintf("\"keywords\":\"%s\"", strings.Join(x.keywords, ";"));
	result += fmt.Sprintf(",\"location\":\"%s\"", x.location);
	result += fmt.Sprintf(",\"compensation\":\"%v\"", x.compensation);
	result += fmt.Sprintf(",\"distance\":\"%v\"", x.distance);
	var jobTypes = "";
	for i, t := range x.jobType {
		if i > 0 {
		   jobTypes += ";";
		}
		jobTypes += fmt.Sprintf("%v", t);
		i += 1;
	}
	result += fmt.Sprintf(",\"jobType\":\"%v\"", jobTypes);
	result += fmt.Sprintf(",\"tech\":\"%s\"", strings.Join(x.tech, ";"));
	result += "}";
	return result;
}

func (x *Filter) AddKeyword(a string) {
	if x.keywords == nil { x.keywords = []string {}; }
	x.keywords = append(x.keywords, a);
}

func (x *Filter) SetLocation (a string) { x.location = a; }
func (x *Filter) SetCompensation (a float32) { x.compensation = a; }
func (x *Filter) SetDistance (a float32) { x.distance = a; }
func (x *Filter) AddJobType (a int) {
	if x.jobType == nil { x.jobType = []int {}; };
	x.jobType = append(x.jobType, a);
}
func (x *Filter) AddTech (a string) {
	if x.tech == nil { x.tech = []string {}; }
	x.tech = append(x.tech, a);
}
func (x Filter) Keywords() ([]string) { return x.keywords; }
func (x Filter) Location() (string) { return x.location; }
func (x Filter) Compensation() (float32) { return x.compensation; }
func (x Filter) Distance() (float32) { return x.distance; }
func (x Filter) JobType() ([]int) { return x.jobType; }
func (x Filter) Tech() ([]string) { return x.tech; }

