package models
import (
	"../../common"
	"fmt"
	"strconv"
)

type Result struct {
	id              int            `json:id`
    profile         *Profile       `json:profile`
    code            string         `json:code`
    company         *Company       `json:company`
    lastUpdatedDate string         `json:lastUpdatedDate`
    postedDate      string         `json:postedDate`
    applied         bool           `json:applied`
    title           string         `json:title`
    description     string         `json:description`
    required        string         `json:required`
    optional        string         `json:optional`
    benefits        string         `json:benefits`
    otherDetails    string         `json:otherDetails`
    minYearsNeeded  int            `json:minYearsNeeded`
    sourceEndpoint  string         `json:sourceEndpoing`
    state           int            `json:state`
}

func (x *Result) ReloadFromJson(json string) {
    var dict = common.StrToDictionary([]byte(json));
    x.id, _ = strconv.Atoi(dict["id"].(string));
    x.profile = &Profile{};
	x.profile.ReloadFromJson(common.DictionaryToJsonString(dict["name"].(map[string]interface{})));
    x.code = dict["code"].(string);
    x.company = &Company{};
	x.company.ReloadFromJson(common.DictionaryToJsonString(dict["city"].(map[string]interface{})));
    x.lastUpdatedDate = dict["lastUpdatedDate"].(string);
    x.postedDate = dict["postedDate"].(string);
    var val, _ = strconv.Atoi(dict["applied"].(string));
	x.applied = val > 0;
    x.title = dict["title"].(string);
    x.description = dict["description"].(string);
    x.required = dict["required"].(string);
    x.optional = dict["optional"].(string);
    x.benefits = dict["benefits"].(string);
    x.otherDetails = dict["otherDetails"].(string);
	x.minYearsNeeded, _ = strconv.Atoi(dict["minYearsNeeded"].(string));
	x.sourceEndpoint = dict["sourceEndpoing"].(string);
	x.state, _ = strconv.Atoi(dict["state"].(string));
}

func (x *Result) ToJsonString() string {
    var result = "{";
    result += fmt.Sprintf("\"id\":\"%d\"", x.id);
    result += fmt.Sprintf(",\"profile\":%s", x.profile.ToJsonString());
    result += fmt.Sprintf(",\"code\":\"%s\"", x.code);
    result += fmt.Sprintf(",\"company\":%s", x.company.ToJsonString());
    result += fmt.Sprintf(",\"lastUpdatedDate\":\"%s\"", x.lastUpdatedDate);
    result += fmt.Sprintf(",\"postedDate\":\"%s\"", x.postedDate);
    result += fmt.Sprintf(",\"applied\":\"%d\"", x.applied);
    result += fmt.Sprintf(",\"title\":\"%s\"", x.title);
    result += fmt.Sprintf(",\"description\":\"%s\"", x.description);
    result += fmt.Sprintf(",\"required\":\"%s\"", x.required);
    result += fmt.Sprintf(",\"optional\":\"%s\"", x.optional);
    result += fmt.Sprintf(",\"benefits\":\"%s\"", x.benefits);
    result += fmt.Sprintf(",\"otherDetails\":\"%s\"", x.otherDetails);
	result += fmt.Sprintf(",\"minYearsNeeded\":\"%d\"", x.minYearsNeeded);
	result += fmt.Sprintf(",\"sourceEndpoint\":\"%s\"", x.sourceEndpoint);
	result += fmt.Sprintf(",\"state\":\"%d\"", x.state);
    result += "}";
    return result;
}
func (x *Result) SetID (a int) { x.id = a; }
func (x *Result) SetProifle (a *Profile) { x.profile = a; }
func (x *Result) SetCode (a string) { x.code = a; }
func (x *Result) SetCompany (a *Company) {x.company = a; }
func (x *Result) SetLastUpdatedDate (a string) { x.lastUpdatedDate = a; }
func (x *Result) SetPostedDate (a string) { x.postedDate = a; }
func (x *Result) SetApplied (a bool) { x.applied = a; }
func (x *Result) SetTitle (a string) { x.title = a; }
func (x *Result) SetDescription (a string) { x.description = a; }
func (x *Result) SetRequired (a string) { x.required = a; }
func (x *Result) SetOptional (a string) { x.optional = a; }
func (x *Result) SetBenefits (a string) { x.benefits = a; }
func (x *Result) SetMinYearsNeeded (a int) { x.minYearsNeeded = a; }
func (x *Result) SetSourceEndpoint (a string) { x.sourceEndpoint = a; }
func (x *Result) SetState (a int) { x.state = a; }
func (x Result) ID() (int) { return x.id; }
func (x Result) Profile() (*Profile) { return x.profile; }
func (x Result) Code() (string) { return x.code; }
func (x Result) Company() (*Company) { return x.company; }
func (x Result) LastUpdatedDate() (string) { return x.lastUpdatedDate; }
func (x Result) PostedDate() (string) { return x.postedDate; }
func (x Result) Applied() (bool) { return x.applied; }
func (x Result) Title() (string) { return x.title; }
func (x Result) Description() (string) { return x.description; }
func (x Result) Required() (string) { return x.required; }
func (x Result) Optional() (string) { return x.optional; }
func (x Result) Benefits() (string) { return x.benefits; }
func (x Result) OtherDetails() (string) { return x.otherDetails; }
func (x Result) MinYearsNeeded() (int) { return x.minYearsNeeded; }
func (x Result) SourceEndpoint() (string) { return x.sourceEndpoint; }
func (x Result) State() (int) { return x.state; }

