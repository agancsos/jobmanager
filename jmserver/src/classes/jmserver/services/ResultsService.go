package services
import (
	"../../common"
	"../models"
	"fmt"
	"strconv"
	"net/http"
	"io/ioutil"
)

// Local service
type ResultsService struct {
	dbs       *DataService
}

var rss *ResultsService;
func GetResultsServiceInstance() IService {
	if rss == nil {
		rss = &ResultsService{};
		rss.dbs = GetDataServiceInstance().(*DataService);
	}
	return rss;
}

func (x *ResultsService) GetResult (a int) *models.Result {
	var result *models.Result;
	var rows = x.dbs.ServiceQuery(fmt.Sprintf("SELECT * FROM RESULT WHERE RESULT_ID = '%d'", a)).Rows();
	if len(rows) > 0 {
		var row = rows[0];
		result = &models.Result{};
		result.SetID(a);
		// result.SetProifle(a *Profile);
		result.SetCode(row.Column("RESULT_CODE").Value());
		var val, _ = strconv.Atoi(row.Column("COMPANY_ID").Value());
		result.SetCompany((GetCompanyServiceInstance()).(*CompanyService).GetCompany(val));
		result.SetLastUpdatedDate(row.Column("LAST_UPDATED_DATE").Value());
		result.SetPostedDate(row.Column("POSTED_DATE").Value());
		val, _ = strconv.Atoi(row.Column("RESULT_APPLIED").Value());
		result.SetApplied(val > 0);
		result.SetTitle(row.Column("RESULT_TITLE").Value());
		result.SetDescription(row.Column("RESULT_DESCRIPTION").Value());
		result.SetRequired(row.Column("RESULT_REQUIRED").Value());
		result.SetOptional(row.Column("RESULT_OPTIONAL").Value());
		result.SetBenefits(row.Column("RESULT_BENEFITS").Value());
		val, _ = strconv.Atoi(row.Column("RESULT_MIN_YEARS_NEEDED").Value());
		result.SetMinYearsNeeded(val);
		result.SetSourceEndpoint(row.Column("RESULT_SOURCE_ENDPOINT").Value());
		val, _ = strconv.Atoi(row.Column("RESULT_STATE").Value());
		result.SetState(val);
	}
	return result;
}

func (x *ResultsService) GetResults(a *models.Profile) []*models.Result {
	var result = []*models.Result{};
	var rows = x.dbs.ServiceQuery(fmt.Sprintf("SELECT RESULT_ID FROM RESULT WHERE PROFILE_ID = '%d'", a.ID())).Rows();
    for _, row := range rows {
        var id, _ = strconv.Atoi(row.Column("RESULT_ID").Value());
        result = append(result, x.GetResult(id));
    }
	return result;
}

func (x *ResultsService) GetResults2(a *models.Company) []*models.Result {
	var result = []*models.Result{};
	var rows = x.dbs.ServiceQuery(fmt.Sprintf("SELECT RESULT_ID FROM RESULT WHERE COMPANY_ID = '%d'", a.ID())).Rows();
	for _, row := range rows {
		var id, _ = strconv.Atoi(row.Column("RESULT_ID").Value());
		result = append(result, x.GetResult(id));
	}
	return result;
}

func (x *ResultsService) AddResult(a *models.Result) bool {
	return x.dbs.RunServiceQuery(fmt.Sprintf(`INSERT INTO RESULT (PROFILE_ID, POSTED_DATE, RESULT_APPLIED, RESULT_TITLE,
		RESULT_DESCRIPTION, RESULT_REQUIRED, RESULT_OPTIONAL, RESULT_BENEFITS, RESULT_OTHERDETAILS, RESULT_MIN_YEARS_NEEDED,
		RESULT_SOURCE_ENDPOINT, RESULT_BASE_ENDPOINT, RESULT_STATE, RESULT_CODE, COMPANY_ID)
		VALUES ('%d','%s','0','%s','%s','%s','%s','%s','%s','%d','%s','%s','%s','%s', '%s', '%d')`,
		a.Profile().ID(), a.PostedDate(), a.Applied(), a.Title(), a.Description(), a.Required(), a.Optional(), a.Benefits(), a.OtherDetails(),
		a.MinYearsNeeded(), a.SourceEndpoint(), "", a.State(), a.Code(), a.Company().ID()));
}

