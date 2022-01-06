package jmrpc
import (
    common "../common"
    services "../jmserver/services"
    models "../jmserver/models"
    context "context"
	"fmt"
)

// CompanyService
type rpcCompanyServiceServer struct {
	cs        *services.CompanyService
}

func NewRpcCompanyServiceServer() *rpcCompanyServiceServer {
	var result = &rpcCompanyServiceServer{};
	result.cs = services.GetCompanyServiceInstance().(*services.CompanyService);
	return result;
}

func (x *rpcCompanyServiceServer) GetCompanies(c context.Context, m *EmptyMessage) (*JsonMessage, error) {
	var companies = x.cs.GetCompanies();
	var result = "{\"companies\":[";
	for i, company := range companies {
		if i > 0 { result += ","; }
		result += company.ToJsonString();
	}
	result += "]}";
	return &JsonMessage{Json: common.StrToStrPtr(result)}, nil;
}
func (x *rpcCompanyServiceServer) AddCompany(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var company = &models.Company{};
    company.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.cs.AddCompany(company))}, nil;
}
func (x *rpcCompanyServiceServer) UpdateCompany(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var company = &models.Company{};
    company.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.cs.UpdateCompany(company))}, nil;
}
func (x *rpcCompanyServiceServer) HasCompany(c context.Context, m *StringMessage) (*BooleanMessage, error) {
	var name = *m.Value;
	return &BooleanMessage {Status: common.BoolToBoolPtr(x.cs.HasCompany(name))}, nil;
}
func (x *rpcCompanyServiceServer) RemoveCompany(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var company = &models.Company{};
	company.ReloadFromJson(*m.Json);
	var dbs = services.GetDataServiceInstance().(*services.DataService);
	dbs.RunServiceQuery(fmt.Sprintf("DELETE FROM RESULT WHERE COMPANY_ID = '%d'", company.ID()));
	return &BooleanMessage {Status: common.BoolToBoolPtr(dbs.RunServiceQuery(fmt.Sprintf("DELETE FROM COMPANY WHERE COMPANY_ID = '%d'", company.ID())))}, nil;
}
func (x *rpcCompanyServiceServer) mustEmbedUnimplementedCompanyServiceServer() {}
/*****************************************************************************/

// ResultsService
type rpcRsultsServiceServer struct {
	rs       *services.ResultsService
}

func NewRpcResultsServiceServer() *rpcRsultsServiceServer {
	var result = &rpcRsultsServiceServer{};
	result.rs = services.GetResultsServiceInstance().(*services.ResultsService);
	return result;
}

func (x *rpcRsultsServiceServer) GetResults(c context.Context, m *GetResultsMessage) (*JsonMessage, error) {
	var results []*models.Result;
	if *m.Method == 1 {
		var profile = &models.Profile{};
		profile.SetID(int(*m.Id));
		results = x.rs.GetResults(profile);
	} else {
		var company = services.GetCompanyServiceInstance().(*services.CompanyService).GetCompany(int(*m.Id));
		results = x.rs.GetResults2(company);
	}
    var result = "{\"results\":[";
    for i, cursor := range results {
        if i > 0 { result += ","; }
        result += cursor.ToJsonString();
    }
    result += "]}";
    return &JsonMessage{Json: common.StrToStrPtr(result)}, nil;
}
func (x *rpcRsultsServiceServer) AddResult(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.AddResult(result))}, nil;
}
func (x *rpcRsultsServiceServer) UpdateResult(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.UpdateResult(result))}, nil;
}
func (x *rpcRsultsServiceServer) RemoveResult(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    var dbs = services.GetDataServiceInstance().(*services.DataService);
    return &BooleanMessage {Status: common.BoolToBoolPtr(dbs.RunServiceQuery(fmt.Sprintf("DELETE FROM RESULT WHERE RESULT_ID = '%d'", result.ID())))}, nil;
}
func (x *rpcRsultsServiceServer) MarkApplied(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.MarkApplied(result))}, nil;
}
func (x *rpcRsultsServiceServer) MarkOffered(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.MarkOffered(result))}, nil;
}
func (x *rpcRsultsServiceServer) MarkAccepted(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.MarkAccepted(result))}, nil;
}
func (x *rpcRsultsServiceServer) MarkRead(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.MarkRead(result))}, nil;
}
func (x *rpcRsultsServiceServer) MarkRejected(c context.Context, m *JsonMessage) (*BooleanMessage, error) {
	var result = &models.Result{};
    result.ReloadFromJson(*m.Json);
    return &BooleanMessage {Status: common.BoolToBoolPtr(x.rs.MarkRejected(result))}, nil;
}
func (x *rpcRsultsServiceServer) mustEmbedUnimplementedResultsServiceServer() {}
/*****************************************************************************/