func (x *ResultsService) UpdateResult(a *models.Result) bool {
	return x.dbs.RunServiceQuery(fmt.Sprintf(`UPDATE RESULT SET COMPANY_ID = '%d', PROFILE_ID = '%d',
		POSTED_DATE = '%s', RESULT_TITLE = '%s', RESULT_DESCRIPTION = '%s',
		RESULT_REQUIRED = '%s', RESULT_OPTIONAL = '%s', RESULT_BENEFITS = '%s', RESULT_OTHERDETAILS = '%s',
		RESULT_MIN_YEARS_NEEDED = '%d', RESULT_CODE='%s',RESULT_APPLIED = '%d', RESULT_SOURCE_ENDPOINT = '%s',
		RESULT_BASE_ENDPOINT = '', RESULT_STATE = '%d', LAST_UPDATED_DATE = CURRENT_TIMESTAMP WHERE RESULT_ID = '%d'`,
		a.Company().ID(), a.Profile().ID(), a.PostedDate(), a.Title(), a.Description(), a.Required(),
		a.Optional(), a.Benefits(), a.OtherDetails(), a.MinYearsNeeded(), a.Code(), a.Applied(), a.SourceEndpoint(),
		a.State(), a.ID()));
}

func (x *ResultsService) MarkApplied(a *models.Result) bool {
	a.SetState(models.RS_APPLIED);
	a.SetApplied(true);
	return x.UpdateResult(a);
}

func (x *ResultsService) MarkOffered(a *models.Result) bool {
	a.SetState(models.RS_OFFERED);
	return x.UpdateResult(a);
}

func (x *ResultsService) MarkAccepted(a *models.Result) bool {
	a.SetState(models.RS_ACCEPTED);
	return x.UpdateResult(a);
}

func (x *ResultsService) MarkRead(a *models.Result) bool {
	a.SetState(models.RS_REVIEWED);
	return x.UpdateResult(a);
}

func (x *ResultsService) MarkRejected(a *models.Result) bool {
	a.SetState(models.RS_REJECTED);
	return x.UpdateResult(a);
}

func (x *ResultsService) Initialize() { }
/*****************************************************************************/

// Rest service
type RestResultsService struct {
    lrs       *ResultsService
}
var rrs *RestResultsService;
func GetRestResultsServiceInstance() *RestResultsService {
    if rrs == nil {
        rrs = &RestResultsService{};
        rrs.lrs = GetResultsServiceInstance().(*ResultsService);
    }
    return rrs;
}

func (x *RestResultsService) GetResults(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var data, _ = ioutil.ReadAll(r.Body);
	var dict = common.StrToDictionary(data);
	var method, _ = strconv.Atoi(dict["method"].(string));
	var id, _ = strconv.Atoi(dict["id"].(string));
	var results []*models.Result;
	var result = "\"results\":[";
	switch (method) {
		case 1:
			var profile = &models.Profile{};
			profile.SetID(id);
			results = x.lrs.GetResults(profile);
			break;
		default:
			var company = GetCompanyServiceInstance().(*CompanyService).GetCompany(id);
			results = x.lrs.GetResults2(company);
			break;
	}
	for i, r := range results {
		if i > 0 {
			result += ",";
		}
		result += r.ToJsonString();
	}
	result += "]}";
	w.Write([]byte(result));
}

func (x *RestResultsService) AddResult(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.AddResult(result)))));
}

func (x *RestResultsService) UpdateResult(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.UpdateResult(result)))));
}

func (x *RestResultsService) RemoveResult(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var ds = GetDataServiceInstance().(*DataService);
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(ds.RunServiceQuery(fmt.Sprintf("DELETE FROM RESULT WHERE RESULT_ID = '%d'", result.ID()))))));
}

func (x *RestResultsService) MarkApplied(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.MarkApplied(result)))));
}

func (x *RestResultsService) MarkOffered(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.MarkOffered(result)))));
}

func (x *RestResultsService) MarkAccepted(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.MarkAccepted(result)))));
}

func (x *RestResultsService) MarkRead(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.MarkRead(result)))));
}

func (x *RestResultsService) MarkRejected(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var result = &models.Result{};
    var data, _ = ioutil.ReadAll(r.Body);
    result.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lrs.MarkRejected(result)))));
}

func (x *RestResultsService) Initialize() {
    http.HandleFunc("/api/results/get/", x.GetResults);
    http.HandleFunc("/api/results/add/", x.AddResult);
    http.HandleFunc("/api/results/update/", x.UpdateResult);
    http.HandleFunc("/api/results/remove/", x.RemoveResult);
	http.HandleFunc("/api/results/applied/", x.MarkApplied);
	http.HandleFunc("/api/results/offered/", x.MarkOffered);
	http.HandleFunc("/api/results/accepted/", x.MarkAccepted);
	http.HandleFunc("/api/results/read/", x.MarkRead);
	http.HandleFunc("/api/results/rejected/", x.MarkRejected);
}
/*****************************************************************************/
